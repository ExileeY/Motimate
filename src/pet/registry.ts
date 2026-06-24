/**
 * Pet registry — the single place that knows which pets exist and which one is
 * active. Each pet contributes its body component and its message table; the
 * rest of the app (PetStage, the home screen) reads `PETS[ACTIVE_PET]` instead
 * of importing a specific pet.
 *
 * To add a pet: build its `Body` (mood-prop SVG, like Mochi/Bulbashik) and its
 * `messages`, then add one entry here. To switch the active pet: change the one
 * `ACTIVE_PET` constant below — that's the whole "programmatic switch".
 *
 * The shared, mood-driven Glow (Halo/Particles/Zzz) is intentionally NOT part of
 * a pet's definition — it stays pet-agnostic in PetStage.
 */
import React from 'react'
import { Mood } from '@/mood/mood'
import { MoodMessage, mochiMessages, bulbashikMessages } from '@/mood/messages'
import Mochi from '@/components/pet/Mochi'
import Bulbashik from '@/components/pet/Bulbashik'

enum PetId {
  MOCHI = 'mochi',
  BULBASHIK = 'bulbashik',
}

interface PetDef {
  Body: React.FC<{ mood: Mood; size?: number }>
  messages: Record<Mood, MoodMessage[]>
}

const PETS: Record<PetId, PetDef> = {
  [PetId.MOCHI]: {
    Body: Mochi,
    messages: mochiMessages,
  },
  [PetId.BULBASHIK]: {
    Body: Bulbashik,
    messages: bulbashikMessages,
  },
}

export const activePet = PETS[PetId.BULBASHIK]
