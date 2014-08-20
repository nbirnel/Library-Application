class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def respond_to_create args
    parse_args_for_respond_to args
    args[:render_on_fail] = :new
    args[:method] = 'save'

    helper_for_respond_to args
  end

  def respond_to_update args
    args = parse_args_for_respond_to args
    #FIXME we probably don't need this conditional - noone passes method_args
    #@args[:method_args] = args[:method_args] ? args[:method_args] : eval(@args[:thing].class.to_s.downcase.sub(/$/, "_args"))
    args[:method_args] = eval(args[:thing].class.to_s.downcase.sub(/$/, "_params"))
    args[:render_on_fail] = :edit
    args[:method] = 'update'

    helper_for_respond_to args

#    thing    = @args[:thing]
#    redirect = @args[:redirect]
#    name     = @args[:name]
#    respond_to do |format|
#      if thing.update(method_args)
#        format.html { redirect_to redirect, notice: "#{name} was successfully updated." }
#        format.json { render :show, status: :created, location: redirect }
#      else
#        format.html { render :edit }
#        format.json { render json: thing.errors, status: :unprocessable_entity }
#      end
#    end
  end

  def respond_to_destroy args
    args = parse_args_for_respond_to args
    thing    = args[:thing]
    redirect = args[:redirect]
    name     = args[:name]

    respond_to do |format|
      format.html { redirect_to redirect, notice: "#{name} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def helper_for_respond_to args
    args[:method_args] ||= {}
    respond_to do |format|
      if args[:thing].send(args[:method], args[:method_args])
        format.html { redirect_to args[:redirect], notice: "#{args[:name]} was successfully created." }
        format.json { render :show, status: :created, location: args[:redirect] }
      else
        format.html { render args[:render_on_fail] }
        format.json { render json: args[:thing].errors, status: :unprocessable_entity }
      end
    end
  end

  def parse_args_for_respond_to args
    thing  = args[:thing]
    args[:redirect]     ||= thing
    args[:name]         ||= thing.class.to_s
    #args[:method_args] ||= eval($thing.class.to_s.downcase.sub(/$/, "_args"))
    args
  end

end
