//=========================================================================================================
//
// semia_ui.h
//  
#ifndef	sem_0_HEADER
#define	sem_0_HEADER

extern Attr_attribute	INSTANCE;

Xv_opaque	sem_0_l_menu_Ov_create(caddr_t, Xv_opaque);
Xv_opaque	sem_0_d_menu_OvrLds_create(caddr_t, Xv_opaque);
Xv_opaque	sem_0_l_menu_OvrLds1_create(caddr_t, Xv_opaque);
Xv_opaque	sem_0_l_menu_OvrLds2_create(caddr_t, Xv_opaque);
Xv_opaque	sem_0_d_menu_lead_create(caddr_t, Xv_opaque);
Xv_opaque	sem_0_l_menu_OvrLds_create(caddr_t, Xv_opaque);

class sem_0_m_bw_objects {

public:
	Xv_opaque	m_bw;
	Xv_opaque	m_c;
	Xv_opaque	m_b_Open;
	Xv_opaque	m_b_Lead0;
	Xv_opaque	m_b_Data;
	Xv_opaque	m_b_NumEpis;
	Xv_opaque	m_b_Lead1;
	Xv_opaque	m_b_KLCoeff;
	Xv_opaque	m_b_AplOp;
	Xv_opaque	m_b_Quit;
	Xv_opaque	m_b_Lead2;
	Xv_opaque	m_b_DiagData;
	Xv_opaque	m_b_help;
	Xv_opaque	m_m_Record;

	virtual void	objects_initialize(Xv_opaque);

	virtual Xv_opaque	m_bw_create(Xv_opaque);
	virtual Xv_opaque	m_c_create(Xv_opaque);
	virtual Xv_opaque	m_b_Open_create(Xv_opaque);
	virtual Xv_opaque	m_b_Lead0_create(Xv_opaque);
	virtual Xv_opaque	m_b_Data_create(Xv_opaque);
	virtual Xv_opaque	m_b_NumEpis_create(Xv_opaque);
	virtual Xv_opaque	m_b_Lead1_create(Xv_opaque);
	virtual Xv_opaque	m_b_KLCoeff_create(Xv_opaque);
	virtual Xv_opaque	m_b_AplOp_create(Xv_opaque);
	virtual Xv_opaque	m_b_Quit_create(Xv_opaque);
	virtual Xv_opaque	m_b_Lead2_create(Xv_opaque);
	virtual Xv_opaque	m_b_DiagData_create(Xv_opaque);
	virtual Xv_opaque	m_b_help_create(Xv_opaque);
	virtual Xv_opaque	m_m_Record_create(Xv_opaque);
};

class sem_0_k_bw_objects {

public:
	Xv_opaque	k_bw;
	Xv_opaque	k_c;
	Xv_opaque	k_ss_ST;
	Xv_opaque	k_ss_1std;
	Xv_opaque	k_b_Overlay;
	Xv_opaque	k_m_dummy1;
	Xv_opaque	k_m_dummy2;
	Xv_opaque	k_m_dummy3;
	Xv_opaque	k_cp;

	virtual void	objects_initialize(Xv_opaque);

	virtual Xv_opaque	k_bw_create(Xv_opaque);
	virtual Xv_opaque	k_c_create(Xv_opaque);
	virtual Xv_opaque	k_ss_ST_create(Xv_opaque);
	virtual Xv_opaque	k_ss_1std_create(Xv_opaque);
	virtual Xv_opaque	k_b_Overlay_create(Xv_opaque);
	virtual Xv_opaque	k_m_dummy1_create(Xv_opaque);
	virtual Xv_opaque	k_m_dummy2_create(Xv_opaque);
	virtual Xv_opaque	k_m_dummy3_create(Xv_opaque);
	virtual Xv_opaque	k_cp_create(Xv_opaque);
};

class sem_0_o_pw_objects {

public:
	Xv_opaque	o_pw;
	Xv_opaque	o_c;
	Xv_opaque	o_file_name;
	Xv_opaque	o_m_message1;
	Xv_opaque	o_b_Cancel;
	Xv_opaque	o_b_OK;

