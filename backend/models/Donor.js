const mongoose = require("mongoose");

const donorSchema = new mongoose.Schema(
  {
    // Link to user account
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      unique: true,
    },

    // Personal info
    name: {
      type: String,
      required: true,
      trim: true,
    },

    fatherName: {
      type: String,
      required: true,
      trim: true,
    },

    mobile: {
      type: String,
      required: true,
      unique: true,
      trim: true,
    },

    email: {
      type: String,
      default: "",
      trim: true,
    },

    bloodGroup: {
      type: String,
      required: true,
      enum: ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"],
    },

    age: {
      type: Number,
      required: true,
    },

    gender: {
      type: String,
      required: true,
      enum: ["Male", "Female", "Other"],
    },

    dob: {
      type: Date,
      required: true,
    },

    address: {
      type: String,
      required: true,
      trim: true,
    },

    occupation: {
      type: String,
      required: true,
      trim: true,
    },

    // Camp relation (optional, depends on your system design)
    campId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Camp",
    },

    // Donation tracking
    hasDonatedBefore: {
      type: Boolean,
      default: false,
    },

    donationCount: {
      type: Number,
      default: 0,
    },

    lastDonationDate: {
      type: Date,
      default: null,
    },

    isAvailable: {
      type: Boolean,
      default: true,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("Donor", donorSchema);