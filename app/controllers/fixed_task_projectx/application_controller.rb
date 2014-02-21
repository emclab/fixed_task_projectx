module FixedTaskProjectx
  class ApplicationController < ApplicationController
    include Authentify::SessionsHelper
    include Authentify::AuthentifyUtility
    include Authentify::UsersHelper
    include Authentify::UserPrivilegeHelper
    include Commonx::CommonxHelper
    include Searchx::SearchHelper
    
    before_filter :require_signin
    before_filter :max_pagination 
    before_filter :check_access_right 
    before_filter :load_session_variable, :only => [:new, :edit]  #for parent_record_id & parent_resource in check_access_right
    after_filter :delete_session_variable, :only => [:create, :update]   #for parent_record_id & parent_resource in check_access_right
    before_filter :view_in_config?
    
    def return_customers_by_access_right     
      access_rights, model_ar_r, has_record_access = access_right_finder('index', FixedTaskProjectx.customer_class.to_s.underscore.pluralize)
      return [] if access_rights.blank?
      return model_ar_r #instance_eval(access_rights.sql_code) #.present?
    end
    
    def return_projects_by_access_right
      access_rights, model_ar_r, has_record_access = access_right_finder('index', params[:controller])
      return [] if access_rights.blank?
      return model_ar_r 
    end

    def return_project_task_templates
      FixedTaskProjectx.task_template_class.where(:active => true).order('ranking_order')
    end
    
    def return_project_types
      FixedTaskProjectx.project_type_class.where(:active => true).order('ranking_order')
    end
    
    def return_yes_no_cn
      [['是',true ],['否', false]]
    end

    protected
  
    def max_pagination
      @max_pagination = find_config_const('pagination')
    end
    
    def view_in_config?
      @view_in_config = Authentify::AuthentifyUtility.load_view_in_config
    end
  end
end
