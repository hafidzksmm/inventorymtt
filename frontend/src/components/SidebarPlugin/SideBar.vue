<template>
  <nav class="navbar navbar-vertical fixed-left navbar-expand-md navbar-light bg-white" id="sidenav-main">
    <div class="container-fluid">

      <!--Toggler-->
      <navbar-toggle-button @click.native="showSidebar"></navbar-toggle-button>
      
      <router-link class="navbar-brand" to="/">
        <img :src="logo" class="navbar-brand-img" alt="...">
      </router-link>

      <slot name="mobile-right">
        <ul class="nav align-items-center d-md-none">
          <base-dropdown class="nav-item" menu-on-right tag="li" title-tag="a">
            <a slot="title-container" class="nav-link nav-link-icon" href="#" role="button"
               aria-haspopup="true" aria-expanded="false">
              <i class="ni ni-bell-55"></i>
            </a>
            <a class="dropdown-item" href="#">Action</a>
            <a class="dropdown-item" href="#">Another action</a>
            <div class="dropdown-divider"></div>
            <a class="dropdown-item" href="#">Something else here</a>
          </base-dropdown>

          <base-dropdown class="nav-item" menu-on-right tag="li" title-tag="a">
            <a slot="title-container" class="nav-link" href="#" role="button">
              <div class="media align-items-center">
                <span class="avatar avatar-sm rounded-circle">
                  <img alt="Image placeholder" src="img/theme/team-1.jpg">
                </span>
              </div>
            </a>

          </base-dropdown>
        </ul>
      </slot>

      <slot></slot>

      <div v-show="$sidebar.showSidebar" class="navbar-collapse collapse show" id="sidenav-collapse-main">

        <div class="navbar-collapse-header d-md-none">
          <div class="row">
            <div class="col-6 collapse-brand">
              <router-link to="/">
                <img :src="logo">
              </router-link>
            </div>
            <div class="col-6 collapse-close">
              <navbar-toggle-button @click.native="closeSidebar"></navbar-toggle-button>
            </div>
          </div>
        </div>

        <!-- Sidebar main navigation -->
        <ul class="navbar-nav">
          <slot name="links"></slot>
        </ul>

        <!-- Divider -->
        <hr class="my-3">

        <!-- Documentation Section -->
        <h6 class="navbar-heading text-muted">Documentation</h6>
        <ul class="navbar-nav mb-md-3">
          <li class="nav-item">
            <a class="nav-link" target="blank" href="https://mttech.co.id/">
              <i class="ni ni-spaceship"></i> Company Profile MTT
            </a>
          </li>
        </ul>
        <ul class="navbar-nav mb-md-3">
          <li class="nav-item">
            <a class="nav-link" target="blank" href="http://192.168.40.150:50/">
              <i class="ni ni-image"></i> Documentation Giat
            </a>
          </li>
        </ul>
        <ul class="navbar-nav mb-md-3">
          <li class="nav-item">
            <a class="nav-link" target="blank" href="#">
              <i class="ni ni-paper-diploma"></i> Documentation Project
            </a>
          </li>
        </ul>
        <ul class="navbar-nav mb-md-3">
          <li class="nav-item">
            <a class="nav-link" target="blank" href="#">
              <i class="ni ni-books"></i> Document Project
            </a>
          </li>
        </ul>

        <!-- Divider -->
        <hr class="my-3">

        <!-- Logout Section -->
        <ul class="navbar-nav mb-md-3">
          <li class="nav-item">
            <a href="#!" class="nav-link text-danger" @click="logout">
              <i class="ni ni-user-run"></i> Logout
            </a>
          </li>
        </ul>

      </div>
    </div>
  </nav>
</template>

<script>
import NavbarToggleButton from '@/components/NavbarToggleButton'

export default {
  name: 'sidebar',
  components: {
    NavbarToggleButton
  },
  props: {
    logo: {
      type: String,
      default: 'img/brand/Logo MTT.png',
      description: 'Sidebar app logo'
    },
    autoClose: {
      type: Boolean,
      default: true,
      description: 'Whether sidebar should autoclose on mobile when clicking an item'
    }
  },
  provide() {
    return {
      autoClose: this.autoClose
    };
  },
  methods: {
    closeSidebar() {
      this.$sidebar.displaySidebar(false)
    },
    showSidebar() {
      this.$sidebar.displaySidebar(true)
    },
    logout() {
      // 🧩 Ganti dengan logic logout kamu
      // Contoh: hapus token dan redirect ke login
      localStorage.removeItem('token');
      this.$router.push('/login');
    }
  },
  beforeDestroy() {
    if (this.$sidebar.showSidebar) {
      this.$sidebar.showSidebar = false;
    }
  }
};
</script>
