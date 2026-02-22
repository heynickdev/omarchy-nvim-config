#!/bin/bash

# ==========================================
# 1. Configuration Helper Functions
# ==========================================

# --- create_air_config ---
create_air_config() {
  if [ -f .air.toml ]; then
    echo "⚠️  .air.toml already exists. Skipping."
    return 1
  fi

  # Optimized: Air handles the build loop and templ generation
  # This prevents the race condition where browser reloads before binary is ready
  cat << 'EOF' > .air.toml
root = "."
tmp_dir = "tmp"

[build]
# Air runs templ generate then builds the binary
cmd = "templ generate && go build -o ./tmp/main ./cmd/main.go"
bin = "./tmp/main"
include_ext = ["go", "templ", "html"]
exclude_dir = ["assets", "tmp", "vendor", "node_modules"]
# Exclude generated files to prevent infinite loops
exclude_regex = ["_templ\\.go", "_test\\.go"]
stop_on_error = true
send_interrupt = true
delay = 100

[log]
time = true
main_only = false

[misc]
clean_on_exit = true

[screen]
clear_on_rebuild = true
EOF
  echo "✅ Created .air.toml (Optimized for Templ)"
}

# --- create_gitignore ---
create_gitignore() {
  if [ -f .gitignore ]; then
    echo "⚠️  .gitignore already exists. Skipping."
    return 1
  fi

  local bin_name=${1:-$(basename "$PWD")}

  cat << EOF > .gitignore
# Go
/$bin_name
*.exe
*.exe~
*.test
*.out
/tmp/
*_templ.go

# Secrets
.env
.env.*
!.env.example
*.log
logs/

# Web
/node_modules/
/vendor/
/dist/
/build/
/public/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.npm/
.eslintcache
.stylelintcache
.cache/
.parcel-cache/
.next/
.nuxt/
.svelte-kit/
.djlintrc

# Editor/OS
*.swp
*.swo
*~
Session.vim
*.local
.DS_Store
Thumbs.db
desktop.ini
EOF
  echo "✅ Created .gitignore"
}

