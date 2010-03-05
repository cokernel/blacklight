module Blacklight::Controller::Application
  
  # this could be used when calling #plugin ->
  
  # def self.configure controller, opts = {}
  #   opts = {:setup => true}.merge(opts)
  #   controller.instance_eval do
  #     helper :all # include all helpers, all the time
  #     protect_from_forgery # See ActionController::RequestForgeryProtection for details
  #     filter_parameter_logging :password, :password_confirmation  
  #     helper_method :current_user_session, :current_user
  #     helper_method [:request_is_for_user_resource?]#, :user_logged_in?]
  #     layout :choose_layout
  #   end if opts[:setup]
  # end
  # 
  # module ClassMethods
  #   
  # end
  
  def self.included base
    base.instance_eval do
      helper :all # include all helpers, all the time
      protect_from_forgery # See ActionController::RequestForgeryProtection for details
      filter_parameter_logging :password, :password_confirmation  
      helper_method :current_user_session, :current_user
      helper_method [:request_is_for_user_resource?]#, :user_logged_in?]
      layout :choose_layout
    end
    base.send :include, InstanceMethods
  end
  
  module InstanceMethods

    def user_class; User; end
  
    # test for exception notifier plugin
    def error
      raise RuntimeError, "Generating a test error..."
    end
  
    protected
    
    # Returns a list of Searches from the ids in the user's history.
    def searches_from_history
      session[:history].blank? ? [] : Search.find(session[:history]) rescue []
    end
  
    #
    # Controller and view helper for determining if the current url is a request for a user resource
    #
    def request_is_for_user_resource?
      request.env['PATH_INFO'] =~ /\/?users\/?/
    end
  
    #
    # If a param[:no_layout] is set OR
    # request.env['HTTP_X_REQUESTED_WITH']=='XMLHttpRequest'
    # don't use a layout, otherwise use the "application.html.erb" layout
    #
    def choose_layout
      'application' unless request.xml_http_request? || ! params[:no_layout].blank?
    end
  
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
    
  end
  
end