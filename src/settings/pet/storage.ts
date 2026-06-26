import { PetId, PET_IDS, DEFAULT_PET_ID } from '@/pet/registry'
import { createPersistedStorage } from '@/settings/persistedStorage'

const STORAGE_KEY = 'motimate.pet'

export const PET_DEFAULT = DEFAULT_PET_ID

export const normalize = (value: PetId): PetId =>
  PET_IDS.includes(value as any) ? value : PET_DEFAULT

export const petStorage = createPersistedStorage<PetId>({
  key: STORAGE_KEY,
  decode: (id) => (id ?? PET_DEFAULT) as PetId,
  encode: (id) => id,
  normalize: normalize,
  fallback: PET_DEFAULT
})

export const getPet = petStorage.get
export const setPet = petStorage.set
