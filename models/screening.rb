require('time')
require_relative('../db/sql_runner')
require_relative('./ticket')

class Screening
	
	attr_accessor :film_time, :available_tickets
	attr_reader :id, :film_id, :customer_id

	def initialize(options)
		@id = options['id'].to_i() if options['id']
		@film_time = options['film_time']
		@available_tickets = options['available_tickets'].to_i()
		@film_id = options['film_id'].to_i()
	end

	def save()
		sql = "INSERT INTO screenings
		(film_time, available_tickets, film_id) VALUES
		($1, $2, $3) RETURNING id;"
		values = [@film_time, @available_tickets, @film_id]
		@id = SqlRunner.run(sql, values)[0]['id'].to_i()
	end

	def update_screening()
		sql = "UPDATE screenings SET
		(film_time, available_tickets, film_id) = ($1, $2, $3) WHERE id = $4;"
		values = [@film_time, @available_tickets, @film_id, @id]
		SqlRunner.run(sql, values)
	end
	
	def available_seats_remaining()
		#get the number of tickets purchased for a film
		sql = "SELECT tickets.* FROM tickets
		WHERE tickets.film_id = $1"
		values = [@film_id]
		tickets_hash_result = SqlRunner.run(sql, values)
		tickets_array = Ticket.map_ticket_data(tickets_hash_result)
		remaining_seats = @available_tickets - tickets_array.count()
		return "No more seats available" if remaining_seats <= 0
		return remaining_seats
	end

	def self.all()
		sql = "SELECT * FROM screenings;"
		screening_hash_data = SqlRunner.run(sql)
		return self.map_screening_data(screening_hash_data)
	end

	def self.delete_all()
		sql = "DELETE FROM screenings;"
		SqlRunner.run(sql)
	end

	def self.map_screening_data(screening_hash_data)
		return screening_hash_data.map { |screening| Screening.new(screening) }
	end

end
