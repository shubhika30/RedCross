const Donor = require("../models/Donor");

// =======================
// REGISTER DONOR
// =======================
const registerDonor = async (req, res) => {
  try {
    const {
      name,
      fatherName,
      mobile,
      email,
      bloodGroup,
      age,
      gender,
      dob,
      address,
      occupation,
      hasDonatedBefore,
      donationCount,
      lastDonationDate,
    } = req.body;

    if (
      !name ||
      !fatherName ||
      !mobile ||
      !bloodGroup ||
      !age ||
      !gender ||
      !dob ||
      !address ||
      !occupation
    ) {
      return res.status(400).json({
        success: false,
        message: "All required fields must be filled",
      });
    }

    const existing = await Donor.findOne({
      user: req.user._id,
    });

    if (existing) {
      return res.status(400).json({
        success: false,
        message: "Donor already registered",
      });
    }

    const donor = await Donor.create({
      user: req.user._id,
      name,
      fatherName,
      mobile,
      email,
      bloodGroup,
      age,
      gender,
      dob,
      address,
      occupation,
      hasDonatedBefore,
      donationCount,
      lastDonationDate,
    });

    return res.status(201).json({
      success: true,
      message: "Donor registered successfully",
      data: donor,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// =======================
// GET ALL DONORS (ADMIN)
// =======================
const getAllDonors = async (req, res) => {
  try {
    const donors = await Donor.find()
      .populate("user", "mobile role")
      .sort({ createdAt: -1 });

    return res.status(200).json({
      success: true,
      count: donors.length,
      data: donors,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// =======================
// GET DONORS BY CAMP
// =======================
const getDonorsByCamp = async (req, res) => {
  try {
    const donors = await Donor.find({
      campId: req.params.campId,
    });

    return res.status(200).json({
      success: true,
      count: donors.length,
      data: donors,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// =======================
// GET MY DONOR PROFILE
// =======================
const getMyDonorProfile = async (req, res) => {
  try {
    const donor = await Donor.findOne({
      user: req.user._id,
    }).populate("user", "mobile role");

    if (!donor) {
      return res.status(404).json({
        success: false,
        message: "Donor profile not found",
      });
    }

    return res.status(200).json({
      success: true,
      data: donor,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// =======================
// UPDATE DONOR PROFILE
// =======================
const updateDonorProfile = async (req, res) => {
  try {
    const donor = await Donor.findOne({ user: req.user._id });

    if (!donor) {
      return res.status(404).json({
        success: false,
        message: "Donor profile not found",
      });
    }

    const {
      name,
      fatherName,
      email,
      bloodGroup,
      age,
      gender,
      dob,
      address,
      occupation,
      hasDonatedBefore,
      donationCount,
      lastDonationDate,
      isAvailable,
    } = req.body;

    if (name) donor.name = name;
    if (fatherName) donor.fatherName = fatherName;
    if (email) donor.email = email;
    if (bloodGroup) donor.bloodGroup = bloodGroup;
    if (age) donor.age = age;
    if (gender) donor.gender = gender;
    if (dob) donor.dob = dob;
    if (address) donor.address = address;
    if (occupation) donor.occupation = occupation;

    if (hasDonatedBefore !== undefined)
      donor.hasDonatedBefore = hasDonatedBefore;

    if (donationCount !== undefined)
      donor.donationCount = donationCount;

    if (lastDonationDate)
      donor.lastDonationDate = lastDonationDate;

    if (isAvailable !== undefined)
      donor.isAvailable = isAvailable;

    await donor.save();

    return res.status(200).json({
      success: true,
      message: "Donor profile updated successfully",
      data: donor,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// =======================
// GET DONOR BY ID (ADMIN)
// =======================
const getDonorById = async (req, res) => {
  try {
    const donor = await Donor.findById(req.params.id).populate(
      "user",
      "mobile role"
    );

    if (!donor) {
      return res.status(404).json({
        success: false,
        message: "Donor not found",
      });
    }

    return res.status(200).json({
      success: true,
      data: donor,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// =======================
// EXPORTS
// =======================
module.exports = {
  registerDonor,
  getAllDonors,
  getDonorsByCamp,
  getMyDonorProfile,
  updateDonorProfile,
  getDonorById,
};