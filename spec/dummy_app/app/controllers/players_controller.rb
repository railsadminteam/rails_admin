# frozen_string_literal: true

class PlayersController < ApplicationController
  def show
    @player = Player.find(params[:id])
  end
end
