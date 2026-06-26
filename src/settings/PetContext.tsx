import React, {
  createContext,
  useContext,
  useEffect,
  useState
} from 'react'

import { PetId, PetDefinition, PETS } from '@/pet/registry'
import { PET_DEFAULT, readPet, writePet } from '@/settings/petStorage'

interface PetContextValue {
  petId: PetId
  activePet: PetDefinition
  ready: boolean
  setPet: (id: PetId) => void
}

const PetContext = createContext<PetContextValue | null>(null)

export const PetProvider = ({ children }: { children: React.ReactNode }) => {
  const [petId, setPetState] = useState<PetId>(PET_DEFAULT)
  const [ready, setReady] = useState(false)

  useEffect(() => {
    let active = true

    readPet()
      .then((stored) => {
        if (active) {
          setPetState(stored)
          setReady(true)
        }
      })

    return () => { active = false }
  }, [])

  const setPet = (id: PetId): void => {
    setPetState(id)
    writePet(id)
  }

  return (
    <PetContext.Provider value={{ petId, activePet: PETS[petId], ready, setPet }}>
      {children}
    </PetContext.Provider>
  )
}

export const useActivePet = () => {
  const context = useContext(PetContext)

  if (context) return context

  throw new Error('useActivePet must be used within a PetProvider')
}
