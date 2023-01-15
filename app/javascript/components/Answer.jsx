import React from 'react'

const Answer = ({ answer, questionHandler }) => {
  return (
    <div className="flex mt-4 flex-col justify-center text-justify items-center w-1/3">
      <p className="font-bold font-serif text-lg ">
        Answer:{'\n'}
        <span className="font-light font-serif text-md">{answer.current}</span>
      </p>
      <button
        onClick={questionHandler}
        className="bg-black text-md shadow rounded mt-4 text-white py-2 px-4 font-bold"
      >
        Ask one more question
      </button>
    </div>
  )
}

export default Answer
