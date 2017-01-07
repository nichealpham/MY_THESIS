//=========================================================================================================
//
// semia_ui.cc
//

#include <stdio.h>
#include <sys/param.h>
#include <sys/types.h>
#include <xview/xview.h>
#include <xview/canvas.h>
#include <xview/panel.h>
#include <xview/scrollbar.h>
#include <xview/svrimage.h>
#include <xview/termsw.h>
#include <xview/text.h>
#include <xview/tty.h>
#include <xview/xv_xrect.h>
#include "semia_ui.h"

//
// Create object `l_menu_Ov' in the specified instance.
//
Xv_opaque
sem_0_l_menu_Ov_create(caddr_t ip, Xv_opaque owner)
{
	extern Menu_item	l_call_OvrLds_Lead0(Menu_item, Menu_generate);
	extern Menu_item	l_call_OvrLds_Lead1(Menu_item, Menu_generate);
	extern Menu_item	l_call_OvrLds_Lead2(Menu_item, Menu_generate);
	extern Menu_item	l_call_OvrLds_UnOvrly(Menu_item, Menu_generate);
	Xv_opaque	obj;
	
	obj = xv_create(XV_NULL, MENU_COMMAND_MENU,
		XV_KEY_DATA, INSTANCE, ip,
		MENU_ITEM,
			XV_KEY_DATA, INSTANCE, ip,
			MENU_STRING, "Lead0",
			MENU_GEN_PROC, l_call_OvrLds_Lead0,
			NULL,
		MENU_ITEM,
			XV_KEY_DATA, INSTANCE, ip,
			MENU_STRING, "Lead1",
			MENU_GEN_PROC, l_call_OvrLds_Lead1,
			NULL,
		MENU_ITEM,
			XV_KEY_DATA, INSTANCE, ip,
			MENU_STRING, "Lead2",
			MENU_GEN_PROC, l_call_OvrLds_Lead2,
			NULL,
		MENU_ITEM,
			XV_KEY_DATA, INSTANCE, ip,
			MENU_STRING, "UnOvrly",
			MENU_GEN_PROC, l_call_OvrLds_UnOvrly,
			NULL,
		MENU_DEFAULT, 4,
		NULL);
	return obj;
}

//
// Create object `d_menu_OvrLds' in the specified instance.
//
Xv_opaque
sem_0_d_menu_OvrLds_create(caddr_t ip, Xv_opaque owner)
{
	extern Menu_item	d_call_OvrLds_Lead0(Menu_item, Menu_generate);
	extern Menu_item	d_call_OvrLds_Lead1(Menu_item, Menu_generate);
	extern Menu_item	d_call_OvrLds_Lead2(Menu_item, Menu_generate);
	extern Menu_item	d_call_OvrLds_UnOvrly(Menu_item, Menu_generate);
	Xv_opaque	obj;
	
	obj = xv_create(XV_NULL, MENU_COMMAND_MENU,
		XV_KEY_DATA, INSTANCE, ip,
		MENU_ITEM,
			XV_KEY_DATA, INSTANCE, ip,
			MENU_STRING, "Lead0",
			MENU_GEN_PROC, d_call_OvrLds_Lead0,
			NULL,
		MENU_ITEM,
			XV_KEY_DATA, INSTANCE, ip,
			MENU_STRING, "Lead1",
			MENU_GEN_PROC, d_call_OvrLds_Lead1,
			NULL,
		MENU_ITEM,
			XV_KEY_DATA, INSTANCE, ip,
			MENU_STRING, "Lead2",
			MENU_GEN_PROC, d_call_OvrLds_Lead2,
			NULL,
		MENU_ITEM,
			XV_KEY_DATA, INSTANCE, ip,
			MENU_STRING, "UnOvrly",
			MENU_GEN_PROC, d_call_OvrLds_UnOvrly,
			NULL,
		MENU_DEFAULT, 4,
		NULL);
	return obj;
}

//
// Create object `l_menu_OvrLds1' in the specified instance.
//
Xv_opaque
sem_0_l_menu_OvrLds1_create(caddr_t ip, Xv_opaque owner)
{
	extern Menu_item	l_call_OvrLds1_Lead0(Menu_item, Menu_generate);
	extern Menu_item	l_call_OvrLds1_Lead1(Menu_item, Menu_generate);
	extern Menu_item	l_call_OvrLds1_Lead2(Menu_item, Menu_generate);
	extern Menu_item	l_call_OvrLds1_UnOvrly(Menu_item, Menu_generate);
	Xv_opaque	obj;
	
	obj = xv_create(XV_NULL, MENU_COMMAND_MENU,
		XV_KEY_DATA, INSTANCE, ip,
		MENU_ITEM,
			XV_KEY_DATA, INSTANCE, ip,
			MENU_STRING, "Lead0",
			MENU_GEN_PROC, l_call_OvrLds1_Lead0,
			NULL,
		MENU_ITEM,
			XV_KEY_DATA, INSTANCE, ip,
			MENU_STRING, "Lead1",
			MENU_GEN_PROC, l_call_OvrLds1_Lead1,
			NULL,
		MENU_ITEM,
			XV_KEY_DATA, INSTANCE, ip,
			MENU_STRING, "Lead2",
			MENU_GEN_PROC, l_call_OvrLds1_Lead2,
			NULL,
		MENU_ITEM,
			XV_KEY_DATA, INSTANCE, ip,
			MENU_STRING, "UnOvrly",
			MENU_GEN_PROC, l_call_OvrLds1_UnOvrly,
			NULL,
		MENU_DEFAULT, 4,
		NULL);
	return obj;
}

//
// Create object `l_menu_OvrLds2' in the specified instance.
//
Xv_opaque
sem_0_l_menu_OvrLds2_create(caddr_t ip, Xv_opaque owner)
{
	extern Menu_item	l_call_OvrLds2_Lead0(Menu_item, Menu_generate);
	extern Menu_item	l_call_OvrLds2_Lead1(Menu_item, Menu_generate);
	extern Menu_item	l_call_OvrLds2_Lead2(Menu_item, Menu_generate);
	extern Menu_item	l_call_OvrLds2_UnOvrly(Menu_item, Menu_generate);
	Xv_opaque	obj;
	
	obj = xv_create(XV_NULL, MENU_COMMAND_MENU,
		XV_KEY_DATA, INSTANCE, ip,
		MENU_ITEM,
			XV_KEY_DATA, INSTANCE, ip,
			MENU_STRING, "Lead0",
			MENU_GEN_PROC, l_call_OvrLds2_Lead0,
			NULL,
		MENU_ITEM,
			XV_KEY_DATA, INSTANCE, ip,
			MENU_STRING, "Lead1",
			MENU_GEN_PROC, l_call_OvrLds2_Lead1,
			NULL,
		MENU_ITEM,
			XV_KEY_DATA, INSTANCE, ip,
			MENU_STRING, "Lead2",
			MENU_GEN_PROC, l_call_OvrLds2_Lead2,
			NULL,
		MENU_ITEM,
			XV_KEY_DATA, INSTANCE, ip,
			MENU_STRING, "UnOvrly",
			MENU_GEN_PROC, l_call_OvrLds2_UnOvrly,
			NULL,
		MENU_DEFAULT, 4,
		NULL);
	return obj;
}

//
// Create object `d_menu_lead' in the specified instance.
//
Xv_opaque
sem_0_d_menu_lead_create(caddr_t ip, Xv_opaque owner)
{
	extern Menu_item	d_menu_call_lead0(Menu_item, Menu_generate);
	extern Menu_item	d_menu_call_lead1(Menu_item, Menu_generate);
	extern Menu_item	d_menu_call_lead2(Menu_item, Menu_generate);
	Xv_opaque	obj;
	
	obj = xv_create(XV_NULL, MENU_COMMAND_MENU,
		XV_KEY_DATA, INSTANCE, ip,
		MENU_ITEM,
			XV_KEY_DATA, INSTANCE, ip,
			MENU_STRING, "Lead0",
			MENU_GEN_PROC, d_menu_call_lead0,
			NULL,
		MENU_ITEM,
			XV_KEY_DATA, INSTANCE, ip,
			MENU_STRING, "Lead1",
			MENU_GEN_PROC, d_menu_call_lead1,
			NULL,
		MENU_ITEM,
			XV_KEY_DATA, INSTANCE, ip,
			MENU_STRING, "Lead2",
			MENU_GEN_PROC, d_menu_call_lead2,
			NULL,
		NULL);
	return obj;
}

//
// Create object `l_menu_OvrLds' in the specified instance.
//
Xv_opaque
sem_0_l_menu_OvrLds_create(caddr_t ip, Xv_opaque owner)
{
	extern Menu_item	l_call_OvrLds_Lead0(Menu_item, Menu_generate);
	extern Menu_item	l_call_OvrLds_Lead1(Menu_item, Menu_generate);
	extern Menu_item	l_call_OvrLds_Lead2(Menu_item, Menu_generate);
	extern Menu_item	l_call_OvrLds_UnOvrly(Menu_item, Menu_generate);
	Xv_opaque	obj;
	
	obj = xv_create(XV_NULL, MENU_COMMAND_MENU,
		XV_KEY_DATA, INSTANCE, ip,
		MENU_ITEM,
			XV_KEY_DATA, INSTANCE, ip,
			MENU_STRING, "Lead0",
			MENU_GEN_PROC, l_call_OvrLds_Lead0,
			NULL,
		MENU_ITEM,
			XV_KEY_DATA, INSTANCE, ip,
			MENU_STRING, "Lead1",
			MENU_GEN_PROC, l_call_OvrLds_Lead1,
			NULL,
		MENU_ITEM,
			XV_KEY_DATA, INSTANCE, ip,
			MENU_STRING, "Lead2",
			MENU_GEN_PROC, l_call_OvrLds_Lead2,
			NULL,
		MENU_ITEM,
			XV_KEY_DATA, INSTANCE, ip,
			MENU_STRING, "UnOvrly",
			MENU_GEN_PROC, l_call_OvrLds_UnOvrly,
			NULL,
		MENU_DEFAULT, 4,
		NULL);
	return obj;
}

//
// Initialize an instance of object `m_bw'.
//
void
sem_0_m_bw_objects::objects_initialize(Xv_opaque owner)
{
	m_bw = m_bw_create(owner);
	m_c = m_c_create(m_bw);
	m_b_Open = m_b_Open_create(m_c);
	m_b_Lead0 = m_b_Lead0_create(m_c);
	m_b_Data = m_b_Data_create(m_c);
	m_b_NumEpis = m_b_NumEpis_create(m_c);
	m_b_Lead1 = m_b_Lead1_create(m_c);
	m_b_KLCoeff = m_b_KLCoeff_create(m_c);
	m_b_AplOp = m_b_AplOp_create(m_c);
	m_b_Quit = m_b_Quit_create(m_c);
	m_b_Lead2 = m_b_Lead2_create(m_c);
	m_b_DiagData = m_b_DiagData_create(m_c);
	m_b_help = m_b_help_create(m_c);
	m_m_Record = m_m_Record_create(m_c);
}

