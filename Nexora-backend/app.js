const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
const likeRoutes = require('./routes/like');
const commentRoutes = require('./routes/comment');

app.use(cors());
app.use(express.json());

app.use('/api/auth', require('./routes/auth'));
app.use('/api/posts', require('./routes/post'));
app.use('/uploads', express.static('uploads'));
app.use('/api/likes', likeRoutes);
app.use('/api/comments', commentRoutes);


module.exports = app;
