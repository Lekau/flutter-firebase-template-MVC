import * as functions from 'firebase-functions';
import { db } from '../utils/admin';

export const onUserCreated = functions.auth.user().onCreate(async (user) => {
  try {
    const userProfile = {
      email: user.email,
      createdAt: new Date(),
      displayName: user.displayName || null,
      photoURL: user.photoURL || null,
      role: 'user',
    };

    await db.collection('users').doc(user.uid).set(userProfile);
    
    // Create default user settings
    await db.collection('userSettings').doc(user.uid).set({
      notifications: true,
      theme: 'light',
    });

  } catch (error) {
    console.error('Error in onUserCreated:', error);
    throw error;
  }
}); 