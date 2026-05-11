import { IUserRepository } from '../../domain/interfaces/IUserRepository';
import { User } from '../../domain/entities/User';
import { JwtService } from '../../infrastructure/security/JwtService';
import { OtpService } from '../../infrastructure/security/OtpService';
import { v4 as uuidv4 } from 'uuid';

export class AuthUseCase {
  // 🔥 INDUSTRY STANDARD: Storing OTP with Expiry Time
  private otpStore = new Map<string, { otp: string, expiresAt: number }>();

  constructor(
    private userRepository: IUserRepository,
    private jwtService: JwtService,
    private otpService: OtpService
  ) {}

  async requestLogin(phone: string) {
    const otp = this.otpService.generateOtp();
    
    // OTP will expire in 5 minutes (300,000 milliseconds)
    const expiresAt = Date.now() + 5 * 60 * 1000;
    
    // Har number ki apni alag entry (Concurrent safe)
    this.otpStore.set(phone, { otp, expiresAt }); 
    
    try {
      await this.otpService.sendOtpSms(phone, otp);
      console.log(`[SYSTEM] OTP stored securely for ${phone}`);
    } catch (e) {
      console.error(`[ERROR] Failed to send OTP to ${phone}:`, e);
      throw new Error("Service temporarily unavailable.");
    }
    
    return { message: "OTP sent successfully." };
  }

  async verifyOtpAndLogin(phone: string, otp: string, name?: string, role_id?: string) {
    const record = this.otpStore.get(phone);
    
    // MASTER OTP for emergency bypass / examiner testing
    const isMasterOtp = otp === '1234';

    if (!isMasterOtp) {
      if (!record) {
        throw new Error('OTP not found. Please request a new one.');
      }
      if (Date.now() > record.expiresAt) {
        this.otpStore.delete(phone); // Memory cleanup
        throw new Error('OTP has expired! Please request again.');
      }
      if (record.otp !== otp) {
        throw new Error('Invalid OTP! Try again.');
      }
    }

    // Processing the login after successful match
    let user = await this.userRepository.findByPhone(phone);

    if (!user) {
      if (!name || !role_id) {
        throw new Error('New user requires name and role selection.');
      }
      const newUserId = uuidv4();
      const newUser = new User(newUserId, phone, name, role_id, new Date());
      
      user = await (this.userRepository as any).create(newUser);
    }

    // Cleanup to prevent replay attacks
    this.otpStore.delete(phone); 

    if (!user) throw new Error("System error: Could not load user details.");

    const token = this.jwtService.generateToken({
      id: user.id,
      phone: user.phone,
      role_id: user.role_id
    });

    return { user, token };
  }
}