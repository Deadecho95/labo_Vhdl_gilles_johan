onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sinegen_tb/reset
add wave -noupdate /sinegen_tb/clock
add wave -noupdate -format Analog-Step -height 30 -max 1300.0 -radix unsigned /sinegen_tb/i_dut/phase
add wave -noupdate -divider {generator signals}
add wave -noupdate -format Analog-Step -height 40 -max 66000.0 -radix unsigned /sinegen_tb/i_dut/sawtooth
add wave -noupdate -format Analog-Step -height 40 -max 66000.0 -radix unsigned /sinegen_tb/i_dut/square
add wave -noupdate -format Analog-Step -height 40 -max 66000.0 -radix unsigned /sinegen_tb/i_dut/triangle
add wave -noupdate -divider sinewave
add wave -noupdate -format Analog-Step -height 80 -max 43200.0 -min -32800.0 -radix decimal /sinegen_tb/i_dut/sinesamples
add wave -noupdate /sinegen_tb/i_dut/newpolynom
add wave -noupdate -radix decimal /sinegen_tb/i_dut/a
add wave -noupdate -radix decimal /sinegen_tb/i_dut/b
add wave -noupdate -radix decimal /sinegen_tb/i_dut/c
add wave -noupdate -radix decimal /sinegen_tb/i_dut/d
add wave -noupdate -format Analog-Step -height 80 -max 76000.0 -radix unsigned /sinegen_tb/i_dut/sine
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
configure wave -namecolwidth 198
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
WaveRestoreZoom {0 ns} {52500 ns}
