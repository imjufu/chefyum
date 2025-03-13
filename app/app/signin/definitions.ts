import { z } from "zod";

export const SigninFormSchema = z.object({
  email: z.string().email({ message: "Please enter a valid email." }).trim(),
  password: z.string().min(1, { message: "Required." }).trim(),
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
