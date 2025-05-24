module faker

struct UserProfile {
pub mut:
	first_name     string @[fake_source: first_name]
	last_name      string @[fake_source: last_name]
	company_name   string @[fake_source: company_name]
	email          string @[fake_source: email_address]
	phone          string @[fake_source: phone_number]
	ip             string @[fake_source: ip_v4]
	accept_meeting string @[fake_list: 'yes,maybe,no']
	accepted_agb   string @[fake_list: 'true,false']
}

fn test_generate_user_profiles() {
	mut helper := Faker{}

	profiles := helper.generate[UserProfile](10) or {
		print(err)
		[]UserProfile{}
	}
	assert profiles.len == 10

	for profile in profiles {
		assert profile.first_name.len > 0
		assert profile.last_name.len > 0
		assert profile.email.len > 0
		assert profile.phone.len > 0
		assert profile.company_name.len > 0
		println('Generated: ${profile}')
	}
}

struct Transaction {
	product_sku string @[fake_source: 'product_sku']
	price       string @[fake_source: 'cart_total']
	timestamp   string @[fake_source: 'timestamp']
	environment string @[fake_list: 'dev,tst,acc,uat,trn,prd']
	weather     string @[fake_list: 'sunny,clouds,rain,snow,cold,hot,breezy']
}

fn test_generate_transactions() {
	mut helper := Faker{}

	txs := helper.generate[Transaction](20) or {
		print(err)
		[]Transaction{}
	}
	assert txs.len == 20

	for tx in txs {
		assert tx.product_sku.starts_with('SKU') || tx.product_sku.len > 0
		assert tx.price.contains('.') || tx.price.len > 0
		assert tx.timestamp.len > 0
		println('Transaction: ${tx}')
	}
}
