const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");

const app = express();
const PORT = 1080; // <- pakai port publik kamu

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
  res.send("🚀 API Utama Inventaris berjalan via HTTP!");
});

// Jalankan server HTTP
app.listen(PORT, "0.0.0.0", () => {
  console.log(`✅ Server berjalan di http://103.56.92.112:${PORT}`);
});
