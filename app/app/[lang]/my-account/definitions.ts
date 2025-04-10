import { z } from "zod";

export const UpdateFormSchema = z.object({
  email: z.string().email({ message: "email_invalid" }).trim(),
  name: z.string().trim(),
  birthdate: z.date({ message: "birthdate_invalid" }),
  gender: z.string(),
  height_in_centimeters: z.number(),
  weight_in_grams: z.number(),
  activity_level: z.string(),
});

export type FormState =
  | {
      data?: {
        email?: string;
        name?: string;
        birthdate?: string;
        gender?: string;
        height_in_centimeters?: number;
        weight_in_grams?: number;
        activity_level?: string;
      };
      errors?: {
        email?: string[];
        name?: string[];
        birthdate?: string[];
        gender?: string[];
        height_in_centimeters?: string[];
        weight_in_grams?: string[];
        activity_level?: string[];
        common?: string[];
      };
      success: boolean;
    }
  | undefined;
