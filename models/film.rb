require_relative('../db/sql_runner')
require_relative('./customer')
require_relative('./ticket')
require_relative('./screening')

class Film

    attr_accessor :title, :price
    attr_reader :id

    def initialize(options)
        @id = options['id'].to_i() if options['id']
        @title = options['title']
        @price = options['price'].to_i()
    end

    def save()
        sql = "INSERT INTO films
        (title, price) VALUES
        ($1, $2) RETURNING id"
        values = [@title, @price]
        @id = SqlRunner.run(sql, values)[0]['id'].to_i()
    end

	def update_film()
		sql = "UPDATE films SET
		(title, price) = ($1, $2)
		WHERE id = $3;"
		values = [@title, @price, @id]
		SqlRunner.run(sql, values)
	end

    def customers_seeing_film()
        sql = "SELECT customers.* FROM customers
        INNER JOIN tickets ON
        tickets.customer_id = customers.id
        WHERE tickets.film_id = $1"
        values = [@id]
        customer_hash_data = SqlRunner.run(sql, values)
        return Customer.map_customer_data(customer_hash_data)
    end

	def film_time()
		sql = "SELECT screenings.film_time FROM screenings
		WHERE screenings.film_id = $1"
		values = [@id]
		time_result = SqlRunner.run(sql, values)[0]['film_time']
		return time_result 
	end

	def number_of_tickets()
		sql = "SELECT tickets.* FROM tickets
		WHERE tickets.film_id = $1"
		values = [@id]
		ticket_hash_result = SqlRunner.run(sql, values)
		number_of_tickets_array = Ticket.map_data(ticket_hash_result)
		return number_of_tickets_array.size()
	end
	
	def best_screening_time()
		sql = "SELECT tickets.screening_id FROM tickets
		WHERE tickets.film_id = $1;"
		values = [@id]
		tickets_hash_result = SqlRunner.run(sql, values)
		tickets_id_result = Ticket.map_ticket_data(tickets_hash_result)
		#for every screening id key, compound assign number of entries
		popular_screenings_hash = Hash.new(0)
		for ticket in tickets_id_result
			popular_screenings_hash[ticket.screening_id()] += 1
		end
		#max_by sort the original tickets_id_result array, against the
		#count in the popular_screenings_hash with the highest value
		#id with the highest occurence is returned
		return tickets_id_result.max_by { |ticket| popular_screenings_hash[ticket.screening_id()] }
	end

    def self.find_film_by_id(id)
      sql = "SELECT films.* FROM films where id = $1"
      values = [id]
      films_hash_result = SqlRunner.run(sql, values)
      return self.map_film_data(films_hash_result)
    end

	def self.most_watched_film()
		sql = "SELECT films.* FROM films
		INNER JOIN tickets ON
		tickets.film_id = films.id;"
		films_hash_result = SqlRunner.run(sql)
		films_array = self.map_film_data(films_hash_result)
		sorted_films = films_array.sort_by { |film| film.number_of_tickets() }
		return sorted_films.uniq { |film| film.number_of_tickets() }
	end

	def self.all()
		sql = "SELECT * FROM films;"
		films_hash_result = SqlRunner.run(sql)
		return self.map_film_data(films_hash_result)
	end

    def self.delete_all()
        sql = "DELETE FROM films;"
        SqlRunner.run(sql)
    end

    def self.map_film_data(film_hash_data)
        return film_hash_data.map { |film| Film.new(film) }
    end


end
