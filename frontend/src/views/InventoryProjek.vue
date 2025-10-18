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
                <b-button
                  size="sm"
                  variant="danger"
                  @click="deleteItem(row.item.id)"
                  class="ml-1"
                >
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
        <b-form-group label="Lokasi">
          <b-form-input v-model="form.lokasi" required></b-form-input>
        </b-form-group>

        <b-form-group label="Item Barang">
          <b-form-input v-model="form.item_barang" required></b-form-input>
        </b-form-group>

        <b-form-group label="Jenis">
          <b-form-input v-model="form.jenis"></b-form-input>
        </b-form-group>

        <b-form-group label="Tipe">
          <b-form-input v-model="form.tipe"></b-form-input>
        </b-form-group>

        <b-form-group label="Merk">
          <b-form-input v-model="form.merk"></b-form-input>
        </b-form-group>

        <b-form-group label="Ukuran">
          <b-form-input v-model="form.ukuran"></b-form-input>
        </b-form-group>

        <b-form-group label="Jumlah">
          <b-form-input type="number" v-model.number="form.jumlah"></b-form-input>
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
  </div>
</template>

<script>
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
        { value: "Jakarta", text: "Jakarta" },
        { value: "Surabaya", text: "Surabaya" },
        { value: "Bandung", text: "Bandung" },
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
      perPage: 10,
    };
  },

  computed: {
    filteredInventaris() {
      let data = [...this.inventaris];

      Object.keys(this.filters).forEach((key) => {
        if (this.filters[key] && this.filters[key] !== "ALL") {
          data = data.filter((item) =>
            (item[key] || "").toLowerCase().includes(this.filters[key].toLowerCase())
          );
        }
      });

      if (this.searchQuery.trim()) {
        const q = this.searchQuery.toLowerCase();
        data = data.filter((item) =>
          Object.values(item)
            .join(" ")
            .toLowerCase()
            .includes(q)
        );
      }

      return data;
    },
    pagedItems() {
      const start = (this.currentPage - 1) * this.perPage;
      return this.filteredInventaris.slice(start, start + this.perPage);
    },
    totalItems() {
      return this.filteredInventaris.length;
    },
    showingFrom() {
      return this.totalItems ? (this.currentPage - 1) * this.perPage + 1 : 0;
    },
    showingTo() {
      const end = this.currentPage * this.perPage;
      return end > this.totalItems ? this.totalItems : end;
    },
  },

  methods: {
    fetchData() {
      // 💾 Data statis dummy
      this.inventaris = [
        { id: 1, item_barang: "Kabel Power", jenis: "C13", tipe: "-", merk: "Philips", ukuran: "2m", jumlah: 50, lokasi: "Jakarta" },
        { id: 2, item_barang: "Kabel Listrik", jenis: "Serabut", tipe: "-", merk: "Schneider", ukuran: "5m", jumlah: 30, lokasi: "Surabaya" },
        { id: 3, item_barang: "Modul Transceiver", jenis: "SFP+", tipe: "10G", merk: "Cisco", ukuran: "-", jumlah: 15, lokasi: "Bandung" },
        { id: 4, item_barang: "Konektor RJ45", jenis: "CAT6", tipe: "-", merk: "Belden", ukuran: "-", jumlah: 100, lokasi: "Jakarta" },
        { id: 1, item_barang: "Kabel Power", jenis: "C13", tipe: "-", merk: "Philips", ukuran: "2m", jumlah: 50, lokasi: "Jakarta" },
        { id: 2, item_barang: "Kabel Listrik", jenis: "Serabut", tipe: "-", merk: "Schneider", ukuran: "5m", jumlah: 30, lokasi: "Surabaya" },
        { id: 3, item_barang: "Modul Transceiver", jenis: "SFP+", tipe: "10G", merk: "Cisco", ukuran: "-", jumlah: 15, lokasi: "Bandung" },
        { id: 4, item_barang: "Konektor RJ45", jenis: "CAT6", tipe: "-", merk: "Belden", ukuran: "-", jumlah: 100, lokasi: "Jakarta" },
        { id: 1, item_barang: "Kabel Power", jenis: "C13", tipe: "-", merk: "Philips", ukuran: "2m", jumlah: 50, lokasi: "Jakarta" },
        { id: 2, item_barang: "Kabel Listrik", jenis: "Serabut", tipe: "-", merk: "Schneider", ukuran: "5m", jumlah: 30, lokasi: "Surabaya" },
        { id: 3, item_barang: "Modul Transceiver", jenis: "SFP+", tipe: "10G", merk: "Cisco", ukuran: "-", jumlah: 15, lokasi: "Bandung" },
        { id: 4, item_barang: "Konektor RJ45", jenis: "CAT6", tipe: "-", merk: "Belden", ukuran: "-", jumlah: 100, lokasi: "Jakarta" },
        { id: 1, item_barang: "Kabel Power", jenis: "C13", tipe: "-", merk: "Philips", ukuran: "2m", jumlah: 50, lokasi: "Jakarta" },
        { id: 2, item_barang: "Kabel Listrik", jenis: "Serabut", tipe: "-", merk: "Schneider", ukuran: "5m", jumlah: 30, lokasi: "Surabaya" },
        { id: 3, item_barang: "Modul Transceiver", jenis: "SFP+", tipe: "10G", merk: "Cisco", ukuran: "-", jumlah: 15, lokasi: "Bandung" },
        { id: 4, item_barang: "Konektor RJ45", jenis: "CAT6", tipe: "-", merk: "Belden", ukuran: "-", jumlah: 100, lokasi: "Jakarta" },
      ];
    },

    showAddModal() {
      this.form = { id: null, item_barang: "", jenis: "", tipe: "", merk: "", ukuran: "", jumlah: 0, lokasi: "" };
      this.$refs.modalAdd.show();
    },

    editItem(item) {
      this.form = { ...item };
      this.$refs.modalAdd.show();
    },

    saveData() {
      if (this.form.id) {
        const idx = this.inventaris.findIndex((i) => i.id === this.form.id);
        if (idx !== -1) this.inventaris.splice(idx, 1, { ...this.form });
      } else {
        this.form.id = Date.now();
        this.inventaris.push({ ...this.form });
      }
      this.$refs.modalAdd.hide();
    },

    deleteItem(id) {
      if (confirm("Yakin ingin menghapus data ini?")) {
        this.inventaris = this.inventaris.filter((i) => i.id !== id);
      }
    },

    downloadExcel() {
      const ws = XLSX.utils.json_to_sheet(this.filteredInventaris);
      const wb = XLSX.utils.book_new();
      XLSX.utils.book_append_sheet(wb, ws, "Inventory Project");
      XLSX.writeFile(wb, "Inventory_Project.xlsx");
    },

    applyFilter() {
      this.showFilterModal = false;
    },
    resetFilter() {
      this.filters = { item_barang: "", jenis: "", tipe: "", merk: "", ukuran: "", lokasi: "" };
    },
    onSearch() {
      this.currentPage = 1;
    },
    clearSearch() {
      this.searchQuery = "";
      this.currentPage = 1;
    },
    closeModal() {
      this.$refs.modalAdd.hide();
    },
  },

  mounted() {
    this.fetchData();
  },
};
</script>

<style scoped>
.text-right {
  text-align: right;
}
</style>
