const express = require("express");
const router = express.Router();
const {
  sendOtp,
  verifyOtp,
  userLogin,
  adminLogin,
} = require("../controllers/authController");
const { createAdmin } = require("../controllers/authController");
const auth = require("../middlewares/authMiddleware");
const admin = require("../middlewares/adminMiddleware");
const {
  otpLimiter,
  loginLimiter,
} = require("../middlewares/rateLimit");

router.post("/send-otp", otpLimiter, sendOtp);
router.post("/verify-otp", loginLimiter, verifyOtp);
router.post("/user-login", loginLimiter, userLogin);
router.post("/admin-login", loginLimiter, adminLogin);
router.post("/create-admin", auth, admin, createAdmin);

module.exports = router;