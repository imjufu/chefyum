import "server-only";
import { getSession } from "./session";
import { ApiResponse } from "./definitions";

class Client {
  async get(endpoint: string) {
    const res = await fetch(this.getUrl(endpoint), {
      headers: await this.defaultHeaders(),
    });
    return await res.json();
  }

  async post(endpoint: string, jsonBody: object) {
    return await this.send("POST", endpoint, jsonBody);
  }

  async put(endpoint: string, jsonBody: object) {
    return await this.send("PUT", endpoint, jsonBody);
  }

  async send(
    method: "POST" | "PUT",
    endpoint: string,
    jsonBody: object,
  ): Promise<ApiResponse> {
    const res = await fetch(this.getUrl(endpoint), {
      method,
      body: JSON.stringify(jsonBody),
      headers: await this.defaultHeaders(),
    });
    return await res.json();
  }

  getUrl(endpoint: string) {
    const baseUrl = process.env.API_BASE_URL;
    if (!baseUrl) throw new Error("Env var API_BASE_URL is missing!");
    return `${baseUrl}/api/v1${endpoint}`;
  }

  async defaultHeaders(): Promise<Headers> {
    const headers = new Headers({
      Accept: "application/json",
      "Content-Type": "application/json",
    });
    const session = await getSession();
    if (session) {
      headers.set("Authorization", `Bearer ${session.token}`);
    }
    return headers;
  }
}

export const apiClient = new Client();
