import processing.serial.*;

Serial myPort;
String incomingLine="";//Para guardar las cadenas entrantes
//Valores
float HumedadSuelo=0;
float HumedadAire=0;
float Temperatura=0;
String Modo="AUTO";
boolean BombaEncendida=false;
//Formato de ventana
int w=800;
int h=360;
PFont f;

void settings() {
  size(w, h);
}
void setup(){
    
    surface.setTitle("Sistema Riego-Interfaz");
    f=createFont("Arial",14);//Creo una fuente
    textFont(f);
    String[] Puerto=Serial.list();
    println("Puertos seriales disponibles:");
    for (int i = 0; i < Puerto.length; i++) {
    println(i + ": " + Puerto[i]);
    ConectarALPuerto(2);  
}

  
}
void draw(){
    background(245);
    MostrarEncabezado();
    MostrarSensores();
    MostrarControles();
    MostrarFecha();
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
}
void MostrarEncabezado(){
    fill(30);//Color del texto
    textSize(20);//Tamaño del texto
    textAlign(LEFT,CENTER);//
    text("Sistema de Riego-Monitor",20,28);
    textSize(12);
    fill(80);
    text("Conectado por serial",20,48);
}
void MostrarSensores(){
    //Box para sensores
    int BoxX=20;
    int BoxY=70;
    int BoxW=width-260;
    int BoxH=200;
    stroke(200);
    fill(255);
    rect(BoxX,BoxY,BoxW,BoxH,6);
    //Muestra los valores
    fill(40);
    textSize(14);
    textAlign(LEFT,TOP);
    text("Temperatura: "+nf(Temperatura,0,2)+"°C",BoxX+12,BoxY+12);
    text("Humedad ambiente: "+nf(HumedadAire,0,2)+"%",BoxX+12,BoxY+40);
    text("Humedad del Suelo: "+nf(HumedadSuelo,0,2)+"%",BoxX+12,BoxY+68);
    
    int BarraX=BoxX+12;
    int BarraY=BoxY+110;
    int BarraW=BoxW-24;
    int BarraH=18;
    
    textSize(12);
    fill(80);
    text("Humedad Suelo",BarraX,BarraY-18);
    DibujarBarra(BarraX, BarraY, BarraW, BarraH, HumedadSuelo);
    fill(80);
    text("Humedad ambiente",BarraX+105, BarraY+40-12);
    DibujarBarra(BarraX, BarraY+40, BarraW, BarraH, HumedadAire);
}
void DibujarBarra(int x, int y, int bw, int bh, float valor){
    noStroke();//Desactivar los bordes
    fill(230);
    rect(x,y,bw,bh,6);
    float wFill=constrain(map(valor,0,100,0,bw),0,bw);
    fill(100,180,255);
    rect(x,y,wFill,bh,6);
    fill(20);
    textAlign(RIGHT,CENTER);
    text(nf(valor,0,2)+"%",x+bw-6,y+bh/2);
}
void MostrarControles(){
    int ControlX=width-220;
    int ControlY=70;
    int ControlW=200;
    int ControlH=200;
    stroke(200);
    fill(255);
    rect(ControlX,ControlY,ControlW,ControlH,6);
    
    fill(40);
    textSize(14);
    textAlign(LEFT,TOP);
    text("Controles",ControlX+12,ControlY+12);
    boolean auto= Modo.equalsIgnoreCase("AUTO");
    int ToggleX=ControlX+12;
    int ToggleY=ControlY+50;
    int ToggleW=ControlW-24;
    int ToggleH=36;
    
    stroke(180);
    fill(245);
    rect(ToggleX,ToggleY,ToggleW,ToggleH,6);
    fill(auto ? color(250,255,200):color(255,200,200));
    int indW=ToggleW/2-4;
    int indX=ToggleX+(auto ? 2:ToggleW/2+2);
    rect(indX,ToggleY+2,indW,ToggleH-4,6);
    fill(20);
    textAlign(CENTER,CENTER);
    textSize(12);
    text("AUTO", ToggleX+ToggleW*0.25,ToggleY+ToggleH/2);
    text("MANUAL",ToggleX+ToggleW*0.75,ToggleY+ToggleH/2);
    
    int BotonBX=ToggleX;
    int BotonBY=ToggleY+ToggleH+20;
    int BotonBW=ToggleW;
    int BotonBH=44;
    boolean manual = !auto;
    
    if(!manual){
        fill(230);
        stroke(200);
        rect(BotonBX,BotonBY,BotonBW,BotonBH,6);
        fill(140);
        textSize(12);
        textAlign(CENTER,CENTER);
        text("Bomba(Modo manual)",BotonBX+BotonBW/2,BotonBY+BotonBH/2-10);
        textSize(11);
        text("Activa solo en modo MANUAL",BotonBX+BotonBW/2,BotonBY+BotonBH/2+10);
    }
    else{
        if(BombaEncendida)fill(255,180,180);
        else fill(200,255,200);
        stroke(160);
        rect(BotonBX,BotonBY,BotonBW,BotonBH,6);
        fill(30);
        textSize(16);
        textAlign(CENTER,CENTER);
        text(BombaEncendida ? "APAGAR BOMBA" : "ENCENDER BOMBA", BotonBX+BotonBW/2,BotonBY+BotonBH/2);
    }
    fill(40);
    textSize(12);
    textAlign(LEFT,TOP);
    text("Modo actual: "+ Modo,ControlX+12,ControlY+ControlH-48);
    text("Bomba: "+ (BombaEncendida ? "ENCENDIDA":"APAGADA"),ControlX+12,ControlY+ControlH-28);
}
void MostrarFecha(){
    fill(80);
    textSize(12);
    textAlign(RIGHT,CENTER);
    String FechaHora=nf(day(),2)+"/"+nf(month(),2)+"/"+year()+" "+nf(hour(),2)+":"+nf(minute(),2)+":"+nf(second(),2);
    text(FechaHora,width-20,height-12);
}
void mousePressed(){
    int ClickX=width-220;
    int ClickY=70;
    int ToggleX=ClickX+12;
    int ToggleY=ClickY+50;
    int ToggleW=200-24;
    int ToggleH=36;
    
    if(mouseX>=ToggleX && mouseX<=ToggleX+ToggleW && mouseY>=ToggleY && mouseY<=ToggleY+ToggleH){
        if(Modo.equalsIgnoreCase("AUTO")){
            Modo="MANUAL";
            sendSerial("MANUAL\n");
        }
        else{
            Modo="AUTO";
            sendSerial("AUTO\n");
        }
        return;
    }
    int BotonBX=ToggleX;
    int BotonBY=ToggleY+ToggleH+20;
    int BotonBW=ToggleW;
    int BotonBH=44;
    boolean manual=!Modo.equalsIgnoreCase("AUTO");
    if(manual && mouseX>=BotonBX && mouseX<=BotonBX+BotonBW && mouseY>=BotonBY && BotonBY<=BotonBY+BotonBH){
        BombaEncendida=!BombaEncendida;
        if(BombaEncendida) sendSerial("ON\n");
        else sendSerial("OFF\n");
    }
    
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
