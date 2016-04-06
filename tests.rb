tests = []

# Users
user_1 = User.new(first_name:"Louis", last_name:"Merlin", email:"louis.merlin@epfl.ch", username:"louismerlin")
user_1.password = "merlin"
user_1.password_confirmation = "merlin"
user_1.save

tests << Proc.new { User.all.first.first_name == "Louis" }
tests << Proc.new { User.all.first.password != "merlin" }

#Chanels
channel_1 = Channel.new(kind:0).save
user_2 = User.new(username:"hugoroussel")
user_2.password = "roussel"
user_2.password_confirmation = "roussel"
user_2.save
channel_1.add_user(user_1)
channel_1.add_user(user_2)

tests << Proc.new { User.all.first.channels.first == channel_1 }
tests << Proc.new { User.all.first.channels.first.users.select{|u| u!= User.all.first}[0] == user_2 }

#Links
link_1 = Link.new(url:"http://www.reddit.com", description:"The frontpage of the internet", sent:Time.now()).save
link_2 = Link.new(url:"http://news.ycombinator.com", description:"Hacker News", sent:Time.now()).save
user_1.add_link(link_1)
channel_1.add_link(link_1)
user_2.add_link(link_2)
channel_1.add_link(link_2)

tests << Proc.new { User.all.first.links.first.url == "http://www.reddit.com" }
tests << Proc.new { channel_1.links.count == 2 }


### THIS IS WHERE THE TESTING TAKES PLACE ###
puts "\e[#{32}mAll tests passed gracefully\e[0m" if tests.all?{|p|
  if p.call()
    true
  else
    puts "\e[#{31}mThe test at line (" + p.source_location[1].to_s + ") failed miserably...\e[0m"
    false
  end
}
