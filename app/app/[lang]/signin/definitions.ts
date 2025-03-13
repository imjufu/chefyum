import { z } from "zod";

export const SigninFormSchema = z.object({
  email: z.string().email({ message: "email_invalid" }).trim(),
  password: z.string().min(1, { message: "password_required" }).trim(),
});

export type FormState =
  | {
      errors?: {
        email?: string[];
        password?: string[];
        common?: string[];
      };
      message?: string;
    }
  | undefined;
