class CreateForceUuidConstraints < Neo4j::Migrations::Base
  def up
    add_constraint :AnotherFieldTest, :uuid, force: true
    add_constraint :Ball, :uuid, force: true
    add_constraint :Category, :uuid, force: true
    add_constraint :"Cms::BasicPage", :uuid, force: true
    add_constraint :Comment, :uuid, force: true
    add_constraint :"Comment::Confirmed", :uuid, force: true
    add_constraint :DeeplyNestedFieldTest, :uuid, force: true
    add_constraint :Division, :uuid, force: true
    add_constraint :Draft, :uuid, force: true
    add_constraint :Fan, :uuid, force: true
    add_constraint :FieldTest, :uuid, force: true
    add_constraint :Hardball, :uuid, force: true
    add_constraint :Image, :uuid, force: true
    add_constraint :League, :uuid, force: true
    add_constraint :NestedFieldTest, :uuid, force: true
    add_constraint :Player, :uuid, force: true
    add_constraint :Tableless, :uuid, force: true
    add_constraint :Team, :uuid, force: true
    add_constraint :User, :uuid, force: true
    add_constraint :"User::Confirmed", :uuid, force: true
  end

  def down
    drop_constraint :AnotherFieldTest, :uuid
    drop_constraint :Ball, :uuid
    drop_constraint :Category, :uuid
    drop_constraint :"Cms::BasicPage", :uuid
    drop_constraint :Comment, :uuid
    drop_constraint :"Comment::Confirmed", :uuid
    drop_constraint :DeeplyNestedFieldTest, :uuid
    drop_constraint :Division, :uuid
    drop_constraint :Draft, :uuid
    drop_constraint :Fan, :uuid
    drop_constraint :FieldTest, :uuid
    drop_constraint :Hardball, :uuid
    drop_constraint :Image, :uuid
    drop_constraint :League, :uuid
    drop_constraint :NestedFieldTest, :uuid
    drop_constraint :Player, :uuid
    drop_constraint :Tableless, :uuid
    drop_constraint :Team, :uuid
    drop_constraint :User, :uuid
    drop_constraint :"User::Confirmed", :uuid
  end
end
