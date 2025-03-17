import { z } from "zod";

export const SignupFormSchema = z.object({
  email: z.string().email({ message: "email_invalid" }).trim(),
  name: z.string().min(1, { message: "name_required" }).trim(),
  password: z.string().min(1, { message: "password_required" }).trim(),
});

export type FormState =
  | {
      data?: {
        email?: string;
        name?: string;
        password?: string;
      };
      errors?: {
        email?: string[];
        name?: string[];
        password?: string[];
        common?: string[];
      };
      success: boolean;
    }
  | undefined;
