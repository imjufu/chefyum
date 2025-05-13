"use client";

import Ui from "./ui";
import { useContext } from "react";
import { AuthContext, IntContext } from "@/app/lib/providers";
import { redirect } from "next/navigation";

export default function Page() {
  const { currentSession } = useContext(AuthContext);
  if (currentSession?.isAuth) redirect("/");

  const { dictionary } = useContext(IntContext);
  return <Ui dict={dictionary}></Ui>;
}
