module FixedTaskProjectx
  class Project < ActiveRecord::Base
    
    after_initialize :default_init, :if => :new_record?
      
    attr_accessor :sales_name, :last_updated_by_name, :project_manager_name, :status_name, :expedite_noupdate, :cancelled_noupdate, :completed_noupdate

    attr_accessible :cancelled, :completed, :delivery_date, :end_date, :est_delivery_date, :expedite, :instruction, 
                    :last_updated_by_id, :name, :project_desp, :project_manager_id, :project_num, :sales_id, :start_date, 
                    :status_id, :task_template_id,  :customer_id,
                    :customer_name_autocomplete, :sales_id, 
                    :as => :role_new
                      
    attr_accessible :cancelled, :completed, :delivery_date, :end_date, :est_delivery_date, :expedite, :instruction, 
                    :last_updated_by_id, :name, :project_desp, :project_manager_id, :project_num, :sales_id, :start_date, 
                    :status_id, :task_template_id, :customer_id,
                    :customer_name_autocomplete, :sales_id, 
                    :sales_name, :last_updated_by_name, :project_manager_name, :status_name, :expedite_noupdate, :cancelled_noupdate, :completed_noupdate, 
                    :as => :role_update


    attr_accessor :project_id_s, :keyword_s, :start_date_s, :end_date_s, :customer_id_s, :status_s, :expedite_s,
                  :zone_id_s, :sales_id_s, :project_task_template_id_s, 
                  :time_frame_s

    attr_accessible :project_id_s, :keyword_s, :start_date_s, :end_date_s, :customer_id_s, :status_s, :expedite_s,
                    :zone_id_s, :sales_id_s, :project_task_template_id_s, :time_frame_s,
                    :as => :role_search_stats

                    
    belongs_to :status, :class_name => 'Commonx::MiscDefinition'
    belongs_to :customer, :class_name => FixedTaskProjectx.customer_class.to_s
    belongs_to :sales, :class_name => 'Authentify::User'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :project_manager, :class_name => 'Authentify::User'
    belongs_to :task_template, :class_name => FixedTaskProjectx.task_template_class.to_s
    
    validates :name, :presence => true,
                     :uniqueness => {:case_sensitive => false, :message => I18n.t('Duplicate Name!')}
    validates :project_num, :presence => true, 
                            :uniqueness => {:case_sensitive => false, :message => I18n.t('Duplicate Project Number')}
    validates_presence_of :start_date 
    validates :task_template_id, :customer_id, :status_id, :presence => true,
                                 :numericality => {:greater_than => 0} 
    validates :sales_id, :presence => true,
                         :numericality => {:greater_than => 0} if :require_sales

    def require_sales
      return Authentify::AuthentifyUtility.find_config_const('project_has_sales', 'fixed_task_projectx') == 'true'
    end

    def default_init
      project_num_time_gen = Authentify::AuthentifyUtility.find_config_const('project_num_time_gen', 'fixed_task_projectx')
      self.project_num = eval(project_num_time_gen)
    end

    def customer_name_autocomplete
      self.customer.try(:name)
    end

    def customer_name_autocomplete=(name)
      self.customer = FixedTaskProjectx.customer_class.find_by_name(name) if name.present?
    end
  end
end
