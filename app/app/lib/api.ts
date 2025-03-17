import "server-only";

class Client {
  getUrl(endpoint: string) {
    const baseUrl = process.env.API_BASE_URL;
    if (!baseUrl) throw new Error("Env var API_BASE_URL is missing!");
    return `${baseUrl}/api/v1/${endpoint}`;
  }

  async post(endpoint: string, jsonBody: object) {
    return await fetch(this.getUrl(endpoint), {
      method: "POST",
      body: JSON.stringify(jsonBody),
      headers: {
        "Content-Type": "application/json",
      },
    });
  }
}

export const apiClient = new Client();
