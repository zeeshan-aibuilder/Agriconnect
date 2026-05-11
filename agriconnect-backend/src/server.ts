import app from './app';

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`\n===========================================`);
  console.log(`🚀 AgriConnect Server running on port ${PORT}`);
  console.log(`===========================================\n`);
});
