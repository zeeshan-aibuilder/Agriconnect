import jwt from 'jsonwebtoken';

export class JwtService {
  private secret = process.env.JWT_SECRET || 'agriconnect-super-secret-key';

  generateToken(payload: { id: string; role_id: string; phone: string }): string {
    return jwt.sign(payload, this.secret, { expiresIn: '7d' });
  }

  verifyToken(token: string): any {
    try {
      return jwt.verify(token, this.secret);
    } catch (error) {
      return null;
    }
  }
}