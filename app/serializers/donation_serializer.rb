class DonationSerializer < ActiveModel::Serializer
  attributes :id,
    :created_at,
    :updated_at,
    :donor_id,
    :food_name,
    :category,
    :total_amount,
    :pickup_instructions,
    :status,
    :distance,
    :donor,
    :claim
  #only return donor address info and location
  def donor
    {address_city: self.object.donor.address_city,
     address_street: self.object.donor.address_street,
     address_state: self.object.donor.address_state,
     address_zip: self.object.donor.address_zip,
     latitude: self.object.donor.latitude,
     longitude: self.object.donor.longitude,
     donor_name: self.object.donor.organization_name}
  end

  def claim
    self.object.claims[0].nil? ? nil : {client_name: self.object.claims[0].client.first_name,
                                        qr_code: self.object.claims[0].qr_code}
  end

end
