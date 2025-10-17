<template>
  <div class="login-container">
    <b-card class="login-card">
      <!-- Logo -->
      <div class="text-center mb-4">
        <img src="@/assets/logo.png" alt="Logo" class="login-logo" />
      </div>

      <!-- Form -->
      <b-form @submit.prevent="onSubmit">
        <b-form-group label="Username">
          <b-form-input
            v-model="username"
            placeholder="Masukkan username"
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
              <!-- Gunakan Font Awesome untuk mata -->
              <i :class="showPassword ? 'fa fa-eye-slash' : 'fa fa-eye'"></i>
            </span>
          </div>
        </b-form-group>

        <b-button type="submit" variant="primary" block>Masuk</b-button>
      </b-form>

      <!-- Footer -->
      <div class="login-footer d-flex justify-content-between mt-3">
        <small class="text-muted">© 2025 by Hafidz</small>
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
      password: "",
      showPassword: false, // kontrol tampilan password
    };
  },
  methods: {
    togglePassword() {
      this.showPassword = !this.showPassword;
    },
    async onSubmit() {
      try {
        const res = await axios.post("http://192.168.40.200:5000/api/users/login", {
          username: this.username,
          password: this.password,
        });

        localStorage.setItem("token", res.data.token);
        Swal.fire("Sukses", res.data.message, "success");
        this.$router.push("/dashboard");
      } catch (err) {
        const message =
          (err.response && err.response.data && err.response.data.message) ||
          "Login gagal.";
        Swal.fire("Gagal", message, "error");
      }
    },
  },
};
</script>

<style scoped>
/* Layout tengah */
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}

/* Card transparan + shadow */
.login-card {
  width: 400px;
  border-radius: 16px;
  padding: 25px;
  background: rgba(255, 255, 255, 0.85); /* transparan dikit */
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.25); /* shadow lembut */
  backdrop-filter: blur(0px);
}

/* Logo */
.login-logo {
  width: 100px;
}

/* Password toggle */
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

/* Footer */
.login-footer {
  font-size: 13px;
  margin-top: 20px;
}

.register-link {
  text-decoration: none;
}

.register-link:hover span {
  text-decoration: underline;
}
</style>
