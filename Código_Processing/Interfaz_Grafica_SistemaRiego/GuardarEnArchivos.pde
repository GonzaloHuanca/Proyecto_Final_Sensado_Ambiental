void GuardarEnCSV() {
    String Fecha = nf(day(),2) + "/" + nf(month(),2) + "/" + year();//Guarda la fecha actual del sistema.
    String Hora  = nf(hour(),2) + ":" + nf(minute(),2) + ":" + nf(second(),2);//Guarda la hora actual del sistema

    String Fila = Fecha + ";" +
                  Hora + ";" +
                  Temperatura + ";" +
                  HumedadAire + ";" +
                  HumedadSuelo + ";" +
                  Modo + ";" +
                  (BombaEncendida ? "ENCENDIDA" : "APAGADA");//Crea la línea separada por ;

    archivoCSV.println(Fila);//Escribe la fila en el archivo.
    archivoCSV.flush();//Fuerza a que los datos se guarden inmediatamente en el disco.
}
