import React, { useState, useRef, useEffect } from 'react'

import { getRandomElement } from '../utils/helpers'
import { useAskQuestion, useTopQuestions } from '../hooks'

import CONSTANTS from '../constants'
import Answer from './Answer'
import Loader from './Loader'

const Home = () => {
  const topQuestions = useTopQuestions({ book_id: 1 })
  const askQuestion = useAskQuestion()

  const [query, setQuery] = useState(CONSTANTS.initialQuestion)

  const [topQuestionsList, setTopQuestionsList] = useState([])

  const answer = useRef(null)
  const answerVisible = useRef(false)

  const textArea = useRef(null)
  const textAreaDisabled = useRef(false)

  const form = useRef(null)

  const handleQuestionSubmit = (event) => {
    event.preventDefault()
    textAreaDisabled.current = true
    answerVisible.current = true
    const question = new FormData(form.current).get('question')
    askQuestion.mutate(
      { query: question, book_id: 1 },
      {
        onSuccess: (data) => {
          answer.current = data.data.answer
          answerVisible.current = true
        },
      }
    )
  }

  const handleTextChange = (event) => {
    setQuery(event.target.value)
  }

  const handleMoreQuestion = (event) => {
    event.preventDefault()
    setQuery('')
    answerVisible.current = false
    textAreaDisabled.current = false
    textArea.current.focus()
  }

  const handleTopQuestion = (event) => {
    event.preventDefault()
    setQuery(getRandomElement(topQuestionsList))
  }

  useEffect(() => {
    if (topQuestions.isLoading === false) {
      setTopQuestionsList(topQuestions?.data?.data?.data?.top_questions)
    }
  }, [topQuestions.isLoading])

  return (
    <div className=" bg-gray-200">
      <div className="flex flex-col justify-center items-center min-h-screen mx-auto max-w-xl lg:max-w-3xl">
        <div className="flex justify-center">
          <div className="w-1/2 p-4">
            <img
              className="shadow rounded-lg max-w-full h-auto align-middle border-none"
              src="https://ik.imagekit.io/tirg62dow/animal_farm_gCdMOIAeJ.png?ik-sdk-version=javascript-1.4.3&updatedAt=1673687918305"
            />
          </div>
        </div>
        <h1 className="font-serif font-bold text-2xl">Ask A Book</h1>
        <p className="font-serif text-sm md:text-md font-light text-slate-600 text-justify leading-5 p-2 w-2/3">
          This is an experiment in using{' '}
          <span className="font-mono font-medium">AI</span> to make a book's
          content more accessible. The book of choice right now is{' '}
          <span className="font-bold">Animal Farm</span>, by George Orwell. Ask
          a question and <span className="font-mono font-medium">AI</span>'ll
          answer it in real-time:
        </p>
        <form ref={form} className="flex flex-col items-center w-2/3">
          <textarea
            ref={textArea}
            className="p-2 text-sm md:text-md resize-y md:resize-none form-control w-full sm:h-auto h-24 rounded-lg shadow-md disabled:shadow-lg font-normal font-mono disabled:bg-slate-300"
            rows="4"
            placeholder="Type in a question"
            value={query}
            onChange={handleTextChange}
            type="text"
            id="question_input"
            name="question"
            disabled={textAreaDisabled.current}
          />
          <div
            className={`${
              false || askQuestion.isLoading || answerVisible.current
                ? 'hidden'
                : ''
            } mt-4 font-serif flex flex-col sm:flex-row gap-2 min-w-full justify-center items-center`}
          >
            <button
              onClick={handleQuestionSubmit}
              disabled={query.length === 0}
              className="bg-black hover:ring-2 hover:ring-stone-400 disabled:hover:ring-0 disabled:bg-gray-600 disabled:text-gray-100 disabled:shadow-none basis-1/2 w-full sm:w-auto text-sm sm:text-md shadow-lg rounded-lg text-white px-4 py-2 font-bold"
            >
              Ask question
            </button>
            <button
              className="bg-gray-100 hover:ring-2 hover:ring-stone-300 disabled:hover:ring-0 disabled:bg-gray-300 disabled:text-gray-100 disabled:shadow-none basis-1/2 w-full sm:w-auto text-sm sm:text-md shadow-lg rounded-lg px-4 py-2 font-bold"
              onClick={handleTopQuestion}
              disabled={topQuestions.isLoading || topQuestionsList.length === 0}
            >
              I'm feeling Lucky
            </button>
          </div>
        </form>
        {answerVisible.current && !askQuestion.isLoading ? (
          <Answer answer={answer} questionHandler={handleMoreQuestion} />
        ) : (
          ''
        )}
        {askQuestion.isLoading ? <Loader /> : ''}
      </div>
    </div>
  )
}

export default Home
