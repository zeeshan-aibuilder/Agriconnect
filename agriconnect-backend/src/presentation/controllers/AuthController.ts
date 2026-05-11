import { Request, Response } from 'express';
import { AuthUseCase } from '../../application/use-cases/AuthUseCase';

export class AuthController {
  constructor(private authUseCase: AuthUseCase) {}

  requestOtp = async (req: Request, res: Response): Promise<void> => {
    try {
      const { phone } = req.body;
      if (!phone) {
        res.status(400).json({ error: 'Phone number is required' });
        return;
      }
      const result = await this.authUseCase.requestLogin(phone);
      res.status(200).json(result);
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  };

  verifyOtp = async (req: Request, res: Response): Promise<void> => {
    try {
      const { phone, otp, name, role_id } = req.body;
      if (!phone || !otp) {
        res.status(400).json({ error: 'Phone and OTP are required' });
        return;
      }
      const result = await this.authUseCase.verifyOtpAndLogin(phone, otp, name, role_id);
      res.status(200).json(result);
    } catch (error: any) {
      res.status(401).json({ error: error.message });
    }
  };
}