onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Operands
add wave -noupdate /paralleladder_tb/cin
add wave -noupdate -radix hexadecimal /paralleladder_tb/a
add wave -noupdate -radix hexadecimal /paralleladder_tb/b
add wave -noupdate -divider Result
add wave -noupdate -radix hexadecimal /paralleladder_tb/i1/sum_int
add wave -noupdate -radix hexadecimal /paralleladder_tb/sum
add wave -noupdate /paralleladder_tb/cout
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
WaveRestoreZoom {0 ns} {265 ns}
