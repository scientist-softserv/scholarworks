Rails.application.routes.draw do
  concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new
  mount BrowseEverything::Engine => '/browse'
  concern :oai_provider, BlacklightOaiProvider::Routes.new

  mount Riiif::Engine => 'images', as: :riiif if Hyrax.config.iiif_image_server?
  mount Blacklight::Engine => '/'
  mount BlacklightAdvancedSearch::Engine => '/'


  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :oai_provider
    concerns :searchable
    concerns :range_searchable
  end

  devise_for :users, controllers: { sessions: 'users/sessions', omniauth_callbacks: 'users/omniauth_callbacks' }, skip: [:sessions]
  devise_scope :user do
    get 'sign_in', to: 'users/sessions#new', as: :new_user_session
    post '/users/sign_in', to: 'users/sessions#create', as: :user_session
    post 'sign_in', to: 'omniauth_callbacks#shibboleth', as: :new_session
    get 'sign_out', to: 'users/sessions#destroy', as: :destroy_user_session
  end
  mount Hydra::RoleManagement::Engine => '/'

  mount Qa::Engine => '/authorities'
  mount Hyrax::Engine, at: '/'
  resources :welcome, only: 'index'
  resources :glacier_sns_download_requests, only: [:create] do
    collection do
      post "unarchive_complete_sns"
    end
  end
  root 'hyrax/homepage#index'
  curation_concerns_basic_routes
  concern :exportable, Blacklight::Routes::Exportable.new

  require 'sidekiq/web'

  # For development use, uncomment and set gems to env
  # mount Sidekiq::Web => '/sidekiq'

  # For production use (block) of sidekiq webapp
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :oai_provider
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  mount WillowSword::Engine, at: "/sword"
  get '/robots.txt', to: 'robots#index'

  get 'collections', to: 'collections#index'
  get 'collections/children/:parent_id', to: 'collections#children'

  get 'campus/:campus', to: 'campus#index'

  get '*unmatched_route', to: 'application#not_found'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
