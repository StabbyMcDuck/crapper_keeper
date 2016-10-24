json.extract! item, :id, :name, :description, :count, :last_used_at, :notification_style, :notification_frequencies, :container_id, :created_at, :updated_at
json.url item_url(item, format: :json)