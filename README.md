# Society Subscription Management

A full-stack society management app with an Admin Panel and Resident Portal.

## Tech Stack

- Frontend: Next.js, Tailwind CSS
- Backend: Node.js, Express.js
- Database: PostgreSQL
- Admin Auth: NextAuth.js + Google OAuth
- Resident Auth: Email + password (bcrypt)

## Setup

**Prerequisites:** Node.js 18+, PostgreSQL

```bash
# Backend
cd backend && npm install && node server.js
# Runs on http://localhost:5000

# Frontend
cd frontend && npm install && npm run dev
# Runs on http://localhost:3000
```

## Environment Variables

`backend/.env`
```
JWT_SECRET=your_jwt_secret
```

`frontend/.env.local`
```
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
NEXTAUTH_SECRET=
NEXTAUTH_URL=http://localhost:3000
ADMIN_EMAIL=your_admin_google_email
```

## Admin Panel

Login via Google at `/admin/login`. Only `ADMIN_EMAIL` is allowed.

- Dashboard — overview stats, charts, recent transactions
- Flats — add, edit, delete flats and set resident passwords
- Plans — manage monthly subscription amounts per flat type
- Monthly — view and manage subscription status per month
- Payments — record payments for pending months
- Notifications — send notices to all or specific flats
- Reports — monthly and yearly reports, export PDF/CSV
- Profile — account info and sign out

## Resident Portal

Login with email and password at `/login`.

- Dashboard — pending dues, recent payments
- Subscriptions — full history with paid/pending status
- Pay Now — pay a pending month
- Profile — update phone number or change password
- Notifications — view admin notices
