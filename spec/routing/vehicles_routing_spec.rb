require 'rails_helper'

describe 'routing to vehicles' do
  it 'routes / to vehicles#index' do
    expect(get: '/').to route_to(
      controller: 'vehicles',
      action: 'index'
    )
  end

  it 'routes /parking to vehicles#create' do
    expect(post: '/parking').to route_to(
      controller: 'vehicles',
      action: 'create'
    )
  end

  it 'routes /parking/XGD-123 to vehicles#show' do
    expect(get: '/parking/:plate').not_to route_to(
      controller: 'vehicles',
      action: 'show'
    )
  end

  it 'routes /parking/new to vehicles#pay' do
    expect(put: '/parking/:code/pay').to route_to(
      controller: 'vehicles',
      action: 'pay',
      code: ':code'
    )
  end

  it 'routes /parking/new to vehicles#out' do
    expect(put: '/parking/:code/out').to route_to(
      controller: 'vehicles',
      action: 'out',
      code: ':code'
    )
  end
end
