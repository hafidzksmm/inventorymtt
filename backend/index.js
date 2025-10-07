const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");

const app = express();
const PORT = 5000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Import route
const inventorywsRoutes = require("./inventoryws");
const inventoryprojekRoutes = require("./inventoryprojek");

// Gunakan route
app.use("/api/inventaris", inventorywsRoutes);
app.use("/api/inventaryprojek", inventoryprojekRoutes);

// Root route
app.get("/", (req, res) => {
  res.send("🚀 API Utama Inventaris berjalan!");
});

// Jalankan server
app.listen(PORT, () => {
  console.log(`✅ Server berjalan di http://localhost:${PORT}`);
});
