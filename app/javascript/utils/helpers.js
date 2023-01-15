const randomElementFrom = (array) => {
  if (
    array === null ||
    array === undefined ||
    typeof array === 'Object' ||
    array.length === 0
  ) {
    return null
  }

  return array[Math.floor(Math.random() * array.length)]
}

export { randomElementFrom }
