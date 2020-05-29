require_relative('../db/sql_runner')

class Film

    def initialize(options)
        @id = options['id'].to_i() if options['id']
        @title = options['title']
        @price = options['price']
    end

    def save()
        sql = "INSERT INTO films
        (title, price) VALUES
        ($1, $2) RETURNING id"
        values = [@title, @price]
        @id = SqlRunner.run(sql, values)[0]['id'].to_i()
    end

    def self.delete_all()
        sql = "DELETE FROM films;"
        SqlRunner.run(sql)
    end

end