const express = require("express");
const router = require("./routers/router");
const path = require("path");
const cors = require("cors");
const cookieParser = require("cookie-parser");
require("dotenv").config();
const { connectDb } = require("./database/connectDb");
const app = express();
//app.set("trust proxy", 1);
app.use(express.json());
app.use(
  cors({
    origin: ["http://localhost:1234"],
    credentials: true,
  }),
);
app.use(cookieParser());
app.use("/", router);
connectDb();
app.listen(process.env.PORT, () => {
  console.log(`Server is listening on port ${process.env.PORT}`);
});
