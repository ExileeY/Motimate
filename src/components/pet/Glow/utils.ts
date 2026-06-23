export const linearInterpolate = (min: number, max: number, progress: number) => {
  'worklet'

  return min + (max - min) * progress
}

export const calcTriangleOpacity = (progress: number, fadeIn: number) => {
  'worklet'

  return progress < fadeIn ? progress / fadeIn : 1 - (progress - fadeIn) / (1 - fadeIn)
}

export const calcTransform = (scale: number, cx: number, cy: number, tx = 0, ty = 0) => {
  'worklet'

  return `translate(${tx} ${ty}) translate(${cx} ${cy}) scale(${scale}) translate(${-cx} ${-cy})`
}
