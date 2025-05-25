const express = require('express');
const router = express.Router();
const authMiddleware = require('../middlewares/authMiddleware');
const upload = require('../middlewares/upload');
const { createPost, getAllPosts } = require('../controllers/postController');

// Create post (protected)
router.post('/', authMiddleware, upload.single('image'), createPost);


// Get all posts (protected)
router.get('/', authMiddleware, getAllPosts);


module.exports = router;
