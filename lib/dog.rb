class Dog

  attr_accessor :name, :breed
  attr_reader :id

  def initialize(id: nil, name:, breed:)
    # binding.pry
    @id = id
    @name = name
    @breed = breed
  end


  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
      )
    SQL
    # binding.pry
    DB[:conn].execute(sql)
  end


  def self.drop_table
    DB[:conn].execute("DROP TABLE IF EXISTS dogs")
  end


  def save
    # binding.pry
    sql = <<-SQL
      INSERT INTO dogs (name, breed) VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self
  end


  def self.create(hash)
    # binding.pry
    doggie = self.new(hash)
    doggie.save
  end


  def self.find_by_id(id)
    sql = <<-SQL
      SELECT * FROM dogs WHERE id = ?
    SQL
  # binding.pry
    result = DB[:conn].execute(sql, id)
    new_dog = self.new(id: result[0][0], name: result[0][1], breed: result[0][2])
    new_dog
  end


  def self.find_or_create_by(hash)
    # binding.pry
    sql = <<-SQL
    SELECT * FROM dogs
    WHERE name = ? AND breed = ?
    SQL
    results = DB[:conn].execute(sql,hash[:name],hash[:breed])
    if results.empty?
      self.create(hash)
    else
      # self.new(id: results[0][0], name: results[0][1], breed: results[0][2])
      self.find_by_id(results[0][0])
    end
  end

 def self.new_from_db(row)
  # binding.pry
  self.new(id: row[0], name: row[1], breed: row[2])

 end

 def self.find_by_name(name)
  sql = <<-SQL
      SELECT * FROM dogs WHERE name = ?
    SQL
  # binding.pry
    result = DB[:conn].execute(sql, name)
    new_dog = self.new(id: result[0][0], name: result[0][1], breed: result[0][2])
    new_dog
  end

  def update
    sql = <<-SQL
      UPDATE dogs
      SET name = ?, breed = ?
      WHERE id = ?
      SQL

      DB[:conn].execute(sql, self.name, self.breed, self.id)
    # binding.pry
  end

end

# Dog.new("Max")