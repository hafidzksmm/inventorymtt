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
// 🛡️ Route Guard
// ===============================
router.beforeEach(async (to, from, next) => {
  const publicPages = ['/login', '/register'];
  const authRequired = !publicPages.includes(to.path);
  const token = localStorage.getItem('token');

  if (!authRequired) {
    return next(); // halaman publik
  }

  if (!token) {
    return next('/login'); // belum login
  }

  try {
    const res = await axios.get('http://192.168.40.200:5000/api/users/check-token', {
      headers: { Authorization: `Bearer ${token}` },
    });

    if (res.data.valid) {
      return next(); // token valid, lanjut
    } else {
      localStorage.removeItem('token');
      return next('/login');
    }
  } catch (err) {
    console.warn('Token invalid:', err);
    localStorage.removeItem('token');
    return next('/login');
  }
});

export default router;
