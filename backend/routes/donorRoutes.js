const express = require("express");
const router = express.Router();

const auth = require("../middlewares/authMiddleware");
const admin = require("../middlewares/adminMiddleware");

const {
  registerDonor,
  getAllDonors,
  getMyDonorProfile,
  updateDonorProfile,
  getDonorById,
  getDonorsByCamp,
} = require("../controllers/donorController");

// =======================
// USER ROUTES
// =======================

// Register donor (user must be logged in)
router.post("/register", auth, registerDonor);

// Get my donor profile
router.get("/me", auth, getMyDonorProfile);

// Update my donor profile
router.put("/update", auth, updateDonorProfile);

// =======================
// ADMIN ROUTES
// =======================

// Get all donors
router.get("/all", auth, admin, getAllDonors);

// Get single donor by ID
router.get("/admin/:id", auth, admin, getDonorById);

// Get donors by camp
router.get("/camp/:campId", auth, admin, getDonorsByCamp);

module.exports = router;