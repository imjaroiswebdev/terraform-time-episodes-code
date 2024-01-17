resource "pagerduty_user" "tf_remote_state_user1" {
  name  = "tf_remote_state_user1"
  email = "tf_remote_state_user1@foo.test"
}

resource "pagerduty_schedule" "tf_remote_state_primary_schedule" {
  name      = "Primary Remote State demo rotation"
  time_zone = "America/New_York"

  layer {
    name                         = "Night Shift"
    start                        = "2015-11-06T20:00:00-05:00"
    rotation_virtual_start       = "2015-11-06T20:00:00-05:00"
    rotation_turn_length_seconds = 86400
    users                        = [pagerduty_user.tf_remote_state_user1.id]

    restriction {
      type              = "daily_restriction"
      start_time_of_day = "08:00:00"
      duration_seconds  = 32400
    }
  }
}

resource "pagerduty_escalation_policy" "tf_remote_state_main_ep" {
  name      = "tf_remote_state_main_ep"
  num_loops = 2

  rule {
    escalation_delay_in_minutes = 10
    target {
      type = "user_schedule"
      id   = pagerduty_schedule.tf_remote_state_primary_schedule.id
    }
  }
}
