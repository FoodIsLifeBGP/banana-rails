require 'base64'

Admin.destroy_all
Claim.destroy_all
Donation.destroy_all
Client.destroy_all
Donor.destroy_all

puts "Seeding Donors..."

donor1 = Donor.create!(
	first_name: "Nancy",
	last_name: "McFood",
	organization_name: "Foods 4 U",
	email: "donor@donor.com",
	password: "donor@123",
	address_street: "704 Terry Ave",
	address_city: "Seattle",
	address_state: "WA",
	address_zip: 98104,
	business_license: "9198DD435AS3456",
	account_status: "active",
	pickup_instructions: 'Please go to the front desk.',
	 business_phone_number: '8675309',
	 business_doc_id: '8675309',
	 profile_pic_link: 'http://www.link.com'
)
donor2 = Donor.create(
	first_name: "Bob",
	last_name: "Binkler",
	organization_name: "Unapproved",
	email: "approve@me.com",
	password: "approve@123",
	address_street: "2245 1st Ave S",
	address_city: "Seattle",
	address_state: "WA",
	address_zip: 98134,
	business_license: "DSJ0984DFGK32",
	pickup_instructions: 'Please go to the front desk.',
	 business_phone_number: '8675309',
	 business_doc_id: '8675309',
	 profile_pic_link: 'http://www.link.com'
)
donor3 = Donor.create(
	first_name: "Rachel",
	last_name: "Maneshevitz",
	organization_name: "ABC Grocery",
	email: "donor3@donor3.com",
	password: "donor3@123",
	address_street: '12001 Main St',
	address_city: 'Bellevue',
	address_state: 'WA',
	address_zip: 98005,
	business_license: "123456789",
	account_status: "approved",
	pickup_instructions: 'Please go to the front desk.',
	 business_phone_number: '8675309',
	 business_doc_id: '8675309',
	 profile_pic_link: 'http://www.link.com'
)
donor4 = Donor.create(
	first_name: "Gigi",
	last_name: "Goode",
	organization_name: "Good Food Restaurant",
	email: "donor4@donor4.com",
	password: "donor4@123",
	address_street: '1100 9th Ave',
	address_city: 'Seattle',
	address_state: 'WA',
	address_zip: 98101,
	business_license: "123456789",
	account_status: "approved",
	pickup_instructions: 'Please go to the front desk.',
	 business_phone_number: '8675309',
	 business_doc_id: '8675309',
	 profile_pic_link: 'http://www.link.com'
)
donor5 = Donor.create(
	first_name: "Serenity",
	last_name: "Now",
	organization_name: "A Coffeeshop",
	email: "donor5@donor5.com",
	password: "donor5@123",
	address_street: '1014 Madison St',
	address_city: 'Seattle',
	address_state: 'WA',
	address_zip: 98104,
	business_license: "123456789",
	account_status: "approved",
	pickup_instructions: 'Please go to the front desk.',
	 business_phone_number: '8675309',
	 business_doc_id: '8675309',
	 profile_pic_link: 'http://www.link.com'
	)
donor6 = Donor.create(
	first_name: "Chad",
	last_name: "Charles",
	organization_name: "Chad's Deli",
	email: "donor6@donor6.com",
	password: "donor6@123",
	address_street: '519 6th Ave S',
	address_city: 'Seattle',
	address_state: 'WA',
	address_zip: 98104,
	business_license: "123456789",
	account_status: "approved",
	pickup_instructions: 'Please go to the front desk.',
	 business_phone_number: '8675309',
	 business_doc_id: '8675309',
	 profile_pic_link: 'http://www.link.com'
)
donor7 = Donor.create(
	first_name: "Joanna",
	last_name: "Soto",
	organization_name: "Fancy Foods",
	email: "donor7@donor7.com",
	password: "donor7@123",
	address_street: '1700 East Madison St',
	address_city: 'Seattle',
	address_state: 'WA',
	address_zip: 98122,
	business_license: "123456789",
	account_status: "approved",
	pickup_instructions: 'Please go to the front desk.',
	 business_phone_number: '8675309',
	 business_doc_id: '8675309',
	 profile_pic_link: 'http://www.link.com'
)
donor8 = Donor.create(
	first_name: "Issa",
	last_name: "Rae",
	organization_name: "XYZ Grocery",
	email: "donor8@donor8.com",
	password: "donor8@123",
	address_street: '532 Broadway E',
	address_city: 'Seattle',
	address_state: 'WA',
	address_zip: 98102,
	business_license: "123456789",
	account_status: "approved",
	pickup_instructions: 'Please go to the front desk.',
	 business_phone_number: '8675309',
	 business_doc_id: '8675309',
	 profile_pic_link: 'http://www.link.com'
)
donor9 = Donor.create(
	first_name: "Greta",
	last_name: "Thunberg",
	organization_name: "Dangerousway",
	email: "donor9@donor9.com",
	password: "donor9@123",
	address_street: '1930 2nd Ave',
	address_city: 'Seattle',
	address_state: 'WA',
	address_zip: 98101,
	business_license: "123456789",
	account_status: "approved",
	pickup_instructions: 'Please go to the front desk.',
	 business_phone_number: '8675309',
	 business_doc_id: '8675309',
	 profile_pic_link: 'http://www.link.com'
)
donor10 = Donor.create(
	first_name: "Sasha",
	last_name: "Fierce",
	organization_name: "Macco Groceries",
	email: "donor10@donor10.com",
	password: "donor10@123",
	address_street: '235 Summit Ave E',
	address_city: 'Seattle',
	address_state: 'WA',
	address_zip: 98102,
	business_license: "123456789",
	account_status: "approved",
	pickup_instructions: 'Please go to the front desk.',
	business_phone_number: '8675309',
	business_doc_id: '8675309',
	profile_pic_link: 'http://www.link.com'
)

