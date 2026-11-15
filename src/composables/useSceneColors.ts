import { onMounted, onUnmounted } from 'vue'
import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'

gsap.registerPlugin(ScrollTrigger)

export function useSceneColors() {
  let media: ReturnType<typeof gsap.matchMedia> | undefined
  let refreshFrame: number | undefined
  let disposed = false

  const refresh = () => {
    if (disposed) return

    if (refreshFrame !== undefined) {
      window.cancelAnimationFrame(refreshFrame)
    }

    refreshFrame = window.requestAnimationFrame(() => {
      refreshFrame = undefined
      if (!disposed) ScrollTrigger.refresh()
    })
  }

  onMounted(() => {
    const root = document.getElementById('app')
    if (!root) return

    media = gsap.matchMedia()

    media.add(
      '(prefers-reduced-motion: no-preference)',
      () => {
        const sections = root.querySelectorAll<HTMLElement>('[data-scene]')

        sections.forEach((section) => {
          const styles = window.getComputedStyle(section)
          const background = styles.getPropertyValue('--scene-bg').trim()
          const entry = styles.getPropertyValue('--scene-entry').trim()

          if (!background || !entry) return

          // ヒーローは初期状態からテーマカラーで表示
          if (section.dataset.scene === 'hero') return

          gsap.fromTo(
            section,
            { backgroundColor: entry },
            {
              backgroundColor: background,
              ease: 'none',
              scrollTrigger: {
                trigger: section,
                start: 'top 95%',
                end: 'top 40%',
                scrub: 0.6,
                invalidateOnRefresh: true,
              },
            },
          )
        })
      },
      root,
    )

    refresh()

    if (document.readyState !== 'complete') {
      window.addEventListener('load', refresh, { once: true })
    }

    void document.fonts.ready.then(refresh)
  })

  onUnmounted(() => {
    disposed = true
    window.removeEventListener('load', refresh)

    if (refreshFrame !== undefined) {
      window.cancelAnimationFrame(refreshFrame)
    }

    media?.revert()
    media = undefined
  })
}
