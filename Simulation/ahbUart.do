onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ahbuart_tb/I_tester/testInformation
add wave -noupdate /ahbuart_tb/hReset_n
add wave -noupdate /ahbuart_tb/hClk
add wave -noupdate -divider {AMBA bus}
add wave -noupdate -radix hexadecimal /ahbuart_tb/hAddr
add wave -noupdate /ahbuart_tb/hTrans
add wave -noupdate /ahbuart_tb/hSel
add wave -noupdate /ahbuart_tb/hWrite
add wave -noupdate -radix hexadecimal /ahbuart_tb/hWData
add wave -noupdate -radix hexadecimal -childformat {{/ahbuart_tb/hRData(15) -radix hexadecimal} {/ahbuart_tb/hRData(14) -radix hexadecimal} {/ahbuart_tb/hRData(13) -radix hexadecimal} {/ahbuart_tb/hRData(12) -radix hexadecimal} {/ahbuart_tb/hRData(11) -radix hexadecimal} {/ahbuart_tb/hRData(10) -radix hexadecimal} {/ahbuart_tb/hRData(9) -radix hexadecimal} {/ahbuart_tb/hRData(8) -radix hexadecimal} {/ahbuart_tb/hRData(7) -radix hexadecimal} {/ahbuart_tb/hRData(6) -radix hexadecimal} {/ahbuart_tb/hRData(5) -radix hexadecimal} {/ahbuart_tb/hRData(4) -radix hexadecimal} {/ahbuart_tb/hRData(3) -radix hexadecimal} {/ahbuart_tb/hRData(2) -radix hexadecimal} {/ahbuart_tb/hRData(1) -radix hexadecimal} {/ahbuart_tb/hRData(0) -radix hexadecimal}} -subitemconfig {/ahbuart_tb/hRData(15) {-height 15 -radix hexadecimal} /ahbuart_tb/hRData(14) {-height 15 -radix hexadecimal} /ahbuart_tb/hRData(13) {-height 15 -radix hexadecimal} /ahbuart_tb/hRData(12) {-height 15 -radix hexadecimal} /ahbuart_tb/hRData(11) {-height 15 -radix hexadecimal} /ahbuart_tb/hRData(10) {-height 15 -radix hexadecimal} /ahbuart_tb/hRData(9) {-height 15 -radix hexadecimal} /ahbuart_tb/hRData(8) {-height 15 -radix hexadecimal} /ahbuart_tb/hRData(7) {-height 15 -radix hexadecimal} /ahbuart_tb/hRData(6) {-height 15 -radix hexadecimal} /ahbuart_tb/hRData(5) {-height 15 -radix hexadecimal} /ahbuart_tb/hRData(4) {-height 15 -radix hexadecimal} /ahbuart_tb/hRData(3) {-height 15 -radix hexadecimal} /ahbuart_tb/hRData(2) {-height 15 -radix hexadecimal} /ahbuart_tb/hRData(1) {-height 15 -radix hexadecimal} /ahbuart_tb/hRData(0) {-height 15 -radix hexadecimal}} /ahbuart_tb/hRData
add wave -noupdate /ahbuart_tb/hReady
add wave -noupdate /ahbuart_tb/hResp
add wave -noupdate -divider Registers
add wave -noupdate /ahbuart_tb/I_DUT/BaudBuffer
add wave -noupdate /ahbuart_tb/I_DUT/RxBuffer
add wave -noupdate /ahbuart_tb/I_DUT/TxBuffer
add wave -noupdate /ahbuart_tb/I_DUT/CtrlBuffer
add wave -noupdate -divider Internals
add wave -noupdate /ahbuart_tb/I_DUT/addrInt
add wave -noupdate /ahbuart_tb/I_DUT/clearCtrlReadyRead
add wave -noupdate /ahbuart_tb/I_DUT/hSelInt
add wave -noupdate /ahbuart_tb/I_DUT/hTransInt
add wave -noupdate /ahbuart_tb/I_DUT/hWriteInt
add wave -noupdate /ahbuart_tb/I_DUT/current_state_tx
add wave -noupdate /ahbuart_tb/I_DUT/next_state_tx
add wave -noupdate /ahbuart_tb/I_DUT/current_state_rx
add wave -noupdate /ahbuart_tb/I_DUT/next_state_rx
add wave -noupdate -divider Counters
add wave -noupdate -format Analog-Step -height 74 -max 16.0 /ahbuart_tb/I_DUT/counterPosBitRx
add wave -noupdate -format Analog-Step -height 74 -max 16.0 /ahbuart_tb/I_DUT/counterPosBitTx
add wave -noupdate /ahbuart_tb/I_DUT/counterRateRx
add wave -noupdate /ahbuart_tb/I_DUT/counterRateTx
add wave -noupdate -format Analog-Step -height 74 -max 5.0 /ahbuart_tb/I_DUT/countTimeRx
add wave -noupdate -format Analog-Step -height 74 -max 5.0 /ahbuart_tb/I_DUT/countTimeTx
add wave -noupdate -divider UART
add wave -noupdate /ahbuart_tb/TxD
add wave -noupdate /ahbuart_tb/RxD
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1015260 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ps} {4263 ns}
