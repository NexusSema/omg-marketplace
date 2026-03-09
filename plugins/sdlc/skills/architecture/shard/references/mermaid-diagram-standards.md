# Mermaid Diagram Standards

Standards for all Mermaid diagrams produced by the shard-architecture workflow.

## Universal Rules

1. **Descriptive node IDs** — use `platformApi`, `adminPortal`, `postgresDb` — never single letters like `A`, `B`, `C`
2. **Relationship labels on all edges** — every `-->` must have a label: `-->|"REST API call"|`
3. **Subgraphs for logical grouping** — group related components: `subgraph "Data Tier"`
4. **Title comment** above every diagram: `%% Container Diagram — Platform API and its dependencies`
5. **Syntactically valid** — must parse without error in Mermaid Live Editor
6. **No HTML tags** — never use `<br>`, `<br/>`, or any HTML tags in node labels. Use `\n` inside double-quoted labels for line breaks if needed, or use a dash/parentheses separator (e.g. `"Service A (FastAPI)"`)
7. **Width constraint** — prefer `graph TD`/`TB` (top-down) over `graph LR` to keep diagrams narrow and readable in VS Code's markdown preview. Limit to **max 5 nodes per row**. If a diagram has more than 5 parallel nodes, split into multiple rows using subgraph nesting or intermediate edges

## Diagram Types and Syntax

### C4 Context Diagram (graph TD)
```mermaid
%% System Context — {System Name} and external actors
graph TD
    actor[/"Actor Name"/]
    system["System Name"]
    externalSystem[("External System")]

    actor -->|"uses"| system
    system -->|"calls"| externalSystem
```

### C4 Container Diagram (graph TD)
```mermaid
%% Container Diagram — {System Name} internal containers
graph TD
    subgraph "System Boundary"
        serviceA["Service A (FastAPI)"]
        serviceB["Service B (Next.js)"]
        database[("PostgreSQL")]
        cache[("Redis")]
    end

    serviceA -->|"reads/writes"| database
    serviceA -->|"caches"| cache
    serviceB -->|"REST API"| serviceA
```

### C4 Component Diagram (graph TD)
```mermaid
%% Component Diagram — {Container Name}
graph TD
    subgraph "Container Name"
        router["API Router"]
        service["Service Layer"]
        repository["Repository"]
    end

    router -->|"delegates"| service
    service -->|"queries"| repository
```

### Sequence Diagram
```mermaid
%% Sequence — {Flow Name}
sequenceDiagram
    actor User
    participant Gateway as API Gateway
    participant Auth as Auth Service
    participant API as Platform API
    participant DB as PostgreSQL

    User->>Gateway: POST /api/v1/resource
    Gateway->>Auth: Validate token
    Auth-->>Gateway: Token valid

    alt Authorized
        Gateway->>API: Forward request
        API->>DB: INSERT query
        DB-->>API: Row created
        API-->>Gateway: 201 Created
        Gateway-->>User: 201 Created
    else Unauthorized
        Gateway-->>User: 403 Forbidden
    end
```

### Entity-Relationship Diagram
```mermaid
%% ERD — {Domain Area}
erDiagram
    TENANT {
        uuid id PK
        varchar name
        varchar slug UK
        timestamp created_at
    }
    USER {
        uuid id PK
        uuid tenant_id FK
        varchar email UK
        varchar role
    }

    TENANT ||--o{ USER : "has"
```

### Infrastructure Topology (graph TD)
```mermaid
%% Infrastructure Topology — {Environment}
graph TD
    subgraph "Kubernetes Cluster"
        subgraph "Namespace: platform"
            apiDeploy["platform-api (Deployment)"]
            apiSvc["platform-api (Service)"]
        end
        subgraph "Namespace: data"
            pgStateful["postgresql (StatefulSet)"]
        end
    end

    apiSvc -->|"ClusterIP:5432"| pgStateful
```

### Network Topology (graph TD)
```mermaid
%% Network Topology — {Environment}
graph TD
    subgraph "Public Zone"
        lb["Load Balancer (TLS Termination)"]
    end
    subgraph "Application Zone"
        api["Platform API"]
        admin["Admin Portal"]
    end
    subgraph "Data Zone"
        db[("PostgreSQL")]
        redis[("Redis")]
    end

    lb -->|"HTTPS:443"| api
    lb -->|"HTTPS:443"| admin
    api -->|"TCP:5432"| db
    api -->|"TCP:6379"| redis
```

## Validation Checklist

For every diagram in every output document:

- [ ] Has `%%` title comment on line above
- [ ] All node IDs are descriptive (no single letters)
- [ ] All edges have labels
- [ ] Related nodes grouped in subgraphs
- [ ] Valid Mermaid syntax (parseable)
- [ ] Matches the described architecture (not generic)
