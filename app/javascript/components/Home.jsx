import React from 'react'

const Home = () => {
  return (
    <div className='flex flex-col justify-center items-center bg-gray-200 min-h-screen min-w-screen'>
      <div className='flex justify-center'>
        <div className='w-1/3'>
        <img className="shadow rounded-lg max-w-full h-auto align-middle border-none" src='https://ik.imagekit.io/tirg62dow/animal_farm_gCdMOIAeJ.png?ik-sdk-version=javascript-1.4.3&updatedAt=1673687918305'/>
        </div>
      </div>
      <h1 className='font-serif font-bold text-2xl my-4'>Ask A Book</h1>
      <p className='font-serif text-lg font-light mb-5 text-slate-600 leading-7'>
        This is an experiment in using <span className='font-mono font-medium'>AI</span> to make a book's content more accessible. <br/>
        The book of choice right now is <span className='font-bold'>Animal Farm</span>, by George Orwell. <br/>
        Ask a question and <span className='font-mono font-medium'>AI</span>'ll answer it in real-time:
      </p>
      <form action="#" className='flex flex-col items-center'>
        <label htmlFor="question_input">
          <textarea className="p-4 rounded-lg shadow font-light font-mono" rows="4" cols="60" placeholder="Type in a question" value="What is the book Animal Farm about?" type="text" id="question_input" name="question"/>
        </label>
        <div className='mt-4 font-serif'>
          <button className='bg-black shadow rounded text-white py-2 px-4 font-bold'>Ask question</button>
          <button className='bg-gray-100 shadow rounded px-4 py-2 ml-2 font-bold'>I'm feeling Lucky</button>
        </div>
      </form>
    </div>
      )
}

export default Home