"use server";

import { ChangePasswordFormSchema, FormState } from "./definitions";
import { apiClient } from "@/app/lib/api";

export async function changePassword(
  previousState: FormState,
  formData: FormData,
): Promise<FormState> {
  // Validate form fields
  const validatedFields = ChangePasswordFormSchema.safeParse({
    password: formData.get("password"),
    password_confirmation: formData.get("password_confirmation"),
  });

  // If any form fields are invalid, return early
  if (!validatedFields.success) {
    return {
      success: false,
      errors: validatedFields.error.flatten().fieldErrors,
    };
  }

  const res = await apiClient.put("/auth/password", {
    token: formData.get("token"),
    password: validatedFields.data["password"],
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
