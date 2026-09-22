erDiagram
    AIRPORTS ||--o{ FLIGHTS : "departs from"
    AIRPORTS {
        int airport_id PK
        string airport_name
    }
