<template>
  <div>
    <base-header class="pb-6 pb-8 pt-5 pt-md-8 bg-gradient-danger">
      <h2 class="text-white">📦 Inventory Project</h2>
    </base-header>

    <b-container fluid class="mt--7">
      <b-row>
        <b-col>
          <b-card>
            <!-- Search dan Tambah Data -->
            <b-row class="mb-3">
              <b-col md="6">
                <b-input-group>
                  <b-form-input 
                    v-model="searchQuery" 
                    placeholder="Cari item barang, jenis, tipe, merk..."
                    @input="onSearch"
                  />
                  <b-input-group-append>
                    <b-button variant="outline-secondary" @click="clearSearch">
                      <i class="fas fa-times"></i>
                    </b-button>
                  </b-input-group-append>
                </b-input-group>
              </b-col>
              <b-col md="6" class="text-right">
                <b-button variant="success" @click="showAddModal">
                  <i class="fas fa-plus"></i> Tambah Data
                </b-button>
              </b-col>
            </b-row>

            <!-- Tabel dengan Pagination -->
            <b-table 
              striped 
              hover 
              :items="filteredInventaris" 
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

            <!-- Pagination -->
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
                  aria-controls="my-table"
                  size="sm"
                ></b-pagination>
              </b-col>
            </b-row>
          </b-card>
        </b-col>
      </b-row>
    </b-container>

    <!-- Modal Tambah / Edit -->
    <b-modal v-model="showModal" :title="form.id ? 'Edit Data' : 'Tambah Data'" hide-footer>
      <b-form @submit.prevent="saveItem">
        <!-- Lokasi -->
        <b-form-group label="Lokasi">
          <b-form-select v-model="form.lokasi" :options="lokasiOptions" @change="updateItems" required />
        </b-form-group>

        <!-- Item Barang -->
        <b-form-group label="Item Barang">
          <!-- Dropdown untuk lokasi selain DLL -->
          <b-form-select 
            v-model="form.item_barang" 
            :options="itemOptions" 
            @change="updateTipeOptions" 
            :disabled="form.lokasi === 'DLL'"
            required 
          />
          
          <!-- Input manual untuk lokasi DLL -->
          <b-form-input 
            v-if="form.lokasi === 'DLL'"
            v-model="form.item_barang" 
            placeholder="Masukkan nama barang"
            required
            class="mt-2"
          />
        </b-form-group>

        <!-- Jenis -->
        <b-form-group label="Jenis">
          <b-form-select 
            v-model="form.jenis" 
            :options="jenisOptions" 
            :disabled="form.lokasi === 'DLL'"
            required 
          />
        </b-form-group>

        <!-- Tipe -->
        <b-form-group label="Tipe">
          <!-- Dropdown khusus untuk modul (Transceiver) di lokasi DATA -->
          <b-form-select 
            v-if="showTipeDropdown"
            v-model="form.tipe" 
            :options="tipeOptions" 
            required 
          />
          
          <!-- Input manual untuk semua kasus lainnya -->
          <b-form-input 
            v-else
            v-model="form.tipe" 
            placeholder="Masukkan tipe barang"
            required
          />
        </b-form-group>

        <b-form-group label="Merk">
          <b-form-input v-model="form.merk" required />
        </b-form-group>
        
        <b-form-group label="Ukuran">
          <b-form-input v-model="form.ukuran" />
        </b-form-group>
        
        <b-form-group label="Jumlah">
          <b-form-input type="number" v-model="form.jumlah" required />
        </b-form-group>

        <div class="text-right">
          <b-button variant="secondary" @click="showModal = false">Batal</b-button>
          <b-button type="submit" variant="primary">Simpan</b-button>
        </div>
      </b-form>
    </b-modal>
  </div>
</template>

<script>
import axios from "axios"

