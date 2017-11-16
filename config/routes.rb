Rails.application.routes.draw do
  get '/pub/:user/:channel/:message', to: 'application#pub'
  get '/sub', to: 'application#sub'
end