//
// Create object `m_bw' in the specified instance.
//
Xv_opaque
sem_0_m_bw_objects::m_bw_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, FRAME,
		XV_KEY_DATA, INSTANCE, this,
		XV_WIDTH, 364,
		XV_HEIGHT, 158,
		XV_LABEL, "SEMIA (Semi-Automatic) (Viewing) V: 3.0.1",
		FRAME_SHOW_FOOTER, FALSE,
		FRAME_SHOW_RESIZE_CORNER, TRUE,
		NULL);
	return obj;
}

//
// Create object `m_c' in the specified instance.
//
Xv_opaque
sem_0_m_bw_objects::m_c_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 0,
		XV_Y, 0,
		XV_WIDTH, WIN_EXTEND_TO_EDGE,
		XV_HEIGHT, WIN_EXTEND_TO_EDGE,
		WIN_BORDER, TRUE,
		NULL);
	return obj;
}

//
// Create object `m_b_Open' in the specified instance.
//
Xv_opaque
sem_0_m_bw_objects::m_b_Open_create(Xv_opaque owner)
{
	extern void		sem_0_m_bw_m_b_Open_notify_callback(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 10,
		XV_Y, 10,
		PANEL_LABEL_WIDTH, 60,
		PANEL_LABEL_STRING, "   Open",
		PANEL_NOTIFY_PROC, sem_0_m_bw_m_b_Open_notify_callback,
		NULL);
	return obj;
}

//
// Create object `m_b_Lead0' in the specified instance.
//
Xv_opaque
sem_0_m_bw_objects::m_b_Lead0_create(Xv_opaque owner)
{
	extern void		init_Lead(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 95,
		XV_Y, 10,
		PANEL_LABEL_WIDTH, 60,
		PANEL_LABEL_STRING, "  Lead0",
		PANEL_INACTIVE, TRUE,
		PANEL_NOTIFY_PROC, init_Lead,
		NULL);
	return obj;
}

//
// Create object `m_b_Data' in the specified instance.
//
Xv_opaque
sem_0_m_bw_objects::m_b_Data_create(Xv_opaque owner)
{
	extern void		init_data(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 180,
		XV_Y, 10,
		PANEL_LABEL_WIDTH, 60,
		PANEL_LABEL_STRING, "   Data",
		PANEL_INACTIVE, TRUE,
		PANEL_NOTIFY_PROC, init_data,
		NULL);
	return obj;
}

//
// Create object `m_b_NumEpis' in the specified instance.
//
Xv_opaque
sem_0_m_bw_objects::m_b_NumEpis_create(Xv_opaque owner)
{
	extern void		sem_0_m_bw_m_b_NumEpis_notify_callback(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 265,
		XV_Y, 10,
		PANEL_LABEL_WIDTH, 60,
		PANEL_LABEL_STRING, "N_Events",
		PANEL_INACTIVE, TRUE,
		PANEL_NOTIFY_PROC, sem_0_m_bw_m_b_NumEpis_notify_callback,
		NULL);
	return obj;
}

//
// Create object `m_b_Lead1' in the specified instance.
//
Xv_opaque
sem_0_m_bw_objects::m_b_Lead1_create(Xv_opaque owner)
{
	extern void		init_Lead1(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 95,
		XV_Y, 50,
		PANEL_LABEL_WIDTH, 60,
		PANEL_LABEL_STRING, "  Lead1",
		PANEL_INACTIVE, TRUE,
		PANEL_NOTIFY_PROC, init_Lead1,
		NULL);
	return obj;
}

//
// Create object `m_b_KLCoeff' in the specified instance.
//
Xv_opaque
sem_0_m_bw_objects::m_b_KLCoeff_create(Xv_opaque owner)
{
	extern void		init_kl(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 180,
		XV_Y, 50,
		PANEL_LABEL_WIDTH, 60,
		PANEL_LABEL_STRING, " KLCoeff",
		PANEL_INACTIVE, TRUE,
		PANEL_NOTIFY_PROC, init_kl,
		NULL);
	return obj;
}

//
// Create object `m_b_AplOp' in the specified instance.
//
Xv_opaque
sem_0_m_bw_objects::m_b_AplOp_create(Xv_opaque owner)
{
	extern void		apply_options(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 265,
		XV_Y, 50,
		PANEL_LABEL_WIDTH, 60,
		PANEL_LABEL_STRING, " AplOp",
		PANEL_NOTIFY_PROC, apply_options,
		NULL);
	return obj;
}

//
// Create object `m_b_Quit' in the specified instance.
//
Xv_opaque
sem_0_m_bw_objects::m_b_Quit_create(Xv_opaque owner)
{
	extern void		sem_0_m_bw_m_b_Quit_notify_callback(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 10,
		XV_Y, 90,
		PANEL_LABEL_WIDTH, 60,
		PANEL_LABEL_STRING, "   Quit",
		PANEL_NOTIFY_PROC, sem_0_m_bw_m_b_Quit_notify_callback,
		NULL);
	return obj;
}

//
// Create object `m_b_Lead2' in the specified instance.
//
Xv_opaque
sem_0_m_bw_objects::m_b_Lead2_create(Xv_opaque owner)
{
	extern void		init_Lead2(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 95,
		XV_Y, 90,
		PANEL_LABEL_WIDTH, 60,
		PANEL_LABEL_STRING, "  Lead2",
		PANEL_INACTIVE, TRUE,
		PANEL_NOTIFY_PROC, init_Lead2,
		NULL);
	return obj;
}

//
// Create object `m_b_DiagData' in the specified instance.
//
Xv_opaque
sem_0_m_bw_objects::m_b_DiagData_create(Xv_opaque owner)
{
	extern void		sem_0_m_bw_m_b_DiagData_notify_callback(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 180,
		XV_Y, 90,
		PANEL_LABEL_WIDTH, 60,
		PANEL_LABEL_STRING, " DiagData",
		PANEL_INACTIVE, TRUE,
		PANEL_NOTIFY_PROC, sem_0_m_bw_m_b_DiagData_notify_callback,
		NULL);
	return obj;
}

//
// Create object `m_b_help' in the specified instance.
//
Xv_opaque
sem_0_m_bw_objects::m_b_help_create(Xv_opaque owner)
{
	extern void		sem_0_m_bw_m_b_help_notify_callback(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 265,
		XV_Y, 90,
		PANEL_LABEL_WIDTH, 60,
		PANEL_LABEL_STRING, "  Help",
		PANEL_NOTIFY_PROC, sem_0_m_bw_m_b_help_notify_callback,
		NULL);
	return obj;
}

//
// Create object `m_m_Record' in the specified instance.
//
Xv_opaque
sem_0_m_bw_objects::m_m_Record_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_MESSAGE,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 25,
		XV_Y, 128,
		PANEL_LABEL_STRING, "Record:                                                             ",
		PANEL_LABEL_BOLD, TRUE,
		XV_SHOW, FALSE,
		NULL);
	return obj;
}

//
// Initialize an instance of object `k_bw'.
//
void
sem_0_k_bw_objects::objects_initialize(Xv_opaque owner)
{
	k_bw = k_bw_create(owner);
	k_c = k_c_create(k_bw);
	k_ss_ST = k_ss_ST_create(k_c);
	k_ss_1std = k_ss_1std_create(k_c);
	k_b_Overlay = k_b_Overlay_create(k_c);
	k_m_dummy1 = k_m_dummy1_create(k_c);
	k_m_dummy2 = k_m_dummy2_create(k_c);
	k_m_dummy3 = k_m_dummy3_create(k_c);
	k_cp = k_cp_create(k_bw);
}

//
// Create object `k_bw' in the specified instance.
//
Xv_opaque
sem_0_k_bw_objects::k_bw_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, FRAME,
		XV_KEY_DATA, INSTANCE, this,
		XV_WIDTH, 1128,
		XV_HEIGHT, 222,
		XV_LABEL, "SEMIA  [KL Coefficients]",
		XV_SHOW, FALSE,
		FRAME_SHOW_FOOTER, FALSE,
		FRAME_SHOW_RESIZE_CORNER, TRUE,
		NULL);
	return obj;
}

//
// Create object `k_c' in the specified instance.
//
Xv_opaque
sem_0_k_bw_objects::k_c_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 0,
		XV_Y, 0,
		XV_WIDTH, WIN_EXTEND_TO_EDGE,
		XV_HEIGHT, 26,
		WIN_BORDER, TRUE,
		NULL);
	return obj;
}

//
// Create object `k_ss_ST' in the specified instance.
//
Xv_opaque
sem_0_k_bw_objects::k_ss_ST_create(Xv_opaque owner)
{
	extern void		k_call_ST(Panel_item, int, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_CHOICE, PANEL_DISPLAY_LEVEL, PANEL_CURRENT,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 12,
		XV_Y, 2,
		PANEL_CHOICE_NCOLS, 1,
		PANEL_LAYOUT, PANEL_HORIZONTAL,
		PANEL_NOTIFY_PROC, k_call_ST,
		PANEL_CHOICE_STRINGS,
			"ST KL",
			"QRS KL",
			NULL,
		PANEL_DEFAULT_VALUE, 0,
		PANEL_VALUE, 0,
		NULL);
	return obj;
}

//
// Create object `k_ss_1std' in the specified instance.
//
Xv_opaque
sem_0_k_bw_objects::k_ss_1std_create(Xv_opaque owner)
{
	extern void		k_call_1std(Panel_item, int, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_CHOICE, PANEL_DISPLAY_LEVEL, PANEL_CURRENT,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 1020,
		XV_Y, 2,
		PANEL_CHOICE_NCOLS, 2,
		PANEL_LAYOUT, PANEL_HORIZONTAL,
		PANEL_NOTIFY_PROC, k_call_1std,
		PANEL_CHOICE_STRINGS,
			"0.1 std",
			"0.125 std",
			"0.2 std",
			"0.25 std",
			"0.5 std",
			"1 std",
			"2 std",
			"4 std",
			"5 std",
			"8 std",
			"10 std",
			"20 std",
			NULL,
		PANEL_DEFAULT_VALUE, 5,
		PANEL_VALUE, 5,
		NULL);
	return obj;
}

