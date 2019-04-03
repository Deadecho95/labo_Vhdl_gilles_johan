onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /beamersystem_tb/reset_n
add wave -noupdate /beamersystem_tb/clock
add wave -noupdate -divider Controls
add wave -noupdate /beamersystem_tb/i0/run
add wave -noupdate /beamersystem_tb/i0/interpolatelin
add wave -noupdate -radix hexadecimal /beamersystem_tb/i0/updateperiod
add wave -noupdate -divider {X-Y waves}
add wave -noupdate /beamersystem_tb/i0/newpolynom
add wave -noupdate -format Analog-Step -height 50 -max 32500.0 -min -32500.0 -radix decimal /beamersystem_tb/i0/memx
add wave -noupdate -format Analog-Step -height 50 -max 32500.0 -min -32500.0 -radix decimal /beamersystem_tb/i0/memy
add wave -noupdate -divider Interpolation
add wave -noupdate /beamersystem_tb/i0/i1/interpolationenable
add wave -noupdate -format Analog-Step -height 50 -max 32500.0 -min -32500.0 -radix decimal /beamersystem_tb/i0/i1/samplex
add wave -noupdate -format Analog-Step -height 50 -max 32500.0 -min -32500.0 -radix decimal /beamersystem_tb/i0/i1/sampley
add wave -noupdate -divider Output
add wave -noupdate /beamersystem_tb/outy
add wave -noupdate -format Analog-Step -height 50 -max 49500.0 -min 16500.0 -radix unsigned /beamersystem_tb/lowpassout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {418837 ns} 0}
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
configure wave -timelineunits ms
update
WaveRestoreZoom {0 ns} {2100 us}
