## Setup

```bash
# Create docker network
docker network create traefik-proxy

# Start traefik-proxy
docker compose up -d
```

## Usages

### Without Docker Labels

Update `./config/dynamic.yaml`
```yaml
http:
  routers:
    example-app:
      rule: "Host(`example.com`)"  # <---- NOTE: Domain you need, make sure the domain resolves to the VM
      service: example-app  # <--- NOTE: This should match the service name defined in services block

  services:
    example-app:  # <--- NOTE: This should match the service name referenced in routers block
      loadBalancer:
        servers:
        - url: "http://host.docker.internal:8501"  # <-- NOTE: Traefik runs inside a container, so use host.docker.internal instead of localhost to access services exposed the host.
```

### With Docker Labels

Update your app `docker-compose.yaml`

```yaml
services:

  # ...

  service-1:  # <--- NOTE: service you want to expose
    networks:
     - default # <---- NOTE: another network for you docker compose stack (this is only required if you have `networks` block for the service)
     - traefik-proxy # <--- NOTE: this is need for traefik to route traffic to your container
    labels:
      traefik.enable: true
      traefik.http.routers.example-app.rule: "Host(`example.com`)"
      traefik.http.routers.example-app.service: example-app
      traefik.http.services.example-app.loadbalancer.server.port: 8501

networks:
  default:
  traefik-proxy:
    external: true
```

> [!IMPORTANT]
> Replace `example-app` with proper name (it acts as global name for the system)

> [!IMPORTANT]
>  Replace `8501` with the port which the application exposes in the container
>
> Traefik can also retrieve this if you have EXPOSE defined in the Docker image

> [!TIP]
> `default` network behavior: https://docs.docker.com/reference/compose-file/networks/
