class Entrance::CampaignsController < ApplicationController
  skip_before_filter :authenticate_user!
  load_resource class: 'Entrance::Campaign'

  def applications
    params[:direction] ||= 1887
    params[:form]      ||= 11
    params[:payment]   ||= 14

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

    @applications = Entrance::Application.
      joins(competitive_group_item: :direction).
      send(form_method).send(payment_method).
      where('directions.id = ?', params[:direction]).
      order('entrance_applications.number ASC')
  end
end