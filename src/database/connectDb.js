const { Pool, types } = require("pg");
// Keep DATE as string (no timezone changes)
types.setTypeParser(1082, (val) => val);
let pool = null;
/* ============================================
   VEHICLE PARKING MANAGEMENT DATABASE
============================================ */
const connectDb = () => {
  if (!pool) {
    pool = new Pool({
      host: process.env.PGHOST,
      database: process.env.PGDATABASE,
      user: process.env.PGUSER,
      password: process.env.PGPASSWORD,
      port: process.env.PGPORT,
      max: 20,
      idleTimeoutMillis: 30000,
      connectionTimeoutMillis: 2000,
      keepAlive: true,
    });
  }
  console.log("Vehicle parking management database connnected successfully.");
  return pool;
};

module.exports = {
  connectDb,
  getTrainPool: () => pool,
};
