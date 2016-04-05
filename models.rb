if !File.exists?("./boilerplate.db") || settings.environment == :test

  # IF YOU DO CHANGES HERE, DELETE THE FILE 'boilerplate.db'

  if settings.environment == :test
    DB = Sequel.sqlite
  else
    DB = Sequel.connect("sqlite://boilerplate.db")
  end

  DB.create_table :channels do
    primary_key :id
    String      :name
    foreign_key :user_id
  end

  DB.create_table :users do
    primary_key :id
    String      :first_name
    String      :last_name
    String      :email
    String      :password_digest
    foreign_key :user_id

  end

  DB.create_table :links do
    primary_key :id
    String      :#HOW TO STORE AN URL?#
    Datetime    :h
  end

  DB.create_table :groups do

  end


else
  DB = Sequel.connect("sqlite://boilerplate.db")
end


class Channel < Sequel::Model
  many_to_many :users
end
#FIND A WAY TO CREATE #

class Group < Channel
  many_to_many :users
end

class Conversation < Channel
  many_to_many :users
end



class User < Sequel::Model
  plugin :secure_password
  many_to_many :Channels
  #many_to_many : users?#
end
