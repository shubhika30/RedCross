const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");
require("dotenv").config();

const connectDB = require("../config/db");
const User = require("../models/User");

const createAdmin = async () => {
  try {
    await connectDB();

    const mobile = "9729624887";
    const password = "admin123";

    // check if admin exists
    const existing = await User.findOne({ mobile, role: "admin" });

    if (existing) {
      console.log("Admin already exists");
      process.exit(0);
    }
    
    const hashedPassword = await bcrypt.hash(password, 10);

    await User.create({
      mobile,
      role: "admin",
      password: hashedPassword,
    });

    console.log("Admin created successfully");
    console.log({ mobile });

    process.exit(0);
  } catch (err) {
    console.log("Error:", err.message);
    process.exit(1);
  }
};

createAdmin();