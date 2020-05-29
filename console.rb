require('pry-byebug')
require_relative('models/customer')
require_relative('models/film')

Customer.delete_all()
Film.delete_all()

customer1 = Customer.new({
	'name' => 'Rick Grimes',
	'funds' => 100
})

customer1.save() 

film1 = Film.new({
    'title' => 'Men in Black',
    'price' => 25
})

film1.save()

binding.pry

nil
