require_relative('../db/sql_runner')
require_relative('./film')

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
    
    def films()
        sql = "SELECT films.* FROM films
        INNER JOIN tickets ON
        tickets.film_id = films.id
        WHERE tickets.customer_id = $1"
        values = [@id]
        film_hash_data = SqlRunner.run(sql, values)
        return Film.map_film_data(film_hash_data)
    end

	def self.delete_all()
	    sql = "DELETE FROM customers;"
	 	SqlRunner.run(sql)
    end
    
    def self.map_customer_data(customer_hash_data)
        return customer_hash_data.map { |customer| Customer.new(customer) }
    end

end



