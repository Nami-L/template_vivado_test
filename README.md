# Repositorio para Diseño RTL y Testbench en Vivado

Este repositorio tiene como objetivo compilar, simular y analizar diseños RTL desde la terminal, evitando depender de la interfaz gráfica (GUI) de Vivado. De esta forma es posible automatizar el flujo de trabajo y mantener un entorno de desarrollo reproducible.

---

# Configuración del ambiente de trabajo

Antes de compilar o simular, es necesario crear un directorio de trabajo y configurar algunas variables de entorno.

## ¿Qué hace cada comando?

### Obtener la raíz del proyecto

```bash
git rev-parse --show-toplevel
```

Devuelve la ruta absoluta del repositorio Git, sin importar desde qué carpeta del proyecto se ejecute el comando.

Por ejemplo:

```text
/home/luis/proyectos/rtl_project
```

---

### Exportar variables de entorno

```bash
export GIT_ROOT=$(git rev-parse --show-toplevel)
```

La instrucción `export` almacena la ruta del proyecto en la variable `GIT_ROOT`, permitiendo utilizar una única referencia para acceder a cualquier archivo del repositorio sin depender del directorio actual.

Esto evita escribir rutas absolutas y hace que los scripts sean portables.

---

### ¿Qué es Bash?

**Bash (Bourne Again Shell)** es el intérprete de comandos utilizado por la mayoría de las terminales en Linux y macOS.

Cuando se escribe un comando como:

```bash
mkdir
cd
cp
git
```

es Bash quien interpreta la instrucción y la envía al sistema operativo para ejecutarla.

---

### ¿Qué es el Shell?

El **Shell** es el programa encargado de recibir comandos y comunicarse con el sistema operativo.

En un Makefile, el Shell es quien ejecuta todas las instrucciones que aparecen dentro de cada *target*.

---

# Flujo de trabajo para Testbench Directo

Crear el ambiente de trabajo:

```bash
export GIT_ROOT=$(git rev-parse --show-toplevel)
export DIRECT_WORK="$GIT_ROOT/work/direct"
mkdir -p "$DIRECT_WORK" && \
cd "$DIRECT_WORK" && \
ln -sf "$GIT_ROOT/scripts/makefiles/Makefile.xilinx" Makefile && \
make
```

Una vez creado el entorno, se utilizan los siguientes comandos.

```bash
make compile
make elaborate
make sim VERBOSITY=UVM_DEBUG
make sim GUI_MODE=true
```

## Descripción de cada comando

| Comando | Descripción |
|----------|-------------|
| `make compile` | Compila el diseño RTL y el testbench. |
| `make elaborate` | Elabora (construye) el diseño para preparar la simulación. |
| `make sim` | Ejecuta la simulación. |
| `make sim VERBOSITY=UVM_DEBUG` | Ejecuta la simulación mostrando mensajes de depuración UVM. |
| `make sim GUI_MODE=true` | Ejecuta la simulación abriendo la interfaz gráfica de Vivado. |

---

# Flujo de trabajo para UVM

Para utilizar el ambiente de verificación basado en UVM:

```bash
export GIT_ROOT=$(git rev-parse --show-toplevel)
export UVM_WORK="$GIT_ROOT/work/uvm"
mkdir -p "$UVM_WORK" && \
cd "$UVM_WORK" && \
ln -sf "$GIT_ROOT/verification/scripts/makefiles/Makefile.xilinx" Makefile && \
make
```

A partir de este punto se utilizan los mismos comandos (`compile`, `elaborate` y `sim`) para ejecutar las simulaciones.

---

# Makefile

## ¿Cómo ejecuta comandos un Makefile?

Todo lo que aparece tabulado dentro de un *target* ya se considera un comando de terminal.

Por ejemplo:

```make
clean:
	rm -rf $(RUN_DIR) $(LOGS_DIR) $(WDB_DIR)
```

Cuando se ejecuta:

```bash
make clean
```

`make` envía automáticamente esa línea al Shell.

No es necesario utilizar `$(shell ...)` porque esas instrucciones ya serán ejecutadas directamente por la terminal.

---

## ¿Cuándo se utiliza `$(shell ...)`?

`$(shell ...)` sirve para capturar el resultado de un comando de terminal y almacenarlo dentro de una variable del Makefile.

Por ejemplo:

```make
PROJ_ROOT := $(shell git rev-parse --show-toplevel)
```

Aquí ocurre lo siguiente:

1. Se ejecuta el comando:

```bash
git rev-parse --show-toplevel
```

2. El resultado se guarda en la variable:

```make
PROJ_ROOT
```

Posteriormente puede utilizarse durante todo el Makefile.

Este mecanismo suele emplearse para obtener información fija del sistema, por ejemplo:

