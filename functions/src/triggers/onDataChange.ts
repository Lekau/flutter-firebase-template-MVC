import * as functions from 'firebase-functions';
import { db } from '../utils/admin';

// Example: Trigger when a document is created in 'posts' collection
export const onPostCreated = functions.firestore
  .document('posts/{postId}')
  .onCreate(async (snap, context) => {
    const postId = context.params.postId;
    const postData = snap.data();

    try {
      // Example: Update user's post count
      await db.collection('users').doc(postData.userId).update({
        postCount: admin.firestore.FieldValue.increment(1)
      });

      // Example: Create notification
      await db.collection('notifications').add({
        userId: postData.userId,
        type: 'new_post',
        postId: postId,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    } catch (error) {
      console.error('Error in onPostCreated:', error);
      throw error;
    }
});

// Example: Trigger when a document is updated
export const onUserUpdated = functions.firestore
  .document('users/{userId}')
  .onUpdate(async (change, context) => {
    const newData = change.after.data();
    const previousData = change.before.data();
    const userId = context.params.userId;

    // Only run if displayName changed
    if (newData.displayName === previousData.displayName) {
      return null;
    }

    try {
      // First get all posts by this user
      const userPosts = await db.collection('posts')
        .where('userId', '==', userId)
        .get();

      // Create a batch operation
      const batch = db.batch();
      
      // Add each post update to the batch
      userPosts.docs.forEach((doc) => {
        batch.update(doc.ref, { 
          authorName: newData.displayName 
        });
      });

      // Execute all updates in a single atomic operation
      await batch.commit();
    } catch (error) {
      console.error('Error in onUserUpdated:', error);
      throw error;
    }
}); 