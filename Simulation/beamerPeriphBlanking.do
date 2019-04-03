onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /beamerperiphblanking_tb/reset
add wave -noupdate -format Logic /beamerperiphblanking_tb/clock
add wave -noupdate -format Logic /beamerperiphblanking_tb/selsincos
add wave -noupdate -divider {Bus interface}
add wave -noupdate -format Literal -radix hexadecimal /beamerperiphblanking_tb/addr
add wave -noupdate -format Literal -radix hexadecimal /beamerperiphblanking_tb/datain
add wave -noupdate -format Literal -radix hexadecimal /beamerperiphblanking_tb/dataout
add wave -noupdate -format Literal -radix hexadecimal /beamerperiphblanking_tb/i1/busdatafromperiph
add wave -noupdate -format Logic /beamerperiphblanking_tb/cs
add wave -noupdate -format Logic /beamerperiphblanking_tb/rd
add wave -noupdate -format Logic /beamerperiphblanking_tb/wrh
add wave -noupdate -format Logic /beamerperiphblanking_tb/wrl
add wave -noupdate -divider {bus decoding}
add wave -noupdate -format Logic /beamerperiphblanking_tb/i0/selcontrol
add wave -noupdate -format Logic /beamerperiphblanking_tb/i0/run
add wave -noupdate -format Logic /beamerperiphblanking_tb/i0/updatepattern
add wave -noupdate -format Logic /beamerperiphblanking_tb/i0/selsize
add wave -noupdate -format Literal -radix unsigned /beamerperiphblanking_tb/i0/patternsize
add wave -noupdate -format Logic /beamerperiphblanking_tb/i0/selspeed
add wave -noupdate -format Literal -radix hexadecimal /beamerperiphblanking_tb/i0/updateperiod
add wave -noupdate -format Logic /beamerperiphblanking_tb/i0/interpolationenable
add wave -noupdate -format Logic /beamerperiphblanking_tb/i0/selx
add wave -noupdate -format Logic /beamerperiphblanking_tb/i0/sely
add wave -noupdate -divider {Signal generation}
add wave -noupdate -format Logic /beamerperiphblanking_tb/i0/newpolynom
add wave -noupdate -format Logic /beamerperiphblanking_tb/i0/cntincrx
add wave -noupdate -format Literal -radix unsigned /beamerperiphblanking_tb/i0/addrx
add wave -noupdate -format Logic /beamerperiphblanking_tb/i0/memwrx
add wave -noupdate -format Logic /beamerperiphblanking_tb/i0/memenx
add wave -noupdate -format Literal -radix hexadecimal /beamerperiphblanking_tb/i0/memx
add wave -noupdate -format Analog-Step -height 75 -offset 33000.0 -radix decimal -scale 0.001 /beamerperiphblanking_tb/i0/samplesx
add wave -noupdate -format Analog-Step -height 75 -radix unsigned -scale 0.001 /beamerperiphblanking_tb/i0/unsignedx
add wave -noupdate -format Literal -radix unsigned /beamerperiphblanking_tb/i0/addry
add wave -noupdate -format Analog-Step -height 75 -offset 33000.0 -radix decimal -scale 0.001 /beamerperiphblanking_tb/i0/samplesy
add wave -noupdate -format Analog-Step -height 75 -radix unsigned -scale 0.001 /beamerperiphblanking_tb/i0/unsignedy
add wave -noupdate -format Literal -radix unsigned /beamerperiphblanking_tb/i0/addrz
add wave -noupdate -format Logic /beamerperiphblanking_tb/outz
add wave -noupdate -format Analog-Step -height 70 -radix unsigned -scale 0.001 /beamerperiphblanking_tb/ioutx
add wave -noupdate -format Analog-Step -height 70 -radix unsigned -scale 0.001 /beamerperiphblanking_tb/iouty
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {1319162400 ps}
WaveRestoreZoom {0 ps} {1050 us}
configure wave -namecolwidth 213
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
