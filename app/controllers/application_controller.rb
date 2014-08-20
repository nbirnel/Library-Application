class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def respond_to_create params
    @params = parse_params_for_respond_to params
    @params[:render_on_fail] = :new
    @params[:method] = 'save'

    helper_for_respond_to @params
  end

  def respond_to_update params
    @params = parse_params_for_respond_to params
    #FIXME we probably don't need this conditional - noone passes method_params
    #@params[:method_params] = params[:method_params] ? params[:method_params] : eval(@params[:thing].class.to_s.downcase.sub(/$/, "_params"))
    @params[:method_params] = eval(@params[:thing].class.to_s.downcase.sub(/$/, "_params"))
    @params[:render_on_fail] = :edit
    @params[:method] = 'update'

    helper_for_respond_to @params

#    thing    = @params[:thing]
#    redirect = @params[:redirect]
#    name     = @params[:name]
#    respond_to do |format|
#      if thing.update(method_params)
#        format.html { redirect_to redirect, notice: "#{name} was successfully updated." }
#        format.json { render :show, status: :created, location: redirect }
#      else
#        format.html { render :edit }
#        format.json { render json: thing.errors, status: :unprocessable_entity }
#      end
#    end
  end

  def respond_to_destroy params
    @params = parse_params_for_respond_to params
    thing    = @params[:thing]
    redirect = @params[:redirect]
    name     = @params[:name]

    respond_to do |format|
      format.html { redirect_to redirect, notice: "#{name} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  
  def helper_for_respond_to params
    @p = params
    @p[:method_params] ||= nil
    @method = @p[:thing].method "#{@p[:method]}"
    respond_to do |format|
      if @method.call(@p[:method_params])
        format.html { redirect_to @p[:redirect], notice: "#{@p[:name]} was successfully created." }
        format.json { render :show, status: :created, location: @p[:redirect] }
      else
        format.html { render @p[:render_on_fail] }
        format.json { render json: @p[:thing].errors, status: :unprocessable_entity }
      end
    end
  end

  def parse_params_for_respond_to params
    $params = params
    $thing  = $params[:thing]
    $params[:redirect]     ||= $thing
    $params[:name]         ||= $thing.class.to_s
    #$params[:method_params] ||= eval($thing.class.to_s.downcase.sub(/$/, "_params"))
    $params
  end

end
