"use server";

import { AuthRequestFormSchema, FormState } from "./definitions";
import { apiClient } from "@/app/lib/api";

export async function authRequest(
  previousState: FormState,
  formData: FormData,
): Promise<FormState> {
  // Validate form fields
  const validatedFields = AuthRequestFormSchema.safeParse({
    email: formData.get("email"),
  });

  // If any form fields are invalid, return early
  if (!validatedFields.success) {
    return {
      success: false,
      errors: validatedFields.error.flatten().fieldErrors,
    };
  }

  let apiUrl = null;
  let redirectUrl = formData.get("base_redirect_url");
  switch (formData.get("request_type")) {
    case "reset-password":
      apiUrl = "/auth/password/request";
      redirectUrl += "/change-password";
      break;
    case "confirmation":
      apiUrl = "/auth/confirmation/request";
      redirectUrl += "/signin?msg=confirmed";
      break;
    case "unlock":
      apiUrl = "/auth/unlock/request";
      redirectUrl += "/signin?msg=unlocked";
      break;
  }

  if (!apiUrl) {
    return {
      success: false,
      errors: {
        common: ["invalid_api_url"],
      },
    };
  }

  const res = await apiClient.post(apiUrl, {
    redirect_url: redirectUrl,
    ...validatedFields.data,
  });

  if (res.success) {
    return { success: true };
  } else {
    return {
      success: false,
      errors: {
        common: res.data.errors,
      },
    };
  }
}
