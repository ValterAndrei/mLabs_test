Rails.application.routes.draw do
  # TODO: Refactor routes to correct resource names
  get    '/',                 to: 'vehicles#index'
  post   'parking',           to: 'vehicles#create'
  get    'parking/:plate',    to: 'vehicles#show'
  delete 'parking/:plate',    to: 'vehicles#destroy'
  put    'parking/:code/pay', to: 'vehicles#pay'
  put    'parking/:code/out', to: 'vehicles#out'

  # XXX: estendendo controller para tratar de blob (direct_upload)
  post "/rails/active_storage/direct_uploads" => "direct_uploads#create"

end
