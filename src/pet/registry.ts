import React from 'react'
import { Mood } from '@/pet/mood'
import { MessageSet, pickMessages } from '@/pet/messages'
import { mochiMessages } from '@/pet/mochi/messages'
import { bulbashikMessages } from '@/pet/bulbashik/messages'
import { dogMessages } from '@/pet/dog/messages'
import { octopusMessages } from '@/pet/octopus/messages'
import { aruticMessages } from '@/pet/arutic/messages'
import { khinklearMessages } from '@/pet/khinklear/messages'
import { tomatoMessages } from '@/pet/tomato/messages'
import Mochi from '@/components/pet/Mochi'
import Bulbashik from '@/components/pet/Bulbashik'
import Dog from '@/components/pet/Dog'
import Octopus from '@/components/pet/Octopus'
import Arutic from '@/components/pet/Arutic'
import Khinklear from '@/components/pet/Khinklear'
import Tomato from '@/components/pet/Tomato'

export enum PetId {
  MOCHI = 'mochi',
  BULBASHIK = 'bulbashik',
  DOG = 'dog',
  OCTOPUS = 'octopus',
  ARUTIC = 'arutic',
  KHINKLEAR = 'khinklear',
  TOMATO = 'tomato',
}

export interface PetDefinition {
  name: string
  Body: React.FC<{ mood: Mood; size?: number }>
  pickMessages: () => Record<Mood, MessageSet>
}

export const PETS: Record<PetId, PetDefinition> = {
  [PetId.MOCHI]: {
    name: 'Mochi',
    Body: Mochi,
    pickMessages: () => pickMessages(mochiMessages)
  },
  [PetId.BULBASHIK]: {
    name: 'Bulbashik',
    Body: Bulbashik,
    pickMessages: () => pickMessages(bulbashikMessages)
  },
  [PetId.DOG]: {
    name: 'Dog',
    Body: Dog,
    pickMessages: () => pickMessages(dogMessages)
  },
  [PetId.OCTOPUS]: {
    name: 'Octopus',
    Body: Octopus,
    pickMessages: () => pickMessages(octopusMessages)
  },
  [PetId.ARUTIC]: {
    name: 'Arutic',
    Body: Arutic,
    pickMessages: () => pickMessages(aruticMessages)
  },
  [PetId.KHINKLEAR]: {
    name: 'Khinklear',
    Body: Khinklear,
    pickMessages: () => pickMessages(khinklearMessages)
  },
  [PetId.TOMATO]: {
    name: 'Tomato',
    Body: Tomato,
    pickMessages: () => pickMessages(tomatoMessages)
  }
}

export const PET_IDS = Object.keys(PETS) as PetId[]
export const DEFAULT_PET_ID = PetId.MOCHI

