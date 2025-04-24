import { Suspense } from "react";
import { getCookingRecipe } from "./actions";
import CookingRecipe from "./ui";
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
      <CookingRecipe cookingRecipe={cookingRecipe}></CookingRecipe>
    </Suspense>
  );
}
