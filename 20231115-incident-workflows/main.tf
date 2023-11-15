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
# Code for today's Incident Workflows configuration👇
#####################################################
resource "pagerduty_incident_workflow" "major_incident_wf" {
  name        = "Major Incidents Workflow"
  description = "Incident Workflow for responding on Major Incidents"
  step {
    name   = "Create a Slack Channel for an Incident"
    action = "pagerduty.com:incident-workflows:create-slack-channel:7"
    input {
      name  = "Slack Workspace Name"
      value = "T024FV5EJ" # PagerDuty Slack Workspace
    }
  }
}

resource "pagerduty_incident_workflow_trigger" "manual_trigger" {
  type                       = "manual"
  workflow                   = pagerduty_incident_workflow.major_incident_wf.id
  subscribed_to_all_services = true
}

resource "pagerduty_incident_workflow_trigger" "conditional_trigger" {
  type                       = "conditional"
  workflow                   = pagerduty_incident_workflow.major_incident_wf.id
  condition                  = "(incident.priority matches 'P1') or (incident.priority matches 'P2')"
  subscribed_to_all_services = true
}
