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
    text("Temperatura: "+nf(Temperatura,0,2)+"°C",BoxX+12,BoxY+12);//nf()formato de número con dos decimales.
    text("Humedad ambiente: "+nf(HumedadAire,0,2)+"%",BoxX+12,BoxY+40);
    text("Humedad del Suelo: "+nf(HumedadSuelo,0,2)+"%",BoxX+12,BoxY+68);
    //Barra gráfica de humedad del suelo y aire.
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
    fill(230);//Color de los contornos.
    rect(x,y,bw,bh,6);
    float wFill=constrain(map(valor,0,100,0,bw),0,bw);//Convierte porcentajes a píxeles.
    fill(100,180,255);
    rect(x,y,wFill,bh,6);//Barra coloreada.
    fill(20);
    textAlign(RIGHT,CENTER);
    text(nf(valor,0,2)+"%",x+bw-6,y+bh/2);//Texto indicando los valores.
}
void MostrarControles(){
    //Dibuja un cuadro contenedor de los controles.   
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
    text("Controles",ControlX+12,ControlY+12);//Titulo.
    boolean auto= Modo.equalsIgnoreCase("AUTO");
    int ToggleX=ControlX+12;
    int ToggleY=ControlY+50;
    int ToggleW=ControlW-24;
    int ToggleH=36;
    stroke(180);
    
    fill(245);
    rect(ToggleX,ToggleY,ToggleW,ToggleH,6);//Dibuja un rectángulo dividido en dos secciones.Izquiera AUTO, derecha MANUAL.
    fill(auto ? color(250,255,200):color(255,200,200));//Se ilumina la parte seleccionada de un color u otro.
    int indW=ToggleW/2-4;
    int indX=ToggleX+(auto ? 2:ToggleW/2+2);//Se mueve el indicador deslizante.
    rect(indX,ToggleY+2,indW,ToggleH-4,6);
    fill(20);
    textAlign(CENTER,CENTER);
    textSize(12);
    text("AUTO", ToggleX+ToggleW*0.25,ToggleY+ToggleH/2);
    text("MANUAL",ToggleX+ToggleW*0.75,ToggleY+ToggleH/2);
    //Boton de la bomba manual.
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
        else fill(200,255,200);//Cambia el color segun el estado de la bomba.
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
    text(FechaHora,width-20,height-12);//Se muestran la fecha y hora del sistema y se coloca abajo a la derecha.
}
void mousePressed(){//Detecta los clicks.
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
    if(manual && mouseX>=BotonBX && mouseX<=BotonBX+BotonBW && mouseY>=BotonBY && mouseY<=BotonBY+BotonBH){
        BombaEncendida=!BombaEncendida;
        if(BombaEncendida) sendSerial("ON\n");
        else sendSerial("OFF\n");
    }
  
}
    
