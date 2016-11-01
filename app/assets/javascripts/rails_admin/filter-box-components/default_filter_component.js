(function (components) {

  components.default_filter_component = function (options) {
    return {control: '<input type="text" class="input-sm form-control" name="' + options.value_name + '" value="' + options.field_value + '"/>' }
  }

}(FilterBoxComponents));