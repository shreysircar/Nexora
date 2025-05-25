const sequelize = require('../config/db');
const User = require('./user');
const Post = require('./post'); // ⬅️ new
const Like = require('./like');
const Comment = require('./comment');


const connectDB = async () => {
  try {
    await sequelize.authenticate();
    console.log('Database connected');
    await sequelize.sync({ alter: true }); // sync all models
  } catch (err) {
    console.error('Unable to connect:', err);
  }
};

// 🧩 Define relationships
User.hasMany(Post, { foreignKey: 'userId' });
Post.belongsTo(User, { foreignKey: 'userId' });

User.hasMany(Like, { foreignKey: 'userId' });
Like.belongsTo(User, { foreignKey: 'userId' });

Post.hasMany(Like, { foreignKey: 'postId' });
Like.belongsTo(Post, { foreignKey: 'postId' });

User.hasMany(Comment, { foreignKey: 'userId' });
Comment.belongsTo(User, { foreignKey: 'userId' });

Post.hasMany(Comment, { foreignKey: 'postId' });
Comment.belongsTo(Post, { foreignKey: 'postId' });

module.exports = { connectDB, sequelize, User, Post, Like, Comment };