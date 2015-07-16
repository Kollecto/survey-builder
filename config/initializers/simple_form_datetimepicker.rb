module SimpleForm
  module Inputs
    class DateTimeInput < Base
      def input(wrapper_options)
        merged_input_options = merge_wrapper_options input_html_options, wrapper_options
        icon = merged_input_options.delete(:icon) || 'glyphicon-calendar'
        icon_lib = merged_input_options.delete(:iconlib) || icon.split('-')[0]
        defaultvalue = merged_input_options.delete(:defaultvalue)
        if defaultvalue.present? && defaultvalue.is_a?(Hash)
          day_offset = defaultvalue.delete(:day_offset)
          defaulttime = Time.zone.now.change(defaultvalue)
          defaulttime += day_offset.days if day_offset.present?
          defaultvalue = defaulttime
        end
        # merged_input_options[:class] << 'dtp'
        input_html_classes.push 'dtp'
        no_group = if merged_input_options.key?(:data)
          merged_input_options[:data][:defaultvalue] = defaultvalue if defaultvalue.present?
          merged_input_options[:data].key? :no_group
        else
          merged_input_options[:data] = {:defaultvalue => defaultvalue} if defaultvalue.present?
          false
        end

        out = ''
        out << '<div class="input-group">' unless no_group
        out << @builder.text_field(attribute_name, merged_input_options)
        unless no_group
          out << '<span class="input-group-addon">'
          out << "<span class='#{icon_lib} #{icon}'></span>"
          out << '</span>'
          out << '</div>'
        end
        out.html_safe
      end

      def label_target
        :"#{attribute_name}"
      end
    end
  end
end
