import type { Metadata } from "next";
import "./globals.scss";
import Navbar from "@/app/components/navbar";
import Footer from "@/app/components/footer";
import { AppContextProvider } from "@/app/lib/providers";
import { getDictionary, Locales } from "@/app/lib/dictionaries";
import { verifySession } from "@/app/lib/dal";
import FlashMessage from "@/app/components/flashMessage";
import { Chewy } from "next/font/google";

const chewy = Chewy({
  weight: "400",
  subsets: ["latin"],
});

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
        <div className="min-h-full py-3 mx-auto max-w-7xl">
          <div className="bg-white rounded-lg p-3">
            <AppContextProvider
              session={session}
              dictionary={dictionary}
              flashMessage={flashMessage}
            >
              <Navbar
                className={`bg-leaf-green text-xl mb-3 rounded-lg ${chewy.className}`}
              />
              <main className="min-h-[90vh] text-neutral-800">{children}</main>
              <Footer
                className={`bg-black rounded-lg mt-3 text-white rounded-lg`}
              />
              <FlashMessage />
            </AppContextProvider>
          </div>
        </div>
      </body>
    </html>
  );
}
