onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /textwriter_tb/reset
add wave -noupdate /textwriter_tb/clock
add wave -noupdate /textwriter_tb/selsincos
add wave -noupdate -divider Points
add wave -noupdate /textwriter_tb/i_dut/newpolynom
add wave -noupdate -radix unsigned /textwriter_tb/i_dut/i0/addry
add wave -noupdate -format Analog-Step -height 50 -max 32000.0 -min -32000.0 -radix decimal -subitemconfig {/textwriter_tb/i_dut/memx(15) {-radix decimal} /textwriter_tb/i_dut/memx(14) {-radix decimal} /textwriter_tb/i_dut/memx(13) {-radix decimal} /textwriter_tb/i_dut/memx(12) {-radix decimal} /textwriter_tb/i_dut/memx(11) {-radix decimal} /textwriter_tb/i_dut/memx(10) {-radix decimal} /textwriter_tb/i_dut/memx(9) {-radix decimal} /textwriter_tb/i_dut/memx(8) {-radix decimal} /textwriter_tb/i_dut/memx(7) {-radix decimal} /textwriter_tb/i_dut/memx(6) {-radix decimal} /textwriter_tb/i_dut/memx(5) {-radix decimal} /textwriter_tb/i_dut/memx(4) {-radix decimal} /textwriter_tb/i_dut/memx(3) {-radix decimal} /textwriter_tb/i_dut/memx(2) {-radix decimal} /textwriter_tb/i_dut/memx(1) {-radix decimal} /textwriter_tb/i_dut/memx(0) {-radix decimal}} /textwriter_tb/i_dut/memx
add wave -noupdate -format Analog-Step -height 50 -max 32000.0 -min -32000.0 -radix decimal /textwriter_tb/i_dut/memy
add wave -noupdate -divider Outputs
add wave -noupdate -format Analog-Step -height 50 -max 32000.0 -min -32000.0 -radix decimal /textwriter_tb/i_dut/i1/samplex
add wave -noupdate -format Analog-Step -height 50 -max 32000.0 -min -32000.0 -radix decimal /textwriter_tb/i_dut/i1/sampley
add wave -noupdate /textwriter_tb/outx
add wave -noupdate /textwriter_tb/outy
add wave -noupdate -format Analog-Step -height 100 -max 65500.0 -radix unsigned /textwriter_tb/lowpassout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
configure wave -namecolwidth 185
configure wave -valuecolwidth 40
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
WaveRestoreZoom {0 ns} {210 us}
