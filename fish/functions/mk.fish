function mk --description "Project Creation Tool"
    set -l dir_name $argv[1]
    set -l init_cmd $argv[2]
    set -l type_cmd $argv[3]

    if test -z "$dir_name"
        echo "Usage: mk <dir-name> init [go]"
        return 1
    end

    mkdir -p "$dir_name"; and cd "$dir_name"
    echo "📁 Created and entered "(pwd)

    if test "$init_cmd" = "init"
        git init
        
        # Style group
        create_editorconfig
        create_prettierrc
        create_gitignore "$dir_name"

        if test "$type_cmd" = "go"
            echo "🚀 Initializing Go + Templ + Tailwind + Docker + SQLC environment..."
            
            create_env
            create_docker_compose
            create_sqlc_config
            create_air_config
            
            go mod init "$dir_name"

            # internal/api/api.go
            mkdir -p internal/api
            printf "package api\n\nimport (\n\t\"$dir_name/internal/database\"\n)\n\ntype APIConfig struct {\n\tDB *database.Queries\n}\n" > internal/api/api.go

            # internal/app/app.go
            mkdir -p internal/app
            printf "package app\n\nimport (\n\t\"fmt\"\n\t\"net/http\"\n\t\"github.com/a-h/templ\"\n)\n\nfunc Render(comp templ.Component) http.HandlerFunc {\n\treturn func(w http.ResponseWriter, r *http.Request) {\n\t\tw.Header().Set(\"Content-Type\", \"text/html; charset=utf-8\")\n\t\tif err := comp.Render(r.Context(), w); err != nil {\n\t\t\thttp.Error(w, \"Internal Server Error\", http.StatusInternalServerError)\n\t\t}\n\t}\n}\n\nfunc Static(folder string) http.Handler {\n\treturn http.StripPrefix(fmt.Sprintf(\"/%%v/\", folder), http.FileServer(http.Dir(fmt.Sprint(\"./internal/app/assets/\", folder))))\n}\n" > internal/app/app.go

            # internal/app/layout.templ
            printf "package app\n\ntempl layout(title string) {\n\t<!DOCTYPE html>\n\t<html lang=\"en\">\n\t\t<head>\n\t\t\t<meta charset=\"UTF-8\"/>\n\t\t\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"/>\n\t\t\t<title>{ title }</title>\n\t\t\t<link rel=\"stylesheet\" href=\"/css/styles.css\"/>\n\t\t\t<script src=\"https://unpkg.com/htmx.org@1.9.10\"></script>\n\t\t\t<script src=\"https://kit.fontawesome.com/8c654ed165.js\" crossorigin=\"anonymous\"></script>\n\t\t\t<script defer src=\"https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js\"></script>\n\t\t</head>\n\t\t<body class=\"bg-slate-900 text-white antialiased\">\n\t\t\t{ children... }\n\t\t</body>\n\t</html>\n}\n" > internal/app/layout.templ

            # internal/app/home.templ
            printf "package app\n\ntempl Home() {\n\t@layout(\"Home Page\") {\n\t\t<div class=\"flex flex-col items-center justify-center h-screen\">\n\t\t\t<h1 class=\"text-4xl font-bold mb-4\">Hello from Templ!</h1>\n\t\t\t<i class=\"fa-solid fa-mountain-sun text-6xl text-blue-500\"></i>\n\t\t</div>\n\t}\n}\n" > internal/app/home.templ

            # cmd/main.go
            mkdir -p cmd
            printf "package main\n\nimport (\n\t\"$dir_name/internal/app\"\n\t\"database/sql\"\n\t\"fmt\"\n\t\"log\"\n\t\"net/http\"\n\t\"os\"\n\t\"time\"\n\n\t\"github.com/go-chi/chi/v5\"\n\t\"github.com/go-chi/chi/v5/middleware\"\n\t\"github.com/joho/godotenv\"\n\t_ \"github.com/lib/pq\"\n)\n\nfunc main() {\n\tif err := godotenv.Load(); err != nil {\n\t\tfmt.Println(\"Warning: .env file not found\")\n\t}\n\n\tdbURL := os.Getenv(\"DB_URL\")\n\tif dbURL != \"\" {\n\t\tdb, err := sql.Open(\"postgres\", dbURL)\n\t\tif err != nil {\n\t\t\tfmt.Println(\"Error preparing database connection: \", err)\n\t\t}\n\t\tdefer db.Close()\n\t}\n\n\tr := chi.NewRouter()\n\tr.Use(middleware.RequestID)\n\tr.Use(middleware.RealIP)\n\tr.Use(middleware.Logger)\n\tr.Use(middleware.Recoverer)\n\tr.Use(middleware.Timeout(60 * time.Second))\n\n\tr.Handle(\"/css/*\", app.Static(\"css\"))\n\tr.Get(\"/\", app.Render(app.Home()))\n\n\tport := os.Getenv(\"HTTP_LISTEN_ADDR\")\n\tif port == \"\" {\n\t\tport = \":42069\"\n\t}\n\n\tfmt.Println(\"------------------------------------------------\")\n\tfmt.Printf(\" Backend listening on %%s\\n\", port)\n\tfmt.Println(\" Visit http://localhost:8080 for live reload\")\n\tfmt.Println(\"------------------------------------------------\")\n\n\tif err := http.ListenAndServe(port, r); err != nil {\n\t\tlog.Fatal(err)\n\t}\n}\n" > cmd/main.go

            create_justfile

            echo "📦 Downloading dependencies..."
            go get github.com/go-chi/chi/v5 github.com/joho/godotenv github.com/lib/pq github.com/a-h/templ
            go mod tidy

            git add .
            git commit -m "Initial commit: Go/Templ/Tailwind/Docker/SQLC setup"
            git branch -M main
        else
            git add .
            git commit -m "Initial commit"
            git branch -M main
        end
    end
end
