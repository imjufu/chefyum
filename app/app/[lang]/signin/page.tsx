"use client";

import { SigninForm } from "./ui";
import { useContext } from "react";
import { IntContext } from "@/app/lib/providers";
import { AuthContext } from "@/app/lib/providers";
import { redirect } from "next/navigation";

export default function Signin() {
  const { currentSession } = useContext(AuthContext);
  if (currentSession?.isAuth) redirect("/");

  const { dictionary } = useContext(IntContext);
  return <SigninForm dict={dictionary}></SigninForm>;
}
