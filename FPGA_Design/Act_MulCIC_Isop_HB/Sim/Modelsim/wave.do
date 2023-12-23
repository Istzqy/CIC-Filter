onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_Mul_CIC/clk
add wave -noupdate /tb_Mul_CIC/rst
add wave -noupdate -radix decimal /tb_Mul_CIC/filter_in
add wave -noupdate -format Analog-Step -height 74 -max 3.8314084374341485e+17 -min -3.8324706415992211e+17 -radix decimal /tb_Mul_CIC/filter_out
add wave -noupdate /tb_Mul_CIC/rdy
add wave -noupdate /tb_Mul_CIC/i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {275030833333 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1062017615176 ps}
