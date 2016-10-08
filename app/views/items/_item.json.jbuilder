json.extract! item, :id, :name, :description, :container_id, :count, :last_used_at, :created_at, :updated_at
json.url item_url(item, format: :json)
