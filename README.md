# PunditCustomErrors
[![Build Status](https://travis-ci.org/luisdaher/pundit_custom_errors.svg)](https://travis-ci.org/luisdaher/pundit_custom_errors) [![Code Climate](https://codeclimate.com/github/luisdaher/pundit_custom_errors/badges/gpa.svg)](https://codeclimate.com/github/luisdaher/pundit_custom_errors) [![Test Coverage](https://codeclimate.com/github/luisdaher/pundit_custom_errors/badges/coverage.svg)](https://codeclimate.com/github/luisdaher/pundit_custom_errors) [![Inline docs](http://inch-ci.org/github/luisdaher/pundit_custom_errors.svg?branch=master)](http://inch-ci.org/github/luisdaher/pundit_custom_errors)

`pundit_custom_errors` is an extension for the [Pundit gem](https://github.com/elabs/pundit) that enables the creation of custom error messages. This adds more flexibility to retrieve different kinds of messages in the same validation method, according to the nature of the error. As for the default error message, it is also set up to generate them by using a localization file (if existent).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pundit_custom_errors'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pundit_custom_errors

## Getting Started

(Note: since this gem is intended to extend [Pundit's](https://github.com/elabs/pundit) capabilities, it is assumed that you're already familiar with it. If not, It is highly recommended that you take a look at [Pundit's documentation](https://github.com/elabs/pundit#pundit) first.)

For this example, let's suppose there's already a standard `Policy` class for an object (`Post`, in this case), called `PostPolicy`, containing a validation for the `show` action. It would look like this:

```ruby
  class PostPolicy
    def show?
      # dummy validation code for the 'show' action
      false
    end
  end
```

Since the `show?` method is returning `false`, this example will always throw a `Pundit::NotAuthorizedError`, with Pundit's default error message inside. As said before, this behavior can be changed by either setting a message in an attribute inside the `Policy` class or creating default messages for the actions' validation methods inside a localization YAML file. Both approaches are explained below.

### Setting a message in an attribute inside the `Policy` class

In order to set custom messages, the first thing to be done is to create the `error_message` attribute with `attr_accessor` permissions inside the desired `Policy` class. The `PostPolicy` class will look like this:

```ruby
  class PostPolicy
    attr_accessor :error_message

    def show?
      # dummy validation code for the 'show' action
      false
    end
  end
```

By putting that attribute inside a class, every time a validation method returns false, `Pundit` will try to use the `error_message`. If there's something set there (like the example below), `Pundit` will use it as the error message.

```ruby
  class PostPolicy
    attr_accessor :error_message

    def show?
      @error_message = "You're not allowed to see this. Better luck next time!"

      # dummy validation code for the 'show' action
      false
    end
  end
```

As the message is set, every time the `show?` method returns false, the message present inside `error_message` will be put inside the `Pundit::NotAuthorizedError` instance.

### Creating default error messages inside a YAML file

#### Creating the YAML file

By running the command:

    $ rails generate pundit_custom_errors:initialize

A file called `pundit_custom_errors.en.yml` will be generated inside the `config/locales` folder. It contains the default message, used if there's no messages for the given controller/action validation.

#### Creating error messages in the localization file

The `policy` keys must be the snake case representation of the given policy classes, containing action names as keys (e.g: `show?` and the message as value). Also, the `policy` hashes must be inside the `pundit` hash, inside the `en` (or the desired language abbreviation) hash.

In short, the YAML file structure should be similar as the example below:

```yaml
en:
  pundit:
    default: "You have requested a page that you do not have access to."
    post_policy:
      show?: "You're not allowed to see this."
```

## Message hierarchy

1. The gem will use the message present in the `error_message` attribute, that should be part of the given `Policy` class.
2. If there's no error message (or even the attribute, if `PunditCustomErrors::Policy` isn't being extended), it will use the message for the given action validation, present in the YAML file.
3. If there's no message for the given action validation in the YAML, it will use the YAML's default message inside `pundit` hash.
4. If there's no YAML default message, it will use the hardcoded message, behaving the same way as Pundit does today.

## Contributing

1. Fork it ( https://github.com/luisdaher/pundit_custom_errors/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
