# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ResponseJsonHandler
  include ExceptionHandler
end
