import "server-only";
import { cache } from "react";
import { getSession } from "./session";
import { redirect } from "next/navigation";

export const verifySession = cache(async () => {
  const session = await getSession();

  if (!session?.token) {
    return { isAuth: false };
  }

  return { isAuth: true, user: session.user };
});

export async function redirectIfAlreadyConnected(url: string) {
  const session = await verifySession();
  if (session.isAuth) {
    redirect(url);
  }
}
