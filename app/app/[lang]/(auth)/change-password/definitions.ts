import { z } from "zod";

export const ChangePasswordFormSchema = z
  .object({
    password: z.string().min(1, { message: "password_required" }).trim(),
    password_confirmation: z
      .string()
      .min(1, { message: "password_confirmation_required" })
      .trim(),
  })
  .refine((data) => data.password === data.password_confirmation, {
    message: "password_confirmation_invalid",
    path: ["password_confirmation"],
  });

export type FormState =
  | {
      data?: {
        password?: string;
        password_confirmation?: string;
      };
      errors?: {
        password?: string[];
        password_confirmation?: string[];
        common?: string[];
      };
      success: boolean;
    }
  | undefined;
