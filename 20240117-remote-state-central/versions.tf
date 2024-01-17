terraform {
  required_version = ">= 1.5"

  backend "remote" {
    organization = "imjarois"

    workspaces {
      name = "tf_time_remote_state"
    }
  }

  required_providers {
    pagerduty = {
      source  = "pagerduty/pagerduty"
      version = ">= 3.0.0"
    }
  }
}


