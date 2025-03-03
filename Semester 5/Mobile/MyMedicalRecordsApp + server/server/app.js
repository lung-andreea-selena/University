const express = require("express");
const http = require("http");
const WebSocket = require("ws");
const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

const recordController = require("./medicalRecordsController");

// Middleware
app.use(express.json());

// WebSocket connection handling
wss.on("connection", function connection(ws) {
  console.log("A new client connected.");

  ws.on("message", function incoming(message) {
    console.log("received: %s", message);
  });

  ws.on("close", () => {
    console.log("Client has disconnected.");
  });
});

// RESTful HTTP Routes
app.get("/records", recordController.getAllRecords);
app.get("/records/:id", (req, res) =>
  recordController.getRecordById(req, res, wss)
);
app.post("/records", (req, res) =>
  recordController.createRecord(req, res, wss)
);
app.put("/records/:id", (req, res) =>
  recordController.updateRecord(req, res, wss)
);
app.delete("/records/:id", (req, res) =>
  recordController.deleteRecord(req, res, wss)
);

// Start server
const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
