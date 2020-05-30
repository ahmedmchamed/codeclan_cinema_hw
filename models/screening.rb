require_relative('../db/sql_runner')

class Screening
	
	attr_accessor :film_time
	attr_reader :id, :film_id

	def initialize(options)
		@id = options['id'].to_i() if options['id']
		@film_time = options['film_time']
		@film_id = options['film_id'].to_i()
	end

	def save()
		sql = "INSERT INTO screenings
		(film_time, film_id) VALUES
		($1, $2) RETURNING id;"
		values = [@film_time, @film_id]
		@id = SqlRunner.run(sql, values)[0]['id'].to_i()
	end

	def self.delete_all()
		sql = "DELETE FROM screenings;"
		SqlRunner.run(sql)
	end

end
