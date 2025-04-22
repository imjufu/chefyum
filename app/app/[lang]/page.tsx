"use client";

import { t } from "@/app/lib/i18n";
import { useContext } from "react";
import { IntContext } from "@/app/lib/providers";

export default function Home() {
  const { dictionary } = useContext(IntContext);

  return (
    <div
      className="home"
      dangerouslySetInnerHTML={{ __html: t(dictionary, "home.pitch") }}
    ></div>
  );
}
