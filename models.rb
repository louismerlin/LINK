if !File.exists?("./link.db") || settings.environment == :test

  # IF YOU DO CHANGES HERE, DELETE THE FILE 'link.db'

  if settings.environment == :test
    DB = Sequel.sqlite
  else
    DB = Sequel.connect("sqlite://link.db")
  end

  DB.create_table :users do
    primary_key :id
    String      :first_name
    String      :last_name
    String      :email
    String      :username
    String      :password_digest
  end

  DB.create_table :channels do
    primary_key :id
    String      :name
    foreign_key :user_id
  end

  DB.create_table :links do
    primary_key :id
    String      :url
    String      :description
    Datetime    :sent
    Datetime    :read
  end

  DB.create_table :groups do

  end

  DB.create_join_table(:user_id=>)


else
  DB = Sequel.connect("sqlite://link.db")
end

class User < Sequel::Model
  plugin :secure_password
  many_to_many :Channels
  #many_to_many : users?#
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
