import { redirectIfAlreadyConnected } from "@/app/lib/dal";
import { SigninForm } from "./ui";
import { getDictionary, Locales } from "../dictionaries";

export default async function Signin({
  params,
}: {
  params: Promise<{ lang: Locales }>;
}) {
  const { lang } = await params;
  const dict = await getDictionary(lang);
  await redirectIfAlreadyConnected("/");

  return <SigninForm dict={dict}></SigninForm>;
}
