"use client";

import { use } from "react";
import { CookingRecipe } from "@/app/lib/definitions";
import Link from "next/link";
import Image from "next/image";

export default function Ui({
  cookingRecipes,
}: {
  cookingRecipes: Promise<CookingRecipe[]>;
}) {
  const loadedCookingRecipes = use(cookingRecipes);
  const lines = loadedCookingRecipes.map((cookingRecipe) => (
    <div key={cookingRecipe.id} className="shadow-md rounded-lg">
      <div className="rounded-t-lg bg-neutral-200 h-30 relative">
        {cookingRecipe.photo_url ? (
          <Image
            className="rounded-t-lg"
            alt={cookingRecipe.title}
            src={cookingRecipe.photo_url}
            fill={true}
            objectFit={"cover"}
          />
        ) : null}
      </div>
      <div className="p-3 text-center">
        <Link href={`/cooking-recipes/${cookingRecipe.slug}`}>
          {cookingRecipe.title}
        </Link>
      </div>
    </div>
  ));

  return <div className="grid grid-cols-5 gap-4">{lines}</div>;
}
