"use server";

import { cookies } from "next/headers";
import { User } from "./definitions";

const sessionKey = "session";

export async function setSession(token: string, user: User, expiresAt: Date) {
  const session = JSON.stringify({ token, user, expiresAt });
  const cookieStore = await cookies();
  cookieStore.set(sessionKey, session, {
    httpOnly: true,
    secure: true,
    expires: expiresAt,
    sameSite: "lax",
    path: "/",
  });
}

export async function getSession() {
  const cookieStore = await cookies();
  const val = cookieStore.get(sessionKey)?.value;
  return val ? JSON.parse(val) : false;
}

export async function deleteSession() {
  const cookieStore = await cookies();
  cookieStore.delete(sessionKey);
}
