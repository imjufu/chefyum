import { Suspense } from "react";
import { getCookingRecipes } from "./actions";
import List from "./ui";
import Loading from "@/app/components/loading";

export default function Page() {
  const cookingRecipes = getCookingRecipes();

  return (
    <Suspense fallback={<Loading />}>
      <List cookingRecipes={cookingRecipes}></List>
    </Suspense>
  );
}
