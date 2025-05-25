const { Post } = require('../models');
const { User } = require('../models');

exports.createPost = async (req, res) => {
  try {
    const { caption } = req.body;
    const userId = req.user.id;
   const imageUrl = req.file ? `${req.protocol}://${req.get('host')}/uploads/${req.file.filename}` : null;


    const newPost = await Post.create({
      caption,
      imageUrl,
      userId,
    });

    res.status(201).json(newPost);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Post creation failed' });
  }
};


exports.getAllPosts = async (req, res) => {
  try {
    const posts = await Post.findAll({
      order: [['createdAt', 'DESC']],
      include: [
        {
          model: User,
          attributes: ['id', 'username', 'email'],
        },
      ],
    });

    res.json(posts);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch posts' });
  }
};
