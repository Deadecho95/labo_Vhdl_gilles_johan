onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {Reset and clock} /morse_tb/reset
add wave -noupdate -expand -group {Reset and clock} /morse_tb/clock
add wave -noupdate -expand -group UART /morse_tb/rxd
add wave -noupdate -expand -group UART /morse_tb/i_dut/charactervalid
add wave -noupdate -expand -group UART -radix ascii /morse_tb/i_dut/characterreg
add wave -noupdate -expand -group UART -radix hexadecimal /morse_tb/i_dut/characterreg
add wave -noupdate -expand -group Encoder /morse_tb/i_dut/i_enc/i_ctl/current_state
add wave -noupdate -expand -group Encoder /morse_tb/i_dut/i_enc/startcounter
add wave -noupdate -expand -group Encoder -radix unsigned /morse_tb/i_dut/i_enc/unitnb
add wave -noupdate -expand -group Encoder /morse_tb/i_dut/i_enc/done
add wave -noupdate -expand -group Encoder /morse_tb/morsecode
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 290
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
WaveRestoreZoom {0 ps} {1260 us}
