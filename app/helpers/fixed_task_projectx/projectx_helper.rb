module FixedTaskProjectx
  module ProjectxHelper
    include Authentify::SessionsHelper
    include Authentify::UserPrivilegeHelper


    def return_customers
      access_rights, model_ar_r, has_record_access = access_right_finder('index', FixedTaskProjectx.customer_class.to_s.underscore.pluralize)
      return [] if access_rights.blank?
      return model_ar_r #instance_eval(access_rights.sql_code) #.present?
    end
    
    def return_projects_by_access_right
      access_rights, model_ar_r, has_record_access = access_right_finder('index', params[:controller])
      return [] if access_rights.blank?
      return model_ar_r 
    end

    
  end
end
