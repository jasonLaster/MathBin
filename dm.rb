require 'rubygems'
require 'data_mapper' # requires all the gems listed above

# If you want the logs displayed you have to do this before the call to setup

# Create a new record
p = Person.new
p.attributes = {
  :firstname => 'John',
  :lastname => 'Doe',
  :email => 'john.doe@email.com'
}

# Save it to the database
p.save

# Make some changes to the object
p.lastname = 'Smith'
p.save

# Create a new object and destroy it
p2 = Person.new
p2.email = 'testing@testing.com'
p2.save

p2.destroy

# Find a record from the database
p3 = Person.get('john.doe@email.com')
puts p3.inspect
