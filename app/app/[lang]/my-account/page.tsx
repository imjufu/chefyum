import { Suspense } from "react";
import { getMe } from "./actions";
import Me from "./ui";
import Loading from "@/app/components/loading";

export default function MyAccount() {
  const me = getMe();

  return (
    <Suspense fallback={<Loading />}>
      <Me me={me}></Me>
    </Suspense>
  );
}
