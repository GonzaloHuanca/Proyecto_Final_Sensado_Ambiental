Sistema de Riego Automático – Arduino + Processing

Este proyecto implementa un sistema de riego automático utilizando Arduino para la lectura de sensores y control de una bomba de agua, y Processing para la visualización y almacenamiento de los datos en un archivo CSV.
El objetivo es monitorear humedad del suelo, humedad del aire y temperatura, y activar la bomba según la lógica configurada.

Descripción General

El sistema está compuesto por dos partes:

1. Arduino

Se encarga de:

Medir humedad del suelo, humedad del aire y temperatura.
Ejecutar una máquina de estados para controlar el flujo del programa.
Activar o desactivar la bomba en modo automático o modo manual.
Enviar al puerto serie una línea de texto con los valores actuales.
2. Processing

Se encarga de:

Conectarse al puerto serie elegido.
Recibir y procesar cada línea enviada por Arduino.
Extraer los valores y actualizar variables.
Registrar todos los datos en un archivo CSV junto con fecha y hora.
Enviar comandos al Arduino cuando sea necesario.

