#include <EstadoRiego.h>
#include <Riego.h>
#include <Arduino.h>


Riego SistemaRiego(A0,7,2,DHT22);
EstadoRiego EstadoActual=ESTADO_INICIO;

unsigned long TiempoAnterior=0;
const unsigned long IntervaloEnvio=2000;

void setup() {
    SistemaRiego.Iniciar();
    Serial.begin(9600);
}

void loop() {
    switch(EstadoActual){
      case ESTADO_INICIO: 
          Serial.println("Sistema de riego iniciado");
          EstadoActual=ESTADO_LECTURA;
          break;
      case ESTADO_LECTURA: 
          SistemaRiego.LeerSensores();
          EstadoActual=ESTADO_CONTROL;
          break;
      case ESTADO_CONTROL:
          SistemaRiego.ControlarBomba();
          EstadoActual=ESTADO_ENVIO;
          break;
      case ESTADO_ENVIO:
          if(millis()-TiempoAnterior>=IntervaloEnvio){
              TiempoAnterior=millis();
              SistemaRiego.EnviarDatos();
          }
          EstadoActual=ESTADO_COMUNICACION;
          break;
      case ESTADO_COMUNICACION:
          SistemaRiego.LeerComandos();
          EstadoActual=ESTADO_LECTURA;
          break;    
    }

