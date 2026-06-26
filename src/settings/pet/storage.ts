import { PetId, PET_IDS, DEFAULT_PET_ID } from '@/pet/registry'
import { createPersistedStorage } from '@/settings/persistedStorage'

const STORAGE_KEY = 'motimate.pet'

export const PET_DEFAULT = DEFAULT_PET_ID

const normalize = (value: string | null): PetId =>
  PET_IDS.includes(value as any) ? (value as PetId) : PET_DEFAULT

export const petStorage = createPersistedStorage<PetId>({
  key: STORAGE_KEY,
  decode: normalize,
  encode: (id) => id,
  fallback: PET_DEFAULT
})

export const getPet = petStorage.get
export const setPet = petStorage.set
