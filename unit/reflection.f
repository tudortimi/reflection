-incdir ../../dependencies/vpi/sv
../../dependencies/vpi/sv/*.sv
../../dependencies/vpi/c/*.c

-incdir ../../sv
../../sv/*.sv


-nowarn SPDUSD
-nowarn DSEMEL:DSEM2009

# without full visibility, vpiClassObjs aren't dereferenced through vpiClassVars
-access rwc
