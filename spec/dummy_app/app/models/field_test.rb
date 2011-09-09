class FieldTest < ActiveRecord::Base
  has_one :comment, :as => :commentable
  attr_accessible :comment_id, :string_field, :text_field, :integer_field, :float_field, :decimal_field, :datetime_field, :timestamp_field, :time_field, :date_field, :boolean_field, :created_at, :updated_at, :format
  attr_accessible :comment_id, :string_field, :text_field, :integer_field, :float_field, :decimal_field, :datetime_field, :timestamp_field, :time_field, :date_field, :boolean_field, :created_at, :updated_at, :format, :restricted_field, :as => :custom_role
  attr_accessible :comment_id, :string_field, :text_field, :integer_field, :float_field, :decimal_field, :datetime_field, :timestamp_field, :time_field, :date_field, :boolean_field, :created_at, :updated_at, :format, :protected_field, :as => :extra_safe_role
end
