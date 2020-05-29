require('pry-byebug')
require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')

Customer.delete_all()
Film.delete_all()

customer1 = Customer.new({
	'name' => 'Johnny McGhee',
	'funds' => 100
})

customer2 = Customer.new({
	'name' => 'Trevor McMuffin',
	'funds' => 90
})

customer1.save()
customer2.save()

film1 = Film.new({
    'title' => 'Men in Black',
    'price' => 25
})

film2 = Film.new({
    'title' => 'Planet of the Apes',
    'price' => 30
})

film1.save()
film2.save()

ticket1 = Ticket.new({
    'customer_id' => customer1.id(),
    'film_id' => film1.id()
})

ticket2 = Ticket.new({
    'customer_id' => customer1.id(),
    'film_id' => film2.id()
})

ticket3 = Ticket.new({
	'customer_id' => customer2.id(),
	'film_id' => film2.id()
})


ticket1.save()
ticket2.save()
ticket3.save()

binding.pry

nil
