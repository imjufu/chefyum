import "server-only";
import { cache } from "react";
import { getSession } from "./session";
import { Session } from "./definitions";

export const verifySession = cache(async (): Promise<Session> => {
  const session = await getSession();

  if (!session?.token) {
    return { isAuth: false };
  }

  return { isAuth: true, user: session.user, token: session.token };
});
