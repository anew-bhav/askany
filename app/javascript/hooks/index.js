import axios from 'axios'

import CONSTANTS from '../constants'
import { useMutation, useQuery } from 'react-query'

export const useTopQuestions = (data) => {
  return useQuery(['top-questions'], () => {
    return axios.get(CONSTANTS.routes.top_questions, {
      params: { question: { book_id: data.book_id } },
    })
  })
}

export const useAskQuestion = () => {
  return useMutation({
    mutationFn: (data) => {
      return axios.post(CONSTANTS.routes.ask_question, {
        question: { query: data.query, book_id: data.book_id },
      })
    },
  })
}