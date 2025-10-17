<template>
  <div class="register-container">
    <b-card class="register-card">
      <!-- Logo -->
      <div class="text-center mb-4">
        <img src="@/assets/logo.png" alt="Logo" class="register-logo" />
      </div>

      <!-- Form register -->
      <b-form @submit.prevent="onSubmit">
        <b-form-group label="Username">
          <b-form-input
            v-model="username"
            placeholder="Masukkan username"
            required
          ></b-form-input>
        </b-form-group>

        <b-form-group label="Email">
          <b-form-input
            v-model="email"
            type="email"
            placeholder="Masukkan email"
            required
          ></b-form-input>
        </b-form-group>

        <b-form-group label="Password">
          <div class="password-wrapper">
            <b-form-input
              v-model="password"
              :type="showPassword ? 'text' : 'password'"
              placeholder="Masukkan password"
              required
            ></b-form-input>
            <span class="toggle-password" @click="togglePassword">
              <i :class="showPassword ? 'fa fa-eye-slash' : 'fa fa-eye'"></i>
            </span>
          </div>
        </b-form-group>

        <b-button type="submit" variant="success" block>Daftar</b-button>
      </b-form>

      <!-- Footer -->
      <div class="register-footer d-flex justify-content-between mt-3">
        <small class="text-muted">© 2025 by Apis</small>
        <router-link to="/login" class="login-link">
          Sudah punya akun? <span class="text-success">Login</span>
        </router-link>
      </div>
    </b-card>
  </div>
</template>

<script>
import axios from "axios";
import Swal from "sweetalert2";

export default {
  data() {
    return {
      username: "",
      email: "",
      password: "",
      showPassword: false,
    };
  },
  methods: {
    togglePassword() {
      this.showPassword = !this.showPassword;
    },

    async onSubmit() {
      if (!this.username || !this.email || !this.password) {
        return Swal.fire("Peringatan", "Semua field wajib diisi!", "warning");
      }

      try {
        console.log("📤 Mengirim data:", {
          username: this.username,
          email: this.email,
          password: this.password,
        });

        const res = await axios.post(
          "http://192.168.10.9:5000/api/users/register",
          {
            username: this.username,
            email: this.email,
            password: this.password,
            role: "user", // ✅ tambahkan default role
          },
          {
            headers: { "Content-Type": "application/json" },
          }
        );

        Swal.fire("Sukses", res.data.message, "success");

        this.username = "";
        this.email = "";
        this.password = "";
        this.$router.push("/login");
      } catch (err) {
        console.error("❌ Error:", err.response || err);
        const message =
          (err.response && err.response.data && err.response.data.message) ||
          "Gagal mendaftar user (Server Error).";
        Swal.fire("Gagal", message, "error");
      }
    },
  },
};
</script>

<style scoped>
.register-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}

.register-card {
  width: 400px;
  border-radius: 16px;
  padding: 25px;
  background: rgba(255, 255, 255, 0.85);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.25);
  backdrop-filter: blur(5px);
}

.register-logo {
  width: 100px;
}

.password-wrapper {
  position: relative;
}

.toggle-password {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  cursor: pointer;
  color: #6c757d;
  font-size: 18px;
}

.toggle-password:hover {
  color: #007bff;
}

.register-footer {
  font-size: 13px;
  margin-top: 20px;
}

.login-link {
  text-decoration: none;
}

.login-link:hover span {
  text-decoration: underline;
}
</style>
