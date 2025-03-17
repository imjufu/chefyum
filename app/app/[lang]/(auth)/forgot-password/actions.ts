"use server";

import { ForgotPasswordFormSchema, FormState } from "./definitions";
import { apiClient } from "@/app/lib/api";

export async function forgotPassword(
  previousState: FormState,
  formData: FormData,
): Promise<FormState> {
  // Validate form fields
  const validatedFields = ForgotPasswordFormSchema.safeParse({
    email: formData.get("email"),
  });

  // If any form fields are invalid, return early
  if (!validatedFields.success) {
    return {
      success: false,
      errors: validatedFields.error.flatten().fieldErrors,
    };
  }

  const res = await apiClient.post("/auth/password/reset-request", {
    redirect_url: formData.get("redirect_url"),
    ...validatedFields.data,
  });
  const json = await res.json();

  if (json.success) {
    return { success: true };
  } else {
    return {
      success: false,
      errors: {
        common: json.data.errors,
      },
    };
  }
}
