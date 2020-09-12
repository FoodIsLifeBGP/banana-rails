class AdminSerializer < ActiveModel::Serializer
  attributes :id,
    :email,
    :password_digest,
    :first_name,
    :last_name,
    :user_type,
    :user_status
end
