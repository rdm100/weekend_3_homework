require('pg')
require('pry-byebug')
require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')

Ticket.delete_all()
Customer.delete_all()
Film.delete_all()

film1 =Film.new({
  'title' => 'film1',
  'price' => 8.00
})

film2 = Film.new({
  'title' => 'film2',
  'price' => 9.00
  })

film3 = Film.new({
  'title' => 'film3',
  'price' => 10.00
  })
  film1.save()
  film2.save()
  film3.save()


customer1 =Customer.new({
  'name' => 'Dave',
  'funds' => 50
})

customer2 = Customer.new( {
  'name' => 'Mike',
  'funds' => 100
})

customer1.save()
customer2.save()

ticket1 = Ticket.new({
  'customer_id' => customer1.id,
  'film_id' => film2.id
  })

 ticket2 = Ticket.new({
  'customer_id' => customer2.id,
  'film_id' => film1.id
  })

  ticket3 = Ticket.new({
    'customer_id' => customer2.id,
    'film_id' => film1.id
    })

ticket1.save()
ticket2.save()
ticket3.save()


binding.pry
nil
