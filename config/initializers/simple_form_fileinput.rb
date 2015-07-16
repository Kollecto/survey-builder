module SimpleForm
  module Inputs
    class FileInput < Base
      def input(wrapper_options)
        merged_input_options = merge_wrapper_options input_html_options, wrapper_options
        merged_input_options[:data] ||= {}
        if Rails.env.test?
          merged_input_options[:data][:bfi_disabled] = true
        else
          merged_input_options[:title] = 'Drop a file here, or click to browse...'
          merged_input_options[:data][:filename_placement] = 'inside'
        end
        @builder.file_field(attribute_name, merged_input_options)
      end
    end
  end
end
