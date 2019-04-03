onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sinewavegenerator_tb/reset
add wave -noupdate /sinewavegenerator_tb/clock
add wave -noupdate -divider Internals
add wave -noupdate -radix decimal /sinewavegenerator_tb/i_dut/imagproduct
add wave -noupdate -radix decimal /sinewavegenerator_tb/i_dut/realproduct
add wave -noupdate -radix decimal /sinewavegenerator_tb/i_dut/imagpart
add wave -noupdate -radix decimal /sinewavegenerator_tb/i_dut/realpart
add wave -noupdate -divider Outputs
add wave -noupdate -format Analog-Step -height 100 -max 500.0 -min -500.0 -radix decimal -subitemconfig {/sinewavegenerator_tb/sine(9) {-radix decimal} /sinewavegenerator_tb/sine(8) {-radix decimal} /sinewavegenerator_tb/sine(7) {-radix decimal} /sinewavegenerator_tb/sine(6) {-radix decimal} /sinewavegenerator_tb/sine(5) {-radix decimal} /sinewavegenerator_tb/sine(4) {-radix decimal} /sinewavegenerator_tb/sine(3) {-radix decimal} /sinewavegenerator_tb/sine(2) {-radix decimal} /sinewavegenerator_tb/sine(1) {-radix decimal} /sinewavegenerator_tb/sine(0) {-radix decimal}} /sinewavegenerator_tb/sine
add wave -noupdate -format Analog-Step -height 100 -max 500.0 -min -500.0 -radix decimal -subitemconfig {/sinewavegenerator_tb/cosine(9) {-radix decimal} /sinewavegenerator_tb/cosine(8) {-radix decimal} /sinewavegenerator_tb/cosine(7) {-radix decimal} /sinewavegenerator_tb/cosine(6) {-radix decimal} /sinewavegenerator_tb/cosine(5) {-radix decimal} /sinewavegenerator_tb/cosine(4) {-radix decimal} /sinewavegenerator_tb/cosine(3) {-radix decimal} /sinewavegenerator_tb/cosine(2) {-radix decimal} /sinewavegenerator_tb/cosine(1) {-radix decimal} /sinewavegenerator_tb/cosine(0) {-radix decimal}} /sinewavegenerator_tb/cosine
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 251
configure wave -valuecolwidth 52
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
WaveRestoreZoom {0 ps} {1050 ns}
