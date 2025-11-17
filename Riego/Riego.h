#ifndef RIEGO_H// Si no está definido RIEGO_H lo siguiente se procesará.
#define RIEGO_H// Se define RIEGO_H, de tal manera que el compilador solo lo procese una vez.
#include <Arduino.h>
#include <DHT.h>//Librería del sensor DHT22
#include <EEPROM.h>//permite leer y escribir datos en la memoria EERPROM (memoria no volátil) de arduino.

class Riego{
    private:
        //Se guardan los pines usados en hardware.
        int PinSensorSuelo;
        int PinRele;
        int PinDHT;
    DHT dht;// Crea un objeto DHT para facilitar el llamado de funciones propias de la librería. 
    //Lectura de sensores.
    float HumedadSuelo;
    float HumedadAire;
    float Temperatura;
    //Umbrales para oscilasiones
    int HumedadSueloBaja;
    int HumedadSueloAlta;
    //Control de bomba.
    bool BombaEncendida;// Guarda el estado de la bomba.
    bool ModoAutomatico;// Indica si el manejo de la bomba será automatico o manual. 
    //Variables para temporización.
    unsigned long TiempoAnterior;
    unsigned long IntervaloEnvio;

public: 
    //Constructor.
    Riego(int PinSuelo,int PinRelay, int PinSensorDHT,int TipoDHT);
    
    void Iniciar();
    void LeerSensores();
    void ControlarBomba();
    void EnviarDatos();
    void LeerComandos();
    void GuardarDatosEEPROM();
    void MostrarDatosEEPROM();
    float AccederHumedadSuelo();
    float AccederTemperatura();
    float AccederHumedadAire();
	void EncenderBomba();
	void ApagarBomba();
};

#endif//Fin del código protegido. 

