onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ahbbeamer_tb/hreset_n
add wave -noupdate /ahbbeamer_tb/hclk
add wave -noupdate /ahbbeamer_tb/selsincos
add wave -noupdate -divider {AMBA bus}
add wave -noupdate -radix hexadecimal /ahbbeamer_tb/haddr
add wave -noupdate /ahbbeamer_tb/htrans
add wave -noupdate /ahbbeamer_tb/hsel
add wave -noupdate /ahbbeamer_tb/hwrite
add wave -noupdate -radix hexadecimal /ahbbeamer_tb/hwdata
add wave -noupdate -radix hexadecimal -subitemconfig {/ahbbeamer_tb/hrdata(15) {-height 15 -radix hexadecimal} /ahbbeamer_tb/hrdata(14) {-height 15 -radix hexadecimal} /ahbbeamer_tb/hrdata(13) {-height 15 -radix hexadecimal} /ahbbeamer_tb/hrdata(12) {-height 15 -radix hexadecimal} /ahbbeamer_tb/hrdata(11) {-height 15 -radix hexadecimal} /ahbbeamer_tb/hrdata(10) {-height 15 -radix hexadecimal} /ahbbeamer_tb/hrdata(9) {-height 15 -radix hexadecimal} /ahbbeamer_tb/hrdata(8) {-height 15 -radix hexadecimal} /ahbbeamer_tb/hrdata(7) {-height 15 -radix hexadecimal} /ahbbeamer_tb/hrdata(6) {-height 15 -radix hexadecimal} /ahbbeamer_tb/hrdata(5) {-height 15 -radix hexadecimal} /ahbbeamer_tb/hrdata(4) {-height 15 -radix hexadecimal} /ahbbeamer_tb/hrdata(3) {-height 15 -radix hexadecimal} /ahbbeamer_tb/hrdata(2) {-height 15 -radix hexadecimal} /ahbbeamer_tb/hrdata(1) {-height 15 -radix hexadecimal} /ahbbeamer_tb/hrdata(0) {-height 15 -radix hexadecimal}} /ahbbeamer_tb/hrdata
add wave -noupdate /ahbbeamer_tb/hready
add wave -noupdate /ahbbeamer_tb/hresp
add wave -noupdate -divider Registers
add wave -noupdate /ahbbeamer_tb/i_dut/run
add wave -noupdate /ahbbeamer_tb/i_dut/i_regs/updatepattern
add wave -noupdate /ahbbeamer_tb/i_dut/interpolatelin
add wave -noupdate -radix unsigned /ahbbeamer_tb/i_dut/i_regs/patternsize
add wave -noupdate -radix unsigned /ahbbeamer_tb/i_dut/updateperiod
add wave -noupdate /ahbbeamer_tb/i_tester/registerdatain
add wave -noupdate -divider Internals
add wave -noupdate /ahbbeamer_tb/i_dut/i_op/interpolationenable
add wave -noupdate /ahbbeamer_tb/i_dut/newpolynom
add wave -noupdate -divider Waveforms
add wave -noupdate -format Analog-Step -height 50 -max 32000.0 -min -32000.0 -radix decimal /ahbbeamer_tb/i_dut/i_op/samplesx
add wave -noupdate -format Analog-Step -height 50 -max 32000.0 -min -32000.0 -radix decimal /ahbbeamer_tb/i_dut/i_op/samplesy
add wave -noupdate -format Analog-Step -height 50 -max 65500.0 -radix unsigned /ahbbeamer_tb/i_dut/i_op/unsignedy
add wave -noupdate -format Analog-Step -height 50 -max 65500.0 -radix unsigned /ahbbeamer_tb/lowpassouty
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {821538462 ps} 0}
configure wave -namecolwidth 255
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
WaveRestoreZoom {0 ps} {1050 us}
