require 'spec_helper'

describe Subscription do
end

# status(trial_active,trial_expired,trial_canceled,active,canceled,completed)

# MISSION SUBSCRIPTIONS
# user with trial_active Crewmanship
# # isn't charged until the day their trial expires
# # isn't charged if they cancel their subscription before the trial ends
# # receives email to input their credit card (3 days before, day of)

# user with trial_expired || trial_canceled || canceled || completed Crewmanship
# # they no longer receive member pricing on mission events
# # don't receive weekly updates
# # mission updates dont show up dashboard
# # can enter payment info and become an active member

# user with active Crewmanship
# # they receive member pricing on mission events
# # receive weekly updates
# # mission updates on dashboard
# # can post 3 events per month
# # get billed monthly for total sum
# # # if re-occurring charge is on 30th of month, make sure February charge happens last day of feb
# # # successful
# # # # user receives receipt
# # # fail
# # # # user receives error email
# # # # email admin
# user can have multiple subscriptions to multiple missions
# user can only have 1 subscription per mission

# ACCOUNT SUBSCRIPTIONS
# an account admin can set a member discount percentage for each event
# account admin can choose subscriptions per mission or per account
# # if account, user has only 1 subscription for an entire ACCOUNT