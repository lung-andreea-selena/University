const db = require("./db"); // Ensure this is properly set up to interact with your database.
const WebSocket = require("ws");

async function getAllRecords(req, res) {
  try {
    const pool = await db.getConnection();
    const result = await pool.request().query("SELECT * FROM MedicalRecord");

    const formattedRecords = result.recordset.map((record) => ({
      ...record,
      date: formatDate(record.date),
    }));

    res.json(formattedRecords);
  } catch (err) {
    console.error("Error retrieving all records:", err);
    res.status(500).send("Error retrieving data from database");
  }
}

async function getRecordById(req, res) {
  try {
    const { id } = req.params;
    const pool = await db.getConnection();
    const result = await pool
      .request()
      .input("id", db.sql.Int, id)
      .query("SELECT * FROM MedicalRecord WHERE id = @id");
    result.forEach((record) => {
      record.date = formatDate(record.date);
    });
    res.json(result.recordset[0] || {});
  } catch (err) {
    console.error("Error retrieving record by id:", err);
    res.status(500).send("Error retrieving data from database");
  }
}

async function createRecord(req, res, wss) {
  try {
    const { title, type, moneySpent, date, details } = req.body;
    const pool = await db.getConnection();
    const result = await pool
      .request()
      .input("title", db.sql.NVarChar, title)
      .input("type", db.sql.NVarChar, type)
      .input("moneySpent", db.sql.Float, moneySpent)
      .input("date", db.sql.Date, date)
      .input("details", db.sql.NVarChar, details)
      .query(
        "INSERT INTO MedicalRecord (title, type, moneySpent, date, details) OUTPUT INSERTED.*"
      );

    res.status(201).json(result.recordset[0]);
    // Broadcasting the new record to all connected WebSocket clients
    wss.clients.forEach((client) => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(
          JSON.stringify({
            action: "create",
            record: result.recordset[0],
          })
        );
      }
    });
  } catch (err) {
    console.error("Failed to create a new record:", err);
    res.status(500).send("Failed to add record");
  }
}

async function updateRecord(req, res, wss) {
  try {
    const { id } = req.params;
    const { title, type, moneySpent, date, details } = req.body;
    const pool = await db.getConnection();
    const result = await pool
      .request()
      .input("id", db.sql.Int, id)
      .input("title", db.sql.NVarChar, title)
      .input("type", db.sql.NVarChar, type)
      .input("moneySpent", db.sql.Float, moneySpent)
      .input("date", db.sql.Date, date)
      .input("details", db.sql.NVarChar, details)
      .query(
        "UPDATE MedicalRecord SET title = @title, type = @type, moneySpent = @moneySpent, date = @date, details = @details WHERE id = @id"
      );

    res.send("Record updated successfully");
    // Broadcasting the update to all connected WebSocket clients
    wss.clients.forEach((client) => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(
          JSON.stringify({
            action: "update",
            id: id,
            record: { title, type, moneySpent, date, details },
          })
        );
      }
    });
  } catch (err) {
    console.error("Failed to update record:", err);
    res.status(500).send("Failed to update record");
  }
}

async function deleteRecord(req, res, wss) {
  try {
    const { id } = req.params;
    const pool = await db.getConnection();
    await pool
      .request()
      .input("id", db.sql.Int, id)
      .query("DELETE FROM MedicalRecord WHERE id = @id");

    res.send("Record deleted successfully");
    // Inform all connected WebSocket clients of the deletion
    wss.clients.forEach((client) => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(JSON.stringify({ action: "delete", id: id }));
      }
    });
  } catch (err) {
    console.error("Failed to delete record:", err);
    res.status(500).send("Failed to delete record");
  }
}

function formatDate(dateString) {
  const date = new Date(dateString);
  const year = date.getFullYear();
  const month = (date.getMonth() + 1).toString().padStart(2, "0"); // JavaScript months are 0-indexed.
  const day = date.getDate().toString().padStart(2, "0");
  return `${year}-${month}-${day}`;
}

module.exports = {
  getAllRecords,
  getRecordById,
  createRecord,
  updateRecord,
  deleteRecord,
};
