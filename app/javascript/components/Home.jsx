import React, { useState, useRef, useEffect } from 'react'
import axios from 'axios'
import { useMutation } from 'react-query'
import Answer from './Answer'
import loadingGifs from '../loadingGifs.json'

const Home = () => {
  const [query, setQuery] = useState('What is the book Animal Farm about?')
  const answer = useRef(null)
  const answerVisible = useRef(false)
  const textAreaDisabled = useRef(false)
  const textArea = useRef(null)

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
    const question = new FormData(event.currentTarget).get('question')
    askQuestion.mutate(question)
  }

  const handleTextChange = (event) => {
    setQuery(event.target.value)
  }

  const handleMoreQuestion = (event) => {
    setQuery('')
    answerVisible.current = false
    textAreaDisabled.current = false
    textArea.current.focus()
  }

  return (
    <div className="flex flex-col justify-center items-center bg-gray-200 min-h-screen min-w-screen">
      <div className="flex justify-center">
        <div className="w-1/3">
          <img
            className="shadow rounded-lg max-w-full h-auto align-middle border-none"
            src="https://ik.imagekit.io/tirg62dow/animal_farm_gCdMOIAeJ.png?ik-sdk-version=javascript-1.4.3&updatedAt=1673687918305"
          />
        </div>
      </div>
      <h1 className="font-serif font-bold text-2xl my-4">Ask A Book</h1>
      <p className="font-serif text-md font-medium mb-5 text-slate-600 text-justify leading-7 w-1/3">
        This is an experiment in using{' '}
        <span className="font-mono font-medium">AI</span> to make a book's
        content more accessible. The book of choice right now is{' '}
        <span className="font-bold">Animal Farm</span>, by George Orwell. Ask a
        question and <span className="font-mono font-medium">AI</span>'ll answer
        it in real-time:
      </p>
      <form
        onSubmit={handleQuestionSubmit}
        className="flex flex-col items-center w-1/3"
      >
        <textarea
          ref={textArea}
          className="p-4 text-md resize-none form-control w-full rounded-lg shadow-md disabled:shadow-lg font-normal font-mono disabled:bg-slate-300"
          rows="3"
          placeholder="Type in a question"
          value={query}
          onChange={handleTextChange}
          type="text"
          id="question_input"
          name="question"
          disabled={textAreaDisabled.current}
        />
        <div
          className="mt-4 font-serif"
          hidden={false || askQuestion.isLoading || answerVisible.current}
        >
          <button className="bg-black text-md shadow rounded text-white py-2 px-4 font-bold">
            Ask question
          </button>
          <button className="bg-gray-100 text-md shadow rounded px-4 py-2 ml-2 font-bold">
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
            src={loadingGifs[Math.floor(Math.random() * loadingGifs.length)]}
          />
          <p className="font-serif font-bold text-base">
            {loadingText[Math.floor(Math.random() * loadingText.length)]}
          </p>
        </div>
      ) : (
        ''
      )}
    </div>
  )
}

export default Home
