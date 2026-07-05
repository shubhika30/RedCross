const mongoose = require("mongoose");

const campSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: true,
    },

    venue: {
      type: String,
      required: true,
    },

    date: {
      type: String,
      required: true,
    },

    time: {
      type: String,
      required: true,
    },

    description: {
      type: String,
    },

    instructions: {
      type: String,
    },



    isPublished: {
      type: Boolean,
      default: false,
    },

  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("Camp", campSchema);