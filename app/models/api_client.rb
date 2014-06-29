class ApiClient

  attr_accessor :api_client, 
                :authorization, 
                :api

  CREATE_API = 'files.insert'
  MIME_TYPES = {
    'folder' => 'application/vnd.google-apps.folder',
    'file' => 'application/vnd.google-apps.document'
  }

  def initialize(user_auth, api)
    self.api_client = GOOGLE_API_CLIENT
    self.authorization = (
      auth = self.api_client.authorization.dup
      auth.update_token!(user_auth)
      auth
    )
    self.api = api
  end

  def create(title, type)
    schema = self.api.files.insert.request_schema.new({
      'title' => title,
      'mimeType' => MIME_TYPES[type]
    })
    file = self.api_client.execute(
      api_method: parse_method(CREATE_API),
      authorization: self.authorization,
      body_object: schema).data
  end

  def request(endpoint, parameters = nil)
    options = {
      api_method: parse_method(endpoint),
      authorization: self.authorization
    }
    options[:parameters] = parameters if parameters
    response = self.api_client.execute(options)

    # TODO: Handle errors
    response.data
  end

  protected

  def parse_method(endpoint)
    endpoint.split('.').inject(self.api) do |call_chain, method|
      raise 'No such endpoint' unless call_chain.respond_to?(method)
      call_chain.public_send(method)
    end
  end

end