	virtual void	objects_initialize(Xv_opaque);

	virtual Xv_opaque	o_pw_create(Xv_opaque);
	virtual Xv_opaque	o_c_create(Xv_opaque);
	virtual Xv_opaque	o_file_name_create(Xv_opaque);
	virtual Xv_opaque	o_m_message1_create(Xv_opaque);
	virtual Xv_opaque	o_b_Cancel_create(Xv_opaque);
	virtual Xv_opaque	o_b_OK_create(Xv_opaque);
};

class sem_0_q_pw_objects {

public:
	Xv_opaque	q_pw;
	Xv_opaque	q_c;
	Xv_opaque	q_m_Save;
	Xv_opaque	q_b_Cancel;
	Xv_opaque	q_b_Quit;

	virtual void	objects_initialize(Xv_opaque);

	virtual Xv_opaque	q_pw_create(Xv_opaque);
	virtual Xv_opaque	q_c_create(Xv_opaque);
	virtual Xv_opaque	q_m_Save_create(Xv_opaque);
	virtual Xv_opaque	q_b_Cancel_create(Xv_opaque);
	virtual Xv_opaque	q_b_Quit_create(Xv_opaque);
};

class sem_0_w_pw_objects {

public:
	Xv_opaque	w_pw;
	Xv_opaque	w_c;
	Xv_opaque	w_m_message1;
	Xv_opaque	w_m_message2;
	Xv_opaque	w_m_message3;
	Xv_opaque	w_b_OK;

	virtual void	objects_initialize(Xv_opaque);

	virtual Xv_opaque	w_pw_create(Xv_opaque);
	virtual Xv_opaque	w_c_create(Xv_opaque);
	virtual Xv_opaque	w_m_message1_create(Xv_opaque);
	virtual Xv_opaque	w_m_message2_create(Xv_opaque);
	virtual Xv_opaque	w_m_message3_create(Xv_opaque);
	virtual Xv_opaque	w_b_OK_create(Xv_opaque);
};

class sem_0_d_bw_objects {

public:
	Xv_opaque	d_bw;
	Xv_opaque	d_c_line0;
	Xv_opaque	d_ss_16s;
	Xv_opaque	d_ss_520ms;
	Xv_opaque	d_ss_Ovrly;
	Xv_opaque	d_ss_6s;
	Xv_opaque	d_ss_1mV;
	Xv_opaque	d_b_lead;
	Xv_opaque	d_b_OvrLds_menu;
	Xv_opaque	d_m_Average;
	Xv_opaque	d_m_Display;
	Xv_opaque	d_m_Opts;
	Xv_opaque	d_c_line1;
	Xv_opaque	d_b_OvrRef;
	Xv_opaque	d_m_dummy;
	Xv_opaque	d_cp;

	virtual void	objects_initialize(Xv_opaque);

	virtual Xv_opaque	d_bw_create(Xv_opaque);
	virtual Xv_opaque	d_c_line0_create(Xv_opaque);
	virtual Xv_opaque	d_ss_16s_create(Xv_opaque);
	virtual Xv_opaque	d_ss_520ms_create(Xv_opaque);
	virtual Xv_opaque	d_ss_Ovrly_create(Xv_opaque);
	virtual Xv_opaque	d_ss_6s_create(Xv_opaque);
	virtual Xv_opaque	d_ss_1mV_create(Xv_opaque);
	virtual Xv_opaque	d_b_lead_create(Xv_opaque);
	virtual Xv_opaque	d_b_OvrLds_menu_create(Xv_opaque);
	virtual Xv_opaque	d_m_Average_create(Xv_opaque);
	virtual Xv_opaque	d_m_Display_create(Xv_opaque);
	virtual Xv_opaque	d_m_Opts_create(Xv_opaque);
	virtual Xv_opaque	d_c_line1_create(Xv_opaque);
	virtual Xv_opaque	d_b_OvrRef_create(Xv_opaque);
	virtual Xv_opaque	d_m_dummy_create(Xv_opaque);
	virtual Xv_opaque	d_cp_create(Xv_opaque);
};

