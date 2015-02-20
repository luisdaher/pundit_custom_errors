require 'pundit_custom_errors/version'
require 'pundit_custom_errors/policy'
require 'pundit_custom_errors/authorization'

# The 'PunditCustomErrors::Authorization' module is being prepended here.
module Pundit
  prepend PunditCustomErrors::Authorization
end
