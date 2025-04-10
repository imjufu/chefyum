export type User = {
  name: string;
  email: string;
  unconfirmed_email?: string;
  sign_in_count?: string;
  current_sign_in_at?: string;
  last_sign_in_at?: string;
  current_sign_in_ip?: string;
  last_sign_in_ip?: string;
  gender?: "male" | "female";
  birthdate?: string;
  height_in_centimeters?: number;
  weight_in_grams?: number;
  activity_level?:
    | "sedentary"
    | "lightly_active"
    | "moderately_active"
    | "active"
    | "very_active";
  macro?: {
    tdee: number;
    bmr: number;
    protein_in_grams: number;
    lipid_in_grams: number;
    carbohydrate_in_grams: number;
  };
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
