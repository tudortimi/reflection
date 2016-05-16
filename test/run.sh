irun \
  -access rwc \
  \
  -incdir ../dependencies/vpi/sv \
  ../dependencies/vpi/sv/vpi.sv \
  ../dependencies/vpi/c/vpi.c \
  \
  -incdir ../sv \
  ../sv/reflection.sv \
  \
  -incdir sv \
  sv/some_package.sv \
  test.sv
