module MissionsHelper

  def full_mission_title(mission)
    "#{mission.verb} #{mission.title.downcase}"
  end

end
