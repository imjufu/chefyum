"use client";

import { signin } from "./actions";
import { useActionState } from "react";

export function SigninForm() {
  const [state, action, pending] = useActionState(signin, undefined);

  return (
    <div>
      <form action={action}>
        <div>
          <label htmlFor="email">Email</label>
          <input id="email" name="email" type="email" placeholder="Email" />
        </div>
        {state?.errors?.email && <p>{state.errors.email}</p>}
        <div>
          <label htmlFor="password">Password</label>
          <input id="password" name="password" type="password" />
        </div>
        {state?.errors?.password && <p>{state.errors.password}</p>}
        <button disabled={pending} type="submit">
          Sign In
        </button>
        {state?.errors?.common && <p>{state.errors.common}</p>}
      </form>
    </div>
  );
}
