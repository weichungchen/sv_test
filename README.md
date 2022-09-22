# sv_test

how to run these cases

cmd > vcs +vcs+lic+wait -R -sverilog test.sv -l test.log +define+copy_fun2


parameter means

+vcs+lic+wait      : wait license

-sverilog test.sv  : specify which file you want to execute, there is only one file, test.sv, can use

-l test.log        : dump log file. if you don't want this option, please remove it

+define+copy_fun2  : replace copy_fun2 and fill out testing case name which follows \`ifdef or \`elsif
