#include <EstadoRiego.h>//Contiene enum con los estados de la máquina de estados
#include <Riego.h>//Para usar la clase que maneja sensores y bomba.
#include <Arduino.h>//Funciones propias de arduino (millis,Serial, etc)

//Crea un objeto de la clase Riego
Riego SistemaRiego(A0,7,2,DHT22);
EstadoRiego EstadoActual=ESTADO_INICIO;//Se define el estado de la máquina, comienza en ESTADO_INICIO.
//Variables para el envío de datos por serial. 
unsigned long TiempoAnterior=0;
const unsigned long IntervaloEnvio=2000;

void setup() {
    SistemaRiego.Iniciar();//Se llama a la inicialización del sistema de riego.
    Serial.begin(9600);//Se abre la comunicación.
}

void loop() {//Está organizado como una máquina de estados.
    switch(EstadoActual){
      case ESTADO_INICIO://Solo se ejecuta una vez al empezar.
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
              TiempoAnterior=millis();//Se llama a EnviarDatos() cada 2 segundos.
              SistemaRiego.EnviarDatos();
          }
          EstadoActual=ESTADO_COMUNICACION;
          break;
      case ESTADO_COMUNICACION:
          SistemaRiego.LeerComandos();
          EstadoActual=ESTADO_LECTURA;//Vuelve al ESTADO_LECTURA para cerrar el ciclo.
          break;    
    }

