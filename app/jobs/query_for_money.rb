class QueryForMoney < ActiveJob::Base
  queue_as :QueryForMoney
  def perform(friend_id)
    user = User.find(friend_id)
    Result.factory(user)
  end
end
