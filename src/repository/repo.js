const { connectDb } = require("../database/connectDb");
const { mapPgError } = require("../utils/pgErrorMapper");
exports.saveOtp = async (email, otp, expires_at) => {
  try {
    const pool = connectDb();
    // Insert new OTP with ispayment flag
    const query = `INSERT INTO email_otps (email, otp, expires_at) VALUES ($1, $2, $3) RETURNING *`;
    const result = await pool.query(query, [email, otp, expires_at]);
    if (0 < result.rows.length) {
      return result.rows[0];
    } else {
      throw mapPgError(new Error({ message: "Failed to include otp!" }));
    }
  } catch (err) {
    console.error("PG ERROR:", err);
    throw mapPgError(err);
  }
};
exports.verifyOtp = async (email, otp) => {
  try {
    const pool = connectDb();
    // Check for VALID, NON-EXPIRED, MATCHING OTP
    // Sort by created_at DESC to get latest
    const query = `
            SELECT * FROM email_otps 
            WHERE email = $1 AND otp = $2 AND expires_at > NOW()
            ORDER BY created_at DESC
            LIMIT 1
        `;
    const result = await pool.query(query, [email, otp]);

    if (result.rows.length > 0) {
      // Mark as verified
      await pool.query(`delete from email_otps WHERE id = $1`, [
        result.rows[0].id,
      ]);
      return true;
    }
    return false;
  } catch (err) {
    console.error("PG ERROR:", err);
    throw mapPgError(err);
  }
};
