<template>
  <div class="register-container">
    <b-card class="register-card shadow">
      <h3 class="text-center mb-4">📝 Register</h3>
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
          <b-form-input
            v-model="password"
            type="password"
            placeholder="Masukkan password"
            required
          ></b-form-input>
        </b-form-group>

        <b-button type="submit" variant="success" block>Daftar</b-button>
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
      email: "",
      password: "",
    };
  },
  methods: {
    async onSubmit() {
      try {
        const res = await axios.post("http://192.168.10.9:5000/api/users/register", {
          username: this.username,
          email: this.email,
          password: this.password,
        });

        Swal.fire("Sukses", res.data.message, "success");

        // Reset form setelah berhasil
        this.username = "";
        this.email = "";
        this.password = "";

        // Arahkan ke halaman login
        this.$router.push("/login");
      } catch (err) {
        const message =
          (err.response && err.response.data && err.response.data.message) ||
          "Gagal mendaftar user.";

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
  background: linear-gradient(135deg, #6dd5fa, #ffffff);
}

.register-card {
  width: 400px;
  border-radius: 16px;
  padding: 20px;
}
</style>
