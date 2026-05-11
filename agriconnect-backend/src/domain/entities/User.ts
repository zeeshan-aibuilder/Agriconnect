export class User {
  constructor(
    public readonly id: string,
    public readonly phone: string,
    public name: string,
    public role_id: string, // Copilot ne yahan 'roleId' likha hoga
    public readonly created_at: Date
  ) {}
}