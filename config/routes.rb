Rails.application.routes.draw do
  root 'homepage#index'

  namespace 'api' do
    namespace 'v1' do
      post 'ask', to: "questions#ask_question"
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
