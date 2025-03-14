"use client";

import { SigninForm } from "./ui";
import { useContext } from "react";
import { IntContext } from "@/app/lib/providers";

export default function Signin() {
  const { dictionary } = useContext(IntContext);
  return <SigninForm dict={dictionary}></SigninForm>;
}
