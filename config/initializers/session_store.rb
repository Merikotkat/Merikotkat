# Be sure to restart your server when you modify this file.

Merikotkat::Application.config.session_store :cookie_store, key: '_merikotkat_session_prod', expire_after: 3.hours if Rails.env.prod?
Merikotkat::Application.config.session_store :cookie_store, key: '_merikotkat_session', expire_after: 3.hours if !Rails.env.prod?
