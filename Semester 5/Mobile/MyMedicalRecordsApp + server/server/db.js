const sql = require("mssql");
const config = require("./config");

async function getConnection() {
  try {
    const pool = await sql.connect(config);
    console.log("Connected to the SQL database successfully.");
    return pool;
  } catch (error) {
    console.error("SQL connection error:", error);
    throw error;
  }
}

module.exports = {
  getConnection,
  sql,
};