class sem_0_l_bw_objects {

public:
	Xv_opaque	l_bw;
	Xv_opaque	l_c_line00;
	Xv_opaque	l_b_shift_ll;
	Xv_opaque	l_b_shift_l;
	Xv_opaque	l_b_shift_r;
	Xv_opaque	l_b_shift_rr;
	Xv_opaque	l_c_line01;
	Xv_opaque	l_ss_HRate;
	Xv_opaque	l_ss_12min;
	Xv_opaque	l_ss_100mV;
	Xv_opaque	l_b_Mark;
	Xv_opaque	l_b_Subtr;
	Xv_opaque	l_b_OvrApp;
	Xv_opaque	l_b_OvrLds_menu;
	Xv_opaque	l_c_line1;
	Xv_opaque	l_b_Exm;
	Xv_opaque	l_b_ConsLR;
	Xv_opaque	l_cp;

	virtual void	objects_initialize(Xv_opaque);

	virtual Xv_opaque	l_bw_create(Xv_opaque);
	virtual Xv_opaque	l_c_line00_create(Xv_opaque);
	virtual Xv_opaque	l_b_shift_ll_create(Xv_opaque);
	virtual Xv_opaque	l_b_shift_l_create(Xv_opaque);
	virtual Xv_opaque	l_b_shift_r_create(Xv_opaque);
	virtual Xv_opaque	l_b_shift_rr_create(Xv_opaque);
	virtual Xv_opaque	l_c_line01_create(Xv_opaque);
	virtual Xv_opaque	l_ss_HRate_create(Xv_opaque);
	virtual Xv_opaque	l_ss_12min_create(Xv_opaque);
	virtual Xv_opaque	l_ss_100mV_create(Xv_opaque);
	virtual Xv_opaque	l_b_Mark_create(Xv_opaque);
	virtual Xv_opaque	l_b_Subtr_create(Xv_opaque);
	virtual Xv_opaque	l_b_OvrApp_create(Xv_opaque);
	virtual Xv_opaque	l_b_OvrLds_menu_create(Xv_opaque);
	virtual Xv_opaque	l_c_line1_create(Xv_opaque);
	virtual Xv_opaque	l_b_Exm_create(Xv_opaque);
	virtual Xv_opaque	l_b_ConsLR_create(Xv_opaque);
	virtual Xv_opaque	l_cp_create(Xv_opaque);
};

class sem_0_l_bw1_objects {

public:
	Xv_opaque	l_bw1;
	Xv_opaque	l_c_line2;
	Xv_opaque	l_b_shift_ll1;
	Xv_opaque	l_b_shift_l1;
	Xv_opaque	l_b_shift_r1;
	Xv_opaque	l_b_shift_rr1;
	Xv_opaque	l_c_line3;
	Xv_opaque	l_ss_HRate1;
	Xv_opaque	l_ss_12min1;
	Xv_opaque	l_ss_100mV1;
	Xv_opaque	l_b_Mark1;
	Xv_opaque	l_b_Subtr1;
	Xv_opaque	l_b_OvrApp1;
	Xv_opaque	l_b_OvrLds_menu1;
	Xv_opaque	l_c_line4;
	Xv_opaque	l_b_Exm1;
	Xv_opaque	l_b_ConsLR1;
	Xv_opaque	l_cp1;

	virtual void	objects_initialize(Xv_opaque);

	virtual Xv_opaque	l_bw1_create(Xv_opaque);
	virtual Xv_opaque	l_c_line2_create(Xv_opaque);
	virtual Xv_opaque	l_b_shift_ll1_create(Xv_opaque);
	virtual Xv_opaque	l_b_shift_l1_create(Xv_opaque);
	virtual Xv_opaque	l_b_shift_r1_create(Xv_opaque);
	virtual Xv_opaque	l_b_shift_rr1_create(Xv_opaque);
	virtual Xv_opaque	l_c_line3_create(Xv_opaque);
	virtual Xv_opaque	l_ss_HRate1_create(Xv_opaque);
	virtual Xv_opaque	l_ss_12min1_create(Xv_opaque);
	virtual Xv_opaque	l_ss_100mV1_create(Xv_opaque);
	virtual Xv_opaque	l_b_Mark1_create(Xv_opaque);
	virtual Xv_opaque	l_b_Subtr1_create(Xv_opaque);
	virtual Xv_opaque	l_b_OvrApp1_create(Xv_opaque);
	virtual Xv_opaque	l_b_OvrLds_menu1_create(Xv_opaque);
	virtual Xv_opaque	l_c_line4_create(Xv_opaque);
	virtual Xv_opaque	l_b_Exm1_create(Xv_opaque);
	virtual Xv_opaque	l_b_ConsLR1_create(Xv_opaque);
	virtual Xv_opaque	l_cp1_create(Xv_opaque);
};

