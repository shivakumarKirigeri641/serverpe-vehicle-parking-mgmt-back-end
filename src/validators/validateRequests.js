const validator = require("validator");
exports.validateStaffForLogin = async (req) => {
  if (!req.body) {
    return {
      poweredby: "serverpe.in",
      mock_data: true,
      status: "Failed",
      successstatus: false,
      message: "No request body found",
    };
  }
  if (!req.body?.email) {
    return {
      poweredby: "serverpe.in",
      mock_data: true,
      status: "Failed",
      successstatus: false,
      message: "No staff email found",
    };
  }
  if (!validator.isEmail(req.body.email)) {
    return {
      poweredby: "serverpe.in",
      mock_data: true,
      status: "Failed",
      successstatus: false,
      message: "Invalid staff email",
    };
  }
  return {
    poweredby: "serverpe.in",
    mock_data: true,
    status: "Success",
    successstatus: true,
    message: "all ok",
  };
};
exports.validateStaffForLoginVerifyOtp = async (req) => {
  if (!req.body) {
    return {
      poweredby: "serverpe.in",
      mock_data: true,
      status: "Failed",
      successstatus: false,
      message: "No request body found",
    };
  }
  if (!req.body?.email) {
    return {
      poweredby: "serverpe.in",
      mock_data: true,
      status: "Failed",
      successstatus: false,
      message: "No staff email found",
    };
  }
  if (!validator.isEmail(req.body.email)) {
    return {
      poweredby: "serverpe.in",
      mock_data: true,
      status: "Failed",
      successstatus: false,
      message: "Invalid staff email",
    };
  }
  if (!req.body?.otp) {
    return {
      poweredby: "serverpe.in",
      mock_data: true,
      status: "Failed",
      successstatus: false,
      message: "No staff otp found",
    };
  }
  return {
    poweredby: "serverpe.in",
    mock_data: true,
    status: "Success",
    successstatus: true,
    message: "all ok",
  };
};
exports.validateStaffForLogout = async (req) => {
  if (!req.email) {
    return {
      poweredby: "serverpe.in",
      mock_data: true,
      status: "Failed",
      successstatus: false,
      message: "No staff email found",
    };
  }
  if (!validator.isEmail(req.email)) {
    return {
      poweredby: "serverpe.in",
      mock_data: true,
      status: "Failed",
      successstatus: false,
      message: "Invalid staff email",
    };
  }
  return {
    poweredby: "serverpe.in",
    mock_data: true,
    status: "Success",
    successstatus: true,
    message: "all ok",
  };
};
exports.validateVehicleCheckIn = async (req) => {
  if (!req.body) {
    return {
      poweredby: "serverpe.in",
      mock_data: true,
      status: "Failed",
      successstatus: false,
      message: "No request body found",
    };
  }
  if (!req.body.vehicle_number) {
    return {
      poweredby: "serverpe.in",
      mock_data: true,
      status: "Failed",
      successstatus: false,
      message: "No vehicle number found",
    };
  }

  return {
    poweredby: "serverpe.in",
    mock_data: true,
    status: "Success",
    successstatus: true,
    message: "all ok",
  };
};
exports.validateVehicleCheckOut = async (req) => {
  if (!req.body) {
    return {
      poweredby: "serverpe.in",
      mock_data: true,
      status: "Failed",
      successstatus: false,
      message: "No request body found",
    };
  }
  if (!req.body.otp) {
    return {
      poweredby: "serverpe.in",
      mock_data: true,
      status: "Failed",
      successstatus: false,
      message: "No exit otp found",
    };
  }

  return {
    poweredby: "serverpe.in",
    mock_data: true,
    status: "Success",
    successstatus: true,
    message: "all ok",
  };
};
