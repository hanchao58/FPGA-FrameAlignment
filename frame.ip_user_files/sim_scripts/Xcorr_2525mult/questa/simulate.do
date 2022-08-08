onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib Xcorr_2525mult_opt

do {wave.do}

view wave
view structure
view signals

do {Xcorr_2525mult.udo}

run -all

quit -force
