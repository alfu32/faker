module faker

pub fn (mut helper Faker) generate[T](size u32) ![]T {
	mut results := []T{}

	for _ in 0 .. size {
		mut item := T{}
		$for field in T.fields {
			mut attribute := unsafe { field.name.str.vstring() }

			for attr in field.attrs {
				if attr.starts_with('fake_list:') {
					if attr.len <= 10 {
						return error('${attr} on ${field.name} must have as argument a list separated by commas')
					}
					attribute = unsafe { attr.str.vstring() }
					attribute_data := attribute[10..].trim("' ")
					list := attribute_data.split(',')
					item.$(field.name) = helper.random_element[string](list) // list.join(";")//
				} else if attr.starts_with('fake_source:') {
					if attr.len <= 12 {
						return error('${attr} on ${field.name} must have an argument')
					}
					attribute = unsafe { attr.str.vstring() }
					attribute_data := attribute[12..].trim(' ')
					item.$(field.name) = match attribute_data {
						//"boolean" { helper.boolean().str() }
						'company_name' { helper.company_name() }
						'first_name' { helper.first_name() }
						//"future_date"  { helper.future_date() }
						'ip_v4' { helper.ip_v4() }
						'last_name' { helper.last_name() }
						//"past_date"  { helper.past_date() }
						'sentence' { helper.sentence() }
						'uuid_v4' { helper.uuid_v4() }
						'visa_credit_card_number' { helper.visa_credit_card_number() }
						'word' { helper.word() }
						else { helper.random_line_in_file(attribute_data) }
					}
					break
				}
				continue
			}
		}
		results << item
	}
	return results
}
