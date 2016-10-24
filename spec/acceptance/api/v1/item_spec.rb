require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Item', type: :acceptance do
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

  delete 'api/v1/items/:id' do
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
      let(:id) { item.id }

      context('That you own') do
        let!(:item) { FactoryGirl.create(:item, container: container) }
        let(:container) { FactoryGirl.create(:container, user: user)}

        example('Deletes item') do
          expect {
            do_request

            expect(status).to eq(204)
            expect(response_body).to be_empty
          }.to change(Item, :count).by(-1)
        end

      end

      context('That you do not own') do
        # Let!s
        let!(:item) { FactoryGirl.create(:item) }

        example('Does not delete item') do
          expect {
            do_request

            expect(status).to eq(403)
            expect(response_body).to include_json({status:403,error:"Forbidden"})
          }.not_to change(Item, :count)
        end
      end

    end
  end

  patch 'api/v1/items/:id' do
    context('With bad ID') do
      let(:id) { -1 }

      example('Show Not Found') do
        do_request

        expect(status).to eq(404)
        expect(response_body).to include_json({status:404,error:"Not Found"})
      end
    end

    context('Update with good ID') do
      let(:id) { item.id }

      context('That you own') do
        let(:item) { FactoryGirl.create(:item, container: container) }
        let(:container) { FactoryGirl.create(:container, user: user)}

        example('Item has no name and no user') do
          attributes = { description: Faker::Hipster.paragraph }
          do_request({item: attributes})

          expect(status).to eq(200)
          expect(response_body).to include_json(attributes)
        end

        example('Item has a good name and a good container') do
          container = FactoryGirl.create(:container)
          attributes = { name: Faker::Commerce.product_name, container_id: container.id }

          do_request({item: attributes})

          expect(status).to eq(200)
          expect(response_body).to include_json(attributes)

          item_after = Item.find(item.id)

          expect(item_after.name).to eq(attributes[:name])
          expect(item_after.container).to eq(container)
        end
      end

      context('That you do not own') do
        let(:item) { FactoryGirl.create(:item) }

        example("is forbidden") do
          attributes = FactoryGirl.attributes_for(:item)
          do_request({item: attributes})

          expect(status).to eq(403)
          expect(response_body).to include_json({status: 403, error: 'Forbidden'})
        end
      end
    end
  end

  post 'api/v1/items/' do
    example('Item has no container is forbidden because container is needed to find owning user') do
      do_request({item:{ description: Faker::Hipster.paragraph }})

      expect(status).to eq(403)
      expect(response_body).to include_json({status: 403, error: "Forbidden"})
    end

    example('Item has a good name and a bad container') do
      attributes = { name: Faker::Commerce.product_name, container_id: -1 }
      do_request({item: attributes})

      expect(status).to eq(404)
      expect(response_body).to include_json({status:404,error:"Not Found"})
    end

    context 'with container that you own' do
      example('Item has valid attributes') do
        container = FactoryGirl.create(:container, user: user)
        attributes = FactoryGirl.attributes_for(:item, container_id: container.id)

        expect {
          do_request({item: attributes})

          expect(status).to eq(201)
          expect(response_body).to include_json(attributes)
        }.to change(Item, :count).by(1)
      end
    end

    context 'with container that you do not own' do
      example('Item has valid attributes is forbidden') do
        container = FactoryGirl.create(:container)
        attributes = FactoryGirl.attributes_for(:item, container_id: container.id)

        expect {
          do_request({item: attributes})

          expect(status).to eq(403)
          expect(response_body).to include_json({status: 403, error: "Forbidden"})
        }.not_to change(Item, :count)
      end
    end
  end

  get 'api/v1/items' do
    example('Get all items when there are no items') do
      do_request

      expect(status).to eq(200)
      expect(response_body).to include_json []
    end

    example('Get all items shows items you own') do
      FactoryGirl.create_list(:item, 2)
      user_container = FactoryGirl.create(:container, user: user)
      user_items = FactoryGirl.create_list(:item, 2, container: user_container)

      do_request

      expect(status).to eq(200)
      expect(response_body).to include_json(UnorderedArray(*user_items.map {
          |item| item_json(item)
      }))
    end
  end

  get 'api/v1/items/:id' do
    context('With bad ID') do
      let(:id) { -1 }

      example('Show Not Found') do
        do_request

        expect(status).to eq(404)
        expect(response_body).to include_json({status:404,error:"Not Found"})
      end
    end

    context('With good ID') do
      let(:id) { item.id }

      context('That you own') do
        let(:item) { FactoryGirl.create(:item, container: container) }
        let(:container) { FactoryGirl.create(:container, user: user)}
        example('Shows item') do
          do_request

          expect(status).to eq(200)
          expect(response_body).to include_json(item_json(item))
        end
      end

      context('That you do not own') do
        let(:item) { FactoryGirl.create(:item) }
        example('Shows item') do
          do_request

          expect(status).to eq(403)
          expect(response_body).to include_json({status:403,error:"Forbidden"})
        end
      end



    end
  end

  private
  def item_json(item)
    {description: item.description, name: item.name}
  end
end

