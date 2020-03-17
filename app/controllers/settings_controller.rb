class SettingsController < ApplicationController
  before_action :dev_only, only: [:dev_panel]

  def dropdown
    @dropdown = true
  end

  def update_all_user_settings
    Setting.initialize_all_settings
    redirect_to home_path
  end

  def index
  end

  def update
    Setting.names.each do |category, names|
      for name in names
        setting = current_user.settings.find_by_name(name)
        # makes sure not to reset color values unless user restores defaults and accounts for on/off setting params
        if params[:restore_defaults]
          setting.update category => (category.eql?(:on) ? false : "")
        elsif category.eql? :state
          state_params = params[name.to_sym]
          if state_params.any? {|key,val| val.present?}
            setting.update category => \
              "rgb(#{state_params[:r].to_i}, #{state_params[:g].to_i}, #{state_params[:b].to_i})"
          end
        elsif category.eql? :on
          setting.update category => params[name.to_sym]
        end
      end
    end
    if params[:ajax]
      @dropdown = true
    else
      redirect_to home_path, notice: "Settings updated successfully..."
    end
  end

  private

  def dev_only
    unless dev?
      redirect_to '/404'
    end
  end
end
