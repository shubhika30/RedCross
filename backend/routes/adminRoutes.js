const express = require("express");
const router = express.Router();

const auth = require("../middlewares/authMiddleware");
const admin = require("../middlewares/adminMiddleware");

const {
  getDashboardStats,
} = require("../controllers/adminController");

// only admin can access dashboard stats
router.get("/dashboard", auth, admin, getDashboardStats);

module.exports = router;