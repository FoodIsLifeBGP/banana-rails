class ClientSerializer < ActiveModel::Serializer
  attributes :id,
             :account_status,
             :first_name,
             :last_name,
             #:address_street,
             #:address_city,
             #:address_state,
             #:address_zip,
             :email
end
