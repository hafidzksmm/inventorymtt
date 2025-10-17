import Vue from 'vue';
import VueRouter from 'vue-router';
import routes from './routes';

Vue.use(VueRouter);

const router = new VueRouter({
  mode: 'history',
  routes,
  linkActiveClass: 'active',
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) return savedPosition;
    if (to.hash) return { selector: to.hash };
    return { x: 0, y: 0 };
  },
});

// ✅ Route guard untuk autentikasi manual
router.beforeEach((to, from, next) => {
  const publicPages = ['/login']; // halaman bebas diakses
  const authRequired = !publicPages.includes(to.path);
  const user = localStorage.getItem('user');

  // Kalau butuh login tapi belum login
  if (authRequired && !user) {
    return next('/login');
  }

  // Kalau sudah login, jangan balik ke halaman login
  if (to.path === '/login' && user) {
    return next('/dashboard');
  }

  next();
});

export default router;