//
// Create object `k_b_Overlay' in the specified instance.
//
Xv_opaque
sem_0_k_bw_objects::k_b_Overlay_create(Xv_opaque owner)
{
	extern void		k_call_Overlay(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 104,
		XV_Y, 4,
		PANEL_LABEL_STRING, "Overlay",
		PANEL_NOTIFY_PROC, k_call_Overlay,
		NULL);
	return obj;
}

//
// Create object `k_m_dummy1' in the specified instance.
//
Xv_opaque
sem_0_k_bw_objects::k_m_dummy1_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_MESSAGE,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 180,
		XV_Y, 7,
		PANEL_LABEL_STRING, "                                                          ",
		PANEL_LABEL_BOLD, TRUE,
		XV_SHOW, FALSE,
		NULL);
	return obj;
}

//
// Create object `k_m_dummy2' in the specified instance.
//
Xv_opaque
sem_0_k_bw_objects::k_m_dummy2_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_MESSAGE,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 430,
		XV_Y, 7,
		PANEL_LABEL_STRING, "                                                           ",
		PANEL_LABEL_BOLD, TRUE,
		XV_SHOW, FALSE,
		NULL);
	return obj;
}

//
// Create object `k_m_dummy3' in the specified instance.
//
Xv_opaque
sem_0_k_bw_objects::k_m_dummy3_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_MESSAGE,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 680,
		XV_Y, 7,
		PANEL_LABEL_STRING, "                                                           ",
		PANEL_LABEL_BOLD, TRUE,
		XV_SHOW, FALSE,
		NULL);
	return obj;
}

//
// Create object `k_cp' in the specified instance.
//
Xv_opaque
sem_0_k_bw_objects::k_cp_create(Xv_opaque owner)
{
	extern Notify_value	sem_0_k_bw_k_cp_event_callback(Xv_window, Event *, Notify_arg, Notify_event_type);
	extern void	k_ini_cpb(Canvas, Xv_window, Display *, Window, Xv_xrectlist *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, CANVAS,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 0,
		XV_Y, (int)xv_get(k_c, XV_Y) +
		      (int)xv_get(k_c, XV_HEIGHT) + 2,
		XV_WIDTH, WIN_EXTEND_TO_EDGE,
		XV_HEIGHT, WIN_EXTEND_TO_EDGE,
		CANVAS_REPAINT_PROC, k_ini_cpb,
		CANVAS_X_PAINT_WINDOW, TRUE,
		NULL);
	xv_set(canvas_paint_window(obj), WIN_CONSUME_EVENTS,
		WIN_MOUSE_BUTTONS,
		NULL, NULL);
	notify_interpose_event_func(canvas_paint_window(obj),
		(Notify_func) sem_0_k_bw_k_cp_event_callback, NOTIFY_SAFE);
	//
	// This line is here for backwards compatibility. It will be
	// removed for the next release.
	//
	xv_set(canvas_paint_window(obj), XV_KEY_DATA, INSTANCE, this, NULL);
	return obj;
}

//
// Initialize an instance of object `o_pw'.
//
void
sem_0_o_pw_objects::objects_initialize(Xv_opaque owner)
{
	o_pw = o_pw_create(owner);
	o_c = o_c_create(o_pw);
	o_file_name = o_file_name_create(o_c);
	o_m_message1 = o_m_message1_create(o_c);
	o_b_Cancel = o_b_Cancel_create(o_c);
	o_b_OK = o_b_OK_create(o_c);
}

//
// Create object `o_pw' in the specified instance.
//
Xv_opaque
sem_0_o_pw_objects::o_pw_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, FRAME_CMD,
		XV_KEY_DATA, INSTANCE, this,
		XV_WIDTH, 307,
		XV_HEIGHT, 96,
		XV_LABEL, "SEMIA  Record",
		XV_SHOW, FALSE,
		FRAME_SHOW_FOOTER, FALSE,
		FRAME_SHOW_RESIZE_CORNER, TRUE,
		FRAME_CMD_PUSHPIN_IN, TRUE,
		NULL);
	xv_set(xv_get(obj, FRAME_CMD_PANEL), WIN_SHOW, FALSE, NULL);
	return obj;
}

//
// Create object `o_c' in the specified instance.
//
Xv_opaque
sem_0_o_pw_objects::o_c_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 0,
		XV_Y, 0,
		XV_WIDTH, WIN_EXTEND_TO_EDGE,
		XV_HEIGHT, WIN_EXTEND_TO_EDGE,
		WIN_BORDER, TRUE,
		NULL);
	return obj;
}

//
// Create object `o_file_name' in the specified instance.
//
Xv_opaque
sem_0_o_pw_objects::o_file_name_create(Xv_opaque owner)
{
	extern Panel_setting	get_record_name(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_TEXT,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 10,
		XV_Y, 10,
		PANEL_VALUE_DISPLAY_LENGTH, 20,
		PANEL_VALUE_STORED_LENGTH, 60,
		PANEL_LABEL_STRING, "Record:",
		PANEL_LAYOUT, PANEL_HORIZONTAL,
		PANEL_READ_ONLY, FALSE,
		PANEL_NOTIFY_PROC, get_record_name,
		NULL);
	return obj;
}

//
// Create object `o_m_message1' in the specified instance.
//
Xv_opaque
sem_0_o_pw_objects::o_m_message1_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_MESSAGE,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 8,
		XV_Y, 36,
		PANEL_LABEL_STRING, "                                                                         ",
		PANEL_LABEL_BOLD, TRUE,
		PANEL_INACTIVE, TRUE,
		NULL);
	return obj;
}

//
// Create object `o_b_Cancel' in the specified instance.
//
Xv_opaque
sem_0_o_pw_objects::o_b_Cancel_create(Xv_opaque owner)
{
	extern void		sem_0_o_pw_o_b_Cancel_notify_callback(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 68,
		XV_Y, 56,
		PANEL_LABEL_WIDTH, 45,
		PANEL_LABEL_STRING, "Cancel",
		PANEL_NOTIFY_PROC, sem_0_o_pw_o_b_Cancel_notify_callback,
		NULL);
	return obj;
}

//
// Create object `o_b_OK' in the specified instance.
//
Xv_opaque
sem_0_o_pw_objects::o_b_OK_create(Xv_opaque owner)
{
	extern void		open_input_record(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 165,
		XV_Y, 56,
		PANEL_LABEL_WIDTH, 40,
		PANEL_LABEL_STRING, "  OK",
		PANEL_INACTIVE, TRUE,
		PANEL_NOTIFY_PROC, open_input_record,
		NULL);
	return obj;
}

//
// Initialize an instance of object `q_pw'.
//
void
sem_0_q_pw_objects::objects_initialize(Xv_opaque owner)
{
	q_pw = q_pw_create(owner);
	q_c = q_c_create(q_pw);
	q_m_Save = q_m_Save_create(q_c);
	q_b_Cancel = q_b_Cancel_create(q_c);
	q_b_Quit = q_b_Quit_create(q_c);
}

//
// Create object `q_pw' in the specified instance.
//
Xv_opaque
sem_0_q_pw_objects::q_pw_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, FRAME_CMD,
		XV_KEY_DATA, INSTANCE, this,
		XV_WIDTH, 307,
		XV_HEIGHT, 96,
		XV_LABEL, "SEMIA  Quit",
		XV_SHOW, FALSE,
		FRAME_SHOW_FOOTER, FALSE,
		FRAME_SHOW_RESIZE_CORNER, TRUE,
		FRAME_CMD_PUSHPIN_IN, TRUE,
		NULL);
	xv_set(xv_get(obj, FRAME_CMD_PANEL), WIN_SHOW, FALSE, NULL);
	return obj;
}

//
// Create object `q_c' in the specified instance.
//
Xv_opaque
sem_0_q_pw_objects::q_c_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 0,
		XV_Y, 0,
		XV_WIDTH, WIN_EXTEND_TO_EDGE,
		XV_HEIGHT, WIN_EXTEND_TO_EDGE,
		WIN_BORDER, TRUE,
		NULL);
	return obj;
}

//
// Create object `q_m_Save' in the specified instance.
//
Xv_opaque
sem_0_q_pw_objects::q_m_Save_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_MESSAGE,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 90,
		XV_Y, 22,
		PANEL_LABEL_STRING, "         Quit  ?",
		PANEL_LABEL_BOLD, TRUE,
		NULL);
	return obj;
}

//
// Create object `q_b_Cancel' in the specified instance.
//
Xv_opaque
sem_0_q_pw_objects::q_b_Cancel_create(Xv_opaque owner)
{
	extern void		sem_0_q_pw_q_b_Cancel_notify_callback(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 68,
		XV_Y, 55,
		PANEL_LABEL_WIDTH, 45,
		PANEL_LABEL_STRING, "Cancel",
		PANEL_NOTIFY_PROC, sem_0_q_pw_q_b_Cancel_notify_callback,
		NULL);
	return obj;
}

//
// Create object `q_b_Quit' in the specified instance.
//
Xv_opaque
sem_0_q_pw_objects::q_b_Quit_create(Xv_opaque owner)
{
	extern void		semia_terminate(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 165,
		XV_Y, 55,
		PANEL_LABEL_WIDTH, 40,
		PANEL_LABEL_STRING, " Quit",
		PANEL_NOTIFY_PROC, semia_terminate,
		NULL);
	return obj;
}

//
// Initialize an instance of object `w_pw'.
//
void
sem_0_w_pw_objects::objects_initialize(Xv_opaque owner)
{
	w_pw = w_pw_create(owner);
	w_c = w_c_create(w_pw);
	w_m_message1 = w_m_message1_create(w_c);
	w_m_message2 = w_m_message2_create(w_c);
	w_m_message3 = w_m_message3_create(w_c);
	w_b_OK = w_b_OK_create(w_c);
}

//
// Create object `w_pw' in the specified instance.
//
Xv_opaque
sem_0_w_pw_objects::w_pw_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, FRAME_CMD,
		XV_KEY_DATA, INSTANCE, this,
		XV_WIDTH, 349,
		XV_HEIGHT, 156,
		XV_LABEL, "SEMIA  Message",
		XV_SHOW, FALSE,
		FRAME_SHOW_FOOTER, FALSE,
		FRAME_SHOW_RESIZE_CORNER, TRUE,
		FRAME_CMD_PUSHPIN_IN, TRUE,
		NULL);
	xv_set(xv_get(obj, FRAME_CMD_PANEL), WIN_SHOW, FALSE, NULL);
	return obj;
}

//
// Create object `w_c' in the specified instance.
//
Xv_opaque
sem_0_w_pw_objects::w_c_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 0,
		XV_Y, 0,
		XV_WIDTH, WIN_EXTEND_TO_EDGE,
		XV_HEIGHT, WIN_EXTEND_TO_EDGE,
		WIN_BORDER, TRUE,
		NULL);
	return obj;
}

