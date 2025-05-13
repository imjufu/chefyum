"use client";

import { Dictionary } from "@/app/lib/dictionaries";
import { signin } from "./actions";
import { useActionState, useContext, useEffect, useState } from "react";
import { t } from "@/app/lib/i18n";
import { AuthContext, FlashMessageContext } from "@/app/lib/providers";
import { Field, Label, Input } from "@headlessui/react";
import Link from "next/link";
import { redirect, useSearchParams } from "next/navigation";
import Alert from "@/app/components/alert";

export default function Ui({ dict }: { dict: Dictionary }) {
  const [state, action, pending] = useActionState(signin, undefined);

  const [unlockedRedirectUrl, setUnlockedRedirectUrl] = useState<string>("");
  useEffect(() => {
    setUnlockedRedirectUrl(`${window.location.origin}/signin?msg=unlocked`);
  }, []);

  const searchParams = useSearchParams();
  const msg = searchParams.get("msg");

  const { setCurrentSession } = useContext(AuthContext);
  const { setFlashMessage } = useContext(FlashMessageContext);
  useEffect(() => {
    if (state?.user) {
      setFlashMessage({
        message: t(dict, "signin.success") as string,
        level: "success",
      });
      setCurrentSession({ isAuth: true, user: state.user, token: state.token });
    }

    if (msg) {
      setFlashMessage({
        message: t(dict, `signin.${msg}`) as string,
        level: "success",
      });
      return redirect("/signin");
    }
  }, [dict, state, setCurrentSession, setFlashMessage, msg]);

  return (
    <>
      <div className="flex flex-col justify-center w-md mx-auto">
        <div className="sm:mx-auto sm:w-full sm:max-w-sm">
          <h2 className="text-center text-2xl/9 font-bold tracking-tight text-gray-900">
            {t(dict, "signin.title")}
          </h2>
          <p className="text-center text-sm/6 text-gray-500">
            Pas encore inscrit ?{" "}
            <Link href="/signup">{t(dict, "signin.signup")}</Link>
          </p>
        </div>
        <form action={action}>
          <Input
            name="unlocked_redirect_url"
            value={unlockedRedirectUrl}
            readOnly={true}
            type="hidden"
          />
          <Field>
            <Label htmlFor="email">{t(dict, "common.email")}</Label>
            <Input
              id="email"
              name="email"
              type="email"
              tabIndex={1}
              autoFocus
              className={state?.errors?.email && "error"}
            />
            {state?.errors?.email && (
              <p className="error">{t(dict, `common.${state.errors.email}`)}</p>
            )}
          </Field>
          <Field>
            <div className="flex items-center justify-between">
              <Label htmlFor="password">{t(dict, "common.password")}</Label>
              <div className="text-sm">
                <Link href="/reset-password">
                  {t(dict, "signin.forgot_password")}
                </Link>
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
              <p className="error">
                {t(dict, `common.${state.errors.password}`)}
              </p>
            )}
          </Field>
          {state?.errors?.common && (
            <Alert level="error">
              {t(dict, `signin.${state.errors.common}`)}
            </Alert>
          )}
          <div>
            <button disabled={pending} type="submit" tabIndex={3}>
              {t(dict, "signin.submit")}
            </button>
          </div>
        </form>
        <div className="mt-4 text-sm flex flex-col items-center">
          <Link href="/confirmation">{t(dict, "confirmation.title")}</Link>
          <Link href="/unlock">{t(dict, "unlock.title")}</Link>
        </div>
      </div>
    </>
  );
}
