const Camp = require("../models/Camp");
const Registration = require("../models/Registration");
const User = require("../models/User");
const Donor = require("../models/Donor");
const PDFDocument = require("pdfkit");
const mongoose = require("mongoose");


// =======================
// CREATE CAMP
// =======================
const createCamp = async (req, res) => {
  try {
    const { title, venue, date, time, description, instructions } = req.body;

    if (!title || !venue || !date || !time) {
      return res.status(400).json({
        success: false,
        message: "Title, venue, date and time are required",
      });
    }

    const camp = await Camp.create({
      title,
      venue,
      date,
      time,
      description,
      instructions,
      isPublished: true,
    });

    return res.status(201).json({
      success: true,
      message: "Camp created successfully",
      data: camp,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// =======================
// GET ALL CAMPS (ADMIN)
// =======================
const getCamps = async (req, res) => {
  try {
    const camps = await Camp.find().sort({ createdAt: -1 });

    const campsWithRegistrations = await Promise.all(
      camps.map(async (camp) => {
        const count = await Registration.countDocuments({ camp: camp._id });

        return {
          ...camp.toObject(),
          registrations: count,
        };
      })
    );

    return res.status(200).json({
      success: true,
      count: campsWithRegistrations.length,
      data: campsWithRegistrations,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// =======================
// UPDATE CAMP
// =======================
const updateCamp = async (req, res) => {
  try {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        success: false,
        message: "Invalid camp ID",
      });
    }

    const updatedCamp = await Camp.findByIdAndUpdate(id, req.body, {
      new: true,
      runValidators: true,
    });

    if (!updatedCamp) {
      return res.status(404).json({
        success: false,
        message: "Camp not found",
      });
    }

    return res.status(200).json({
      success: true,
      message: "Camp updated successfully",
      data: updatedCamp,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// =======================
// DELETE CAMP
// =======================
const deleteCamp = async (req, res) => {
  try {
    const { id } = req.params;

    const camp = await Camp.findById(id);

    if (!camp) {
      return res.status(404).json({
        success: false,
        message: "Camp not found",
      });
    }

    await Registration.deleteMany({ camp: id });
    await Camp.findByIdAndDelete(id);

    return res.status(200).json({
      success: true,
      message: "Camp deleted successfully",
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// =======================
// GET CAMP DETAILS
// =======================
const getCampDetails = async (req, res) => {
  try {
    const camp = await Camp.findById(req.params.id);

    if (!camp) {
      return res.status(404).json({
        success: false,
        message: "Camp not found",
      });
    }

    const registrations = await Registration.find({
      camp: camp._id,
    }).populate("user", "mobile role");

    return res.status(200).json({
      success: true,
      camp,
      totalRegistrations: registrations.length,
      registrations,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// =======================
// PUBLISH CAMP
// =======================
const publishCamp = async (req, res) => {
  try {
    const camp = await Camp.findById(req.params.id);

    if (!camp) {
      return res.status(404).json({
        success: false,
        message: "Camp not found",
      });
    }

    camp.isPublished = true;
    await camp.save();

    return res.status(200).json({
      success: true,
      message: "Camp published successfully",
      data: camp,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// =======================
// UNPUBLISH CAMP
// =======================
const unpublishCamp = async (req, res) => {
  try {
    const camp = await Camp.findById(req.params.id);

    if (!camp) {
      return res.status(404).json({
        success: false,
        message: "Camp not found",
      });
    }

    camp.isPublished = false;
    await camp.save();

    return res.status(200).json({
      success: true,
      message: "Camp unpublished successfully",
      data: camp,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// =======================
// GET PUBLISHED CAMPS
// =======================
const getPublishedCamps = async (req, res) => {
  try {
    const camps = await Camp.find({ isPublished: true }).sort({
      createdAt: -1,
    });

    return res.status(200).json({
      success: true,
      count: camps.length,
      data: camps,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// =======================
// GET PUBLISHED CAMP DETAILS (FIXED MISSING FUNCTION)
// =======================
const getPublishedCampDetails = async (req, res) => {
  try {
    const camp = await Camp.findOne({
      _id: req.params.id,
      isPublished: true,
    });

    if (!camp) {
      return res.status(404).json({
        success: false,
        message: "Published camp not found",
      });
    }

    return res.status(200).json({
      success: true,
      data: camp,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// =======================
// DOWNLOAD CAMP REPORT (FIXED MISSING FUNCTION)
// =======================
const downloadCampReport = async (req, res) => {
  try {
    const camp = await Camp.findById(req.params.id);

    if (!camp) {
      return res.status(404).json({
        success: false,
        message: "Camp not found",
      });
    }

    const registrations = await Registration.find({ camp: camp._id }).populate("user");
    const doc = new PDFDocument();

    res.setHeader("Content-Type", "application/pdf");
    res.setHeader(
      "Content-Disposition",
      `attachment; filename=camp-${camp._id}.pdf`
    );

    doc.pipe(res);

    doc.fontSize(18).text(`Camp Report`, { underline: true });
    doc.moveDown();

    doc.fontSize(12).text(`Title: ${camp.title}`);
    doc.text(`Venue: ${camp.venue}`);
    doc.text(`Date: ${camp.date}`);
    doc.text(`Time: ${camp.time}`);
    doc.text(`Total Registrations: ${registrations.length}`);
    doc.moveDown();
doc.fontSize(16).text("Registered Donors", { underline: true });
doc.moveDown();

if (registrations.length === 0) {
  doc.text("No registrations yet.");
} else {
  for (let i = 0; i < registrations.length; i++) {
    const reg = registrations[i];
    const donor = await Donor.findOne({ user: reg.user._id });

    if (!donor) continue;

    doc.fontSize(12).text(`
Donor #${i + 1}

Name: ${donor.name}
Father Name: ${donor.fatherName}
Mobile: ${donor.mobile}
Email: ${donor.email}
Blood Group: ${donor.bloodGroup}
Age: ${donor.age}
Gender: ${donor.gender}
Date of Birth: ${donor.dob}
Address: ${donor.address}
Occupation: ${donor.occupation}
Has Donated Before: ${donor.hasDonatedBefore ? "Yes" : "No"}
Donation Count: ${donor.donationCount}
Last Donation Date: ${donor.lastDonationDate || "N/A"}
Registration Status: ${reg.status}
`);

    doc.moveDown();
  }
}

    doc.end();
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// =======================
// EXPORTS (FIXED)
// =======================
module.exports = {
  createCamp,
  getCamps,
  updateCamp,
  deleteCamp,
  getCampDetails,
  publishCamp,
  unpublishCamp,
  getPublishedCamps,
  getPublishedCampDetails,
  downloadCampReport,
};