//
// Create object `w_m_message1' in the specified instance.
//
Xv_opaque
sem_0_w_pw_objects::w_m_message1_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_MESSAGE,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 30,
		XV_Y, 28,
		PANEL_LABEL_STRING, "Status label 1                                                 ",
		PANEL_LABEL_BOLD, TRUE,
		NULL);
	return obj;
}

//
// Create object `w_m_message2' in the specified instance.
//
Xv_opaque
sem_0_w_pw_objects::w_m_message2_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_MESSAGE,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 30,
		XV_Y, 48,
		PANEL_LABEL_STRING, "Status label 2                                                 ",
		PANEL_LABEL_BOLD, TRUE,
		NULL);
	return obj;
}

//
// Create object `w_m_message3' in the specified instance.
//
Xv_opaque
sem_0_w_pw_objects::w_m_message3_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_MESSAGE,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 30,
		XV_Y, 68,
		PANEL_LABEL_STRING, "Status label 3                                                 ",
		PANEL_LABEL_BOLD, TRUE,
		NULL);
	return obj;
}

//
// Create object `w_b_OK' in the specified instance.
//
Xv_opaque
sem_0_w_pw_objects::w_b_OK_create(Xv_opaque owner)
{
	extern void		sem_0_w_pw_w_b_OK_notify_callback(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 140,
		XV_Y, 112,
		PANEL_LABEL_WIDTH, 40,
		PANEL_LABEL_STRING, "  OK",
		PANEL_NOTIFY_PROC, sem_0_w_pw_w_b_OK_notify_callback,
		NULL);
	return obj;
}

//
// Initialize an instance of object `d_bw'.
//
void
sem_0_d_bw_objects::objects_initialize(Xv_opaque owner)
{
	d_bw = d_bw_create(owner);
	d_c_line0 = d_c_line0_create(d_bw);
	d_ss_16s = d_ss_16s_create(d_c_line0);
	d_ss_520ms = d_ss_520ms_create(d_c_line0);
	d_ss_Ovrly = d_ss_Ovrly_create(d_c_line0);
	d_ss_6s = d_ss_6s_create(d_c_line0);
	d_ss_1mV = d_ss_1mV_create(d_c_line0);
	d_b_lead = d_b_lead_create(d_c_line0);
	d_b_OvrLds_menu = d_b_OvrLds_menu_create(d_c_line0);
	d_m_Average = d_m_Average_create(d_c_line0);
	d_m_Display = d_m_Display_create(d_c_line0);
	d_m_Opts = d_m_Opts_create(d_c_line0);
	d_c_line1 = d_c_line1_create(d_bw);
	d_b_OvrRef = d_b_OvrRef_create(d_c_line1);
	d_m_dummy = d_m_dummy_create(d_c_line1);
	d_cp = d_cp_create(d_bw);
}

//
// Create object `d_bw' in the specified instance.
//
Xv_opaque
sem_0_d_bw_objects::d_bw_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, FRAME,
		XV_KEY_DATA, INSTANCE, this,
		XV_WIDTH, 1128,
		XV_HEIGHT, 419,
		XV_LABEL, "SEMIA  [Data]",
		XV_SHOW, FALSE,
		FRAME_SHOW_FOOTER, FALSE,
		FRAME_SHOW_RESIZE_CORNER, TRUE,
		NULL);
	return obj;
}

//
// Create object `d_c_line0' in the specified instance.
//
Xv_opaque
sem_0_d_bw_objects::d_c_line0_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 0,
		XV_Y, 0,
		XV_WIDTH, WIN_EXTEND_TO_EDGE,
		XV_HEIGHT, 26,
		WIN_BORDER, TRUE,
		NULL);
	return obj;
}

//
// Create object `d_ss_16s' in the specified instance.
//
Xv_opaque
sem_0_d_bw_objects::d_ss_16s_create(Xv_opaque owner)
{
	extern void		d_call_16s(Panel_item, int, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_CHOICE, PANEL_DISPLAY_LEVEL, PANEL_CURRENT,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 500,
		XV_Y, 2,
		PANEL_CHOICE_NCOLS, 1,
		PANEL_LAYOUT, PANEL_HORIZONTAL,
		PANEL_NOTIFY_PROC, d_call_16s,
		PANEL_CHOICE_STRINGS,
			"Sngl",
			"2 s",
			"4 s",
			"6 s",
			"10 s",
			"16 s",
			"20 s",
			"30 s",
			"1 min",
			"2 min",
			"3 min",
			"4 min",
			"5 min",
			NULL,
		PANEL_DEFAULT_VALUE, 5,
		PANEL_VALUE, 5,
		NULL);
	return obj;
}

//
// Create object `d_ss_520ms' in the specified instance.
//
Xv_opaque
sem_0_d_bw_objects::d_ss_520ms_create(Xv_opaque owner)
{
	extern void		d_call_520ms(Panel_item, int, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_CHOICE, PANEL_DISPLAY_LEVEL, PANEL_CURRENT,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 580,
		XV_Y, 2,
		PANEL_CHOICE_NCOLS, 1,
		PANEL_LAYOUT, PANEL_HORIZONTAL,
		PANEL_NOTIFY_PROC, d_call_520ms,
		PANEL_CHOICE_STRINGS,
			"200 ms",
			"280 ms",
			"360 ms",
			"440 ms",
			"520 ms",
			"600 ms",
			"680 ms",
			"760 ms",
			"840 ms",
			"920 ms",
			"1000 ms",
			NULL,
		PANEL_DEFAULT_VALUE, 4,
		PANEL_VALUE, 4,
		NULL);
	return obj;
}

//
// Create object `d_ss_Ovrly' in the specified instance.
//
Xv_opaque
sem_0_d_bw_objects::d_ss_Ovrly_create(Xv_opaque owner)
{
	extern void		d_call_menu_Ovrly(Panel_item, int, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_CHOICE, PANEL_DISPLAY_LEVEL, PANEL_CURRENT,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 720,
		XV_Y, 2,
		PANEL_CHOICE_NCOLS, 1,
		PANEL_LAYOUT, PANEL_HORIZONTAL,
		PANEL_NOTIFY_PROC, d_call_menu_Ovrly,
		PANEL_CHOICE_STRINGS,
			"Ovrly",
			"OvShift",
			NULL,
		PANEL_DEFAULT_VALUE, 0,
		PANEL_VALUE, 0,
		NULL);
	return obj;
}

//
// Create object `d_ss_6s' in the specified instance.
//
Xv_opaque
sem_0_d_bw_objects::d_ss_6s_create(Xv_opaque owner)
{
	extern void		d_call_6s(Panel_item, int, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_CHOICE, PANEL_DISPLAY_LEVEL, PANEL_CURRENT,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 960,
		XV_Y, 2,
		PANEL_CHOICE_NCOLS, 2,
		PANEL_LAYOUT, PANEL_HORIZONTAL,
		PANEL_NOTIFY_PROC, d_call_6s,
		PANEL_CHOICE_STRINGS,
			"1 s",
			"2 s",
			"4 s",
			"5 s",
			"6 s",
			"8 s",
			"10 s",
			"12 s",
			"15 s",
			"20 s",
			"25 s",
			"30 s",
			"45 s",
			"60 s",
			NULL,
		PANEL_DEFAULT_VALUE, 4,
		PANEL_VALUE, 4,
		NULL);
	return obj;
}

//
// Create object `d_ss_1mV' in the specified instance.
//
Xv_opaque
sem_0_d_bw_objects::d_ss_1mV_create(Xv_opaque owner)
{
	extern void		d_call_1mV(Panel_item, int, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_CHOICE, PANEL_DISPLAY_LEVEL, PANEL_CURRENT,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 1035,
		XV_Y, 2,
		PANEL_CHOICE_NCOLS, 2,
		PANEL_LAYOUT, PANEL_HORIZONTAL,
		PANEL_NOTIFY_PROC, d_call_1mV,
		PANEL_CHOICE_STRINGS,
			"50 uV",
			"75 uV",
			"100 uV",
			"125 uV",
			"150 uV",
			"200 uV",
			"250 uV",
			"500 uV",
			"750 uV",
			"1 mV",
			"2 mV",
			"5 mV",
			NULL,
		PANEL_DEFAULT_VALUE, 9,
		PANEL_VALUE, 9,
		NULL);
	return obj;
}

//
// Create object `d_b_lead' in the specified instance.
//
Xv_opaque
sem_0_d_bw_objects::d_b_lead_create(Xv_opaque owner)
{
	extern void		d_call_menu_lead(Panel_item, Event *);
	extern Xv_opaque	sem_0_d_menu_lead_create(caddr_t, Xv_opaque);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 16,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 40,
		PANEL_LABEL_STRING, "Lead",
		PANEL_ITEM_MENU, sem_0_d_menu_lead_create((caddr_t) this, d_bw),
		PANEL_NOTIFY_PROC, d_call_menu_lead,
		NULL);
	return obj;
}

//
// Create object `d_b_OvrLds_menu' in the specified instance.
//
Xv_opaque
sem_0_d_bw_objects::d_b_OvrLds_menu_create(Xv_opaque owner)
{
	extern void		d_call_menu_OvrLds(Panel_item, Event *);
	extern Xv_opaque	sem_0_d_menu_OvrLds_create(caddr_t, Xv_opaque);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 112,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 40,
		PANEL_LABEL_STRING, "OvrLds",
		PANEL_ITEM_MENU, sem_0_d_menu_OvrLds_create((caddr_t) this, d_bw),
		PANEL_NOTIFY_PROC, d_call_menu_OvrLds,
		NULL);
	return obj;
}

//
// Create object `d_m_Average' in the specified instance.
//
Xv_opaque
sem_0_d_bw_objects::d_m_Average_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_MESSAGE,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 394,
		XV_Y, 7,
		PANEL_LABEL_STRING, "Average beat:",
		PANEL_LABEL_BOLD, TRUE,
		NULL);
	return obj;
}

//
// Create object `d_m_Display' in the specified instance.
//
Xv_opaque
sem_0_d_bw_objects::d_m_Display_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_MESSAGE,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 890,
		XV_Y, 7,
		PANEL_LABEL_STRING, "Display:",
		PANEL_LABEL_BOLD, TRUE,
		NULL);
	return obj;
}

//
// Create object `d_m_Opts' in the specified instance.
//
Xv_opaque
sem_0_d_bw_objects::d_m_Opts_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_MESSAGE,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 672,
		XV_Y, 8,
		PANEL_LABEL_STRING, "Opts:",
		PANEL_LABEL_BOLD, TRUE,
		NULL);
	return obj;
}

