import { Suspense } from "react";
import { getCookingRecipes } from "./actions";
import Ui from "./ui";
import Loading from "@/app/components/loading";

export default function Page() {
  const cookingRecipes = getCookingRecipes();

  return (
    <Suspense fallback={<Loading />}>
      <Ui cookingRecipes={cookingRecipes}></Ui>
    </Suspense>
  );
}
