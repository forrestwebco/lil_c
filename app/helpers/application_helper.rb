module ApplicationHelper
  def add_card_class item
    klass = if item.is_a? SharedItem or item.is_a? Survey
      'shared_item_card_vertical_spacer'
    else
      'card_vertical_spacer'
    end
    klass = nil if show_anon_avatar? item.user
    klass
  end

  def get_time_ago_link_class item, position=nil
    klass = if item.is_a? Proposal or item.is_a? Post
      'standard_post_link'
    else
      'top_right_link'
    end
    if position
      klass = position.to_s
    end
    return klass
  end

  def snip_txt txt, read_more=nil, small=nil
    unless read_more
      if txt.present? and txt.size > SharedItem::READ_MORE_MIN
        _txt = txt[0..(small ? 25 : SharedItem::READ_MORE_MIN)]
        _txt[-1] = "" if _txt[-1].eql? " "
        return _txt + "..."
      else
        return txt
      end
    end
    txt
  end

  def get_card_type
    if social_maya?
      'dark_card'
    else
      'card'
    end
  end

  def non_link
    'javascript:;'
  end

  def ellipsis_dots
    '&#9679&#9679&#9679'
  end

  def middle_dot
    "·"
  end

  def is_a_link? word
    word =~ /\A#{URI::regexp}\z/ or word.include? "http://" or word.include? ".se" \
      and word != "in:" and not (["::", ":)", ":]", "c:"].any? { |i| word.include? i } or word =~ /\w+:/)
  end

  def is_a_yt_link? word
    word =~ /\A#{URI::regexp}\z/ and word.include? "youtu" and !word.include? "user" and !word.include? "channel"
  end

  def standard_dark_card id='', alignment='center', &block
    str = "<div class=\"dark_card\" id=\"#{id}\" align=\"#{alignment.to_sym}\">"
    str << capture(&block)
    str << '</div>'
    raw str
  end

  def standard_card &block
    str = '<div class="card" align="center">'
    str << capture(&block)
    str << '</div>'
    raw str
  end

  def get_site_ico
    if social_maya?
      "cube"
    elsif forrest_web_co? or forrest_wilkins?
      "me"
    else
      "dsa"
    end
  end

  def justified_body item
    'justified_body_text' if (item.is_a?(Message) ? decrypt_message(item) : item.body).size > 125
  end

  def fa_icon icon, label='', size=''
    str = %Q[<i class="fa fa-#{icon}#{' ' + size if size.present?}"></i>] + " " + label
    return str.html_safe
  end

	def random_color as_str=nil
		rgb = []; 3.times { rgb << Random.rand(1..255) }
		rgb = "#{ rgb[0] }, #{ rgb[1] }, #{ rgb[2] }" if as_str
		return rgb
	end

  def rand_string
    SecureRandom.urlsafe_base64.gsub(/[^0-9a-z]/i, '')
  end

  def clean_a_token token
    return token.gsub(/[^0-9a-z]/i, '')
  end

  def time_ago _time_ago
    _time_ago = _time_ago + " ago"
    if _time_ago.include? "about"
    	_time_ago.slice! "about "
    end
    if _time_ago[0].to_i > 0 and _time_ago[1].to_i > 0
      _time_ago = _time_ago[0..2] + _time_ago[3.._time_ago.size]
    elsif _time_ago[0].to_i > 0
      _time_ago = _time_ago[0..1] + _time_ago[2.._time_ago.size]
    end
    return _time_ago
  end
end
