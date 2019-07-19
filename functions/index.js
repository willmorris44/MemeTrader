const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp();

// Listen for updates to any `user` document.
exports.listenForVotes = functions.firestore
    .document('memes/{memeUID}')
    .onUpdate((change, context) => {
      // Retrieve the current and previous value
      const data = change.after.data();
      const previousData = change.before.data();

      // We'll only update if the name has changed.
      // This is crucial to prevent infinite loops.
      if (data.upvotes === previousData.upvotes && data.downvotes === previousData.downvotes) return null;

      const previousVoteDif = previousData.upvotes - previousData.downvotes;
      const voteDif = data.upvotes - data.downvotes;

      const voteChange = voteDif - previousVoteDif;
      console.log(voteChange);
      const timeStamp = admin.firestore.Timestamp.now().toDate();
      console.log(timeStamp);
      const currentTime = new Date(timeStamp);
      console.log(currentTime);
      const oldTime = data.date.toDate();
      console.log(oldTime);

      const time = currentTime.getTime() - oldTime.getTime();
      console.log(time);
      const changeOfTime = Math.round(time / 1000 / 60 / 30);
      console.log(changeOfTime);

      const rateOfChange = voteChange / changeOfTime;
      console.log(rateOfChange);

      // Then return a promise of a set operation to update the count
      return change.after.ref.update({
        rateOfVotes: Number(rateOfChange.toFixed(2))
      });
    });

    exports.documentWriteListener = functions.firestore
    .document('users/{userUID}')
    .onWrite((change, context) => {

    const db = admin.firestore().collection('users');

    if (!change.before.exists) {
        // New document Created : add one to count
        db.doc('numberOfUsers').update({numberOfDocs: admin.firestore.FieldValue.increment(1)});

    } else if (change.before.exists && change.after.exists) {
        // Updating existing document : Do nothing

    } else if (!change.after.exists) {
        // Deleting document : subtract one from count
        db.doc('numberOfUsers').update({numberOfDocs: admin.firestore.FieldValue.increment(-1)});
    }

    return null;
});

exports.calcStockValue = functions.firestore
    .document('memes/{memeUID}')
    .onUpdate((change, context) => {
        const data = change.after.data();
        const previousData = change.before.data();

        if (data.upvotes === previousData.upvotes && data.downvotes === previousData.downvotes) return null;

        return admin.firestore()
        .collection('users')
        .doc('numberOfUsers')
        .get()
        .then(doc => {
            console.log('Got rule: ' + doc.data().numberOfDocs);
            const users = doc.data().numberOfDocs;
            const votes = data.upvotes - data.downvotes;
            const newValue = (((200 * (votes * votes)) + users) / ((votes * votes) + (users * users))) + 5;
            return change.after.ref.update({
                value: Number(newValue.toFixed(2))
            });
        });
    });
