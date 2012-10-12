ActiveRecord::Base.send(:include, ActiveModel::ForbiddenAttributesProtection) if defined? ActiveRecord::Base
Mongoid::Document.send(:include, ActiveModel::ForbiddenAttributesProtection) if defined? Mongoid::Document
