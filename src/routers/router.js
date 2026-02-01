const express = require("express");
const router = express.Router();
const repo = require("../repository/repo");
const sendMail = require("../utils/sendMail");
const sendOtpMailTemplate = require("../utils/sendOtpMailTemplate");
require("dotenv").config();
const jwt = require("jsonwebtoken");
const checkServerPeUser = require("../middleware/checkServerPeUser");
const sendError = (res, statusCode, message, details = null) => {
  const response = {
    poweredby: "serverpe.in",
    mock_data: true,
    status: "Failed",
    successstatus: false,
    message,
  };
  if (details && process.env.NODE_ENV === "development") {
    response.error_details = details;
  }
  return res.status(statusCode).json(response);
};

/**
 * Standardized API success response
 * @param {Response} res - Express response object
 * @param {Object} data - Response data
 * @param {string} message - Optional success message
 */
const sendSuccess = (res, data, message = "Success") => {
  return res.status(200).json({
    poweredby: "serverpe.in",
    mock_data: true,
    status: "Success",
    successstatus: true,
    message,
    data,
  });
};
router.post("/vpm/send-otp", async (req, res) => {
  try {
    const { email } = req.body;

    if (!email) {
      return sendError(res, 400, "Email is required");
    }

    // Validate email format
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return sendError(res, 400, "Invalid email format");
    }
    const otp = Math.floor(1000 + Math.random() * 9000).toString();

    // Send email based on OTP type
    const result_otp_email = otp;
    await sendMail({
      to: email,
      subject: "Your OTP for vehicle parking management login",
      html: await sendOtpMailTemplate({ result_otp_email }),
      text: `Your OTP for login is ${result_otp_email}. Valid for 10 minutes.`,
    });

    // OTP expires in 10 minutes
    const expires_at = new Date(Date.now() + 10 * 60 * 1000);

    await repo.saveOtp(email, otp, expires_at);
    const response = { email, expires_in: "10 minutes" };
    sendSuccess(res, response, "OTP sent successfully");
  } catch (err) {
    console.error("Error sending OTP:", err);
    sendError(res, 500, "Failed to send OTP", err.message);
  }
});

/**
 * POST /train/verify-otp
 * Verify OTP
 * Body: { email, otp }
 */
router.post("/vpm/verify-otp", async (req, res) => {
  try {
    const { email, otp } = req.body;

    if (!email || !otp) {
      return sendError(res, 400, "Email and OTP are required");
    }

    const isValid = await repo.verifyOtp(email, otp);

    if (!isValid) {
      return sendError(res, 401, "Invalid or expired OTP");
    }

    // 🔐 Generate JWT token after successful OTP verification
    const token = jwt.sign({ email }, process.env.SECRET_KEY, {
      expiresIn: "7d",
    });

    // 🍪 Set token as HTTP-only cookie
    /*res.cookie("token", token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      sameSite: "lax",
      maxAge: 7 * 24 * 60 * 60 * 1000, // 7 days
      path: "/",
    });*/
    res.cookie("token", token, {
      httpOnly: true,
      secure: true, // REQUIRED for SameSite=None
      sameSite: "None", // REQUIRED for cross-domain React → Node
      domain: ".serverpe.in",
    });
    return res.status(200).json({
      poweredby: "serverpe.in",
      mock_data: true,
      status: "Success",
      successstatus: true,
      message: "OTP verified successfully",
      data: {
        email,
        verified: true,
        token_expires_in: "7 days",
      },
    });
  } catch (err) {
    console.error("Error verifying OTP:", err);
    sendError(res, 500, "Failed to verify OTP", err.message);
  }
});
module.exports = router;
