# coding: utf-8


class Team < ActiveRecord::Base
  attr_accessible :name, :division_id, :logo_url, :manager, :ballpark, :mascot, :founded, :wins, :losses, :win_percentage, :revenue, :color, :custom_field, :fan_ids, :player_ids, :comment_ids

  belongs_to :division
  has_many :players, :inverse_of => :team
  has_and_belongs_to_many :fans
  has_many :comments, :as => :commentable

  validates_numericality_of :division_id, :only_integer => true
  validates_presence_of :manager
  validates_numericality_of :founded, :only_integer => true
  validates_numericality_of :wins, :only_integer => true
  validates_numericality_of :losses, :only_integer => true
  validates_numericality_of :win_percentage
  validates_numericality_of :revenue, :allow_nil => true

  def player_names_truncated
    players.map{|p| p.name}.join(", ")[0..32]
  end

  def color_enum
    ['white', 'black', 'red', 'green', 'blu<e>é']
  end
end
