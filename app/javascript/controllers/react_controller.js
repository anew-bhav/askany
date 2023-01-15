import { Controller } from '@hotwired/stimulus'
import * as React from 'react'
import * as ReactDOM from 'react-dom/client'

import App from '../components/App'

// Connects to data-controller="react"
export default class extends Controller {
  connect() {
    const root = ReactDOM.createRoot(document.getElementById('root'))
    root.render(<App />)
  }
}
