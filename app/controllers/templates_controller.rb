class TemplatesController < ApplicationController
  before_action :set_lil_c, only: [:lil_c, :lil_c_sign_up]
  before_action :set_fwc

  layout :get_layout

  def verify
    render layout: false
  end

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
end
