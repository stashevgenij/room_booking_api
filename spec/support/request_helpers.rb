module Requests
  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body)
    end
  end

  module AuthenticationHelpers
    def user_headers(user)
      {'X-User-ID' => user.id}
    end
  end
end