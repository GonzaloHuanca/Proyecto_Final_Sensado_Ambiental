void serialEvent(Serial puerto) {
    try {
        String incomingLine = puerto.readStringUntil('\n');
        if (incomingLine != null) {
            println("Línea recibida: " + incomingLine);
            incomingLine = incomingLine.trim();
            ProcesarLinea(incomingLine);
        }
    } 
    catch(Exception e) {
        println("Error al leer serial: " + e);
    }
}

void ConectarALPuerto(int index){
    String [] Puertos =Serial.list();
    if(Puertos.length==0){
        println("NO hay puertos seriales disponibles");
        return;
    }
    if(index<0 || index>=Puertos.length){
        println("Índice de puerto inválido. Lista de puertos: ");
        for (int i = 0; i < Puertos.length; i++) {
        println(i + ": " + Puertos[i]);
        }

        return;
    }
    try{
        if(myPort!=null) myPort.stop();
        myPort= new Serial(this,Puertos[index],9600);
        myPort.bufferUntil('\n');
        println("Conectado a: " + Puertos[index]);
     
    }
    catch(Exception e){
    println("Error al abrir puerto: " + e.getMessage());
    }
}
void ProcesarLinea(String linea) {
    if (linea == null) return;

    // Ejemplo:
    // Humedad suelo: 23.00% | Humedad Aire: 52.80% | Temperatura: 26.40°C | Modo: AUTO | Bomba: ENCENDIDA
  
    String[] partes = linea.split("\\|");
    for (String p : partes) {
        p = p.trim();

        if (p.startsWith("Humedad suelo:")) {
            HumedadSuelo = float(p.substring(14, p.length()-1));  // quita el %
  
        }
        if (p.startsWith("Humedad Aire:")) {
            HumedadAire = float(p.substring(14, p.length()-1));
   
        }
        if (p.startsWith("Temperatura:")) {
            String valor = p.replace("Temperatura:", "") .replace("°C", "").replace("C", "").replace("Â", "").trim();
            try {
                Temperatura = float(valor);
                
            } catch(Exception e) {
                println("Error leyendo temperatura: " + valor);
            }
        }
        if (p.startsWith("Modo:")) {
           Modo = p.substring(6);
    
        }
        if (p.startsWith("Bomba:")) {
            BombaEncendida = p.contains("ENCENDIDA");
    
        }
    }
  GuardarEnCSV();
}

void sendSerial(String msj){
    if(myPort!=null){
        myPort.write(msj);
        println("->"+msj.trim());
    }    
    else{
        println("Puerto serial no conectado. Mensaje no enviado: "+msj.trim());
    }
}
