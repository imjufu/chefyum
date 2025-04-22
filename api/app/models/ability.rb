# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md

    # Unauthenticated users can…
    can :read, CookingRecipe

    return unless user.present?

    # Admin users can…
    if user.is_admin?
      can [ :create, :update, :destroy ], CookingRecipe
    end
  end
end
