const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const firestore = admin.firestore();

exports.followingNotify = functions.firestore
    .document('users/{userId}')
    .onUpdate((change, context) => {
        const previousValue = change.before.data()
        const nextValue = change.after.data()
        if(previousValue.followers !== nextValue.followers) {
            const newFollowing = nextValue.followers.filter(eachOne => !previousValue.followers.includes(eachOne))
            firestore.collection('notifications').add({
                uid: context.params.userId,
                message: `You have a new follower`,
                createdDate: new Date(),
                ref: 'following',
                isRead: false
            }).then((snapshot) => {
                console.log('ok')
            })
        } else {
            console.log('ok')
        }
    });

exports.favoriteNotify = functions.firestore
    .document('posts/{postId}')
    .onUpdate((change, context) => {
        const previousValue = change.before.data()
        const nextValue = change.after.data()
        if(previousValue.uidFavorite !== nextValue.uidFavorite) {
            const newFavorite = nextValue.uidFavorite.filter(eachOne => !previousValue.uidFavorite.includes(eachOne))
            firestore.collection('notifications').add({
                uid: nextValue.createdBy,
                message: `You have a new favorite`,
                createdDate: new Date(),
                ref: 'favorite',
                isRead: false
            }).then((snapshot) => {
                console.log('ok')
            })
        } else {
            console.log('ok')
        }
    })