import { z } from "zod";

export const AuthRequestFormSchema = z.object({
  email: z.string().email({ message: "email_invalid" }).trim(),
});

export type FormState =
  | {
      data?: {
        email?: string;
      };
      errors?: {
        email?: string[];
        common?: string[];
      };
      success: boolean;
    }
  | undefined;
