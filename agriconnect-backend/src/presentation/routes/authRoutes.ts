import { Router } from 'express';
import { AuthController } from '../controllers/AuthController';
import { AuthUseCase } from '../../application/use-cases/AuthUseCase';
import { UserRepositoryImpl } from '../../infrastructure/repositories/UserRepositoryImpl';
import { JwtService } from '../../infrastructure/security/JwtService';
import { OtpService } from '../../infrastructure/security/OtpService';

// Dependency Injection (Building the brain)
const userRepository = new UserRepositoryImpl();
const jwtService = new JwtService();
const otpService = new OtpService();
const authUseCase = new AuthUseCase(userRepository, jwtService, otpService);
const authController = new AuthController(authUseCase);

const router = Router();

// Routes for Flutter app
router.post('/request-otp', authController.requestOtp);
router.post('/verify-otp', authController.verifyOtp);

export default router;