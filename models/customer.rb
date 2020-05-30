require_relative('../db/sql_runner')
require_relative('./film')
require_relative('./ticket')

class Customer

    attr_accessor :name, :funds
    attr_reader :id

    def initialize(options)
        @id = options['id'].to_i() if options['id']
        @name = options['name']
        @funds = options['funds'].to_i()
    end

    def save()
        sql = "INSERT INTO customers
        (name, funds) VALUES
        ($1, $2) RETURNING id;"
        values = [@name, @funds]
        @id = SqlRunner.run(sql, values)[0]['id'].to_i()
    end

	def update_customer()
		sql = "UPDATE customers SET 
		(name, funds) = ($1, $2) WHERE id = $3;"
		values = [@name, @funds, @id]
		SqlRunner.run(sql, values)
	end
    
    def films()
        sql = "SELECT films.* FROM films
        INNER JOIN tickets ON
        tickets.film_id = films.id
        WHERE tickets.customer_id = $1;"
        values = [@id]
        film_hash_data = SqlRunner.run(sql, values)
        return Film.map_film_data(film_hash_data)
    end

    def remaining_funds()
        ticket_price_sql = "SELECT films.price FROM films
        INNER JOIN tickets ON
        tickets.film_id = films.id
        WHERE tickets.customer_id = $1;"
        values = [@id]
        ticket_price_result = SqlRunner.run(ticket_price_sql, values)[0]['price'].to_i()
        return remaining_customer_funds = @funds - ticket_price_result
    end

	def number_of_tickets_purchased()
		sql = "SELECT tickets.* FROM tickets
		WHERE tickets.customer_id = $1;"
		values = [@id]
		tickets_hash_result = SqlRunner.run(sql, values)
		tickets_array = Ticket.map_data(tickets_hash_result)
		return tickets_array.size()
	end

	def self.all()
		sql = "SELECT * FROM customers;"
		customers_hash_result = SqlRunner.run(sql)
		return self.map_customer_data(customers_hash_result)
	end

	def self.delete_all()
	    sql = "DELETE FROM customers;"
	 	SqlRunner.run(sql)
    end
    
    def self.map_customer_data(customer_hash_data)
        return customer_hash_data.map { |customer| Customer.new(customer) }
    end

end



