"use client";

import { use, useActionState, useContext, useEffect, useState } from "react";
import { User } from "@/app/lib/definitions";
import "./styles.scss";
import { t, d } from "@/app/lib/i18n";
import { FlashMessageContext, IntContext } from "@/app/lib/providers";
import { Dictionary } from "@/app/lib/dictionaries";
import { Field, Label, Input, Select } from "@headlessui/react";
import { update } from "./actions";
import { redirect, useSearchParams } from "next/navigation";
import Link from "next/link";
import { ChevronDownIcon } from "@heroicons/react/16/solid";

function Form({ dict, myAccount }: { dict: Dictionary; myAccount: User }) {
  const {
    name,
    email,
    gender,
    birthdate,
    height_in_centimeters,
    weight_in_grams,
    activity_level,
  } = myAccount;
  const [state, action, pending] = useActionState(update, {
    success: false,
    data: {
      name,
      email,
      gender,
      birthdate,
      height_in_centimeters,
      weight_in_grams,
      activity_level,
    },
  });
  const [heightInCentimeters, setHeightInCentimeters] = useState(
    height_in_centimeters,
  );
  const [weightInGrams, setWeightInGrams] = useState(weight_in_grams);
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
          className={state?.errors?.email && "error"}
        />
        {state?.errors?.email && (
          <p className="error">{t(dict, `common.${state.errors.email}`)}</p>
        )}
      </Field>
      <Field>
        <Label htmlFor="gender">{t(dict, "common.gender")}</Label>
        <div className="grid grid-cols-1">
          <Select
            name="gender"
            className={`col-start-1 row-start-1 ${state?.errors?.gender ? "error" : ""}`}
            defaultValue={state?.data?.gender}
          >
            <option></option>
            <option value="male">{t(dict, "common.male")}</option>
            <option value="female">{t(dict, "common.female")}</option>
          </Select>
          <ChevronDownIcon
            className="pointer-events-none col-start-1 row-start-1 mr-2 size-5 self-center justify-self-end text-gray-500 sm:size-4"
            aria-hidden="true"
          />
        </div>
        {state?.errors?.gender && (
          <p className="error">{t(dict, `common.${state.errors.gender}`)}</p>
        )}
      </Field>
      <Field>
        <Label htmlFor="birthdate">{t(dict, "common.birthdate")}</Label>
        <div className="grid grid-cols-1">
          <Input
            id="birthdate"
            name="birthdate"
            defaultValue={
              state?.data?.birthdate ? state.data.birthdate : undefined
            }
            type="date"
            className={state?.errors?.name && "error"}
          />
        </div>
        {state?.errors?.birthdate && (
          <p className="error">{t(dict, `common.${state.errors.birthdate}`)}</p>
        )}
      </Field>
      <Field>
        <Label htmlFor="height">{t(dict, "common.height")}</Label>
        <Input
          name="height_in_centimeters"
          defaultValue={heightInCentimeters}
          type="hidden"
        />
        <Input
          id="height"
          name="height"
          defaultValue={
            state?.data?.height_in_centimeters
              ? state.data.height_in_centimeters / 100
              : undefined
          }
          type="number"
          min={0}
          step={0.01}
          onChange={(e) =>
            setHeightInCentimeters(
              Math.round(+e.target.value * 100 * 100) / 100,
            )
          }
          className={state?.errors?.height_in_centimeters && "error"}
        />
        {state?.errors?.height_in_centimeters && (
          <p className="error">
            {t(dict, `common.${state.errors.height_in_centimeters}`)}
          </p>
        )}
      </Field>
      <Field>
        <Label htmlFor="weight">{t(dict, "common.weight")}</Label>
        <Input
          name="weight_in_grams"
          defaultValue={weightInGrams}
          type="hidden"
        />
        <Input
          id="weight"
          name="weight"
          defaultValue={
            state?.data?.weight_in_grams
              ? state.data.weight_in_grams / 1000
              : undefined
          }
          type="number"
          min={0}
          step={0.5}
          onChange={(e) =>
            setWeightInGrams(Math.round(+e.target.value * 1000 * 100) / 100)
          }
          className={state?.errors?.weight_in_grams && "error"}
        />
        {state?.errors?.weight_in_grams && (
          <p className="error">
            {t(dict, `common.${state.errors.weight_in_grams}`)}
          </p>
        )}
      </Field>
      <Field>
        <Label htmlFor="activity_level">
          {t(dict, "common.activity_level")}
        </Label>
        <div className="grid grid-cols-1">
          <Select
            name="activity_level"
            className={`col-start-1 row-start-1 ${state?.errors?.activity_level ? "error" : ""}`}
            defaultValue={state?.data?.activity_level}
          >
            <option></option>
            <option value="sedentary">
              {t(dict, "my_account.activity_level.sedentary")}
            </option>
            <option value="lightly_active">
              {t(dict, "my_account.activity_level.lightly_active")}
            </option>
            <option value="moderately_active">
              {t(dict, "my_account.activity_level.moderately_active")}
            </option>
            <option value="active">
              {t(dict, "my_account.activity_level.active")}
            </option>
            <option value="very_active">
              {t(dict, "my_account.activity_level.very_active")}
            </option>
          </Select>
          <ChevronDownIcon
            className="pointer-events-none col-start-1 row-start-1 mr-2 size-5 self-center justify-self-end text-gray-500 sm:size-4"
            aria-hidden="true"
          />
        </div>
        {state?.errors?.activity_level && (
          <p className="error">
            {t(dict, `common.${state.errors.activity_level}`)}
          </p>
        )}
      </Field>
      <div className="flex gap-3 justify-end">
        <Link href="/my-account" className="btn btn-link">
          {t(dict, "common.cancel")}
        </Link>
        <button disabled={pending} type="submit" className="w-auto">
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
          {myAccount.gender ? (
            <div className="line">
              <dt>{t(dict, "common.gender")}</dt>
              <dd>{t(dict, `common.${myAccount.gender}`)}</dd>
            </div>
          ) : null}
          {myAccount.birthdate ? (
            <div className="line">
              <dt>{t(dict, "common.birthdate")}</dt>
              <dd>
                {d(myAccount.birthdate, dict.locale, { timeStyle: undefined })}
              </dd>
            </div>
          ) : null}
          {myAccount.height_in_centimeters ? (
            <div className="line">
              <dt>{t(dict, "common.height")}</dt>
              <dd>
                {t(dict, "my_account.height", {
                  height: myAccount.height_in_centimeters / 100,
                })}
              </dd>
            </div>
          ) : null}
          {myAccount.weight_in_grams ? (
            <div className="line">
              <dt>{t(dict, "common.weight")}</dt>
              <dd>
                {t(dict, "my_account.weight", {
                  weight: myAccount.weight_in_grams / 1000,
                })}
              </dd>
            </div>
          ) : null}
          {myAccount.activity_level ? (
            <div className="line">
              <dt>{t(dict, "common.activity_level")}</dt>
              <dd>
                {t(
                  dict,
                  `my_account.activity_level.${myAccount.activity_level}`,
                )}
              </dd>
            </div>
          ) : null}
        </dl>
      </div>
      <div className="mt-8 px-4 sm:px-0">
        <p className="mt-1 max-w-2xl text-sm/6 text-gray-500">
          {t(dict, "my_account.cal")}
        </p>
      </div>
      <div className="mt-4 border-t border-gray-100">
        {myAccount.macro ? (
          <dl className="lines">
            <div className="line">
              <dt>{t(dict, "my_account.tdee")}</dt>
              <dd>
                {t(dict, "my_account.in_cals", {
                  cals: myAccount.macro.tdee,
                })}
              </dd>
            </div>
            <div className="line">
              <dt>{t(dict, "my_account.bmr")}</dt>
              <dd>
                {t(dict, "my_account.in_cals", {
                  cals: myAccount.macro.bmr,
                })}
              </dd>
            </div>
          </dl>
        ) : (
          ""
        )}
      </div>
      <div className="mt-8 px-4 sm:px-0">
        <p className="mt-1 max-w-2xl text-sm/6 text-gray-500">
          {t(dict, "my_account.macro")}
        </p>
      </div>
      <div className="mt-4 border-t border-gray-100">
        {myAccount.macro ? (
          <dl className="lines">
            <div className="line">
              <dt>{t(dict, "my_account.protein_in_grams")}</dt>
              <dd>
                {t(dict, "my_account.in_grams", {
                  grams: myAccount.macro.protein_in_grams,
                })}
              </dd>
            </div>
            <div className="line">
              <dt>{t(dict, "my_account.carbohydrate_in_grams")}</dt>
              <dd>
                {t(dict, "my_account.in_grams", {
                  grams: myAccount.macro.carbohydrate_in_grams,
                })}
              </dd>
            </div>
            <div className="line">
              <dt>{t(dict, "my_account.lipid_in_grams")}</dt>
              <dd>
                {t(dict, "my_account.in_grams", {
                  grams: myAccount.macro.lipid_in_grams,
                })}
              </dd>
            </div>
          </dl>
        ) : (
          ""
        )}
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

export default function Ui({ me }: { me: Promise<User> }) {
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
          <h1 className="text-base/7 font-semibold text-gray-900">
            {t(dict, "my_account.title")}
          </h1>
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
