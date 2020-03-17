module SharedItemsHelper
  def shared_item_read_more_link shared_item, field, read_more=nil
    link_to "Read more", shared_item_read_more_path(shared_item.id, field: field), remote: true, class: :stacked_shared_item_edit_link \
      if shared_item.send(field).to_s.size > SharedItem::READ_MORE_MIN and not read_more
  end

  def stacked_vertically?
    cookies[:stacked_shared_items_set_to_vertical].present?
  end

  def shared_item_sort_by_field_label field
    case field
    when :body
      :description
    when :item_category_id
      :category
    when :holder_id
      :holder
    when :days_to_borrow
      :max_duration_of_use
    else
      field
    end
  end

  def shared_item_max_duration_time shared_item
    time = time_ago_in_words shared_item.days_to_borrow.days.from_now.to_datetime
    time.slice! "about "
    time
  end

  def shared_item_in_stock shared_item
    if shared_item.current_borrower
      if shared_item.current_borrow_expires_at > DateTime.current
        time_ago_in_words(shared_item.current_borrow_expires_at) + " until available"
      else
        "Item not yet returned"
      end
    else
      "Yes"
    end
  end

  def days_to_borrow_options filter_field=nil
    # only shows "defaults to 1 week" outside of filter form
    options = [["Max duration of use#{' (defaults to 1 week)' unless filter_field}", nil],
      ['1 day', 1],
      ['1 week', 7],
      ['2 weeks', 14],
      ['1 month', 30]]
  end

  def display_holder shared_item
    if shared_item.holder.is_a? User
      shared_item.holder.name.capitalize
    elsif shared_item.holder.eql? 'lending_library'
      'Lending Library'
    end
  end

  def shared_item_filter_options sort_by=false
    options = [["Choose a field to #{sort_by ? 'sort' : 'filter'} by", nil]]
    for field in shared_item_fields
      _field = case field
      when :body
        :description
      when :item_category_id
        'category (domain)'
      when :holder_id
        :holder
      when :days_to_borrow
        :max_duration_of_use
      else
        field
      end
      options << [_field.to_s.gsub("_", " ").capitalize, field]
    end
    options << ['In stock', :in_stock]
    options
  end

  def shared_item_fields
    [:name, :body, :item_category_id, :arrangement, :item_type, :size, :aka, :contact, :region, :holder_id, :days_to_borrow]
  end

  def shared_item_fields_summary
    [:name, :item_category_id, :holder_id, :arrangement]
  end

  def shared_item_fields_feed_summary
    [:body, :item_category_id, :arrangement]
  end
end
