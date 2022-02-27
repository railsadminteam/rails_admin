# frozen_string_literal: true

require 'shrine'
require 'shrine/storage/memory'

Shrine.storages = {
  cache: Shrine::Storage::Memory.new,
  store: Shrine::Storage::Memory.new,
}
