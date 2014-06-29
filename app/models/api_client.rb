class ApiClient

  attr_accessor :api_client, :authorization, :api

  def initialize(user_auth, api)
    self.api_client = GOOGLE_API_CLIENT
    self.authorization = (
      auth = self.api_client.authorization.dup
      auth.update_token!(user_auth)
      auth
    )
    self.api = api

  end

  def request(endpoint)
    api_method = endpoint.split('.').inject(self.api) do |call_chain, method|
      raise 'No such endpoint' unless call_chain.respond_to?(method)
      call_chain.public_send(method)
    end

    response = self.api_client.execute(api_method: api_method,
                                       authorization: self.authorization)

    # TODO: Handle errors
    response.data
  end

end