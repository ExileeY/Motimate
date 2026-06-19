/**
 * Fredoka (headings) + Nunito (body) loading. The mockups use the 500/600
 * Fredoka weights and 400/700 Nunito weights — those are the four we load.
 *
 * `useAppFonts()` returns `[loaded, error]`; the screen gates rendering on it.
 */
import {
  useFonts,
  Fredoka_500Medium,
  Fredoka_600SemiBold,
} from '@expo-google-fonts/fredoka'
import {
  Nunito_400Regular,
  Nunito_700Bold
} from '@expo-google-fonts/nunito'

export const useAppFonts = () =>
  useFonts({
    Fredoka_500Medium,
    Fredoka_600SemiBold,
    Nunito_400Regular,
    Nunito_700Bold,
  })
