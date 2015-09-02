module PointsHelper
  def points(count)
    return "#{count} points" if count != 1
    '1 point'
  end
end
