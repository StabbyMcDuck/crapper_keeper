require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Container', type: :acceptance do
  get 'api/v1/containers' do
    example('Get all containers when there are no containers') do
      do_request

      expect(status).to eq(200)
      expect(response_body).to include_json []
    end

    example('Get all containers') do
      containers = FactoryGirl.create_list(:container, 2)

      do_request

      expect(status).to eq(200)
      expect(response_body).to include_json(UnorderedArray(*containers.map {
          |container| container_json(user)
      }))
    end

  end

  get 'api/v1/containers/:id' do
    let(:id) { -1 }

    example('Show bad ID') do
      do_request

      expect(status).to eq(404)
      expect(response_body).to eq('foo')
    end


  end
  private
  def user_json(user)
    {uid: user.uid}
  end
end

