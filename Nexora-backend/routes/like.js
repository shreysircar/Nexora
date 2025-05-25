const express = require('express');
const router = express.Router();
const authMiddleware = require('../middlewares/authMiddleware');
const { toggleLike, getLikesCount, userLikedPost } = require('../controllers/likeController');

// Toggle like/unlike
router.post('/:postId/toggle', authMiddleware, toggleLike);

// Get like count for a post
router.get('/:postId/count', getLikesCount);

// Check if current user liked a post
router.get('/:postId/status', authMiddleware, userLikedPost);

module.exports = router;
