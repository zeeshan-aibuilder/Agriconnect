import { WhatsAppService } from './WhatsAppService';

export class OtpService {
  private whatsappService: WhatsAppService;

  constructor() {
    // Service start hote hi WhatsApp bot zinda ho jayega
    this.whatsappService = new WhatsAppService();
  }

  generateOtp(): string {
    // 4-digit ka random code
    return Math.floor(1000 + Math.random() * 9000).toString();
  }

  async sendOtpSms(phone: string, otp: string): Promise<void> {
    // Ab yeh SMS ki jagah real WhatsApp message bhejega
    await this.whatsappService.sendOtpMessage(phone, otp);
  }
}