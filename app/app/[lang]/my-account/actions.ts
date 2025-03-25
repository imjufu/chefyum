import { apiClient } from "@/app/lib/api";

export async function getMe() {
  return (await apiClient.get("/me")).data;
}