- Ruta del proyecto.
- Fecha.
- Versión del compilador.
- Nombre del sistema operativo.

Generalmente estas variables se inicializan al comienzo del Makefile y se evalúan cada vez que se ejecuta `make`.

---

# `fork...join` en SystemVerilog

La sentencia `fork` permite ejecutar varios procesos en paralelo.

El comportamiento depende del tipo de `join` utilizado al finalizar el bloque.

---

# Caso 1: Un único `begin/end`

```systemverilog
fork
    begin
        send_data_port_a();
        send_data_port_b();
    end
join_any
```

Aunque exista un `fork`, únicamente hay **un hilo**.

Las tareas se ejecutan de forma secuencial:

```
Puerto A
    ↓
Puerto B
```

El `join_any` no tiene ningún efecto especial, ya que solamente existe un proceso paralelo.

La ejecución continuará únicamente cuando termine la segunda tarea.

---

# Caso 2: Un hilo por tarea

```systemverilog
fork
    send_data_port_a();
    send_data_port_b();
join_any
```

También puede escribirse como:

```systemverilog
fork
    begin
        send_data_port_a();
    end

    begin
        send_data_port_b();
    end
join_any
```

En ambos casos existen **dos hilos independientes**.

```
Tiempo

Puerto A ───────────────►

Puerto B ─────────────────────────►
```

Las dos tareas comienzan exactamente al mismo tiempo.

El `join_any` continuará la ejecución en cuanto la primera tarea termine, mientras que la otra seguirá ejecutándose en segundo plano.

---

# Resumen

Si varias tareas están dentro del mismo `begin/end`, forman un único hilo y se ejecutan secuencialmente.

Si cada tarea está fuera del `begin/end`, o cada una tiene su propio `begin/end`, cada una se convierte en un hilo independiente y todas comienzan en paralelo.

---

# `fork...join`

`join` espera a que **todos** los procesos terminen antes de continuar.

```systemverilog
fork
    send_data_port_a(); // 10 ns
    send_data_port_b(); // 20 ns
join
```

### Comportamiento

```
Puerto A ─────────► 10 ns

Puerto B ─────────────────────► 20 ns

Continúa aquí ───────────────► 20 ns
```

Aunque el Puerto A termine primero, la simulación permanecerá bloqueada hasta que el Puerto B también finalice.

Es el comportamiento más utilizado cuando se necesita garantizar que todos los estímulos terminaron antes de continuar con la siguiente fase de la prueba.

---

# `fork...join_any`

`join_any` espera únicamente al **primer proceso** que termine.

```systemverilog
fork
    send_data_port_a(); // 10 ns
    send_data_port_b(); // 20 ns
join_any
```

### Comportamiento

```
Puerto A ─────────► 10 ns

Puerto B ─────────────────────► 20 ns

Continúa aquí ─────► 10 ns
```

En el instante en que el Puerto A termina, la ejecución continúa inmediatamente.

El Puerto B sigue ejecutándose en segundo plano.

Este mecanismo suele utilizarse para implementar:

- Timeouts.
- Esperar el primer evento que ocurra.
- Competencias entre procesos (*race conditions* controladas).

---

# `fork...join_none`

`join_none` no espera absolutamente a ningún proceso.

```systemverilog
fork
    send_data_port_a();
    send_data_port_b();
join_none
```

### Comportamiento

```
Puerto A ─────────────►

Puerto B ─────────────────►

Programa principal ─► continúa inmediatamente
```

El código situado debajo del `join_none` comienza a ejecutarse inmediatamente, mientras los procesos lanzados por el `fork` continúan ejecutándose en segundo plano.

Es especialmente útil para iniciar procesos permanentes, por ejemplo:

- Monitores.
- Scoreboards.
- Drivers auxiliares.
- Generadores de reloj.
- Procesos de supervisión.

---

# Comparación de los tipos de `join`

| Tipo | ¿Cuándo continúa la ejecución? | Uso típico |
|-------|--------------------------------|-----------|
| **`join`** | Cuando **todos** los hilos terminan. | Esperar que todos los estímulos concluyan antes de continuar con la prueba. |
| **`join_any`** | Cuando **el primer** hilo termina. | Implementar *timeouts*, esperar el primer evento o detectar cuál proceso finaliza primero. |
| **`join_none`** | **Inmediatamente**, sin esperar a ningún hilo. | Lanzar procesos de fondo como monitores, scoreboards o relojes sin bloquear la simulación. |

---

# Ideas clave

- Un `fork` únicamente crea paralelismo entre los procesos que contiene.
- Un solo `begin/end` representa **un único hilo**.
- Varias tareas fuera del `begin/end` representan **múltiples hilos**.
- `join` espera a todos.
- `join_any` espera al primero.
- `join_none` no espera a ninguno.