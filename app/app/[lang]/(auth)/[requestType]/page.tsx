import { AuthRequestForm } from "./ui";

export function generateStaticParams() {
  return [
    { lang: "fr", requestType: "reset-password" },
    { lang: "fr", requestType: "confirmation" },
    { lang: "fr", requestType: "unlock" },
  ];
}

export default async function Request({
  params,
}: {
  params: Promise<{ requestType: string }>;
}) {
  const { requestType } = await params;
  return <AuthRequestForm requestType={requestType}></AuthRequestForm>;
}
