# frozen_string_literal: true

Rails.application.routes.draw do
  resources :mentors do
    resources :bookings
  end
end