class sem_0_l_bw2_objects {

public:
	Xv_opaque	l_bw2;
	Xv_opaque	l_c_line5;
	Xv_opaque	l_b_shift_ll2;
	Xv_opaque	l_b_shift_l2;
	Xv_opaque	l_b_shift_r2;
	Xv_opaque	l_b_shift_rr2;
	Xv_opaque	l_c_line6;
	Xv_opaque	l_ss_HRate2;
	Xv_opaque	l_ss_12min2;
	Xv_opaque	l_ss_100mV2;
	Xv_opaque	l_b_Mark2;
	Xv_opaque	l_b_Subtr2;
	Xv_opaque	l_b_OvrApp2;
	Xv_opaque	l_b_OvrLds_menu2;
	Xv_opaque	l_c_line7;
	Xv_opaque	l_b_Exm2;
	Xv_opaque	l_b_ConsLR2;
	Xv_opaque	l_cp2;

	virtual void	objects_initialize(Xv_opaque);

	virtual Xv_opaque	l_bw2_create(Xv_opaque);
	virtual Xv_opaque	l_c_line5_create(Xv_opaque);
	virtual Xv_opaque	l_b_shift_ll2_create(Xv_opaque);
	virtual Xv_opaque	l_b_shift_l2_create(Xv_opaque);
	virtual Xv_opaque	l_b_shift_r2_create(Xv_opaque);
	virtual Xv_opaque	l_b_shift_rr2_create(Xv_opaque);
	virtual Xv_opaque	l_c_line6_create(Xv_opaque);
	virtual Xv_opaque	l_ss_HRate2_create(Xv_opaque);
	virtual Xv_opaque	l_ss_12min2_create(Xv_opaque);
	virtual Xv_opaque	l_ss_100mV2_create(Xv_opaque);
	virtual Xv_opaque	l_b_Mark2_create(Xv_opaque);
	virtual Xv_opaque	l_b_Subtr2_create(Xv_opaque);
	virtual Xv_opaque	l_b_OvrApp2_create(Xv_opaque);
	virtual Xv_opaque	l_b_OvrLds_menu2_create(Xv_opaque);
	virtual Xv_opaque	l_c_line7_create(Xv_opaque);
	virtual Xv_opaque	l_b_Exm2_create(Xv_opaque);
	virtual Xv_opaque	l_b_ConsLR2_create(Xv_opaque);
	virtual Xv_opaque	l_cp2_create(Xv_opaque);
};

class sem_0_d_pw_objects {

public:
	Xv_opaque	d_pw;
	Xv_opaque	textpane_data;

	virtual void	objects_initialize(Xv_opaque);

	virtual Xv_opaque	d_pw_create(Xv_opaque);
	virtual Xv_opaque	textpane_data_create(Xv_opaque);
};

class sem_0_c_pw_objects {

public:
	Xv_opaque	c_pw;
	Xv_opaque	textpane_numepis;

	virtual void	objects_initialize(Xv_opaque);

	virtual Xv_opaque	c_pw_create(Xv_opaque);
	virtual Xv_opaque	textpane_numepis_create(Xv_opaque);
};

class sem_0_h_pw_objects {

public:
	Xv_opaque	h_pw;
	Xv_opaque	textpane_help;

	virtual void	objects_initialize(Xv_opaque);

	virtual Xv_opaque	h_pw_create(Xv_opaque);
	virtual Xv_opaque	textpane_help_create(Xv_opaque);
};
#endif
//=========================================================================================================
