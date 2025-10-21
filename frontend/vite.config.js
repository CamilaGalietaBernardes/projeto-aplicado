import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import { VitePWA } from 'vite-plugin-pwa'

const getProxyTarget = () => {
  if (process.env.VITE_API_URL)  return process.env.VITE_API_URL;

  if (process.env.IN_DOCKER === 'true')  return "http://app:5000"

  return "http://localhost:5000"
}

const getProdApi = () => 'https://projeto-aplicado.onrender.com'

export default defineConfig({
  plugins: [
    react(),
    VitePWA({
      registerType: 'autoUpdate',
      manifest: {
        name: 'Sistema de Manutenção',
        short_name: 'Manutenção',
        start_url: '/',
        display: 'standalone',
        background_color: '#10b981',
        theme_color: '#10b981',
        icons: [
          {
            src: '/vite.svg',
            sizes: '192x192',
            type: 'image/svg+xml',
          },
        ],
      },
    }),
  ],
  server: {
    host: true,      
    port: 5173,
    proxy: {
      '/api': {
        target: getProxyTarget(), 
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, ''),
      },
    },
  },

  define: {
    __API_URL__: JSON.stringify(getProdApi()),
  }
})
