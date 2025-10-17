<template>
  <div class="main-content bg-default">
    <base-nav
      v-model="showMenu"
      :transparent="false"
      menu-classes="justify-content-end"
      class="navbar-horizontal navbar-main navbar-top navbar-dark"
      expand="lg"
    >
      <div slot="brand" class="navbar-wrapper">
        <b-navbar-brand to="/">
        </b-navbar-brand>
      </div>

      <template>
        <div class="navbar-collapse-header">
          <b-row>
            <b-col cols="6" class="collapse-brand">
              <router-link to="/">
              </router-link>
            </b-col>
            <b-col cols="6" class="collapse-close">
              <button type="button" class="navbar-toggler" @click="showMenu = false">
                <span></span>
                <span></span>
              </button>
            </b-col>
          </b-row>
        </div>
        <b-navbar-nav class="align-items-lg-center ml-lg-auto">
          <b-nav-item to="/register">
            <i class="ni ni-circle-08"></i>
            <span class="nav-link-inner--text font-weight-bold">Register</span>
          </b-nav-item>
          <b-nav-item to="/login">
            <i class="ni ni-key-25"></i>
            <span class="nav-link-inner--text font-weight-bold">Login</span>
          </b-nav-item>
        </b-navbar-nav>
      </template>
    </base-nav>

    <div class="main-content">
      <zoom-center-transition
        :duration="pageTransitionDuration"
        mode="out-in"
      >
        <router-view></router-view>
      </zoom-center-transition>
    </div>

  </div>
</template>

<script>
import { BaseNav } from '@/components';
import { ZoomCenterTransition } from 'vue2-transitions';

export default {
  components: {
    BaseNav,
    ZoomCenterTransition,
  },
  props: {
    backgroundColor: {
      type: String,
      default: 'black',
    },
  },
  data() {
    return {
      showMenu: false,
      menuTransitionDuration: 250,
      pageTransitionDuration: 200,
      year: new Date().getFullYear(),
      pageClass: 'login-page',
    };
  },
  computed: {
    title() {
      return `${this.$route.name} Page`;
    },
  },
  beforeRouteUpdate(to, from, next) {
    if (this.showMenu) {
      this.closeMenu();
      setTimeout(() => {
        next();
      }, this.menuTransitionDuration);
    } else {
      next();
    }
  },
  watch: {
    $route: {
      immediate: true,
      handler() {
        this.updateBackground();
      },
    },
  },
};
</script>

<style scoped>
.texts {
  text-align: center;
  padding-left: 421px;
  color:white;
}

/* 🌄 Tambahkan background di sini */
.main-content.bg-default {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background-image: url("~@/assets/bg-regislogin3.jpg");
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  background-attachment: fixed;
  }
</style>

<style lang="scss">
$scaleSize: 0.8;

@keyframes zoomIn8 {
  from {
    opacity: 0;
    transform: scale3d($scaleSize, $scaleSize, $scaleSize);
  }
  100% {
    opacity: 1;
  }
}

.main-content .zoomIn {
  animation-name: zoomIn8;
}

@keyframes zoomOut8 {
  from {
    opacity: 1;
  }
  to {
    opacity: 0;
    transform: scale3d($scaleSize, $scaleSize, $scaleSize);
  }
}

.main-content .zoomOut {
  animation-name: zoomOut8;
}
</style>