# --- create_editorconfig ---
create_editorconfig() {
  if [ -f .editorconfig ]; then
    echo "⚠️  .editorconfig already exists. Skipping."
    return 1
  fi

  cat << EOF > .editorconfig
root = true

[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

# Go requires tabs by standard (gofmt)
[*.go]
indent_style = tab
indent_size = 4
tab_width = 4

[*.templ]
indent_style = space
indent_size = 2
tab_width = 2

# Makefiles MUST use tabs
[Makefile]
indent_style = tab
tab_width = 4

[Justfile]
indent_stype = space
tab_width = 2

# Web technologies
[*.{js,jsx,ts,tsx,vue,html,css,scss,json,yaml,yml}]
indent_style = space
indent_size = 2
tab_width = 2
EOF
  echo "✅ Created .editorconfig"
}

# --- create_prettierrc ---
create_prettierrc() {
  if [ -f .prettierrc ]; then
    echo "⚠️  .prettierrc already exists. Skipping."
    return 1
  fi

  cat << EOF > .prettierrc
{
  "semi": false,
  "singleQuote": true,
  "useTabs": false,
  "tabWidth": 2
}
EOF
  echo "✅ Created .prettierrc"
}

# --- create_env ---
create_env() {
  if [ -f .env ]; then
    echo "⚠️  .env already exists. Skipping."
    return 1
  fi
  local d_name=${dir_name:-$(basename "$PWD")}

  cat << EOF > .env
APP_ENV=dev
# Backend listens here, Templ proxy listens on 8080
HTTP_LISTEN_ADDR=:42069
POSTGRES_USER=dev
POSTGRES_PASSWORD=devArea
POSTGRES_DB=$d_name

DB_URL="postgres://dev:devArea@localhost:5432/$d_name?sslmode=disable"
EOF
  echo "✅ Created .env"
}

# --- create_docker_compose ---
create_docker_compose() {
  if [ -f docker-compose.yml ]; then
    echo "⚠️  docker-compose.yml already exists. Skipping."
    return 1
  fi
  local d_name=${dir_name:-$(basename "$PWD")}

  cat << EOF > docker-compose.yml
services:
  postgres:
    image: postgres:16
    container_name: $d_name
    restart: unless-stopped
    env_file:
      - .env
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
EOF
  echo "✅ Created docker-compose.yml"
}

# --- create_sqlc_config ---
create_sqlc_config() {
  if [ -f sqlc.yaml ]; then
    echo "⚠️  sqlc.yaml already exists. Skipping."
    return 1
  fi

  mkdir -p sql/schema
  mkdir -p sql/queries
  mkdir -p internal/database

  cat << EOF > sqlc.yaml
version: "2"
sql:
  - schema: "sql/schema"
    queries: "sql/queries"
    engine: "postgresql"
    gen:
      go:
        out: "internal/database"
        package: "database"
EOF
  echo "✅ Created sqlc.yaml and directory structure"
}

# --- create_djlintrc ---
create_djlintrc() {
  if [ -f .djlintrc ]; then
    echo "⚠️  Djlintrc already exists. Skipping"
    return 1
  fi

  touch .djlintrc
  cat << EOF > .djlintrc
{
    "profile": "django",
    "indent": 2,
    "max_line_length": 120,
    "preserve_blank_lines": true,
    "format_python_code": true,
    "wrap_attributes": "force-aligned",
    "ignore_blocks": "h1,h2,h3,h4,h5,h6,p,span,strong,small",
    "ignore": "H006,H030,H031"
}
EOF
  echo "✅ Created .djlintrc"

}

create_justfile() {
  if [ -f justfile ]; then
    echo "⚠️ Justfile already exists. Skipping."
    return 1
  fi

  mkdir -p ./internal/app/assets/css
  touch ./internal/app/assets/styles.css

  if [ ! -f ./internal/app/assets/input.css ]; then
    cat << EOF > ./internal/app/assets/input.css
@import 'tailwindcss';
EOF
  fi

  # update justfile logic
  cat << 'EOF' > justfile
# Load .env file automatically
set dotenv-load := true

# Variables
gobin := `go env GOPATH` / "bin"
db_url := env_var_or_default("DB_URL", "postgres://localhost:5432")

# Watches for generated files and triggers browser reload on 8080
templ:
    templ generate --proxy="http://localhost:42069" --open-browser=false --proxyport="8080" --watch

# Run the air hot-reload server
server:
    {{gobin}}/air

# Watch and compile Tailwind CSS
tailwind:
    tailwindcss -i ./internal/app/assets/css/input.css -o ./internal/app/assets/css/styles.css --watch

# Run tailwind, templ, and server in parallel
[parallel]
dev: tailwind templ server

# Spin up docker-compose
up:
    docker-compose up -d

# Spin down docker-compose
down:
    docker-compose down
EOF
  echo "✅ Successfully created justfile"

}

# --- create_makefile ---
create_makefile() {
  if [ -f Makefile ]; then
    echo "⚠️  Makefile already exists. Skipping."
    return 1
  fi
  
  mkdir -p ./internal/app/assets/css
  touch ./internal/app/assets/css/styles.css
  
  if [ ! -f ./internal/app/assets/css/input.css ]; then
    cat << EOF > ./internal/app/assets/css/input.css
@import 'tailwindcss';
EOF
  fi

  # Updated Makefile logic: 
  # - Templ only handles the live-reload injection/proxy.
  # - Air handles the generation and binary rebuild.
  cat << 'EOF' > Makefile
# 1. Setup Variables
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

# Fix for Arch Linux: Explicitly find the Go binary path
GOBIN := $(shell go env GOPATH)/bin

# 2. Tasks
# templ proxy: Watches for generated files and triggers browser reload on 8080
templ:
	templ generate --proxy="http://localhost:42069" --open-browser=false --proxyport="8080" --watch

server:
	$(GOBIN)/air

tailwind:
	tailwindcss -i ./internal/app/assets/css/input.css -o ./internal/app/assets/css/styles.css --watch

# Clean j2 (we only need server/templ to coordinate together)
dev:
	make -j3 tailwind templ server

db-status:
	@echo "Connecting to ${DB_URL}..."
	@docker exec dev pg_isready || echo "Database container 'dev' is not running."

up:
	docker-compose up -d

down:
	docker-compose down
EOF

  echo "✅ Created Makefile (Arch Linux Live-Reload Optimized)"
}

# --- pretty (group function) ---
pretty() {
  create_editorconfig
  create_prettierrc
  create_gitignore "$1"
}

# --- create (standalone helper) ---
create() {
  if [ -z "$1" ]; then
    echo "Usage: create <all | air | style | env | make | docker | sqlc | django | just>"
    return 1
  fi
  local project_name
  project_name=$(basename "$PWD")

  case "$1" in
    all)
      create_env
      create_air_config
      pretty "$project_name"
      create_docker_compose
      create_sqlc_config
      create_justfile
      ;;
    air) create_air_config ;;
    style) pretty "$project_name" ;;
    env) create_env ;;
    editor) create_editorconfig ;;
    pretty) create_prettierrc ;;
    ignore) create_gitignore "$project_name" ;;
    make) create_makefile ;;
    docker) create_docker_compose ;;
    sqlc) create_sqlc_config ;;
    django) create_djlintrc ;;
    just) create_justfile ;;
    *) echo "Error: Unknown option '$1'." ;;
  esac
}

# ==========================================
# 2. Main Logic
# ==========================================

