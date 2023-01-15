## Notes

### Background
Before attempting this project, I didn't had any prior knowledge on how language models worked.
I did use chatGPT to answer a few questions for me, but didn't built a solution from ground up.
The problem shared was hard at first and eventually became easier.
There were parts which were unknowns and a few which I knew I would be able to complete easily.

### Path Taken

#### Doing the known
As mentioned before - a few things were unknowns and I was sure would take time.
In order to keep up the motivation and to progress, I started doing things that I knew wont take much time.
I set up the basic rails applications, installed all required gems, env varaibles etc,
By end of this leg, I was hyped to start with the more harder work.

#### Attempting the unknown
I did not had the manuscript of the Minimalist Entreprenuer.
I decided to use text from any freely available book. Google gave me "Animal Farm" by George Orwell.

Ruby already has a gem to read pdf pages. First hurdle crossed.
I ran a small script to read all pages in an array.
The data was not cleaned. Contained white spaces (because of page formatting).
Cleaned the pages to get only text from the pages, nothing else.

Tokenization was the hardest step.
There was no ruby implementation of `GPT2TokenizerFast` python package.
I did research for quite to no avail.
After a while, I was able to find a technique called interop (calling python code from ruby)
There was this gem, `PyCall` through which we can import python modules in a ruby runtime environment.
Integrating was easy and I was able to create embeddings of the pages and store them in a CSV.

#### Climbing the cliff
I was able to complete the first part of the task, creating a script in Ruby to generate embeddings and page data.
Next cliff infront of me was to understand the answer creation logic.
The reference repository provided some help but I could not wrap my head around it.
I follow Sahil on twitter and remember him posting about the same porject.
Digging deeper I watch the youtube session which provided foundation on things are working.
It took several re reads of the python code base to understand what was happening.
I have a rusty python, and the syntactic sugars here and there, troubled a lot.
Eventually I fired up an online jupyter notebook to visualize what all was happening.
I as wrote each step - things became more clear.
I could see a distant light approching me.

#### Getting things done
Now I was all set to write the rails && ruby equivalent.
I was in complete flow and I was able to write the `AnswerGenerationService` in no time.
With this service in place, 80% of the problem was solved.
Now I had to just create apis, connect apis with frontend and basic working version of the app was ready.

#### The final polish
Working iteratively on the frontend making it better with every passing hour.
All the known issues have been fixed now.