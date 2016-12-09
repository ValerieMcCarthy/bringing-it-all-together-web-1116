class Dog

attr_accessor :id, :name, :breed

def initialize (options = {})
	@id = options[:id]
	@name = options[:name]
	@breed = options[:breed]
	
end

def self.create_table
	sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs (
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
    )
    SQL

    DB[:conn].execute(sql)
end

def self.drop_table
	 sql = <<-SQL
	 	DROP TABLE IF EXISTS dogs
	 SQL
    DB[:conn].execute(sql)
end


def self.create(attributes)
	self.new(attributes).save
end

# def self.create(name:, breed:)
# 	dog = Dog.new(name: name, breed: breed)
# 	dog.save
# 	dog
# end

def self.find_by_id(id_query)
	sql = <<-SQL
		SELECT * 
		FROM dogs 
		WHERE id = ?
	
	SQL
	
	 results = new_from_db(DB[:conn].execute(sql, id_query).first)	
	 results[0]
	 # attributes = DB[:conn].execute(sql, id_query).first
	 # new_from_db(attributes)
end

def self.new_from_db(row)
    attr = {}
    attr[:id], attr[:name], attr[:breed] = row
    self.new(attr)
end

def self.find_or_create_by(attr)
	sql = <<-SQL
		SELECT *
		FROM dogs
		WHERE name = ? AND breed = ?
	SQL

	results = DB[:conn].execute(sql, attr[:name], attr[:breed]).first
	if results.nil?
		create(attr)
	else
		new_from_db(results)
	end
    # dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)
    # if !dog.empty?
    #   dog_data = dog[0]
    #   dog = dog.new(dog_data[0], dog_data[1], dog_data[2])
    # else
    #   dog = self.create(name: name, breed: breed)
    # end
    # dog
end

def self.find_by_name(dog_name)
	sql = <<-SQL
		SELECT * 
		FROM dogs 
		WHERE name = ?
	SQL
		
	new_from_db(DB[:conn].execute(sql, dog_name).first)
	
end

def self.find_by_id(id_query)
	sql = <<-SQL
		SELECT * 
		FROM dogs 
		WHERE id = ?
	
	SQL
	
	 # results = new_from_db(DB[:conn].execute(sql, id_query).first)	
	 # results[0]
	 new_from_db(DB[:conn].execute(sql, id_query).first)
	 # attributes = DB[:conn].execute(sql, id_query).first
	 # new_from_db(attributes)
end

def update
	sql = <<-SQL
	 UPDATE dogs
	 SET name = ?, breed = ?
	 WHERE id = ?
	SQL

	DB[:conn].execute(sql, self.name, self.breed, self.id)
end


def save
	sql = <<-SQL
		INSERT INTO dogs (name, breed)
		VALUES (?, ?)
	SQL

	DB[:conn].execute(sql, self.name, self.breed)
	id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
	@id = id
	self
	
end



# def self.find_or_create_by(name:, breed:)
# 	sql = <<-SQL
# 		SELECT *
# 		FROM dogs
# 		WHERE name = ? AND breed = ?
# 	SQL

# 	results = DB[:conn].execute(sql, name, breed).first
# 	if id
# 		find_by_id(id)
# 	else
# 		new(name: name, breed: breed).save
# 	end
#     # dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)
#     # if !dog.empty?
#     #   dog_data = dog[0]
#     #   dog = dog.new(dog_data[0], dog_data[1], dog_data[2])
#     # else
#     #   dog = self.create(name: name, breed: breed)
#     # end
#     # dog
# end

# def self.find_by_id(id_query)
# 	sql = <<-SQL
# 		SELECT * 
# 		FROM dogs 
# 		WHERE id = ?
# 		LIMIT 1
# 	SQL
		
# 	 attributes = DB[:conn].execute(sql, id_query)
# 	 new_from_db(attributes)
# end







end
