# Environment Variables Reference

## Backend Environment Variables (Render)

### Required Variables (Must Set)

| Variable | Example | Description |
|----------|---------|-------------|
| `NODE_ENV` | `production` | Controls security settings for cookies |
| `PORT` | `5000` | Server port (Render auto-assigns, keep as 5000) |
| `DATABASE_URL` | `postgresql://user:pass@host/neondb?sslmode=require` | Neon PostgreSQL connection string |
| `SESSION_SECRET` | `1a2b3c4d5e...` | Random string for session signing (32+ chars) |
| `JWT_SECRET` | `9f8e7d6c5b...` | Random string for JWT tokens (32+ chars) |
| `FRONTEND_URL` | `https://society-subscription-management-nu.vercel.app` | Your Vercel frontend domain |

### How to Generate Secrets

```bash
# On Mac/Linux
openssl rand -base64 32

# Output example: "R9kL2pQ8vX1mN7sT4wY6zB3cE5jF9hO2aD4gK7mP0rS2uV8x"

# Use this value for SESSION_SECRET and JWT_SECRET
```

### Render Dashboard Setup

1. Create Web Service
2. Go to "Environment" tab
3. Add each variable one by one:
   - Click "Add Environment Variable"
   - Enter key and value
   - Save

**⚠️ Important:** Never share or commit these values to git!

## Frontend Environment Variables (Vercel)

### Required Variable

| Variable | Example | Description |
|----------|---------|-------------|
| `NEXT_PUBLIC_API_URL` | `https://society-subscription-backend-xxx.onrender.com` | Your Render backend URL |

### Why `NEXT_PUBLIC_` prefix?

The `NEXT_PUBLIC_` prefix means this variable is available to the browser. It's safe because it just points to your backend URL (doesn't contain secrets).

### Vercel Dashboard Setup

1. Import GitHub repo
2. Go to "Environment Variables"
3. Add:
   - Key: `NEXT_PUBLIC_API_URL`
   - Value: `https://your-backend.onrender.com`
4. Deploy

## Local Development Environment

### Backend (.env.local or .env)

```env
# Development settings
NODE_ENV=development
PORT=5000

# Local Neon connection (copy from Neon console)
DATABASE_URL=postgresql://neondb_owner:password@ep-polished-cloud-an8xmw4g-pooler.c-6.us-east-1.aws.neon.tech/neondb?sslmode=require

# Can be simple for development
SESSION_SECRET=dev_secret_key_change_in_production
JWT_SECRET=dev_jwt_secret_key_change_in_production

# Point to local frontend
FRONTEND_URL=http://localhost:3000
```

### Frontend (.env.local)

```env
# Development - point to localhost backend
NEXT_PUBLIC_API_URL=http://localhost:5000
```

## Production Environment

### Backend (.env.production or Render Dashboard)

```env
# Production settings
NODE_ENV=production
PORT=5000

# Neon PostgreSQL connection
DATABASE_URL=postgresql://neondb_owner:strong_password@ep-polished-cloud-an8xmw4g-pooler.c-6.us-east-1.aws.neon.tech/neondb?sslmode=require

# Strong random strings (use `openssl rand -base64 32`)
SESSION_SECRET=R9kL2pQ8vX1mN7sT4wY6zB3cE5jF9hO2aD4gK7mP0rS2uV8x
JWT_SECRET=9f8e7d6c5b4a3f2e1d0c9b8a7f6e5d4c3b2a1f0e9d8c7b6a

# Your Vercel frontend domain
FRONTEND_URL=https://society-subscription-management-nu.vercel.app
```

### Frontend (.env.production or Vercel Dashboard)

```env
# Production - point to Render backend
NEXT_PUBLIC_API_URL=https://society-subscription-backend-xxx.onrender.com
```

## Where to Get Values

### DATABASE_URL (Neon)

1. Go to https://console.neon.tech
2. Select your project
3. Go to "Connection String"
4. Copy the full connection string
5. Paste into `DATABASE_URL`

Example format:
```
postgresql://neondb_owner:npg_sU6p8gTawSit@ep-polished-cloud-an8xmw4g-pooler.c-6.us-east-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require
```

### FRONTEND_URL (Vercel)

1. Deploy frontend to Vercel first
2. Copy your deployment URL from Vercel dashboard
3. Example: `https://society-subscription-management-nu.vercel.app`

### Render Backend URL

1. After deploying to Render
2. URL shown in Render dashboard
3. Example: `https://society-subscription-backend-abc123.onrender.com`

## Environment Variable Checklist

### Before Render Deployment
- [ ] Generated `SESSION_SECRET` (32+ random chars)
- [ ] Generated `JWT_SECRET` (32+ random chars)
- [ ] Have Neon `DATABASE_URL`
- [ ] Know your Vercel frontend URL
- [ ] Set `NODE_ENV=production`

### Before Vercel Deployment
- [ ] Know your Render backend URL
- [ ] Set `NEXT_PUBLIC_API_URL` to Render URL

### Local Development
- [ ] Created `.env.local` in both backend and frontend
- [ ] Added localhost URLs for development

## Security Best Practices

✅ **DO:**
- Generate strong random secrets (use `openssl rand`)
- Store secrets in Render/Vercel dashboards (never in code)
- Use environment variables for all sensitive data
- Rotate secrets regularly
- Use HTTPS-only in production

❌ **DON'T:**
- Commit `.env` or `.env.production` files
- Use simple passwords like "password123"
- Share Render/Vercel dashboard credentials
- Hardcode secrets in code
- Use same secret for dev and production

## Troubleshooting

### "SESSION_SECRET is undefined"
**Problem:** Variable not set in Render dashboard
**Solution:** Add SESSION_SECRET to Render environment variables

### "DATABASE_URL is invalid"
**Problem:** Wrong connection string format
**Solution:** Copy exact string from Neon console, verify `?sslmode=require`

### "Cannot reach backend"
**Problem:** FRONTEND_URL doesn't match Render URL
**Solution:** Check FRONTEND_URL exactly matches your Vercel domain

### "CORS error: Not allowed"
**Problem:** FRONTEND_URL in backend doesn't include protocol/domain correctly
**Solution:** Should be full domain: `https://your-domain.vercel.app`

## Testing Variables

After setting all variables, test:

```bash
# Backend (on Render console)
curl https://your-backend.onrender.com/api/flats/count

# Should return JSON (or auth error, but not CORS error)
```

```javascript
// Frontend (in browser console)
fetch('https://your-backend.onrender.com/api/resident/login', {
  credentials: 'include'
})

// Should show network request with HTTPS and cookies
```

## Reference Summary

| Environment | DATABASE_URL | SESSION_SECRET | JWT_SECRET | FRONTEND_URL | PORT |
|-------------|---|---|---|---|---|
| **Local Dev** | Neon (copy from console) | `dev_secret` | `dev_secret` | http://localhost:3000 | 5000 |
| **Render Prod** | Neon (copy from console) | openssl generated | openssl generated | Vercel domain | 5000 |
| **Vercel Prod** | N/A | N/A | N/A | N/A (self) | N/A |

---

**Ready to deploy? Follow QUICK_DEPLOY.md for step-by-step instructions.**
