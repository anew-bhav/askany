import React from 'react'
import { RouterProvider } from 'react-router-dom'
import { createBrowserRouter } from 'react-router-dom'
import { QueryClient, QueryClientProvider } from 'react-query'

import Home from '../components/Home'

const App = () => {
  const router = createBrowserRouter([
    {
      path: '/askabook',
      element: <Home />,
    },
  ])

  const queryClient = new QueryClient({})

  return (
    <QueryClientProvider client={queryClient}>
      <React.StrictMode>
        <RouterProvider router={router} />
      </React.StrictMode>
    </QueryClientProvider>
  )
}

export default App
