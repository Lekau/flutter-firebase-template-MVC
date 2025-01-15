import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

// Import all functions
import { onUserCreated } from './auth/onUserCreated';
import { onPostCreated, onUserUpdated } from './triggers/onDataChange';
import { updateUserProfile, getPublicPosts } from './api/endpoints';

// Export functions
export {
  // Auth triggers
  onUserCreated,
  
  // Database triggers
  onPostCreated,
  onUserUpdated,
  
  // API endpoints
  updateUserProfile,
  getPublicPosts,
}; 