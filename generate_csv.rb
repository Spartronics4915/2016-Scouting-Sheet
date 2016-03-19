#!/usr/bin/env ruby

require 'csv'
require 'json'

def curl endpoint
  JSON::parse `curl -H "X-TBA-App-Id: frc4915:scouting:v1" http://www.thebluealliance.com/api/v2#{endpoint}`
end

teams_at_event = curl "/event/#{$<.read.chomp}/teams"

out = CSV.generate do |csv|
  csv << ['Team Name', 'Team #', 'Match #', 'Autonomous Points', 'High Goals', 'Low Goals', 'Robot Type', 'Scaled', 'Challenged', 'Portcullis', 'Cheval de Frise', 'Ramparts', 'Moat', 'Drawbridge', 'Sally Port', 'Rock Wall', 'Rough Terrain', 'Low Bar', 'Comments']
  rows = 1
  teams_at_event.sort_by do |x|
    x["team_number"]
  end.each do |team|
    avgs = (?D..?F).map do |col|
      "=AVERAGE(#{col}#{rows + 2}:#{col}#{rows + 13})"
    end
    counts = (?H..?R).map do |col|
      "=COUNT(#{col}#{rows + 2}:#{col}#{rows + 13})"
    end
    csv << [team["nickname"], team["team_number"], nil, *avgs, nil, *counts]
    rows += 1
    12.times do
      csv << [nil, team["team_number"]]
      rows += 1
    end
  end
end

puts out

