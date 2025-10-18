<template>
  <div>
    <!-- Header -->
    <base-header class="pb-6 pb-8 pt-5 pt-md-8 bg-gradient-danger">
      <h2 class="text-white">📦 Inventory Asset Jual</h2>
    </base-header>

    <div class="container-fluid mt--7">
      <b-card>
        <!-- 🔍 Baris atas -->
        <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap">
          <div class="mb-2 d-flex align-items-center flex-wrap">
            <b-button variant="success" @click="showAddModal">+ Tambah Data</b-button>
            <b-button variant="info" class="ml-2" @click="showFilterModal = true">
              <i class="fas fa-filter"></i> Filter
            </b-button>
            <b-button variant="primary" class="ml-2" @click="showImportModal = true">
              <i class="fas fa-file-import"></i> Import Excel
            </b-button>
            <b-button variant="warning" class="ml-2" @click="downloadExcel">
              <i class="fas fa-file-download"></i> Download Excel
            </b-button>
          </div>

          <!-- 🔎 Search -->
          <b-form-input
            v-model="search"
            placeholder="Cari data..."
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

    <!-- 🧾 Modal Filter -->
    <b-modal v-model="showFilterModal" title="Filter Data" hide-footer>
      <b-form @submit.prevent="applyFilter">
        <b-form-group label="Nama Barang">
          <b-form-select
            v-model="filters.nama_barang"
            :options="namaBarangOptions"
            @change="updateJenisOptions"
          ></b-form-select>
        </b-form-group>

        <b-form-group label="Jenis">
          <b-form-select
            v-model="filters.jenis"
            :options="jenisOptions"
            @change="updateUkuranOptions"
          ></b-form-select>
        </b-form-group>

        <b-form-group label="Ukuran">
          <b-form-select
            v-model="filters.ukuran"
            :options="ukuranOptions"
            @change="updateDimensiOptions"
          ></b-form-select>
        </b-form-group>

        <b-form-group label="Dimensi">
          <b-form-select
            v-model="filters.dimensi"
            :options="dimensiOptions"
          ></b-form-select>
        </b-form-group>

        <b-form-group label="Lokasi">
          <b-form-select v-model="filters.lokasi" :options="lokasiOptions"></b-form-select>
        </b-form-group>

        <div class="text-right">
          <b-button variant="secondary" @click="resetFilter">Reset</b-button>
          <b-button type="submit" variant="info">Terapkan Filter</b-button>
        </div>
      </b-form>
    </b-modal>

    <!-- 📝 Modal Tambah/Edit -->
    <b-modal v-model="isModalOpen" :title="isEdit ? 'Edit Data' : 'Tambah Data'" hide-footer>
      <b-form @submit.prevent="isEdit ? updateItem() : createItem()">
        <b-form-group label="Nama Barang">
          <b-form-input v-model="form.nama_barang" required></b-form-input>
        </b-form-group>

        <b-form-group label="Jenis">
          <b-form-input v-model="form.jenis"></b-form-input>
        </b-form-group>

        <b-form-group label="Ukuran">
          <b-form-input v-model="form.ukuran"></b-form-input>
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
  </div>
</template>

<script>
import * as XLSX from "xlsx";

