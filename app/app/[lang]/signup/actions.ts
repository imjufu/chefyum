"use server";

import { SignupFormSchema, FormState } from "./definitions";
import { apiClient } from "@/app/lib/api";

export async function signup(
  previousState: FormState,
  formData: FormData,
): Promise<FormState> {
  // Validate form fields
  const currentData = {
    email: formData.get("email") as string,
    name: formData.get("name") as string,
    password: formData.get("password") as string,
  };
  const validatedFields = SignupFormSchema.safeParse(currentData);

  // If any form fields are invalid, return early
  if (!validatedFields.success) {
    return {
      success: false,
      data: currentData,
      errors: validatedFields.error.flatten().fieldErrors,
    };
  }

  const res = await apiClient.post("/sign-up", {
    user: validatedFields.data,
    redirect_url: formData.get("redirect_url"),
  });
  const json = await res.json();

  if (json.success) {
    return {
      success: true,
    };
  } else {
    return {
      success: false,
      data: currentData,
      errors: {
        common: json.data.errors,
      },
    };
  }
}
