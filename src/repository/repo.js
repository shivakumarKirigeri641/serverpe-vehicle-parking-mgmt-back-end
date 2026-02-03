const { connectDb } = require("../database/connectDb");
const mapPgError = require("../utils/pgErrorMapper");
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
      //update login_status
      const result_staff = await pool.query(
        `select id from staff where emailid=$1`,
        [email],
      );
      await pool.query(
        `insert into staff_logs (fkstaff, login_status) values ($1, $2)`,
        [result_staff.rows[0].id, true],
      );
      return true;
    }
    return false;
  } catch (err) {
    console.error("PG ERROR:", err);
    throw mapPgError(err);
  }
};
exports.staffLogout = async (staff_email) => {
  try {
    const pool = connectDb();
    // Check for VALID, NON-EXPIRED, MATCHING OTP
    // Sort by created_at DESC to get latest
    const result_staff = await pool.query(
      `select id from staff where emailid=$1`,
      [staff_email],
    );
    const query = await pool.query(
      `update staff_logs set logout_status=$1 where fkstaff = $2`,
      [true, result_staff.rows[0].id],
    );
  } catch (err) {
    console.error("PG ERROR:", err);
    throw mapPgError(err);
  }
};
exports.checkinVehicle = async (vehicle_number, staff_email) => {
  try {
    let result_vehicle_session = {};
    const pool = connectDb();
    //get parking_id from staff_email
    //check vehicle number in mock_vahan, if not insert & select, if already present, then select
    let result_mockvahan = await pool.query(
      `select *from mock_vahan where vehicle_number=$1`,
      [vehicle_number.toUpperCase()],
    );
    if (0 === result_mockvahan.rows.length) {
      result_mockvahan = await pool.query(
        `insert into mock_vahan (vehicle_number, vehicle_type, mobile_number) values ($1,$2,$3) returning *`,
        [vehicle_number.toUpperCase(), "2W", "9886122415"],
      );
    }
    //get staff id from staff_email
    let result_staff = await pool.query(`select *from staff where emailid=$1`, [
      staff_email,
    ]);

    if (0 < result_staff.rows.length) {
      //what if alraedy checked in?
      const result_already_checkin = await pool.query(
        `select *from vehicle_session where fkmock_vahan = $1 and entry_status=true and exit_status=false`,
        [result_mockvahan.rows[0].id],
      );
      if (0 < result_already_checkin.rows.length) {
        //vehicle not found
        return {
          poweredby: "serverpe.in",
          mock_data: true,
          status: "Failed",
          successstatus: false,
          message: "Vehicle already in parking lot!",
        };
      }
      const otp = Math.floor(1000 + Math.random() * 9000).toString();
      result_vehicle_session = await pool.query(
        `insert into vehicle_session (fkparkingfield, fkmock_vahan, fkstaff, exit_otp, entry_status) values ($1, $2, $3, $4, $5) returning *`,
        [
          result_staff.rows[0].fkparkingfield,
          result_mockvahan.rows[0].id,
          result_staff.rows[0].id,
          otp,
          true,
        ],
      );
    }
    return result_vehicle_session.rows[0];
  } catch (err) {
    console.error("PG ERROR:", err);
    throw mapPgError(err);
  }
};
exports.checkoutVehicle = async (checkout_staff_email, otp) => {
  try {
    const pool = connectDb();
    let result_vehicle_session = await pool.query(
      `select *from vehicle_session where exit_otp = $1`,
      [otp],
    );
    let result_staff_details = await pool.query(
      `select *from staff where emailid = $1`,
      [checkout_staff_email],
    );
    if (0 === result_vehicle_session.rows.length) {
      //vehicle not found
      return {
        poweredby: "serverpe.in",
        mock_data: true,
        status: "Failed",
        successstatus: false,
        message: "Vehicle not found!",
      };
    }
    //get payment structure
    let result_parking_payment_structure = {};
    //calcualte duration
    const result_mock_vahan = await pool.query(
      `select *from mock_vahan where id = $1`,
      [result_vehicle_session.rows[0].fkmock_vahan],
    );
    const result_pay_details = await pool.query(
      `SELECT
    vs.id AS session_id,

    CEIL(EXTRACT(EPOCH FROM (NOW() - vs.created_at)) / 60) AS total_minutes,
    CEIL(EXTRACT(EPOCH FROM (NOW() - vs.created_at)) / 3600) AS total_hours,

    COALESCE(p2.min_pay, p3.min_pay, p4.min_pay) AS min_pay,
    COALESCE(
        p2.per_hour_increment,
        p3.per_hour_increment,
        p4.per_hour_increment
    ) AS per_hour_increment,

    COALESCE(p2.min_pay, p3.min_pay, p4.min_pay)
    +
    GREATEST(
        CEIL(EXTRACT(EPOCH FROM (NOW() - vs.created_at)) / 3600) - 1,
        0
    )
    *
    COALESCE(
        p2.per_hour_increment,
        p3.per_hour_increment,
        p4.per_hour_increment
    ) AS total_amount

FROM vehicle_session vs

JOIN mock_vahan mv
    ON mv.id = vs.fkmock_vahan

LEFT JOIN parking_payment_structure_2w p2
    ON p2.fkparkingfield = vs.fkparkingfield
   AND mv.vehicle_type = '2W'

LEFT JOIN parking_payment_structure_3w p3
    ON p3.fkparkingfield = vs.fkparkingfield
   AND mv.vehicle_type = '3W'

LEFT JOIN parking_payment_structure_4w p4
    ON p4.fkparkingfield = vs.fkparkingfield
   AND mv.vehicle_type = '4W'

WHERE vs.id = $1;
`,
      [result_vehicle_session.rows[0].id],
    );
    //now update the sessions &
    await pool.query(
      `update vehicle_session set exit_at=NOW(), fkstaff_exit=$1, total_pay=$2, exit_status=$3 where id=$4`,
      [
        result_vehicle_session.rows[0].fkstaff,
        result_pay_details.rows[0].total_amount,
        true,
        result_vehicle_session.rows[0].id,
      ],
    );
    return {
      staff_details: result_staff_details.rows[0],
      parking_payment_details: result_pay_details.rows[0],
      vehicle_details: result_mock_vahan.rows[0],
    };
  } catch (err) {
    console.error("PG ERROR:", err);
    throw mapPgError(err);
  }
};
