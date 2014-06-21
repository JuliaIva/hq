class Entrance::CampaignsController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:applications]
  load_and_authorize_resource class: 'Entrance::Campaign'

  def applications
    @applications = applications_from_filters

    respond_to do |format|
      format.html
      format.pdf
    end
  end

  def register
    @applications = applications_from_filters

    respond_to do |format|
      format.html
      format.pdf
    end
  end

  private

  def applications_from_filters(opts = { date: false })
    params[:direction] ||= 1887
    @direction = Direction.find(params[:direction])

    params[:form]      ||= 11
    @form = EducationForm.find(params[:form])

    params[:payment]   ||= 14
    @source = EducationSource.find(params[:payment])

    form_method = case params[:form]
                    when '10'
                      :z_form
                    when '12'
                      :oz_form
                    else
                      :o_form
                  end

    payment_method = case params[:payment]
                       when '15'
                         :paid
                       else
                         :not_paid
                     end

    apps = Entrance::Application.
      joins(competitive_group_item: :direction).
      send(form_method).send(payment_method).
      where('directions.id = ?', params[:direction]).
      order('entrance_applications.number ASC')

    if opts[:date]
      params[:date] ||= l(Date.today)
      apps = apps.where('DATE(entrance_applications.created_at) = ?',
                 Date.strptime(params[:date], '%d.%m.%Y'))
    end

    apps
  end
end