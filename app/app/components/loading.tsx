"use client";

import { IntContext } from "@/app/lib/providers";
import { ArrowPathIcon } from "@heroicons/react/24/outline";
import { useContext } from "react";
import { t } from "@/app/lib/i18n";

export default function Loading() {
  const { dictionary: dict } = useContext(IntContext);

  return (
    <div className="flex justify-center items-center gap-1 text-sm text-gray-900/75">
      <ArrowPathIcon aria-hidden="true" className="block size-5" />
      <p>{t(dict, "common.loading")}</p>
    </div>
  );
}
