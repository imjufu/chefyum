import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";
import { match } from "@formatjs/intl-localematcher";
import Negotiator from "negotiator";
import { verifySession } from "@/app/lib/dal";

const locales = ["fr"];
const defaultLocale = "fr-FR";
const publicRoutes = [
  /^\/signin$/,
  /^\/signup$/,
  /^\/reset-password$/,
  /^\/change-password$/,
  /^\/confirmation$/,
  /^\/unlock$/,
  /^\/cooking-recipes/,
];

// Get the preferred locale, similar to the above or using a library
async function getLocale(request: NextRequest) {
  const languages = new Negotiator({
    headers: {
      "accept-language": request.headers.get("accept-language") || undefined,
    },
  }).languages();
  return match(languages, locales, defaultLocale);
}

async function newUrlWithLocale(request: NextRequest) {
  // Check if there is any supported locale in the pathname
  const { pathname } = request.nextUrl;
  const pathnameHasLocale = locales.some(
    (locale) => pathname.startsWith(`/${locale}/`) || pathname === `/${locale}`,
  );
  if (!pathnameHasLocale) {
    // Redirect if there is no locale
    const locale = await getLocale(request);
    request.nextUrl.pathname = `/${locale}${pathname}`;
    // e.g. incoming request is /products
    // The new URL is now /en-US/products
    return request.nextUrl;
  }
  return null;
}

async function hasToBeAuthenticated(request: NextRequest) {
  const { pathname } = request.nextUrl;
  const locale = await getLocale(request);
  const pathnameWithoutLocale = pathname.replace(`/${locale}`, "");

  let isPublicRoute = false;
  if (pathnameWithoutLocale) {
    for (const publicRoute of publicRoutes) {
      if (pathnameWithoutLocale.match(publicRoute)) {
        isPublicRoute = true;
        break;
      }
    }
  } else {
    // Root path is public!
    isPublicRoute = true;
  }

  const { isAuth } = await verifySession();

  return !isPublicRoute && !isAuth;
}

export async function middleware(request: NextRequest) {
  // Redirect if there is no locale in the pathname
  const urlWithLocale = await newUrlWithLocale(request);
  if (urlWithLocale) {
    return NextResponse.redirect(urlWithLocale);
  }

  if (await hasToBeAuthenticated(request)) {
    return NextResponse.redirect(new URL("/signin", request.nextUrl));
  }

  return NextResponse.next();
}

export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - api (API routes)
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico, sitemap.xml, robots.txt (metadata files)
     */
    "/((?!api|_next/static|_next/image|assets|favicon.ico|sitemap.xml|robots.txt).*)",
  ],
};
