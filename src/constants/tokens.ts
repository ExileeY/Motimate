/**
 * Design tokens — every value here is lifted verbatim from the mockups
 * (`Mockups/Emotions/Mochi/{happy,calm,tired}.dc.html`). Nothing is invented.
 *
 * The per-mood tables are keyed by the `Mood` enum so the whole UI can do a
 * single `TABLE[mood]` lookup (see src/mood/mood.ts).
 */
import { Mood } from '@/pet/mood'

/** Shared terracotta-cream palette (mood-independent). */
export const colors = {
  text: '#503A29', // headings / brand
  accent: '#C77E45', // brand dot + "mood" word
  pillText: '#6B4F3F', // time-of-day pill label + card title
  clock: '#8A6F58', // clock time
  subtitle: '#967A60', // pet subtitle
  cardMeta: '#A98C76', // card right-hand meta ("quiet so far")
  cardFooter: '#9A8472', // card footer line
  pillBg: 'rgba(255,247,237,0.6)',
  pillBorder: 'rgba(214,150,100,0.22)',
  cardBg: 'rgba(255,247,237,0.55)',
  cardBorder: 'rgba(214,150,100,0.18)',
  barTrack: 'rgba(140,90,55,0.12)',
  barFrom: '#F0B07A', // progress bar gradient start
  barTo: '#E08A4F', // progress bar gradient end
} as const

export const fonts = {
  heading: 'Fredoka_600SemiBold',
  headingMedium: 'Fredoka_500Medium',
  bodyRegular: 'Nunito_400Regular',
  bodyBold: 'Nunito_700Bold',
} as const

export interface ScreenBackground {
  colors: [string, string, string]
  locations: [number, number, number] // radial-gradient stop offsets (0..1), reused as linear locations.
}

export const screenBackground: Record<Mood, ScreenBackground> = {
  [Mood.ENERGETIC]: {
    colors: ['#FCE0C2', '#F6C49A', '#EDA877'],
    locations: [0, 0.44, 1],
  },
  [Mood.CALM]: {
    colors: ['#FBEAD6', '#F4D7B6', '#ECD4BC'],
    locations: [0, 0.5, 1],
  },
  [Mood.TIRED]: {
    colors: ['#F3E0CA', '#E7C6A1', '#D9B083'],
    locations: [0, 0.56, 1],
  },
  [Mood.SAD]: {
    colors: ['#E4EDF4', '#CFDCE8', '#BFCFE0'],
    locations: [0, 0.5, 1],
  },
}

/**
 * The soft circular halo behind the pet. In the mockups this is a blurred
 * `radial-gradient(circle, rgba(...,a), rgba(...,0) 68%)` that `glowPulse`s.
 */
export interface GlowSpec {
  size: number // px diameter (236 / 220 / 206)
  color: string // inner rgb
  opacity: number // inner alpha (0.95 / 0.7 / 0.6)
  pulseDuration: number // glowPulse ms (5500 / 7000 / 8000)
}

export const glow: Record<Mood, GlowSpec> = {
  [Mood.ENERGETIC]: {
    size: 236,
    color: '#FFDEB6',
    opacity: 0.95,
    pulseDuration: 5500
  },
  [Mood.CALM]: {
    size: 220,
    color: '#FAE2C6',
    opacity: 0.7,
    pulseDuration: 7000
  },
  [Mood.TIRED]: {
    size: 206,
    color: '#FFEEDC',
    opacity: 0.6,
    pulseDuration: 8000
  },
  [Mood.SAD]: {
    size: 236,
    color: '#BED6EC',
    opacity: 0.8,
    pulseDuration: 5500
  },
}

export const statusDot: Record<Mood, string> = {
  [Mood.ENERGETIC]: '#C9824F',
  [Mood.CALM]: '#E0A95C',
  [Mood.TIRED]: '#B98E5E',
  [Mood.SAD]: '#7FA3C9'
}

export const screen = {
  width: 276,
  height: 600,
} as const
