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
import { Mood } from '@/pet/mood'
import { MessageSet, pickMessages } from '@/pet/messages'
import { mochiMessages } from '@/pet/mochi/messages'
import { bulbashikMessages } from '@/pet/bulbashik/messages'
import { dogMessages } from '@/pet/dog/messages'
import { octopusMessages } from '@/pet/octopus/messages'
import { aruticMessages } from '@/pet/arutic/messages'
import { khinklearMessages } from '@/pet/khinklear/messages'
import Mochi from '@/components/pet/Mochi'
import Bulbashik from '@/components/pet/Bulbashik'
import Dog from '@/components/pet/Dog'
import Octopus from '@/components/pet/Octopus'
import Arutic from '@/components/pet/Arutic'
import Khinklear from '@/components/pet/Khinklear'

enum PetId {
  MOCHI = 'mochi',
  BULBASHIK = 'bulbashik',
  DOG = 'dog',
  OCTOPUS = 'octopus',
  ARUTIC = 'arutic',
  KHINKLEAR = 'khinklear',
}

interface PetDefinition {
  Body: React.FC<{ mood: Mood; size?: number }>
  pickMessages: () => Record<Mood, MessageSet>
}

const PETS: Record<PetId, PetDefinition> = {
  [PetId.MOCHI]: {
    Body: Mochi,
    pickMessages: () => pickMessages(mochiMessages)
  },
  [PetId.BULBASHIK]: {
    Body: Bulbashik,
    pickMessages: () => pickMessages(bulbashikMessages)
  },
  [PetId.DOG]: {
    Body: Dog,
    pickMessages: () => pickMessages(dogMessages)
  },
  [PetId.OCTOPUS]: {
    Body: Octopus,
    pickMessages: () => pickMessages(octopusMessages)
  },
  [PetId.ARUTIC]: {
    Body: Arutic,
    pickMessages: () => pickMessages(aruticMessages)
  },
  [PetId.KHINKLEAR]: {
    Body: Khinklear,
    pickMessages: () => pickMessages(khinklearMessages)
  }
}

export const activePet = PETS[PetId.KHINKLEAR]
