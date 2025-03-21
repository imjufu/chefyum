"use client";

import { Dictionary } from "@/app/lib/dictionaries";
import { changePassword } from "./actions";
import { useActionState, useContext, useEffect } from "react";
import { t } from "@/app/lib/i18n";
import { Field, Label, Input } from "@headlessui/react";
import Alert from "@/app/components/alert";
import { redirect, useSearchParams } from "next/navigation";
import { FlashMessageContext } from "@/app/lib/providers";

export function ChangePasswordForm({ dict }: { dict: Dictionary }) {
  const [state, action, pending] = useActionState(changePassword, undefined);

  const searchParams = useSearchParams();
  const token = searchParams.get("token") || "";

  const { setFlashMessage } = useContext(FlashMessageContext);
  useEffect(() => {
    if (state?.success) {
      setFlashMessage({
        message: t(dict.change_password, "success") as string,
        level: "success",
      });
      redirect("/signin");
    }
  });

  return (
    <>
      <div className="flex flex-col justify-center w-md mx-auto">
        <div className="sm:mx-auto sm:w-full sm:max-w-sm">
          <h2 className="text-center text-2xl/9 font-bold tracking-tight text-gray-900">
            {t(dict.change_password, "title")}
          </h2>
        </div>
        <form action={action}>
          <Input name="token" value={token} readOnly={true} type="hidden" />
          <Field>
            <Label htmlFor="password">
              {t(dict.change_password, "password")}
            </Label>
            <Input
              id="password"
              name="password"
              type="password"
              tabIndex={1}
              autoFocus
              className={state?.errors?.password && "error"}
            />
            {state?.errors?.password && (
              <p className="error">
                {t(dict.change_password, state.errors.password)}
              </p>
            )}
          </Field>
          <Field>
            <Label htmlFor="password">
              {t(dict.change_password, "password_confirmation")}
            </Label>
            <Input
              id="password_confirmation"
              name="password_confirmation"
              type="password"
              tabIndex={2}
              className={state?.errors?.password_confirmation && "error"}
            />
            {state?.errors?.password_confirmation && (
              <p className="error">
                {t(dict.change_password, state.errors.password_confirmation)}
              </p>
            )}
          </Field>
          {state?.errors?.common && (
            <Alert level="error">
              {t(dict.change_password, state.errors.common)}
            </Alert>
          )}
          <div>
            <button disabled={pending} type="submit" tabIndex={3}>
              {t(dict.change_password, "submit")}
            </button>
          </div>
        </form>
      </div>
    </>
  );
}
