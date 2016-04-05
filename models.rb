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
    Integer     :kind # 0:conversation; 1:group
    String      :name
  end

  DB.create_table :links do
    primary_key :id
    String      :url
    String      :description
    Datetime    :sent
    Datetime    :read
    foreign_key :user_id
    foreign_key :channel_id
  end

  DB.create_join_table(:user_id=>:users, :channel_id=>:channels)


else
  DB = Sequel.connect("sqlite://link.db")
end

class User < Sequel::Model
  plugin :secure_password
  many_to_many :channels
  one_to_many :links
end

class Channel < Sequel::Model
  many_to_many :users
  one_to_many :links
end

class Link < Sequel::Model
  many_to_one :user
  many_to_one :channel
end
