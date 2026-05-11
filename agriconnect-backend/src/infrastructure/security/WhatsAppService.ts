import { Client, LocalAuth } from 'whatsapp-web.js';
import * as qrcode from 'qrcode-terminal';

export class WhatsAppService {
  private client: Client;
  private isReady: boolean = false;

  constructor() {
    // LocalAuth session ko save rakhega taake baar baar QR scan na karna paray
    this.client = new Client({
      authStrategy: new LocalAuth(),
      puppeteer: {
        args: ['--no-sandbox', '--disable-setuid-sandbox'] // Server crash se bachanay ke liye
      }
    });

    this.initializeClient();
  }

  private initializeClient() {
    this.client.on('qr', (qr) => {
      console.log('\n==================================================');
      console.log('📱 SCAN THIS QR CODE FROM YOUR WHATSAPP TO LINK BOT');
      console.log('==================================================\n');
      qrcode.generate(qr, { small: true });
    });

    this.client.on('ready', () => {
      this.isReady = true;
      console.log('\n✅ WHATSAPP BOT IS CONNECTED & READY TO SEND OTPS!\n');
    });

    this.client.on('auth_failure', (msg) => {
      console.error('\n❌ WhatsApp Authentication Failed:', msg);
    });

    this.client.initialize();
  }

  async sendOtpMessage(phone: string, otp: string): Promise<void> {
    if (!this.isReady) {
      console.log('⚠️ WhatsApp Bot not ready yet. Logging OTP to console instead.');
      console.log(`[MOCK OTP]: ${otp} for ${phone}`);
      return;
    }

    try {
      // Format number for WhatsApp (e.g. 03001234567 -> 923001234567@c.us)
      let formattedNumber = phone.replace('+', '');
      if (formattedNumber.startsWith('0')) {
        formattedNumber = '92' + formattedNumber.substring(1); // Assuming Pakistan (+92)
      }
      const chatId = `${formattedNumber}@c.us`;

      const message = `*AgriConnect Verification*\n\nYour OTP is: *${otp}*\n\nPlease do not share this code with anyone. \n\n_Powered by Adlytix_`;
      
      await this.client.sendMessage(chatId, message);
      console.log(`✅ WhatsApp OTP sent to ${phone}`);
    } catch (error) {
      console.error(`❌ Failed to send WhatsApp OTP to ${phone}:`, error);
    }
  }
}