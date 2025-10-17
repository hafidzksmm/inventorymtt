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
import axios from "axios";
import * as XLSX from "xlsx";

export default {
  data() {
    return {
      items: [],
      search: "",
      currentPage: 1,
      perPage: 100,
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
        lokasi: ""
      },
      lokasiOptions: [
        { value: "ALL", text: "📍 Semua Lokasi" },
        { value: "", text: "Pilih Lokasi" }
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
        lokasi: ""
      },
      fields: [
        { key: "nama_barang", label: "Nama Barang" },
        { key: "jenis", label: "Jenis" },
        { key: "ukuran", label: "Ukuran" },
        { key: "dimensi", label: "Dimensi" },
        { key: "qty", label: "Jumlah" },
        { key: "lokasi", label: "Lokasi" },
        { key: "created_at", label: "Tanggal Dibuat" },
        { key: "actions", label: "Aksi" }
      ]
    };
  },
  computed: {
    filteredItems() {
      let data = [...this.items];

      if (this.filters.nama_barang)
        data = data.filter(i => i.nama_barang === this.filters.nama_barang);
      if (this.filters.jenis)
        data = data.filter(i => i.jenis === this.filters.jenis);
      if (this.filters.ukuran)
        data = data.filter(i => i.ukuran === this.filters.ukuran);
      if (this.filters.dimensi)
        data = data.filter(i => i.dimensi === this.filters.dimensi);
      if (this.filters.lokasi && this.filters.lokasi !== "ALL")
        data = data.filter(i => i.lokasi === this.filters.lokasi);

      if (this.search.trim()) {
        const kw = this.search.toLowerCase();
        data = data.filter(i =>
          `${i.nama_barang} ${i.jenis} ${i.ukuran} ${i.dimensi} ${i.lokasi}`
            .toLowerCase()
            .includes(kw)
        );
      }
      return data;
    }
  },
  methods: {
    async fetchItems() {
      const res = await axios.get("http://192.168.40.200:50/api/assetjual/assetjual");
      this.items = res.data;
      this.generateFilterOptions();
    },

    async fetchLokasi() {
      const res = await axios.get("http://192.168.40.200:50/api/assetjual/lokasi");
      this.lokasiOptions = [
        { value: "ALL", text: "📍 Semua Lokasi" },
        { value: "", text: "Pilih Lokasi" },
        ...[...new Set(res.data.map(i => i.lokasi))].map(l => ({ value: l, text: l }))
      ];
    },

    generateFilterOptions() {
      const unique = (key) =>
        [...new Set(this.items.map((i) => i[key]).filter(Boolean))].map((v) => ({
          value: v,
          text: v,
        }));

      this.namaBarangOptions = [{ value: "", text: "Pilih Nama Barang" }, ...unique("nama_barang")];
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
      this.form = {
        id: null,
        nama_barang: "",
        jenis: "",
        ukuran: "",
        dimensi: "",
        qty: 0,
        satuan: "",
        lokasi: ""
      };
      this.isModalOpen = true;
    },

    showEditModal(item) {
      this.isEdit = true;
      this.form = { ...item };
      this.isModalOpen = true;
    },

    async createItem() {
      await axios.post("http://192.168.40.200:50/api/assetjual", this.form);
      alert("✅ Data berhasil ditambahkan!");
      this.isModalOpen = false;
      this.fetchItems();
    },

    async updateItem() {
      await axios.put(`http://192.168.40.200:50/api/assetjual/${this.form.id}`, this.form);
      alert("✅ Data diperbarui!");
      this.isModalOpen = false;
      this.fetchItems();
    },

    async deleteItem(id) {
      if (confirm("Yakin ingin menghapus data ini?")) {
        await axios.delete(`http://192.168.40.200:50/api/assetjual/${id}`);
        this.fetchItems();
      }
    },

    async handleImportExcel() {
      if (!this.selectedFile || !this.selectedLokasi) {
        alert("⚠️ Harap pilih lokasi dan file Excel terlebih dahulu!");
        return;
      }
      const reader = new FileReader();
      reader.onload = async (e) => {
        const data = new Uint8Array(e.target.result);
        const workbook = XLSX.read(data, { type: "array" });
        const sheet = workbook.Sheets[workbook.SheetNames[0]];
        const jsonData = XLSX.utils.sheet_to_json(sheet);

        const withLoc =
          this.selectedLokasi === "ALL"
            ? jsonData
            : jsonData.map((r) => ({ ...r, lokasi: this.selectedLokasi }));

        await axios.post("http://192.168.40.200:50/api/assetjual/assetjual/import", withLoc);
        alert("✅ Import berhasil!");
        this.showImportModal = false;
        this.fetchItems();
      };
      reader.readAsArrayBuffer(this.selectedFile);
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
      this.filters = {
        nama_barang: "",
        jenis: "",
        ukuran: "",
        dimensi: "",
        lokasi: ""
      };
      this.generateFilterOptions();
      this.currentPage = 1;
    }
  },
  mounted() {
    this.fetchItems();
    this.fetchLokasi();
  }
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
