import React from 'react'
import { RouterProvider } from 'react-router-dom'
import { createBrowserRouter } from 'react-router-dom'
import { QueryClient, QueryClientProvider } from 'react-query'
import { ReactQueryDevtools } from 'react-query/devtools'

import Home from '../components/Home'

const App = () => {
  const router = createBrowserRouter([
    {
      path: '/',
      element: <Home />,
    },
  ])

  const queryClient = new QueryClient({})

  return (
    <QueryClientProvider client={queryClient}>
      <React.StrictMode>
        <RouterProvider router={router} />
      </React.StrictMode>
      <ReactQueryDevtools />
    </QueryClientProvider>
  )
}

export default App
