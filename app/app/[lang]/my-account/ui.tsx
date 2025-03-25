"use client";

import { use, useContext } from "react";
import { User } from "@/app/lib/definitions";
import "./styles.scss";
import { t, d } from "@/app/lib/i18n";
import { IntContext } from "@/app/lib/providers";

export default function Me({ me }: { me: Promise<User> }) {
  const myAccount = use(me);
  const { dictionary: dict } = useContext(IntContext);

  return (
    <div>
      <div className="px-4 sm:px-0">
        <h3 className="text-base/7 font-semibold text-gray-900">
          {t(dict, "my_account.title")}
        </h3>
        <p className="mt-1 max-w-2xl text-sm/6 text-gray-500">
          {t(dict, "my_account.description")}
        </p>
      </div>
      <div className="mt-4 border-t border-gray-100">
        <dl className="lines">
          <div className="line">
            <dt>{t(dict, "common.name")}</dt>
            <dd>{myAccount.name}</dd>
          </div>
          <div className="line">
            <dt>{t(dict, "common.email")}</dt>
            <dd>{myAccount.email}</dd>
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
    </div>
  );
}
