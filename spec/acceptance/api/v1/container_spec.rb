require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Container', type: :acceptance do
  let(:authorization) {
    "Basic #{Base64.encode64("#{identity.uid}:#{identity.oauth_token}")}"
  }

  let(:identity){
    FactoryGirl.create(:identity)
  }

  let(:user){
    identity.user
  }

  header "Authorization", :authorization

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
      let(:id) { container.id }

      context 'that you own' do
        let!(:container) { FactoryGirl.create(:container, user: user) }

        example('Deletes container') do
          expect {
            do_request

            expect(status).to eq(204)
            expect(response_body).to be_empty
          }.to change(Container, :count).by(-1)
        end
      end

      context 'that you do not own' do
        # Let!s
        let!(:container) { FactoryGirl.create(:container) }

        example('is forbidden') do
          expect {
            do_request

            expect(status).to eq(403)
            expect(response_body).to include_json({status: 403, error: "Forbidden"})
          }.not_to change(Container, :count)
        end
      end
    end
  end

  patch 'api/v1/containers/:id' do
    context('With bad ID') do
      let(:id) { -1 }

      example('is Not Found') do
        do_request({container: {name: Faker::Commerce.product_name }})

        expect(status).to eq(404)
        expect(response_body).to include_json({status:404,error:"Not Found"})
      end
    end

    context('with good ID') do
      let(:id) { container.id }

      context 'that you do own' do
        let(:container) { FactoryGirl.create(:container, user: user) }

        example('changes description') do
          attributes = {description: Faker::Hipster.paragraph}
          do_request({container: attributes})

          expect(status).to eq(200)
          expect(response_body).to include_json(attributes)

          container_after = Container.find(container.id)

          expect(container_after.description).to eq(attributes[:description])
        end

        example('changes name') do
          attributes = {name: Faker::Commerce.product_name}
          do_request({container: attributes})

          expect(status).to eq(200)
          expect(response_body).to include_json(attributes)

          container_after = Container.find(container.id)

          expect(container_after.name).to eq(attributes[:name])
        end

        example('changes parent to container you own') do
          new_parent = FactoryGirl.create(:container, user: user)
          attributes = {parent_id: new_parent.id}
          do_request({container: attributes})

          expect(status).to eq(200)
          expect(response_body).to include_json(attributes)

          container_after = Container.find(container.id)

          expect(container_after.parent).to eq(new_parent)
        end

        example('is forbidden to change parent to container you do not own') do
          other_user_parent = FactoryGirl.create(:container)
          attributes = {parent_id: other_user_parent.id}

          expect {
            do_request({container: attributes})

            expect(status).to eq(403)
            expect(response_body).to include_json({status: 403, error: "Forbidden"})
          }.not_to change {
            Container.find(container.id).parent
          }
        end
      end

      context 'that you do not own' do
        let(:container) { FactoryGirl.create(:container) }

        example('is forbbiden') do
          attributes = {description: Faker::Hipster.paragraph}
          do_request({container: attributes})

          expect(status).to eq(403)
          expect(response_body).to include_json({status: 403, error: "Forbidden"})
        end
      end
    end
  end

  post 'api/v1/containers/' do
    example('Container has no name') do
      do_request({container:{ description: Faker::Hipster.paragraph }})

      expect(status).to eq(422)
      expect(response_body).to include_json({name:["can't be blank"]})
    end

    example('Container has a good name') do
      attributes = { name: Faker::Commerce.product_name }
      expect{ do_request({container: attributes}) }.to change(Container, :count).by(1)

      expect(status).to eq(201)
      expect(response_body).to include_json(attributes)
    end
  end

  get 'api/v1/containers' do
    example('Get all containers when there are no containers') do
      do_request

      expect(status).to eq(200)
      expect(response_body).to include_json []
    end

    example('gets only containers you own') do
      # Other user's containers
      FactoryGirl.create_list(:container, 2)
      user_containers = FactoryGirl.create_list(:container, 2, user: user)

      do_request

      expect(status).to eq(200)
      expect(response_body).to include_json(UnorderedArray(*user_containers.map {
          |container| container_json(container)
      }))
    end

  end

  get 'api/v1/containers/:id' do
    context('with bad ID') do
      let(:id) { -1 }

      example('Show Not Found') do
        do_request

        expect(status).to eq(404)
        expect(response_body).to include_json({status:404,error:"Not Found"})
      end
    end

    context('with good ID') do
      let(:id) { container.id }

      context 'that you own' do
        let(:container) { FactoryGirl.create(:container, user: user) }

        example('Shows container') do
          do_request

          expect(status).to eq(200)
          expect(response_body).to include_json(container_json(container))
        end
      end

      context 'that you do not own' do
        let(:container) { FactoryGirl.create(:container) }

        example('is forbidden') do
          do_request

          expect(status).to eq(403)
          expect(response_body).to include_json({status: 403, error: "Forbidden"})
        end
      end
    end
  end

  private
  def container_json(container)
    {description: container.description, name: container.name}
  end
end

