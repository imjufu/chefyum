import { Suspense } from "react";
import { getMe } from "./actions";
import Ui from "./ui";
import Loading from "@/app/components/loading";

export default function Page() {
  const me = getMe();

  return (
    <Suspense fallback={<Loading />}>
      <Ui me={me}></Ui>
    </Suspense>
  );
}
