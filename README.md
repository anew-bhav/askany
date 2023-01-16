## Notes

### Background
Before attempting this project, I didn't had any prior knowledge on how language models worked.
I did use chatGPT to answer a few questions for me, but didn't built a solution from ground up.
The problem shared was hard at first and eventually became easier.
There were parts which were unknowns and a few which I knew I would be able to complete easily.

### About embedding generation script
1. `scripts/book.pdf` and `scripts/create_embeddings.rb` are used to generate `./book_embeddings.csv` and `./book_sections.csv`
2. To run this script on any machine, it is required, to have python and related python packages like `GPT2TokenizerFast` to be installed already. script could be run using
   ```bash
   ruby scripts/create_embeddings.rb
   ```
3. The `app/services/answer_generation.rb` handles in finding the most relevant sections, embedding the context in the prompt, and use the prompt to answer the query.

### The Journey

TLDR; Everything was eventually figured out and implemented as expected.

#### Doing the known
As mentioned before - a few things were unknowns and I was sure would take time.
In order to keep up the motivation and to progress, I started doing things that I knew wont take much time.
I set up the basic rails applications, installed all required gems, env varaibles etc,
By end of this leg, I was hyped to start with the more harder work.

#### Attempting the unknown
I donot have the manuscript of the Minimalist Entreprenuer.
I decided to use text from any freely available book. Google gave me "Animal Farm" by George Orwell.

I used [pdf-reader](https://github.com/yob/pdf-reader) gem to achieve the same.
I ran a small script to read all pages in the memory.
The data was not cleaned. Contained white spaces (because of page formatting).
Cleaned the pages to get only text from the pages.
Intially I did this in order to just remove unecessary data.
Later down  the line I realized, it was good that I cleaned the data, as the number of tokens getting generated per section were exceeding 500.

Tokenization was the hardest step.
There was no ruby implementation that implemented `GPT2TokenizerFast` python package.
After a while researching, I was able to find a technique called interop (calling python code from ruby)
There was this gem, `PyCall` through which we can import python modules in a ruby runtime environment.
This interop was tested.
Integrating was easy and I was able to create embeddings of the pages and store them in a CSV.

#### Climbing the cliff
I was able to complete the first part of the task, creating a script in Ruby to generate embeddings and page data.

Next cliff infront of me was to understand the `Answer Generation` logic.
The reference repository provided in the task did some help but I could not wrap my head around it in one go.

I follow Sahil on twitter and remember him posting about the same porject.
Digging deeper I watched the youtube session which provided foundation on things are working.
Understood a few terminologies from the open AI documentation.
It took several re reads of the python code base to understand what was happening.
Eventually I fired up an online jupyter notebook to visualize what all was happening.
I as wrote each step - things became more clear.
I could see a distant light approching me.

#### Getting things done
Now I was all set to write the rails application && ruby equivalent of the `Answer Generation` logic.
I wrote the `AnswerGenerationService`. It didn't work in the first go, but a minor adjustments made it work.
With this service in place, 80% of the problem was solved.
Now I had to just create apis, connect apis with frontend and basic working version of the app was ready.

#### The final polish
Working iteratively on the frontend making it better with every passing minute.

### Future scope
- create a UI where the different parameters could be tweaked and response can be experimented.
- create a generalized ask_a_book service,  where user uploads a pdf and can talk to it.
- show loading emojis based on question's mood.
- share general fact about the book after each question is answered.
- store embeddings in a specialized databases to reduce request times, [pinecone](https://app.pinecone.io) is something that has been recommended by open ai.
- find similarities between two questions that would eventually land the same answer, we can detect this case and optimize