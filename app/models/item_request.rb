class ItemRequest < ApplicationRecord
  belongs_to :shared_item
  belongs_to :user

  def valid_phone_number?
    phone_number = resolve_phone_number
    if phone_number.present?
      if phone_number.size.eql? 10 or phone_number.size.eql? 11
        return true
      end
    end
    false
  end

  def resolve_phone_number
    # gets phone_number from user or shared_item
    phone_number = get_phone_number
    if phone_number.present?
      # removes any extra characters
      phone_number = Phoner::Phone.normalize phone_number
      # adds country code if necessary
      phone_number = if phone_number.size == 10 and phone_number.first != "1"
        "1" + phone_number
      else
        phone_number
      end
    end
    phone_number
  end

  def get_phone_number
    phone_number = if shared_item.user.phone_number.present?
      shared_item.user.phone_number
    elsif shared_item.contact.present? and shared_item.contact.size >= 10
      shared_item.contact
    end
    phone_number
  end

  def duration
    durations = { '1': '1 day',
                '7': '1 week',
                '14': '2 weeks',
                '30': '1 month' }
    durations[chosen_days_to_borrow.to_s.to_sym]
  end
end
