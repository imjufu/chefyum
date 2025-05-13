import { Suspense } from "react";
import { getCookingRecipe } from "./actions";
import Ui from "./ui";
import Loading from "@/app/components/loading";
import { use } from "react";

export default function Page({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = use(params);
  const cookingRecipe = getCookingRecipe(slug);

  return (
    <Suspense fallback={<Loading />}>
      <Ui cookingRecipe={cookingRecipe}></Ui>
    </Suspense>
  );
}
