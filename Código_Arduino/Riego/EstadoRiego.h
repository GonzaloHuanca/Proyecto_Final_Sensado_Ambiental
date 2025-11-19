//EstadoRiego.h
#ifndef ESTADO_RIEGO_H//Evita la doble inclusión
#define ESTADO_RIEGO_H

enum EstadoRiego{//Se enumera una lista de estados posibles que se utilizan para una máquina de estados
  ESTADO_INICIO,
  ESTADO_LECTURA,
  ESTADO_CONTROL,
  ESTADO_ENVIO,
  ESTADO_COMUNICACION,
}; 
#endif//Fin de la protección   
