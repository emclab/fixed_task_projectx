require "fixed_task_projectx/engine"

module FixedTaskProjectx
  mattr_accessor :task_template_class, :customer_class, :index_task_path, :show_customer_path, :task_resource, :index_contract_path,
                 :index_payment_path, :contract_resource, :payment_resource, :project_type_class
  
  def self.project_class
    @@task_template_class.constantize
  end 
  
  def self.customer_class
    @@customer_class.constantize
  end
  
  def self.task_template_class
    @@task_template_class.constantize
  end
  
  def self.project_type_class
    @@project_type_class.constantize
  end
end

