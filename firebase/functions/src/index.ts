import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { DocumentReference } from '@google-cloud/firestore';

admin.initializeApp();
admin.firestore().settings({ timestampsInSnapshots: true });

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
export const sendNotifications = functions.https.onRequest(async (request, response) => {

    const plants = await admin.firestore().collection('plants').get();

    const notificationPromises = await plants.docs
        .filter((plant) => {
            const lastWatered: Date = plant.get('last watered').toDate()
            const nextWatering = new Date()
            nextWatering.setTime(lastWatered.getTime() + plant.get('watering frequency') * 24 * 60 * 60 * 1000)
            return !plant.get('notification sent') && nextWatering <= new Date(Date.now())
        })
        .map(async plant => {
            const house = await admin.firestore().collection('houses').doc(plant.get('house id')).get()
            const users: DocumentReference[] = house.get('users')
            const tokenPromises = users.map(async userRef => {
                const user = await userRef.get()
                return user.get('fcm_token') as string
            })
            const tokensWithNulls = await Promise.all(tokenPromises)
            const tokens = tokensWithNulls.filter(token => token !== undefined && token !== null)
            const notification = {
                tokens: tokens,
                plant: plant,
                payload: {
                    notification: {
                        title: 'Time to water your plants!',
                        body: `${plant.get('name')} is dying to get some water`
                    },
                    data: {
                        click_action: 'FLUTTER_NOTIFICATION_CLICK'
                    }
                }
            }

            return notification
        }, Promise.resolve([]))

    const notifications = await Promise.all(notificationPromises)

    console.log(notifications)

    const fcmResponsePromises = notifications.map(notification => {
        return admin.messaging().sendToDevice(notification.tokens, notification.payload)
    })
    const fcmResponses = await Promise.all(fcmResponsePromises)

    const tasksToComplete: Promise<any>[] = [];
    fcmResponses.forEach((fcmResponse, notificationIndex) => {
        fcmResponse.results.forEach((result, tokenIndex) => {
            const error = result.error;
            if (error) {
                const token = notifications[notificationIndex].tokens[tokenIndex]
                console.error('Failure sending notification to', token, error);

                // Cleanup the tokens that are not registered anymore
                if (error.code === 'messaging/invalid-registration-token' ||
                    error.code === 'messaging/registration-token-not-registered') {
                    tasksToComplete.push(
                        admin.firestore()
                            .collection('users')
                            .where('fcm_token', '==', token)
                            .get()
                            .then(query => query.forEach(snapshot => snapshot.ref.update({ 'fcm_token': null })))
                    );
                }
            } else {
                console.log("Successfully sent message: " + result);

                tasksToComplete.push(
                    notifications[notificationIndex].plant.ref.update({
                        'notification sent': true
                    })
                );
            }
        })
    })
    return Promise.all(tasksToComplete)
        .then(() => response.status(200).send('ok'))
        .catch(reason => {
            console.error('Failure deleting unused push tokens')
            response.status(500).send('fail')
        })
});
