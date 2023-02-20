### The Journey

TLDR; Everything was eventually figured out and implemented as expected.

#### Doing the known

A few things were unknowns and I was sure would take time.
In order to keep up the motivation and to progress, I started doing things that I knew wont take much time.
I set up the basic rails applications, installed all required gems, env varaibles etc,
By end of this leg, I was hyped to start with the more harder work.

#### Attempting the unknown

I decided to use text from any freely available book. Google gave me "Animal Farm" by George Orwell.

I used [pdf-reader](https://github.com/yob/pdf-reader) gem to achieve the same.
I ran a small script to read all pages in the memory.
The data was not cleaned. Contained white spaces (because of page formatting).
Cleaned the pages to get only text from the pages.
Intially I did this in order to just remove unecessary data.
Later I realized, it was good that I cleaned the data, as the number of tokens getting generated per section were exceeding 500.

Tokenization was the hardest step.
There was no ruby implementation that implemented `GPT2TokenizerFast` python package.
After a while researching, I was able to find a technique called interop (calling python code from ruby)
There was this gem, `PyCall` through which we can import python modules in a ruby runtime environment.
This interop was tested.
Integrating was easy and I was able to tokenize the page contents and store the token count in a csv file.

The script utilized OpenAI embeddings API to generate the embeddings for each page and those were also stored in a csv file.

#### Climbing the cliff

Challenge - Understanding the `Answer Generation` logic.
The reference repository did some help but I could not wrap my head around it in one go.

I follow the creator on twitter and remember him posting about the same project.
Digging deeper I watched the youtube session which provided foundation on how things are working.
Understood a few terminologies from the open AI documentation.
It took several re reads and REPL sessions to understand what was happening.

#### Getting things done

Now I was all set to write the rails application & ruby equivalent of the `Answer Generation` logic.
I wrote the `AnswerGenerationService`. It didn't work in the first go, but a minor adjustments made it work.
With this service in place, 80% of the problem was solved.
Now I had to just create apis, connect apis with frontend and basic working version of the app was ready.

#### The final polish

Working iteratively on the frontend making it better with every passing minute.
