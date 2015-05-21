class Result < ActiveRecord::Base
  belongs_to :user

  def self.factory(user)
    unless user.queried_money_databases
      user.results.create(AvailableClaims.find(user.person_info))
      if user.results.count > 0
        user.update_attributes(queried_money_databases: true)
      end
    end
  end
end
