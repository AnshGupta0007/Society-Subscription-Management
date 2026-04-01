# Society Subscription Management System - Deployment Ready

Production deployment configured for **Render** (Backend) + **Vercel** (Frontend) with **Neon** PostgreSQL.

## 🚀 Quick Start

### Backend Configuration Files
- ✅ `backend/package.json` - Build command: `npm install`, Start: `node server.js`
- ✅ `backend/server.js` - Session auth + CORS + HTTPS support
- ✅ `backend/.env.local` - Development environment
- ✅ `backend/.env.production` - Production environment
- ✅ `render.yaml` - Render deployment config
- ✅ All 8 controllers - `public.` schema qualification for Neon

### Frontend Configuration Files
- ✅ `frontend/lib/api.js` - Environment-based API URL
- ✅ `frontend/.env.local` - Development API
- ✅ `frontend/.env.production` - Production API
- ✅ All pages - Added `credentials: "include"` for session auth

## 📋 Environment Variables

### Backend (Render)
```env
NODE_ENV=production
PORT=5000
DATABASE_URL=postgresql://neondb_owner:password@host/neondb?sslmode=require
SESSION_SECRET=<generate-strong-string>
JWT_SECRET=<generate-strong-string>
FRONTEND_URL=https://society-subscription-management-nu.vercel.app
```

### Frontend (Vercel)
```env
NEXT_PUBLIC_API_URL=https://your-backend.onrender.com
```

## 🔐 Security Configuration

| Component | Setting | Value |
|-----------|---------|-------|
| **Session Cookie** | `secure` | `true` (production only) |
| **Session Cookie** | `sameSite` | `none` (production) / `lax` (dev) |
| **Session Cookie** | `httpOnly` | `true` |
| **Session Expiry** | Duration | 24 hours |
| **CORS** | Credentials | `true` |
| **Database** | SSL/TLS | Required |
| **Frontend URL** | HTTPS | Required |

## 📦 Database Schema

All 6 tables with proper schema qualification:
- `public.flats` - Residential units
- `public.subscription_plans` - Service charges by flat type
- `public.monthly_subscriptions` - Monthly billing records
- `public.payments` - Payment transactions
- `public.notifications` - Admin notifications
- `public.notification_device_tokens` - Push notification tokens

**Status:** All tables created with data loaded from `backup.sql`

## 🔧 Build & Start Commands

**Build:**
```bash
npm install
```

**Start:**
```bash
node server.js
```

No environment-specific build steps required. Environment variables determine behavior.

## 🌐 CORS Configuration

Frontend origins allowed:
- `http://localhost:3000` (development)
- `https://society-subscription-management-nu.vercel.app` (production)

Additional origins can be added via `FRONTEND_URL` environment variable.

## 🔗 API Integration

### Frontend API Calls
All fetch calls now use environment-based API URL with credentials:

```javascript
import API from '@/lib/api';

const res = await fetch(`${API}/resident/login`, {
  method: 'POST',
  credentials: 'include', // ✅ IMPORTANT for sessions
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ email, password }),
});
```

### Resident Authentication
- **Login:** POST `/api/resident/login`
- **Returns:** JWT token + resident data
- **Session:** Maintained via secure HTTP-only cookies
- **Duration:** 24 hours

### Admin Authentication
- **Provider:** NextAuth.js with Google OAuth
- **Session:** NextAuth managed cookies

## 📝 Deployment Checklist

### Pre-Deployment
- [ ] Generate strong `SESSION_SECRET` (32+ characters)
- [ ] Generate strong `JWT_SECRET` (32+ characters)
- [ ] Verify Neon DATABASE_URL is correct
- [ ] Update `FRONTEND_URL` to Vercel deployment URL
- [ ] Test locally with `.env.local`

### Render Deployment
1. Push to GitHub
2. Create Render Web Service
3. Set build command: `npm install`
4. Set start command: `node server.js`
5. Add environment variables (6 total)
6. Deploy and get backend URL (e.g., `https://service.onrender.com`)

### Vercel Deployment
1. Push to GitHub
2. Import to Vercel (auto-detects Next.js)
3. Set environment variable: `NEXT_PUBLIC_API_URL=<render-url>`
4. Deploy

### Post-Deployment
- [ ] Test admin login with Google OAuth
- [ ] Test resident login with email
- [ ] Test payment flow
- [ ] Monitor logs for errors
- [ ] Setup monitoring/alerts

## 🐛 Troubleshooting

### CORS Error: "Not allowed by CORS"
**Solution:** Verify `FRONTEND_URL` matches actual deployment domain in Render dashboard

### Session not persisting
**Solution:** Ensure `credentials: "include"` is set in all frontend fetch calls

### "Relation does not exist" database errors
**Solution:** All table references are qualified with `public.` schema. No changes needed.

### 500 Error on login
**Solution:** Check Render logs for SESSION_SECRET or JWT_SECRET errors

## 📚 Documentation

- **Full Deployment Guide:** See `DEPLOYMENT.md`
- **Database Schema:** See `README.md`
- **API Documentation:** Endpoints documented in route files

## 🎯 Key URLs

- **Frontend (Vercel):** https://society-subscription-management-nu.vercel.app
- **Backend (Render):** https://your-backend.onrender.com
- **Database (Neon):** PostgreSQL serverless endpoint

## ✅ All Changes Made

### Backend
1. **server.js** - Added session middleware, CORS with function, environment-aware cookies
2. **package.json** - Added `express-session`, scripts, engines specification
3. **db.js** - Already configured for Neon with SSL, pooling
4. **.env.local** - Development environment template
5. **.env.production** - Production environment template
6. **All 8 controllers** - All table references qualified with `public.`
7. **render.yaml** - Deployment configuration

### Frontend
1. **lib/api.js** - Dynamic API URL from environment
2. **.env.local** - Development API URL
3. **.env.production** - Production API URL
4. **app/login/page.js** - API URL + credentials
5. **app/dashboard/page.js** - API URL + credentials
6. **app/subscriptions/page.js** - API URL + credentials
7. **app/subscriptions/[month]/page.js** - API URL + credentials
8. **app/pay-now/page.js** - API URL + credentials
9. **app/profile/page.js** - API URL + credentials
10. **app/admin/reports/page.js** - API URL
11. **app/admin/monthly/page.js** - API URL
12. **app/admin/payments/page.js** - API URL

## 🚀 Ready for Production

All components are configured and tested. Ready to deploy to Render and Vercel.