# --- mk (Project Creation) ---
mk() {
  local dir_name="$1"
  local init_cmd="$2"
  local type_cmd="$3"

  if [ -z "$dir_name" ]; then
    echo "Usage: mk <dir-name> init [go]"
    return 1
  fi

  # 1. Create and enter the directory
  mkdir -p "$dir_name" && cd "$dir_name" || return 1
  echo "📁 Created and entered $(pwd)"

  # 2. Check for the 'init' command
  if [ "$init_cmd" = "init" ]; then
    
    # Initialize Git
    git init
    
    # Create generic style configs
    pretty "$dir_name"

    # 3. Check for 'go' command
    if [ "$type_cmd" = "go" ]; then
      echo "🚀 Initializing Go + Templ + Tailwind + Docker + SQLC environment..."
      
      # --- Generate Configs ---
      create_env
      create_docker_compose
      create_sqlc_config
      create_air_config
      
      # Go Mod Init
      go mod init "$dir_name"

      # --- Create internal/api/api.go ---
      mkdir -p ./internal/api
      cat << EOF > ./internal/api/api.go
package api

import (
	"$dir_name/internal/database"
)

type APIConfig struct {
	DB *database.Queries
}
EOF
      echo "✅ Created internal/api/api.go"

      # --- Create internal/app/app.go with Render method ---
      mkdir -p ./internal/app
      cat << EOF > ./internal/app/app.go
package app

import (
  "fmt"
	"net/http"
	"github.com/a-h/templ"
)

func Render(comp templ.Component) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		if err := comp.Render(r.Context(), w); err != nil {
			http.Error(w, "Internal Server Error", http.StatusInternalServerError)
		}
	}
}

func Static(folder string) http.Handler {
  return http.StripPrefix(fmt.Sprintf("/%v/", folder), http.FileServer(http.Dir(fmt.Sprint("./internal/app/assets/", folder))))
}
EOF
      echo "✅ Created internal/app/app.go"

      # --- Create initial views with Font Awesome ---
      cat << EOF > ./internal/app/layout.templ
package app

templ layout(title string) {
	<!DOCTYPE html>
	<html lang="en">
		<head>
			<meta charset="UTF-8"/>
			<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
			<title>{ title }</title>
			<link rel="stylesheet" href="/css/styles.css"/>
			<script src="https://unpkg.com/htmx.org@1.9.10"></script>
			<script src="https://kit.fontawesome.com/8c654ed165.js" crossorigin="anonymous"></script>
      <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
		</head>
		<body class="bg-slate-900 text-white antialiased">
			{ children... }
		</body>
	</html>
}

EOF
      echo "✅ Created internal/app/layout.templ"

      # --- Initialise home.templ
      cat << EOF > ./internal/app/home.templ
package app

templ Home() {
	@layout("Home Page") {
		<div class="flex flex-col items-center justify-center h-screen">
			<h1 class="text-4xl font-bold mb-4">Hello from Templ!</h1>
			<i class="fa-solid fa-mountain-sun text-6xl text-blue-500"></i>
		</div>
	}
}
EOF
      echo "✅ Created internal/app/home.templ"
      # --- Create cmd/main.go ---
      mkdir -p ./cmd
      cat << EOF > ./cmd/main.go
package main

import (
	"$dir_name/internal/app"
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
	// "$dir_name/internal/api"
	// "$dir_name/internal/database"
)

func main() { // 1. Load Env
	if err := godotenv.Load(); err != nil {
		fmt.Println("Warning: .env file not found")
	}

	// 2. Connect DB
	dbURL := os.Getenv("DB_URL")
	if dbURL != "" {
		db, err := sql.Open("postgres", dbURL)
		if err != nil {
			fmt.Println("Error preparing database connection: ", err)
		}
		defer db.Close()
	}


	// 3. Setup Router
	r := chi.NewRouter()
	r.Use(middleware.RequestID)
	r.Use(middleware.RealIP)
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)
	r.Use(middleware.Timeout(60 * time.Second))

	r.Handle("/css/*", app.Static("css"))

	r.Get("/", app.Render(app.Home()))


	// 4. Start Server
	port := os.Getenv("HTTP_LISTEN_ADDR")
	if port == "" {
		port = ":42069"
	}

	fmt.Println("------------------------------------------------")
	fmt.Printf(" Backend listening on %s\n", port)
	fmt.Println(" Visit http://localhost:8080 for live reload")
	fmt.Println("------------------------------------------------")

	if err := http.ListenAndServe(port, r); err != nil {
		log.Fatal(err)
	}
}
EOF
      echo "✅ Created cmd/main.go"

      # Create Makefile
      create_justfile

      # Tidy up modules
      echo "📦 Downloading dependencies..."
      go get github.com/go-chi/chi/v5
      go get github.com/joho/godotenv
      go get github.com/lib/pq
      go get github.com/a-h/templ
      go mod tidy
      
      # Commit
      git add .
      git commit -m "Initial commit: Go/Templ/Tailwind/Docker/SQLC setup"
      git branch -M main

    # 4. If 'init' only (no 'go')
    elif [ -z "$type_cmd" ]; then
      git add .
      git commit -m "Initial commit"
      git branch -M main
    fi
  fi
}
