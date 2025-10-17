<template>
  <div>
    <!-- Header -->
    <base-header class="pb-6 pb-8 pt-5 pt-md-8 bg-gradient-danger">
      <h2 class="text-white">📦 Inventory Workshop</h2>
    </base-header>

    <div class="container-fluid mt--7">
      <b-card>
        <!-- 🔍 Baris atas -->
        <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap">
          <div class="mb-2 d-flex align-items-center flex-wrap">
            <b-button variant="success" @click="showAddModal">+ Tambah Data</b-button>
            <b-button variant="primary" class="ml-2" @click="showImportModal = true">
              <i class="fas fa-file-import"></i> Import Excel
            </b-button>
            <b-button variant="warning" class="ml-2" @click="downloadExcel">
              <i class="fas fa-file-download"></i> Download Excel
            </b-button>
            <b-button variant="info" class="ml-2" @click="showFilterModal = true">
              <i class="fas fa-filter"></i> Filter
            </b-button>
          </div>

          <!-- 🔎 Search -->
          <b-form-input
            v-model="search"
            placeholder="Cari cepat..."
            class="w-25"
            size="sm"
          ></b-form-input>
        </div>

        <!-- 📋 Tabel -->
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

        <!-- 📄 Pagination -->
        <b-pagination
          v-model="currentPage"
          :total-rows="filteredItems.length"
          :per-page="perPage"
          align="center"
          class="my-2"
        ></b-pagination>
      </b-card>
    </div>

    <!-- 📝 Modal Tambah/Edit -->
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

        <b-form-group label="Satuan">
          <b-form-input v-model="form.satuan"></b-form-input>
        </b-form-group>

        <b-form-group label="Jumlah">
          <b-form-input type="number" v-model="form.qty" required></b-form-input>
        </b-form-group>

        <b-form-group label="Lokasi">
          <b-form-select v-model="form.lokasi" :options="lokasiOptions" required />
        </b-form-group>

        <div class="text-right">
          <b-button variant="secondary" @click="isModalOpen = false">Batal</b-button>
          <b-button type="submit" variant="success">{{ isEdit ? 'Update' : 'Simpan' }}</b-button>
        </div>
      </b-form>
    </b-modal>

    <!-- 📥 Modal Import Excel -->
    <b-modal v-model="showImportModal" title="Import Data dari Excel" hide-footer>
      <b-form @submit.prevent="handleImportExcel">
        <b-form-group label="Pilih Lokasi">
          <b-form-select v-model="selectedLokasi" :options="lokasiOptions" required />
        </b-form-group>

        <b-form-group label="Pilih File Excel">
          <b-form-file
            v-model="selectedFile"
            accept=".xlsx, .xls"
            placeholder="Pilih file Excel..."
            browse-text="Browse"
            required
          />
        </b-form-group>

        <div class="text-right">
          <b-button variant="secondary" @click="showImportModal = false">Batal</b-button>
          <b-button type="submit" variant="primary" :disabled="!selectedFile">Import</b-button>
        </div>
      </b-form>
    </b-modal>

    <!-- 🧩 Modal Filter -->
    <b-modal v-model="showFilterModal" title="Filter Data" hide-footer>
      <b-form @submit.prevent="applyFilter">
        <b-form-group label="Nama Barang">
          <b-form-select
            v-model="filters.nama_barang"
            :options="namaBarangOptions"
            @change="filterMerkOptions"
          ></b-form-select>
        </b-form-group>

        <b-form-group label="Merk">
          <b-form-select
            v-model="filters.merk"
            :options="merkOptions"
            @change="filterDeskripsiOptions"
            :disabled="!filters.nama_barang"
          ></b-form-select>
        </b-form-group>

        <b-form-group label="Deskripsi">
          <b-form-select
            v-model="filters.deskripsi"
            :options="deskripsiOptions"
            :disabled="!filters.merk"
          ></b-form-select>
        </b-form-group>

        <b-form-group label="Lokasi">
          <b-form-select v-model="filters.lokasi" :options="lokasiOptions"></b-form-select>
        </b-form-group>

        <div class="text-right">
          <b-button variant="secondary" @click="resetFilter">Reset</b-button>
          <b-button type="submit" variant="info">Filter</b-button>
        </div>
      </b-form>
    </b-modal>
  </div>
</template>

