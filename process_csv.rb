#!/usr/bin/env ruby

require 'csv'

def process_round round
  round.shift 3

  auto = round.shift.to_i

  goal = ((5 * round.shift.to_i) + (2 * round.shift.to_i))

  round.shift

  endgame = ((15 * round.shift.to_i) + (5 * round.shift.to_i))

  breach_a = (round.shift.to_i + round.shift.to_i) * 5
  breach_b = (round.shift.to_i + round.shift.to_i) * 5
  breach_c = (round.shift.to_i + round.shift.to_i) * 5
  breach_d = (round.shift.to_i + round.shift.to_i) * 5

  breach_low = round.shift.to_i * 5

  {
    a: auto,
    b: goal,
    c: breach_a,
    d: breach_b,
    e: breach_c,
    f: breach_d,
    g: breach_low,
    h: endgame
  }
end

array = CSV::parse(ARGF.read).to_a.drop(1).chunk{|x|x[1]}.to_a.map do |team|
  number = team.shift
  rounds = team.shift.drop(1).map do |r|
    process_round r
  end.reduce({}) do |m, x|
    m.merge(x) do |k, o, n|
      o + n
    end
  end
  [number, rounds]
end.to_a

out = CSV.generate do |c|
  c << ["Team", "Autonomous", "Goal", "Breach A", "Breach B", "Breach C", "Breach D", "Breach Low Bar", "End-game"]  
  array.map do |a|
    [a.shift, *(a.shift.values)]
  end.sort_by do |a|
    a.drop(1).reduce(:+)
  end.reverse.each do |a|
    c << a
  end
end

puts out
