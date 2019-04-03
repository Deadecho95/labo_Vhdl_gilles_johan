onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /waveformgen_tb/reset
add wave -noupdate /waveformgen_tb/clock
add wave -noupdate /waveformgen_tb/en
add wave -noupdate -divider {generator signals}
add wave -noupdate -format Analog-Step -height 70 -max 66000.0 -radix unsigned /waveformgen_tb/i_dut/sawtooth
add wave -noupdate -format Analog-Step -height 70 -max 66000.0 -radix unsigned /waveformgen_tb/i_dut/square
add wave -noupdate -format Analog-Step -height 70 -max 66000.0 -radix unsigned /waveformgen_tb/i_dut/triangle
add wave -noupdate -format Analog-Step -height 70 -max 66000.0 -radix unsigned /waveformgen_tb/i_dut/polygon
add wave -noupdate -format Analog-Step -height 70 -max 66000.0 -radix unsigned /waveformgen_tb/i_dut/sine
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 198
configure wave -valuecolwidth 89
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
configure wave -timelineunits ms
update
WaveRestoreZoom {0 ps} {1050 us}
