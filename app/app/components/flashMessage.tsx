"use client";

import { FlashMessageContext } from "@/app/lib/providers";
import { useContext } from "react";
import Alert from "./alert";

export default function FlashMessage() {
  const { flashMessage } = useContext(FlashMessageContext);

  return (
    flashMessage && (
      <div className="fixed top-0 right-0 left-0 flex flex-col flex-col-reverse gap-3 items-center p-3">
        <Alert className="w-sm border shadow-md" level={flashMessage.level}>
          {flashMessage.message}
        </Alert>
      </div>
    )
  );
}
