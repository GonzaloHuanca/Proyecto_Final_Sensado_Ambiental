import processing.serial.*;//Permite usar el puerto serial para comunicarse con arduino.
import java.io.PrintWriter;
import java.io.FileWriter;
import java.io.IOException;//Permiten crear y escribir archivos.

Serial myPort;//Almacena el puerto serial
PrintWriter archivoCSV;//Archivo donde se guardan los datos
String incomingLine="";//Para guardar las cadenas entrantes.
//Valores
float HumedadSuelo=0;
float HumedadAire=0;
float Temperatura=0;
String Modo="AUTO";
boolean BombaEncendida=false;
//Formato de ventana.
int w=800;
int h=360;
PFont f;//Fuente

void settings() {
  size(w, h);// Creo la ventana indicando sus parámetros.
}
void setup(){
    

    surface.setTitle("Sistema Riego-Interfaz");// Nombre del programa
    f=createFont("Arial",14);//Creo una fuente
    textFont(f);//Establece la fuente para usar en los textos.
    String[] Puerto=Serial.list();//Guardo los puertos seriales disponibles.
    println("Puertos seriales disponibles:");
    for (int i = 0; i < Puerto.length; i++) {
        println(i + ": " + Puerto[i]);//Se muestran los puertos seriales.
    }
    ConectarALPuerto(2);// Acá se selecciona el puerto serial según el número que lo representa.
    try {
        // Se abre el archivo en modo append (append=true)
        archivoCSV = new PrintWriter(new FileWriter("Registro_Riego.csv", true));//Abre un archivo CSV en modo append
        // Si el archivo está vacío, escribir encabezado
        File f = new File("Registro_Riego.csv");
        if (f.length() == 0) {
            archivoCSV.println("Fecha;Hora;Temperatura;HumedadAire;HumedadSuelo;Modo;Bomba");
            archivoCSV.flush();
        }

    } catch (IOException e) {
        println("Error al abrir archivo CSV: " + e);
    }       
        
}
void draw(){
    background(245);//Color del fondo de la ventana.
    MostrarEncabezado();
    MostrarSensores();
    MostrarControles();
    MostrarFecha();
}
