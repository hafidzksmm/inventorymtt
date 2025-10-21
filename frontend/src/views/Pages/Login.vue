<template>
  <div class="login-container">
    <b-card class="login-card shadow">
      <h3 class="text-center mb-4">🔐 Login</h3>

      <b-form @submit.prevent="handleLogin">
        <b-form-group label="Username">
          <b-form-input
            v-model.trim="username"
            placeholder="Masukkan username"
            required
          ></b-form-input>
        </b-form-group>

        <b-form-group label="Password">
          <b-form-input
            v-model.trim="password"
            type="password"
            placeholder="Masukkan password"
            required
          ></b-form-input>
        </b-form-group>

        <b-button type="submit" variant="primary" block>Login</b-button>
      </b-form>

      <div v-if="error" class="text-danger text-center mt-3">
        {{ error }}
      </div>
    </b-card>
  </div>
</template>

<script>
import Swal from "sweetalert2";
import axios from "axios";

export default {
  data() {
    return {
      username: "",
      password: "",
      error: null,
    };
  },
  methods: {
    async handleLogin() {
      this.error = null;

      if (!this.username || !this.password) {
        this.error = "Username dan password wajib diisi.";
        Swal.fire("Peringatan", this.error, "warning");
        return;
      }

      try {
        // 🚀 Kirim request ke backend
        const response = await axios.post(
          "http://localhost:5000/api/users/login",
          {
            username: this.username,
            password: this.password,
          },
          {
            headers: {
              "Content-Type": "application/json",
            },
          }
        );

        console.log("Response dari backend:", response.data);

        const { success, message, user } = response.data;

        if (success === true) {
          Swal.fire("Berhasil", message || "Login berhasil!", "success");
          localStorage.setItem("user", JSON.stringify(user));
          this.$router.push("/dashboard");
        } else {
          const errMsg = message || "Username atau password salah.";
          this.error = errMsg;
          Swal.fire("Gagal", errMsg, "error");
        }
      } catch (err) {
        console.error("Error saat login:", err);
        this.error = "Tidak dapat terhubung ke server. Pastikan backend berjalan.";
        Swal.fire("Error", this.error, "error");
      }
    },
  },
};
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}

.login-card {
  width: 400px;
  border-radius: 16px;
  padding: 20px;
  background: white;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}
</style>
