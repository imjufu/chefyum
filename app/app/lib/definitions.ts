export type User = {
  name: string;
  email: string;
  unconfirmed_email?: string;
  sign_in_count?: string;
  current_sign_in_at?: string;
  last_sign_in_at?: string;
  current_sign_in_ip?: string;
  last_sign_in_ip?: string;
};

export type Session = {
  isAuth: boolean;
  user?: User;
  token?: string;
};

export type ApiResponse = {
  success: boolean;
  data: unknown;
};

export type AlertLevel = "success" | "error";
