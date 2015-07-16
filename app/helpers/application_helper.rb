module ApplicationHelper

  @@dashboard_regex = /dashboard(\.self)?(-[a-z0-9]+)?\.css/
  def on_dashboard?
    content_for(:header_css) =~ @@dashboard_regex
  end
  def smart_container
    container_class = "container#{on_dashboard? ? '-fluid' : ''}"
    content_tag(:div, :class => container_class) { yield }
  end
  def smart_row
    container_class = "row#{on_dashboard? ? '-fluid' : ''}"
    content_tag(:div, :class => container_class) { yield }
  end

  def default_frame(options={})
    settings = {}.deep_merge(options)
    content_tag(:div, settings) { yield }
  end

  def devise_frame(options={})
    settings = {}.deep_merge(options)
    settings[:id] = 'devise-frame'
    form_frame(settings) { yield }
  end

  def admin_frame
    output = ''

    output << ( content_tag :div, :class => 'admin-frame' do
      ( content_tag :div, :class => 'row' do
        ( render :partial => 'admin/base/admin_frame' ) <<
        ( content_tag :div, :class => 'col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2' do
          ( content_tag(:div) { render_flash_messages!(:style => 'margin-top:20px;') } ) <<
          ( content_tag(:div) { yield } )
        end )
      end )
    end )
    output.html_safe
  end

  def form_frame(size=:small, options={})
    if size.is_a? Hash
      options = size
      size = :small
    end
    settings = { :class => '' }.deep_merge(options)
    settings[:class] += ' ' if settings[:class].length
    settings[:class] << 'form-frame '
    settings[:class] << (
    case size
    when :small then  'col-lg-4 col-lg-offset-4 col-md-6 col-md-offset-3'
    when :medium then 'col-lg-6 col-lg-offset-3 col-md-8 col-md-offset-2'
    when :large then 'col-lg-8 col-lg-offset-2 col-md-10 col-md-offset-1'
    end )
    content_tag(:div, :class => 'row') { content_tag(:div, settings) {
      ( content_tag(:div) { render_flash_messages! } ) <<
      ( content_tag(:div) { yield } ) } }
  end

  def get_flash_render_count
    return 0 unless content_for?(:flash_message_renders)
    content_for(:flash_message_renders).to_i
  end
  def increment_flash_render_count
    incremented_count = get_flash_render_count + 1
    content_for :flash_message_renders, incremented_count.to_s, :flush => true
  end

  def render_flash_messages(options={})
    return if get_flash_render_count > 0
    render_flash_messages!(options)
  end

  def render_flash_messages!(options={})
    settings = {}.deep_merge(options)
    increment_flash_render_count
    render('shared/flash_messages', :settings => settings,
           :render_count => get_flash_render_count).html_safe
  end

  def pluralize_without_count(count, noun, text = nil)
    if count != 0
      count == 1 ? "#{noun}#{text}" : "#{noun.pluralize}#{text}"
    else
      "#{noun.pluralize}#{text}"
    end
  end

end
