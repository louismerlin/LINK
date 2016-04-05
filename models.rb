if !File.exists?("./boilerplate.db") || settings.environment == :test

  # IF YOU DO CHANGES HERE, DELETE THE FILE 'boilerplate.db'

  if settings.environment == :test
    DB = Sequel.sqlite
  else
    DB = Sequel.connect("sqlite://boilerplate.db")
  end

  DB.create_table :breads do
    primary_key :id
    String      :type
  end

  DB.create_table :slices do
    primary_key :id
    Float       :width
    foreign_key :bread_id
  end

else
  DB = Sequel.connect("sqlite://boilerplate.db")
end


class Bread < Sequel::Model
  one_to_many :slices
end

class Slice < Sequel::Model
  many_to_one :bread
end
