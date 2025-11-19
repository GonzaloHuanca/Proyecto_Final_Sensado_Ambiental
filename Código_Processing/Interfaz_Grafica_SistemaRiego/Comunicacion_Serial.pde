void serialEvent(Serial puerto) {//Es el puente entre arduino y processing.
    try {
        String incomingLine = puerto.readStringUntil('\n');//Lee una línea completa hasta el salto de línea \n.
        if (incomingLine != null) {//Si la línea no es nula.
            println("Línea recibida: " + incomingLine);//Muestra en la consola.
            incomingLine = incomingLine.trim();//Elimina los espacios del inicio y final;
            ProcesarLinea(incomingLine);//Envia la cadena a ProcesarLinea() para extraer datos.
        }
    } 
    catch(Exception e) {
        println("Error al leer serial: " + e);//En caso de algun error lo informa.
    }
}

void ConectarALPuerto(int index){//Intenta conectarse al puerto serial según el índice recibido.
    String [] Puertos =Serial.list();//Guarda la lista de puertos disponibles.
    if(Puertos.length==0){//Si no hay puertos, se muestra en la consola.
        println("NO hay puertos seriales disponibles");
        return;
    }
    if(index<0 || index>=Puertos.length){//Si el elegido es inválido imprime la lista nuevamente.
        println("Índice de puerto inválido. Lista de puertos: ");
        for (int i = 0; i < Puertos.length; i++) {
        println(i + ": " + Puertos[i]);
        }

        return;
    }
    try{
        if(myPort!=null) myPort.stop();//Cierra el puerto anterior si existía algún otro
        myPort= new Serial(this,Puertos[index],9600);//Abre el nuevo puerto a 9600 baudios.
        myPort.bufferUntil('\n');//Configura que los datos se lean línea por línea.
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
  
    String[] partes = linea.split("\\|");//Divide la línea en partes separadas por |.
    for (String p : partes) {
        p = p.trim();//Limpia los espacios del inicio y fin.

        if (p.startsWith("Humedad suelo:")) {
            HumedadSuelo = float(p.substring(14, p.length()-1));  //Quita el % y guarda el dato.
  
        }
        if (p.startsWith("Humedad Aire:")) {
            HumedadAire = float(p.substring(14, p.length()-1));//Quita el % y guarda el dato.
   
        }
        if (p.startsWith("Temperatura:")) {
            String valor = p.replace("Temperatura:", "") .replace("°C", "").replace("C", "").replace("Â", "").trim();//Limpia los símbolos raros por codificación y guarda el dato.
            try {
                Temperatura = float(valor);
                
            } catch(Exception e) {
                println("Error leyendo temperatura: " + valor);
            }
        }
        if (p.startsWith("Modo:")) {
           Modo = p.substring(6);//Guarda AUTO o MANUAL.
    
        }
        if (p.startsWith("Bomba:")) {
            BombaEncendida = p.contains("ENCENDIDA");//Convierte a variable booleana ENCENDIDA=true; 
    
        }
    }
  GuardarEnCSV();//Se guardan todos los datos en un archivo CSV.
}
//Esta función es la que permite que, mediante botones, se pueda activar o desactivar la bomba o el modo automático.
void sendSerial(String msj){
    if(myPort!=null){//Verifica que el puerto esté conectado.
        myPort.write(msj);
        println("->"+msj.trim());
    }    
    else{
        println("Puerto serial no conectado. Mensaje no enviado: "+msj.trim());
    }
}
