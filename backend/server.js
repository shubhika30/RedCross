const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
require("dotenv").config();

const connectDB = require("./config/db");

const campRoutes = require("./routes/campRoutes");
const donorRoutes = require("./routes/donorRoutes");
const authRoutes = require("./routes/authRoutes");
const registrationRoutes = require("./routes/registrationRoutes");
const adminRoutes = require("./routes/adminRoutes");

const { generalLimiter } = require("./middlewares/rateLimit");

const app = express();
const PORT = process.env.PORT || 5000;

// Connect Database
connectDB();

// Middlewares
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(generalLimiter);

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/camps", campRoutes);
app.use("/api/donors", donorRoutes);
app.use("/api/registrations", registrationRoutes);
app.use("/api/admin", adminRoutes);

// Health Check
app.get("/", (req, res) => {
  res.send("Red Cross Backend Running");
});

// Start Server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});