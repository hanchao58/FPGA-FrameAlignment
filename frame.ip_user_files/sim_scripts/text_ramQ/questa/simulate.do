onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib text_ramQ_opt

do {wave.do}

view wave
view structure
view signals

do {text_ramQ.udo}

run -all

quit -force
