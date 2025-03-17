"use client";

import { Dictionary } from "../dictionaries";
import { signin } from "./actions";
import { useActionState, useContext, useEffect, useRef } from "react";
import { t } from "@/app/lib/i18n";
import { AuthContext } from "@/app/lib/providers";
import { Field, Label, Input } from "@headlessui/react";
import Link from "next/link";
import { useSearchParams } from "next/navigation";
import Modal from "../components/modal";
import { redirect } from "next/navigation";

export function SigninForm({ dict }: { dict: Dictionary }) {
  const [state, action, pending] = useActionState(signin, undefined);

  const searchParams = useSearchParams();
  const confirmed = searchParams.get("confirmed");

  const { setCurrentSession } = useContext(AuthContext);
  useEffect(() => {
    if (state?.user)
      setCurrentSession({ isAuth: true, user: state.user, token: state.token });
  }, [state, setCurrentSession]);

  const modalRef = useRef(null);

  return (
    <>
      <div className="flex flex-col justify-center w-md mx-auto">
        <div className="sm:mx-auto sm:w-full sm:max-w-sm">
          <h2 className="text-center text-2xl/9 font-bold tracking-tight text-gray-900">
            {t(dict.signin, "title")}
          </h2>
          <p className="text-center text-sm/6 text-gray-500">
            Pas encore inscrit ?{" "}
            <Link href="/signup">{t(dict.signin, "signup")}</Link>
          </p>
        </div>
        <form action={action}>
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
          <Field>
            <div className="flex items-center justify-between">
              <Label htmlFor="password">{t(dict.common, "password")}</Label>
              <div className="text-sm">
                <Link href="/forgot-password">
                  {t(dict.signin, "forgot_password")}
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
              <p className="error">{t(dict.common, state.errors.password)}</p>
            )}
          </Field>
          {state?.errors?.common && (
            <div className="alert-error">
              {t(dict.signin, state.errors.common)}
            </div>
          )}
          <div>
            <button disabled={pending} type="submit" tabIndex={3}>
              {t(dict.signin, "submit")}
            </button>
          </div>
        </form>
      </div>
      <Modal
        ref={modalRef}
        open={!!confirmed}
        title={t(dict.signin, "confirmed_title") as string}
        description={t(dict.signin, "confirmed_description") as string}
      >
        <button
          type="button"
          className="btn"
          onClick={() => {
            modalRef.current.closeModal();
            redirect("/signin");
          }}
        >
          {t(dict.signin, "confirmed_action")}
        </button>
      </Modal>
    </>
  );
}
