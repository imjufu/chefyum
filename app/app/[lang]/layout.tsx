import type { Metadata } from "next";
import "./globals.scss";
import Navbar from "./components/navbar";
import { AppContextProvider } from "@/app/lib/providers";
import { getDictionary, Locales } from "@/app/[lang]/dictionaries";
import { verifySession } from "../lib/dal";

export const metadata: Metadata = {
  title: "Chef Yum",
};

export default async function RootLayout({
  children,
  params,
}: Readonly<{
  children: React.ReactNode;
  params: Promise<{ lang: Locales }>;
}>) {
  const session = await verifySession();
  const lang = (await params).lang;
  const dictionary = await getDictionary(lang);

  return (
    <html lang={lang} className="h-full">
      <body className="h-full antialiased">
        <div className="min-h-full">
          <AppContextProvider session={session} dictionary={dictionary}>
            <Navbar />
            <main>
              <div className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:px-8">
                {children}
              </div>
            </main>
          </AppContextProvider>
        </div>
      </body>
    </html>
  );
}
