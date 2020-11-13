Rails.application.routes.draw do
  get '/', to: 'home#index'

  post 'parking',        to: 'vehicles#create'
  get  'parking/:plate', to: 'vehicles#show'
end
