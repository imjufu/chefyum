"use client";

import { Dictionary } from "../dictionaries";
import { signin } from "./actions";
import { useActionState, useContext, useEffect } from "react";
import { t } from "@/app/lib/i18n";
import { AuthContext } from "@/app/lib/providers";
import { redirect } from "next/navigation";

export function SigninForm({ dict }: { dict: Dictionary }) {
  const [state, action, pending] = useActionState(signin, undefined);

  const { currentSession, setCurrentSession } = useContext(AuthContext);
  if (currentSession?.isAuth) redirect("/");

  useEffect(() => {
    if (state?.user)
      setCurrentSession({ isAuth: true, user: state.user, token: state.token });
  }, [state, setCurrentSession]);

  return (
    <div>
      <form action={action}>
        <div>
          <label htmlFor="email">{t(dict.signin, "email")}</label>
          <input id="email" name="email" type="email" />
        </div>
        {state?.errors?.email && <p>{t(dict.signin, state.errors.email)}</p>}
        <div>
          <label htmlFor="password">{t(dict.signin, "password")}</label>
          <input id="password" name="password" type="password" />
        </div>
        {state?.errors?.password && (
          <p>{t(dict.signin, state.errors.password)}</p>
        )}
        <button disabled={pending} type="submit">
          {t(dict.signin, "submit")}
        </button>
        {state?.errors?.common && <p>{t(dict.signin, state.errors.common)}</p>}
      </form>
    </div>
  );
}
