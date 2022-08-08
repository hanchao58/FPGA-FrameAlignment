onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib Cmult_xcorr_opt

do {wave.do}

view wave
view structure
view signals

do {Cmult_xcorr.udo}

run -all

quit -force
