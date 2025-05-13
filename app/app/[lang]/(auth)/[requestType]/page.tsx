import Ui from "./ui";

export function generateStaticParams() {
  return [
    { lang: "fr", requestType: "reset-password" },
    { lang: "fr", requestType: "confirmation" },
    { lang: "fr", requestType: "unlock" },
  ];
}

export default async function Page({
  params,
}: {
  params: Promise<{ requestType: string }>;
}) {
  const { requestType } = await params;
  return <Ui requestType={requestType}></Ui>;
}
