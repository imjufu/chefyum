"use client";

import { PropsWithChildren, useState } from "react";
import {
  XMarkIcon,
  ExclamationTriangleIcon,
  CheckCircleIcon,
} from "@heroicons/react/24/outline";

export default function Alert({
  type,
  className,
  children,
}: PropsWithChildren<{ className?: string; type: "success" | "error" }>) {
  const [isOpen, setIsOpen] = useState(true);

  const classNames = [className];
  let icon = null;
  if (type == "success") {
    classNames.push("alert-success");
    icon = <CheckCircleIcon aria-hidden="true" className="block size-6" />;
  } else if (type == "error") {
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