puts "Seeding Donations..."

donation1 = Donation.create!(
	food_name: "Bananas",
	donor_id: donor1.id,
  category: DonationCategory::PRODUCE,
	pickup_instructions: 'front desk',
  total_amount: '20 bunches',
  status: DonationStatus::ACTIVE,
)
donation2 = Donation.create(
	food_name: "Apples",
	donor_id: donor2.id,
	pickup_instructions: 'front desk',
	status: DonationStatus::CLOSED,
  total_amount: '2 dozen apples',
  category: DonationCategory::PRODUCE
)
donation3 = Donation.create(
	food_name: "Bread",
  category: DonationCategory::BREAD,
	total_amount: "10 Loaves",
	donor_id: donor3.id,
	pickup_instructions: 'front desk',
  status: DonationStatus::DELETED,
)
donation4 = Donation.create(
	food_name: "Roast beef & kale sandwich",
  category: DonationCategory::OTHERS,
  total_amount: "10 servings",
	donor_id: donor1.id,
	pickup_instructions: 'front desk',
  status: DonationStatus::CLOSED,
)
donation5 = Donation.create(
	food_name: "Chicken Tikka Masala",
  total_amount: "10 servings",
	donor_id: donor1.id,
	pickup_instructions: 'front desk',
  category: DonationCategory::HOT_MEAL,
  status: DonationStatus::CLOSED,
)
donation6 = Donation.create(
	food_name: "Honeydew",
	total_amount: "10 servings",
	donor_id: donor2.id,
	pickup_instructions: 'front desk',
  category: DonationCategory::PRODUCE,
  status: DonationStatus::ACTIVE,
)
donation9 = Donation.create(
	food_name: "Milk",
	donor_id: donor3.id,
	pickup_instructions: 'front desk',
  category: DonationCategory::DAIRY,
  total_amount: "3 gallons",
  status: DonationStatus::ACTIVE
)
## Either delete or migrate these to new table format
# donation10 = Donation.create(
# 	food_name: "Croissant",
# 	measurement: "croissant",
# 	per_person: 1,
# 	total_servings: 15,
# 	duration_minutes: 30,
# 	image_url: "",
# 	donor_id: donor4.id,
# 	pickup_location: 'front desk',
# 	canceled: false,
# )
# donation11 = Donation.create(
# 	food_name: "Garlic broccoli",
# 	measurement: "side",
# 	per_person: 1,
# 	total_servings: 9,
# 	duration_minutes: 30,
# 	image_url: "",
# 	donor_id: donor5.id,
# 	pickup_location: 'front desk',
# 	canceled: false,
# )
# donation12 = Donation.create(
# 	food_name: "Pepperoni pizza",
# 	measurement: "slice",
# 	per_person: 2,
# 	total_servings: 6,
# 	duration_minutes: 30,
# 	image_url: "",
# 	donor_id: donor6.id,
# 	pickup_location: 'front desk',
# 	canceled: false,
# )
# donation13 = Donation.create(
# 	food_name: "Beans",
# 	measurement: "can",
# 	per_person: 2,
# 	total_servings: 21,
# 	duration_minutes: 60,
# 	image_url: "",
# 	donor_id: donor7.id,
# 	pickup_location: 'front desk',
# 	canceled: false,
# )
# donation14 = Donation.create(
# 	food_name: "Diced tomatoes",
# 	measurement: "can",
# 	per_person: 1,
# 	total_servings: 12,
# 	duration_minutes: 30,
# 	image_url: "",
# 	donor_id: donor8.id,
# 	pickup_location: 'front desk',
# 	canceled: false,
# )
# donation15 = Donation.create(
# 	food_name: "Collards (cooked)",
# 	measurement: "side serving",
# 	per_person: 1,
# 	total_servings: 16,
# 	duration_minutes: 60,
# 	image_url: "",
# 	donor_id: donor9.id,
# 	pickup_location: 'front desk',
# 	canceled: false,
# )
# donation16 = Donation.create(
# 	food_name: "Spinach (raw)",
# 	measurement: "bag",
# 	per_person: 1,
# 	total_servings: 10,
# 	duration_minutes: 30,
# 	image_url: "",
# 	donor_id: donor10.id,
# 	pickup_location: 'front desk',
# 	canceled: false,
# )
# donation17 = Donation.create(
# 	food_name: "Curry with chickpeas",
# 	measurement: "plate",
# 	per_person: 1,
# 	total_servings: 6,
# 	duration_minutes: 30,
# 	image_url: "",
# 	donor_id: donor10.id,
# 	pickup_location: 'front desk',
# 	canceled: false,
# )
# donation18 = Donation.create(
# 	food_name: "Red bean mochi",
# 	measurement: "package",
# 	per_person: 1,
# 	total_servings: 19,
# 	duration_minutes: 30,
# 	image_url: "",
# 	donor_id: donor9.id,
# 	pickup_location: 'front desk',
# 	canceled: false,
# )
# donation19 = Donation.create(
# 	food_name: "Bananas",
# 	measurement: "bunch",
# 	per_person: 1,
# 	total_servings: 20,
# 	duration_minutes: 60,
# 	image_url: "",
# 	donor_id: donor8.id,
# 	pickup_location: 'front desk',
# 	canceled: false,
# )
# donation20 = Donation.create(
# 	food_name: "Bell peppers",
# 	measurement: "pepper",
# 	per_person: 2,
# 	total_servings: 25,
# 	duration_minutes: 30,
# 	image_url: "",
# 	donor_id: donor7.id,
# 	pickup_location: 'front desk',
# 	canceled: false,
# )
# donation21 = Donation.create(
# 	food_name: "Mint Oreos",
# 	measurement: "box",
# 	per_person: 1,
# 	total_servings: 8,
# 	duration_minutes: 60,
# 	image_url: "",
# 	donor_id: donor6.id,
# 	pickup_location: 'front desk',
# 	canceled: false,
# )
# donation22 = Donation.create(
# 	food_name: "Olives",
# 	measurement: "pint",
# 	per_person: 1,
# 	total_servings: 6,
# 	duration_minutes: 30,
# 	image_url: "",
# 	donor_id: donor5.id,
# 	pickup_location: 'front desk',
# 	canceled: false,
# )
# donation23 = Donation.create(
# 	food_name: "Assorted ice cream",
# 	measurement: "quart",
# 	per_person: 1,
# 	total_servings: 18,
# 	duration_minutes: 30,
# 	image_url: "",
# 	donor_id: donor4.id,
# 	pickup_location: 'front desk',
# 	canceled: false,
# )
# donation24 = Donation.create(
# 	food_name: "Rice & peas",
# 	measurement: "plate",
# 	per_person: 2,
# 	total_servings: 8,
# 	duration_minutes: 30,
# 	image_url: "",
# 	donor_id: donor4.id,
# 	pickup_location: 'front desk',
# 	canceled: false,
# )


