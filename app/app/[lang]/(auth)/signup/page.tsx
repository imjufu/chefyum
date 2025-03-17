"use client";

import { SignupForm } from "./ui";
import { useContext } from "react";
import { AuthContext, IntContext } from "@/app/lib/providers";
import { redirect } from "next/navigation";

export default function Signup() {
  const { currentSession } = useContext(AuthContext);
  if (currentSession?.isAuth) redirect("/");

  const { dictionary } = useContext(IntContext);
  return <SignupForm dict={dictionary}></SignupForm>;
}
