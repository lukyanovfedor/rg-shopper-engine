def fill_address(address, country)
  fill_in 'First name', with: address[:first_name]
  fill_in 'Last name', with: address[:last_name]
  find('.country-select').select(country.name)
  fill_in 'City', with: address[:city]
  fill_in 'Street', with: address[:street]
  fill_in 'Zip', with: address[:zip]
  fill_in 'Phone', with: address[:phone]
end

def fill_payment(credit_card)
  fill_in 'Number', with: credit_card[:number]
  find('.months-select').select('March')
  fill_in 'Expiration year', with: credit_card[:expiration_year]
  fill_in 'Cvv', with: credit_card[:cvv]
end