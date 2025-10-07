<template>
  <div>
    <!-- Header -->
    <base-header class="pb-6 pb-8 pt-5 pt-md-8 bg-gradient-danger">
      <h2 class="text-white">📦 Inventory Workshop</h2>
    </base-header>

    <div class="container-fluid mt--7">
      <b-card>
        <!-- Baris atas: tombol tambah dan search -->
        <div class="d-flex justify-content-between align-items-center mb-3">
          <b-button variant="success" @click="showAddModal">+ Tambah Data</b-button>

          <b-form-input
            v-model="search"
            placeholder="Cari data..."
            class="w-25"
            size="sm"
          ></b-form-input>
        </div>

        <!-- Tabel -->
        <b-table
          striped
          hover
          bordered
          responsive
          small
          :items="filteredItems"
          :fields="fields"
          :per-page="perPage"
          :current-page="currentPage"
          class="compact-table"
        >
          <template #cell(created_at)="data">
            {{ new Date(data.item.created_at).toLocaleString() }}
          </template>

          <template #cell(qty)="data">
            {{ data.item.qty }} {{ data.item.satuan }}
          </template>

          <template #cell(actions)="row">
            <b-button size="sm" variant="primary" @click="showEditModal(row.item)">Edit</b-button>
            <b-button size="sm" variant="danger" class="ml-1" @click="deleteItem(row.item.id)">Hapus</b-button>
          </template>
        </b-table>

        <!-- Pagination -->
        <b-pagination
          v-model="currentPage"
          :total-rows="filteredItems.length"
          :per-page="perPage"
          align="center"
          class="my-2"
        ></b-pagination>
      </b-card>
    </div>

    <!-- Modal Tambah/Edit -->
    <b-modal v-model="isModalOpen" :title="isEdit ? 'Edit Data' : 'Tambah Data'" hide-footer>
      <b-form @submit.prevent="isEdit ? updateItem() : createItem()">
        <b-form-group label="Nama Barang">
          <b-form-input v-model="form.nama_barang" required></b-form-input>
        </b-form-group>

        <b-form-group label="Merk">
          <b-form-input v-model="form.merk"></b-form-input>
        </b-form-group>

        <b-form-group label="Deskripsi">
          <b-form-textarea v-model="form.deskripsi"></b-form-textarea>
        </b-form-group>

        <b-form-group label="Dimensi">
          <b-form-input v-model="form.dimensi"></b-form-input>
        </b-form-group>

        <b-form-group label="Jumlah">
          <b-form-input type="number" v-model="form.qty" required></b-form-input>
        </b-form-group>

        <b-form-group label="Satuan">
          <b-form-input v-model="form.satuan"></b-form-input>
        </b-form-group>

        <b-form-group label="Lokasi">
          <b-form-input v-model="form.lokasi"></b-form-input>
        </b-form-group>

        <div class="text-right">
          <b-button variant="secondary" @click="isModalOpen = false">Batal</b-button>
          <b-button type="submit" variant="success">{{ isEdit ? 'Update' : 'Simpan' }}</b-button>
        </div>
      </b-form>
    </b-modal>
  </div>
</template>

<script>
import Vue from "vue";
import VueClipboard from "vue-clipboard2";
import axios from "axios";
import BaseHeader from "@/components/BaseHeader";

Vue.use(VueClipboard);

export default {
  name: "InventarisTable",
  components: { BaseHeader },
  data() {
    return {
      items: [],
      fields: [
        { key: "nama_barang", label: "Nama Barang" },
        { key: "merk", label: "Merk" },
        { key: "deskripsi", label: "Deskripsi" },
        { key: "dimensi", label: "Dimensi" },
        { key: "qty", label: "Jumlah" },
        { key: "lokasi", label: "Lokasi" },
        { key: "created_at", label: "Tanggal Input" },
        { key: "actions", label: "Aksi" },
      ],

      isModalOpen: false,
      isEdit: false,
      form: {
        id: null,
        nama_barang: "",
        merk: "",
        deskripsi: "",
        dimensi: "",
        qty: "",
        satuan: "",
        lokasi: "",
      },

      search: "",
      perPage: 10,
      currentPage: 1,
    };
  },
  computed: {
    filteredItems() {
      if (!this.search) return this.items;
      const searchLower = this.search.toLowerCase();
      return this.items.filter((item) => {
        const nama = item.nama_barang ? item.nama_barang.toLowerCase() : "";
        const merk = item.merk ? item.merk.toLowerCase() : "";
        const deskripsi = item.deskripsi ? item.deskripsi.toLowerCase() : "";
        const lokasi = item.lokasi ? item.lokasi.toLowerCase() : "";
        return (
          nama.includes(searchLower) ||
          merk.includes(searchLower) ||
          deskripsi.includes(searchLower) ||
          lokasi.includes(searchLower)
        );
      });
    },
  },
  methods: {
    async fetchData() {
      try {
        const res = await axios.get("http://localhost:5000/api/inventaris/inventaris");
        this.items = res.data;
      } catch (err) {
        console.error("Gagal fetch data:", err);
      }
    },
    showAddModal() {
      this.resetForm();
      this.isEdit = false;
      this.isModalOpen = true;
    },
    showEditModal(item) {
      this.form = { ...item };
      this.isEdit = true;
      this.isModalOpen = true;
    },
    async createItem() {
      try {
        await axios.post("http://localhost:5000/api/inventaris/inventaris", this.form);
        this.isModalOpen = false;
        this.fetchData();
      } catch (err) {
        console.error("Gagal tambah data:", err);
      }
    },
    async updateItem() {
      try {
        await axios.put(`http://localhost:5000/api/inventaris/inventaris/${this.form.id}`, this.form);
        this.isModalOpen = false;
        this.fetchData();
      } catch (err) {
        console.error("Gagal update data:", err);
      }
    },
    async deleteItem(id) {
      if (confirm("Yakin ingin menghapus data ini?")) {
        try {
          await axios.delete(`http://localhost:5000/api/inventaris/inventaris/${id}`);
          this.fetchData();
        } catch (err) {
          console.error("Gagal hapus data:", err);
        }
      }
    },
    resetForm() {
      this.form = {
        id: null,
        nama_barang: "",
        merk: "",
        deskripsi: "",
        dimensi: "",
        qty: "",
        satuan: "",
        lokasi: "",
      };
    },
  },
  mounted() {
    this.fetchData();
  },
};
</script>

<style scoped>
.compact-table td,
.compact-table th {
  padding: 0.4rem !important; /* lebih rapat antar kolom */
  vertical-align: middle !important;
  white-space: nowrap;
}

.compact-table {
  font-size: 0.9rem; /* sedikit lebih kecil */
}
</style>
