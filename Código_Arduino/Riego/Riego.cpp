#include "Riego.h"

Riego::Riego(int PinSuelo,int PinRelay,int PinSensorDHT,int TipoDHT):

    PinSensorSuelo(PinSuelo),
    PinRele(PinRelay),
    PinDHT(PinSensorDHT),
    dht(PinSensorDHT, TipoDHT)
{
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

void Riego::Iniciar(){
    pinMode(PinRele,OUTPUT);
    digitalWrite(PinRele,HIGH);
    dht.begin();
    Serial.begin(9600);
  
}
void Riego::LeerSensores(){
    int LecturaAnalogica=analogRead(PinSensorSuelo);
    HumedadSuelo=map(LecturaAnalogica,1023,0,0,100);
    HumedadAire=dht.readHumidity();
    Temperatura=dht.readTemperature();
    
    if(isnan(HumedadAire) || isnan(Temperatura)){
        Serial.println("Error en la lectura del DHT22");
        return;
    }
}
void Riego::ControlarBomba(){
    if(ModoAutomatico){
        if(HumedadSuelo < HumedadSueloBaja && !BombaEncendida){
            EncenderBomba();
        }
        else if(HumedadSuelo > HumedadSueloAlta && BombaEncendida){
            ApagarBomba();
        }
    }
}
void Riego::EnviarDatos(){
    if(millis()-TiempoAnterior >= IntervaloEnvio){
        TiempoAnterior=millis();

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
}
void Riego::LeerComandos(){
    if(Serial.available()){
           String Comando=Serial.readStringUntil('\n');
        Comando.trim(); 
        
        if(Comando=="AUTO"){
            ModoAutomatico=true;
            Serial.println("Modo automatico activado");
        }
        else if(Comando=="MANUAL"){
            ModoAutomatico=false;
            Serial.println("Modo manual activado");
        }
        else if(Comando=="ON" && !ModoAutomatico){
            EncenderBomba();
        }
        else if(Comando=="OFF" && !ModoAutomatico){
            ApagarBomba();
        }
        else{
            Serial.println("Comando desconocido");
        }
    }
     
}

void Riego::EncenderBomba(){
    digitalWrite(PinRele,LOW);
    BombaEncendida=true;
    Serial.println("Bomba encendida");
}
void Riego::ApagarBomba(){
    digitalWrite(PinRele, HIGH);
    BombaEncendida=false;
    Serial.println("Bomba apagada");
}

float Riego::AccederHumedadSuelo(){ return HumedadSuelo; }
float Riego::AccederTemperatura(){ return Temperatura; }
float Riego::AccederHumedadAire(){ return HumedadAire; } 

