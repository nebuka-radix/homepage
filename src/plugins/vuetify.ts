import 'vuetify/styles'
import { createVuetify } from 'vuetify'
import {
  VApp,
  VMain,
  VContainer,
  VCard,
  VChip,
  VDivider,
} from 'vuetify/components'

export default createVuetify({
  components: {
    VApp,
    VMain,
    VContainer,
    VCard,
    VChip,
    VDivider,
  },
  theme: {
    defaultTheme: 'homepageLight',
    themes: {
      homepageLight: {
        dark: false,
        colors: {
          background: '#F7F8FC',
          surface: '#FFFFFF',
          primary: '#405CE8',
          secondary: '#64748B',
          'on-background': '#17243B',
          'on-surface': '#17243B',
          'on-primary': '#FFFFFF',
        },
      },
    },
  },
  defaults: {
    VCard: {
      elevation: 0,
      rounded: 'xl',
    },
  },
})
