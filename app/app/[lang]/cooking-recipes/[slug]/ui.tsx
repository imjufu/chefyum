"use client";

import { use, useContext } from "react";
import { CookingRecipe } from "@/app/lib/definitions";
import { IntContext } from "@/app/lib/providers";
import { t } from "@/app/lib/i18n";

export default function Ui({
  cookingRecipe,
}: {
  cookingRecipe: Promise<CookingRecipe>;
}) {
  const loadedCookingRecipe = use(cookingRecipe);
  const { dictionary: dict } = useContext(IntContext);

  const ingredients = loadedCookingRecipe.ingredients.map((ingredient, idx) => (
    <li key={idx}>
      <span className="text-sm">{ingredient.food.label}</span>&nbsp;
      <span className="font-semibold">
        {ingredient.quantity}
        {t(dict, `cooking_recipe.unit_${ingredient.unit}`)}
      </span>
    </li>
  ));

  const steps = loadedCookingRecipe.steps.map((step, idx) => (
    <li key={idx}>
      <span className="font-semibold">{step.step}</span>&nbsp;{step.instruction}
    </li>
  ));

  const nutritionalValues = Object.keys(
    loadedCookingRecipe.nutritional_values_per_serving,
  ).map((nv, idx) => (
    <li key={idx}>
      <span className="text-sm">{t(dict, `cooking_recipe.${nv}`)}</span>&nbsp;
      <span className="font-semibold">
        {loadedCookingRecipe.nutritional_values_per_serving[nv]}
      </span>
    </li>
  ));

  return (
    <div>
      <h1 className="text-2xl font-semibold text-gray-900">
        {loadedCookingRecipe.title}
      </h1>
      <p className="mt-1 max-w-2xl text-sm text-gray-500">
        {loadedCookingRecipe.description}
      </p>
      <div className="mt-4">
        <dl>
          <div>
            <dt className="mb-1">
              <h3 className="text-xl font-semibold text-gray-900">
                {t(dict, "cooking_recipe.ingredients", {
                  servings: loadedCookingRecipe.servings,
                })}
              </h3>
            </dt>
            <dd className="text-base">
              <ul>{ingredients}</ul>
            </dd>
          </div>
        </dl>
      </div>
      <div className="mt-4">
        <dl>
          <div>
            <dt className="mb-1">
              <h3 className="text-xl font-semibold text-gray-900">
                {t(dict, "cooking_recipe.steps")}
              </h3>
            </dt>
            <dd>
              <ul>{steps}</ul>
            </dd>
          </div>
        </dl>
      </div>
      <div className="mt-4">
        <dl>
          <div>
            <dt className="mb-1">
              <h3 className="text-xl font-semibold text-gray-900">
                {t(dict, "cooking_recipe.nutritional_values")}
              </h3>
              <h4 className="text-sm text-gray-500">
                {t(dict, "cooking_recipe.nutritional_values_description")}
              </h4>
            </dt>
            <dd>
              <ul>{nutritionalValues}</ul>
            </dd>
          </div>
        </dl>
      </div>
    </div>
  );
}
