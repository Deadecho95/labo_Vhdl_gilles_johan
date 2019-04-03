onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ahbgpio_tb/hreset_n
add wave -noupdate /ahbgpio_tb/hclk
add wave -noupdate -divider {AMBA bus}
add wave -noupdate -radix hexadecimal /ahbgpio_tb/haddr
add wave -noupdate /ahbgpio_tb/htrans
add wave -noupdate /ahbgpio_tb/hsel
add wave -noupdate /ahbgpio_tb/hwrite
add wave -noupdate -radix hexadecimal /ahbgpio_tb/hwdata
add wave -noupdate -radix hexadecimal /ahbgpio_tb/hrdata
add wave -noupdate /ahbgpio_tb/hready
add wave -noupdate /ahbgpio_tb/hresp
add wave -noupdate -divider Registers
add wave -noupdate -radix hexadecimal /ahbgpio_tb/i_dut/outputenableregister
add wave -noupdate -radix hexadecimal /ahbgpio_tb/i_dut/dataoutregister
add wave -noupdate -radix hexadecimal /ahbgpio_tb/i_dut/datainregister
add wave -noupdate -divider UART
add wave -noupdate -radix hexadecimal /ahbgpio_tb/ioen
add wave -noupdate -radix hexadecimal /ahbgpio_tb/ioout
add wave -noupdate -radix hexadecimal /ahbgpio_tb/ioin
add wave -noupdate -radix hexadecimal -subitemconfig {/ahbgpio_tb/io(7) {-radix hexadecimal} /ahbgpio_tb/io(6) {-radix hexadecimal} /ahbgpio_tb/io(5) {-radix hexadecimal} /ahbgpio_tb/io(4) {-radix hexadecimal} /ahbgpio_tb/io(3) {-radix hexadecimal} /ahbgpio_tb/io(2) {-radix hexadecimal} /ahbgpio_tb/io(1) {-radix hexadecimal} /ahbgpio_tb/io(0) {-radix hexadecimal}} /ahbgpio_tb/io
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {735 ns}
