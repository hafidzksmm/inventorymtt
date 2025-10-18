<template>
  <div class="login-container">
    <b-card class="login-card shadow">
      <h3 class="text-center mb-4">🔐 Login</h3>
      <b-form @submit.prevent="handleLogin">
        <b-form-group label="Username">
          <b-form-input
            v-model="username"
            placeholder="Masukkan username"
            required
          ></b-form-input>
        </b-form-group>

        <b-form-group label="Password">
          <b-form-input
            v-model="password"
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

      // 🔒 Validasi input kosong
      if (!this.username || !this.password) {
        this.error = "Username dan password wajib diisi.";
        return;
      }

      // 🧩 Login statis
      const validUsername = "admin";
      const validPassword = "1q2w3e4r5T!";

      if (this.username === validUsername && this.password === validPassword) {
        Swal.fire("Berhasil", "Login berhasil!", "success");

        // Simpan status login di localStorage
        localStorage.setItem(
          "user",
          JSON.stringify({ username: this.username, role: "admin" })
        );

        // Arahkan ke dashboard
        this.$router.push("/dashboard");
      } else {
        this.error = "Username atau password salah.";
        Swal.fire("Gagal", this.error, "error");
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
}
</style>
