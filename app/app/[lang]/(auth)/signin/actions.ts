"use server";

import { SigninFormSchema, FormState } from "./definitions";
import { setSession } from "@/app/lib/session";
import { apiClient } from "@/app/lib/api";

export async function signin(
  previousState: FormState,
  formData: FormData,
): Promise<FormState> {
  // Validate form fields
  const validatedFields = SigninFormSchema.safeParse({
    email: formData.get("email"),
    password: formData.get("password"),
  });

  // If any form fields are invalid, return early
  if (!validatedFields.success) {
    return {
      errors: validatedFields.error.flatten().fieldErrors,
    };
  }

  const res = await apiClient.post("/auth", validatedFields.data);
  const json = await res.json();

  if (json.success) {
    // Create stateless session
    await setSession(
      json.data.access_token,
      json.data.user,
      new Date(json.data.expires_at),
    );
    return { token: json.data.access_token, user: json.data.user };
  } else {
    return {
      errors: {
        common: json.data.errors,
      },
    };
  }
}
