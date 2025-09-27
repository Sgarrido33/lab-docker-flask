import os
from flask import Flask, jsonify, render_template_string
from dotenv import load_dotenv

# Carga .env si existe en el working dir (/app dentro del contenedor)
# Nota: load_dotenv() no falla si el archivo no existe
load_dotenv()

app = Flask(__name__)

@app.route('/')
def home():
    html = '''
    <!DOCTYPE html>
    <html>
    <head>
        <title>{{ app_name }}</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 50px; }
            .container { max-width: 600px; margin: 0 auto; }
            h1 { color: #2196F3; }
            code { background: #f4f4f4; padding: 2px 6px; border-radius: 4px; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🐳 {{ app_name }}</h1>
            <p>Entorno: <code>{{ app_env }}</code></p>
            <p><a href="/api/health">/api/health</a> | <a href="/api/info">/api/info</a> | <a href="/api/app-config">/api/app-config</a></p>
        </div>
    </body>
    </html>
    '''
    return render_template_string(html,
                                  app_name=os.getenv("APP_NAME", "Flask Docker App"),
                                  app_env=os.getenv("APP_ENV", "unknown"))

@app.route('/api/health')
def health():
    return jsonify({"status": "healthy"})

@app.route('/api/info')
def info():
    import platform, socket
    return jsonify({
        "app": os.getenv("APP_NAME", "Flask Docker Demo"),
        "version": "1.1.0",
        "python_version": platform.python_version(),
        "hostname": socket.gethostname()
    })

@app.route('/api/app-config')
def app_config():
    # Devuelve una vista segura (no expongas secretos reales)
    safe = {
        "APP_NAME": os.getenv("APP_NAME"),
        "APP_ENV": os.getenv("APP_ENV"),
        "FEATURE_FLAG_SHOW_INFO": os.getenv("FEATURE_FLAG_SHOW_INFO"),
        # Nunca retornes variables sensibles (ej: DB_PASSWORD, API_KEYS, etc.)
        "SECRET_MESSAGE_present": "SECRET_MESSAGE" in os.environ
    }
    return jsonify(safe)

if __name__ == '__main__':
    port = int(os.getenv("PORT", "5000"))
    app.run(host='0.0.0.0', port=port, debug=True)