# 🚀 Quick Deploy Guide - 5 Minutes to Production

## Step 1: Generate Secrets (1 minute)

```bash
# Run these in your terminal
openssl rand -base64 32   # Copy output → SESSION_SECRET
openssl rand -base64 32   # Copy output → JWT_SECRET
```

## Step 2: Deploy Backend to Render (2 minutes)

1. Go to https://render.com → Sign in
2. Click "New +" → "Web Service"
3. Connect your GitHub repo
4. **Fill in:**
   - **Name:** `society-subscription-backend`
   - **Build Command:** `npm install`
   - **Start Command:** `node server.js`
   - **Plan:** Free (or paid for 24/7 uptime)

5. **Add Environment Variables:**
   ```
   NODE_ENV              = production
   PORT                  = 5000
   DATABASE_URL          = postgresql://neondb_owner:password@host/neondb?sslmode=require
   SESSION_SECRET        = (your generated secret)
   JWT_SECRET            = (your generated secret)
   FRONTEND_URL          = https://society-subscription-management-nu.vercel.app
   ```

6. Click **"Create Web Service"**
7. **Wait 5-10 minutes** for deployment
8. **Copy your URL** (e.g., `https://xxx.onrender.com`)

## Step 3: Deploy Frontend to Vercel (1 minute)

1. Go to https://vercel.com → Sign in
2. Click "Add New" → "Project"
3. Import your GitHub repo
4. **Keep defaults** (auto-detects Next.js)
5. **Click "Environment Variables"**
6. **Add one variable:**
   ```
   NEXT_PUBLIC_API_URL = https://xxx.onrender.com
   ```
   (Use the URL from Step 2)

7. Click **"Deploy"**
8. **Wait 2-3 minutes** for deployment
9. **Visit your live app:** https://society-subscription-management-nu.vercel.app

## Step 4: Test (1 minute)

1. **Admin Login:** https://society-subscription-management-nu.vercel.app/admin/login
   - Click "Sign in with Google"
   - Test dashboard → view stats

2. **Resident Login:** https://society-subscription-management-nu.vercel.app/login
   - Use any resident email + password from database
   - Test dashboard → view subscriptions
   - Test payment flow

3. **Check for errors:** Press F12 → Console tab
   - Should see NO CORS errors
   - Sessions should persist across page refreshes

## Troubleshooting

| Error | Fix |
|-------|-----|
| **CORS error** | Check `FRONTEND_URL` env var matches your Vercel domain |
| **Session not saving** | Check `credentials: "include"` in fetch calls (should already be there) |
| **500 error on login** | Check `SESSION_SECRET` and `JWT_SECRET` are set in Render dashboard |
| **Database connection error** | Verify `DATABASE_URL` format and Neon connection is active |

## URLs After Deployment

```
📱 Frontend (Vercel):
https://society-subscription-management-nu.vercel.app

🔌 Backend (Render):
https://your-service-name.onrender.com

🗄️ Database (Neon):
ep-polished-cloud-an8xmw4g-pooler.c-6.us-east-1.aws.neon.tech
```

## Architecture

```
┌─────────────────────────────────────┐
│  Your Users                         │
│  (Browsers/Mobile)                  │
└────────────┬────────────────────────┘
             │ HTTPS + Cookies
             │
┌────────────▼────────────────────────┐
│  Frontend (Vercel)                  │
│  Next.js 16 + React                 │
│  - Admin: Google OAuth              │
│  - Resident: Email/Password         │
└────────────┬────────────────────────┘
             │ Secure REST API
             │
┌────────────▼────────────────────────┐
│  Backend (Render)                   │
│  Node.js + Express                  │
│  - JWT Tokens + Sessions            │
│  - bcrypt Password Hashing          │
└────────────┬────────────────────────┘
             │ SSL/TLS
             │
┌────────────▼────────────────────────┐
│  Database (Neon)                    │
│  PostgreSQL Serverless              │
│  - 6 Tables                         │
│  - Connection Pooling               │
│  - Auto Backups                     │
└─────────────────────────────────────┘
```

## What's Configured ✅

✅ **Backend:**
- Express.js server ready for Render
- Session authentication (bcrypt + JWT)
- CORS with environment-based origins
- All database queries use `public.schema` qualification
- Environment variables for all secrets

✅ **Frontend:**
- Next.js configured for Vercel
- Dynamic API URL from environment
- `credentials: "include"` on all API calls
- Session persistence across page refreshes
- Google OAuth for admin login

✅ **Database:**
- Neon PostgreSQL connection
- SSL/TLS required
- Connection pooling enabled
- 6 tables with full schema loaded
- All queries optimized for Neon

✅ **Security:**
- HTTPS only in production
- HTTP-only secure cookies
- Cross-origin session support (SameSite=None)
- Strong session secrets
- Environment-based secrets (never committed)

## No Additional Configuration Needed!

Everything is ready to go. Just:
1. Generate 2 secrets
2. Deploy backend to Render
3. Update frontend API URL
4. Deploy frontend to Vercel
5. Test the app

## Questions?

Refer to:
- `DEPLOYMENT.md` - Full deployment guide
- `PRODUCTION_READY.md` - Configuration checklist
- `CHANGES_SUMMARY.md` - What was changed
