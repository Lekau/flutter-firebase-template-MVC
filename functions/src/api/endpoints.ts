import * as functions from 'firebase-functions';
import { db, auth } from '../utils/admin';

// Example: HTTP callable function for user operations
export const updateUserProfile = functions.https.onCall(async (data, context) => {
  // Check if user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be authenticated'
    );
  }

  const uid = context.auth.uid;
  const { displayName, bio } = data;

  try {
    // Update auth profile
    await auth.updateUser(uid, { displayName });

    // Update Firestore profile
    await db.collection('users').doc(uid).update({
      displayName,
      bio,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { success: true };
  } catch (error) {
    throw new functions.https.HttpsError('internal', 'Profile update failed');
  }
});

// Example: HTTP endpoint (REST API)
export const getPublicPosts = functions.https.onRequest(async (req, res) => {
  try {
    // Example: Pagination parameters
    const limit = parseInt(req.query.limit as string) || 10;
    const startAfter = req.query.startAfter as string;

    let query = db.collection('posts')
      .where('isPublic', '==', true)
      .orderBy('createdAt', 'desc')
      .limit(limit);

    // Add pagination if startAfter is provided
    if (startAfter) {
      const startAfterDoc = await db.collection('posts').doc(startAfter).get();
      query = query.startAfter(startAfterDoc);
    }

    const snapshot = await query.get();
    const posts = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    }));

    res.json({
      posts,
      lastDoc: posts.length > 0 ? posts[posts.length - 1].id : null
    });
  } catch (error) {
    console.error('Error in getPublicPosts:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
}); 