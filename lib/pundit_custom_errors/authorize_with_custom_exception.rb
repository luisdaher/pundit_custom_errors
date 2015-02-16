# Module created to override Pundit's 'authorize' function. It enables Pundit to
# use the 'error' attribute (if existent) inside a Policy object to display
# the given error message instead of a default error message.
module AuthorizeWithCustomException
  def authorize(record, query = nil)
    query ||= params[:action].to_s + '?'
    @_pundit_policy_authorized = true
    policy = policy(record)
    fail generate_error_for(policy, query, record) unless policy.public_send(query)
    true
  end

  def generate_error_for(policy, query, record)
    error = policy.error
    error ||= Pundit::NotAuthorizedError.new(
      translate_error_message_for_query(query, policy)
    )
    error.query, error.record, error.policy = query, record, policy
    error
  end

  def translate_error_message_for_query(query, policy)
    t("#{policy.class.to_s.underscore}.#{query}",
      scope: 'pundit',
      default: :default)
  end
end

# The module is being prepended here.
module Pundit
  prepend AuthorizeWithCustomException
end
