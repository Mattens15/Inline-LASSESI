Rails.application.routes.draw do
  resources :rooms
  resources :has_powers
  resources :prenotaziones
	resources :users
	
	get 'map'					=> 'mapbox#show'
  get 'signup'			=> 'users#new'
  
end
	
