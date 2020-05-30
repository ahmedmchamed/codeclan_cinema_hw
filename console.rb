require('pry-byebug')
require('time')
require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')
require_relative('models/screening')

#Clearing the data first
Screening.delete_all()
Ticket.delete_all()
Customer.delete_all()
Film.delete_all()

##################
#####CUSTOMER#####
##################

customer1 = Customer.new({
	'name' => 'Johnny McGhee',
	'funds' => 100
})

customer2 = Customer.new({
	'name' => 'Trevor McMuffin',
	'funds' => 90
})

customer3 = Customer.new({
	'name' => 'Bongo McGuffin',
	'funds' => 65
})

customer4 = Customer.new({
	'name' => 'Eduardo McFly',
	'funds' => 75
})

customer5 = Customer.new({
	'name' => 'Ricardo Manly',
	'funds' => 50
})

customer6 = Customer.new({
	'name' => 'Larry Is Happy',
	'funds' => 55
})

customer7 = Customer.new({
	'name' => 'Steve',
	'funds' => 60
})

customer1.save()
customer2.save()
customer3.save()
customer4.save()
customer5.save()
customer6.save()
customer7.save()

##################
#######FILM#######
##################

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

##################
####SCREENING#####
##################

eleven_pm = Time.new(2020, 10, 31, 23, 0, 0)
nine_pm = Time.new(2020, 10, 31, 21, 0, 0)
eight_pm = Time.new(2020, 10, 31, 20, 0, 0)

screening1 = Screening.new({
	'film_time' => eleven_pm,
	'available_tickets' => 20,
	'film_id' => film2.id(),
})

screening2 = Screening.new({
	'film_time' => nine_pm,
	'available_tickets' => 25,
	'film_id' => film1.id(),
})

screening3 = Screening.new({
	'film_time' => eight_pm,
	'available_tickets' => 20,
	'film_id' => film2.id(),
})

screening1.save()
screening2.save()
screening3.save()

##################
######TICKET######
##################

ticket1 = Ticket.new({
    'customer_id' => customer1.id(),
    'film_id' => film1.id(),
	'screening_id' => screening2.id()
})

ticket2 = Ticket.new({
    'customer_id' => customer1.id(),
    'film_id' => film2.id(),
	'screening_id' => screening1.id()
})

ticket3 = Ticket.new({
	'customer_id' => customer2.id(),
	'film_id' => film2.id(),
	'screening_id' => screening1.id()
})

ticket4 = Ticket.new({
	'customer_id' => customer3.id(),
	'film_id' => film2.id(),
	'screening_id' => screening1.id()
})

ticket5 = Ticket.new({
	'customer_id' => customer4.id(),
	'film_id' => film2.id(),
	'screening_id' => screening3.id()
})

ticket6 = Ticket.new({
	'customer_id' => customer5.id(),
	'film_id' => film1.id(),
	'screening_id' => screening2.id()
})

ticket1.save()
ticket2.save()
ticket3.save()
ticket4.save()
ticket5.save()
ticket6.save()

binding.pry

nil
