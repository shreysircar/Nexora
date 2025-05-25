const { DataTypes } = require('sequelize');
const sequelize = require('../config/db');

const Post = sequelize.define('Post', {
  caption: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  imageUrl: {
    type: DataTypes.STRING,
    allowNull: true, // we'll upload images later
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false,
  }
});

module.exports = Post;
