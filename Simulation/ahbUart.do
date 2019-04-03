onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ahbuart_tb/hreset_n
add wave -noupdate /ahbuart_tb/hclk
add wave -noupdate -divider {AMBA bus}
add wave -noupdate -radix hexadecimal /ahbuart_tb/haddr
add wave -noupdate /ahbuart_tb/htrans
add wave -noupdate /ahbuart_tb/hsel
add wave -noupdate /ahbuart_tb/hwrite
add wave -noupdate -radix hexadecimal /ahbuart_tb/hwdata
add wave -noupdate -radix hexadecimal -subitemconfig {/ahbuart_tb/hrdata(15) {-height 15 -radix hexadecimal} /ahbuart_tb/hrdata(14) {-height 15 -radix hexadecimal} /ahbuart_tb/hrdata(13) {-height 15 -radix hexadecimal} /ahbuart_tb/hrdata(12) {-height 15 -radix hexadecimal} /ahbuart_tb/hrdata(11) {-height 15 -radix hexadecimal} /ahbuart_tb/hrdata(10) {-height 15 -radix hexadecimal} /ahbuart_tb/hrdata(9) {-height 15 -radix hexadecimal} /ahbuart_tb/hrdata(8) {-height 15 -radix hexadecimal} /ahbuart_tb/hrdata(7) {-height 15 -radix hexadecimal} /ahbuart_tb/hrdata(6) {-height 15 -radix hexadecimal} /ahbuart_tb/hrdata(5) {-height 15 -radix hexadecimal} /ahbuart_tb/hrdata(4) {-height 15 -radix hexadecimal} /ahbuart_tb/hrdata(3) {-height 15 -radix hexadecimal} /ahbuart_tb/hrdata(2) {-height 15 -radix hexadecimal} /ahbuart_tb/hrdata(1) {-height 15 -radix hexadecimal} /ahbuart_tb/hrdata(0) {-height 15 -radix hexadecimal}} /ahbuart_tb/hrdata
add wave -noupdate /ahbuart_tb/hready
add wave -noupdate /ahbuart_tb/hresp
add wave -noupdate -divider Registers
add wave -noupdate -radix hexadecimal /ahbuart_tb/i_dut/dataoutregister
add wave -noupdate -radix hexadecimal /ahbuart_tb/i_dut/controlregister
add wave -noupdate -radix hexadecimal /ahbuart_tb/i_dut/scalerregister
add wave -noupdate -radix hexadecimal /ahbuart_tb/i_dut/datainregister
add wave -noupdate -radix hexadecimal -subitemconfig {/ahbuart_tb/i_dut/statusregister(15) {-radix hexadecimal} /ahbuart_tb/i_dut/statusregister(14) {-radix hexadecimal} /ahbuart_tb/i_dut/statusregister(13) {-radix hexadecimal} /ahbuart_tb/i_dut/statusregister(12) {-radix hexadecimal} /ahbuart_tb/i_dut/statusregister(11) {-radix hexadecimal} /ahbuart_tb/i_dut/statusregister(10) {-radix hexadecimal} /ahbuart_tb/i_dut/statusregister(9) {-radix hexadecimal} /ahbuart_tb/i_dut/statusregister(8) {-radix hexadecimal} /ahbuart_tb/i_dut/statusregister(7) {-radix hexadecimal} /ahbuart_tb/i_dut/statusregister(6) {-radix hexadecimal} /ahbuart_tb/i_dut/statusregister(5) {-radix hexadecimal} /ahbuart_tb/i_dut/statusregister(4) {-radix hexadecimal} /ahbuart_tb/i_dut/statusregister(3) {-radix hexadecimal} /ahbuart_tb/i_dut/statusregister(2) {-radix hexadecimal} /ahbuart_tb/i_dut/statusregister(1) {-radix hexadecimal} /ahbuart_tb/i_dut/statusregister(0) {-radix hexadecimal}} /ahbuart_tb/i_dut/statusregister
add wave -noupdate -divider Internals
add wave -noupdate /ahbuart_tb/i_dut/txen
add wave -noupdate -radix unsigned /ahbuart_tb/i_dut/txshiftcounter
add wave -noupdate /ahbuart_tb/i_dut/txsending
add wave -noupdate /ahbuart_tb/i_dut/rxen
add wave -noupdate -radix unsigned /ahbuart_tb/i_dut/rxshiftcounter
add wave -noupdate /ahbuart_tb/i_dut/rxreceiving
add wave -noupdate /ahbuart_tb/i_dut/rxdataready
add wave -noupdate -divider UART
add wave -noupdate /ahbuart_tb/txd
add wave -noupdate /ahbuart_tb/rxd
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
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
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {4200 ns}
