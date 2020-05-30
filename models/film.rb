require_relative('../db/sql_runner')
require_relative('./customer')
require_relative('./ticket')

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

    def customers()
        sql = "SELECT customers.* FROM customers
        INNER JOIN tickets ON
        tickets.customer_id = customers.id
        WHERE tickets.film_id = $1"
        values = [@id]
        customer_hash_data = SqlRunner.run(sql, values)
        return Customer.map_customer_data(customer_hash_data)
    end

	def number_of_customers()
			sql = "SELECT tickets.* FROM tickets
			WHERE tickets.film_id = $1"
			values = [@id]
			ticket_hash_result = SqlRunner.run(sql, values)
			number_of_customers_array = Ticket.map_data(ticket_hash_result)
			return number_of_customers_array.size()
	end

    def self.delete_all()
        sql = "DELETE FROM films;"
        SqlRunner.run(sql)
    end

    def self.map_film_data(film_hash_data)
        return film_hash_data.map { |film| Film.new(film) }
    end


end
