from flask import Flask, config, render_template, redirect, request, session, url_for
from pyfladesk import init_gui
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
conn = mysql.connector.connect(host='mydb.cn9l7lrgturn.us-east-2.rds.amazonaws.com',
                                user = 'root', 
                                password = 'Con_1_2022', #Con_1_2022
                                database='mydb') #mydb
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
    viajes = pd.read_sql('SELECT v.ID, v.cantidadDeLugaresDisponibles, v.fecha, v.hora, v.precioDelViaje, v.equipaje, ve.patente, lo.nombre AS origen, ld.nombre AS destino, ev.ID as estado FROM Viaje v JOIN Vehiculo ve ON ve.ID = v.Vehiculo_ID JOIN Localidad1 lo on lo.ID = v.Origen_ID JOIN Localidad2 ld ON ld.ID = v.Destino_ID JOIN EstadoViaje ev ON ev.ID = v.EstadoViaje_ID', conn, index_col = None)
    viajes_front = []
    for index, row in viajes.iterrows():
        vi=[]
        v_id = row['ID']
        viaje = v_id
        lugares = row['cantidadDeLugaresDisponibles']
        fecha = row['fecha']
        hora = row['hora']
        precio = row['precioDelViaje']
        patente=row['patente']
        origen = row['origen']
        destino = row['destino'] 
        estado = row['estado']
        if estado == 2:
            vi.append(viaje)
            vi.append(fecha)
            vi.append(hora)
            vi.append(origen)
            vi.append(destino)
            vi.append(precio)
            vi.append(patente)
            vi.append(lugares)
            viajes_front.append(vi)
    return render_template('index.html', viajes_front=viajes_front)
    #return render_template('index.html', lugares=lugares, fecha=fecha, hora=hora, precio=precio, patente=patente, origen=origen, destino=destino)

@app.route("/crearViaje", methods=["GET", "POST"])
def crearViaje():
    dropdown_origen = []
    origenes = pd.read_sql('SELECT ID, nombre FROM Localidad1', conn,  index_col = None)
    for index, row in origenes.iterrows():
        orig = []
        id = row['ID']
        ori = row['nombre']
        orig.append(id)
        orig.append(ori)
        dropdown_origen.append(orig)
    dropdown_destino = []
    destinos = pd.read_sql('SELECT ID, nombre FROM Localidad2', conn,  index_col = None)
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

        cursor.execute("INSERT INTO Viaje (cantidadDeLugaresDisponibles,fecha,hora,precioDelViaje,equipaje,observacion,PerfilConductor_ID,Vehiculo_ID,Origen_ID,Destino_ID,EstadoViaje_ID) VALUES (4,'{}','{}',{},1,'',1,1,{},{},2)".format(str(fecha),str(hora),float(precio),int(origen),int(destino)))
        conn.commit()
        return redirect(url_for('main'))
    return render_template('crearViaje.html', dropdown_origen=dropdown_origen, dropdown_destino=dropdown_destino)

@app.route("/verPerfil", methods=["GET", "POST"])
def verPerfil():
    chofer = pd.read_sql('SELECT nombre, apellido, dni, mail, rutaFoto FROM Persona WHERE ID = 1', conn, index_col = None)
    chofer_perf = []
    for index, row in chofer.iterrows():
        c=[]
        nombre = row['nombre']
        apellido = row['apellido']
        dni = row['dni']
        mail = row['mail']
        foto = row['rutaFoto']
        c.append(nombre)
        c.append(apellido)
        c.append(dni)
        c.append(mail)
        c.append(foto)
        chofer_perf.append(c)

    return render_template('verPerfil.html', chofer_perf=chofer_perf)

@app.route("/historial", methods=["GET", "POST"])
def historial():
    viajes = pd.read_sql('SELECT v.ID, v.cantidadDeLugaresDisponibles, v.fecha, v.hora, v.precioDelViaje, v.equipaje, ve.patente, lo.nombre AS origen, ld.nombre AS destino, ev.observacion as estado FROM Viaje v JOIN Vehiculo ve ON ve.ID = v.Vehiculo_ID JOIN Localidad1 lo on lo.ID = v.Origen_ID JOIN Localidad2 ld ON ld.ID = v.Destino_ID JOIN EstadoViaje ev ON ev.ID = v.EstadoViaje_ID', conn, index_col = None)
    viajes_front = []
    for index, row in viajes.iterrows():
        vi=[]
        v_id = row['ID']
        viaje = v_id
        fecha = row['fecha']
        hora = row['hora']
        precio = row['precioDelViaje']
        patente=row['patente']
        origen = row['origen']
        destino = row['destino'] 
        estado = row['estado']
        vi.append(viaje)
        vi.append(fecha)
        vi.append(hora)
        vi.append(origen)
        vi.append(destino)
        vi.append(precio)
        vi.append(patente)
        vi.append(estado)
        viajes_front.append(vi)
    return render_template('historial.html', viajes_front=viajes_front)


@app.route("/cancelar", methods=["GET", "POST"])
def cancelar():
    if request.method == 'POST':
        viaje = request.form.get('viaje')
        viaje = json.loads(viaje)
        cursor.execute("UPDATE Viaje SET EstadoViaje_ID = 3 WHERE ID = {}".format(viaje))
        conn.commit()
        sendContactForm()
        
        return redirect(url_for('historial'))

@app.route("/modificar", methods=["GET","POST"])
def modificar():
    return redirect(url_for('historial'))

if __name__ == '__main__':
    #app.run(port=5530, debug=True)
    init_gui(app, width=360, height=640, window_title="Subi Que Te Llevo" )
