# template_vivado_test
Este repositorio tiene el objetivo de poder simular, compilar y observar el diseño y pruebas a traves de comando y no ejecutando el GUI de vivad.




A continuación se colocan una serie de comando que deben ejecutarse desde terminal.

```bash
export GIT_ROOT=$(git rev-parse --show-toplevel)
export UVM_WORK="$GIT_ROOT/work/direct"
mkdir -p work/direct && cd work/direct
ln -sf $GIT_ROOT/compuerta_and/scripts/makefiles/Makefile.xilinx Makefile
make
```
