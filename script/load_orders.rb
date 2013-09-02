Order.transaction do
  (1..100).each do |i|
    Order.create(name:     "Customer #{i}",
                 address:  "#{i} Main street",
                 email:    "customer-#{i}@exsample.com",
                 pay_type_id: 1)
  end
end