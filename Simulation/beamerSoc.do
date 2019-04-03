onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /beamersoc_tb/reset
add wave -noupdate /beamersoc_tb/clock
add wave -noupdate -divider Microprocessor
add wave -noupdate -radix hexadecimal -subitemconfig {/beamersoc_tb/i_dut/programcounter(9) {-height 15 -radix hexadecimal} /beamersoc_tb/i_dut/programcounter(8) {-height 15 -radix hexadecimal} /beamersoc_tb/i_dut/programcounter(7) {-height 15 -radix hexadecimal} /beamersoc_tb/i_dut/programcounter(6) {-height 15 -radix hexadecimal} /beamersoc_tb/i_dut/programcounter(5) {-height 15 -radix hexadecimal} /beamersoc_tb/i_dut/programcounter(4) {-height 15 -radix hexadecimal} /beamersoc_tb/i_dut/programcounter(3) {-height 15 -radix hexadecimal} /beamersoc_tb/i_dut/programcounter(2) {-height 15 -radix hexadecimal} /beamersoc_tb/i_dut/programcounter(1) {-height 15 -radix hexadecimal} /beamersoc_tb/i_dut/programcounter(0) {-height 15 -radix hexadecimal}} /beamersoc_tb/i_dut/programcounter
add wave -noupdate /beamersoc_tb/i_dut/i_up/instrstring
add wave -noupdate /beamersoc_tb/i_dut/i_up/i_ctrl/discardopcode
add wave -noupdate -radix hexadecimal -subitemconfig {/beamersoc_tb/i_dut/i_up/i_alu/i_regs/registerarray(0) {-height 15 -radix hexadecimal} /beamersoc_tb/i_dut/i_up/i_alu/i_regs/registerarray(1) {-height 15 -radix hexadecimal} /beamersoc_tb/i_dut/i_up/i_alu/i_regs/registerarray(2) {-height 15 -radix hexadecimal} /beamersoc_tb/i_dut/i_up/i_alu/i_regs/registerarray(3) {-height 15 -radix hexadecimal} /beamersoc_tb/i_dut/i_up/i_alu/i_regs/registerarray(4) {-height 15 -radix hexadecimal} /beamersoc_tb/i_dut/i_up/i_alu/i_regs/registerarray(5) {-height 15 -radix hexadecimal} /beamersoc_tb/i_dut/i_up/i_alu/i_regs/registerarray(6) {-height 15 -radix hexadecimal} /beamersoc_tb/i_dut/i_up/i_alu/i_regs/registerarray(7) {-height 15 -radix hexadecimal} /beamersoc_tb/i_dut/i_up/i_alu/i_regs/registerarray(8) {-height 15 -radix hexadecimal} /beamersoc_tb/i_dut/i_up/i_alu/i_regs/registerarray(9) {-height 15 -radix hexadecimal} /beamersoc_tb/i_dut/i_up/i_alu/i_regs/registerarray(10) {-height 15 -radix hexadecimal} /beamersoc_tb/i_dut/i_up/i_alu/i_regs/registerarray(11) {-height 15 -radix hexadecimal} /beamersoc_tb/i_dut/i_up/i_alu/i_regs/registerarray(12) {-height 15 -radix hexadecimal} /beamersoc_tb/i_dut/i_up/i_alu/i_regs/registerarray(13) {-height 15 -radix hexadecimal} /beamersoc_tb/i_dut/i_up/i_alu/i_regs/registerarray(14) {-height 15 -radix hexadecimal} /beamersoc_tb/i_dut/i_up/i_alu/i_regs/registerarray(15) {-height 15 -radix hexadecimal}} /beamersoc_tb/i_dut/i_up/i_alu/i_regs/registerarray
add wave -noupdate /beamersoc_tb/i_dut/upreadstrobe
add wave -noupdate /beamersoc_tb/i_dut/upwritestrobe
add wave -noupdate -divider {AMBA bus}
add wave -noupdate -radix hexadecimal -subitemconfig {/beamersoc_tb/i_dut/haddr(15) {-radix hexadecimal} /beamersoc_tb/i_dut/haddr(14) {-radix hexadecimal} /beamersoc_tb/i_dut/haddr(13) {-radix hexadecimal} /beamersoc_tb/i_dut/haddr(12) {-radix hexadecimal} /beamersoc_tb/i_dut/haddr(11) {-radix hexadecimal} /beamersoc_tb/i_dut/haddr(10) {-radix hexadecimal} /beamersoc_tb/i_dut/haddr(9) {-radix hexadecimal} /beamersoc_tb/i_dut/haddr(8) {-radix hexadecimal} /beamersoc_tb/i_dut/haddr(7) {-radix hexadecimal} /beamersoc_tb/i_dut/haddr(6) {-radix hexadecimal} /beamersoc_tb/i_dut/haddr(5) {-radix hexadecimal} /beamersoc_tb/i_dut/haddr(4) {-radix hexadecimal} /beamersoc_tb/i_dut/haddr(3) {-radix hexadecimal} /beamersoc_tb/i_dut/haddr(2) {-radix hexadecimal} /beamersoc_tb/i_dut/haddr(1) {-radix hexadecimal} /beamersoc_tb/i_dut/haddr(0) {-radix hexadecimal}} /beamersoc_tb/i_dut/haddr
add wave -noupdate /beamersoc_tb/i_dut/htrans
add wave -noupdate /beamersoc_tb/i_dut/hwrite
add wave -noupdate -radix hexadecimal /beamersoc_tb/i_dut/hwdata
add wave -noupdate -radix hexadecimal /beamersoc_tb/i_dut/hrdata
add wave -noupdate /beamersoc_tb/i_dut/hready
add wave -noupdate /beamersoc_tb/i_dut/hresp
add wave -noupdate -divider GPIO
add wave -noupdate -radix hexadecimal -subitemconfig {/beamersoc_tb/io(7) {-radix hexadecimal} /beamersoc_tb/io(6) {-radix hexadecimal} /beamersoc_tb/io(5) {-radix hexadecimal} /beamersoc_tb/io(4) {-radix hexadecimal} /beamersoc_tb/io(3) {-radix hexadecimal} /beamersoc_tb/io(2) {-radix hexadecimal} /beamersoc_tb/io(1) {-radix hexadecimal} /beamersoc_tb/io(0) {-radix hexadecimal}} /beamersoc_tb/io
add wave -noupdate -divider UART
add wave -noupdate -radix hexadecimal /beamersoc_tb/i_tester/uartrxdata
add wave -noupdate /beamersoc_tb/rxd
add wave -noupdate /beamersoc_tb/txd
add wave -noupdate -radix hexadecimal /beamersoc_tb/i_tester/uarttxdata
add wave -noupdate -divider {Beamer registers}
add wave -noupdate /beamersoc_tb/i_dut/hselv
add wave -noupdate /beamersoc_tb/i_dut/hselbeamer
add wave -noupdate -radix hexadecimal /beamersoc_tb/i_dut/i_beamer/i_regs/addr
add wave -noupdate /beamersoc_tb/i_dut/i_beamer/i_regs/selcontrol
add wave -noupdate /beamersoc_tb/i_dut/i_beamer/i_regs/selspeed
add wave -noupdate /beamersoc_tb/i_dut/i_beamer/i_regs/selx
add wave -noupdate /beamersoc_tb/i_dut/i_beamer/i_regs/sely
add wave -noupdate /beamersoc_tb/i_dut/i_beamer/run
add wave -noupdate /beamersoc_tb/i_dut/i_beamer/i_regs/updatepattern
add wave -noupdate /beamersoc_tb/i_dut/i_beamer/interpolatelin
add wave -noupdate -radix unsigned /beamersoc_tb/i_dut/i_beamer/i_regs/patternsize
add wave -noupdate -radix unsigned /beamersoc_tb/i_dut/i_beamer/updateperiod
add wave -noupdate -divider Internals
add wave -noupdate /beamersoc_tb/i_dut/i_beamer/i_op/interpolationenable
add wave -noupdate /beamersoc_tb/i_dut/i_beamer/newpolynom
add wave -noupdate /beamersoc_tb/i_dut/i_uart/rxdataready
add wave -noupdate -divider Waveforms
add wave -noupdate -format Analog-Step -height 50 -max 32000.0 -min -32000.0 -radix decimal /beamersoc_tb/i_dut/i_beamer/i_op/samplesx
add wave -noupdate -format Analog-Step -height 50 -max 32000.0 -min -32000.0 -radix decimal /beamersoc_tb/i_dut/i_beamer/i_op/samplesy
add wave -noupdate -format Analog-Step -height 50 -max 65500.0 -radix unsigned /beamersoc_tb/i_dut/i_beamer/i_op/unsignedy
add wave -noupdate -format Analog-Step -height 50 -max 48000.0 -min 16000.0 -radix unsigned /beamersoc_tb/lowpassouty
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 300
configure wave -valuecolwidth 55
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {1417500 ns}
