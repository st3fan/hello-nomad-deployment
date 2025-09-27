job "hello-nomad" {
  datacenters = ["dc1"]
  type        = "service"

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
        "http",
        "web",
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
        image = "ghcr.io/st3fan/hello-nomad-deployment:latest"
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