export default {
  data() {
    return {
      items: [],
      search: "",
      currentPage: 1,
      perPage: 10,
      isModalOpen: false,
      isEdit: false,
      showFilterModal: false,
      showImportModal: false,
      selectedFile: null,
      selectedLokasi: "",
      filters: {
        nama_barang: "",
        jenis: "",
        ukuran: "",
        dimensi: "",
        lokasi: "",
      },
      lokasiOptions: [
        { value: "ALL", text: "📍 Semua Lokasi" },
        { value: "", text: "Pilih Lokasi" },
        { value: "Jakarta", text: "Jakarta" },
        { value: "Surabaya", text: "Surabaya" },
        { value: "Bandung", text: "Bandung" },
      ],
      namaBarangOptions: [],
      jenisOptions: [],
      ukuranOptions: [],
      dimensiOptions: [],
      form: {
        id: null,
        nama_barang: "",
        jenis: "",
        ukuran: "",
        dimensi: "",
        qty: 0,
        satuan: "",
        lokasi: "",
      },
      fields: [
        { key: "nama_barang", label: "Nama Barang" },
        { key: "jenis", label: "Jenis" },
        { key: "ukuran", label: "Ukuran" },
        { key: "dimensi", label: "Dimensi" },
        { key: "qty", label: "Jumlah" },
        { key: "lokasi", label: "Lokasi" },
        { key: "created_at", label: "Tanggal Dibuat" },
        { key: "actions", label: "Aksi" },
      ],
    };
  },

  computed: {
    filteredItems() {
      let data = [...this.items];

      if (this.filters.nama_barang)
        data = data.filter((i) => i.nama_barang === this.filters.nama_barang);
      if (this.filters.jenis)
        data = data.filter((i) => i.jenis === this.filters.jenis);
      if (this.filters.ukuran)
        data = data.filter((i) => i.ukuran === this.filters.ukuran);
      if (this.filters.dimensi)
        data = data.filter((i) => i.dimensi === this.filters.dimensi);
      if (this.filters.lokasi && this.filters.lokasi !== "ALL")
        data = data.filter((i) => i.lokasi === this.filters.lokasi);

      if (this.search.trim()) {
        const kw = this.search.toLowerCase();
        data = data.filter((i) =>
          `${i.nama_barang} ${i.jenis} ${i.ukuran} ${i.dimensi} ${i.lokasi}`
            .toLowerCase()
            .includes(kw)
        );
      }
      return data;
    },
  },

  methods: {
    // 💾 Data dummy
fetchItems() {
  this.items = [
    { id: 1, nama_barang: "Modul (Transceiver)", jenis: "SFP", ukuran: "1G", dimensi: "Dell", qty: 6, satuan: "pcs", lokasi: "data" },
    { id: 2, nama_barang: "Modul (Transceiver)", jenis: "SFP", ukuran: "1G", dimensi: "FINISAR", qty: 2, satuan: "pcs", lokasi: "data" },
    { id: 3, nama_barang: "Modul (Transceiver)", jenis: "SFP+", ukuran: "10G", dimensi: "Dell", qty: 4, satuan: "pcs", lokasi: "data" },
    { id: 4, nama_barang: "Modul (Transceiver)", jenis: "SFP+", ukuran: "10G", dimensi: "D-Link", qty: 42, satuan: "pcs", lokasi: "data" },
    { id: 5, nama_barang: "Modul (Transceiver)", jenis: "SFP+", ukuran: "10G", dimensi: "Edge-Core", qty: 6, satuan: "pcs", lokasi: "data" },
    { id: 6, nama_barang: "Modul (Transceiver)", jenis: "SFP+", ukuran: "10G", dimensi: "Huawei", qty: 1, satuan: "pcs", lokasi: "data" },
    { id: 7, nama_barang: "Modul (Transceiver)", jenis: "SFP+", ukuran: "10G", dimensi: "Lenovo", qty: 1, satuan: "pcs", lokasi: "data" },
    { id: 8, nama_barang: "Modul (Transceiver)", jenis: "SFP+", ukuran: "25G", dimensi: "Dell", qty: 9, satuan: "pcs", lokasi: "data" },
    { id: 9, nama_barang: "Modul (Transceiver)", jenis: "Konverter SFP to RJ45", ukuran: "1G", dimensi: "Copper", qty: 2, satuan: "pcs", lokasi: "data" },
    { id: 10, nama_barang: "Modul (Transceiver)", jenis: "Konverter SFP to RJ46", ukuran: "1G", dimensi: "Nokia", qty: 1, satuan: "pcs", lokasi: "data" },
    { id: 11, nama_barang: "Modul (Transceiver)", jenis: "Konverter SFP to RJ47", ukuran: "1G", dimensi: "Avago", qty: 1, satuan: "pcs", lokasi: "data" },
    { id: 12, nama_barang: "Modul (Transceiver)", jenis: "Konverter SFP to RJ48", ukuran: "1G", dimensi: "Linktel", qty: 1, satuan: "pcs", lokasi: "data" },
    { id: 13, nama_barang: "Modul (Transceiver)", jenis: "Konverter SFP to RJ49", ukuran: "10G", dimensi: "NETLINE", qty: 1, satuan: "pcs", lokasi: "data" },
    { id: 14, nama_barang: "Modul (Transceiver)", jenis: "QSFP", ukuran: "100G", dimensi: "Dell", qty: 10, satuan: "pcs", lokasi: "data" },
    { id: 15, nama_barang: "Modul (Transceiver)", jenis: "MPO", ukuran: "100G", dimensi: "Dell", qty: 4, satuan: "pcs", lokasi: "data" },
    { id: 16, nama_barang: "Konverter VGA", jenis: "Mini DP to VGA", ukuran: "", dimensi: "", qty: 48, satuan: "pcs", lokasi: "data" },
    { id: 17, nama_barang: "Konverter VGA", jenis: "", ukuran: "", dimensi: "", qty: 33, satuan: "pcs", lokasi: "data" },
    { id: 18, nama_barang: "RAM", jenis: "16GB", ukuran: "", dimensi: "", qty: 316, satuan: "pcs", lokasi: "data" },
    { id: 19, nama_barang: "RAM", jenis: "4GB", ukuran: "", dimensi: "", qty: 1, satuan: "pcs", lokasi: "data" },
    { id: 20, nama_barang: "Kabel KVM", jenis: "Digital", ukuran: "", dimensi: "", qty: 5, satuan: "pcs", lokasi: "data" },
    { id: 21, nama_barang: "Kabel KVM", jenis: "IP", ukuran: "", dimensi: "", qty: 5, satuan: "pcs", lokasi: "data" },
    { id: 22, nama_barang: "Kabel KVM", jenis: "Analog", ukuran: "", dimensi: "", qty: 123, satuan: "pcs", lokasi: "data" },
    { id: 23, nama_barang: "Kabel KVM", jenis: "PS/2", ukuran: "", dimensi: "", qty: 5, satuan: "pcs", lokasi: "data" },
    { id: 24, nama_barang: "Kabel KVM", jenis: "DAC", ukuran: "", dimensi: "", qty: 1, satuan: "pcs", lokasi: "data" },
    { id: 25, nama_barang: "Hard disk", jenis: "SAS 2.5 inc", ukuran: "1.2 TB", dimensi: "HGST", qty: 2, satuan: "pcs", lokasi: "data" },
  ];

  this.generateFilterOptions();
},

    generateFilterOptions() {
      const unique = (key) =>
        [...new Set(this.items.map((i) => i[key]).filter(Boolean))].map((v) => ({
          value: v,
          text: v,
        }));

      this.namaBarangOptions = [
        { value: "", text: "Pilih Nama Barang" },
        ...unique("nama_barang"),
      ];
      this.jenisOptions = [{ value: "", text: "Pilih Jenis" }];
      this.ukuranOptions = [{ value: "", text: "Pilih Ukuran" }];
      this.dimensiOptions = [{ value: "", text: "Pilih Dimensi" }];
    },

    updateJenisOptions() {
      const selected = this.filters.nama_barang;
      const jenisSet = [...new Set(this.items.filter(i => i.nama_barang === selected).map(i => i.jenis))];
      this.jenisOptions = [{ value: "", text: "Pilih Jenis" }, ...jenisSet.map(j => ({ value: j, text: j }))];
      this.filters.jenis = "";
      this.filters.ukuran = "";
      this.filters.dimensi = "";
      this.ukuranOptions = [{ value: "", text: "Pilih Ukuran" }];
      this.dimensiOptions = [{ value: "", text: "Pilih Dimensi" }];
    },

    updateUkuranOptions() {
      const selected = this.filters.jenis;
      const ukuranSet = [...new Set(this.items.filter(i => i.jenis === selected).map(i => i.ukuran))];
      this.ukuranOptions = [{ value: "", text: "Pilih Ukuran" }, ...ukuranSet.map(u => ({ value: u, text: u }))];
      this.filters.ukuran = "";
      this.filters.dimensi = "";
      this.dimensiOptions = [{ value: "", text: "Pilih Dimensi" }];
    },

    updateDimensiOptions() {
      const selected = this.filters.ukuran;
      const dimSet = [...new Set(this.items.filter(i => i.ukuran === selected).map(i => i.dimensi))];
      this.dimensiOptions = [{ value: "", text: "Pilih Dimensi" }, ...dimSet.map(d => ({ value: d, text: d }))];
      this.filters.dimensi = "";
    },

    showAddModal() {
      this.isEdit = false;
      this.form = { id: null, nama_barang: "", jenis: "", ukuran: "", dimensi: "", qty: 0, satuan: "", lokasi: "" };
      this.isModalOpen = true;
    },

    showEditModal(item) {
      this.isEdit = true;
      this.form = { ...item };
      this.isModalOpen = true;
    },

    createItem() {
      this.form.id = Date.now();
      this.form.created_at = new Date().toISOString();
      this.items.push({ ...this.form });
      alert("✅ Data berhasil ditambahkan!");
      this.isModalOpen = false;
    },

    updateItem() {
      const idx = this.items.findIndex((i) => i.id === this.form.id);
      if (idx !== -1) this.items.splice(idx, 1, { ...this.form });
      alert("✅ Data diperbarui!");
      this.isModalOpen = false;
    },

    deleteItem(id) {
      if (confirm("Yakin ingin menghapus data ini?")) {
        this.items = this.items.filter((i) => i.id !== id);
      }
    },

    handleImportExcel() {
      alert("📥 Fitur import hanya contoh (tidak aktif tanpa API).");
      this.showImportModal = false;
    },

    downloadExcel() {
      if (!this.filteredItems.length) {
        alert("Tidak ada data untuk diunduh!");
        return;
      }
      const ws = XLSX.utils.json_to_sheet(this.filteredItems);
      const wb = XLSX.utils.book_new();
      XLSX.utils.book_append_sheet(wb, ws, "Asset_Jual");
      XLSX.writeFile(wb, "Asset_Jual.xlsx");
    },

    applyFilter() {
      this.showFilterModal = false;
      this.currentPage = 1;
    },

    resetFilter() {
      this.filters = { nama_barang: "", jenis: "", ukuran: "", dimensi: "", lokasi: "" };
      this.generateFilterOptions();
      this.currentPage = 1;
    },
  },

  mounted() {
    this.fetchItems();
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
