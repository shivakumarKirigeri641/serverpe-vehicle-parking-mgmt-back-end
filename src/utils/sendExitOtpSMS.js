const axios = require("axios");
require("dotenv").config();
const sendExitOtpSMS = async (venue, mobile_number) => {
  const now = new Date().toLocaleString("en-IN", {
    timeZone: "Asia/Kolkata",
  });
  const fast2smsResp = await axios.get(
    //`https://www.fast2sms.com/dev/bulkV2?authorization=${process.env.FAST2SMSAPIKEY}&route=dlt&sender_id=SRVRPE&message=204637&variables_values=${generatedotp}|${validfor}&numbers=${mobile_number}`
    `https://www.fast2sms.com/dev/bulkV2?authorization=${process.env.FAST2SMSAPIKEY}&route=dlt&sender_id=SRVRPE&message=208313&variables_values=${now}|${venue}|Var3&numbers=${mobile_number}`,
  );
  if (fast2smsResp.data && fast2smsResp.data.return) {
    //dont do anything
    return { success: true, data: fast2smsResp.data };
  } else {
    // bubble details for debugging
    return { success: false, data: fast2smsResp.data };
  }
};
module.exports = sendExitOtpSMS;
