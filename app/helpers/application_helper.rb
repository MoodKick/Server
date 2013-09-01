# encoding: UTF-8
module ApplicationHelper
  def avatar_url(url)
    return url if url
    '/images/avatars/generic_avatar.png'
  end

  def daily_journal_entry_keywords(keywords)
    keywords.map do |keyword|
      content_tag(:span, class: keyword) { keyword }
    end.join(', ').html_safe
  end

  def daily_journal_entry_happiness_level(happiness_level)
    content_tag(:div, class: [:progress]) do
      content_tag(:div, class: [:bar], style: "width: #{happiness_level * 100 / 5}%") { happiness_level.to_s.html_safe }
    end
  end

  def daily_journal_entry_created_at(created_at)
    short_created_at(created_at)
  end

  def short_created_at(created_at)
    time_tag(created_at, format: :day_month)
  end

  def daily_journal_entry_created_at_link(created_at, path)
    link_to(daily_journal_entry_created_at(created_at), path, class: 'btn')
  end

  def nice_date(date)
    if date
      time_tag(date, date.strftime("%A #{date.day.ordinalize} of %b"))
    else
      'No'
    end
  end

  def location_options
    ['Hovedstaden', 'Sjælland', 'Syddanmark', 'Midtjylland', 'Nordjylland']
  end

  def user_roles(roles)
    if roles.empty?
      'No'
    else
      roles.join(', ')
    end
  end

  def api_user_roles(roles)
    roles.map(&:to_s)
  end
end
