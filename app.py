from flask import Flask, config, render_template, request, session, url_for
import os
import json
from flask_mail import Mail, Message
import codecs
import mysql.connector
import pandas as pd


with codecs.open('config.json', 'r', 'utf8') as conf:
    config = json.load(conf)



passwd = config['email']['pass']
email = config['email']['email']
app = Flask(__name__, template_folder='templates')
app.secret_key = os.urandom(12)
app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 465
app.config['MAIL_USE_SSL'] = True
app.config['MAIL_USERNAME'] = email
app.config['MAIL_PASSWORD'] = passwd

mail = Mail(app)

#Coneccion al server de la BD
conn = mysql.connector.connect(host='localhost',
                                user = 'root',
                                password = '1234',
                                database='mydb2')
#Crear el cursor
cursor = conn.cursor()

def sendContactForm():
    msg = Message("Contacto desde Subi que te Llevo",
                  sender=email,
                  recipients=[email])

    msg.body = """
    Buenos días,
    Se le informa que su viaje ha sido cancelado.
    Saludos,
    Subi que te llevo.
    """
    mail.send(msg)
    
@app.route('/', methods=['POST', 'GET'])
def main():
    viajes = pd.read_sql('SELECT v.cantidadDeLugaresDisponibles, v.fecha, v.hora, v.precioDelViaje, v.equipaje, ve.patente, lo.nombre AS origen, ld.nombre AS destino, ev.observacion FROM viaje v JOIN vehiculo ve ON ve.ID = v.Vehiculo_ID JOIN localidad1 lo on lo.ID = v.Origen_ID JOIN localidad2 ld ON ld.ID = v.Destino_ID JOIN estadoviaje ev ON ev.ID = v.EstadoViaje_ID', conn, index_col = None)
    viajes_front = []
    i = 0
    for index, row in viajes.iterrows():
        vi=[]
        viaje = "viaje N° "+str(i)
        lugares = row['cantidadDeLugaresDisponibles']
        fecha = row['fecha']
        hora = row['hora']
        precio = row['precioDelViaje']
        patente=row['patente']
        origen = row['origen']
        destino = row['destino'] 
        vi.append(viaje)
        vi.append(fecha)
        vi.append(hora)
        vi.append(origen)
        vi.append(destino)
        vi.append(precio)
        vi.append(patente)
        vi.append(lugares)
        viajes_front.append(vi)
        i = i+1
    return render_template('index.html', viajes_front=viajes_front)
    #return render_template('index.html', lugares=lugares, fecha=fecha, hora=hora, precio=precio, patente=patente, origen=origen, destino=destino)

@app.route("/crearViaje", methods=["GET", "POST"])
def crearViaje():
    dropdown_origen = []
    origenes = pd.read_sql('SELECT ID, nombre FROM localidad1', conn,  index_col = None)
    for index, row in origenes.iterrows():
        orig = []
        id = row['ID']
        ori = row['nombre']
        orig.append(id)
        orig.append(ori)
        dropdown_origen.append(orig)
    dropdown_destino = []
    destinos = pd.read_sql('SELECT ID, nombre FROM localidad2', conn,  index_col = None)
    for index, row in destinos.iterrows():
        dest = []
        id = row['ID']
        ori = row['nombre']
        dest.append(id)
        dest.append(ori)
        dropdown_destino.append(dest)
    if request.method == 'POST':
        fecha = request.form['fecha']
        hora = request.form['hora']        
        origen = request.form['origen']
        destino = request.form['destino']
        precio = request.form['precio']
        patente = request.form['patente']

        cursor.execute("INSERT INTO viaje (cantidadDeLugaresDisponibles,fecha,hora,precioDelViaje,equipaje,observacion,PerfilConductor_ID,Vehiculo_ID,Origen_ID,Destino_ID,EstadoViaje_ID) VALUES (4,'{}','{}',{},1,'',1,1,{},{},1)".format(str(fecha),str(hora),float(precio),int(origen),int(destino)))
        cursor.commit()
        return url_for('main')
    return render_template('crearViaje.html', dropdown_origen=dropdown_origen, dropdown_destino=dropdown_destino)

@app.route("/verPerfil", methods=["GET", "POST"])
def verPerfil():
    return render_template('verPerfil.html')

@app.route("/historial", methods=["GET", "POST"])
def historial():
    return render_template('historial.html')



@app.route("/contact", methods=["GET", "POST"])
def contact():
    viajes = pd.read_sql('SELECT v.cantidadDeLugaresDisponibles, v.fecha, v.hora, v.precioDelViaje, v.equipaje, ve.patente, lo.nombre AS origen, ld.nombre AS destino, ev.observacion FROM viaje v JOIN vehiculo ve ON ve.ID = v.Vehiculo_ID JOIN localidad lo on lo.ID = v.Origen_ID JOIN localidad ld ON ld.ID = v.Destino_ID JOIN estadoviaje ev ON ev.ID = v.EstadoViaje_ID', conn, index_col = None)
    viajes_front = []
    i = 0
    for index, row in viajes.iterrows():
        vi=[]
        viaje = "viaje N° "+str(i)
        lugares = row['cantidadDeLugaresDisponibles']
        fecha = row['fecha']
        hora = row['hora']
        precio = row['precioDelViaje']
        patente=row['patente']
        origen = row['origen']
        destino = row['destino'] 
        vi.append(viaje)
        vi.append(fecha)
        vi.append(hora)
        vi.append(origen)
        vi.append(destino)
        vi.append(precio)
        vi.append(patente)
        vi.append(lugares)
        viajes_front.append(vi)
    if request.method == 'POST':
        print('entró')
        sendContactForm()
        
        return render_template('index.html', viajes_front=viajes_front)


    return render_template('index.html', viajes_front=viajes_front)

if __name__ == '__main__':
    app.run(port=5520, debug=True)
