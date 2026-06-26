import AsyncStorage from '@react-native-async-storage/async-storage'
import { PetId, PET_IDS, DEFAULT_PET_ID } from '@/pet/registry'

export const PET_DEFAULT = DEFAULT_PET_ID

const STORAGE_KEY = 'motimate.pet'

export const normalizePetId = (value: string | null): PetId =>
  PET_IDS.includes(value as any) ? (value as PetId) : PET_DEFAULT

export const readPet = async (): Promise<PetId> => {
  try {
    return normalizePetId(await AsyncStorage.getItem(STORAGE_KEY))
  } catch {
    return PET_DEFAULT
  }
}

export const writePet = async (id: PetId): Promise<void> => {
  try {
    await AsyncStorage.setItem(STORAGE_KEY, id)
  } catch {
    // Do nothing
  }
}
