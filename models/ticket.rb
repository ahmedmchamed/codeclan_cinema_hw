require_relative('../db/sql_runner')

class Ticket

    attr_reader :id, :customer_id, :film_id, :screening_id

    def initialize(options)
        @id = options['id'].to_i() if options['id']
        @customer_id = options['customer_id'].to_i()
        @film_id = options['film_id'].to_i()
		@screening_id = options['screening_id'].to_i()
    end

    def save()
        sql = "INSERT INTO tickets
        (customer_id, film_id, screening_id) VALUES
        ($1, $2, $3) RETURNING id"
        values = [@customer_id, @film_id, @screening_id]
        @id = SqlRunner.run(sql, values)[0]['id'].to_i()
    end

	def update_ticket()
		sql = "UPDATE tickets SET
		(customer_id, film_id, screening_id) = ($1, $2, $3)
		WHERE id = $4;"
		values = [@customer_id, @film_id, @screening_id, @id]
		SqlRunner.run(sql, values)
	end

	def self.all()
		sql = "SELECT * FROM tickets;"
		tickets_hash_result = SqlRunner.run(sql)
		return self.map_ticket_data(tickets_hash_result)
	end

	def self.delete_all()
		sql = "DELETE FROM tickets;"
		SqlRunner.run(sql)
	end

	def self.map_ticket_data(tickets_hash_result)
		return tickets_hash_result.map { |ticket| Ticket.new(ticket) }
	end

end
