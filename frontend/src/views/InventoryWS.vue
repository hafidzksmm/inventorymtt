<template>
  <div>
    <!-- Header -->
    <base-header class="pb-6 pb-8 pt-5 pt-md-8 bg-gradient-danger">
      <h2 class="text-white">📦 Inventory Workshop (Statis)</h2>
    </base-header>

    <div class="container-fluid mt--7">
      <b-card>
        <!-- 🔍 Baris atas -->
        <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap">
          <div class="mb-2 d-flex align-items-center flex-wrap">
            <b-button variant="success" @click="showAddModal">+ Tambah Data</b-button>
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

    <!-- 🧩 Modal Filter -->
    <b-modal v-model="showFilterModal" title="Filter Data" hide-footer>
      <b-form @submit.prevent="applyFilter">
        <b-form-group label="Nama Barang">
          <b-form-select v-model="filters.nama_barang" :options="namaBarangOptions"></b-form-select>
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
import BaseHeader from "@/components/BaseHeader";
import * as XLSX from "xlsx";

export default {
  name: "InventarisStatic",
  components: { BaseHeader },
  data() {
    return {
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

      // 📦 Data Statis dari Excel
      items: [
        {
          id: 1,
          nama_barang: "Rak Besi",
          merk: "-",
          deskripsi: "Dapat di bongkar, tatakan bahan hpl, 4 tingkat",
          dimensi: "119x40x197cm",
          qty: 2,
          satuan: "pcs",
          lokasi: "Workshop",
          created_at: new Date(),
        },
        {
          id: 2,
          nama_barang: "Rak Kecil",
          merk: "-",
          deskripsi: "Rangka besi dan tatakan bahan HPL",
          dimensi: "50x25x97cm",
          qty: 1,
          satuan: "pcs",
          lokasi: "Workshop",
          created_at: new Date(),
        },
        {
          id: 3,
          nama_barang: "Dispenser",
          merk: "Arasi model ABD04C-Black",
          deskripsi: "Hot water and Cool Water",
          dimensi: "40x36x109cm",
          qty: 1,
          satuan: "pcs",
          lokasi: "Workshop",
          created_at: new Date(),
        },
        {
          id: 4,
          nama_barang: "Smartlock",
          merk: "Taffhome model XR24-Black",
          deskripsi: "Unlock with PIN, Card, and Fingerprint",
          dimensi: "17x7x37cm",
          qty: 1,
          satuan: "unit",
          lokasi: "Workshop",
          created_at: new Date(),
        },
        {
          id: 5,
          nama_barang: "Layar Interaktif",
          merk: "Acer Model Acer ALTOS IWB86",
          deskripsi: "OS: Android 13 RAM 4GB Storage 32GB",
          dimensi: "196x25x117cm",
          qty: 1,
          satuan: "unit",
          lokasi: "Workshop",
          created_at: new Date(),
        },
        {
          id: 6,
          nama_barang: "Bracket",
          merk: "Acer",
          deskripsi: "Bracket besi Acer",
          dimensi: "107x66x150cm",
          qty: 1,
          satuan: "pcs",
          lokasi: "Workshop",
          created_at: new Date(),
        },
        {
          id: 7,
          nama_barang: "Monitor",
          merk: "Weyon WY-A24",
          deskripsi: "HD 1680x1050, HDMI, VGA, RF, AV, USB, Remote",
          dimensi: "74x8x44cm",
          qty: 1,
          satuan: "unit",
          lokasi: "Workshop",
          created_at: new Date(),
        },
        {
          id: 8,
          nama_barang: "Xiaomi TV",
          merk: "Xiaomi",
          deskripsi: "Dolby Audio, HDMI, VGA 50W",
          dimensi: "72x42cm",
          qty: 2,
          satuan: "unit",
          lokasi: "Workshop",
          created_at: new Date(),
        },
                {
          id: 1,
          nama_barang: "Rak Besi",
          merk: "-",
          deskripsi: "Dapat di bongkar, tatakan bahan hpl, 4 tingkat",
          dimensi: "119x40x197cm",
          qty: 2,
          satuan: "pcs",
          lokasi: "Workshop",
          created_at: new Date(),
        },
        {
          id: 2,
          nama_barang: "Rak Kecil",
          merk: "-",
          deskripsi: "Rangka besi dan tatakan bahan HPL",
          dimensi: "50x25x97cm",
          qty: 1,
          satuan: "pcs",
          lokasi: "Workshop",
          created_at: new Date(),
        },
        {
          id: 3,
          nama_barang: "Dispenser",
          merk: "Arasi model ABD04C-Black",
          deskripsi: "Hot water and Cool Water",
          dimensi: "40x36x109cm",
          qty: 1,
          satuan: "pcs",
          lokasi: "Workshop",
          created_at: new Date(),
        },
        {
          id: 4,
          nama_barang: "Smartlock",
          merk: "Taffhome model XR24-Black",
          deskripsi: "Unlock with PIN, Card, and Fingerprint",
          dimensi: "17x7x37cm",
          qty: 1,
          satuan: "unit",
          lokasi: "Workshop",
          created_at: new Date(),
        },
        {
          id: 5,
          nama_barang: "Layar Interaktif",
          merk: "Acer Model Acer ALTOS IWB86",
          deskripsi: "OS: Android 13 RAM 4GB Storage 32GB",
          dimensi: "196x25x117cm",
          qty: 1,
          satuan: "unit",
          lokasi: "Workshop",
          created_at: new Date(),
        },
        {
          id: 6,
          nama_barang: "Bracket",
          merk: "Acer",
          deskripsi: "Bracket besi Acer",
          dimensi: "107x66x150cm",
          qty: 1,
          satuan: "pcs",
          lokasi: "Workshop",
          created_at: new Date(),
        },
        {
          id: 7,
          nama_barang: "Monitor",
          merk: "Weyon WY-A24",
          deskripsi: "HD 1680x1050, HDMI, VGA, RF, AV, USB, Remote",
          dimensi: "74x8x44cm",
          qty: 1,
          satuan: "unit",
          lokasi: "Workshop",
          created_at: new Date(),
        },
        {
          id: 8,
          nama_barang: "Xiaomi TV",
          merk: "Xiaomi",
          deskripsi: "Dolby Audio, HDMI, VGA 50W",
          dimensi: "72x42cm",
          qty: 2,
          satuan: "unit",
          lokasi: "Workshop",
          created_at: new Date(),
        },
                {
          id: 1,
          nama_barang: "Rak Besi",
          merk: "-",
          deskripsi: "Dapat di bongkar, tatakan bahan hpl, 4 tingkat",
          dimensi: "119x40x197cm",
          qty: 2,
          satuan: "pcs",
          lokasi: "Workshop",
          created_at: new Date(),
        },
        {
          id: 2,
          nama_barang: "Rak Kecil",
          merk: "-",
          deskripsi: "Rangka besi dan tatakan bahan HPL",
          dimensi: "50x25x97cm",
          qty: 1,
          satuan: "pcs",
          lokasi: "Workshop",
          created_at: new Date(),
        },
        {
          id: 3,
          nama_barang: "Dispenser",
          merk: "Arasi model ABD04C-Black",
          deskripsi: "Hot water and Cool Water",
          dimensi: "40x36x109cm",
          qty: 1,
          satuan: "pcs",
          lokasi: "Workshop",
          created_at: new Date(),
        },
        {
          id: 4,
          nama_barang: "Smartlock",
          merk: "Taffhome model XR24-Black",
          deskripsi: "Unlock with PIN, Card, and Fingerprint",
          dimensi: "17x7x37cm",
          qty: 1,
          satuan: "unit",
          lokasi: "Workshop",
          created_at: new Date(),
        },
        {
          id: 5,
          nama_barang: "Layar Interaktif",
          merk: "Acer Model Acer ALTOS IWB86",
          deskripsi: "OS: Android 13 RAM 4GB Storage 32GB",
          dimensi: "196x25x117cm",
          qty: 1,
          satuan: "unit",
          lokasi: "Workshop",
          created_at: new Date(),
        },
        {
          id: 6,
          nama_barang: "Bracket",
          merk: "Acer",
          deskripsi: "Bracket besi Acer",
          dimensi: "107x66x150cm",
          qty: 1,
          satuan: "pcs",
          lokasi: "Workshop",
          created_at: new Date(),
        },
        {
          id: 7,
          nama_barang: "Monitor",
          merk: "Weyon WY-A24",
          deskripsi: "HD 1680x1050, HDMI, VGA, RF, AV, USB, Remote",
          dimensi: "74x8x44cm",
          qty: 1,
          satuan: "unit",
          lokasi: "Workshop",
          created_at: new Date(),
        },
        {
          id: 8,
          nama_barang: "Xiaomi TV",
          merk: "Xiaomi",
          deskripsi: "Dolby Audio, HDMI, VGA 50W",
          dimensi: "72x42cm",
          qty: 2,
          satuan: "unit",
          lokasi: "Workshop",
          created_at: new Date(),
        },


      ],

      isModalOpen: false,
      isEdit: false,
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
        lokasi: "",
      },

      lokasiOptions: [
        { value: "", text: "📍 Semua Lokasi" },
        { value: "Workshop", text: "Workshop" },
      ],

      namaBarangOptions: [
        { value: "", text: "Semua Barang" },
        { value: "Rak Besi", text: "Rak Besi" },
        { value: "Rak Kecil", text: "Rak Kecil" },
        { value: "Dispenser", text: "Dispenser" },
        { value: "Smartlock", text: "Smartlock" },
        { value: "Layar Interaktif", text: "Layar Interaktif" },
        { value: "Bracket", text: "Bracket" },
        { value: "Monitor", text: "Monitor" },
        { value: "Xiaomi TV", text: "Xiaomi TV" },
      ],

      search: "",
      perPage: 10,
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

      if (this.filters.nama_barang)
        filtered = filtered.filter(
          (i) => i.nama_barang === this.filters.nama_barang
        );
      if (this.filters.lokasi)
        filtered = filtered.filter((i) => i.lokasi === this.filters.lokasi);

      return filtered;
    },
  },

  methods: {
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

    createItem() {
      const newItem = { ...this.form, id: this.items.length + 1, created_at: new Date() };
      this.items.push(newItem);
      this.isModalOpen = false;
    },

    updateItem() {
      const index = this.items.findIndex((i) => i.id === this.form.id);
      if (index !== -1) this.items.splice(index, 1, { ...this.form });
      this.isModalOpen = false;
    },

    deleteItem(id) {
      if (confirm("Yakin ingin menghapus data ini?")) {
        this.items = this.items.filter((i) => i.id !== id);
      }
    },

    downloadExcel() {
      const ws = XLSX.utils.json_to_sheet(this.filteredItems);
      const wb = XLSX.utils.book_new();
      XLSX.utils.book_append_sheet(wb, ws, "Inventaris_Workshop_Statis");
      XLSX.writeFile(wb, `Inventaris_Statis.xlsx`);
    },

    applyFilter() {
      this.showFilterModal = false;
      this.currentPage = 1;
    },

    resetFilter() {
      this.filters = { nama_barang: "", lokasi: "" };
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
