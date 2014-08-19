class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def respond_to_create params
    @params = parse_params_for_respond_to params
    thing    = @params[:thing]
    redirect = @params[:redirect]
    name     = @params[:name]

    respond_to do |format|
      if thing.save
        format.html { redirect_to redirect, notice: "#{name} was successfully created." }
        format.json { render :show, status: :created, location: redirect }
      else
        format.html { render :new }
        format.json { render json: thing.errors, status: :unprocessable_entity }
      end
    end
  end

  def respond_to_update params
    @params = parse_params_for_respond_to params
    thing    = @params[:thing]
    redirect = @params[:redirect]
    name     = @params[:name]
    thing_params = params[:thing_params] ? params[:thing_params] : eval(thing.class.to_s.downcase.sub(/$/, "_params"))

    respond_to do |format|
      if thing.update(thing_params)
        format.html { redirect_to redirect, notice: "#{name} was successfully updated." }
        format.json { render :show, status: :created, location: redirect }
      else
        format.html { render :edit }
        format.json { render json: thing.errors, status: :unprocessable_entity }
      end
    end
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


  def parse_params_for_respond_to params
    $params = params
    $thing  = $params[:thing]
    $params[:redirect]     ||= $thing
    $params[:name]         ||= $thing.class.to_s
    #$params[:thing_params] ||= eval($thing.class.to_s.downcase.sub(/$/, "_params"))
    $params
  end
    

end
