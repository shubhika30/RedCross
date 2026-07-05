const mongoose = require("mongoose");

const registrationSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },

    camp: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Camp",
      required: true,
    },

    status: {
      type: String,
      enum: ["registered", "attended", "cancelled"],
      default: "registered",
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Registration", registrationSchema);