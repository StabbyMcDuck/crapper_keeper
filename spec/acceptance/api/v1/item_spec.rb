require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Item', type: :acceptance do
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
      # Let!s
      let!(:item) { FactoryGirl.create(:item) }

      example('Deletes item') do
        expect {
        do_request

        expect(status).to eq(204)
        expect(response_body).to be_empty
        }.to change(Item, :count).by(-1)
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
      let(:item) { FactoryGirl.create(:item) }

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
      end

      example('Item has a good name and a bad container') do
        attributes = { name: Faker::Commerce.product_name, container_id: -1 }
        do_request({item: attributes})

        expect(status).to eq(422)
        expect(response_body).to include_json({container:["can't be blank"]})
      end
    end
  end

  post 'api/v1/items/' do
    example('Item has no name and no container') do
      do_request({item:{ description: Faker::Hipster.paragraph }})

      expect(status).to eq(422)
      expect(response_body).to include_json({"name"=>["can't be blank"],
                                             "container"=>["can't be blank"],
                                             "count"=>["can't be blank", "is not a number"],
                                             "notification_style"=>["is not included in the list"]})
    end

    example('Item has valid attributes') do
      container = FactoryGirl.create(:container)
      attributes = FactoryGirl.attributes_for(:item, container_id: container.id)
      expect{ do_request({item: attributes}) }.to change(Item, :count).by(1)

      expect(status).to eq(201)
      expect(response_body).to include_json(attributes)
    end

    example('Item has a good name and a bad container') do
      attributes = { name: Faker::Commerce.product_name, container_id: -1 }
      do_request({item: attributes})

      expect(status).to eq(404)
      expect(response_body).to include_json({status:404,error:"Not Found"})
    end
  end

  get 'api/v1/items' do
    example('Get all items when there are no items') do
      do_request

      expect(status).to eq(200)
      expect(response_body).to include_json []
    end

    example('Get all items') do
      items = FactoryGirl.create_list(:item, 2)

      do_request

      expect(status).to eq(200)
      expect(response_body).to include_json(UnorderedArray(*items.map {
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
      let(:item) { FactoryGirl.create(:item) }

      example('Shows item') do
        do_request

        expect(status).to eq(200)
        expect(response_body).to include_json(item_json(item))
      end
    end
  end

  private
  def item_json(item)
    {description: item.description, name: item.name}
  end
end

