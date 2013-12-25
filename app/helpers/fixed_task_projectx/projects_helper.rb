module FixedTaskProjectx
  module ProjectsHelper
    def return_task_definitions
      Commonx::CommonxHelper.return_misc_definitions('project_task_definition')
    end

    def return_project_task_templates
      FixedTaskProjectx.task_template_class.where(:active => true).order('ranking_order')
    end
    
    def return_project_types
      FixedTaskProjectx.project_type_class.where(:active => true).order('ranking_order')
    end
    
    def return_task_definitions
      Commonx::CommonxHelper.return_misc_definitions('project_task_definition')
    end

  end
end
