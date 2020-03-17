class TemplatesController < ApplicationController
  before_action :set_lil_c, only: [:lil_c, :lil_c_sign_up]
  before_action :fw_only
  before_action :set_fwc

  layout :get_layout

  def co
    @fwc_home = true
  end

  def lil_c
    @lil_c_home = true
  end

  private

  def set_lil_c
    @lil_c = true
  end

  def set_fwc
    @forrest_web_co = true
  end

  def fw_only
    unless forrest_web_co? or forrest_wilkins? or in_dev?
      redirect_to home_path
    end
  end
end
