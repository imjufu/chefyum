"use client";

import { Dictionary } from "../dictionaries";
import { signin } from "./actions";
import { useActionState, useContext, useEffect } from "react";
import { t } from "@/app/lib/i18n";
import { AuthContext } from "@/app/lib/providers";
import { Field, Label, Input } from "@headlessui/react";
import Link from "next/link";

export function SigninForm({ dict }: { dict: Dictionary }) {
  const [state, action, pending] = useActionState(signin, undefined);

  const { setCurrentSession } = useContext(AuthContext);
  useEffect(() => {
    if (state?.user)
      setCurrentSession({ isAuth: true, user: state.user, token: state.token });
  }, [state, setCurrentSession]);

  return (
    <div className="flex flex-col justify-center w-md mx-auto">
      <div className="sm:mx-auto sm:w-full sm:max-w-sm">
        <h2 className="text-center text-2xl/9 font-bold tracking-tight text-gray-900">
          {t(dict.signin, "title")}
        </h2>
        <p className="text-center text-sm/6 text-gray-500">
          Pas encore inscrit ? <Link href="/">{t(dict.signin, "signup")}</Link>
        </p>
      </div>
      <form action={action}>
        <Field>
          <Label htmlFor="email">{t(dict.signin, "email")}</Label>
          <Input
            id="email"
            name="email"
            type="email"
            tabIndex={1}
            autoFocus
            className={state?.errors?.email && "error"}
          />
          {state?.errors?.email && (
            <p className="error">{t(dict.signin, state.errors.email)}</p>
          )}
        </Field>
        <Field>
          <div className="flex items-center justify-between">
            <Label htmlFor="password">{t(dict.signin, "password")}</Label>
            <div className="text-sm">
              <Link href="/">{t(dict.signin, "forgot_password")}</Link>
            </div>
          </div>
          <Input
            id="password"
            name="password"
            type="password"
            tabIndex={2}
            className={state?.errors?.password && "error"}
          />
          {state?.errors?.password && (
            <p className="error">{t(dict.signin, state.errors.password)}</p>
          )}
        </Field>
        {state?.errors?.common && (
          <p className="error">{t(dict.signin, state.errors.common)}</p>
        )}
        <div>
          <button disabled={pending} type="submit" tabIndex={3}>
            {t(dict.signin, "submit")}
          </button>
        </div>
      </form>
    </div>
  );
}
