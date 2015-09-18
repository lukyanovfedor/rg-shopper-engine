# Shopper

[![Code Climate](https://codeclimate.com/github/lukyanovfedor/rg-shopper-engine/badges/gpa.svg)](https://codeclimate.com/github/lukyanovfedor/rg-shopper-engine)
[![Test Coverage](https://codeclimate.com/github/lukyanovfedor/rg-shopper-engine/badges/coverage.svg)](https://codeclimate.com/github/lukyanovfedor/rg-shopper-engine/coverage)
[![Build Status](https://travis-ci.org/lukyanovfedor/rg-shopper-engine.svg?branch=master)](https://travis-ci.org/lukyanovfedor/rg-shopper-engine)

Rails engine that transform your rails app into simple online store

## Getting started

Add in your gemfile and bundle

```ruby
gem 'shopper', git: 'https://github.com/lukyanovfedor/rg-shopper-engine.git'
```

After gem install, copy migrations and run db:migrate
```console
rake shopper:install:migrations
rake db:migrate
```

Next, you need to mount shopper to your app, add in config/routes.rb
```ruby
mount Shopper::Engine => '/cart', as: 'shopper'
```

Then you can easily register products with :register_as_product
```ruby
class MyAwesomeProduct < ActiveRecord::Base
  register_as_product
end
```

and register customer with :register_as_customer
```ruby
class User < ActiveRecord::Base
  register_as_customer
end
```

also it's important to have in your ApplicationController method :current_user
```ruby
class ApplicationController < ActionController::Base
  def current_user
    @user
  end
end
```
