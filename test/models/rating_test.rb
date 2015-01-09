require 'test_helper'

class RatingTest < ActiveSupport::TestCase
  test 'remove_rating_from_concert_score' do
    rating = ratings(:swift_2012_7)
    rating.send(:remove_rating_from_concert_score)
    concert = concerts(:swift_2012)
    assert_equal 3, concert.aggregate_score
  end
  
  test 'remove_rating_from_concert_score when destroying all ratings' do
    concerts(:swift_2012).ratings.destroy_all
    assert_nil concerts(:swift_2012, true).rank
  end
end
