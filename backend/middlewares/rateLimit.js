const rateLimit = require("express-rate-limit");

// ==========================
// GENERAL API LIMIT
// ==========================
exports.generalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 200, // max requests per IP
  message: {
    success: false,
    message: "Too many requests, try again later.",
  },
});

// ==========================
//  OTP LIMIT (STRICT)
// ==========================
exports.otpLimiter = rateLimit({
  windowMs: 5 * 60 * 1000, // 5 minutes
  max: 3, // only 3 OTP requests per 5 min
  message: {
    success: false,
    message: "Too many OTP requests. Try again after 5 minutes.",
  },
});

// ==========================
//  LOGIN LIMIT
// ==========================
exports.loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 10, // 10 login attempts per 15 min
  message: {
    success: false,
    message: "Too many login attempts. Please try again later.",
  },
});