export default {
  data() {
    return {
      inventaris: [],
      filteredInventaris: [],
      fields: [
        { key: "item_barang", label: "Item Barang" },
        { key: "jenis", label: "Jenis" },
        { key: "tipe", label: "Tipe" },
        { key: "merk", label: "Merk" },
        { key: "ukuran", label: "Ukuran" },
        { key: "jumlah", label: "Jumlah" },
        { key: "lokasi", label: "Lokasi" },
        { key: "actions", label: "Aksi" }
      ],
      showModal: false,
      form: {
        id: null,
        item_barang: "",
        jenis: "",
        tipe: "",
        merk: "",
        ukuran: "",
        jumlah: 0,
        lokasi: ""
      },
      
      // Pagination & Search
      searchQuery: "",
      currentPage: 1,
      perPage: 10,
      
      lokasiOptions: [
        { value: "", text: "Pilih Lokasi" },
        { value: "POWER", text: "POWER" },
        { value: "MANAGEMENT", text: "MANAGEMENT" },
        { value: "DATA", text: "DATA" },
        { value: "DLL", text: "DLL" }
      ],
      itemOptions: [],
      jenisOptions: [],
      tipeOptions: [],
      masterData: {
        "POWER": {
          "kabel listrik": {
            jenis: ["Serabut", "Tunggal"]
          },
          "kabel power": {
            jenis: ["C13", "C13 to C14"]
          },
          "industrial socket": {
            jenis: ["Male", "Female", "1 Set"]
          },
          "konektor": {
            jenis: ["C14", "C20"]
          }
        },
        "MANAGEMENT": {
          "Kabel UTP": {
            jenis: ["CAT5", "CAT5e", "CAT6", "CAT6a"]
          },
          "konektor": {
            jenis: ["RJ45", "RJ11"]
          },
          "Plugboots": {
            jenis: ["Standard", "Shielded"]
          }
        },
        "DATA": {
          "kabel patchcord": {
            jenis: ["Single Mode", "Multi Mode"]
          },
          "modul (Transceiver)": {
            jenis: ["SFP", "SFP+", "QSFP", "QSFP+"],
            tipe: ["1G", "2.5G", "10G", "25G", "100G"]
          }
        },
        "DLL": {} // Kosong untuk input manual
      }
    }
  },
  computed: {
    showTipeDropdown() {
      // Hanya tampilkan dropdown tipe untuk modul (Transceiver) di lokasi DATA
      return this.form.lokasi === "DATA" && 
             this.form.item_barang === "modul (Transceiver)" &&
             this.form.jenis;
    },
    
    totalItems() {
      return this.filteredInventaris.length;
    },
    
    showingFrom() {
      return (this.currentPage - 1) * this.perPage + 1;
    },
    
    showingTo() {
      const end = this.currentPage * this.perPage;
      return end > this.totalItems ? this.totalItems : end;
    }
  },
  methods: {
    async fetchData() {
      try {
        const res = await axios.get("http://localhost:5000/api/inventaryprojek/inventaryprojek");
        this.inventaris = res.data;
        this.filteredInventaris = this.inventaris.slice(); // Initialize filtered data
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    },
    
    onSearch() {
      if (this.searchQuery.trim() === "") {
        this.filteredInventaris = this.inventaris.slice();
      } else {
        const query = this.searchQuery.toLowerCase();
        this.filteredInventaris = this.inventaris.filter(function (item) {
          return (item.item_barang && item.item_barang.toLowerCase().includes(query)) ||
                 (item.jenis && item.jenis.toLowerCase().includes(query)) ||
                 (item.tipe && item.tipe.toLowerCase().includes(query)) ||
                 (item.merk && item.merk.toLowerCase().includes(query)) ||
                 (item.ukuran && item.ukuran.toLowerCase().includes(query)) ||
                 (item.lokasi && item.lokasi.toLowerCase().includes(query));
        });
      }
      this.currentPage = 1; // Reset to first page when searching
    },
    
    clearSearch() {
      this.searchQuery = "";
      this.filteredInventaris = this.inventaris.slice();
      this.currentPage = 1;
    },
    
    showAddModal() {
      this.form = {
        id: null,
        lokasi: "",
        item_barang: "",
        jenis: "",
        tipe: "",
        merk: "",
        ukuran: "",
        jumlah: 0
      }
      this.itemOptions = []
      this.jenisOptions = []
      this.tipeOptions = []
      this.showModal = true
    },
    
    updateItems() {
      // Reset form fields ketika lokasi berubah
      this.form.item_barang = ""
      this.form.jenis = ""
      this.form.tipe = ""
      
      if (this.form.lokasi && this.form.lokasi !== "DLL") {
        // Untuk lokasi POWER, MANAGEMENT, DATA
        const items = Object.keys(this.masterData[this.form.lokasi] || {})
        this.itemOptions = [
          { value: "", text: "Pilih Item Barang" },
          ...items.map(function (item) { 
            return { value: item, text: item } 
          })
        ]
      } else if (this.form.lokasi === "DLL") {
        // Untuk lokasi DLL, kosongkan options
        this.itemOptions = []
        this.jenisOptions = []
        this.tipeOptions = []
      } else {
        this.itemOptions = []
      }
      this.jenisOptions = []
      this.tipeOptions = []
    },
    
    updateTipeOptions() {
      this.form.jenis = ""
      this.form.tipe = ""
      
      if (this.form.lokasi && this.form.lokasi !== "DLL" && this.form.item_barang) {
        const itemData = this.masterData[this.form.lokasi][this.form.item_barang]
        if (itemData && itemData.jenis) {
          this.jenisOptions = [
            { value: "", text: "Pilih Jenis" },
            ...itemData.jenis.map(function (jenis) { 
              return { value: jenis, text: jenis } 
            })
          ]
        } else {
          this.jenisOptions = []
        }
        
        // Jika ini adalah modul (Transceiver) di DATA, siapkan options tipe
        if (this.form.lokasi === "DATA" && 
            this.form.item_barang === "modul (Transceiver)" && 
            itemData && itemData.tipe) {
          this.tipeOptions = [
            { value: "", text: "Pilih Tipe" },
            ...itemData.tipe.map(function (tipe) { 
              return { value: tipe, text: tipe } 
            })
          ]
        }
      } else {
        this.jenisOptions = []
        this.tipeOptions = []
      }
    },
    
    editItem(item) {
      this.form = Object.assign({}, item);
      this.updateItems()
      
      // Setelah updateItems, set item_barang yang sesuai
      if (this.form.lokasi && this.form.lokasi !== "DLL" && this.form.item_barang) {
        this.updateTipeOptions()
      }
      
      this.showModal = true
    },
    
    async saveItem() {
      try {
        if (this.form.id) {
          await axios.put("http://localhost:5000/api/inventaryprojek/inventaryprojek/" + this.form.id, this.form)
        } else {
          await axios.post("http://localhost:5000/api/inventaryprojek/inventaryprojek", this.form)
        }
        this.showModal = false
        this.fetchData()
      } catch (error) {
        console.error("Error saving data:", error)
        alert("Gagal menyimpan data")
      }
    },
    
    async deleteItem(id) {
      if (confirm("Yakin hapus data ini?")) {
        try {
          await axios.delete("http://localhost:5000/api/inventaryprojek/inventaryprojek/" + id)
          this.fetchData()
        } catch (error) {
          console.error("Error deleting data:", error)
          alert("Gagal menghapus data")
        }
      }
    }
  },
  mounted() {
    this.fetchData()
  }
}
</script>

<style scoped>
.text-muted {
  font-size: 0.875rem;
}
.ml-1 {
  margin-left: 0.25rem;
}
</style>