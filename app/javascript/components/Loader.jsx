import React from 'react'

import loadingGifs from '../loadingGifs.json'
import { getRandomElement } from '../utils/helpers'

const Loader = () => {
  const loaderText = ['Hmm...', 'I know that...', 'Noice...']

  return (
    <div className="flex mt-4 gap-2 flex-col items-center justify-center">
      <img
        alt="Loading"
        className="w-auto h-32 bg-transparent rounded"
        src={ getRandomElement(loadingGifs)}
      />
      <p className="font-serif font-bold text-base">
        { getRandomElement(loaderText)}
      </p>
    </div>
  )
}

export default Loader
