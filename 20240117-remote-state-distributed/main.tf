data "terraform_remote_state" "tf_time_remote_state" {
  backend = "remote"

  config = {
    organization = "imjarois"
    workspaces = {
      name = "tf_time_remote_state"
    }
  }
}

resource "pagerduty_service" "db_srv_tf_local" {
  name              = "db_srv_tf_local"
  escalation_policy = data.terraform_remote_state.tf_time_remote_state.outputs.tf_remote_state_main_ep_id
  alert_creation    = "create_alerts_and_incidents"
  incident_urgency_rule {
    type    = "constant"
    urgency = "severity_based"
  }
}
