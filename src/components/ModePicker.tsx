import React from 'react'
import { View, Text, Pressable, Alert, StyleSheet } from 'react-native'
import { Ionicons } from '@expo/vector-icons'
import { GameMode } from '@/settings/mode/storage'
import { useMode } from '@/settings/mode/useMode'
import { colors, fonts } from '@/constants/tokens'

interface ModeOption {
  id: GameMode
  title: string
  icon: string
  subtitle: string
  isDefault: boolean
}

const MODE_OPTIONS: ModeOption[] = [
  {
    id: GameMode.STANDARD,
    title: 'Standard',
    icon: '🍃',
    subtitle: 'Your pet stays happy and safe, no matter your step count.',
    isDefault: true,
  },
  {
    id: GameMode.REAL,
    title: 'Real',
    icon: '🔥',
    subtitle: 'Steps become food. Walk too little and your pet goes hungry.',
    isDefault: false,
  },
]

const ModePicker = () => {
  const { mode, setMode } = useMode()

  const onSelect = (id: GameMode) => {
    if (id === mode) return

    if (id === GameMode.REAL) {
      Alert.alert(
        'Your pet is in danger!',
        'When this mode is enabled, your steps are converted into food for your pet. If the pet gets hungry, it will suffer.',
        [
          { text: 'Cancel', style: 'cancel' },
          { text: 'Enable', style: 'destructive', onPress: () => setMode(GameMode.REAL) },
        ]
      )
      return
    }

    setMode(id)
  }

  return (
    <View style={styles.list}>
      {MODE_OPTIONS.map((option) => (
        <ModeRow
          key={option.id}
          option={option}
          selected={option.id === mode}
          onSelect={onSelect}
        />
      ))}
    </View>
  )
}

interface ModeRowProps {
  option: ModeOption
  selected: boolean
  onSelect: (id: GameMode) => void
}

const ModeRow = ({ option, selected, onSelect }: ModeRowProps) => (
  <Pressable
    style={[styles.row, selected && styles.rowSelected]}
    onPress={() => onSelect(option.id)}
    accessibilityRole="button"
    accessibilityState={{ selected }}
    accessibilityLabel={option.title}
  >
    <View style={styles.iconTile}>
      <Text style={styles.icon}>
        {option.icon}
      </Text>
    </View>
    <View style={styles.rowText}>
      <View style={styles.titleRow}>
        <Text style={styles.title}>
          {option.title}
        </Text>
        {option.isDefault ? (
          <View style={styles.defaultPill}>
            <Text style={styles.defaultPillText}>
              Default
            </Text>
          </View>
        ) : null}
      </View>
      <Text style={styles.subtitle}>
        {option.subtitle}
      </Text>
    </View>
    <View style={[styles.radio, selected && styles.radioSelected]}>
      {selected ? (
        <Ionicons name="checkmark" size={14} color="#fff" />
      ) : null}
    </View>
  </Pressable>
)

export default ModePicker

const styles = StyleSheet.create({
  list: {
    gap: 12,
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 13,
    paddingVertical: 15,
    paddingHorizontal: 15,
    borderRadius: 20,
    backgroundColor: colors.cardBg,
    borderWidth: 1.5,
    borderColor: colors.cardBorder,
  },
  rowSelected: {
    borderWidth: 2,
    borderColor: colors.accent,
  },
  iconTile: {
    width: 46,
    height: 46,
    borderRadius: 14,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: colors.pillBg,
  },
  icon: {
    fontSize: 22,
  },
  rowText: {
    flex: 1,
  },
  titleRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 7,
  },
  title: {
    fontFamily: fonts.heading,
    fontSize: 16.5,
    color: colors.text,
  },
  defaultPill: {
    paddingVertical: 2,
    paddingHorizontal: 7,
    borderRadius: 99,
    backgroundColor: colors.barTrack,
  },
  defaultPillText: {
    fontFamily: fonts.bodyBold,
    fontSize: 9.5,
    letterSpacing: 0.5,
    textTransform: 'uppercase',
    color: colors.cardMeta,
  },
  subtitle: {
    fontFamily: fonts.bodyRegular,
    fontSize: 12,
    color: colors.subtitle,
    marginTop: 3,
  },
  radio: {
    width: 24,
    height: 24,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 2,
    borderColor: colors.pillBorder,
  },
  radioSelected: {
    borderWidth: 0,
    backgroundColor: colors.accent,
  },
})
