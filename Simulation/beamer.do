onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /beamer_tb/rstn
add wave -noupdate /beamer_tb/clk
add wave -noupdate -divider {AHB UART}
add wave -noupdate /beamer_tb/rxd0
add wave -noupdate /beamer_tb/txd0
add wave -noupdate -radix hexadecimal /beamer_tb/u_0/i0/i6/dcom_uart0/r.brate
add wave -noupdate -radix hexadecimal /beamer_tb/u_0/i0/i6/dcom_uart0/r.rhold
add wave -noupdate -radix hexadecimal /beamer_tb/u_0/i0/i6/dcom_uart0/r.thold
add wave -noupdate -divider {AMBA bus}
add wave -noupdate -radix hexadecimal -subitemconfig {/beamer_tb/u_0/i0/ahbmi.hgrant {-radix hexadecimal} /beamer_tb/u_0/i0/ahbmi.hready {-radix hexadecimal} /beamer_tb/u_0/i0/ahbmi.hresp {-radix hexadecimal} /beamer_tb/u_0/i0/ahbmi.hrdata {-radix hexadecimal} /beamer_tb/u_0/i0/ahbmi.hcache {-radix hexadecimal} /beamer_tb/u_0/i0/ahbmi.hirq {-radix hexadecimal} /beamer_tb/u_0/i0/ahbmi.testen {-radix hexadecimal} /beamer_tb/u_0/i0/ahbmi.testrst {-radix hexadecimal} /beamer_tb/u_0/i0/ahbmi.scanen {-radix hexadecimal}} /beamer_tb/u_0/i0/ahbmi
add wave -noupdate -radix hexadecimal -subitemconfig {/beamer_tb/u_0/i0/ahbmo(15) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/ahbmo(14) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/ahbmo(13) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/ahbmo(12) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/ahbmo(11) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/ahbmo(10) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/ahbmo(9) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/ahbmo(8) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/ahbmo(7) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/ahbmo(6) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/ahbmo(5) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/ahbmo(4) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/ahbmo(3) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/ahbmo(2) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/ahbmo(1) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/ahbmo(0) {-height 15 -radix hexadecimal}} /beamer_tb/u_0/i0/ahbmo
add wave -noupdate -radix hexadecimal -subitemconfig {/beamer_tb/u_0/i0/ahbsi.hsel {-radix hexadecimal} /beamer_tb/u_0/i0/ahbsi.haddr {-radix hexadecimal} /beamer_tb/u_0/i0/ahbsi.hwrite {-radix hexadecimal} /beamer_tb/u_0/i0/ahbsi.htrans {-radix hexadecimal} /beamer_tb/u_0/i0/ahbsi.hsize {-radix hexadecimal} /beamer_tb/u_0/i0/ahbsi.hburst {-radix hexadecimal} /beamer_tb/u_0/i0/ahbsi.hwdata {-radix hexadecimal} /beamer_tb/u_0/i0/ahbsi.hprot {-radix hexadecimal} /beamer_tb/u_0/i0/ahbsi.hready {-radix hexadecimal} /beamer_tb/u_0/i0/ahbsi.hmaster {-radix hexadecimal} /beamer_tb/u_0/i0/ahbsi.hmastlock {-radix hexadecimal} /beamer_tb/u_0/i0/ahbsi.hmbsel {-radix hexadecimal} /beamer_tb/u_0/i0/ahbsi.hcache {-radix hexadecimal} /beamer_tb/u_0/i0/ahbsi.hirq {-radix hexadecimal} /beamer_tb/u_0/i0/ahbsi.testen {-radix hexadecimal} /beamer_tb/u_0/i0/ahbsi.testrst {-radix hexadecimal} /beamer_tb/u_0/i0/ahbsi.scanen {-radix hexadecimal}} /beamer_tb/u_0/i0/ahbsi
add wave -noupdate -radix hexadecimal -subitemconfig {/beamer_tb/u_0/i0/ahbso(15) {-radix hexadecimal} /beamer_tb/u_0/i0/ahbso(14) {-radix hexadecimal} /beamer_tb/u_0/i0/ahbso(13) {-radix hexadecimal} /beamer_tb/u_0/i0/ahbso(12) {-radix hexadecimal} /beamer_tb/u_0/i0/ahbso(11) {-radix hexadecimal} /beamer_tb/u_0/i0/ahbso(10) {-radix hexadecimal} /beamer_tb/u_0/i0/ahbso(9) {-radix hexadecimal} /beamer_tb/u_0/i0/ahbso(8) {-radix hexadecimal} /beamer_tb/u_0/i0/ahbso(7) {-radix hexadecimal} /beamer_tb/u_0/i0/ahbso(6) {-radix hexadecimal} /beamer_tb/u_0/i0/ahbso(5) {-radix hexadecimal} /beamer_tb/u_0/i0/ahbso(4) {-radix hexadecimal} /beamer_tb/u_0/i0/ahbso(3) {-radix hexadecimal} /beamer_tb/u_0/i0/ahbso(2) {-radix hexadecimal} /beamer_tb/u_0/i0/ahbso(1) {-radix hexadecimal} /beamer_tb/u_0/i0/ahbso(0) {-radix hexadecimal}} /beamer_tb/u_0/i0/ahbso
add wave -noupdate -radix hexadecimal -subitemconfig {/beamer_tb/u_0/i0/apbi.psel {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/apbi.penable {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/apbi.paddr {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/apbi.pwrite {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/apbi.pwdata {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/apbi.pirq {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/apbi.testen {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/apbi.testrst {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/apbi.scanen {-height 15 -radix hexadecimal}} /beamer_tb/u_0/i0/apbi
add wave -noupdate -radix hexadecimal -subitemconfig {/beamer_tb/u_0/i0/apbo(0) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/apbo(1) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/apbo(2) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/apbo(3) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/apbo(4) {-radix hexadecimal} /beamer_tb/u_0/i0/apbo(5) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/apbo(6) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/apbo(7) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/apbo(8) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/apbo(9) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/apbo(10) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/apbo(11) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/apbo(12) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/apbo(13) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/apbo(14) {-height 15 -radix hexadecimal} /beamer_tb/u_0/i0/apbo(15) {-height 15 -radix hexadecimal}} /beamer_tb/u_0/i0/apbo
add wave -noupdate -divider Registers
add wave -noupdate /beamer_tb/u_0/i0/i2/run
add wave -noupdate /beamer_tb/u_0/i0/i2/i0/updatepattern
add wave -noupdate /beamer_tb/u_0/i0/i2/interpolatelin
add wave -noupdate -radix unsigned /beamer_tb/u_0/i0/i2/i0/patternsize
add wave -noupdate -radix unsigned /beamer_tb/u_0/i0/i2/updateperiod
add wave -noupdate /beamer_tb/u_0/i0/i2/newpolynom
add wave -noupdate -format Analog-Step -height 30 -max 32000.0 -min -32000.0 -radix decimal /beamer_tb/u_0/i0/i2/memx
add wave -noupdate -format Analog-Step -height 30 -max 32000.0 -min -32000.0 -radix decimal /beamer_tb/u_0/i0/i2/memy
add wave -noupdate -divider Outputs
add wave -noupdate -format Analog-Step -height 30 -max 32000.0 -min -32000.0 -radix decimal /beamer_tb/u_0/i0/i2/i1/samplex
add wave -noupdate -format Analog-Step -height 30 -max 32000.0 -min -32000.0 -radix decimal /beamer_tb/u_0/i0/i2/i1/sampley
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
configure wave -namecolwidth 255
configure wave -valuecolwidth 55
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
WaveRestoreZoom {0 ns} {3150 us}
