void GuardarEnCSV() {
    String Fecha = nf(day(),2) + "/" + nf(month(),2) + "/" + year();
    String Hora  = nf(hour(),2) + ":" + nf(minute(),2) + ":" + nf(second(),2);

    String Fila = Fecha + ";" +
                  Hora + ";" +
                  Temperatura + ";" +
                  HumedadAire + ";" +
                  HumedadSuelo + ";" +
                  Modo + "," +
                  (BombaEncendida ? "ENCENDIDA" : "APAGADA");

    archivoCSV.println(Fila);
    archivoCSV.flush();
}
void AbrirArchivoCSV() {
    try {
        String ruta = sketchPath("Registro_Riego.csv");
        File archivo = new File(ruta);

        if (archivo.exists()) {
            launch(archivo.getAbsolutePath()); // ⭐ Reemplaza completamente a Desktop.open()
            println("Abriendo Registro_Riego.csv...");
        } else {
            println("El archivo CSV aún no existe.");
        }
    } 
    catch (Exception e) {
        println("No se pudo abrir el archivo CSV: " + e);
    }
}
