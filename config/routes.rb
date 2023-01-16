Rails.application.routes.draw do
  root "homepage#index"

  namespace "api", defaults: { format: "json" } do
    namespace "v1" do
      post "ask", to: "questions#ask_question"
      get "top", to: "questions#top_questions"
    end
  end

  match "*unmatched", to: "api#not_found_method", via: :all
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
