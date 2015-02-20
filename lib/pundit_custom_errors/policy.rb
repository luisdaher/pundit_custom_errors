module PunditCustomErrors
  class Policy
    attr_reader :error

    def generate_error(message)
      self.error = Pundit::NotAuthorizedError.new(message)
    end
  end
end
