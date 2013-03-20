class EventsController < ApplicationController
  before_action :authenticate!, except: [:index, :show]

  def index
    @newevents = Event.where("date > ?", DateTime.now).order("date DESC")
    @oldevents = Event.where("date <= ?", DateTime.now).order("date ASC").limit(5)
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(create_params).tap do |event|
      event.date = "#{params[:event][:date]} #{params[:event][:time]}"
      event.identity = current_identity
    end

    return redirect_to events_path, notice: t('.event_created') if @event.save

    flash.now[:alert] = t('.invalid_event')
    @event.date = params[:event][:date]
    render :new
  end

  def edit
    @event = Event.my_event params[:id], current_identity

    return redirect_to events_path, alert: t('.event_not_found') unless @event
  end

  def update
    @event = Event.my_event params[:id], current_identity
    
    if @event
      return redirect_to events_path, notice: t('.event_updated') if @event.update_attributes create_params
    end
    
    return redirect_to events_path, alert: t('.event_not_found')
  end
  
  def destroy
    @event = Event.my_event params[:id], current_identity
    
    if @event
      return redirect_to events_path, notice: t('.event_deleted') if @event.destroy
    end
    
    return redirect_to events_path, alert: t('.event_not_found')
  end

  private
  def create_params
    params.require(:event).permit(:name, :location, :description, :contact, :organizer, :date, :time)
  end
end
