"use server";

import { apiClient } from "@/app/lib/api";

export async function getCookingRecipes() {
  return (await apiClient.get("/cooking-recipes")).data;
}
