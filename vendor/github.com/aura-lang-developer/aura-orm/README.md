# ⚡ Aura ORM (`aura-orm`)

Librería de **Mapeo Objeto-Relacional (ORM)**, **Query Builder Fluido** y **Gestor de Esquemas DDL** escrita de forma nativa para el lenguaje de programación **Aura** (`aurac`).

---

## 🚀 Características

- **Query Builder Fluido Multi-Dialecto**: Construcción programática y segura de sentencias `SELECT`, `INSERT`, `UPDATE` y `DELETE`.
- **Dialectos SQL Nativos**:
  - **PostgreSQL**: Placeholders numerados (`$1, $2, ...`), cláusulas `RETURNING`, `SERIAL PRIMARY KEY` y entrecomillado `"identificador"`.
  - **MySQL**: Placeholders de interrogación (`?`) y delimitador de backtick `` `identificador` ``.
  - **SQLite**: Placeholders (`?`), `INTEGER PRIMARY KEY AUTOINCREMENT` y tipos ligeros.
- **Definición de Esquemas y DDL**: Definición declarativa de tablas, tipos de columnas (`INTEGER`, `BIGINT`, `VARCHAR`, `TEXT`, `BOOLEAN`, `NUMERIC`, `TIMESTAMP`), restricciones (`PRIMARY KEY`, `NOT NULL`, `UNIQUE`) y valores `DEFAULT`.
- **Despacho Seguro de Métodos**: Integración con el modelo Go/Aura mediante receptor tipado y etiqueta interna `__aura_type`.
- **100% Nativo en Aura**: Sin dependencias externas runtime pesadas.

---

## 📁 Estructura del Proyecto

```text
aura-orm/
├── aura.mod                  # Manifiesto de módulo Aura (v0.5.0)
├── Makefile                  # Comandos make (test, check, fmt, clean)
├── README.md                 # Documentación técnica
├── src/
│   ├── dialect/
│   │   └── dialect.aura      # Abstracciones de dialectos (PostgreSQL, MySQL, SQLite)
│   ├── builder/
│   │   └── query.aura        # Query Builder para SELECT, INSERT, UPDATE, DELETE
│   ├── schema/
│   │   └── schema.aura       # Definición de columnas, tablas y generador DDL
│   └── orm.aura              # Fachada unificada de alto nivel
└── tests/
    ├── builder_test.aura     # Pruebas de generación y parametrización de consultas
    └── schema_test.aura      # Pruebas de DDL y generación de esquemas
```

---

## 🛠️ Guía de Uso

### 1. Inicialización del ORM

```aura
import { PostgresOrm, MysqlOrm, SqliteOrm } from "./src/orm";

// Instanciar para el motor de tu preferencia:
let orm = PostgresOrm();
```

### 2. Consultas `SELECT` con Paginación y Filtros

```aura
let query = orm.SelectFrom("users")
  .Select("id")
  .Select("name")
  .Select("email")
  .Where("status", "=", "active")
  .Where("age", ">=", "18")
  .OrderBy("created_at", "DESC")
  .Limit(10)
  .Offset(20)
  .ToSql();

println(query.sql);
// SELECT id, name, email FROM users WHERE status = $1 AND age >= $2 ORDER BY created_at DESC LIMIT 10 OFFSET 20;
// query.params => ["active", "18"]
```

### 3. Inserciones `INSERT INTO` con `RETURNING` (PostgreSQL)

```aura
let insert = orm.InsertInto("users")
  .Set("name", "Alice")
  .Set("email", "alice@example.com")
  .Set("active", "true")
  .Returning("id")
  .Returning("created_at")
  .ToSql();

println(insert.sql);
// INSERT INTO users (name, email, active) VALUES ($1, $2, $3) RETURNING id, created_at;
// insert.params => ["Alice", "alice@example.com", "true"]
```

### 4. Actualizaciones `UPDATE` y Eliminaciones `DELETE`

```aura
// UPDATE
let update = orm.UpdateTable("users")
  .Set("name", "Alice Smith")
  .Set("status", "verified")
  .Where("id", "=", "42")
  .ToSql();

// DELETE
let delete = orm.DeleteFrom("sessions")
  .Where("expired", "=", "true")
  .ToSql();
```

### 5. Definición de Esquema y Migraciones DDL

```aura
import {
  IntegerColumn,
  StringColumn,
  BoolColumn,
  TimestampColumn
} from "./src/schema/schema";

let usersTable = orm.DefineTable("users")
  .AddColumn(IntegerColumn("id").PrimaryKey())
  .AddColumn(StringColumn("name", 100))
  .AddColumn(StringColumn("email", 150).Unique())
  .AddColumn(BoolColumn("is_active").Default("true"))
  .AddColumn(TimestampColumn("created_at"));

// Generar DDL según el dialecto configurado:
let ddlSql = usersTable.ToCreateTableSql(orm.dialect);
// CREATE TABLE IF NOT EXISTS "users" ("id" SERIAL PRIMARY KEY, "name" VARCHAR(100) NOT NULL, ...);
```

---

## 🧪 Pruebas Automatizadas

Para verificar tipos y ejecutar toda la suite de pruebas unitarias:

```bash
# Validar sintaxis y análisis semántico de tipos
make check

# Ejecutar pruebas del query builder y esquemas
make test
```
