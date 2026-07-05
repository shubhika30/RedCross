const Registration = require("../models/Registration");
const Camp = require("../models/Camp");
const Donor = require("../models/Donor");
const User = require("../models/User");

// REGISTER FOR CAMP

exports.registerCamp = async (req, res) => {
  try {
    const userId = req.user._id;

    const {
      campId,
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
    } = req.body;

    if (!campId) {
      return res.status(400).json({
        success: false,
        message: "Camp ID is required",
      });
    }

    // Check if camp exists
    const camp = await Camp.findById(campId);

    if (!camp) {
      return res.status(404).json({
        success: false,
        message: "Camp not found",
      });
    }

    // Check if registration has closed (24 hours after camp starts)

const campDateTime = new Date(`${camp.date} ${camp.time}`);

const registrationClosingTime = new Date(
  campDateTime.getTime() + 24 * 60 * 60 * 1000
);

if (new Date() > registrationClosingTime) {
  return res.status(400).json({
    success: false,
    message: "Registration for this camp has closed.",
  });
}

    // Prevent duplicate registration
    const existingRegistration = await Registration.findOne({
      user: userId,
      camp: campId,
    });

    if (existingRegistration) {
      return res.status(400).json({
        success: false,
        message: "Already registered for this camp",
      });
    }

    // Get logged in user (to obtain mobile number)
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }

    // Create or Update donor profile
    let donor = await Donor.findOne({ user: userId });

    if (!donor) {
      donor = await Donor.create({
        user: userId,
        name,
        fatherName,
        mobile: user.mobile,
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
    } else {
      donor.name = name;
      donor.fatherName = fatherName;
      donor.mobile = user.mobile;
      donor.email = email;
      donor.bloodGroup = bloodGroup;
      donor.age = age;
      donor.gender = gender;
      donor.dob = dob;
      donor.address = address;
      donor.occupation = occupation;
      donor.hasDonatedBefore = hasDonatedBefore;
      donor.donationCount = donationCount;
      donor.lastDonationDate = lastDonationDate;

      await donor.save();
    }

    // Create registration
    const registration = await Registration.create({
      user: userId,
      camp: campId,
    });

    return res.status(201).json({
      success: true,
      message: "Registration successful",
      registration,
      donor,
    });

  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

//  GET MY REGISTRATIONS

exports.getMyRegistrations = async (req, res) => {
  try {
    const userId = req.user._id;

    const registrations = await Registration.find({ user: userId })
      .populate("camp")
      .sort({ createdAt: -1 });

    return res.status(200).json({
      success: true,
      count: registrations.length,
      data: registrations,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};