const { Comment, User } = require('../models');

exports.addComment = async (req, res) => {
  try {
    const userId = req.user.id;
    const postId = req.params.postId;
    const { content } = req.body;

    if (!content) return res.status(400).json({ error: 'Comment content required' });

    const comment = await Comment.create({ userId, postId, content });
    res.status(201).json(comment);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to add comment' });
  }
};

exports.getComments = async (req, res) => {
  try {
    const postId = req.params.postId;
    const comments = await Comment.findAll({
      where: { postId },
      include: {
        model: User,
        attributes: ['id', 'username'],
      },
      order: [['createdAt', 'DESC']],
    });
    res.json(comments);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to get comments' });
  }
};

exports.deleteComment = async (req, res) => {
  try {
    const userId = req.user.id;
    const commentId = req.params.commentId;

    const comment = await Comment.findOne({ where: { id: commentId, userId } });
    if (!comment) return res.status(404).json({ error: 'Comment not found or unauthorized' });

    await comment.destroy();
    res.json({ message: 'Comment deleted' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to delete comment' });
  }
};
