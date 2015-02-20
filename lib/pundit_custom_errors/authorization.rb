# Module created to override Pundit's 'authorize' function. It enables Pundit to
# use the 'error_message' attribute (if existent) inside a Policy object to
# display the given error message instead of a default error message.
module PunditCustomErrors
  def authorize(record, query = nil)
    @_pundit_policy_authorized = true

    query ||= params[:action].to_s + '?'
    policy = policy(record)
    unless policy.public_send(query)
      fail generate_error_for(policy, query, record)
    end

    true
  end

  protected

  def generate_error_for(policy, query, record)
    message = policy.error_message
    message ||= translate_error_message_for_query(query, policy)
    message ||= "not allowed to #{query} this #{record}"

    error = Pundit::NotAuthorizedError.new(message)

    error.query, error.record, error.policy = query, record, policy
    error
  end

  def translate_error_message_for_query(query, policy)
    t("#{policy.class.to_s.underscore}.#{query}",
      scope: 'pundit',
      default: :default) if self.respond_to?(:t)
  end
end
