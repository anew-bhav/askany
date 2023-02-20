### Background
Before attempting this project, I didn't had any prior knowledge on how language models worked.
I did use chatGPT to answer a few questions for me, but didn't built a solution from ground up.
The problem shared was hard at first and eventually became easier.
There were parts which were unknowns and a few which I knew I would be able to complete easily.

Demo is live [here](https://anewbhav.dev/askabook)

### Goals
The goal of this project is to enable user to upload any pdf and create answering bot out of it.

### Current Status
The foundation of the project is done. We are able to take in a pdf file, and expose APIs to ask questions to it.

### Next Steps
Currently users are able to ask questions from only one book.
Next steps would be :
1. ability for users to upload a book of choice.
2. ability configure the prompt (as owner of the book)
3. ability for platform users list of books uploaded by self or other users
4. ability to navigate to page of a particular book and ask questions

### v0
I took inspiration from [askmybook](https://github.com/slavingia/askmybook) and built the same using Ruby.

The v0, as it was aiming to exactly replicate what _askmybook_ did, the architecture was dependent on two csv files namely `book_embeddings.csv` and `book_sections.csv` .
1. `scripts/book.pdf` and `scripts/create_embeddings.rb`, were used to generate `./book_embeddings.csv` and `./book_sections.csv`
2. To run this script on any machine, it was required, to have python and related python packages like `GPT2TokenizerFast` to be installed already. script could be run using
   ```bash
   ruby scripts/create_embeddings.rb
   ```
3. The `app/services/answer_generation.rb` handled in finding the most relevant sections, embedding the context in the prompt, and use the prompt to answer the query. PS: This service is now updated to accomodate v1.
More on v0 [journey](JOURNEY.md)

### v0.1
v0 worked but it was slow.
Primary reason - We worked with large CSV and the logic was based on reading the CSV for each request.
We figured out that CSV files were not needed.
We moved away from that dependency and stored the embeddings as JSON in the database.

We also figured out, the interop with python was not required at all.
We removed it completely.
We are now a pure ruby implementation.