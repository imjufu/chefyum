"use client";

import { useContext } from "react";
import { IntContext } from "@/app/lib/providers";
import { authRequest } from "./actions";
import { useActionState, useState, useEffect } from "react";
import { t } from "@/app/lib/i18n";
import { Field, Label, Input } from "@headlessui/react";
import Alert from "@/app/components/alert";
import Link from "next/link";

export function AuthRequestForm({ requestType }: { requestType: string }) {
  const [state, action, pending] = useActionState(authRequest, undefined);

  const { dictionary: dict } = useContext(IntContext);

  const [baseRedirectUrl, setBaseRedirectUrl] = useState<string>("");
  useEffect(() => {
    setBaseRedirectUrl(window.location.origin);
  }, []);

  console.log("REQUEST", requestType);

  return (
    <>
      <div className="flex flex-col justify-center w-md mx-auto">
        <div className="sm:mx-auto sm:w-full sm:max-w-sm">
          <h2 className="text-center text-2xl/9 font-bold tracking-tight text-gray-900">
            {t(dict[requestType], "title")}
          </h2>
        </div>
        {state?.success && (
          <Alert level="success" className="my-5">
            {t(dict[requestType], "success")}
          </Alert>
        )}
        <form action={action}>
          <Input
            name="base_redirect_url"
            value={baseRedirectUrl}
            readOnly={true}
            type="hidden"
          />
          <Input
            name="request_type"
            value={requestType}
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
            <Alert level="error">
              {t(dict[requestType], state.errors.common)}
            </Alert>
          )}
          <div>
            <button disabled={pending} type="submit" tabIndex={3}>
              {t(dict[requestType], "submit")}
            </button>
          </div>
        </form>
        <div className="mt-4 text-sm flex flex-col items-center">
          <Link href="/signin">{t(dict.signup, "signin")}</Link>
        </div>
      </div>
    </>
  );
}
