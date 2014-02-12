class EventsController < ApplicationController
  load_and_authorize_resource

  def index
    @events = @events.no_booking  # Пока так, чтобы ничего лишнего не смотрели
    @events = @events.from_name(params[:name]) if params[:name]
  end

  def actual
    @events = @events.no_booking  # Пока так, чтобы ничего лишнего не смотрели
    @dates = []
    @events.each do |event|
      @dates << event.dates.collect{|d| (l d.date, format: '%d.%m.%Y')}
    end
    @dates = @dates.flatten.uniq.sort_by{|d| d,m,y=d.split('.');[y,m,d]}
    @event_dates = []
    @events.each do |event|
      @event_dates << event.dates.collect{|d| d}
    end
    @event_dates = @event_dates.flatten.uniq
  end

  def show
    @visitor = VisitorEventDate.new
  end

  def new
  end

  def create
    @event = Event.new(resource_params)
    if @event.save
      redirect_to events_path, notice: 'Событие успешно добавлено.'
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @event.update(resource_params)
      redirect_to events_path, notice: 'Изменения сохранены.'
    else
      render action: :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    redirect_to events_path, notice: 'Событие было удалено.'
  end

  def print
    respond_to do |format|
      format.pdf
    end
  end

  def resource_params
    params.fetch(:event, {}).permit(:name, :description, :booking, :event_category_id,
                 dates_attributes: [:id, :date, :time_start, :time_end, :max_visitors, :'_destroy'])
  end
end