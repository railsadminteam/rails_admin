RailsAdmin.config do |c|
  c.excluded_models << RelTest << FieldTest

  c.model Coach do
    destroy do
      soft_destroy true
    end
  end

  c.model Club do
    destroy do
      soft_destroy :custom_destroy
    end
  end

end
