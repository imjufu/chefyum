"use client";

import { use } from "react";
import { CookingRecipe } from "@/app/lib/definitions";
import Link from "next/link";

export default function Ui({
  cookingRecipes,
}: {
  cookingRecipes: Promise<CookingRecipe[]>;
}) {
  const loadedCookingRecipes = use(cookingRecipes);
  const lines = loadedCookingRecipes.map((cookingRecipe) => (
    <li key={cookingRecipe.id}>
      <Link href={`/cooking-recipes/${cookingRecipe.slug}`}>
        {cookingRecipe.title}
      </Link>
    </li>
  ));

  return <ul>{lines}</ul>;
}
