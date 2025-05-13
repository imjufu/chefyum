"use client";

import { useContext } from "react";
import { AuthContext, IntContext } from "@/app/lib/providers";
import { redirect } from "next/navigation";
import { Ui } from "./ui";

export default function Page() {
  const { currentSession } = useContext(AuthContext);
  if (currentSession?.isAuth) redirect("/");

  const { dictionary } = useContext(IntContext);
  return <Ui dict={dictionary}></Ui>;
}
