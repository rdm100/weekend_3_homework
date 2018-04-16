require_relative('../db/sql_runner')
class Customer
  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)
    @name = options['name']
    @funds = options['funds'].to_i
    @id = options['id'].to_i
  end

  def save()
    sql = "INSERT INTO customers(name, funds) VALUES ($1, $2) RETURNING id" 
    values = [@name, @funds]
    result = SqlRunner.run(sql, values).first()
    @id = result['id'].to_i
  end

  def update()
    sql = "UPDATE customers SET name = $1, funds =$2 WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
     sql = "DELETE FROM customers WHERE id = $1"
     values = [@id]
     SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM customers"
    customer_data = SqlRunner.run(sql)
    return Customer.map_items(customer_data)
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def films()
    sql = "SELECT films.* FROM films 
    INNER JOIN tickets ON films.id = tickets.film_id
    WHERE tickets.customer_id = $1"
    values = [@id]
    film_data = SqlRunner.run(sql, values)
    return Film.map_items(film_data)
  end

  def reduce_funds(film)
    if @funds >= film.price
    @funds -= film.price
    self.update()
    end
  end

  def how_many_tickets()
    sql = "SELECT * FROM tickets WHERE customer_id = $1"
    values = [@id]
    tickets = SqlRunner.run(sql, values)
    array_of_tickets = tickets.map{|ticket| Ticket.new(ticket)}
    return array_of_tickets.length
  end

  def self.map_items(customer_data)
    result = customer_data.map {|customer| Customer.new(customer)}
    return result
  end


end
