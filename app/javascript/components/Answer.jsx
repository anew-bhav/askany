import React from 'react'

const Answer = ({ answer, questionHandler }) => {
  return (
    <div className="flex flex-col justify-center text-justify items-center p-2 w-2/3">
      <p className="font-bold font-serif text-md">
        Answer:{' '}
        <span className="font-normal font-serif text-sm sm:text-md">
          {answer.current}
        </span>
      </p>
      <button
        onClick={questionHandler}
        className="bg-black w-full md:w-1/2 text-sm sm:text-md shadow rounded mt-4 text-white py-2 px-4 font-bold"
      >
        Ask one more question
      </button>
    </div>
  )
}

export default Answer
