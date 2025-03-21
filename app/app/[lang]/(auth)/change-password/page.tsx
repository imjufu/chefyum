"use client";

import { useContext } from "react";
import { AuthContext, IntContext } from "@/app/lib/providers";
import { redirect } from "next/navigation";
import { ChangePasswordForm } from "./ui";

export default function ChangePassword() {
  const { currentSession } = useContext(AuthContext);
  if (currentSession?.isAuth) redirect("/");

  const { dictionary } = useContext(IntContext);
  return <ChangePasswordForm dict={dictionary}></ChangePasswordForm>;
}
