const express = require("express");
const router = express.Router();

const auth = require("../middlewares/authMiddleware");

const {
  registerCamp,
  getMyRegistrations,
} = require("../controllers/registrationController");

// user must be logged in
router.post("/register", auth, registerCamp);

router.get("/my", auth, getMyRegistrations);

module.exports = router;