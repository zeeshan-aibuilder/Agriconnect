export class Role {
  constructor(
    public readonly id: string,
    public readonly role_name: 'Farmer' | 'Buyer' | 'Transporter' | 'Admin'
  ) {}
}