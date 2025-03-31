"use client";

import { Dictionary } from "@/app/lib/dictionaries";
import { signup } from "./actions";
import { useState, useActionState, useEffect } from "react";
import { t } from "@/app/lib/i18n";
import { Field, Label, Input } from "@headlessui/react";
import Link from "next/link";
import Alert from "@/app/components/alert";

export function SignupForm({ dict }: { dict: Dictionary }) {
  const [state, action, pending] = useActionState(signup, undefined);

  const [redirectUrl, setRedirectUrl] = useState<string>("");
  useEffect(() => {
    setRedirectUrl(`${window.location.origin}/signin?msg=confirmed`);
  }, []);

  let commonErrorPart = null;
  if (state?.errors?.common) {
    const parts = [];
    for (let idx = 0; idx < state.errors.common.length; idx++) {
      const error = state.errors.common[idx];
      if (error === "email_taken") {
        parts.push(
          <p key={idx}>
            {t(dict, `signup.${error}`)}
            <Link href="/reset-password">
              {t(dict, "signin.forgot_password")}
            </Link>
          </p>,
        );
      } else {
        parts.push(<p key={idx}>{t(dict, `signup.${error}`)}</p>);
      }
    }
    commonErrorPart = parts;
  }

  return (
    <div className="flex flex-col justify-center w-md mx-auto">
      <div className="sm:mx-auto sm:w-full sm:max-w-sm">
        <h2 className="text-center text-2xl/9 font-bold tracking-tight text-gray-900">
          {t(dict, "signup.title")}
        </h2>
        <p className="text-center text-sm/6 text-gray-500">
          <span>{t(dict, "signup.already_signup")}</span>&nbsp;
          <Link href="/signin">{t(dict, "signup.signin")}</Link>
        </p>
      </div>
      {state?.success && (
        <Alert level="success" className="my-5">
          <div
            dangerouslySetInnerHTML={{ __html: t(dict, "signup.success") }}
          ></div>
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
          <Label htmlFor="name">{t(dict, "common.name")}</Label>
          <Input
            id="name"
            name="name"
            defaultValue={state?.data?.name}
            type="text"
            tabIndex={1}
            autoFocus
            className={state?.errors?.name && "error"}
          />
          {state?.errors?.name && (
            <p className="error">{t(dict, `common.${state.errors.name}`)}</p>
          )}
        </Field>
        <Field>
          <Label htmlFor="email">{t(dict, "common.email")}</Label>
          <Input
            id="email"
            name="email"
            defaultValue={state?.data?.email}
            type="email"
            tabIndex={2}
            autoFocus
            className={state?.errors?.email && "error"}
          />
          {state?.errors?.email && (
            <p className="error">{t(dict, `common.${state.errors.email}`)}</p>
          )}
        </Field>
        <Field>
          <Label htmlFor="password">{t(dict, "common.password")}</Label>
          <Input
            id="password"
            name="password"
            type="password"
            tabIndex={3}
            className={state?.errors?.password && "error"}
          />
          {state?.errors?.password && (
            <p className="error">
              {t(dict, `common.${state.errors.password}`)}
            </p>
          )}
        </Field>
        {commonErrorPart && <Alert level="error">{commonErrorPart}</Alert>}
        <div>
          <button disabled={pending} type="submit" tabIndex={4}>
            {t(dict, "signup.submit")}
          </button>
        </div>
      </form>
      <div className="mt-4 text-sm flex flex-col items-center">
        <Link href="/signin">{t(dict, "signup.signin")}</Link>
      </div>
    </div>
  );
}
