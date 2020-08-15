class DonorSerializer < ActiveModel::Serializer
  attributes :id,
    :email,
    :first_name,
    :last_name,
    :organization_name,
    :address_street,
    :address_city,
    :address_state,
    :address_zip,
    :account_status,
    :pickup_instructions
    # :business_license,        # commented out for pre-alpha
    # :business_phone_number,   # commented out for pre-alpha
    # :business_doc_id,         # commented out for pre-alpha
    # :profile_pic_link,        # commented out for pre-alpha
end
