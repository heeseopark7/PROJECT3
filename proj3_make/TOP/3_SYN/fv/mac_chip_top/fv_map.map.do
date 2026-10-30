
//input ports
add mapped point i_clk i_clk -type PI PI
add mapped point i_rst_n i_rst_n -type PI PI
add mapped point i_a[15] i_a[15] -type PI PI
add mapped point i_a[14] i_a[14] -type PI PI
add mapped point i_a[13] i_a[13] -type PI PI
add mapped point i_a[12] i_a[12] -type PI PI
add mapped point i_a[11] i_a[11] -type PI PI
add mapped point i_a[10] i_a[10] -type PI PI
add mapped point i_a[9] i_a[9] -type PI PI
add mapped point i_a[8] i_a[8] -type PI PI
add mapped point i_a[7] i_a[7] -type PI PI
add mapped point i_a[6] i_a[6] -type PI PI
add mapped point i_a[5] i_a[5] -type PI PI
add mapped point i_a[4] i_a[4] -type PI PI
add mapped point i_a[3] i_a[3] -type PI PI
add mapped point i_a[2] i_a[2] -type PI PI
add mapped point i_a[1] i_a[1] -type PI PI
add mapped point i_a[0] i_a[0] -type PI PI
add mapped point i_b[15] i_b[15] -type PI PI
add mapped point i_b[14] i_b[14] -type PI PI
add mapped point i_b[13] i_b[13] -type PI PI
add mapped point i_b[12] i_b[12] -type PI PI
add mapped point i_b[11] i_b[11] -type PI PI
add mapped point i_b[10] i_b[10] -type PI PI
add mapped point i_b[9] i_b[9] -type PI PI
add mapped point i_b[8] i_b[8] -type PI PI
add mapped point i_b[7] i_b[7] -type PI PI
add mapped point i_b[6] i_b[6] -type PI PI
add mapped point i_b[5] i_b[5] -type PI PI
add mapped point i_b[4] i_b[4] -type PI PI
add mapped point i_b[3] i_b[3] -type PI PI
add mapped point i_b[2] i_b[2] -type PI PI
add mapped point i_b[1] i_b[1] -type PI PI
add mapped point i_b[0] i_b[0] -type PI PI
add mapped point i_en i_en -type PI PI
add mapped point i_clr i_clr -type PI PI

//output ports
add mapped point o_acc[39] o_acc[39] -type PO PO
add mapped point o_acc[38] o_acc[38] -type PO PO
add mapped point o_acc[37] o_acc[37] -type PO PO
add mapped point o_acc[36] o_acc[36] -type PO PO
add mapped point o_acc[35] o_acc[35] -type PO PO
add mapped point o_acc[34] o_acc[34] -type PO PO
add mapped point o_acc[33] o_acc[33] -type PO PO
add mapped point o_acc[32] o_acc[32] -type PO PO
add mapped point o_acc[31] o_acc[31] -type PO PO
add mapped point o_acc[30] o_acc[30] -type PO PO
add mapped point o_acc[29] o_acc[29] -type PO PO
add mapped point o_acc[28] o_acc[28] -type PO PO
add mapped point o_acc[27] o_acc[27] -type PO PO
add mapped point o_acc[26] o_acc[26] -type PO PO
add mapped point o_acc[25] o_acc[25] -type PO PO
add mapped point o_acc[24] o_acc[24] -type PO PO
add mapped point o_acc[23] o_acc[23] -type PO PO
add mapped point o_acc[22] o_acc[22] -type PO PO
add mapped point o_acc[21] o_acc[21] -type PO PO
add mapped point o_acc[20] o_acc[20] -type PO PO
add mapped point o_acc[19] o_acc[19] -type PO PO
add mapped point o_acc[18] o_acc[18] -type PO PO
add mapped point o_acc[17] o_acc[17] -type PO PO
add mapped point o_acc[16] o_acc[16] -type PO PO
add mapped point o_acc[15] o_acc[15] -type PO PO
add mapped point o_acc[14] o_acc[14] -type PO PO
add mapped point o_acc[13] o_acc[13] -type PO PO
add mapped point o_acc[12] o_acc[12] -type PO PO
add mapped point o_acc[11] o_acc[11] -type PO PO
add mapped point o_acc[10] o_acc[10] -type PO PO
add mapped point o_acc[9] o_acc[9] -type PO PO
add mapped point o_acc[8] o_acc[8] -type PO PO
add mapped point o_acc[7] o_acc[7] -type PO PO
add mapped point o_acc[6] o_acc[6] -type PO PO
add mapped point o_acc[5] o_acc[5] -type PO PO
add mapped point o_acc[4] o_acc[4] -type PO PO
add mapped point o_acc[3] o_acc[3] -type PO PO
add mapped point o_acc[2] o_acc[2] -type PO PO
add mapped point o_acc[1] o_acc[1] -type PO PO
add mapped point o_acc[0] o_acc[0] -type PO PO

