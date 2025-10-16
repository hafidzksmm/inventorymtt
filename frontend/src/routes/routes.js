import DashboardLayout from '@/views/Layout/DashboardLayout.vue';
import AuthLayout from '@/views/Pages/AuthLayout.vue';
import NotFound from '@/views/NotFoundPage.vue';

const routes = [
  // 🔹 Route untuk login & register
  {
    path: '/',
    redirect: '/login', // login jadi halaman utama
    component: AuthLayout,
    children: [
      {
        path: '/login',
        name: 'login',
        component: () => import('../views/Pages/Login.vue'),
      },
      {
        path: '/register',
        name: 'register',
        component: () => import('../views/Pages/Register.vue'),
      },
    ],
  },

  // 🔹 Route setelah login
  {
    path: '/app',
    redirect: '/dashboard',
    component: DashboardLayout,
    meta: { requiresAuth: true }, // <--- nanti dipakai di guard
    children: [
      {
        path: '/dashboard',
        name: 'Dashboard',
        component: () => import('../views/Dashboard.vue'),
      },
      {
        path: '/inventoryws',
        name: 'Inventory WS',
        component: () => import('../views/InventoryWS.vue'),
      },
      {
        path: '/inventoryproject',
        name: 'Inventory Project',
        component: () => import('../views/InventoryProjek.vue'),
      },
      {
        path: '/assetjual',
        name: 'Asset Jual',
        component: () => import('../views/Assetjual.vue'),
      },
      {
        path: '/profile',
        name: 'Profile',
        component: () => import('../views/Pages/UserProfile.vue'),
      },
      {
        path: '/tables',
        name: 'Tables',
        component: () => import('../views/RegularTables.vue'),
      },
    ],
  },

  // 🔹 Route not found
  { path: '*', component: NotFound },
];

export default routes;
