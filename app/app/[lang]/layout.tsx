import type { Metadata } from "next";
import "./globals.scss";
import Navbar from "@/app/components/navbar";
import { AppContextProvider } from "@/app/lib/providers";
import { getDictionary, Locales } from "@/app/lib/dictionaries";
import { verifySession } from "@/app/lib/dal";
import FlashMessage from "@/app/components/flashMessage";

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
  const flashMessage = null;

  return (
    <html lang={lang} className="h-full">
      <body className="h-full antialiased">
        <div className="min-h-full">
          <AppContextProvider
            session={session}
            dictionary={dictionary}
            flashMessage={flashMessage}
          >
            <Navbar />
            <main>
              <div className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:px-8">
                {children}
              </div>
            </main>
            <FlashMessage />
          </AppContextProvider>
        </div>
      </body>
    </html>
  );
}
