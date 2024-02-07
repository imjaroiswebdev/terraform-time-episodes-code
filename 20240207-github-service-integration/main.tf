# Create a PagerDuty team
resource "pagerduty_user" "tf_user_local1" {
  name  = "tf_user_local1"
  email = "tf.user.local1@foo.test"
}

resource "pagerduty_escalation_policy" "tf_escalation_local1" {
  name      = "tf_escalation_local1"
  num_loops = 2

  rule {
    escalation_delay_in_minutes = 10
    target {
      type = "user_reference"
      id   = pagerduty_user.tf_user_local1.id
    }
  }
}

resource "pagerduty_service" "github_repository" {
  name              = "github_repository"
  escalation_policy = pagerduty_escalation_policy.tf_escalation_local1.id
  alert_creation    = "create_alerts_and_incidents"
  incident_urgency_rule {
    type    = "constant"
    urgency = "severity_based"
  }
}

data "pagerduty_vendor" "github" {
  name = "GitHub"
}

resource "pagerduty_service_integration" "github" {
  name = data.pagerduty_vendor.github.name
  service = pagerduty_service.github_repository.id
  vendor = data.pagerduty_vendor.github.id
}

data "pagerduty_priority" "p2" {
  name = "P2"
}

resource "pagerduty_event_orchestration_service" "github_repository" {
  service = pagerduty_service.github_repository.id
  enable_event_orchestration_for_service = true

  set {
    id = "start"
    rule {
      condition {
        expression = "event.summary matches 'Tests Status failure'"
      }
      actions {
        annotate = "Please checkout the GH Action output in https://github.com/imjaroiswebdev/node-jest-boilerplate/actions"
        priority = data.pagerduty_priority.p2.id

        extraction {
          template = "PR failed in GitHub Repository"
          target = "event.summary"
        }
      }
    }
  }
  catch_all {
    actions {}
  }
}
