onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ahblite_tb/reset
add wave -noupdate /ahblite_tb/clock
add wave -noupdate -divider {AMBA bus}
add wave -noupdate -radix hexadecimal /ahblite_tb/haddr
add wave -noupdate /ahblite_tb/htrans
add wave -noupdate /ahblite_tb/hwrite
add wave -noupdate -radix hexadecimal /ahblite_tb/hwdata
add wave -noupdate -radix hexadecimal /ahblite_tb/hrdata
add wave -noupdate /ahblite_tb/hready
add wave -noupdate /ahblite_tb/hresp
add wave -noupdate -divider Peripherals
add wave -noupdate /ahblite_tb/hselv
add wave -noupdate /ahblite_tb/hselperiph1
add wave -noupdate -radix hexadecimal /ahblite_tb/hrdataperiph1
add wave -noupdate /ahblite_tb/hselperiph2
add wave -noupdate -radix hexadecimal /ahblite_tb/hrdataperiph2
add wave -noupdate -divider Registers
add wave -noupdate -radix hexadecimal /ahblite_tb/i_tester/registerarray(0)
add wave -noupdate -radix hexadecimal /ahblite_tb/i_tester/registerarray(1)
add wave -noupdate -radix hexadecimal /ahblite_tb/i_tester/registerarray(16)
add wave -noupdate -radix hexadecimal /ahblite_tb/i_tester/registerarray(17)
add wave -noupdate -radix hexadecimal -subitemconfig {/ahblite_tb/i_tester/registerarray(31) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(30) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(29) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(28) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(27) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(26) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(25) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(24) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(23) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(22) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(21) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(20) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(19) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(18) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(17) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(16) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(15) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(14) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(13) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(12) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(11) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(10) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(9) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(8) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(7) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(6) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(5) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(4) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(3) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(2) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(1) {-radix hexadecimal} /ahblite_tb/i_tester/registerarray(0) {-radix hexadecimal}} /ahblite_tb/i_tester/registerarray
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {525 ns}
