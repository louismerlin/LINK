white_bread = Bread.new(:type => "white").save
wheat_bread = Bread.new(:type => "wheat").save

big_slice = Slice.new(:width => 5).save
small_slice = Slice.new(:width => 0.5).save

white_bread.add_slice(small_slice)
wheat_bread.add_slice(big_slice)
