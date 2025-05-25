const { Like } = require('../models');

exports.toggleLike = async (req, res) => {
  try {
    const userId = req.user.id;
    const postId = req.params.postId;

    const existingLike = await Like.findOne({ where: { userId, postId } });

    if (existingLike) {
      // Unlike
      await existingLike.destroy();
      return res.json({ message: 'Post unliked' });
    } else {
      // Like
      await Like.create({ userId, postId });
      return res.json({ message: 'Post liked' });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to toggle like' });
  }
};

exports.getLikesCount = async (req, res) => {
  try {
    const postId = req.params.postId;
    const count = await Like.count({ where: { postId } });
    res.json({ postId, likes: count });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to get likes count' });
  }
};

exports.userLikedPost = async (req, res) => {
  try {
    const userId = req.user.id;
    const postId = req.params.postId;

    const liked = await Like.findOne({ where: { userId, postId } });
    res.json({ liked: !!liked });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to check like status' });
  }
};
