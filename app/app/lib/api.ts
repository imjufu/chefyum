import "server-only";

class Client {
  async post(endpoint: string, jsonBody: object) {
    return await this.send("POST", endpoint, jsonBody);
  }

  async put(endpoint: string, jsonBody: object) {
    return await this.send("PUT", endpoint, jsonBody);
  }

  async send(method: "POST" | "PUT", endpoint: string, jsonBody: object) {
    return await fetch(this.getUrl(endpoint), {
      method,
      body: JSON.stringify(jsonBody),
      headers: this.defaultHeaders(),
    });
  }

  getUrl(endpoint: string) {
    const baseUrl = process.env.API_BASE_URL;
    if (!baseUrl) throw new Error("Env var API_BASE_URL is missing!");
    return `${baseUrl}/api/v1/${endpoint}`;
  }

  defaultHeaders() {
    return {
      "Content-Type": "application/json",
    };
  }
}

export const apiClient = new Client();
