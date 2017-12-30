# coding: utf-8

require 'spec_helper'

describe 'RailsAdmin Basic Association List', type: :request do
  subject { page }

  def register_action(action_name)
    RailsAdmin::Config::Actions.send(:init_actions!)
    RailsAdmin::Config::Actions::AssociationIndex.register_assoc(action_name)
    yield
    Rails.application.reload_routes!
    load Rails.root.join('../../app/controllers/rails_admin/main_controller.rb')
  end

  describe 'GET /admin/teams/1/players' do
    it 'works with has_many' do
      register_action(:players) do
        RailsAdmin.config do |config|
          config.included_models = [
            Player,
            Team,
          ]
          config.actions do
            players { only Team }
          end

          config.model Player do
            list do
              field :name
            end
          end
        end
      end

      team = FactoryGirl.create(:team)
      team_players = FactoryGirl.create_list(:player, 2, team: team)
      other_players = FactoryGirl.create_list(:player, 2)

      visit "/admin/team/#{team.id}/players"

      is_expected.to have_selector("a[href$='/admin/team/#{team.id}']")
      is_expected.to have_selector("a[href$='/admin/team/#{team.id}/edit']")
      is_expected.to have_selector("a[href$='/admin/team/#{team.id}/delete']")

      team_players.each do |player|
        is_expected.to have_content(player.name)
        is_expected.to have_selector("td a[href$='/admin/player/#{player.id}']")
        is_expected.to have_selector("td a[href$='/admin/player/#{player.id}/edit']")
        is_expected.to have_selector("td a[href$='/admin/player/#{player.id}/delete']")
      end

      other_players.each do |player|
        is_expected.not_to have_content(player.name)
      end
    end
  end

  describe 'GET /admin/teams/1/fans' do
    it 'works with has_and_belongs_to_many' do
      register_action(:fans) do
        RailsAdmin.config do |config|
          config.included_models = [
            Fan,
            Team,
          ]
          config.actions do
            fans { only Team }
          end

          config.model Fan do
            list do
              field :name
            end
          end
        end
      end

      team = FactoryGirl.create(:team)
      team_fans = FactoryGirl.create_list(:fan, 2, teams: [team])
      other_fans = FactoryGirl.create_list(:fan, 2)

      visit "/admin/team/#{team.id}/fans"

      is_expected.to have_selector("a[href$='/admin/team/#{team.id}']")
      is_expected.to have_selector("a[href$='/admin/team/#{team.id}/edit']")
      is_expected.to have_selector("a[href$='/admin/team/#{team.id}/delete']")

      team_fans.each do |fan|
        is_expected.to have_content(fan.name)
        is_expected.to have_selector("td a[href$='/admin/fan/#{fan.id}']")
        is_expected.to have_selector("td a[href$='/admin/fan/#{fan.id}/edit']")
        is_expected.to have_selector("td a[href$='/admin/fan/#{fan.id}/delete']")
      end

      other_fans.each do |fan|
        is_expected.not_to have_content(fan.name)
      end
    end
  end
end
