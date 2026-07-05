const express = require("express");
const router = express.Router();

const auth = require("../middlewares/authMiddleware");
const admin = require("../middlewares/adminMiddleware");

const {
  createCamp,
  getCamps,
  updateCamp,
  deleteCamp,
  getCampDetails,
  downloadCampReport,
  publishCamp,
  unpublishCamp,
  getPublishedCamps,
  getPublishedCampDetails,
} = require("../controllers/campController");

// =======================
// ADMIN ROUTES
// =======================

// Create Camp (Admin only)
router.post("/create", auth, admin, createCamp);

// Get all camps (Admin view)
router.get("/", auth, admin, getCamps);

// Update camp
router.put("/update/:id", auth, admin, updateCamp);

// Delete camp
router.delete("/delete/:id", auth, admin, deleteCamp);

// Get single camp details (admin)
router.get("/details/:id", auth, admin, getCampDetails);

// Download camp report PDF
router.get("/:id/report", auth, admin, downloadCampReport);

// Publish camp
router.put("/publish/:id", auth, admin, publishCamp);

// Unpublish camp
router.put("/unpublish/:id", auth, admin, unpublishCamp);

// =======================
// PUBLIC WEBSITE ROUTES
// =======================

// Get all published camps (public)
router.get("/public/all", getPublishedCamps);

// Get single published camp (public)
router.get("/public/:id", getPublishedCampDetails);

module.exports = router;