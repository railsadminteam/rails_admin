import jQuery from "jquery";
import "jquery-ui/ui/widget.js";

(function ($) {
  "use strict";

  $.widget("ra.abstractSelect", {
    options: {
      createQuery: function (query) {
        if ($.isEmptyObject(this.scopeBy)) {
          return { query: query };
        } else {
          const filterQuery = {};
          for (var field in this.scopeBy) {
            const targetField = this.scopeBy[field];
            const targetValue = $(`[name$="[${field}]"]`).val();
            if (!filterQuery[targetField]) {
              filterQuery[targetField] = [];
            }
            filterQuery[targetField].push(
              targetValue ? { o: "is", v: targetValue } : { o: "_blank" }
            );
          }
          return { query: query, f: filterQuery };
        }
      },
      scopeBy: {},
    },
  });
})(jQuery);
