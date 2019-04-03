onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /beamersystem_tb/reset_n
add wave -noupdate /beamersystem_tb/clock
add wave -noupdate -divider {Bus interface}
add wave -noupdate /beamersystem_tb/i1/busaddress
add wave -noupdate -radix hexadecimal /beamersystem_tb/i1/busdatatoperiph
add wave -noupdate /beamersystem_tb/i1/busread
add wave -noupdate /beamersystem_tb/i1/buswrite
add wave -noupdate -radix hexadecimal -subitemconfig {/beamersystem_tb/apbi.psel {-height 15 -radix hexadecimal} /beamersystem_tb/apbi.penable {-height 15 -radix hexadecimal} /beamersystem_tb/apbi.paddr {-height 15 -radix hexadecimal} /beamersystem_tb/apbi.pwrite {-height 15 -radix hexadecimal} /beamersystem_tb/apbi.pwdata {-height 15 -radix hexadecimal} /beamersystem_tb/apbi.pirq {-height 15 -radix hexadecimal} /beamersystem_tb/apbi.testen {-height 15 -radix hexadecimal} /beamersystem_tb/apbi.testrst {-height 15 -radix hexadecimal} /beamersystem_tb/apbi.scanen {-height 15 -radix hexadecimal}} /beamersystem_tb/apbi
add wave -noupdate -radix hexadecimal /beamersystem_tb/apbo
add wave -noupdate -radix hexadecimal -subitemconfig {/beamersystem_tb/i1/busdatafromperiph(31) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(30) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(29) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(28) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(27) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(26) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(25) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(24) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(23) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(22) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(21) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(20) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(19) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(18) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(17) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(16) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(15) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(14) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(13) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(12) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(11) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(10) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(9) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(8) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(7) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(6) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(5) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(4) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(3) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(2) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(1) {-height 15 -radix hexadecimal} /beamersystem_tb/i1/busdatafromperiph(0) {-height 15 -radix hexadecimal}} /beamersystem_tb/i1/busdatafromperiph
add wave -noupdate -divider Registers
add wave -noupdate -radix hexadecimal /beamersystem_tb/i0/i0/addr
add wave -noupdate -radix hexadecimal /beamersystem_tb/i0/i0/datain
add wave -noupdate /beamersystem_tb/i0/i0/write
add wave -noupdate -radix hexadecimal -subitemconfig {/beamersystem_tb/i0/i0/dataout(31) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(30) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(29) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(28) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(27) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(26) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(25) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(24) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(23) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(22) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(21) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(20) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(19) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(18) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(17) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(16) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(15) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(14) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(13) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(12) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(11) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(10) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(9) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(8) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(7) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(6) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(5) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(4) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(3) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(2) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(1) {-radix hexadecimal} /beamersystem_tb/i0/i0/dataout(0) {-radix hexadecimal}} /beamersystem_tb/i0/i0/dataout
add wave -noupdate /beamersystem_tb/i0/i0/selcontrol
add wave -noupdate /beamersystem_tb/i0/i0/selspeed
add wave -noupdate /beamersystem_tb/i0/i0/selx
add wave -noupdate /beamersystem_tb/i0/i0/sely
add wave -noupdate -divider Controls
add wave -noupdate /beamersystem_tb/i0/run
add wave -noupdate /beamersystem_tb/i0/interpolatelin
add wave -noupdate -radix hexadecimal /beamersystem_tb/i0/updateperiod
add wave -noupdate -divider Memory
add wave -noupdate /beamersystem_tb/i0/i0/updatepattern
add wave -noupdate -radix decimal /beamersystem_tb/i0/i0/patternsize
add wave -noupdate -radix hexadecimal /beamersystem_tb/i0/i0/addrx
add wave -noupdate -radix hexadecimal /beamersystem_tb/i0/i0/memdatain
add wave -noupdate /beamersystem_tb/i0/i0/memenx
add wave -noupdate /beamersystem_tb/i0/i0/memwrx
add wave -noupdate -divider {X-Y waves}
add wave -noupdate /beamersystem_tb/i0/newpolynom
add wave -noupdate -format Analog-Step -height 50 -max 32500.0 -min -32500.0 -radix decimal /beamersystem_tb/i0/memx
add wave -noupdate -format Analog-Step -height 50 -max 32500.0 -min -32500.0 -radix decimal /beamersystem_tb/i0/memy
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {94448 ns} 0}
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
WaveRestoreZoom {0 ns} {42 us}
