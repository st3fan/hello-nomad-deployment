variable "git_version" {
  description = "Git Version"
  type        = string
  default     = "unknown"
}

variable "git_commit" {
  description = "Git Commit"
  type        = string
  default     = "unknown"
}

job "hello-nomad" {
  datacenters = ["dc1"]
  type        = "service"

  meta {
    git_version = var.git_version
    git_commit = var.git_commit
  }

  group "web" {
    count = 2

    network {
      port "http" {
        to = 8080
      }
    }

    service {
      name = "hello-nomad"
      port = "http"
      provider = "nomad"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.webapp.rule=Host(`hello-nomad.sateh.systems`)",
        "traefik.http.routers.webapp.entrypoints=web",
      ]

      check {
        type     = "http"
        path     = "/health"
        interval = "10s"
        timeout  = "3s"
      }
    }

    task "server" {
      driver = "docker"

      config {
        image = "ghcr.io/st3fan/hello-nomad-deployment:${var.git_version}"
        ports = ["http"]
      }

      env {
        PORT = "${NOMAD_PORT_http}"
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}
