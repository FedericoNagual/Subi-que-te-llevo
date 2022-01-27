from flask import Flask, render_template
app = Flask(__name__)

##Rutas 

@app.route("/index")
def index():
    return render_template("index.html")

@app.route("/crearViaje")
def crearViaje():
    return render_template("crearViaje.html")

@app.route("/historial")
def historial():
    return render_template("historial.html")

@app.route("/verPerfil")
def verPerfil():
    return render_template("verPerfil")

if __name__ == "__main__":
    app.run(debug=True)