//
// Create object `d_c_line1' in the specified instance.
//
Xv_opaque
sem_0_d_bw_objects::d_c_line1_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 0,
		XV_Y, (int)xv_get(d_c_line0, XV_Y) +
		      (int)xv_get(d_c_line0, XV_HEIGHT) + 2,
		XV_WIDTH, WIN_EXTEND_TO_EDGE,
		XV_HEIGHT, 26,
		WIN_BORDER, TRUE,
		NULL);
	return obj;
}

//
// Create object `d_b_OvrRef' in the specified instance.
//
Xv_opaque
sem_0_d_bw_objects::d_b_OvrRef_create(Xv_opaque owner)
{
	extern void		d_call_OvrRef(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 16,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 53,
		PANEL_LABEL_STRING, "OvrRef",
		PANEL_INACTIVE, TRUE,
		PANEL_NOTIFY_PROC, d_call_OvrRef,
		NULL);
	return obj;
}

//
// Create object `d_m_dummy' in the specified instance.
//
Xv_opaque
sem_0_d_bw_objects::d_m_dummy_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_MESSAGE,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 90,
		XV_Y, 7,
		PANEL_LABEL_STRING, "                                    ",
		PANEL_LABEL_BOLD, TRUE,
		XV_SHOW, FALSE,
		NULL);
	return obj;
}

//
// Create object `d_cp' in the specified instance.
//
Xv_opaque
sem_0_d_bw_objects::d_cp_create(Xv_opaque owner)
{
	extern Notify_value	sem_0_d_bw_d_cp_event_callback(Xv_window, Event *, Notify_arg, Notify_event_type);
	extern void	d_ini_cpb(Canvas, Xv_window, Display *, Window, Xv_xrectlist *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, CANVAS,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 0,
		XV_Y, (int)xv_get(d_c_line1, XV_Y) +
		      (int)xv_get(d_c_line1, XV_HEIGHT) + 2,
		XV_WIDTH, WIN_EXTEND_TO_EDGE,
		XV_HEIGHT, WIN_EXTEND_TO_EDGE,
		CANVAS_REPAINT_PROC, d_ini_cpb,
		CANVAS_X_PAINT_WINDOW, TRUE,
		NULL);
	xv_set(canvas_paint_window(obj), WIN_CONSUME_EVENTS,
		WIN_MOUSE_BUTTONS,
		NULL, NULL);
	notify_interpose_event_func(canvas_paint_window(obj),
		(Notify_func) sem_0_d_bw_d_cp_event_callback, NOTIFY_SAFE);
	//
	// This line is here for backwards compatibility. It will be
	// removed for the next release.
	//
	xv_set(canvas_paint_window(obj), XV_KEY_DATA, INSTANCE, this, NULL);
	return obj;
}

//
// Initialize an instance of object `l_bw'.
//
void
sem_0_l_bw_objects::objects_initialize(Xv_opaque owner)
{
	l_bw = l_bw_create(owner);
	l_c_line00 = l_c_line00_create(l_bw);
	l_b_shift_ll = l_b_shift_ll_create(l_c_line00);
	l_b_shift_l = l_b_shift_l_create(l_c_line00);
	l_b_shift_r = l_b_shift_r_create(l_c_line00);
	l_b_shift_rr = l_b_shift_rr_create(l_c_line00);
	l_c_line01 = l_c_line01_create(l_bw);
	l_ss_HRate = l_ss_HRate_create(l_c_line01);
	l_ss_12min = l_ss_12min_create(l_c_line01);
	l_ss_100mV = l_ss_100mV_create(l_c_line01);
	l_b_Mark = l_b_Mark_create(l_c_line01);
	l_b_Subtr = l_b_Subtr_create(l_c_line01);
	l_b_OvrApp = l_b_OvrApp_create(l_c_line01);
	l_b_OvrLds_menu = l_b_OvrLds_menu_create(l_c_line01);
	l_c_line1 = l_c_line1_create(l_bw);
	l_b_Exm = l_b_Exm_create(l_c_line1);
	l_b_ConsLR = l_b_ConsLR_create(l_c_line1);
	l_cp = l_cp_create(l_bw);
}

//
// Create object `l_bw' in the specified instance.
//
Xv_opaque
sem_0_l_bw_objects::l_bw_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, FRAME,
		XV_KEY_DATA, INSTANCE, this,
		XV_WIDTH, 1128,
		XV_HEIGHT, 235,
		XV_LABEL, "SEMIA  [Lead 0]",
		XV_SHOW, FALSE,
		FRAME_SHOW_FOOTER, FALSE,
		FRAME_SHOW_RESIZE_CORNER, FALSE,
		NULL);
	return obj;
}

//
// Create object `l_c_line00' in the specified instance.
//
Xv_opaque
sem_0_l_bw_objects::l_c_line00_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 0,
		XV_Y, 0,
		XV_WIDTH, 158,
		XV_HEIGHT, 26,
		WIN_BORDER, TRUE,
		NULL);
	return obj;
}

//
// Create object `l_b_shift_ll' in the specified instance.
//
Xv_opaque
sem_0_l_bw_objects::l_b_shift_ll_create(Xv_opaque owner)
{
	extern void		l_call_shift_ll(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 1,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 18,
		PANEL_LABEL_STRING, "<<",
		PANEL_NOTIFY_PROC, l_call_shift_ll,
		NULL);
	return obj;
}

//
// Create object `l_b_shift_l' in the specified instance.
//
Xv_opaque
sem_0_l_bw_objects::l_b_shift_l_create(Xv_opaque owner)
{
	extern void		l_call_shift_l(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 40,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 18,
		PANEL_LABEL_STRING, " <",
		PANEL_NOTIFY_PROC, l_call_shift_l,
		NULL);
	return obj;
}

//
// Create object `l_b_shift_r' in the specified instance.
//
Xv_opaque
sem_0_l_bw_objects::l_b_shift_r_create(Xv_opaque owner)
{
	extern void		l_call_shift_r(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 80,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 18,
		PANEL_LABEL_STRING, " >",
		PANEL_NOTIFY_PROC, l_call_shift_r,
		NULL);
	return obj;
}

//
// Create object `l_b_shift_rr' in the specified instance.
//
Xv_opaque
sem_0_l_bw_objects::l_b_shift_rr_create(Xv_opaque owner)
{
	extern void		l_call_shift_rr(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 120,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 18,
		PANEL_LABEL_STRING, ">>",
		PANEL_NOTIFY_PROC, l_call_shift_rr,
		NULL);
	return obj;
}

//
// Create object `l_c_line01' in the specified instance.
//
Xv_opaque
sem_0_l_bw_objects::l_c_line01_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, (int)xv_get(l_c_line00, XV_X) +
		      (int)xv_get(l_c_line00, XV_WIDTH) + 2,
		XV_Y, 0,
		XV_WIDTH, WIN_EXTEND_TO_EDGE,
		XV_HEIGHT, 26,
		WIN_BORDER, TRUE,
		NULL);
	return obj;
}

//
// Create object `l_ss_HRate' in the specified instance.
//
Xv_opaque
sem_0_l_bw_objects::l_ss_HRate_create(Xv_opaque owner)
{
	extern void		l_call_HRate(Panel_item, int, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_CHOICE, PANEL_DISPLAY_LEVEL, PANEL_CURRENT,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 630,
		XV_Y, 2,
		PANEL_CHOICE_NCOLS, 1,
		PANEL_LAYOUT, PANEL_HORIZONTAL,
		PANEL_NOTIFY_PROC, l_call_HRate,
		PANEL_CHOICE_STRINGS,
			"HRate",
			"HR Raw",
			"ST Fine",
			"STsl Fine",
			"STsl Raw",
			"Episodes",
			"Hide HR",
			NULL,
		PANEL_VALUE, 0,
		NULL);
	return obj;
}

//
// Create object `l_ss_12min' in the specified instance.
//
Xv_opaque
sem_0_l_bw_objects::l_ss_12min_create(Xv_opaque owner)
{
	extern void		l_call_12min(Panel_item, int, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_CHOICE, PANEL_DISPLAY_LEVEL, PANEL_CURRENT,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 808,
		XV_Y, 2,
		PANEL_CHOICE_NCOLS, 2,
		PANEL_LAYOUT, PANEL_HORIZONTAL,
		PANEL_NOTIFY_PROC, l_call_12min,
		PANEL_CHOICE_STRINGS,
			"1 min",
			"2 min",
			"3 min",
			"6 min",
			"9 min",
			"12 min",
			"24 min",
			"30 min",
			"1 h",
			"2 h",
			"4 h",
			"6 h",
			"12 h",
			"24 h",
			"48 h",
			"96 h",
			NULL,
		PANEL_DEFAULT_VALUE, 5,
		PANEL_VALUE, 5,
		NULL);
	return obj;
}

//
// Create object `l_ss_100mV' in the specified instance.
//
Xv_opaque
sem_0_l_bw_objects::l_ss_100mV_create(Xv_opaque owner)
{
	extern void		l_call_100mV(Panel_item, int, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_CHOICE, PANEL_DISPLAY_LEVEL, PANEL_CURRENT,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 887,
		XV_Y, 2,
		PANEL_CHOICE_NCOLS, 2,
		PANEL_LAYOUT, PANEL_HORIZONTAL,
		PANEL_NOTIFY_PROC, l_call_100mV,
		PANEL_CHOICE_STRINGS,
			"20 uV",
			"25 uV",
			"50 uV",
			"75 uV",
			"100 uV",
			"125 uV",
			"150 uV",
			"200 uV",
			"250 uV",
			"500 uV",
			"750 uV",
			"1 mV",
			"2 mV",
			"5 mV",
			NULL,
		PANEL_DEFAULT_VALUE, 4,
		PANEL_VALUE, 4,
		NULL);
	return obj;
}

//
// Create object `l_b_Mark' in the specified instance.
//
Xv_opaque
sem_0_l_bw_objects::l_b_Mark_create(Xv_opaque owner)
{
	extern void		l_call_Mark(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 4,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 45,
		PANEL_LABEL_STRING, "Marker",
		PANEL_NOTIFY_PROC, l_call_Mark,
		NULL);
	return obj;
}

//
// Create object `l_b_Subtr' in the specified instance.
//
Xv_opaque
sem_0_l_bw_objects::l_b_Subtr_create(Xv_opaque owner)
{
	extern void		l_call_Subtr(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 182,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 55,
		PANEL_LABEL_STRING, "Subtr",
		PANEL_NOTIFY_PROC, l_call_Subtr,
		NULL);
	return obj;
}

//
// Create object `l_b_OvrApp' in the specified instance.
//
Xv_opaque
sem_0_l_bw_objects::l_b_OvrApp_create(Xv_opaque owner)
{
	extern void		l_call_OvrApp(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 316,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 58,
		PANEL_LABEL_STRING, "OvrApp",
		PANEL_NOTIFY_PROC, l_call_OvrApp,
		NULL);
	return obj;
}

