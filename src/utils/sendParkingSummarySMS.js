const axios = require("axios");
require("dotenv").config();
const sendParkingSummarySMS = async (
  mobile_number,
  amount,
  venue,
  check_in_date_and_time,
) => {
  const now = new Date().toLocaleString("en-IN", {
    timeZone: "Asia/Kolkata",
  });
  const diffMs = new Date() - new Date(check_in_date_and_time);
  const hours = Math.floor(diffMs / 3600000);
  const minutes = Math.floor((diffMs % 3600000) / 60000);
  const duration = `${hours}h ${minutes}m`;
  const fast2smsResp = await axios.get(
    //`https://www.fast2sms.com/dev/bulkV2?authorization=${process.env.FAST2SMSAPIKEY}&route=dlt&sender_id=SRVRPE&message=204637&variables_values=${generatedotp}|${validfor}&numbers=${mobile_number}`
    `https://www.fast2sms.com/dev/bulkV2?authorization=${process.env.FAST2SMSAPIKEY}&route=dlt&sender_id=SRVRPE&message=208312&variables_values=${amount}|${venue}|${duration}&numbers=${mobile_number}`,
  );
  if (fast2smsResp.data && fast2smsResp.data.return) {
    //dont do anything
    return { success: true, data: fast2smsResp.data };
  } else {
    // bubble details for debugging
    return { success: false, data: fast2smsResp.data };
  }
};
module.exports = sendParkingSummarySMS;
