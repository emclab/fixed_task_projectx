require 'spec_helper'

module FixedTaskProjectx
  describe ProjectsController do
    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
    end
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
      @cust = FactoryGirl.create(:kustomerx_customer)
      @proj_type = FactoryGirl.create(:simple_typex_type)
      @proj_type1 = FactoryGirl.create(:simple_typex_type, :name => 'newnew')
      @task_def = FactoryGirl.create(:commonx_misc_definition, :for_which => 'project_task_definition', :active => true)
      @proj_status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'project_status', :active => true, :name => 'proj status')
      @tt = FactoryGirl.create(:task_templatex_template, :active => true, :last_updated_by_id => @u.id, :type_id => @proj_type.id)
      @tt1 = FactoryGirl.create(:task_templatex_template, :active => true, :last_updated_by_id => @u.id, :type_id => @proj_type1.id, :name => 'newnew')
    end
      
    render_views
    
    describe "GET 'index'" do
      it "returns all projects for regular user" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'fixed_task_projectx_projects', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "FixedTaskProjectx::Project.where(:cancelled => false).order('id')")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:fixed_task_projectx_project, :cancelled => false, :last_updated_by_id => @u.id, :task_template_id => @tt.id)
        qs1 = FactoryGirl.create(:fixed_task_projectx_project, :cancelled => false, :last_updated_by_id => @u.id, :task_template_id => @tt1.id, :project_num => '23444',  :name => 'newnew')
        get 'index' , {:use_route => :fixed_task_projectx}
        assigns(:projects).should =~ [qs, qs1]       
      end
      
      it "should return project for the project_type" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'fixed_task_projectx_projects', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "FixedTaskProjectx::Project.where(:cancelled => false).order('id')")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:fixed_task_projectx_project, :cancelled => false, :last_updated_by_id => @u.id, :task_template_id => @tt.id)
        qs1 = FactoryGirl.create(:fixed_task_projectx_project, :cancelled => true, :last_updated_by_id => @u.id, :task_template_id => @tt1.id, :project_num => '4355556', :name => 'newnew')
        get 'index' , {:use_route => :fixed_task_projectx, :task_template_id => @tt.id}
        assigns(:projects).should eq([qs])
      end
      
    end
  
    describe "GET 'new'" do
      
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'fixed_task_projectx_projects', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new' , {:use_route => :fixed_task_projectx, :task_template_id => @tt.id}
        response.should be_success
      end
           
    end
  
    describe "GET 'create'" do
      it "redirect for a successful creation" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'fixed_task_projectx_projects', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.attributes_for(:fixed_task_projectx_project)
        get 'create' , {:use_route => :fixed_task_projectx, :task_template_id => @tt.id, :project => qs}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'fixed_task_projectx_projects', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.attributes_for(:fixed_task_projectx_project, :name => nil)
        get 'create' , {:use_route => :fixed_task_projectx, :task_template_id => @tt.id, :project => qs}
        response.should render_template("new")
      end
    end
  
    describe "GET 'edit'" do
      
      it "returns http success for edit" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'fixed_task_projectx_projects', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:fixed_task_projectx_project, :customer_id => @cust.id)
        get 'edit' , {:use_route => :fixed_task_projectx, :task_template_id => @tt.id, :id => qs.id}
        response.should be_success
      end
      
    end
  
    describe "GET 'update'" do
      
      it "redirect if success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'fixed_task_projectx_projects', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:fixed_task_projectx_project)
        get 'update' , {:use_route => :fixed_task_projectx, :task_template_id => @tt.id, :id => qs.id, :project => {:name => 'newnew'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'fixed_task_projectx_projects', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:fixed_task_projectx_project)
        get 'update' , {:use_route => :fixed_task_projectx, :task_template_id => @tt.id, :id => qs.id, :project => {:name => nil}}
        response.should render_template("edit")
      end
    end
  
    describe "GET 'show'" do
      
      it "should show" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'fixed_task_projectx_projects', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:fixed_task_projectx_project)
        get 'show' , {:use_route => :fixed_task_projectx, :task_template_id => @tt.id, :id => qs.id}
        response.should be_success
      end
    end
  end
end
