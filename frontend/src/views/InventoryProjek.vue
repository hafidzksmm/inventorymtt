<template>
  <div>
    <base-header class="pb-6 pb-8 pt-5 pt-md-8 bg-gradient-danger">
      <h2 class="text-white">📦 Inventory Project</h2>
    </base-header>

    <b-container fluid class="mt--7">
      <b-row>
        <b-col>
          <b-card>
            <!-- 🔍 Search, Tambah, Import, Download, Filter -->
            <b-row class="align-items-center mb-3">
              <!-- 🔍 Search Bar -->
              <b-col md="4" sm="12" class="mb-2 mb-md-0">
                <b-input-group>
                  <b-form-input 
                    v-model="searchQuery" 
                    placeholder="Cari"
                    @input="onSearch"
                  />
                  <b-input-group-append>
                    <b-button variant="outline-secondary" @click="clearSearch">
                      <i class="fas fa-times"></i>
                    </b-button>
                  </b-input-group-append>
                </b-input-group>
              </b-col>

              <!-- 📦 Tombol Aksi -->
              <b-col md="8" sm="12" class="d-flex justify-content-md-end flex-wrap">
                <b-button variant="success" class="mb-2 mr-2" @click="showAddModal">
                  <i class="fas fa-plus"></i> Tambah Data
                </b-button>

                <b-button variant="info" class="mb-2 mr-2" @click="showFilterModal = true">
                  <i class="fas fa-filter"></i> Filter
                </b-button>

                <b-button variant="primary" class="mb-2 mr-2" @click="showImportModal = true">
                  <i class="fas fa-file-import"></i> Import Excel
                </b-button>

                <b-button variant="danger" class="mb-2" @click="downloadExcel">
                  <i class="fas fa-file-download"></i> Download Excel
                </b-button>
              </b-col>
            </b-row>

            <!-- 📋 Tabel -->
            <b-table 
              striped 
              hover 
              :items="pagedItems" 
              :fields="fields"
              :per-page="perPage"
              :current-page="currentPage"
              show-empty
              empty-text="Tidak ada data yang ditemukan"
            >
              <template #cell(actions)="row">
                <b-button size="sm" variant="info" @click="editItem(row.item)">
                  <i class="fas fa-edit"></i> Edit
                </b-button>
                <b-button size="sm" variant="danger" @click="deleteItem(row.item.id)" class="ml-1">
                  <i class="fas fa-trash"></i> Hapus
                </b-button>
              </template>
            </b-table>

            <!-- 📄 Pagination -->
            <b-row>
              <b-col md="6">
                <div class="text-muted">
                  Menampilkan {{ showingFrom }} sampai {{ showingTo }} dari {{ totalItems }} data
                </div>
              </b-col>
              <b-col md="6" class="text-right">
                <b-pagination
                  v-model="currentPage"
                  :total-rows="totalItems"
                  :per-page="perPage"
                  size="sm"
                ></b-pagination>
              </b-col>
            </b-row>
          </b-card>
        </b-col>
      </b-row>
    </b-container>

    <!-- 🧾 Modal Filter -->
    <b-modal v-model="showFilterModal" title="Filter Data" hide-footer>
      <b-form @submit.prevent="applyFilter">
        <b-form-group label="Item Barang">
          <b-form-input v-model="filters.item_barang" placeholder="Masukkan nama item barang"></b-form-input>
        </b-form-group>

        <b-form-group label="Jenis">
          <b-form-input v-model="filters.jenis" placeholder="Masukkan jenis"></b-form-input>
        </b-form-group>

        <b-form-group label="Tipe">
          <b-form-input v-model="filters.tipe" placeholder="Masukkan tipe"></b-form-input>
        </b-form-group>

        <b-form-group label="Merk">
          <b-form-input v-model="filters.merk" placeholder="Masukkan merk"></b-form-input>
        </b-form-group>

        <b-form-group label="Ukuran">
          <b-form-input v-model="filters.ukuran" placeholder="Masukkan ukuran"></b-form-input>
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
    <b-modal ref="modalAdd" :title="form.id ? 'Edit Data' : 'Tambah Data'" hide-footer>
      <b-form @submit.prevent="saveData">
        <b-form-group label="Lokasi" label-for="lokasi">
          <b-form-input v-model="form.lokasi" id="lokasi" required></b-form-input>
        </b-form-group>

        <b-form-group label="Item Barang" label-for="item_barang">
          <b-form-input v-model="form.item_barang" id="item_barang" required></b-form-input>
        </b-form-group>

        <b-form-group label="Jenis" label-for="jenis">
          <b-form-input v-model="form.jenis" id="jenis"></b-form-input>
        </b-form-group>

        <b-form-group label="Tipe" label-for="tipe">
          <b-form-input v-model="form.tipe" id="tipe"></b-form-input>
        </b-form-group>

        <b-form-group label="Merk" label-for="merk">
          <b-form-input v-model="form.merk" id="merk"></b-form-input>
        </b-form-group>

        <b-form-group label="Ukuran" label-for="ukuran">
          <b-form-input v-model="form.ukuran" id="ukuran"></b-form-input>
        </b-form-group>

        <b-form-group label="Jumlah" label-for="jumlah">
          <b-form-input type="number" v-model.number="form.jumlah" id="jumlah"></b-form-input>
        </b-form-group>

        <div class="text-right">
          <b-button type="submit" variant="primary">
            <i class="fas fa-save"></i> Simpan
          </b-button>
          <b-button variant="secondary" @click="closeModal">
            <i class="fas fa-times"></i> Tutup
          </b-button>
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
      inventaris: [],
      showFilterModal: false,
      filters: {
        item_barang: "",
        jenis: "",
        tipe: "",
        merk: "",
        ukuran: "",
        lokasi: "",
      },
      lokasiOptions: [
        { value: "ALL", text: "📍 Semua Lokasi" },
        { value: "", text: "Pilih Lokasi" },
      ],
      fields: [
        { key: "item_barang", label: "Item Barang" },
        { key: "jenis", label: "Jenis" },
        { key: "tipe", label: "Tipe" },
        { key: "merk", label: "Merk" },
        { key: "ukuran", label: "Ukuran" },
        { key: "jumlah", label: "Jumlah" },
        { key: "lokasi", label: "Lokasi" },
        { key: "actions", label: "Aksi" },
      ],
      // tidak lagi pakai showModal boolean
      showImportModal: false,
      form: {
        id: null,
        item_barang: "",
        jenis: "",
        tipe: "",
        merk: "",
        ukuran: "",
        jumlah: 0,
        lokasi: "",
      },
      searchQuery: "",
      currentPage: 1,
      perPage: 100,
      selectedFile: null,
      selectedLokasi: "",
      itemOptions: [],
      jenisOptions: [],
      tipeOptions: [],
      masterData: {
        POWER: {
          "kabel listrik": { jenis: ["Serabut", "Tunggal"] },
          "kabel power": { jenis: ["C13", "C13 to C14", "C19", "C19 to C20"] },
          "industrial socket": { jenis: ["Male", "Female", "1 Set"] },
          konektor: { jenis: ["C14", "C20"] },
        },
        MANAGEMENT: {
          "Kabel UTP": { jenis: ["CAT5", "CAT5e", "CAT6", "CAT6a"] },
          konektor: { jenis: ["RJ45", "RJ11"] },
          Plugboots: { jenis: ["Standard", "Shielded"] },
        },
        DATA: {
          "kabel patchcord": { jenis: ["Single Mode", "Multi Mode"] },
          "modul (Transceiver)": {
            jenis: ["SFP", "SFP+", "QSFP", "QSFP+"],
            tipe: ["1G", "2.5G", "10G", "25G", "100G"],
          },
        },
        DLL: {},
      },
    };
  },

  computed: {
    showTipeDropdown() {
      return (
        this.form.lokasi === "DATA" &&
        this.form.item_barang === "modul (Transceiver)" &&
        this.form.jenis
      );
    },

    filteredInventaris() {
      let data = Array.isArray(this.inventaris)
        ? this.inventaris.slice()
        : [];

      // Filter kombinasi
      const applyKeywordFilter = (field) => {
        if (!this.filters[field]) return;
        const keywords = this.filters[field]
          .toLowerCase()
          .split(/\s+/)
          .filter(Boolean);
        data = data.filter((i) => {
          const val = (i[field] || "").toLowerCase();
          return keywords.some((k) => val.includes(k));
        });
      };

      ["item_barang", "jenis", "tipe", "merk", "ukuran"].forEach(
        applyKeywordFilter
      );

      if (this.filters.lokasi && this.filters.lokasi !== "ALL") {
        data = data.filter((i) => (i.lokasi || "") === this.filters.lokasi);
      }

      // Global search
      if (this.searchQuery && this.searchQuery.trim()) {
        const s = this.searchQuery.toLowerCase();
        data = data.filter((i) =>
          [i.item_barang, i.jenis, i.tipe, i.merk, i.ukuran, i.lokasi]
            .filter(Boolean)
            .join(" ")
            .toLowerCase()
            .includes(s)
        );
      }

      return data;
    },

    pagedItems() {
      const start = (this.currentPage - 1) * this.perPage;
      const end = this.currentPage * this.perPage;
      return this.filteredInventaris.slice(start, end);
    },

    totalItems() {
      return this.filteredInventaris.length;
    },
    showingFrom() {
      if (!this.totalItems) return 0;
      return (this.currentPage - 1) * this.perPage + 1;
    },
    showingTo() {
      const end = this.currentPage * this.perPage;
      return end > this.totalItems ? this.totalItems : end;
    },
  },

  methods: {
    async fetchData() {
      try {
        const res = await axios.get(
          "http://192.168.10.9:5000/api/inventaryprojek/inventaryprojek"
        );
        this.inventaris = res.data;
        this.currentPage = 1;
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    },

    async fetchLokasi() {
      try {
        const res = await axios.get(
          "http://192.168.10.9:5000/api/inventaryprojek/lokasi"
        );
        this.lokasiOptions = [
          { value: "ALL", text: "📍 Semua Lokasi" },
          { value: "", text: "Pilih Lokasi" },
          ...res.data.map((item) => ({
            value: item.lokasi,
            text: item.lokasi,
          })),
        ];
      } catch (error) {
        console.error("Gagal mengambil data lokasi:", error);
      }
    },

    // 📥 Import Excel
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

        const dataWithLocation =
          this.selectedLokasi === "ALL"
            ? jsonData
            : jsonData.map((r) => ({ ...r, lokasi: this.selectedLokasi }));

        try {
          await axios.post(
            "http://192.168.10.9:5000/api/inventaryprojek/inventaryprojek/import",
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
      if (!this.filteredInventaris.length) {
        alert("Tidak ada data untuk diunduh!");
        return;
      }
      const ws = XLSX.utils.json_to_sheet(this.filteredInventaris);
      const wb = XLSX.utils.book_new();
      XLSX.utils.book_append_sheet(wb, ws, "Inventaris_Project");
      XLSX.writeFile(wb, `Inventaris_Project.xlsx`);
    },

    onSearch() {
      this.currentPage = 1;
    },
    clearSearch() {
      this.searchQuery = "";
      this.currentPage = 1;
    },

    applyFilter() {
      this.showFilterModal = false;
      this.currentPage = 1;
    },
    resetFilter() {
      this.filters = {
        item_barang: "",
        jenis: "",
        tipe: "",
        merk: "",
        ukuran: "",
        lokasi: "",
      };
      this.currentPage = 1;
    },

    // 🟢 Modal Tambah
    showAddModal() {
      this.form = {
        id: null,
        lokasi: "",
        item_barang: "",
        jenis: "",
        tipe: "",
        merk: "",
        ukuran: "",
        jumlah: 0,
      };
      this.itemOptions = [];
      this.jenisOptions = [];
      this.tipeOptions = [];
      this.$refs.modalAdd.show(); // ✅ aman
    },

    // ✏️ Modal Edit
    editItem(item) {
      this.form = Object.assign({}, item);
      this.updateItems();
      if (
        this.form.lokasi &&
        this.form.lokasi !== "DLL" &&
        this.form.item_barang
      ) {
        this.updateTipeOptions();
      }
      this.$refs.modalAdd.show();
    },

    // 💾 Simpan
    async saveItem() {
      try {
        if (this.form.id) {
          await axios.put(
            `http://192.168.10.9:5000/api/inventaryprojek/inventaryprojek/${this.form.id}`,
            this.form
          );
        } else {
          await axios.post(
            "http://192.168.10.9:5000/api/inventaryprojek/inventaryprojek",
            this.form
          );
        }
        this.$refs.modalAdd.hide();
        this.fetchData();
      } catch (err) {
        console.error(err);
        alert("❌ Gagal menyimpan data");
      }
    },

    async deleteItem(id) {
      if (confirm("Yakin hapus data ini?")) {
        try {
          await axios.delete(
            `http://192.168.10.9:5000/api/inventaryprojek/inventaryprojek/${id}`
          );
          this.fetchData();
        } catch (err) {
          console.error(err);
          alert("Gagal menghapus data");
        }
      }
    },

    closeModal() {
      this.$refs.modalAdd.hide();
    },

    updateItems() {
      this.form.item_barang = "";
      this.form.jenis = "";
      this.form.tipe = "";
      if (this.form.lokasi && this.form.lokasi !== "DLL") {
        const items = Object.keys(this.masterData[this.form.lokasi] || {});
        this.itemOptions = [
          { value: "", text: "Pilih Item Barang" },
          ...items.map((item) => ({ value: item, text: item })),
        ];
      } else {
        this.itemOptions = [];
        this.jenisOptions = [];
        this.tipeOptions = [];
      }
    },

    updateTipeOptions() {
      this.form.jenis = "";
      this.form.tipe = "";
      if (
        this.form.lokasi &&
        this.form.lokasi !== "DLL" &&
        this.form.item_barang
      ) {
        const itemData =
          this.masterData[this.form.lokasi][this.form.item_barang];
        if (itemData && itemData.jenis) {
          this.jenisOptions = [
            { value: "", text: "Pilih Jenis" },
            ...itemData.jenis.map((j) => ({ value: j, text: j })),
          ];
        }
        if (
          this.form.lokasi === "DATA" &&
          this.form.item_barang === "modul (Transceiver)" &&
          itemData &&
          itemData.tipe
        ) {
          this.tipeOptions = [
            { value: "", text: "Pilih Tipe" },
            ...itemData.tipe.map((t) => ({ value: t, text: t })),
          ];
        }
      } else {
        this.jenisOptions = [];
        this.tipeOptions = [];
      }
    },
  },

  mounted() {
    this.fetchData();
    this.fetchLokasi();
  },
};
</script>

<style scoped>
.text-right {
  text-align: right;
}
</style>
