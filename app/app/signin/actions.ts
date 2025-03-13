"use server";

import { SigninFormSchema, FormState } from "./definitions";
import { setSession } from "@/app/lib/session";

export async function signin(
  state: FormState,
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

  const res = await fetch("http://localhost:3000/api/v1/auth", {
    method: "POST",
    body: JSON.stringify(validatedFields.data),
    headers: {
      "Content-Type": "application/json",
    },
  });

  const json = await res.json();
  if (json.success) {
    await setSession(
      json.data.access_token,
      json.data.user,
      new Date("2025-07-01"),
    );
  } else {
    return {
      errors: {
        common: json.data.errors,
      },
    };
  }
}
