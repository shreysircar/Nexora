const express = require('express');
const router = express.Router();
const { register, login } = require('../controllers/authController');
const authMiddleware = require('../middlewares/authMiddleware');

// Auth routes
router.post('/register', register);
router.post('/login', login);

// Protected route
router.get('/profile', authMiddleware, (req, res) => {
  res.json({ msg: 'Welcome to your profile!', user: req.user });
});

module.exports = router;
