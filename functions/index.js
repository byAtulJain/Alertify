//const functions = require('firebase-functions');
//const admin = require('firebase-admin');
//admin.initializeApp();
//
//exports.sendNotificationToAllUsers = functions.firestore
//    .document('cards/{cardId}')
//    .onCreate(async (snap, context) => {
//      const newValue = snap.data();
//
//      const payload = {
//        notification: {
//          title: newValue.title,
//          body: newValue.content,
//        }
//      };
//
//      const deviceTokensSnapshot = await admin.firestore().collection('deviceToken').get();
//      const tokens = deviceTokensSnapshot.docs.map(doc => doc.id);
//
//      // Send notification to each device one by one
//      for (const token of tokens) {
//        try {
//          await admin.messaging().sendToDevice(token, payload);
//        } catch (error) {
//          console.error(`Failed to send notification to ${token}`, error);
//        }
//      }
//    });


// Import the Firebase Admin SDK
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Define the Cloud Function
exports.sendNotification = functions.https.onRequest((request, response) => {
  // Notification payload
  const payload = {
    notification: {
      title: 'Notification Title',
      body: 'Notification Body',
    },
  };

  // Send notification to device
  admin.messaging().sendToDevice('cB6FaqpmQ_m8Aqucop0lWc:APA91bHzM2QeTAYbhxhLzDBFh-43GrZDjSQfm5H4z-odEXTVOIRhFUE0RZO6hqce6Y9zryKbW5bhDsXZbnuy6VnXuVg3f6jeqewSPvtlPacXH7fjZCKLp3JKYnWbHKyDvuOVTzm9-8kS', payload)
    .then((response) => {
      console.log('Notification sent successfully:', response);
      response.send('Notification sent successfully');
    })
    .catch((error) => {
      console.error('Error sending notification:', error);
      response.status(500).send('Error sending notification');
    });
});
