import NextAuth from "next-auth";
import GoogleProvider from "next-auth/providers/google";

const ADMIN_EMAIL = process.env.ADMIN_EMAIL;

const normalizeEmail = (value) =>
  typeof value === "string" ? value.trim().toLowerCase() : "";

const handler = NextAuth({
  providers: [
    GoogleProvider({
      clientId: process.env.GOOGLE_CLIENT_ID,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    }),
  ],
  secret: process.env.NEXTAUTH_SECRET,
  callbacks: {
    async signIn({ user }) {
      const adminEmail = normalizeEmail(ADMIN_EMAIL);
      const userEmail = normalizeEmail(user?.email);
      if (!adminEmail) return false;
      return userEmail === adminEmail;
    },
    async session({ session, token }) {
      session.user.email = token.email;
      session.user.isAdmin = Boolean(token.isAdmin);
      return session;
    },
    async jwt({ token, user }) {
      if (user) token.email = user.email;
      token.isAdmin = normalizeEmail(token.email) === normalizeEmail(ADMIN_EMAIL);
      return token;
    },
  },
  pages: {
    error: "/admin/login",
  },
});

export { handler as GET, handler as POST };
