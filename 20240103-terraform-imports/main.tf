# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "PHSB4I2"
resource "pagerduty_escalation_policy" "great_escalation_for_starting_2024" {
  description = null
  name        = "Great Escalation for starting 2024"
  num_loops   = 0
  teams       = []
  rule {
    escalation_delay_in_minutes = 30
    escalation_rule_assignment_strategy {
      type = "round_robin"
    }
    target {
      id   = "PSBYN8K"
      type = "user_reference"
    }
  }
}

# __generated__ by Terraform from "PEOZCNR"
resource "pagerduty_service" "great_tech_serv_for_starting_2024" {
  acknowledgement_timeout = "null"
  alert_creation          = "create_alerts_and_incidents"
  auto_resolve_timeout    = "null"
  description             = "This is a great Technical Service for starting 2024 on Terraform Time 😁"
  escalation_policy       = "PHSB4I2"
  name                    = "Great Tech Service for starting 2024"
  response_play           = null
  alert_grouping_parameters {
    type = "intelligent"
    config {
      aggregate   = null
      fields      = []
      time_window = 300
      timeout     = 0
    }
  }
  auto_pause_notifications_parameters {
    enabled = true
    timeout = 300
  }
  incident_urgency_rule {
    type    = "constant"
    urgency = "high"
  }
}
