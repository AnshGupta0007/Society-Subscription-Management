require("dotenv").config();
const express = require("express");
const cors = require("cors");
const session = require("express-session");
const pool = require("./db");

const flatsRoutes = require("./routes/flats.routes");
const dashboardRoutes = require("./routes/dashboard.routes");
const plansRoutes = require("./routes/plans.routes");
const monthlyRoutes = require("./routes/monthly.routes");
const paymentsRoutes = require("./routes/payments.routes");
const reportsRoutes = require("./routes/reports.routes");
const profileRoutes = require("./routes/profile.routes");
const residentRoutes = require("./routes/resident.routes");
const notificationsRoutes = require("./routes/notifications.routes");

const app = express();
const port = Number(process.env.PORT || 5000);

// CORS Configuration for both local development and production
const allowedOrigins = [
  "http://localhost:3000",
  "http://localhost:3001",
  process.env.FRONTEND_URL || "https://society-subscription-management-nu.vercel.app",
  "https://society-subscription-management-nu.vercel.app"
];

app.use(cors({
  origin: function(origin, callback) {
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error("Not allowed by CORS"));
    }
  },
  credentials: true
}));

// Session Configuration for Resident Auth
app.use(session({
  secret: process.env.SESSION_SECRET || "your_development_secret_change_in_production",
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: process.env.NODE_ENV === "production",
    sameSite: process.env.NODE_ENV === "production" ? "none" : "lax",
    httpOnly: true,
    maxAge: 24 * 60 * 60 * 1000 // 24 hours
  }
}));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/api/reports", reportsRoutes);
app.use("/api/payments", paymentsRoutes);
app.use("/api/monthly", monthlyRoutes);
app.use("/api/plans", plansRoutes);
app.use("/api/flats", flatsRoutes);
app.use("/api/dashboard", dashboardRoutes);
app.use("/api/profile", profileRoutes);
app.use("/api/resident", residentRoutes);
app.use("/api/notifications", notificationsRoutes);

// Cleanup endpoint to remove duplicate subscriptions
app.post("/api/cleanup", async (req, res) => {
  try {
    await pool.query('BEGIN');
    
    // Delete all subscriptions except the first one per flat/month
    await pool.query(`
      DELETE FROM monthly_subscriptions
      WHERE id NOT IN (
        SELECT DISTINCT ON (flat_id, month) id
        FROM monthly_subscriptions
        ORDER BY flat_id, month, id ASC
      );
    `);
    
    await pool.query('COMMIT');
    
    const result = await pool.query(`
      SELECT COUNT(*) as total FROM monthly_subscriptions;
    `);
    
    res.json({
      success: true,
      message: "Duplicates removed",
      totalSubscriptions: result.rows[0].total,
    });
  } catch (err) {
    await pool.query('ROLLBACK');
    res.status(500).json({
      success: false,
      error: err.message,
    });
  }
});

async function startServer() {
  try {
    await pool.query("SELECT 1");
    console.log("Database connected");

    app.listen(port, () => {
      console.log(`Server running on ${port}`);
    });
  } catch (error) {
    console.error("Database connection failed:", error.message);
    process.exit(1);
  }
}

startServer();