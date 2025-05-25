const express = require('express');
const router = express.Router();
const authMiddleware = require('../middlewares/authMiddleware');
const { addComment, getComments, deleteComment } = require('../controllers/commentController');

// Add comment to a post (protected)
router.post('/:postId', authMiddleware, addComment);

// Get all comments for a post (public)
router.get('/:postId', getComments);

// Delete own comment (protected)
router.delete('/:commentId', authMiddleware, deleteComment);

module.exports = router;
