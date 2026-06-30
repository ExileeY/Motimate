import { normalize, PET_DEFAULT } from '@/settings/pet/storage'
import { PetId, PET_IDS } from '@/pet/registry'

describe('pet normalize', () => {
  it('passes through every registered PetId unchanged', () => {
    for (const id of PET_IDS) {
      expect(normalize(id)).toBe(id)
    }
  })

  it('falls back to PET_DEFAULT for an unregistered value', () => {
    expect(normalize('not-a-pet' as PetId)).toBe(PET_DEFAULT)
    expect(normalize(undefined as unknown as PetId)).toBe(PET_DEFAULT)
  })
})
