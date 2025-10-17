const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");

const app = express();
const PORT = 50;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Import routes
const inventorywsRoutes = require("./inventoryws");
const inventoryprojekRoutes = require("./inventoryprojek");
const assetjualRoutes = require("./assetjual");
const usersRoutes = require("./users");

// Gunakan route
app.use("/api/inventaris", inventorywsRoutes);
app.use("/api/inventaryprojek", inventoryprojekRoutes);
app.use("/api/assetjual", assetjualRoutes);
app.use("/api/users", usersRoutes);

// Root test
app.get("/", (req, res) => {
  res.send("🚀 API Utama Inventaris berjalan!");
});

// Jalankan server
app.listen(PORT, () => {
  console.log(`✅ Server berjalan di http://192.168.40.200:${PORT}`);
});