puts "Seeding Clients..."

client1 = Client.create!(
	email: "client@client.com",
	password: "client@123",
	address_street: "1411 4th Ave",
	address_city: "Seattle",
	address_state: "Washington",
	address_zip: 98101,
	account_status: "active",
	ethnicity: "Black or African American",
	gender: "Prefer Not to Answer",
    first_name: "John",
    last_name: "Doe"
)

client2 = Client.create(
	email: "c2@me.com",
	password: "password2@123",
	address_street: "2901 3rd Ave",
	address_city: "Seattle",
	address_state: "Washington",
	address_zip: 98121,
	ethnicity: "White",
	gender: "Female",
    first_name: "David",
    last_name: "Jones"
)

client3 = Client.create(
	email: "c3@me.com",
	password: "password3@123",
	address_street: "111 S Jackson St",
	address_city: "Seattle",
	address_state: "Washington",
	address_zip: 98104,
	account_status: "suspended",
	ethnicity: "Hispanic or Latino",
	gender: "Male",
    first_name: "Mark",
    last_name: "Lee"
)

puts "Seeding Claims..."

def create_claim(client_id, donation_id, completed)
	Claim.create!(
		client_id: client_id,
		donation_id: donation_id,
		qr_code: Base64.encode64({ 'client_id': client_id, 'donation_id': donation_id }.to_json).chomp,
		completed: completed,
		time_claimed: Time.now,
		canceled: false
	)
end

claims = [
	[client1.id, donation1.id, true],
	[client1.id, donation2.id, false],
	[client1.id, donation3.id, false],
	[client2.id, donation4.id, false],
	[client2.id, donation5.id, false],
	[client2.id, donation6.id, true],
	[client3.id, donation1.id, false],
	[client3.id, donation2.id, false],
	[client3.id, donation3.id, false],
	[client3.id, donation4.id, true],
	[client3.id, donation5.id, false],
	[client3.id, donation6.id, false],
]

claims.each { |c| create_claim(*c) }

puts "Seeding Admins..."
Admin.create!(
	email: 'admin@admin.com',
	password: 'admin',
)

puts "Finished with no errors"
