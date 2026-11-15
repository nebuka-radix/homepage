import { onMounted, onUnmounted } from 'vue'
import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'

gsap.registerPlugin(ScrollTrigger)

export function usePageAnimations() {
  let media: ReturnType<typeof gsap.matchMedia> | undefined
  let refreshFrame: number | undefined
  let disposed = false

  const refreshLayout = () => {
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

    const select = (selector: string) =>
      Array.from(root.querySelectorAll<HTMLElement>(selector))

    media = gsap.matchMedia()

    media.add(
      {
        desktop: '(min-width: 701px)',
        mobile: '(max-width: 700px)',
        reduceMotion: '(prefers-reduced-motion: reduce)',
      },
      (context) => {
        const conditions = context.conditions
        if (!conditions || conditions.reduceMotion) return

        const mobile = Boolean(conditions.mobile)
        const distance = mobile ? 14 : 24
        const duration = mobile ? 0.5 : 0.65

        // ファーストビュー：短い時間差で情報を提示
        const heroTargets = select(
          '.hero-copy > .eyebrow, ' +
          '.hero-copy > h1, ' +
          '.hero-copy > .hero-description, ' +
          '.hero-copy > .hero-actions, ' +
          '.hero-copy > .hero-signature',
        )

        gsap.from(heroTargets, {
          y: distance,
          opacity: 0,
          duration: 0.7,
          stagger: 0.1,
          ease: 'power2.out',
          clearProps: 'transform,opacity',
        })

        // 既存のCSSによる傾き・レスポンシブ設定を保つ
        gsap.from(select('.art-card-back'), {
          y: 18,
          opacity: 0,
          duration: 0.85,
          delay: 0.12,
          ease: 'power2.out',
          clearProps: 'transform,opacity',
        })

        gsap.from(select('.art-card-front'), {
          y: 30,
          opacity: 0,
          duration: 0.85,
          delay: 0.25,
          ease: 'power3.out',
          clearProps: 'transform,opacity',
        })

        gsap.from(select('.art-label'), {
          y: 12,
          opacity: 0,
          duration: 0.6,
          delay: 0.65,
          ease: 'power2.out',
          clearProps: 'transform,opacity',
        })

        const animated = new Set<HTMLElement>()
        const revealTweens: gsap.core.Tween[] = []

        const reveal = (
          elements: HTMLElement[],
          trigger: HTMLElement,
          stagger = 0,
        ) => {
          const targets = elements.filter((element) => !animated.has(element))
          if (!targets.length) return

          targets.forEach((element) => animated.add(element))

          const tween = gsap.from(targets, {
            y: distance,
            // 待機中も内容を完全には隠さない
            opacity: 0.25,
            duration,
            stagger,
            ease: 'power2.out',
            clearProps: 'transform,opacity',
            scrollTrigger: {
              trigger,
              start: 'top 92%',
              once: true,
              invalidateOnRefresh: true,
            },
          })

          revealTweens.push(tween)
        }

        // グリッドはデスクトップではまとめて、モバイルでは項目単位
        for (const grid of select('.highlight-grid, .service-grid')) {
          const items = Array.from(grid.children).filter(
            (item): item is HTMLElement => item instanceof HTMLElement,
          )

          if (mobile) {
            items.forEach((item) => reveal([item], item))
          } else {
            reveal(items, grid, 0.09)
          }
        }

        // 長い事例カードはそれぞれの表示位置で再生
        for (const item of select(
          '.project-card, .career-item, .skill-group, .principle',
        )) {
          reveal([item], item)
        }

        // 見出し・紹介文・参画条件
        for (const item of select(
          '.section-heading, ' +
          '.about-layout > div, ' +
          '.availability-layout > div, ' +
          '.availability-details > div',
        )) {
          reveal([item], item)
        }

        // アンカー移動やキーボード操作時は、対象をすぐ読める状態にする
        const finishContaining = (target: HTMLElement) => {
          revealTweens.forEach((tween) => {
            const containsTarget = tween.targets().some((element: unknown) =>
              element instanceof HTMLElement
                ? element === target ||
                  element.contains(target) ||
                  target.contains(element)
                : false,
            )

            if (containsTarget) tween.progress(1)
          })
        }

        const handleFocus = (event: FocusEvent) => {
          if (event.target instanceof HTMLElement) {
            finishContaining(event.target)
          }
        }

        const handleClick = (event: MouseEvent) => {
          if (!(event.target instanceof Element)) return

          const link = event.target.closest<HTMLAnchorElement>('a[href^="#"]')
          const href = link?.getAttribute('href')
          if (!href || href === '#') return

          let id: string
          try {
            id = decodeURIComponent(href.slice(1))
          } catch {
            return
          }

          const target = document.getElementById(id)
          if (target && root.contains(target)) finishContaining(target)
        }

        root.addEventListener('focusin', handleFocus)
        root.addEventListener('click', handleClick)

        return () => {
          root.removeEventListener('focusin', handleFocus)
          root.removeEventListener('click', handleClick)
        }
      },
      root,
    )

    refreshLayout()

    // Webフォント・画像等の読み込み後に位置を再計算
    if (document.readyState !== 'complete') {
      window.addEventListener('load', refreshLayout, { once: true })
    }

    void document.fonts.ready.then(() => {
      refreshLayout()
    })
  })

  onUnmounted(() => {
    disposed = true
    window.removeEventListener('load', refreshLayout)

    if (refreshFrame !== undefined) {
      window.cancelAnimationFrame(refreshFrame)
    }

    media?.revert()
    media = undefined
  })
}
