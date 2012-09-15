# redis-Keyring

Simple redis key management system.

## Features
Uses the ever so useful method_missing of ruby to make specifying keys short and beautiful.

    keyring = Keyring::Key.new("myapp")
    
    new_id = redis.incr(keyring.user_count) # increments the key "myapp:user_count"
    redis.set(keyring.user.id(new_id).name,"james") # sets the key "myapp:user:1:name"

Can generate a key directory for easily finding keys you're using in your app. 
    
    Keyring::Key.generate_stats("redis-keys.txt") # add to spec_helper.rb or your main test helper, on exit redis-keys.txt is generated
    
Generates something like this for the above example

    # Legend (* - tainted variables), (@ - clean variables)
    myapp:user:@id:name
    myapp:user_count



## Installation

Add this line to your application's Gemfile:

    gem 'redis-keyring'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install redis-keyring

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
