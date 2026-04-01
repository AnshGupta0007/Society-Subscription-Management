# Deployment Guide: Render + Vercel

## Backend Deployment (Render)

### Prerequisites
- Neon PostgreSQL database URL
- Render account (https://render.com)

### Step 1: Prepare Environment Variables

Before deploying, generate secure secrets:

```bash
# Generate SESSION_SECRET
openssl rand -base64 32

# Generate JWT_SECRET
openssl rand -base64 32
```

### Step 2: Deploy to Render

1. **Push to GitHub**
   ```bash
   git add .
   git commit -m "Configure for Render deployment"
   git push origin main
   ```

2. **Create Render Service**
   - Go to https://render.com
   - Click "New +" → "Web Service"
   - Connect your GitHub repository
   - Select the branch (main)

3. **Configure Build & Start Commands**
   ```
   Build Command: npm install
   Start Command: node server.js
   ```

4. **Set Environment Variables in Render Dashboard**
   ```
   NODE_ENV = production
   PORT = 5000
   DATABASE_URL = postgresql://neondb_owner:password@host/neondb?sslmode=require
   SESSION_SECRET = (generated value from step 1)
   JWT_SECRET = (generated value from step 1)
   FRONTEND_URL = https://society-subscription-management-nu.vercel.app
   ```

5. **Deploy**
   - Click "Create Web Service"
   - Render will automatically build and deploy
   - Your backend URL will be: `https://your-service-name.onrender.com`

### Step 3: Update Frontend Environment

After getting your Render backend URL:

**Update `frontend/.env.production`:**
```
NEXT_PUBLIC_API_URL=https://your-service-name.onrender.com
```

## Frontend Deployment (Vercel)

### Step 1: Deploy to Vercel

```bash
cd frontend
npm install
vercel --prod
```

Or connect GitHub to Vercel:
1. Go to https://vercel.com
2. Click "New Project"
3. Import GitHub repository
4. Vercel auto-detects Next.js configuration
5. Deploy

### Step 2: Set Environment Variables in Vercel Dashboard

```
NEXT_PUBLIC_API_URL = https://your-service-name.onrender.com
```

## Architecture

```
┌─────────────────────────────────────────┐
│ Frontend (Vercel)                       │
│ https://...vercel.app                   │
│ - Next.js 16.1.6 with Turbopack         │
│ - NextAuth.js (Admin OAuth)             │
│ - React Components                      │
└──────────────┬──────────────────────────┘
               │ HTTPS + credentials: true
               │
┌──────────────▼──────────────────────────┐
│ Backend (Render)                        │
│ https://...onrender.com                 │
│ - Express.js Server                     │
│ - Session Auth (bcrypt + JWT)           │
│ - REST API                              │
└──────────────┬──────────────────────────┘
               │ SSL/TLS Required
               │
┌──────────────▼──────────────────────────┐
│ Database (Neon)                         │
│ PostgreSQL Serverless                   │
│ - 6 tables with full schema              │
│ - Connection pooling enabled            │
└─────────────────────────────────────────┘
```

## Security Checklist

✅ **CORS Configuration**
- Frontend URL added to allowedOrigins
- credentials: true enabled
- Secure cookie flags set

✅ **Session Security**
- `secure: true` in production (HTTPS only)
- `sameSite: "none"` for cross-origin
- `httpOnly: true` (not accessible to JavaScript)
- 24-hour expiry

✅ **Database**
- SSL/TLS required (Neon)
- Connection pooling configured
- All table names qualified with `public.` schema

✅ **Environment Variables**
- SESSION_SECRET: Strong random string
- JWT_SECRET: Strong random string
- Never commit .env files

## Testing

### Test Backend on Render

```bash
# Test database connection
curl https://your-service-name.onrender.com/api/flats/count

# Test resident login
curl -X POST https://your-service-name.onrender.com/api/resident/login \
  -H "Content-Type: application/json" \
  -d '{"email":"resident@example.com","password":"password"}'
```

### Test Frontend on Vercel

1. Visit https://society-subscription-management-nu.vercel.app
2. Admin Login: Test NextAuth.js Google OAuth
3. Resident Login: Test bcrypt + JWT auth
4. Dashboard: Verify API calls work (CORS + credentials)
5. Payments: Test transaction flow

## Troubleshooting

### CORS Error
- Check `FRONTEND_URL` env var matches actual domain
- Verify `credentials: true` in frontend fetch calls
- Check Render CORS settings allow HTTPS

### 42P01 "Relation does not exist"
- All table references must use `public.schema_name`
- Check that migrations were applied to Neon

### Session not persisting
- Verify `secure: true` only in production
- Check cookie `sameSite` and `httpOnly` settings
- Ensure credentials passed in fetch: `credentials: "include"`

### Database Connection Timeout
- Check `DATABASE_URL` format is correct
- Verify Neon connection pool settings
- Check firewall allows outbound to Neon

## Post-Deployment

1. **Monitor logs** in Render dashboard
2. **Test key workflows**: Admin CRUD, Resident login, Payments
3. **Monitor performance**: Check response times and error rates
4. **Setup alerts**: Email notifications for deploy failures
5. **Backup database**: Regular automated backups (Neon handles this)

## Useful Links

- Render Docs: https://render.com/docs
- Vercel Docs: https://vercel.com/docs
- Neon Docs: https://neon.tech/docs
- Express.js: https://expressjs.com
- Next.js: https://nextjs.org/docs
