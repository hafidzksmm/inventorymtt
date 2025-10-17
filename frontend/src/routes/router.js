import Vue from 'vue';
import VueRouter from 'vue-router';
import routes from './routes';
import axios from 'axios';

Vue.use(VueRouter);

const router = new VueRouter({
  routes,
  linkActiveClass: 'active',
  scrollBehavior: (to, from, savedPosition) => {
    if (savedPosition) return savedPosition;
    if (to.hash) return { selector: to.hash };
    return { x: 0, y: 0 };
  },
});

// ===============================
// 🛡️ Route Guard Lengkap
// ===============================
router.beforeEach(async (to, from, next) => {
  const publicPages = ['/login', '/register'];
  const authRequired = !publicPages.includes(to.path);
  const token = localStorage.getItem('token');

  // 1️⃣ Halaman publik (login/register)
  if (!authRequired) {
    // Kalau user SUDAH login tapi mau ke /login atau /register → arahkan ke dashboard
    if (token && (to.path === '/login' || to.path === '/register')) {
      return next('/dashboard');
    }
    return next();
  }

  // 2️⃣ Halaman butuh login tapi token kosong
  if (!token) {
    return next('/login');
  }

  // 3️⃣ Cek validitas token ke backend
  try {
    const res = await axios.get('http://192.168.40.200:5000/api/users/check-token', {
      headers: { Authorization: `Bearer ${token}` },
    });

    if (res.data.valid) {
      return next(); // Token valid, lanjut ke halaman tujuan
    } else {
      localStorage.removeItem('token');
      return next('/login');
    }
  } catch (err) {
    console.warn('Token invalid atau server error:', err);

    // Kalau server balas 401 → token expired
    if (err.response && err.response.status === 401) {
      localStorage.removeItem('token');
    }

    return next('/login');
  }
});

export default router;