//
// Create object `l_b_OvrLds_menu' in the specified instance.
//
Xv_opaque
sem_0_l_bw_objects::l_b_OvrLds_menu_create(Xv_opaque owner)
{
	extern void		l_call_menu_OvrLds(Panel_item, Event *);
	extern Xv_opaque	sem_0_l_menu_OvrLds_create(caddr_t, Xv_opaque);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 396,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 50,
		PANEL_LABEL_STRING, "OvrLds",
		PANEL_ITEM_MENU, sem_0_l_menu_OvrLds_create((caddr_t) this, l_bw),
		PANEL_NOTIFY_PROC, l_call_menu_OvrLds,
		NULL);
	return obj;
}

//
// Create object `l_c_line1' in the specified instance.
//
Xv_opaque
sem_0_l_bw_objects::l_c_line1_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 0,
		XV_Y, (int)xv_get(l_c_line00, XV_Y) +
		      (int)xv_get(l_c_line00, XV_HEIGHT) + 2,
		XV_WIDTH, WIN_EXTEND_TO_EDGE,
		XV_HEIGHT, 26,
		WIN_BORDER, TRUE,
		NULL);
	return obj;
}

//
// Create object `l_b_Exm' in the specified instance.
//
Xv_opaque
sem_0_l_bw_objects::l_b_Exm_create(Xv_opaque owner)
{
	extern void		l_call_Exm(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 442,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 30,
		PANEL_LABEL_STRING, "Exm",
		PANEL_NOTIFY_PROC, l_call_Exm,
		NULL);
	return obj;
}

//
// Create object `l_b_ConsLR' in the specified instance.
//
Xv_opaque
sem_0_l_bw_objects::l_b_ConsLR_create(Xv_opaque owner)
{
	extern void		l_call_ConsLR(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 885,
		XV_Y, 4,
		PANEL_LABEL_STRING, "ConsLR",
		PANEL_NOTIFY_PROC, l_call_ConsLR,
		NULL);
	return obj;
}

//
// Create object `l_cp' in the specified instance.
//
Xv_opaque
sem_0_l_bw_objects::l_cp_create(Xv_opaque owner)
{
	extern Notify_value	sem_0_l_bw_l_cp_event_callback(Xv_window, Event *, Notify_arg, Notify_event_type);
	extern void	l_ini_lcp(Canvas, Xv_window, Display *, Window, Xv_xrectlist *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, CANVAS,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 0,
		XV_Y, (int)xv_get(l_c_line1, XV_Y) +
		      (int)xv_get(l_c_line1, XV_HEIGHT) + 2,
		XV_WIDTH, WIN_EXTEND_TO_EDGE,
		XV_HEIGHT, WIN_EXTEND_TO_EDGE,
		CANVAS_REPAINT_PROC, l_ini_lcp,
		CANVAS_X_PAINT_WINDOW, TRUE,
		NULL);
	xv_set(canvas_paint_window(obj), WIN_CONSUME_EVENTS,
		WIN_MOUSE_BUTTONS,
		NULL, NULL);
	notify_interpose_event_func(canvas_paint_window(obj),
		(Notify_func) sem_0_l_bw_l_cp_event_callback, NOTIFY_SAFE);
	//
	// This line is here for backwards compatibility. It will be
	// removed for the next release.
	//
	xv_set(canvas_paint_window(obj), XV_KEY_DATA, INSTANCE, this, NULL);
	return obj;
}

//
// Initialize an instance of object `l_bw1'.
//
void
sem_0_l_bw1_objects::objects_initialize(Xv_opaque owner)
{
	l_bw1 = l_bw1_create(owner);
	l_c_line2 = l_c_line2_create(l_bw1);
	l_b_shift_ll1 = l_b_shift_ll1_create(l_c_line2);
	l_b_shift_l1 = l_b_shift_l1_create(l_c_line2);
	l_b_shift_r1 = l_b_shift_r1_create(l_c_line2);
	l_b_shift_rr1 = l_b_shift_rr1_create(l_c_line2);
	l_c_line3 = l_c_line3_create(l_bw1);
	l_ss_HRate1 = l_ss_HRate1_create(l_c_line3);
	l_ss_12min1 = l_ss_12min1_create(l_c_line3);
	l_ss_100mV1 = l_ss_100mV1_create(l_c_line3);
	l_b_Mark1 = l_b_Mark1_create(l_c_line3);
	l_b_Subtr1 = l_b_Subtr1_create(l_c_line3);
	l_b_OvrApp1 = l_b_OvrApp1_create(l_c_line3);
	l_b_OvrLds_menu1 = l_b_OvrLds_menu1_create(l_c_line3);
	l_c_line4 = l_c_line4_create(l_bw1);
	l_b_Exm1 = l_b_Exm1_create(l_c_line4);
	l_b_ConsLR1 = l_b_ConsLR1_create(l_c_line4);
	l_cp1 = l_cp1_create(l_bw1);
}

//
// Create object `l_bw1' in the specified instance.
//
Xv_opaque
sem_0_l_bw1_objects::l_bw1_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, FRAME,
		XV_KEY_DATA, INSTANCE, this,
		XV_WIDTH, 1128,
		XV_HEIGHT, 235,
		XV_LABEL, "SEMIA  [Lead 1]",
		XV_SHOW, FALSE,
		FRAME_SHOW_FOOTER, FALSE,
		FRAME_SHOW_RESIZE_CORNER, FALSE,
		NULL);
	return obj;
}

//
// Create object `l_c_line2' in the specified instance.
//
Xv_opaque
sem_0_l_bw1_objects::l_c_line2_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 0,
		XV_Y, 0,
		XV_WIDTH, 158,
		XV_HEIGHT, 26,
		WIN_BORDER, TRUE,
		NULL);
	return obj;
}

//
// Create object `l_b_shift_ll1' in the specified instance.
//
Xv_opaque
sem_0_l_bw1_objects::l_b_shift_ll1_create(Xv_opaque owner)
{
	extern void		l_call_shift_ll1(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 1,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 18,
		PANEL_LABEL_STRING, "<<",
		PANEL_NOTIFY_PROC, l_call_shift_ll1,
		NULL);
	return obj;
}

//
// Create object `l_b_shift_l1' in the specified instance.
//
Xv_opaque
sem_0_l_bw1_objects::l_b_shift_l1_create(Xv_opaque owner)
{
	extern void		l_call_shift_l1(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 40,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 18,
		PANEL_LABEL_STRING, " <",
		PANEL_NOTIFY_PROC, l_call_shift_l1,
		NULL);
	return obj;
}

//
// Create object `l_b_shift_r1' in the specified instance.
//
Xv_opaque
sem_0_l_bw1_objects::l_b_shift_r1_create(Xv_opaque owner)
{
	extern void		l_call_shift_r1(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 80,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 18,
		PANEL_LABEL_STRING, " >",
		PANEL_NOTIFY_PROC, l_call_shift_r1,
		NULL);
	return obj;
}

//
// Create object `l_b_shift_rr1' in the specified instance.
//
Xv_opaque
sem_0_l_bw1_objects::l_b_shift_rr1_create(Xv_opaque owner)
{
	extern void		l_call_shift_rr1(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 120,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 18,
		PANEL_LABEL_STRING, ">>",
		PANEL_NOTIFY_PROC, l_call_shift_rr1,
		NULL);
	return obj;
}

//
// Create object `l_c_line3' in the specified instance.
//
Xv_opaque
sem_0_l_bw1_objects::l_c_line3_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, (int)xv_get(l_c_line2, XV_X) +
		      (int)xv_get(l_c_line2, XV_WIDTH) + 2,
		XV_Y, 0,
		XV_WIDTH, WIN_EXTEND_TO_EDGE,
		XV_HEIGHT, 26,
		WIN_BORDER, TRUE,
		NULL);
	return obj;
}

//
// Create object `l_ss_HRate1' in the specified instance.
//
Xv_opaque
sem_0_l_bw1_objects::l_ss_HRate1_create(Xv_opaque owner)
{
	extern void		l_call_HRate1(Panel_item, int, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_CHOICE, PANEL_DISPLAY_LEVEL, PANEL_CURRENT,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 630,
		XV_Y, 2,
		PANEL_CHOICE_NCOLS, 1,
		PANEL_LAYOUT, PANEL_HORIZONTAL,
		PANEL_NOTIFY_PROC, l_call_HRate1,
		PANEL_CHOICE_STRINGS,
			"HRate",
			"HR Raw",
			"ST Fine",
			"STsl Fine",
			"STsl Raw",
			"Episodes",
			"Hide HR",
			NULL,
		PANEL_DEFAULT_VALUE, 0,
		PANEL_VALUE, 0,
		NULL);
	return obj;
}

//
// Create object `l_ss_12min1' in the specified instance.
//
Xv_opaque
sem_0_l_bw1_objects::l_ss_12min1_create(Xv_opaque owner)
{
	extern void		l_call_12min1(Panel_item, int, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_CHOICE, PANEL_DISPLAY_LEVEL, PANEL_CURRENT,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 808,
		XV_Y, 2,
		PANEL_CHOICE_NCOLS, 2,
		PANEL_LAYOUT, PANEL_HORIZONTAL,
		PANEL_NOTIFY_PROC, l_call_12min1,
		PANEL_CHOICE_STRINGS,
			"1 min",
			"2 min",
			"3 min",
			"6 min",
			"9 min",
			"12 min",
			"24 min",
			"30 min",
			"1 h",
			"2 h",
			"4 h",
			"6 h",
			"12 h",
			"24 h",
			"48 h",
			"96 h",
			NULL,
		PANEL_DEFAULT_VALUE, 5,
		PANEL_VALUE, 5,
		NULL);
	return obj;
}

//
// Create object `l_ss_100mV1' in the specified instance.
//
Xv_opaque
sem_0_l_bw1_objects::l_ss_100mV1_create(Xv_opaque owner)
{
	extern void		l_call_100mV1(Panel_item, int, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_CHOICE, PANEL_DISPLAY_LEVEL, PANEL_CURRENT,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 887,
		XV_Y, 2,
		PANEL_CHOICE_NCOLS, 2,
		PANEL_LAYOUT, PANEL_HORIZONTAL,
		PANEL_NOTIFY_PROC, l_call_100mV1,
		PANEL_CHOICE_STRINGS,
			"20 uV",
			"25 uV",
			"50 uV",
			"75 uV",
			"100 uV",
			"125 uV",
			"150 uV",
			"200 uV",
			"250 uV",
			"500 uV",
			"750 uV",
			"1 mV",
			"2 mV",
			"5 mV",
			NULL,
		PANEL_DEFAULT_VALUE, 4,
		PANEL_VALUE, 4,
		NULL);
	return obj;
}

