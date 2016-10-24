require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'User', type: :acceptance do
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

  get 'api/v1/users' do
    example('Get all users when there are no users') do
      do_request

      expect(status).to eq(200)
      expect(response_body).to include_json []
    end

    example('Get all users -- only shows yourself') do
      FactoryGirl.create(:user)

      do_request

      expect(status).to eq(200)
      expect(response_body).to include_json([
         user_json(user)
      ])
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

      context('With your own ID') do
        example('Shows user') do
          do_request

          expect(status).to eq(200)
          expect(response_body).to include_json(user_json(user))
        end
      end

      context('With someone elses ID') do
        let(:user) { FactoryGirl.create(:user) }

        example('Is forbidden') do
          do_request

          expect(status).to eq(403)
          expect(response_body).to include_json({status:403,error:"Forbidden"})
        end
      end
    end
  end
  private
  def user_json(user)
    {name: user.name}
  end
end

