# monitoring_tools

 ```mermaid
graph TD
    %% Users
    User[User]

    %% Workload VMs
    AppVM[App VM - Application server]
    DBVM[DB VM - Database server]

    %% Monitoring Cluster
    MonCluster[Monitoring Cluster: Prometheus, Loki, Alertmanager, Exporters]
    Grafana[Grafana - Dashboard]

    %% Flows
    User --> Grafana
    AppVM --> MonCluster
    DBVM --> MonCluster
    MonCluster --> Grafana

```
```mermaid
mindmap
  root((Monitoring Stack))
    AppVM
      App Server
    DBVM
      DB Server
    Exporters
      Node Exporter
      Blackbox Exporter
      Promtail
      Pushgateway
    Monitoring Core
      Prometheus
      Loki
      Alertmanager
    Dashboards
      Grafana
```


```mermaid
sequenceDiagram
    App VM->>Node Exporter: send metrics
    DB VM->>Node Exporter: send metrics
    App VM->>Blackbox: probe
    DB VM->>Blackbox: probe
    Pushgateway->>Prometheus: push metrics
    Node Exporter->>Prometheus: metrics
    Blackbox->>Prometheus: metrics
    App VM->>Promtail: logs
    DB VM->>Promtail: logs
    Promtail->>Loki: logs
    Prometheus->>Alertmanager: alerts
    Grafana->>Prometheus: query metrics
    Grafana->>Loki: query logs

```