//
// Create object `l_b_Mark1' in the specified instance.
//
Xv_opaque
sem_0_l_bw1_objects::l_b_Mark1_create(Xv_opaque owner)
{
	extern void		l_call_Mark1(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 4,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 45,
		PANEL_LABEL_STRING, "Marker",
		PANEL_NOTIFY_PROC, l_call_Mark1,
		NULL);
	return obj;
}

//
// Create object `l_b_Subtr1' in the specified instance.
//
Xv_opaque
sem_0_l_bw1_objects::l_b_Subtr1_create(Xv_opaque owner)
{
	extern void		l_call_Subtr1(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 182,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 55,
		PANEL_LABEL_STRING, "Subtr",
		PANEL_NOTIFY_PROC, l_call_Subtr1,
		NULL);
	return obj;
}

//
// Create object `l_b_OvrApp1' in the specified instance.
//
Xv_opaque
sem_0_l_bw1_objects::l_b_OvrApp1_create(Xv_opaque owner)
{
	extern void		l_call_OvrApp1(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 316,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 58,
		PANEL_LABEL_STRING, "OvrApp",
		PANEL_NOTIFY_PROC, l_call_OvrApp1,
		NULL);
	return obj;
}

//
// Create object `l_b_OvrLds_menu1' in the specified instance.
//
Xv_opaque
sem_0_l_bw1_objects::l_b_OvrLds_menu1_create(Xv_opaque owner)
{
	extern void		l_call_menu_OvrLds1(Panel_item, Event *);
	extern Xv_opaque	sem_0_l_menu_OvrLds1_create(caddr_t, Xv_opaque);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 396,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 50,
		PANEL_LABEL_STRING, "OvrLds",
		PANEL_ITEM_MENU, sem_0_l_menu_OvrLds1_create((caddr_t) this, l_bw1),
		PANEL_NOTIFY_PROC, l_call_menu_OvrLds1,
		NULL);
	return obj;
}

//
// Create object `l_c_line4' in the specified instance.
//
Xv_opaque
sem_0_l_bw1_objects::l_c_line4_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 0,
		XV_Y, (int)xv_get(l_c_line2, XV_Y) +
		      (int)xv_get(l_c_line2, XV_HEIGHT) + 2,
		XV_WIDTH, WIN_EXTEND_TO_EDGE,
		XV_HEIGHT, 26,
		WIN_BORDER, TRUE,
		NULL);
	return obj;
}

//
// Create object `l_b_Exm1' in the specified instance.
//
Xv_opaque
sem_0_l_bw1_objects::l_b_Exm1_create(Xv_opaque owner)
{
	extern void		l_call_Exm1(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 442,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 30,
		PANEL_LABEL_STRING, "Exm",
		PANEL_NOTIFY_PROC, l_call_Exm1,
		NULL);
	return obj;
}

//
// Create object `l_b_ConsLR1' in the specified instance.
//
Xv_opaque
sem_0_l_bw1_objects::l_b_ConsLR1_create(Xv_opaque owner)
{
	extern void		l_call_ConsLR1(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 885,
		XV_Y, 4,
		PANEL_LABEL_STRING, "ConsLR",
		PANEL_NOTIFY_PROC, l_call_ConsLR1,
		NULL);
	return obj;
}

//
// Create object `l_cp1' in the specified instance.
//
Xv_opaque
sem_0_l_bw1_objects::l_cp1_create(Xv_opaque owner)
{
	extern Notify_value	sem_0_l_bw1_l_cp1_event_callback(Xv_window, Event *, Notify_arg, Notify_event_type);
	extern void	l_ini_cp1b(Canvas, Xv_window, Display *, Window, Xv_xrectlist *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, CANVAS,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 0,
		XV_Y, (int)xv_get(l_c_line4, XV_Y) +
		      (int)xv_get(l_c_line4, XV_HEIGHT) + 2,
		XV_WIDTH, WIN_EXTEND_TO_EDGE,
		XV_HEIGHT, WIN_EXTEND_TO_EDGE,
		CANVAS_REPAINT_PROC, l_ini_cp1b,
		CANVAS_X_PAINT_WINDOW, TRUE,
		NULL);
	xv_set(canvas_paint_window(obj), WIN_CONSUME_EVENTS,
		WIN_MOUSE_BUTTONS,
		NULL, NULL);
	notify_interpose_event_func(canvas_paint_window(obj),
		(Notify_func) sem_0_l_bw1_l_cp1_event_callback, NOTIFY_SAFE);
	//
	// This line is here for backwards compatibility. It will be
	// removed for the next release.
	//
	xv_set(canvas_paint_window(obj), XV_KEY_DATA, INSTANCE, this, NULL);
	return obj;
}

//
// Initialize an instance of object `l_bw2'.
//
void
sem_0_l_bw2_objects::objects_initialize(Xv_opaque owner)
{
	l_bw2 = l_bw2_create(owner);
	l_c_line5 = l_c_line5_create(l_bw2);
	l_b_shift_ll2 = l_b_shift_ll2_create(l_c_line5);
	l_b_shift_l2 = l_b_shift_l2_create(l_c_line5);
	l_b_shift_r2 = l_b_shift_r2_create(l_c_line5);
	l_b_shift_rr2 = l_b_shift_rr2_create(l_c_line5);
	l_c_line6 = l_c_line6_create(l_bw2);
	l_ss_HRate2 = l_ss_HRate2_create(l_c_line6);
	l_ss_12min2 = l_ss_12min2_create(l_c_line6);
	l_ss_100mV2 = l_ss_100mV2_create(l_c_line6);
	l_b_Mark2 = l_b_Mark2_create(l_c_line6);
	l_b_Subtr2 = l_b_Subtr2_create(l_c_line6);
	l_b_OvrApp2 = l_b_OvrApp2_create(l_c_line6);
	l_b_OvrLds_menu2 = l_b_OvrLds_menu2_create(l_c_line6);
	l_c_line7 = l_c_line7_create(l_bw2);
	l_b_Exm2 = l_b_Exm2_create(l_c_line7);
	l_b_ConsLR2 = l_b_ConsLR2_create(l_c_line7);
	l_cp2 = l_cp2_create(l_bw2);
}

//
// Create object `l_bw2' in the specified instance.
//
Xv_opaque
sem_0_l_bw2_objects::l_bw2_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, FRAME,
		XV_KEY_DATA, INSTANCE, this,
		XV_WIDTH, 1128,
		XV_HEIGHT, 235,
		XV_LABEL, "SEMIA  [Lead 2]",
		XV_SHOW, FALSE,
		FRAME_SHOW_FOOTER, FALSE,
		FRAME_SHOW_RESIZE_CORNER, FALSE,
		NULL);
	return obj;
}

//
// Create object `l_c_line5' in the specified instance.
//
Xv_opaque
sem_0_l_bw2_objects::l_c_line5_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 0,
		XV_Y, 0,
		XV_WIDTH, 158,
		XV_HEIGHT, 26,
		WIN_BORDER, TRUE,
		NULL);
	return obj;
}

//
// Create object `l_b_shift_ll2' in the specified instance.
//
Xv_opaque
sem_0_l_bw2_objects::l_b_shift_ll2_create(Xv_opaque owner)
{
	extern void		l_call_shift_ll2(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 1,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 18,
		PANEL_LABEL_STRING, "<<",
		PANEL_NOTIFY_PROC, l_call_shift_ll2,
		NULL);
	return obj;
}

//
// Create object `l_b_shift_l2' in the specified instance.
//
Xv_opaque
sem_0_l_bw2_objects::l_b_shift_l2_create(Xv_opaque owner)
{
	extern void		l_call_shift_l2(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 40,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 18,
		PANEL_LABEL_STRING, " <",
		PANEL_NOTIFY_PROC, l_call_shift_l2,
		NULL);
	return obj;
}

//
// Create object `l_b_shift_r2' in the specified instance.
//
Xv_opaque
sem_0_l_bw2_objects::l_b_shift_r2_create(Xv_opaque owner)
{
	extern void		l_call_shift_r2(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 80,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 18,
		PANEL_LABEL_STRING, " >",
		PANEL_NOTIFY_PROC, l_call_shift_r2,
		NULL);
	return obj;
}

//
// Create object `l_b_shift_rr2' in the specified instance.
//
Xv_opaque
sem_0_l_bw2_objects::l_b_shift_rr2_create(Xv_opaque owner)
{
	extern void		l_call_shift_rr2(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 120,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 18,
		PANEL_LABEL_STRING, ">>",
		PANEL_NOTIFY_PROC, l_call_shift_rr2,
		NULL);
	return obj;
}

//
// Create object `l_c_line6' in the specified instance.
//
Xv_opaque
sem_0_l_bw2_objects::l_c_line6_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, (int)xv_get(l_c_line5, XV_X) +
		      (int)xv_get(l_c_line5, XV_WIDTH) + 2,
		XV_Y, 0,
		XV_WIDTH, WIN_EXTEND_TO_EDGE,
		XV_HEIGHT, 26,
		WIN_BORDER, TRUE,
		NULL);
	return obj;
}

//
// Create object `l_ss_HRate2' in the specified instance.
//
Xv_opaque
sem_0_l_bw2_objects::l_ss_HRate2_create(Xv_opaque owner)
{
	extern void		l_call_HRate2(Panel_item, int, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_CHOICE, PANEL_DISPLAY_LEVEL, PANEL_CURRENT,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 630,
		XV_Y, 2,
		PANEL_CHOICE_NCOLS, 1,
		PANEL_LAYOUT, PANEL_HORIZONTAL,
		PANEL_NOTIFY_PROC, l_call_HRate2,
		PANEL_CHOICE_STRINGS,
			"HRate",
			"HR Raw",
			"ST Fine",
			"STsl Fine",
			"STsl Raw",
			"Episodes",
			"Hide HR",
			NULL,
		PANEL_DEFAULT_VALUE, 0,
		PANEL_VALUE, 0,
		NULL);
	return obj;
}

//
// Create object `l_ss_12min2' in the specified instance.
//
Xv_opaque
sem_0_l_bw2_objects::l_ss_12min2_create(Xv_opaque owner)
{
	extern void		l_call_12min2(Panel_item, int, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_CHOICE, PANEL_DISPLAY_LEVEL, PANEL_CURRENT,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 808,
		XV_Y, 2,
		PANEL_CHOICE_NCOLS, 2,
		PANEL_LAYOUT, PANEL_HORIZONTAL,
		PANEL_NOTIFY_PROC, l_call_12min2,
		PANEL_CHOICE_STRINGS,
			"1 min",
			"2 min",
			"3 min",
			"6 min",
			"9 min",
			"12 min",
			"24 min",
			"30 min",
			"1 h",
			"2 h",
			"4 h",
			"6 h",
			"12 h",
			"24 h",
			"48 h",
			"96 h",
			NULL,
		PANEL_DEFAULT_VALUE, 5,
		PANEL_VALUE, 5,
		NULL);
	return obj;
}