//inout ports




//Sequential Pins
add mapped point u_mac/g_stage1.en_q/q u_mac/g_stage1.en_q_reg/Q -type DFF DFF
add mapped point u_mac/g_stage1.clr_q/q u_mac/g_stage1.clr_q_reg/Q -type DFF DFF
add mapped point u_mac/g_stage1.a_q[15]/q u_mac/g_stage1.a_q_reg_15/Q -type DFF DFF
add mapped point u_mac/g_stage1.a_q[14]/q u_mac/g_stage1.a_q_reg_14/Q -type DFF DFF
add mapped point u_mac/g_stage1.a_q[8]/q u_mac/g_stage1.a_q_reg_8/Q -type DFF DFF
add mapped point u_mac/g_stage1.b_q[0]/q u_mac/g_stage1.b_q_reg_0/Q -type DFF DFF
add mapped point u_mac/g_stage1.a_q[0]/q u_mac/g_stage1.a_q_reg_0/Q -type DFF DFF
add mapped point u_mac/g_stage1.a_q[12]/q u_mac/g_stage1.a_q_reg_12/Q -type DFF DFF
add mapped point u_mac/g_stage1.b_q[15]/q u_mac/g_stage1.b_q_reg_15/Q -type DFF DFF
add mapped point u_mac/g_stage1.a_q[7]/q u_mac/g_stage1.a_q_reg_7/Q -type DFF DFF
add mapped point u_mac/g_stage1.b_q[14]/q u_mac/g_stage1.b_q_reg_14/Q -type DFF DFF
add mapped point u_mac/g_stage1.b_q[13]/q u_mac/g_stage1.b_q_reg_13/Q -type DFF DFF
add mapped point u_mac/g_stage1.a_q[11]/q u_mac/g_stage1.a_q_reg_11/Q -type DFF DFF
add mapped point u_mac/g_stage1.a_q[6]/q u_mac/g_stage1.a_q_reg_6/Q -type DFF DFF
add mapped point u_mac/g_stage1.b_q[12]/q u_mac/g_stage1.b_q_reg_12/Q -type DFF DFF
add mapped point u_mac/g_stage1.b_q[11]/q u_mac/g_stage1.b_q_reg_11/Q -type DFF DFF
add mapped point u_mac/g_stage1.a_q[5]/q u_mac/g_stage1.a_q_reg_5/Q -type DFF DFF
add mapped point u_mac/g_stage1.b_q[10]/q u_mac/g_stage1.b_q_reg_10/Q -type DFF DFF
add mapped point u_mac/g_stage1.b_q[9]/q u_mac/g_stage1.b_q_reg_9/Q -type DFF DFF
add mapped point u_mac/g_stage1.a_q[13]/q u_mac/g_stage1.a_q_reg_13/Q -type DFF DFF
add mapped point u_mac/g_stage1.a_q[10]/q u_mac/g_stage1.a_q_reg_10/Q -type DFF DFF
add mapped point u_mac/g_stage1.a_q[4]/q u_mac/g_stage1.a_q_reg_4/Q -type DFF DFF
add mapped point u_mac/g_stage1.b_q[8]/q u_mac/g_stage1.b_q_reg_8/Q -type DFF DFF
add mapped point u_mac/g_stage1.b_q[7]/q u_mac/g_stage1.b_q_reg_7/Q -type DFF DFF
add mapped point u_mac/g_stage1.a_q[3]/q u_mac/g_stage1.a_q_reg_3/Q -type DFF DFF
add mapped point u_mac/g_stage1.b_q[6]/q u_mac/g_stage1.b_q_reg_6/Q -type DFF DFF
add mapped point u_mac/g_stage1.b_q[5]/q u_mac/g_stage1.b_q_reg_5/Q -type DFF DFF
add mapped point u_mac/g_stage1.a_q[9]/q u_mac/g_stage1.a_q_reg_9/Q -type DFF DFF
add mapped point u_mac/g_stage1.a_q[2]/q u_mac/g_stage1.a_q_reg_2/Q -type DFF DFF
add mapped point u_mac/g_stage1.b_q[4]/q u_mac/g_stage1.b_q_reg_4/Q -type DFF DFF
add mapped point u_mac/g_stage1.b_q[3]/q u_mac/g_stage1.b_q_reg_3/Q -type DFF DFF
add mapped point u_mac/g_stage1.a_q[1]/q u_mac/g_stage1.a_q_reg_1/Q -type DFF DFF
add mapped point u_mac/g_stage1.b_q[2]/q u_mac/g_stage1.b_q_reg_2/Q -type DFF DFF
add mapped point u_mac/g_stage1.b_q[1]/q u_mac/g_stage1.b_q_reg_1/Q -type DFF DFF
add mapped point u_mac/acc_q[0]/q u_mac/acc_q_reg_0/Q -type DFF DFF
add mapped point u_mac/acc_q[1]/q u_mac/acc_q_reg_1/Q -type DFF DFF
add mapped point u_mac/acc_q[2]/q u_mac/acc_q_reg_2/Q -type DFF DFF
add mapped point u_mac/acc_q[3]/q u_mac/acc_q_reg_3/Q -type DFF DFF
add mapped point u_mac/acc_q[4]/q u_mac/acc_q_reg_4/Q -type DFF DFF
add mapped point u_mac/acc_q[5]/q u_mac/acc_q_reg_5/Q -type DFF DFF
add mapped point u_mac/acc_q[6]/q u_mac/acc_q_reg_6/Q -type DFF DFF
add mapped point u_mac/acc_q[7]/q u_mac/acc_q_reg_7/Q -type DFF DFF
add mapped point u_mac/acc_q[8]/q u_mac/acc_q_reg_8/Q -type DFF DFF
add mapped point u_mac/acc_q[9]/q u_mac/acc_q_reg_9/Q -type DFF DFF
add mapped point u_mac/acc_q[10]/q u_mac/acc_q_reg_10/Q -type DFF DFF
add mapped point u_mac/acc_q[11]/q u_mac/acc_q_reg_11/Q -type DFF DFF
add mapped point u_mac/acc_q[12]/q u_mac/acc_q_reg_12/Q -type DFF DFF
add mapped point u_mac/acc_q[13]/q u_mac/acc_q_reg_13/Q -type DFF DFF
add mapped point u_mac/acc_q[14]/q u_mac/acc_q_reg_14/Q -type DFF DFF
add mapped point u_mac/acc_q[15]/q u_mac/acc_q_reg_15/Q -type DFF DFF
add mapped point u_mac/acc_q[16]/q u_mac/acc_q_reg_16/Q -type DFF DFF
add mapped point u_mac/acc_q[17]/q u_mac/acc_q_reg_17/Q -type DFF DFF
add mapped point u_mac/acc_q[18]/q u_mac/acc_q_reg_18/Q -type DFF DFF
add mapped point u_mac/acc_q[19]/q u_mac/acc_q_reg_19/Q -type DFF DFF
add mapped point u_mac/acc_q[20]/q u_mac/acc_q_reg_20/Q -type DFF DFF
add mapped point u_mac/acc_q[21]/q u_mac/acc_q_reg_21/Q -type DFF DFF
add mapped point u_mac/acc_q[22]/q u_mac/acc_q_reg_22/Q -type DFF DFF
add mapped point u_mac/acc_q[23]/q u_mac/acc_q_reg_23/Q -type DFF DFF
add mapped point u_mac/acc_q[24]/q u_mac/acc_q_reg_24/Q -type DFF DFF
add mapped point u_mac/acc_q[25]/q u_mac/acc_q_reg_25/Q -type DFF DFF
add mapped point u_mac/acc_q[26]/q u_mac/acc_q_reg_26/Q -type DFF DFF
add mapped point u_mac/acc_q[27]/q u_mac/acc_q_reg_27/Q -type DFF DFF
add mapped point u_mac/acc_q[28]/q u_mac/acc_q_reg_28/Q -type DFF DFF
add mapped point u_mac/acc_q[29]/q u_mac/acc_q_reg_29/Q -type DFF DFF
add mapped point u_mac/acc_q[30]/q u_mac/acc_q_reg_30/Q -type DFF DFF
add mapped point u_mac/acc_q[31]/q u_mac/acc_q_reg_31/Q -type DFF DFF
add mapped point u_mac/acc_q[32]/q u_mac/acc_q_reg_32/Q -type DFF DFF
add mapped point u_mac/acc_q[33]/q u_mac/acc_q_reg_33/Q -type DFF DFF
add mapped point u_mac/acc_q[34]/q u_mac/acc_q_reg_34/Q -type DFF DFF
add mapped point u_mac/acc_q[35]/q u_mac/acc_q_reg_35/Q -type DFF DFF
add mapped point u_mac/acc_q[36]/q u_mac/acc_q_reg_36/Q -type DFF DFF
add mapped point u_mac/acc_q[37]/q u_mac/acc_q_reg_37/Q -type DFF DFF
add mapped point u_mac/acc_q[38]/q u_mac/acc_q_reg_38/Q -type DFF DFF
add mapped point u_mac/acc_q[39]/q u_mac/acc_q_reg_39/Q -type DFF DFF



//Black Boxes



//Empty Modules as Blackboxes
