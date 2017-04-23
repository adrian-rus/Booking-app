json.extract! profile, :id, :firstname, :lastname, :address, :avatar, :user_id, :created_at, :updated_at
json.url profile_url(profile, format: :json)