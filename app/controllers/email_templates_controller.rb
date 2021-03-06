class EmailTemplatesController < BaseController
   
  before_action :check_manager 

  def index
  	@email_templates = EmailTemplate.default_templates(current_user.id)
  end	

  # Compose custom email before send
  def compose_email
  	@email_template = EmailTemplate.where(id: params[:id]).last
  	if @email_template.blank? || (@email_template.user_id.present? && @email_template.user_id != current_user.id)
  	  redirect_to root_path	
  	else
  	  @user_ids = current_user.lead_generators.collect(&:id) << current_user.id
    end 
  end	

  # Send email
  def send_email 
    EmailConversation.save_email(params, current_user)
    redirect_to email_templates_path
  end

  def new
  	@email_template = EmailTemplate.new
  end

  def create
  	EmailTemplate.create(email_template_params)
  	redirect_to email_templates_path
  end	

  private
  def email_template_params
  	params[:email_template][:user_id] = current_user.id
  	params.require(:email_template).permit(:subject, :content, :user_id)
  end	


end
