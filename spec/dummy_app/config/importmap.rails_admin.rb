# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'rails_admin', preload: true
pin 'rails_admin/src/rails_admin/base', to: 'rails_admin/base.js'
pin '@hotwired/turbo', to: 'https://ga.jspm.io/npm:@hotwired/turbo@7.1.0/dist/turbo.es2017-esm.js'
pin '@hotwired/turbo-rails', to: 'https://ga.jspm.io/npm:@hotwired/turbo-rails@7.1.1/app/javascript/turbo/index.js'
pin '@popperjs/core', to: 'https://ga.jspm.io/npm:@popperjs/core@2.11.2/dist/esm/popper.js'
pin '@rails/actioncable/src', to: 'https://ga.jspm.io/npm:@rails/actioncable@7.0.2/src/index.js'
pin '@rails/ujs', to: 'https://ga.jspm.io/npm:@rails/ujs@6.1.4/lib/assets/compiled/rails-ujs.js'
pin 'bootstrap', to: 'https://ga.jspm.io/npm:bootstrap@5.1.3/dist/js/bootstrap.esm.js'
pin 'flatpickr', to: 'https://ga.jspm.io/npm:flatpickr@4.6.9/dist/flatpickr.js'
pin 'flatpickr/', to: 'https://ga.jspm.io/npm:flatpickr@4.6.9/'
pin 'jquery', to: 'https://ga.jspm.io/npm:jquery@3.6.0/dist/jquery.js'
pin 'jquery-ui/', to: 'https://ga.jspm.io/npm:jquery-ui@1.13.1/'
