"use client";

import { PropsWithChildren, useState } from "react";
import {
  XMarkIcon,
  ExclamationTriangleIcon,
  CheckCircleIcon,
} from "@heroicons/react/24/outline";
import { AlertLevel } from "@/app/lib/definitions";

export default function Alert({
  level,
  className,
  children,
}: PropsWithChildren<{ className?: string; level: AlertLevel }>) {
  const [isOpen, setIsOpen] = useState(true);

  const classNames = [className];
  let icon = null;
  if (level == "success") {
    classNames.push("alert-success");
    icon = <CheckCircleIcon aria-hidden="true" className="block size-6" />;
  } else if (level == "error") {
    classNames.push("alert-error");
    icon = (
      <ExclamationTriangleIcon aria-hidden="true" className="block size-6" />
    );
  }

  return (
    isOpen && (
      <div className={classNames.join(" ")}>
        <div className="pl-4 py-4">{icon}</div>
        <div className="grow pl-4 py-4">
          {children}
          <a href="#" className="close"></a>
        </div>
        <div
          className="self-start p-2 cursor-pointer"
          onClick={() => setIsOpen(false)}
        >
          <XMarkIcon aria-hidden="true" className="block size-4" />
        </div>
      </div>
    )
  );
}
