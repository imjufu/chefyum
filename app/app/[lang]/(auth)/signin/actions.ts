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

  const res = await apiClient.post("/auth", {
    ...validatedFields.data,
    unlocked_redirect_url: formData.get("unlocked_redirect_url"),
  });

  if (res.success) {
    // Create stateless session
    await setSession(
      res.data.access_token,
      res.data.user,
      new Date(res.data.expires_at),
    );
    return { token: res.data.access_token, user: res.data.user };
  } else {
    return {
      errors: {
        common: res.data.errors,
      },
    };
  }
}
