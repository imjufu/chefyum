"use server";

import { apiClient } from "@/app/lib/api";

export async function getCookingRecipe(slug: string) {
  return (await apiClient.get(`/cooking-recipes/${slug}`)).data;
}
