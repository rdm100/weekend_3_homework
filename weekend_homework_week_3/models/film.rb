require_relative('../db/sql_runner')

class Film
  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @id = options['id'].to_i
    @title = options['title']
    @price = options['price'].to_i
  end

  def save()
    sql = "INSERT INTO films (title, price) VALUES ($1, $2) RETURNING id"
    values = [@title, @price]
	@id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def update()
  	sql = "UPDATE films SET title = $1, price =$2 WHERE id = $3"
    values = [@title, @price, @id]
	SqlRunner.run(sql, values)
  end

  def delete()
   sql = "DELETE FROM films WHERE id = $1"
   values = [@id]
   SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM films"
    film_data = SqlRunner.run(sql)
    return Film.map_items(film_data)
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def customers()
    sql = "SELECT customers.* FROM customers INNER JOIN tickets ON customers.id
    = tickets.customer_id WHERE tickets.film_id = $1"
    values = [@id]
    customer_data = SqlRunner.run(sql, values)
    return Customer.map_items(customer_data)
  end

   def how_many_customers
    return customers().length
   end

  def self.map_items(film_data)
    result = film_data.map {|film| Film.new(film)}
    return result
  end

end
