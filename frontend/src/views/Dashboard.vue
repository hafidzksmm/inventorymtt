<template>
  <div>
    <header class="video-header">
      <!-- 🎥 Background Video -->
      <video autoplay muted loop playsinline class="video-bg">
        <source src="@/assets/vidio.mp4" type="video/mp4" />
        Browser kamu tidak mendukung video HTML5.
      </video>

      <!-- 🧠 Konten Header -->
<div class="header-content">
  <!-- Judul di kiri atas -->
  <h1 class="dashboard-title">DASHBOARD</h1>

  <!-- Logo di tengah -->
  <div class="logo-center">
    <img
      src="@/assets/logo.png"
      alt="Logo Media Touch"
      class="main-logo-center"
    />
  </div>

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
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import { Chart, registerables } from "chart.js";
Chart.register(...registerables);

export default {
  name: "Dashboard",
  data() {
    return {
      countInventaris: 0,
      countInventaryProjek: 0,
      countAssetJual: 0,
      chart: null,
    };
  },
  methods: {
    async fetchCounts() {
      try {
        const [inventarisRes, inventaryRes, assetRes] = await Promise.all([
          axios.get("http://192.168.20.17:5000/api/inventaris/inventaris"),
          axios.get("http://192.168.20.17:5000/api/inventaryprojek/inventaryprojek"),
          axios.get("http://192.168.20.17:5000/api/assetjual/assetjual"),
        ]);

        this.countInventaris = inventarisRes.data.length;
        this.countInventaryProjek = inventaryRes.data.length;
        this.countAssetJual = assetRes.data.length;

        this.initChart();
      } catch (error) {
        console.error("Gagal mengambil data:", error);
      }
    },

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
    this.fetchCounts();
  },
};
</script>

<style scoped>
/* 🎥 Background Video */
.video-header {
  position: relative;
  height: 70vh; /* ✅ Lebih kecil dari full screen */
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
  z-index: 0;
}
/* 🔗 Image Link Container */
.image-link {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-decoration: none;
  margin: 0 8px; /* ✅ lebih rapat antar ikon */
}

/* 🧩 Label teks di bawah ikon */
.icon-label {
  margin-top: 6px;
  font-size: 0.9rem;
  font-weight: 600;
  color: #fff;
  text-align: center;
  text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.7);
  white-space: nowrap;
}

/* 🌿 Responsif */
@media (max-width: 768px) {
  .image-link {
    margin: 0 5px;
  }
  .icon-label {
    font-size: 0.75rem;
  }
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
  letter-spacing: 1px;
  text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.7);
}

/* Logo tetap di tengah layar */
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
  animation: pulse 3s infinite ease-in-out;
  filter: drop-shadow(0px 0px 10px rgba(255, 255, 255, 0.6));
}

/* Baris ikon di kiri bawah */
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

/* Ikon tengah sedikit besar */
.middle-icon {
  transform: scale(1.1);
}

/* Animasi lembut */
@keyframes pulse {
  0% { transform: translate(-50%, -60%) scale(1); }
  50% { transform: translate(-50%, -60%) scale(1.05); }
  100% { transform: translate(-50%, -60%) scale(1); }
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
/* 🧩 Judul Dashboard */
.dashboard-title {
  position: absolute;
  top: 20px;
  left: 40px;
  font-size: 2rem;
  font-weight: 700;
  letter-spacing: 1px;
  color: #fff;
  text-shadow: 2px 2px 6px rgba(0, 0, 0, 0.8);
}

/* 🔵 Logo Tengah (dibedakan class) */
.logo-center {
  margin-top: 40px;
}
.main-logo-center {
  width: 215px;
  max-width: 100%;
  animation: float 3s infinite ease-in-out;
  filter: drop-shadow(0px 0px 15px rgba(255, 255, 255, 1));
}

/* 💫 Animasi lembut */
@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}

/* 🧩 Gambar ikon di bawah logo */
.icon-image {
  width: 100%;
  max-width: 90px;
  border-radius: 50%;
  background-color: rgba(255, 255, 255, 0.1);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}
.icon-image:hover {
  transform: scale(1.2);
  box-shadow: 0px 6px 20px rgba(255, 255, 255, 0.4);
}

/* 🌿 Icon tengah sedikit berbeda */
.middle-icon {
  transform: scale(1.1);
}

/* 📱 Responsif */
@media (max-width: 768px) {
  .video-header {
    height: 60vh;
  }
  .dashboard-title {
    top: 10px;
    left: 20px;
    font-size: 1.5rem;
  }
  .main-logo-center {
    width: 180px;
  }
  .icon-image {
    max-width: 65px;
  }
}
</style>
