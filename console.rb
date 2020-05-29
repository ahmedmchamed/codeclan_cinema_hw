require('pry-byebug')
require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')

Customer.delete_all()
Film.delete_all()

customer1 = Customer.new({
	'name' => 'Rick Grimes',
	'funds' => 100
})



film1 = Film.new({
    'title' => 'Men in Black',
    'price' => 25
})

customer1.save() 
film1.save()

ticket1 = Ticket.new({
    'customer_id' => customer1.id(),
    'film_id' => film1.id()
})


ticket1.save()

binding.pry

nil
