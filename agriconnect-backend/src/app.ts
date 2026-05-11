import express from 'express';
import cors from 'cors';
import authRoutes from './presentation/routes/authRoutes';

const app = express();

// Security and Data middlewares
app.use(cors());
app.use(express.json());

// Register API Routes
app.use('/api/auth', authRoutes);

// Simple Health Check
app.get('/', (req, res) => {
  res.send('AgriConnect API is up and running! 🚀');
});

export default app;