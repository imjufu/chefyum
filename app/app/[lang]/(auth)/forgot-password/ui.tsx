"use client";

import { Dictionary } from "@/app/[lang]/dictionaries";
import { forgotPassword } from "./actions";
import { useActionState, useState, useEffect } from "react";
import { t } from "@/app/lib/i18n";
import { Field, Label, Input } from "@headlessui/react";
import Alert from "@/app/[lang]/components/alert";

export function ForgotPasswordForm({ dict }: { dict: Dictionary }) {
  const [state, action, pending] = useActionState(forgotPassword, undefined);

  const [redirectUrl, setRedirectUrl] = useState<string>("");
  useEffect(() => {
    setRedirectUrl(`${window.location.origin}/forgot-password/change`);
  }, []);

  return (
    <>
      <div className="flex flex-col justify-center w-md mx-auto">
        <div className="sm:mx-auto sm:w-full sm:max-w-sm">
          <h2 className="text-center text-2xl/9 font-bold tracking-tight text-gray-900">
            {t(dict.forgot_password, "title")}
          </h2>
        </div>
        {state?.success && (
          <Alert type="success" className="my-5">
            {t(dict.forgot_password, "success")}
          </Alert>
        )}
        <form action={action}>
          <Input
            name="redirect_url"
            value={redirectUrl}
            readOnly={true}
            type="hidden"
          />
          <Field>
            <Label htmlFor="email">{t(dict.common, "email")}</Label>
            <Input
              id="email"
              name="email"
              type="email"
              tabIndex={1}
              autoFocus
              className={state?.errors?.email && "error"}
            />
            {state?.errors?.email && (
              <p className="error">{t(dict.common, state.errors.email)}</p>
            )}
          </Field>
          {state?.errors?.common && (
            <Alert type="error">
              {t(dict.forgot_password, state.errors.common)}
            </Alert>
          )}
          <div>
            <button disabled={pending} type="submit" tabIndex={3}>
              {t(dict.forgot_password, "submit")}
            </button>
          </div>
        </form>
      </div>
    </>
  );
}
