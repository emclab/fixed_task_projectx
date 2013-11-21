require 'spec_helper'

describe "LinkTests" do
  describe "GET /fixed_task_projectx_link_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link'
        }
    before(:each) do
      @project_num_time_gen = FactoryGirl.create(:engine_config, :engine_name => 'fixed_task_projectx', :engine_version => nil, :argument_name => 'project_num_time_gen', :argument_value => ' FixedTaskProjectx::Project.last.nil? ? (Time.now.strftime("%Y%m%d") + "-"  + 112233.to_s + "-" + rand(100..999).to_s) :  (Time.now.strftime("%Y%m%d") + "-"  + (FixedTaskProjectx::Project.last.project_num.split("-")[-2].to_i + 555).to_s + "-" + rand(100..999).to_s)')
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      ua1 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'fixed_task_projectx_projects', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "FixedTaskProjectx::Project.where(:cancelled => false).order('id')")
      ua1 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'fixed_task_projectx_projects', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'fixed_task_projectx_projects', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "record.last_updated_by_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'fixed_task_projectx_projects', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'create_project', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        
      @cust = FactoryGirl.create(:kustomerx_customer)
      @proj_type = FactoryGirl.create(:simple_typex_type)
      @proj_type1 = FactoryGirl.create(:simple_typex_type, :name => 'newnew')
      @task_def = FactoryGirl.create(:commonx_misc_definition, :for_which => 'project_task_definition', :active => true)
      @proj_status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'project_status', :active => true, :name => 'proj status')
      @tt = FactoryGirl.create(:task_templatex_template, :active => true, :last_updated_by_id => @u.id, :type_id => @proj_type.id)
      @tt1 = FactoryGirl.create(:task_templatex_template, :active => true, :last_updated_by_id => @u.id, :type_id => @proj_type1.id, :name => 'newnew')
      
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => 'password'
      click_button 'Login'
      
    end
    it "works! (now write some real specs)" do
      qs = FactoryGirl.create(:fixed_task_projectx_project, :cancelled => false, :last_updated_by_id => @u.id, :task_template_id => @tt.id)
      visit projects_path(:task_template_id => @tt.id)
      #save_and_open_page
      page.should have_content('Projects')
      click_link 'New Project'
      #save_and_open_page
      page.should have_content('New Project')
      visit projects_path
      click_link qs.id.to_s
      page.should have_content('Project Info')
      click_link 'New Log'
      page.should have_content('Log')
      #save_and_open_page
      visit projects_path(:task_template_id => @tt.id)      
      click_link 'Edit'
      #save_and_open_page
      page.should have_content('Edit Project')
    end
  end
end
