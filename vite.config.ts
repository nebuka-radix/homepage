import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

const entry = (path: string) =>
  decodeURIComponent(new URL(path, import.meta.url).pathname)

export default defineConfig({
  base: '/homepage/',
  plugins: [vue()],
  build: {
    rollupOptions: {
      input: {
        home: entry('./index.html'),
        about: entry('./about/index.html'),
        services: entry('./services/index.html'),
        projects: entry('./projects/index.html'),
        career: entry('./career/index.html'),
        availability: entry('./availability/index.html'),
      },
    },
  },
})
