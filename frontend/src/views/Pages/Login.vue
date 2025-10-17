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
import axios from "axios";
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

      if (!this.username || !this.password) {
        this.error = "Username dan password wajib diisi.";
        return;
      }

      try {
        const res = await axios.post("http://192.168.20.17:50/api/users/login", {
          username: this.username,
          password: this.password,
        });

        Swal.fire("Berhasil", "Login berhasil!", "success");
        localStorage.setItem("user", JSON.stringify(res.data.user));
        this.$router.push("/dashboard");
      } catch (err) {
        this.error =
          (err.response && err.response.data && err.response.data.message) ||
          "Terjadi kesalahan saat login.";
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
}
</style>
