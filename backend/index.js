const express = require("express");
const cors = require("cors");

const app = express();
const PORT = 5000;

// ✅ Middleware utama
app.use(cors({
  origin: "*", // bisa diganti IP frontend kalau mau dibatasi
  methods: ["GET", "POST", "PUT", "DELETE"],
  allowedHeaders: ["Content-Type", "Authorization"]
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ✅ Import semua route
const inventorywsRoutes = require("./inventoryws");
const inventoryprojekRoutes = require("./inventoryprojek");
const assetjualRoutes = require("./assetjual");
const usersRoutes = require("./users");

// ✅ Gunakan route
app.use("/api/inventaris", inventorywsRoutes);
app.use("/api/inventaryprojek", inventoryprojekRoutes);
app.use("/api/assetjual", assetjualRoutes);
app.use("/api/users", usersRoutes);

// ✅ Root test
app.get("/", (req, res) => {
  res.send("🚀 API Utama Inventaris berjalan via HTTP!");
});

// ✅ Jalankan server
app.listen(PORT, "0.0.0.0", () => {
  console.log(`✅ Server berjalan di http://localhost:${PORT}`);
});
