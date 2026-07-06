# Repositorio para diseño de RTL y TB en VIVADO

Este repositorio tiene el objetivo de poder simular, compilar y observar el diseño y pruebas a traves de comando y no ejecutando el GUI de vivado-




A continuación se colocan una serie de comando que deben ejecutarse desde terminal.
Las sigueitne lineas nos permitira tener un ambiente de trabajo estructurado conel objetivo de evitar malas rutas al momento de buscar los archivos necesarios para poder trabajar

 * Testbench Directo
 * 
```bash
export GIT_ROOT=$(git rev-parse --show-toplevel)
export UVM_WORK="$GIT_ROOT/work/direct"
mkdir -p work/direct && cd work/direct
ln -sf $GIT_ROOT/scripts/makefiles/Makefile.xilinx Makefile
make
```
Despues de realizar los pasos anteriores que es para crear nuestro ambiente en donde vamos a trabajar. debemos ejecutar los  siguientes comandos 

    make compile
    make elaborate
    make sim VERBOSITY=UVM_DEBUG #Solo ver mensajes
    make sim GUI_MODE=true # abrir la interfaz grafica

  * **make compile** =  permite * compilar nuestro RTL
  * **make elaborate** = permite  correr nuestro proyecto.
  * **make sim** = Permite mostrar los resultados de la simulación y con la bandera **GUI_MODE** nos permitira abrir la interfas gráfica.

* Introducción a la verificación 
* 
```bash
export GIT_ROOT=$(git rev-parse --show-toplevel)
export UVM_WORK="$GIT_ROOT/work/uvm"
mkdir -p work/uvm && cd work/uvm
ln -sf $GIT_ROOT/verification/scripts/makefiles/Makefile.xilinx Makefile
make
```