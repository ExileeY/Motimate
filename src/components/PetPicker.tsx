import React from 'react'
import { View, Text, Pressable, StyleSheet } from 'react-native'
import { Ionicons } from '@expo/vector-icons'
import { Mood } from '@/pet/mood'
import { PetId, PET_IDS, PETS } from '@/pet/registry'
import { useActivePet } from '@/settings/pet/useActivePet'
import { colors, fonts } from '@/constants/tokens'

const PREVIEW_SIZE = 64

const PetPicker = () => {
  const { petId, setPet } = useActivePet()

  return (
    <View style={styles.grid}>
      {PET_IDS.map((id) => (
        <PetTile
          key={id}
          id={id}
          selected={id === petId}
          onSelect={setPet}
        />
      ))}
    </View>
  )
}

interface PetTileProps {
  id: PetId
  selected: boolean
  onSelect: (id: PetId) => void
}

const PetTile = ({ id, selected, onSelect }: PetTileProps) => {
  const { name, Body } = PETS[id]

  return (
    <Pressable
      style={styles.tile}
      onPress={() => onSelect(id)}
      accessibilityRole="button"
      accessibilityState={{ selected }}
      accessibilityLabel={name}
    >
      <View style={[styles.preview, selected && styles.previewSelected]}>
        <Body mood={Mood.CALM} size={PREVIEW_SIZE} />
        {selected ? (
          <View style={styles.badge}>
            <Ionicons name="checkmark" size={14} color="#fff" />
          </View>
        ) : null}
      </View>
      <Text style={styles.name} numberOfLines={1}>
        {name}
      </Text>
    </Pressable>
  )
}

export default PetPicker

const styles = StyleSheet.create({
  grid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 12,
  },
  tile: {
    flexBasis: '30%',
    flexGrow: 1,
    maxWidth: '32%',
    alignItems: 'center',
    gap: 7,
  },
  preview: {
    width: '100%',
    aspectRatio: 1,
    borderRadius: 18,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: colors.cardBg,
    borderWidth: 1.5,
    borderColor: colors.cardBorder,
  },
  previewSelected: {
    borderWidth: 2.5,
    borderColor: colors.accent,
  },
  badge: {
    position: 'absolute',
    top: 7,
    right: 7,
    width: 22,
    height: 22,
    borderRadius: 11,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: colors.accent,
  },
  name: {
    fontFamily: fonts.headingMedium,
    fontSize: 13.5,
    color: colors.text,
  },
})
