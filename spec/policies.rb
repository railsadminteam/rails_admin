class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def show?
    user.roles.include? :admin
  end

  def destroy?
    false
  end

  def history?
    user.roles.include? :admin
  end

  def show_in_app?
    user.roles.include? :admin
  end

  def dashboard?
    user.roles.include? :admin
  end

  def index?
    false
  end

  def new?
    user.roles.include? :admin
  end

  def edit?
    user.roles.include? :admin
  end

  def export?
    user.roles.include? :admin
  end

  def rails_admin_index?
    true
  end
end

class PlayerPolicy < ApplicationPolicy
  def new?
    (user.roles.include?(:create_player) || user.roles.include?(:admin) || user.roles.include?(:manage_player))
  end

  def edit?
    (user.roles.include? :manage_player)
  end

  def destroy?
    (user.roles.include? :manage_player)
  end

  def index?
    user.roles.include? :admin
  end
end
