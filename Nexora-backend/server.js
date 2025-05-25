const app = require('./app');
const { connectDB } = require('./models');

const PORT = process.env.PORT || 5000;

connectDB().then(() => {
  app.listen(PORT,'0.0.0.0', () => console.log(`Server running on port ${PORT}`));
});
