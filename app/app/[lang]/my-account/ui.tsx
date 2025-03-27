"use client";

import { use, useActionState, useContext, useEffect, useState } from "react";
import { User } from "@/app/lib/definitions";
import "./styles.scss";
import { t, d } from "@/app/lib/i18n";
import { FlashMessageContext, IntContext } from "@/app/lib/providers";
import { Dictionary } from "@/app/lib/dictionaries";
import { Field, Label, Input } from "@headlessui/react";
import { update } from "./actions";
import { redirect, useSearchParams } from "next/navigation";
import Link from "next/link";

function Form({ dict, myAccount }: { dict: Dictionary; myAccount: User }) {
  const { name, email } = myAccount;
  const [state, action, pending] = useActionState(update, {
    success: false,
    data: { name, email },
  });
  const { setFlashMessage } = useContext(FlashMessageContext);
  const [redirectUrl, setRedirectUrl] = useState<string>("");

  useEffect(() => {
    setRedirectUrl(`${window.location.origin}/my-account?msg=confirmed`);
    if (state?.success) {
      setFlashMessage({
        message: t(dict, "my_account.success") as string,
        level: "success",
      });
      return redirect("/my-account");
    }
  }, [dict, state, setFlashMessage]);

  return (
    <form action={action} className="mt-4 w-1/2">
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
          className={state?.errors?.email && "error"}
        />
        {state?.errors?.email && (
          <p className="error">{t(dict, `common.${state.errors.email}`)}</p>
        )}
      </Field>
      <div className="flex gap-3 justify-end">
        <Link href="/my-account" className="btn btn-link" tabIndex={4}>
          {t(dict, "common.cancel")}
        </Link>
        <button
          disabled={pending}
          type="submit"
          tabIndex={3}
          className="w-auto"
        >
          {t(dict, "common.update")}
        </button>
      </div>
    </form>
  );
}

function Details({ dict, myAccount }: { dict: Dictionary; myAccount: User }) {
  return (
    <>
      <div className="mt-4 border-t border-gray-100">
        <dl className="lines">
          <div className="line">
            <dt>{t(dict, "common.name")}</dt>
            <dd>{myAccount.name}</dd>
          </div>
          <div className="line">
            <dt>{t(dict, "common.email")}</dt>
            <dd>
              {myAccount.email}
              {myAccount.unconfirmed_email ? (
                <span className="block text-muted">
                  {t(dict, "my_account.unconfirmed_email", {
                    email: myAccount.unconfirmed_email,
                  })}
                </span>
              ) : null}
            </dd>
          </div>
        </dl>
      </div>
      <div className="mt-8 px-4 sm:px-0">
        <p className="mt-1 max-w-2xl text-sm/6 text-gray-500">
          {t(dict, "my_account.security")}
        </p>
      </div>
      <div className="mt-4 border-t border-gray-100">
        <dl className="lines">
          <div className="line">
            <dt>{t(dict, "my_account.sign_in_count")}</dt>
            <dd>{myAccount.sign_in_count}</dd>
          </div>
          <div className="line">
            <dt>{t(dict, "my_account.current_sign_in_at")}</dt>
            <dd>{d(myAccount.current_sign_in_at, dict.locale)}</dd>
          </div>
          <div className="line">
            <dt>{t(dict, "my_account.last_sign_in_at")}</dt>
            <dd>{d(myAccount.last_sign_in_at, dict.locale)}</dd>
          </div>
          <div className="line">
            <dt>{t(dict, "my_account.current_sign_in_ip")}</dt>
            <dd>{myAccount.current_sign_in_ip}</dd>
          </div>
          <div className="line">
            <dt>{t(dict, "my_account.last_sign_in_ip")}</dt>
            <dd>{myAccount.last_sign_in_ip}</dd>
          </div>
        </dl>
      </div>
    </>
  );
}

export default function Me({ me }: { me: Promise<User> }) {
  const myAccount = use(me);
  const { dictionary: dict } = useContext(IntContext);
  const searchParams = useSearchParams();
  const edit = searchParams.get("edit");
  const msg = searchParams.get("msg");
  const { setFlashMessage } = useContext(FlashMessageContext);

  useEffect(() => {
    if (msg) {
      setFlashMessage({
        message: t(dict, `my_account.${msg}`) as string,
        level: "success",
      });
      return redirect("/my-account");
    }
  }, [dict, setFlashMessage, msg]);

  return (
    <div>
      <div className="px-4 sm:px-0 flex">
        <div className="grow-1">
          <h3 className="text-base/7 font-semibold text-gray-900">
            {t(dict, "my_account.title")}
          </h3>
          <p className="mt-1 max-w-2xl text-sm/6 text-gray-500">
            {t(dict, "my_account.description")}
          </p>
        </div>
        <div>
          {!edit ? (
            <button
              className="btn"
              onClick={() => redirect("/my-account?edit=true")}
            >
              {t(dict, "common.update")}
            </button>
          ) : null}
        </div>
      </div>
      {edit ? (
        <Form dict={dict} myAccount={myAccount} />
      ) : (
        <Details dict={dict} myAccount={myAccount} />
      )}
    </div>
  );
}
