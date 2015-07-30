# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  return unless (panels=$('.google-drive-import-settings-panel')).is('*')
  $(document).ready ->
    panels.each ->
      panel = $(@)
      header_index_select =
        panel.find('#survey_iteration_google_worksheet_header_row_index')
      art_attrs_start_column_select =
        panel.find('#survey_iteration_google_worksheet_art_attributes_start_column_index')
      art_attrs_end_column_select =
        panel.find('#survey_iteration_google_worksheet_art_attributes_end_column_index')
      art_attrs_inputs_row =
        panel.find('.google-worksheet-art-attributes-inputs')
      filtering_column_select =
        panel.find('#survey_iteration_google_worksheet_filtering_column_index')
      filtering_value_select =
        panel.find('#survey_iteration_google_worksheet_filtering_column_value')
      filtering_inputs_row = panel.find('.google-worksheet-filtering-inputs')

      # Cache original html values for dynamic selects
      art_attrs_start_column_select.data 'original-html',
                     art_attrs_start_column_select.html()
      art_attrs_end_column_select.data 'original-html',
                     art_attrs_end_column_select.html()
      filtering_column_select.data 'original-html',
                     filtering_column_select.html()

      resetArtAttrsColumnSelects = ->
        art_attrs_start_column_select.html(
          art_attrs_start_column_select.data('original-html'))
        art_attrs_start_column_select.val('')
        art_attrs_end_column_select.html(
          art_attrs_end_column_select.data('original-html'))
        art_attrs_end_column_select.val('')
      resetFilteringColumnSelect = ->
        filtering_column_select.html(
          filtering_column_select.data('original-html'))
        filtering_column_select.val('')

      header_index_select.change ->
        if $(@).val().length
          selected_opt = $(@).find('option:selected')
          cells = selected_opt.data 'cells'
          resetArtAttrsColumnSelects()
          resetFilteringColumnSelect()
          default_filtering_column =
            default_start_column = default_end_column = null
          for c, i in cells
            text = "Column #{i+1}: #{c}"
            buildOpt = -> $('<option />').html(text).val(i)
            art_attrs_start_column_select.append buildOpt()
            art_attrs_end_column_select.append   buildOpt()
            filtering_column_select.append       buildOpt()
            default_start_column     ?= i if c == 'colorful'
            default_end_column       ?= i if i == cells.length - 1
            default_filtering_column ?= i if c == 'delivery-round'
          if default_start_column?
            art_attrs_start_column_select.val default_start_column
          if default_end_column?
            art_attrs_end_column_select.val default_end_column
          if default_filtering_column?
            filtering_column_select.val default_filtering_column
          art_attrs_inputs_row.show(400)
          filtering_inputs_row.show(400)
        else
          art_attrs_inputs_row.hide 400, ->
            resetArtAttrsColumnSelects()
          filtering_inputs_row.hide 400, ->
            resetFilteringColumnSelect()
