module Requests
  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body)
    end
  end

  module AuthenticationHelpers
    def sign_in(user)
      request.headers['X-User-ID'] = user.id
    end
  end
end