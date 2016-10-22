json.extract! container, :id, :name, :description, :parent_id, :user_id, :created_at, :updated_at
json.url container_url(container, format: :json)