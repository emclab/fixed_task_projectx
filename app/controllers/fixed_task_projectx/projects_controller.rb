require_dependency "fixed_task_projectx/application_controller"

module FixedTaskProjectx
  class ProjectsController < ApplicationController
    before_filter :require_employee
    before_filter :load_parent_record

    def index
      @title = t('Projects')
      @projects =  params[:fixed_task_projectx_projects][:model_ar_r]
      @projects = @projects.where(:task_template_id => @task_template.id) if @task_template
      @projects = @projects.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('project_index_view', 'fixed_task_projectx')
    end

    def new
      @title = t('New Project')
      @project = FixedTaskProjectx::Project.new
      @erb_code = find_config_const('project_new_view', 'fixed_task_projectx')
    end


    def create
      @project = FixedTaskProjectx::Project.new(params[:project], :as => :role_new)
      @project.last_updated_by_id = session[:user_id]
      if @project.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        flash[:notice] = t('Data Error. Not Saved!')
        @erb_code = find_config_const('project_new_view', 'fixed_task_projectx')
        render 'new'
      end
    end

    def edit
      @title = t('Edit Project')
      @project = FixedTaskProjectx::Project.find_by_id(params[:id])
      @erb_code = find_config_const('project_edit_view', 'fixed_task_projectx')
    end

    def update
        @project = FixedTaskProjectx::Project.find_by_id(params[:id])
        @project.last_updated_by_id = session[:user_id]
        if @project.update_attributes(params[:project], :as => :role_update)
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
        else
          flash[:notice] = t('Data Error. Not Updated!')
          @erb_code = find_config_const('project_edit_view', 'fixed_task_projectx')
          render 'edit'
        end
    end

    def show
      @title = t('Project Info')
      @project = FixedTaskProjectx::Project.find_by_id(params[:id])
      @erb_code = find_config_const('project_show_view', 'fixed_task_projectx')
    end
    
    protected
    def load_parent_record
      @task_template = FixedTaskProjectx.task_template_class.find_by_id(params[:task_template_id]) if params[:task_template_id].present?
      @task_template = FixedTaskProjectx.task_template_class.find_by_id(FixedTaskProjectx::Project.find_by_id(params[:id]).task_template_id) if params[:id].present?
    end

  end
end
