onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fpga_sinegen_tb/reset
add wave -noupdate /fpga_sinegen_tb/clock
add wave -noupdate -divider {Function generator}
add wave -noupdate -format Analog-Step -height 100 -max 40000.0 -min -32000.0 -radix decimal /fpga_sinegen_tb/i0/i3/sinesamples
add wave -noupdate -divider Coefficients
add wave -noupdate -radix decimal /fpga_sinegen_tb/i0/i3/a
add wave -noupdate -radix decimal /fpga_sinegen_tb/i0/i3/b
add wave -noupdate -radix decimal /fpga_sinegen_tb/i0/i3/c
add wave -noupdate -radix decimal /fpga_sinegen_tb/i0/i3/d
add wave -noupdate -radix decimal /fpga_sinegen_tb/i0/i7/a
add wave -noupdate -radix decimal /fpga_sinegen_tb/i0/i7/b
add wave -noupdate -radix decimal /fpga_sinegen_tb/i0/i7/c
add wave -noupdate -radix decimal /fpga_sinegen_tb/i0/i7/d
add wave -noupdate -divider Outputs
add wave -noupdate /fpga_sinegen_tb/xout
add wave -noupdate /fpga_sinegen_tb/yout
add wave -noupdate /fpga_sinegen_tb/triggerout
add wave -noupdate -divider Lowpasses
add wave -noupdate -format Analog-Step -height 20 -max 131000.0 -radix unsigned /fpga_sinegen_tb/i0/i3/phase
add wave -noupdate -format Analog-Step -height 100 -max 24000.0 -min 8000.0 -radix unsigned /fpga_sinegen_tb/lowpassoutx
add wave -noupdate -format Analog-Step -height 40 -max 131000.0 -radix unsigned /fpga_sinegen_tb/i0/i7/phase
add wave -noupdate -format Analog-Step -height 100 -max 24000.0 -min 8000.0 -radix unsigned /fpga_sinegen_tb/lowpassouty
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {156383 ns} 0}
configure wave -namecolwidth 276
configure wave -valuecolwidth 64
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ns} {2100 us}
