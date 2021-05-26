# frozen_string_literal: true

# responds with JSON and an HTTP status code (200 by default
module ResponseJsonHandler
  def json_response(object, status = :ok)
    render json: object, status: status
  end
end
