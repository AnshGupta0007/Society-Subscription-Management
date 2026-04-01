import { NextResponse } from "next/server";
import { getToken } from "next-auth/jwt";

const ADMIN_EMAIL = process.env.ADMIN_EMAIL;

const RESIDENT_PROTECTED = [
  "/dashboard",
  "/subscriptions",
  "/pay-now",
  "/profile",
  "/notifications",
];

export async function middleware(req) {
  const { pathname } = req.nextUrl;

  // ✅ Get token with secret (IMPORTANT)
  const token = await getToken({
    req,
    secret: process.env.NEXTAUTH_SECRET,
  });

  /* ── Allow NextAuth routes (CRITICAL FIX) ── */
  if (pathname.startsWith("/api/auth")) {
    return NextResponse.next();
  }

  /* ── Resident routes ── */
  const isResidentRoute = RESIDENT_PROTECTED.some(
    (p) => pathname === p || pathname.startsWith(p + "/")
  );

  if (isResidentRoute) {
    const residentSession = req.cookies.get("resident_session");
    if (!residentSession?.value) {
      return NextResponse.redirect(new URL("/login", req.url));
    }
    return NextResponse.next();
  }

  /* ── Admin login page ── */
  if (pathname === "/admin/login") {
    if (token && token.email === ADMIN_EMAIL) {
      return NextResponse.redirect(new URL("/admin/dashboard", req.url));
    }
    return NextResponse.next();
  }

  /* ── Admin protected routes ── */
  if (pathname.startsWith("/admin")) {
    if (!token || token.email !== ADMIN_EMAIL) {
      return NextResponse.redirect(new URL("/admin/login", req.url));
    }
  }

  return NextResponse.next();
}

export const config = {
  matcher: [
    "/admin/:path*",
    "/dashboard",
    "/subscriptions/:path*",
    "/pay-now",
    "/profile",
    "/notifications",
  ],
};