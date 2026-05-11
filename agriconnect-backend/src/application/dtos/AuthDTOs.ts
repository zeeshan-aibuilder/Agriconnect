export interface VerifyOtpDTO {
  phone: string;
  otp: string;
  name?: string;     // Sirf tab chahiye jab naya account ban raha ho
  role_id?: string;  // Farmer, Buyer ya Transporter ki ID
}