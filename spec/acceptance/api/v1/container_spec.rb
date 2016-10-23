require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Container', type: :acceptance do
  delete 'api/v1/containers/:id' do
    context('With bad ID') do
      let(:id) { -1 }

      example('Show Not Found') do
        do_request

        expect(status).to eq(404)
        expect(response_body).to include_json({status:404,error:"Not Found"})
      end
    end

    context('With good ID') do
      # Let
      let(:id) { container.id }
      # Let!s
      let!(:container) { FactoryGirl.create(:container) }

      example('Deletes container') do
        expect {
        do_request

        expect(status).to eq(204)
        expect(response_body).to be_empty
        }.to change(Container, :count).by(-1)
      end
    end
  end

  patch 'api/v1/containers/:id' do
    context('With bad ID') do
      let(:id) { -1 }

      example('Show Not Found') do
        do_request

        expect(status).to eq(404)
        expect(response_body).to include_json({status:404,error:"Not Found"})
      end
    end

    context('Update with good ID') do
      let(:id) { container.id }
      let(:container) { FactoryGirl.create(:container) }

      example('Container has no name and no user') do
        attributes = { description: Faker::Hipster.paragraph }
        do_request({container: attributes})

        expect(status).to eq(200)
        expect(response_body).to include_json(attributes)
      end

      example('Container has a good name and a good user') do
        user = FactoryGirl.create(:user)
        attributes = { name: Faker::Commerce.product_name, user_id: user.id }
        do_request({container: attributes})

        expect(status).to eq(200)
        expect(response_body).to include_json(attributes)
      end

      example('Container has a good name and a bad user') do
        attributes = { name: Faker::Commerce.product_name, user_id: -1 }
        do_request({container: attributes})

        expect(status).to eq(422)
        expect(response_body).to include_json({user:["can't be blank"]})
      end
    end
  end

  post 'api/v1/containers/' do
    example('Container has no name and no user') do
      do_request({container:{ description: Faker::Hipster.paragraph }})

      expect(status).to eq(422)
      expect(response_body).to include_json({name:["can't be blank"],user:["can't be blank"]})
    end

    example('Container has a good name and a good user') do
      user = FactoryGirl.create(:user)
      attributes = { name: Faker::Commerce.product_name, user_id: user.id }
      expect{ do_request({container: attributes}) }.to change(Container, :count).by(1)

      expect(status).to eq(201)
      expect(response_body).to include_json(attributes)
    end

    example('Container has a good name and a bad user') do
      attributes = { name: Faker::Commerce.product_name, user_id: -1 }
      do_request({container: attributes})

      expect(status).to eq(404)
      expect(response_body).to include_json({status:404,error:"Not Found"})
    end
  end

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
          |container| container_json(container)
      }))
    end

  end

  get 'api/v1/containers/:id' do
    context('With bad ID') do
      let(:id) { -1 }

      example('Show Not Found') do
        do_request

        expect(status).to eq(404)
        expect(response_body).to include_json({status:404,error:"Not Found"})
      end
    end

    context('With good ID') do
      let(:id) { container.id }
      let(:container) { FactoryGirl.create(:container) }

      example('Shows container') do
        do_request

        expect(status).to eq(200)
        expect(response_body).to include_json(container_json(container))
      end
    end
  end

  private
  def container_json(container)
    {description: container.description, name: container.name}
  end
end

