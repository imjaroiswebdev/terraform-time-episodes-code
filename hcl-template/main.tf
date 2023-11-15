# Configure the PagerDuty provider
provider "pagerduty" {
  token = var.pagerduty_token
}

# Create a PagerDuty team
resource "pagerduty_team" "tf_team_local1" {
  name        = "tf_team_local1"
  description = "A new team created with Terraform for local testing"
}

resource "pagerduty_user" "tf_user_local1" {
  name  = "tf_user_local1"
  email = "tf.user.local1@foo.test"
}

resource "pagerduty_escalation_policy" "tf_escalation_local1" {
  name      = "tf_escalation_local1"
  num_loops = 2
  teams     = [pagerduty_team.tf_team_local1.id]

  rule {
    escalation_delay_in_minutes = 10
    target {
      type = "user_reference"
      id   = pagerduty_user.tf_user_local1.id
    }
  }
}

resource "pagerduty_service" "db_srv_tf_local" {
  name              = "db_srv_tf_local"
  escalation_policy = pagerduty_escalation_policy.tf_escalation_local1.id
  alert_creation    = "create_alerts_and_incidents"
  incident_urgency_rule {
    type    = "constant"
    urgency = "severity_based"
  }
}

resource "pagerduty_service" "web_srv_tf_local" {
  name              = "web_srv_tf_local"
  escalation_policy = pagerduty_escalation_policy.tf_escalation_local1.id
  alert_creation    = "create_alerts_and_incidents"
  incident_urgency_rule {
    type    = "constant"
    urgency = "severity_based"
  }
}

#####################################################
# Testing with services, teams and users from here 👇
#####################################################