<script>
import Vue from "vue";
import VueClipboard from "vue-clipboard2";
import axios from "axios";
import * as XLSX from "xlsx";
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
        { key: "satuan", label: "Satuan" },
        { key: "qty", label: "Jumlah" },
        { key: "lokasi", label: "Lokasi" },
        { key: "created_at", label: "Tanggal Input" },
        { key: "actions", label: "Aksi" },
      ],

      isModalOpen: false,
      isEdit: false,
      showImportModal: false,
      showFilterModal: false,

      form: {
        id: null,
        nama_barang: "",
        merk: "",
        deskripsi: "",
        dimensi: "",
        satuan: "",
        qty: "",
        lokasi: "",
      },

      filters: {
        nama_barang: "",
        merk: "",
        deskripsi: "",
        lokasi: "",
      },

      lokasiOptions: [],
      namaBarangOptions: [],
      merkOptions: [],
      deskripsiOptions: [],
      selectedFile: null,
      selectedLokasi: "",
      search: "",
      perPage: 100,
      currentPage: 1,
    };
  },

  computed: {
    filteredItems() {
      let filtered = [...this.items];

      if (this.search) {
        const s = this.search.toLowerCase();
        filtered = filtered.filter((i) =>
          ["nama_barang", "merk", "deskripsi", "lokasi"].some((key) =>
            (i[key] ? i[key].toLowerCase() : "").includes(s)
          )
        );
      }

      // 🧩 Filter berantai
      if (this.filters.nama_barang)
        filtered = filtered.filter(
          (i) => i.nama_barang === this.filters.nama_barang
        );
      if (this.filters.merk)
        filtered = filtered.filter((i) => i.merk === this.filters.merk);
      if (this.filters.deskripsi)
        filtered = filtered.filter((i) => i.deskripsi === this.filters.deskripsi);
      if (this.filters.lokasi)
        filtered = filtered.filter((i) => i.lokasi === this.filters.lokasi);

      return filtered;
    },
  },

  methods: {
    async fetchData() {
      try {
        const res = await axios.get("http://192.168.40.200:5000/api/inventaris/inventaris");
        this.items = res.data;
        this.generateFilterOptions();
      } catch (err) {
        console.error("Gagal fetch data:", err);
      }
    },

    generateFilterOptions() {
      const uniqueNama = [...new Set(this.items.map((i) => i.nama_barang))].filter(Boolean);
      this.namaBarangOptions = [{ value: "", text: "Pilih Nama Barang" }, ...uniqueNama.map((n) => ({ value: n, text: n }))];

      const uniqueLokasi = [...new Set(this.items.map((i) => i.lokasi))].filter(Boolean);
      this.lokasiOptions = [{ value: "", text: "📍 Semua Lokasi" }, ...uniqueLokasi.map((l) => ({ value: l, text: l }))];
    },

    filterMerkOptions() {
      const filtered = this.items.filter(
        (i) => i.nama_barang === this.filters.nama_barang
      );
      const uniqueMerk = [...new Set(filtered.map((i) => i.merk))].filter(Boolean);
      this.merkOptions = [{ value: "", text: "Pilih Merk" }, ...uniqueMerk.map((m) => ({ value: m, text: m }))];
      this.filters.merk = "";
      this.filters.deskripsi = "";
      this.deskripsiOptions = [];
    },

    filterDeskripsiOptions() {
      const filtered = this.items.filter(
        (i) =>
          i.nama_barang === this.filters.nama_barang && i.merk === this.filters.merk
      );
      const uniqueDesc = [...new Set(filtered.map((i) => i.deskripsi))].filter(Boolean);
      this.deskripsiOptions = [{ value: "", text: "Pilih Deskripsi" }, ...uniqueDesc.map((d) => ({ value: d, text: d }))];
      this.filters.deskripsi = "";
    },

    applyFilter() {
      this.showFilterModal = false;
      this.currentPage = 1;
    },

    resetFilter() {
      this.filters = { nama_barang: "", merk: "", deskripsi: "", lokasi: "" };
      this.merkOptions = [];
      this.deskripsiOptions = [];
    },

    async handleImportExcel() {
      if (!this.selectedFile || !this.selectedLokasi) {
        alert("Harap pilih lokasi dan file Excel terlebih dahulu!");
        return;
      }
      const reader = new FileReader();
      reader.onload = async (e) => {
        const data = new Uint8Array(e.target.result);
        const workbook = XLSX.read(data, { type: "array" });
        const sheet = workbook.Sheets[workbook.SheetNames[0]];
        const jsonData = XLSX.utils.sheet_to_json(sheet);
        const dataWithLocation =
          this.selectedLokasi === "ALL"
            ? jsonData
            : jsonData.map((r) => ({ ...r, lokasi: this.selectedLokasi }));
        try {
          await axios.post(
            "http://192.168.40.200:5000/api/inventaris/inventaris/import",
            dataWithLocation
          );
          alert("✅ Import data berhasil!");
          this.showImportModal = false;
          this.selectedFile = null;
          this.selectedLokasi = "";
          this.fetchData();
        } catch (err) {
          console.error(err);
          alert("❌ Gagal import data ke server.");
        }
      };
      reader.readAsArrayBuffer(this.selectedFile);
    },

    downloadExcel() {
      const ws = XLSX.utils.json_to_sheet(this.filteredItems);
      const wb = XLSX.utils.book_new();
      XLSX.utils.book_append_sheet(wb, ws, "Inventaris_Workshop");
      XLSX.writeFile(wb, `Inventaris_Filtered.xlsx`);
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
      await axios.post("http://192.168.40.200:5000/api/inventaris/inventaris", this.form);
      this.isModalOpen = false;
      this.fetchData();
    },
    async updateItem() {
      await axios.put(
        `http://192.168.40.200:5000/api/inventaris/inventaris/${this.form.id}`,
        this.form
      );
      this.isModalOpen = false;
      this.fetchData();
    },
    async deleteItem(id) {
      if (confirm("Yakin ingin menghapus data ini?")) {
        await axios.delete(`http://192.168.40.200:5000/api/inventaris/inventaris/${id}`);
        this.fetchData();
      }
    },
    resetForm() {
      this.form = {
        id: null,
        nama_barang: "",
        merk: "",
        deskripsi: "",
        dimensi: "",
        satuan: "",
        qty: "",
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
  padding: 0.4rem !important;
  vertical-align: middle !important;
  white-space: nowrap;
}
.compact-table {
  font-size: 0.9rem;
}
</style>
