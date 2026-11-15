import { onMounted, onUnmounted } from 'vue'
import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'

gsap.registerPlugin(ScrollTrigger)

export function useMobilePresentation() {
  let media: ReturnType<typeof gsap.matchMedia> | undefined
  let frame: number | undefined
  let disposed = false

  const refresh = () => {
    if (disposed) return

    if (frame !== undefined) {
      window.cancelAnimationFrame(frame)
    }

    frame = window.requestAnimationFrame(() => {
      frame = undefined
      if (!disposed) ScrollTrigger.refresh()
    })
  }

  onMounted(() => {
    const root = document.getElementById('app')
    if (!root) return

    media = gsap.matchMedia()

    media.add(
      '(max-width: 700px) and (prefers-reduced-motion: no-preference)',
      () => {
        const progress = root.querySelector<HTMLElement>(
          '[data-mobile-progress]',
        )

        if (progress) {
          gsap.fromTo(
            progress,
            { scaleX: 0 },
            {
              scaleX: 1,
              ease: 'none',
              scrollTrigger: {
                start: 0,
                end: 'max',
                scrub: true,
                invalidateOnRefresh: true,
              },
            },
          )
        }

        // 既存演出のtransform・opacityとは異なるプロパティを使用
        const headings = root.querySelectorAll<HTMLElement>(
          '.scene-section .section-heading',
        )

        headings.forEach((heading) => {
          gsap.fromTo(
            heading,
            { '--mobile-rule': 0.15 },
            {
              '--mobile-rule': 1,
              duration: 0.75,
              ease: 'power3.out',
              scrollTrigger: {
                trigger: heading,
                start: 'top 92%',
                once: true,
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

    if (frame !== undefined) {
      window.cancelAnimationFrame(frame)
    }

    media?.revert()
    media = undefined
  })
}
