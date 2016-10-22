require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'User', type: :acceptance do
  get 'api/v1/users' do
    example('Get all users when there are no users') do
      do_request

      expect(status).to eq(200)
      expect(response_body).to include_json []
    end

    example('Get all users') do
      users = FactoryGirl.create_list(:user, 2)

      do_request

      expect(status).to eq(200)
      expect(response_body).to include_json(UnorderedArray(*users.map {
          |user| user_json(user)
      }))
    end

  end

  get 'api/v1/users/:id' do
    context('With bad ID') do
      let(:id) { -1 }

      example('Show Not Found') do
        do_request

        expect(status).to eq(404)
        expect(response_body).to include_json({status:404,error:"Not Found"})
      end
    end

    context('With good ID') do
      let(:id) { user.id }
      let(:user) { FactoryGirl.create(:user) }

      example('Shows user') do
        do_request

        expect(status).to eq(200)
        expect(response_body).to include_json(user_json(user))
      end
    end
  end
  private
  def user_json(user)
    {uid: user.uid, name: user.name}
  end
end

