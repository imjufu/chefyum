import { z } from "zod";

export const UpdateFormSchema = z.object({
  email: z.string().email({ message: "email_invalid" }).trim(),
  name: z.string().min(1, { message: "name_required" }).trim(),
});

export type FormState =
  | {
      data?: {
        email?: string;
        name?: string;
      };
      errors?: {
        email?: string[];
        name?: string[];
        common?: string[];
      };
      success: boolean;
    }
  | undefined;
