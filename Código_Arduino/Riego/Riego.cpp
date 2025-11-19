#include "Riego.h"//Incluye el header, para poder usar las funciones que estan definidas en Riego.h
//Se inician las variables privadas necesarias del objeto 
Riego::Riego(int PinSuelo,int PinRelay,int PinSensorDHT,int TipoDHT):

    PinSensorSuelo(PinSuelo),
    PinRele(PinRelay),
    PinDHT(PinSensorDHT),
    dht(PinSensorDHT, TipoDHT)
{
    //Se establecen los valores iniciales del sistema para luego trabajarlos con las funciones.
	HumedadSuelo=0;
    HumedadAire=0;
    Temperatura=0;
    
    BombaEncendida=false;
    ModoAutomatico=true;

    HumedadSueloBaja=45;
    HumedadSueloAlta=55;

    TiempoAnterior=0;
    IntervaloEnvio=2000;
}
//
void Riego::Iniciar(){
    pinMode(PinRele,OUTPUT);//Configura el pin del relé como salida.
    digitalWrite(PinRele,HIGH);//Inicia el relé apagado.
    dht.begin();//Inicia el DHT
    Serial.begin(9600);//Comunicación serial a 9600 baudios.
    
}
void Riego::LeerSensores(){
    int LecturaAnalogica=analogRead(PinSensorSuelo);//Lee el sensor de de humedad de suelo.
    HumedadSuelo=map(LecturaAnalogica,1023,0,0,100);// Convierte los valores (0-1023) a porcentaje.
    HumedadAire=dht.readHumidity();
    Temperatura=dht.readTemperature();//Lee la humedad y Temperatura del DHT
    
    if(isnan(HumedadAire) || isnan(Temperatura)){//Si alguna lectura falla, se informa por serial.
        Serial.println("Error en la lectura del DHT22");
        return;
    }
}
void Riego::ControlarBomba(){
    if(ModoAutomatico){//Solo controla la bomba si está en modo automático.
        if(HumedadSuelo < HumedadSueloBaja && !BombaEncendida){//Si está muy seca y la bomba apagada, entonces enciende.
            EncenderBomba();
        }
        else if(HumedadSuelo > HumedadSueloAlta && BombaEncendida){//Si está húmeda y la bomba prendida, entonces apaga.
            ApagarBomba();
        }
    }
//Se usan humbrales para evitar prender y apagar rápidamente.
}
void Riego::EnviarDatos(){
    if(millis()-TiempoAnterior >= IntervaloEnvio){
        TiempoAnterior=millis();//Asegura que los datos se envíen cada 2 segundos sin bloquear el programa.

        Serial.print("Humedad suelo: ");
        Serial.print(HumedadSuelo);
        Serial.print("% | Humedad Aire: ");
        Serial.print(HumedadAire);
        Serial.print("% | Temperatura: ");
        Serial.print(Temperatura);
        Serial.print("°C | Modo: ");
        Serial.print(ModoAutomatico ? "AUTO" : "MANUAL");
        Serial.print(" | Bomba: ");
        Serial.println(BombaEncendida ? "ENCENDIDA" : "APAGADA");        
    }
	//Comunica, todos los datos leídos, por serial.
}
void Riego::LeerComandos(){//Cuando llega un texto por serial, se interpreta como comando.
    if(Serial.available()){
           String Comando=Serial.readStringUntil('\n');//Guarda el comando sin /n.
        Comando.trim(); 
        
        if(Comando=="AUTO"){
            ModoAutomatico=true;//Activa el modo automático si llega "AUTO"
            Serial.println("Modo automatico activado");
        }
        else if(Comando=="MANUAL"){
            ModoAutomatico=false;//Desactiva el modo automático si llega el comando "MANUAL"
            Serial.println("Modo manual activado");
        }
        else if(Comando=="ON" && !ModoAutomatico){
            EncenderBomba();//Enciende la bomba si llega el comando "ON", siempre que este desactivado el modo automático. 
        }
        else if(Comando=="OFF" && !ModoAutomatico){
            ApagarBomba();//Apaga la bomba si llega el comando "OFF" cuando el modo automático está desactivado.
        }
        else{
            Serial.println("Comando desconocido");//Cualquier otro comando se interpreta como desconocido.
        }
    }
     
}

void Riego::EncenderBomba(){
    digitalWrite(PinRele,LOW);//LOW=ON
    BombaEncendida=true;
    Serial.println("Bomba encendida");
}
void Riego::ApagarBomba(){
    digitalWrite(PinRele, HIGH);//HIGH=OFF
    BombaEncendida=false;
    Serial.println("Bomba apagada");
}
//FUnciones para acceder a valores fuera de la clase.
float Riego::AccederHumedadSuelo(){ return HumedadSuelo; }
float Riego::AccederTemperatura(){ return Temperatura; }
float Riego::AccederHumedadAire(){ return HumedadAire; } 

