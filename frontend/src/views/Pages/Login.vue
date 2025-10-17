<template>
  <div class="login-container">
    <b-card class="login-card shadow">
      <h3 class="text-center mb-4">🔐 Login</h3>
      <b-form @submit.prevent="onSubmit">
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
    };
  },
  methods: {
    async onSubmit() {
      try {
        const res = await axios.post("http://192.168.10.9:5000/api/users/login", {
          username: this.username,
          password: this.password,
        });

        // Simpan token
        localStorage.setItem("token", res.data.token);

        Swal.fire("Sukses", res.data.message, "success");

        // Redirect ke dashboard
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
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background: linear-gradient(135deg, #83a4d4, #b6fbff);
}

.login-card {
  width: 400px;
  border-radius: 16px;
  padding: 20px;
}
</style>
