onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pipelineadder_tb/reset
add wave -noupdate /pipelineadder_tb/clock
add wave -noupdate -divider Operands
add wave -noupdate -radix hexadecimal -subitemconfig {/pipelineadder_tb/a(31) {-radix hexadecimal} /pipelineadder_tb/a(30) {-radix hexadecimal} /pipelineadder_tb/a(29) {-radix hexadecimal} /pipelineadder_tb/a(28) {-radix hexadecimal} /pipelineadder_tb/a(27) {-radix hexadecimal} /pipelineadder_tb/a(26) {-radix hexadecimal} /pipelineadder_tb/a(25) {-radix hexadecimal} /pipelineadder_tb/a(24) {-radix hexadecimal} /pipelineadder_tb/a(23) {-radix hexadecimal} /pipelineadder_tb/a(22) {-radix hexadecimal} /pipelineadder_tb/a(21) {-radix hexadecimal} /pipelineadder_tb/a(20) {-radix hexadecimal} /pipelineadder_tb/a(19) {-radix hexadecimal} /pipelineadder_tb/a(18) {-radix hexadecimal} /pipelineadder_tb/a(17) {-radix hexadecimal} /pipelineadder_tb/a(16) {-radix hexadecimal} /pipelineadder_tb/a(15) {-radix hexadecimal} /pipelineadder_tb/a(14) {-radix hexadecimal} /pipelineadder_tb/a(13) {-radix hexadecimal} /pipelineadder_tb/a(12) {-radix hexadecimal} /pipelineadder_tb/a(11) {-radix hexadecimal} /pipelineadder_tb/a(10) {-radix hexadecimal} /pipelineadder_tb/a(9) {-radix hexadecimal} /pipelineadder_tb/a(8) {-radix hexadecimal} /pipelineadder_tb/a(7) {-radix hexadecimal} /pipelineadder_tb/a(6) {-radix hexadecimal} /pipelineadder_tb/a(5) {-radix hexadecimal} /pipelineadder_tb/a(4) {-radix hexadecimal} /pipelineadder_tb/a(3) {-radix hexadecimal} /pipelineadder_tb/a(2) {-radix hexadecimal} /pipelineadder_tb/a(1) {-radix hexadecimal} /pipelineadder_tb/a(0) {-radix hexadecimal}} /pipelineadder_tb/a
add wave -noupdate -radix hexadecimal /pipelineadder_tb/b
add wave -noupdate /pipelineadder_tb/cin
add wave -noupdate -divider Internals
add wave -noupdate /pipelineadder_tb/i0/carryin
add wave -noupdate -radix hexadecimal /pipelineadder_tb/i0/a_int
add wave -noupdate -radix hexadecimal /pipelineadder_tb/i0/b_int
add wave -noupdate -radix hexadecimal /pipelineadder_tb/i0/sum_int
add wave -noupdate -radix hexadecimal /pipelineadder_tb/i1/sumnopipe
add wave -noupdate -divider Result
add wave -noupdate -radix hexadecimal /pipelineadder_tb/sum
add wave -noupdate /pipelineadder_tb/cout
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
WaveRestoreZoom {0 ns} {315 ns}