//
// Create object `l_ss_100mV2' in the specified instance.
//
Xv_opaque
sem_0_l_bw2_objects::l_ss_100mV2_create(Xv_opaque owner)
{
	extern void		l_call_100mV2(Panel_item, int, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_CHOICE, PANEL_DISPLAY_LEVEL, PANEL_CURRENT,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 887,
		XV_Y, 2,
		PANEL_CHOICE_NCOLS, 2,
		PANEL_LAYOUT, PANEL_HORIZONTAL,
		PANEL_NOTIFY_PROC, l_call_100mV2,
		PANEL_CHOICE_STRINGS,
			"20 uV",
			"25 uV",
			"50 uV",
			"75 uV",
			"100 uV",
			"125 uV",
			"150 uV",
			"200 uV",
			"250 uV",
			"500 uV",
			"750 uV",
			"1 mV",
			"2 mV",
			"5 mV",
			NULL,
		PANEL_DEFAULT_VALUE, 4,
		PANEL_VALUE, 4,
		NULL);
	return obj;
}

//
// Create object `l_b_Mark2' in the specified instance.
//
Xv_opaque
sem_0_l_bw2_objects::l_b_Mark2_create(Xv_opaque owner)
{
	extern void		l_call_Mark2(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 4,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 45,
		PANEL_LABEL_STRING, "Marker",
		PANEL_NOTIFY_PROC, l_call_Mark2,
		NULL);
	return obj;
}

//
// Create object `l_b_Subtr2' in the specified instance.
//
Xv_opaque
sem_0_l_bw2_objects::l_b_Subtr2_create(Xv_opaque owner)
{
	extern void		l_call_Subtr2(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 182,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 55,
		PANEL_LABEL_STRING, "Subtr",
		PANEL_NOTIFY_PROC, l_call_Subtr2,
		NULL);
	return obj;
}

//
// Create object `l_b_OvrApp2' in the specified instance.
//
Xv_opaque
sem_0_l_bw2_objects::l_b_OvrApp2_create(Xv_opaque owner)
{
	extern void		l_call_OvrApp2(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 316,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 58,
		PANEL_LABEL_STRING, "OvrApp",
		PANEL_NOTIFY_PROC, l_call_OvrApp2,
		NULL);
	return obj;
}

//
// Create object `l_b_OvrLds_menu2' in the specified instance.
//
Xv_opaque
sem_0_l_bw2_objects::l_b_OvrLds_menu2_create(Xv_opaque owner)
{
	extern void		l_call_menu_OvrLds2(Panel_item, Event *);
	extern Xv_opaque	sem_0_l_menu_OvrLds2_create(caddr_t, Xv_opaque);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 396,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 50,
		PANEL_LABEL_STRING, "OvrLds",
		PANEL_ITEM_MENU, sem_0_l_menu_OvrLds2_create((caddr_t) this, l_bw2),
		PANEL_NOTIFY_PROC, l_call_menu_OvrLds2,
		NULL);
	return obj;
}

//
// Create object `l_c_line7' in the specified instance.
//
Xv_opaque
sem_0_l_bw2_objects::l_c_line7_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 0,
		XV_Y, (int)xv_get(l_c_line5, XV_Y) +
		      (int)xv_get(l_c_line5, XV_HEIGHT) + 2,
		XV_WIDTH, WIN_EXTEND_TO_EDGE,
		XV_HEIGHT, 26,
		WIN_BORDER, TRUE,
		NULL);
	return obj;
}

//
// Create object `l_b_Exm2' in the specified instance.
//
Xv_opaque
sem_0_l_bw2_objects::l_b_Exm2_create(Xv_opaque owner)
{
	extern void		l_call_Exm2(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 442,
		XV_Y, 4,
		PANEL_LABEL_WIDTH, 30,
		PANEL_LABEL_STRING, "Exm",
		PANEL_NOTIFY_PROC, l_call_Exm2,
		NULL);
	return obj;
}

//
// Create object `l_b_ConsLR2' in the specified instance.
//
Xv_opaque
sem_0_l_bw2_objects::l_b_ConsLR2_create(Xv_opaque owner)
{
	extern void		l_call_ConsLR2(Panel_item, Event *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, PANEL_BUTTON,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 885,
		XV_Y, 4,
		PANEL_LABEL_STRING, "ConsLR",
		PANEL_NOTIFY_PROC, l_call_ConsLR2,
		NULL);
	return obj;
}

//
// Create object `l_cp2' in the specified instance.
//
Xv_opaque
sem_0_l_bw2_objects::l_cp2_create(Xv_opaque owner)
{
	extern Notify_value	sem_0_l_bw2_l_cp2_event_callback(Xv_window, Event *, Notify_arg, Notify_event_type);
	extern void	l_ini_cp2b(Canvas, Xv_window, Display *, Window, Xv_xrectlist *);
	Xv_opaque	obj;
	
	obj = xv_create(owner, CANVAS,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 0,
		XV_Y, (int)xv_get(l_c_line7, XV_Y) +
		      (int)xv_get(l_c_line7, XV_HEIGHT) + 2,
		XV_WIDTH, WIN_EXTEND_TO_EDGE,
		XV_HEIGHT, WIN_EXTEND_TO_EDGE,
		CANVAS_REPAINT_PROC, l_ini_cp2b,
		CANVAS_X_PAINT_WINDOW, TRUE,
		NULL);
	xv_set(canvas_paint_window(obj), WIN_CONSUME_EVENTS,
		WIN_MOUSE_BUTTONS,
		NULL, NULL);
	notify_interpose_event_func(canvas_paint_window(obj),
		(Notify_func) sem_0_l_bw2_l_cp2_event_callback, NOTIFY_SAFE);
	//
	// This line is here for backwards compatibility. It will be
	// removed for the next release.
	//
	xv_set(canvas_paint_window(obj), XV_KEY_DATA, INSTANCE, this, NULL);
	return obj;
}

//
// Initialize an instance of object `d_pw'.
//
void
sem_0_d_pw_objects::objects_initialize(Xv_opaque owner)
{
	d_pw = d_pw_create(owner);
	textpane_data = textpane_data_create(d_pw);
}

//
// Create object `d_pw' in the specified instance.
//
Xv_opaque
sem_0_d_pw_objects::d_pw_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, FRAME_CMD,
		XV_KEY_DATA, INSTANCE, this,
		XV_WIDTH, 612,
		XV_HEIGHT, 400,
		XV_LABEL, "SEMIA  Diagnostic Data",
		XV_SHOW, FALSE,
		FRAME_SHOW_FOOTER, FALSE,
		FRAME_SHOW_RESIZE_CORNER, TRUE,
		FRAME_CMD_PUSHPIN_IN, TRUE,
		NULL);
	xv_set(xv_get(obj, FRAME_CMD_PANEL), WIN_SHOW, FALSE, NULL);
	return obj;
}

//
// Create object `textpane_data' in the specified instance.
//
Xv_opaque
sem_0_d_pw_objects::textpane_data_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, TEXTSW,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 0,
		XV_Y, 0,
		XV_WIDTH, WIN_EXTEND_TO_EDGE,
		XV_HEIGHT, WIN_EXTEND_TO_EDGE,
		OPENWIN_SHOW_BORDERS, TRUE,
		NULL);
	return obj;
}

//
// Initialize an instance of object `c_pw'.
//
void
sem_0_c_pw_objects::objects_initialize(Xv_opaque owner)
{
	c_pw = c_pw_create(owner);
	textpane_numepis = textpane_numepis_create(c_pw);
}

//
// Create object `c_pw' in the specified instance.
//
Xv_opaque
sem_0_c_pw_objects::c_pw_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, FRAME_CMD,
		XV_KEY_DATA, INSTANCE, this,
		XV_WIDTH, 490,
		XV_HEIGHT, 512,
		XV_LABEL, "SEMIA  Numbers of ST Events",
		XV_SHOW, FALSE,
		FRAME_SHOW_FOOTER, FALSE,
		FRAME_SHOW_RESIZE_CORNER, TRUE,
		FRAME_CMD_PUSHPIN_IN, TRUE,
		NULL);
	xv_set(xv_get(obj, FRAME_CMD_PANEL), WIN_SHOW, FALSE, NULL);
	return obj;
}

//
// Create object `textpane_numepis' in the specified instance.
//
Xv_opaque
sem_0_c_pw_objects::textpane_numepis_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, TEXTSW,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 0,
		XV_Y, 0,
		XV_WIDTH, WIN_EXTEND_TO_EDGE,
		XV_HEIGHT, WIN_EXTEND_TO_EDGE,
		OPENWIN_SHOW_BORDERS, TRUE,
		NULL);
	return obj;
}

//
// Initialize an instance of object `h_pw'.
//
void
sem_0_h_pw_objects::objects_initialize(Xv_opaque owner)
{
	h_pw = h_pw_create(owner);
	textpane_help = textpane_help_create(h_pw);
}

//
// Create object `h_pw' in the specified instance.
//
Xv_opaque
sem_0_h_pw_objects::h_pw_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, FRAME_CMD,
		XV_KEY_DATA, INSTANCE, this,
		XV_WIDTH, 612,
		XV_HEIGHT, 512,
		XV_LABEL, "SEMIA  Help",
		XV_SHOW, FALSE,
		FRAME_SHOW_FOOTER, FALSE,
		FRAME_SHOW_RESIZE_CORNER, TRUE,
		FRAME_CMD_PUSHPIN_IN, TRUE,
		NULL);
	xv_set(xv_get(obj, FRAME_CMD_PANEL), WIN_SHOW, FALSE, NULL);
	return obj;
}

//
// Create object `textpane_help' in the specified instance.
//
Xv_opaque
sem_0_h_pw_objects::textpane_help_create(Xv_opaque owner)
{
	Xv_opaque	obj;
	
	obj = xv_create(owner, TEXTSW,
		XV_KEY_DATA, INSTANCE, this,
		XV_X, 0,
		XV_Y, 0,
		XV_WIDTH, WIN_EXTEND_TO_EDGE,
		XV_HEIGHT, WIN_EXTEND_TO_EDGE,
		OPENWIN_SHOW_BORDERS, TRUE,
		NULL);
	return obj;
}
//=========================================================================================================
