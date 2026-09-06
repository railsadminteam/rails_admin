# frozen_string_literal: true

threads 0, ENV.fetch('RAILS_MAX_THREADS', 3)
port ENV.fetch('PORT', 3000)
