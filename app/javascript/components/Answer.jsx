import React, { useRef, useEffect, useState } from 'react'
import Typed from 'typed.js'

const Answer = ({ answer, questionHandler }) => {
  const element = useRef(null)
  const typed = useRef(null)
  const [typingComplete, setTypingComplete] = useState(null)

  useEffect(() => {
    const options = {
      strings: [answer.current],
      typeSpeed: 20,
      showCursor: false,
      onBegin: () => setTypingComplete(false),
      onComplete: () => setTypingComplete(true),
    }

    typed.current = new Typed(element.current, options)

    return () => {
      typed.current.destroy()
    }
  }, [])

  return (
    <div className="flex flex-col justify-center text-justify items-center p-2 w-2/3">
      <p className="font-bold font-serif text-md">
        Answer:{' '}
        <span
          ref={element}
          className="font-normal font-serif text-sm sm:text-md"
        >
          {answer.current}
        </span>
      </p>
      <button
        onClick={questionHandler}
        disabled={!typingComplete}
        className="bg-black w-full hover:ring-2 hover:ring-stone-400 disabled:hover:ring-0 disabled:bg-gray-600 disabled:text-gray-100 disabled:shadow-none md:w-1/2 text-sm sm:text-md shadow-lg rounded-lg mt-4 text-white py-2 px-4 font-bold"
      >
        Ask another question
      </button>
    </div>
  )
}

export default Answer
