import { redirectIfAlreadyConnected } from "@/app/lib/dal";
import { SigninForm } from "./ui";

export default async function Signin() {
  await redirectIfAlreadyConnected("/");

  return <SigninForm></SigninForm>;
}
