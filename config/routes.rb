# frozen_string_literal: true

Rails.application.routes.draw do
  get 'app_info', to: 'app_info#index'
  get 'welcome/index'
  root 'welcome#index'
end
