"use server";

import { apiClient } from "@/app/lib/api";
import { UpdateFormSchema, FormState } from "./definitions";

export async function getMe() {
  return (await apiClient.get("/me")).data;
}

export async function update(
  previousState: FormState,
  formData: FormData,
): Promise<FormState> {
  // Validate form fields
  const currentData = {
    email: formData.get("email") as string,
    name: formData.get("name") as string,
  };
  const validatedFields = UpdateFormSchema.safeParse(currentData);

  // If any form fields are invalid, return early
  if (!validatedFields.success) {
    return {
      success: false,
      data: currentData,
      errors: validatedFields.error.flatten().fieldErrors,
    };
  }

  const res = await apiClient.patch("/me", {
    user: validatedFields.data,
    redirect_url: formData.get("redirect_url"),
  });

  if (res.success) {
    return {
      success: true,
    };
  } else {
    return {
      success: false,
      data: currentData,
      errors: {
        common: res.data.errors,
      },
    };
  }
}
