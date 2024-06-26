# frozen_string_literal: true
#
# OVERRIDE class from blacklight v6.25.0
# Customization:
# Only check for current_user instead of current_or_guest.
# Prevent route error in the front end as it generates the more facet link as it sets to 'advanced'
#
# Filters added to this controller apply to all controllers in the hosting application
# as this module is mixed-in to the application controller in the hosting app on installation.
#
module Blacklight::Controller
  extend ActiveSupport::Concern
  extend Deprecation
  self.deprecation_horizon = 'blacklight 7.x'

  included do
    include Blacklight::SearchFields
    helper Blacklight::SearchFields if respond_to? :helper

    include ActiveSupport::Callbacks

    # now in application.rb file under config.filter_parameters
    # filter_parameter_logging :password, :password_confirmation
    after_action :discard_flash_if_xhr

    # handle basic authorization exception with #access_denied
    rescue_from Blacklight::Exceptions::AccessDenied, :with => :access_denied

    if respond_to? :helper_method
      helper_method :current_user_session, :current_user, :current_or_guest_user

      # extra head content
      helper_method :has_user_authentication_provider?
      helper_method :blacklight_config, :blacklight_configuration_context
      helper_method :search_action_url, :search_action_path, :search_facet_path
      helper_method :search_state
    end

    # Specify which class to use for the search state. You can subclass SearchState if you
    # want to override any of the methods (e.g. SearchState#url_for_document)
    class_attribute :search_state_class
    self.search_state_class = Blacklight::SearchState

    # This callback runs when a user first logs in

    define_callbacks :logging_in_user
    set_callback :logging_in_user, :before, :transfer_guest_user_actions_to_current_user
  end

  def default_catalog_controller
    CatalogController
  end

  delegate :blacklight_config, to: :default_catalog_controller

    protected

    ##
    # Context in which to evaluate blacklight configuration conditionals
    def blacklight_configuration_context
      @blacklight_configuration_context ||= Blacklight::Configuration::Context.new(self)
    end

    ##
    # Determine whether to render the bookmarks control
    # (Needs to be available globally, as it is used in the navbar)
    def render_bookmarks_control?



      ### CUSTOMIZATION
      # Only check for current_user instead of current_or_guest
      # as guest users cause template errors on collection gallery view
      has_user_authentication_provider? and current_user

      ### END CUSTOMIZATION



    end

    ##
    # Determine whether to render the saved searches link
    # (Needs to be available globally, as it is used in the navbar)
    def render_saved_searches?
      has_user_authentication_provider? and current_user
    end

    # @return [Blacklight::SearchState] a memoized instance of the parameter state.
    def search_state
      @search_state ||= begin
        if search_state_class.instance_method(:initialize).arity == -3
          search_state_class.new(params, blacklight_config, self)
        else
          Deprecation.warn(search_state_class, "The constructor for #{search_state_class} now requires a third argument. " \
            "Invoking it will 2 arguments is deprecated and will be removed in Blacklight 7.")
          search_state_class.new(params, blacklight_config)
        end
      end
    end

    # Default route to the search action (used e.g. in global partials). Override this method
    # in a controller or in your ApplicationController to introduce custom logic for choosing
    # which action the search form should use
    def search_action_url options = {}
      # Rails 4.2 deprecated url helpers accepting string keys for 'controller' or 'action'
      search_catalog_url(options.except(:controller, :action))
    end

    def search_action_path *args
      if args.first.is_a? Hash
        args.first[:only_path] = true
      end

      search_action_url(*args)
    end

    def search_facet_url options = {}
      opts = search_state.to_h.merge(action: "facet").merge(options).except(:page)



      ### CUSTOMIZATION
      # just override this and set it to catalog controller
      # so it doesn't complain about no route error in the
      # front end as it generates the more facet link as it sets to 'advanced'
      opts['controller'] = 'catalog' if opts['controller'].eql?('advanced')

      ### END CUSTOMIZATION



      url_for opts
    end
    deprecation_deprecate search_facet_url: 'Use search_facet_path instead.'

    def search_facet_path(options = {})
      Deprecation.silence(Blacklight::Controller) do
        search_facet_url(options.merge(only_path: true))
      end
    end

    # Returns a list of Searches from the ids in the user's history.
    def searches_from_history
      session[:history].blank? ? Search.none : Search.where(:id => session[:history]).order("updated_at desc")
    end

    # Should be provided by authentication provider
    # def current_user
    # end
    # def current_or_guest_user
    # end

    # Here's a stub implementation we'll add if it isn't provided for us
    def current_or_guest_user
      if defined? super
        super
      elsif has_user_authentication_provider?
        current_user
      end
    end
    alias blacklight_current_or_guest_user current_or_guest_user

    ##
    # We discard flash messages generated by the xhr requests to avoid
    # confusing UX.
    def discard_flash_if_xhr
      flash.discard if request.xhr?
    end
    deprecation_deprecate discard_flash_if_xhr: "Discarding flash messages on XHR requests is deprecated.
      If you wish to continue this behavior, add this method to your ApplicationController with an
      after_action :discard_flash_if_xhr filter. To disable this behavior now and remove this warning, add
      a skip_after_action :discard_flash_if_xhr to your ApplicationController."

    ##
    #
    #
    def has_user_authentication_provider?
      respond_to? :current_user
    end

    def require_user_authentication_provider
      raise ActionController::RoutingError, 'Not Found' unless has_user_authentication_provider?
    end

    ##
    # When a user logs in, transfer any saved searches or bookmarks to the current_user
    def transfer_guest_user_actions_to_current_user
      return unless respond_to? :current_user and respond_to? :guest_user and current_user and guest_user
      current_user_searches = current_user.searches.pluck(:query_params)
      current_user_bookmarks = current_user.bookmarks.pluck(:document_id)

      guest_user.searches.reject { |s| current_user_searches.include?(s.query_params)}.each do |s|
        current_user.searches << s
        s.save!
      end

      guest_user.bookmarks.reject { |b| current_user_bookmarks.include?(b.document_id)}.each do |b|
        current_user.bookmarks << b
        b.save!
      end

      # let guest_user know we've moved some bookmarks from under it
      guest_user.reload if guest_user.persisted?
    end

    ##
    # To handle failed authorization attempts, redirect the user to the
    # login form and persist the current request uri as a parameter
    def access_denied
      # send the user home if the access was previously denied by the same
      # request to avoid sending the user back to the login page
      #   (e.g. protected page -> logout -> returned to protected page -> home)
      redirect_to root_url and flash.discard and return if request.referer and request.referer.ends_with? request.fullpath

      redirect_to root_url and return unless has_user_authentication_provider?

      redirect_to new_user_session_url(:referer => request.fullpath)
    end
end
