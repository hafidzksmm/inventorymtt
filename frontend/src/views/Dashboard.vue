<template>
  <div>
    <header class="video-header">
      <!-- 🖼️ Background Image -->
<img src="@/assets/bg-regislogin3.jpg" alt="Background" class="video-bg" />


      <!-- 🧠 Konten Header -->
      <div class="header-content">
        <!-- Judul di kiri atas -->
        <h1 class="dashboard-title">DASHBOARD</h1>


        <!-- Ikon navigasi di bawah kiri -->
        <div class="icon-row ml-4 mt-1">
          <div class="col-auto">
            <router-link to="/inventoryws" class="image-link">
              <img
                src="@/assets/inventoryworkshop.png"
                alt="Inventory WS"
                class="icon-image shadow-lg"
              />
              <p class="icon-label">Inventory WS</p>
            </router-link>
          </div>

          <div class="col-auto">
            <router-link to="/inventoryproject" class="image-link">
              <img
                src="@/assets/inventoryproject.png"
                alt="Inventory Project"
                class="icon-image shadow-lg middle-icon"
              />
              <p class="icon-label">Inventory Project</p>
            </router-link>
          </div>

          <div class="col-auto">
            <router-link to="/assetjual" class="image-link">
              <img
                src="@/assets/assetjual.png"
                alt="Asset Jual"
                class="icon-image shadow-lg"
              />
              <p class="icon-label">Asset Jual</p>
            </router-link>
          </div>
        </div>
      </div>
    </header>

    <!-- 📊 Statistik -->
    <div class="container-fluid mt--2 mb-4">
      <div class="row justify-content-center">
        <div class="col-xl-8 col-lg-10">
          <div class="card shadow">
            <div class="card-header border-0 text-center bg-light">
              <h3 class="mb-0">📈 Statistik Umum Aset</h3>
            </div>
            <div class="card-body text-center">
              <canvas id="chart-pie" height="130"></canvas>
              <div class="mt-3">
                <p><strong>Inventory WS:</strong> {{ countInventaris }}</p>
                <p><strong>Inventory Project:</strong> {{ countInventaryProjek }}</p>
                <p><strong>Asset Jual:</strong> {{ countAssetJual }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { Chart, registerables } from "chart.js";
Chart.register(...registerables);

export default {
  name: "Dashboard",
  data() {
    return {
      // 📊 Data statis (contoh dummy)
      countInventaris: 45,
      countInventaryProjek: 30,
      countAssetJual: 15,
      chart: null,
    };
  },
  methods: {
    initChart() {
      const ctx = document.getElementById("chart-pie").getContext("2d");
      if (this.chart) this.chart.destroy();

      this.chart = new Chart(ctx, {
        type: "pie",
        data: {
          labels: ["Inventory WS", "Inventory Project", "Asset Jual"],
          datasets: [
            {
              data: [
                this.countInventaris,
                this.countInventaryProjek,
                this.countAssetJual,
              ],
              backgroundColor: ["#5e72e4", "#2dce89", "#fb6340"],
              borderColor: "#fff",
              borderWidth: 2,
            },
          ],
        },
        options: {
          responsive: true,
          plugins: {
            legend: { position: "bottom" },
          },
        },
      });
    },
  },
  mounted() {
    this.initChart(); // langsung jalankan chart tanpa ambil data dari API
  },
};
</script>

<style scoped>
/* 🎥 Background Video */
.video-header {
  position: relative;
  height: 70vh;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}
.video-bg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  z-index: -1;
}


/* 🔗 Image Link Container */
.image-link {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-decoration: none;
  margin: 0 8px;
}
.icon-label {
  margin-top: 6px;
  font-size: 0.9rem;
  font-weight: 600;
  color: #fff;
  text-align: center;
  text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.7);
  white-space: nowrap;
}

/* 🧠 Konten Header */
.header-content {
  position: relative;
  z-index: 2;
  width: 100%;
  height: 100%;
  padding: 40px;
}
.dashboard-title {
  position: absolute;
  top: 30px;
  left: 40px;
  font-size: 2rem;
  font-weight: 700;
  color: #fff;
  text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.7);
}

/* Logo tengah */
.logo-center {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -60%);
  text-align: center;
}
.main-logo-center {
  width: 260px;
  max-width: 100%;
  animation: float 3s infinite ease-in-out;
  filter: drop-shadow(0px 0px 10px rgba(255, 255, 255, 0.8));
}
@keyframes float {
  0%, 100% { transform: translate(-50%, -60%) scale(1); }
  50% { transform: translate(-50%, -60%) scale(1.05); }
}

/* Baris ikon bawah */
.icon-row {
  position: absolute;
  bottom: 0px;
  display: flex;
}

/* Gaya ikon */
.icon-image {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background-color: rgba(255, 255, 255, 0.15);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}
.icon-image:hover {
  transform: scale(1.15);
  box-shadow: 0px 6px 15px rgba(255, 255, 255, 0.4);
}

/* Responsif */
@media (max-width: 768px) {
  .dashboard-title {
    font-size: 1.5rem;
    top: 15px;
    left: 20px;
  }
  .main-logo-center {
    width: 180px;
  }
  .icon-row {
    left: 20px;
    bottom: 25px;
    gap: 10px;
  }
  .icon-image {
    width: 60px;
    height: 60px;
  }
}
</style>
