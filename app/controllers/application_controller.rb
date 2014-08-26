class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def check_valid_user
      unless current_user
        redirect_to :back, notice: "You must login to or sign up to user this feature"
        return
      end
  end

  def create
    # The subclasses need to set @item 
    # They may set @redirect if it is not the same as @item
    @redirect ||= @item 
    respond_to do |format|
      if @item.save
        format.html { html_success_says 'created' }
        format.json { json_success_says :created }
      else
        format.html { render :new }
        format.json { json_failure_says }
      end
    end
  end

  def update
    # The subclasses need to set @item and @current_parameters
    # They may set @redirect if it is not the same as @item
    @redirect ||= @item 
    
    respond_to do |format|
      if @item.update(@current_parameters)
        format.html { html_success_says 'updated' }
        format.json { json_success_says :ok }
      else
        format.html { render :edit }
        format.json { json_failure_says }
      end
    end
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  private

  def html_success_says action
    redirect_to @redirect, notice: "#{@item.class.to_s} was successfully #{action}."
  end

  def json_success_says status
    render :show, status: status, location: @redirect
  end

  def json_failure_says 
    render json: @item.errors, status: :unprocessable_entity
  end

end

