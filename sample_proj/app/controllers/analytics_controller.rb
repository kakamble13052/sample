class AnalyticsController < ApplicationController
  $month_start = 3.months.ago.to_date
  $month_end = Date.today
  $months_a = ($month_start..$month_end).map{|date| date.strftime('%m') }.uniq
  respond_to :html, :js, :json
  def get_months
    $month_start = Date.strptime(params[:assigned_from], '%m/%d/%Y').to_date
    $month_end = Date.strptime(params[:assigned_to], '%m/%d/%Y').to_date
    $months_a = ($month_start..$month_end).map{|date| date.strftime('%m') }.uniq
    success_string = 'success'
    render json: success_string
  end
  def view_admin
    @month_names = ['Last 3 months', 'Last 6 months', 'Last 9 months']
  end
  def view_manager

  end
  def view_employee

  end
end
