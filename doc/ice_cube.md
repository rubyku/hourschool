
include IceCube
schedule = Schedule.new(start_date)
rule     = IceCube::Rule.weekly

rule.day(:monday)
schedule.add_recurrence_rule(rule)

