const randomElementFrom = (array) => {
  if (
    array === null ||
    array === undefined ||
    array.constructor.name === 'Object' ||
    array.length === 0
  ) {
    return null
  }

  return array[Math.floor(Math.random() * array.length)]
}

export { randomElementFrom }
