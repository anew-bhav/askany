import React, { useState, useRef, useEffect } from 'react'
import axios from 'axios'
import { useMutation, useQuery } from 'react-query'
import Answer from './Answer'
import loadingGifs from '../loadingGifs.json'
import { randomElementFrom } from '../utils/helpers'

const Home = () => {
  const topQuestions = useQuery(['top-questions'], () => {
    return axios.get('/api/v1/top')
  })

  const [query, setQuery] = useState('What is the book Animal Farm about?')
  const [topQuestionsList, setTopQuestionsList] = useState([])
  const answer = useRef(null)
  const answerVisible = useRef(false)
  const textAreaDisabled = useRef(false)
  const textArea = useRef(null)
  const form = useRef(null)

  const loadingText = ['Hmm...', 'I know that...', 'Noice...']

  const askQuestion = useMutation({
    mutationFn: (question) => {
      return axios.post('/api/v1/ask', { question: { query: question } })
    },
    onSuccess: (data) => {
      answer.current = data.data.answer
      answerVisible.current = true
    },
  })

  const handleQuestionSubmit = (event) => {
    event.preventDefault()
    textAreaDisabled.current = true
    answerVisible.current = true
    const question = new FormData(form.current).get('question')
    askQuestion.mutate(question)
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
    setQuery(randomElementFrom(topQuestionsList))
  }

  useEffect(() => {
    if (topQuestions.isLoading === false) {
      setTopQuestionsList(topQuestions.data.data.data.top_questions)
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
              className="bg-black hover:ring-2 hover:ring-stone-400 disabled:bg-gray-600 disabled:text-gray-100 disabled:shadow-none basis-1/2 w-full sm:w-auto text-sm sm:text-md shadow-lg rounded-lg text-white px-4 py-2 font-bold"
            >
              Ask question
            </button>
            <button
              className="bg-gray-100 hover:ring-2 hover:ring-stone-300 disabled:bg-gray-300 disabled:text-gray-100 disabled:shadow-none basis-1/2 w-full sm:w-auto text-sm sm:text-md shadow-lg rounded-lg px-4 py-2 font-bold"
              onClick={handleTopQuestion}
              disabled={topQuestions.isLoading}
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
        {askQuestion.isLoading ? (
          <div className="flex mt-4 gap-2 flex-col items-center justify-center">
            <img
              alt="Loading"
              className="w-auto h-32 bg-transparent rounded"
              src={randomElementFrom(loadingGifs)}
            />
            <p className="font-serif font-bold text-base">
              {randomElementFrom(loadingText)}
            </p>
          </div>
        ) : (
          ''
        )}
      </div>
    </div>
  )
}

export default Home
