const User = require("../models/User");
const Camp = require("../models/Camp");
const Donor = require("../models/Donor");
const Registration = require("../models/Registration");

//  ADMIN DASHBOARD STATS

exports.getDashboardStats = async (req, res) => {
  try {
    const totalUsers = await User.countDocuments({ role: "user" });
    const totalAdmins = await User.countDocuments({ role: "admin" });
    const totalCamps = await Camp.countDocuments();
    const totalDonors = await Donor.countDocuments();
    const totalRegistrations = await Registration.countDocuments();

    // recent data (last 5 entries each)
    const recentUsers = await User.find()
      .sort({ createdAt: -1 })
      .limit(5)
      .select("mobile role createdAt");

    const recentCamps = await Camp.find()
      .sort({ createdAt: -1 })
      .limit(5);

    const recentDonors = await Donor.find()
      .sort({ createdAt: -1 })
      .limit(5)
      .select("name bloodGroup location");

    const recentRegistrations = await Registration.find()
      .sort({ createdAt: -1 })
      .limit(5)
      .populate("camp", "name location");

    return res.status(200).json({
      success: true,
      data: {
        summary: {
          totalUsers,
          totalAdmins,
          totalCamps,
          totalDonors,
          totalRegistrations,
        },
        recent: {
          users: recentUsers,
          camps: recentCamps,
          donors: recentDonors,
          registrations: recentRegistrations,
        },
      },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    }); 
  }
};