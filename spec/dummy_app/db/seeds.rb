# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

User.create(:email => 'test@test.com', :password => 'test1234', :password_confirmation => 'test1234')

al = League.create!(:name => 'American')
nl = League.create!(:name => 'National')

east_al = Division.create!(:name => 'East', :league => al)
east_nl = Division.create!(:name => 'East', :league => nl)

west_al = Division.create!(:name => 'West', :league => al)
west_nl = Division.create!(:name => 'West', :league => nl)

Team.create!(:name => 'Red Sox', :manager => 'Jack Dempsey', :founded => 1900, :wins => 100, :losses => 0, :win_percentage => 100, :league => al, :division => east_al)
Team.create!(:name => 'Yankees', :manager => 'Yogi Berra', :founded => 1900, :wins => 0, :losses => 100, :win_percentage => 0, :league => al, :division => east_al)
