import React from "react";

import { RouterProvider } from "react-router-dom";
import { createBrowserRouter } from 'react-router-dom'
import Home from '../components/Home'

const App = () => {
  const router = createBrowserRouter([{
    path: "/",
    element: <Home />
  }])

  return(
  <React.StrictMode>
    <RouterProvider router={router}/>
  </React.StrictMode>)

}

export default App;
