//=========================================================================================================
//
// semia_stubs.cc
//

#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/X.h>
#include <X11/Xatom.h>

#include <sys/param.h>
#include <sys/types.h>

#include <xview/xview.h>
#include <xview/panel.h>
#define _OTHER_TEXTSW_FUNCTIONS
#include <xview/textsw.h>
#include <xview/xv_xrect.h>
#include <xview/frame.h>
#include <xview/notice.h>

#include "semia_ui.h"

//Work with WFDB library
#include <wfdb/wfdb.h>
#include <wfdb/ecgmap.h>
#include <wfdb/ecgcodes.h>

//How to plot time series
#define PLOT_ALL   FALSE

//Length of one screen in samples if Fsamp is 250 samples/sec
//Lengths                           21600000 - 24 hours
//                                  43200000 - 48 hours
//Length of fine buffers if Fsamp is 250 samples/sec    (LEN_BUFF_F)
//Lengths                  187200  (190000)  - 26 hours
//                         345600  (370000)  - 48 hours
//Length of raw buffers if Fsamp is 250 samples/sec     (LEN_BUFF_R)
//Lengths                   46800   (47000)  - 26 hours
//                          86400   (90000)  - 48 hours
#define LEN_BUFF_F 224000 // fine data buff length
#define LEN_BUFF_R 86400  // raw data buff length

//
#define STAMPL 200            // 200 units = 1000 uV
#define FSAMP 250             // 250 msec
#define auto_ampl_1 10.0      // 50  uV
#define BORDER_SEP_CLICK 120  // Samples at the bottom of lead window
#define ALL_ONE FALSE         // true = copy lead0 > lead1 > lead2
#define LEN_BUFF_D 37626      // 5 min / 2 = 150 * 1000 msec = 150 * 1000 / (1000/FSAMP) + 125 (avr /2 ) + 1 ( center )
#define LEN_BUFF_D_A 251      // average window = 1000 msec

#define OR ||

void d_ini_cp_b(Panel_item, Event *);
void l_ini_cp1_b(Panel_item, Event *);
void k_ini_cp_b(Panel_item, Event *);
void l_ini_cp2_b(Panel_item, Event *);
void main_open_init(Panel_item, Event *);
void init_counts(Panel_item, Event *);
void init_diagdata(Panel_item, Event *);
void show_diagdata(Panel_item, Event *);
void show_counts(Panel_item, Event *);
void init_help(Panel_item, Event *);
void show_help(Panel_item, Event *);

//Global variables for drawing
Display  *l_b_display, *l_b1_display, *l_b2_display, *d_b_display, *k_b_display, *my_display;
Window   l_b_window, l_b1_window, l_b2_window, d_b_window, k_b_window, my_window;
GC       gcLead0, gcLead1, gcLead2, gcdata, gckoeff, my_gc;
unsigned long background, foreground;
Colormap cmap;
XColor   col, unused;

//Global data
int set_line_width=1;
int set_marker=1; 
char set_color1[30]="green";
char set_color2[30]="blue";
char set_color3[30]="red";
char set_color4[30]="red";
char set_color5[30]="red";
char set_color6[30]="red";
//Other
char set_color7[30]="LightCyan1";
char set_color8[30]="yellow";

long click_ST80_0 = 0, click_STsb_0 = 0, click_ST80_f0 = 0;
long click_ST80_1 = 0, click_STsb_1 = 0, click_ST80_f1 = 0;
long click_ST80_2 = 0, click_STsb_2 = 0, click_ST80_f2 = 0;

Bool auto_save = FALSE;     
int  auto_save_counter = 0;

Bool fast0_center = FALSE; 
Bool fast1_center = FALSE; 
Bool fast2_center = FALSE; 
Bool fast0_right  = FALSE; 
Bool fast1_right  = FALSE; 
Bool fast2_right  = FALSE; 

char message[60], message1[60], message2[60], message3[60];
char pr_buff[80];

//Input data variables
char inp_rec_name[80];

WFDB_Siginfo *siarray;            
long nsig;
WFDB_Siginfo DB_s[WFDB_MAXSIG];
WFDB_Sample v_sample[3];
FILE *dataFileDescriptor = NULL;    
long buff[5][15000];

//Save
FILE *file_save=NULL;
FILE *flinsave=NULL;
char save_name[20];
char save_name_lin[20];
Bool final_save = FALSE;

//Program status
Bool status_manual_mode=TRUE, status_unsubtracted=TRUE, status_consider_localref=TRUE;
Bool status_manual_mode1=TRUE, status_unsubtracted1=TRUE, status_consider_localref1=TRUE;
Bool status_manual_mode2=TRUE, status_unsubtracted2=TRUE, status_consider_localref2=TRUE;

//Diagram data
long time_scale_0=720, time_scale_1=720, time_scale_2=720;  // 720 = 12 min 
long time_scale_d=6;                                        // 6 = 6sec
int  data_scale=6;                                          // 6 = 6 sec
long data_tick=160;
double data_grid_tick = 25.6;                               // 6 sec / 960 * 25.6 = 160 msec
long scale_time_tick=60;                                    // 720 / 12 = 60
long diagram_time_begin_lead, diagram_time_end_lead;
long time_begin_lead, time_end_lead;
long ampl_0=100, ampl_1=100, ampl_2=100;                    // 100 = 100uV

long ampl_d=1000;
long auto_ampl_2[3];
float ampl_c=1.0;

long index_0, index_0_b, index_0_e;
long raw_last_index, fin_last_index;
long raw_display_begin, raw_display_end, fin_display_begin, fin_display_end;
Bool ovr0_l1=FALSE,  ovr0_l2=FALSE;
Bool ovr1_l0=FALSE,  ovr1_l2=FALSE;
Bool ovr2_l1=FALSE,  ovr2_l0=FALSE;
Bool ovr0_app = FALSE, ovr1_app = FALSE, ovr2_app = FALSE;
Bool lead1_data=FALSE,  lead2_data=FALSE; 
Bool KL_coefficents=TRUE;
Bool ovr_coef=FALSE;

Bool allow_l0;
Bool allow_l1, allow_l2;
Bool x_lead =FALSE;

short Lead0_operation;
short Lead1_operation;
short Lead2_operation;

Bool change_atribute0=FALSE; 
Bool change_atribute1=FALSE;
Bool change_atribute2=FALSE;
Bool how0=TRUE;
Bool how1=TRUE;
Bool how2=TRUE;

char ref_code[5];
int Data_lead=0;
Bool data_ovr_l0, data_ovr_l1, data_ovr_l2;
Bool data_ovrly_shift;

long data_mstime_index, reference_mstime_index;

long L_buff_M[6][LEN_BUFF_D], R_buff_M[6][LEN_BUFF_D],A_buff_M[6][LEN_BUFF_D_A];
long L_buff_R[6][LEN_BUFF_D], R_buff_R[6][LEN_BUFF_D],A_buff_R[6][LEN_BUFF_D_A];

Bool global_set;
Bool last_set_all; 

int current_iso_m, current_j_m;
long current_nl, current_nr, current_mean_smp;

long ref_iso, ref_j, ref_dj;

long current_average_beat_time = 0;
long d_avrg_index = 0;
long current_average_window_index;
long current_average_window_time;

short data_ovrly=1;
Bool data_ovr_ref=FALSE;
Bool repeat_set =FALSE;
Bool repeat_set1=FALSE;
Bool repeat_set2=FALSE;

class def_click
{ public:
   Bool first;
   long x,y,  time_index, raw, raw_l,raw_r, fine, fine_l, fine_r;
};

def_click click_l0, click_c0, click_r0;
def_click click_l1, click_c1, click_r1;
def_click click_l2, click_c2, click_r2;
def_click click_c;

class button_lead_status_def
{
public:
  Bool Mark,Dmy, Auto, Subtr, Cmpt, OvrApp, OvrLds, GlR, SetLB, SetLE, DelLI, Isc, Rate_r, Cnd, AxS,Exm, Atr, Move, Del, DelA, ChAtr,ChAtrA, ConsLR, LcRef, Cancel, Rpt;
  short Auto_s,Subtr_s,OvrApp_s,ConsLR_s;
  void copy_button_status(  button_lead_status_def source);
};

button_lead_status_def Lead0_buttons, Lead0_op_begin_status;
button_lead_status_def Lead1_buttons, Lead1_op_begin_status;
button_lead_status_def Lead2_buttons, Lead2_op_begin_status;

class data_fin_def
{
   public:
      long index;
      int HR;
      float l0_ST80,l0_ST20,l1_ST80,l1_ST20,l2_ST80,l2_ST20;
      int  STk1,STk2,STk3,STk4,STk5,
            ST_f,
            QRSk1,QRSk2,QRSk3,QRSk4,QRSk5,
            QRS_f,
            nPB, nPE, nISO, nQ, nJ, nTB, nTX, nTE;
      float lin_v[3], sub_v[3];

   void Init(void);
   void Insert(data_fin_def value);
};

data_fin_def data_fin[LEN_BUFF_F];
data_fin_def data_raw[LEN_BUFF_R];

class lead_plot_button_status
{
public:
  Bool HRate,HRRaw,STFine,STslFine,STslRaw,Episodes,HideHR,ISOJ,Mode9,Mode10,lead0,lead1,lead2,UnOvrly;
}; 

lead_plot_button_status lead0_plot_button_status;
lead_plot_button_status lead1_plot_button_status;
lead_plot_button_status lead2_plot_button_status;

class reference_def
{
   public:
      Bool set; 

      long raw_index, fine_index;
      int code1, code2;
      int lead, raw_HR, fine_HR;
      int  raw_ST80,raw_ST20, ST_sub, fine_ST80, fine_ST20, STd, ST80, STsl;
      int  nPB, nPE, nISO, nQ, nJ, nJ80, nTB, nTX, nTE, window, NL, NR, NS;
   void copy_ref(reference_def source);

};

reference_def global_ref[3], act_ref_data[3], Marker[3], references[3][5000], loc_interval_b[3], loc_interval_e[3];
long references_index[3];
long reference_act[3];  // last active reference - set or ex

class ref_use_def
{
public:
  Bool set, change;
  long typ; // 1 - global, 2 - local
  long index, lead;
};

ref_use_def act_reference[3];

void k_call_left(Xv_window, Event *, Notify_arg, Notify_event_type);
void k_call_center(Xv_window, Event *, Notify_arg, Notify_event_type);
void k_call_right(Xv_window, Event *, Notify_arg, Notify_event_type);
void d_call_left(Xv_window, Event *, Notify_arg, Notify_event_type);
void d_call_center(Xv_window, Event *, Notify_arg, Notify_event_type);
void d_call_right(Xv_window, Event *, Notify_arg, Notify_event_type);
void l_call_left(Xv_window, Event *, Notify_arg, Notify_event_type);
void l_call_center(Xv_window, Event *, Notify_arg, Notify_event_type);
void l_call_right(Xv_window, Event *, Notify_arg, Notify_event_type);
void l_call_left1(Xv_window, Event *, Notify_arg, Notify_event_type);
void l_call_center1(Xv_window, Event *, Notify_arg, Notify_event_type);
void l_call_right1(Xv_window, Event *, Notify_arg, Notify_event_type);
void l_call_left2(Xv_window, Event *, Notify_arg, Notify_event_type);
void l_call_center2(Xv_window, Event *, Notify_arg, Notify_event_type);
void l_call_right2(Xv_window, Event *, Notify_arg, Notify_event_type);
void l_ini_lcp_b(Panel_item, Event *);

void draw_grid_coeff(void);
void draw_ovrly_coeff(void);

void sub_op0_exec(void);
void sub_op1_exec(void);
void sub_op2_exec(void);

void insert_ref(int, reference_def, int, int);
void set_marker_l(int leadx);
void update_marker(int leadx,long cal);
void draw_grid_lead0(int leadx); 
void show_data(int leadx, Bool xx_lead, Bool xx_kl);

void data_new_r_read(void);
void get_average_M(void);
void get_average_R(void);
void set_buttons_lead1_setGR(void);
void set_buttons_lead1(void);
void set_buttons_lead2_setGR(void);
void set_buttons_lead2(void);
void set_buttons_lead0(void);

//Global object definitions.
sem_0_m_bw_objects	Sem_0_m_bw;
sem_0_k_bw_objects	Sem_0_k_bw;
sem_0_o_pw_objects	Sem_0_o_pw;
sem_0_q_pw_objects	Sem_0_q_pw;
sem_0_w_pw_objects	Sem_0_w_pw;
sem_0_d_bw_objects	Sem_0_d_bw;
sem_0_l_bw_objects	Sem_0_l_bw;
sem_0_l_bw1_objects	Sem_0_l_bw1;
sem_0_l_bw2_objects	Sem_0_l_bw2;
sem_0_d_pw_objects	Sem_0_d_pw;
sem_0_c_pw_objects	Sem_0_c_pw;
sem_0_h_pw_objects	Sem_0_h_pw;

//User functions =========================================================================================

//void (*textsw_default_notifyx)(Textsw textsw, Attr_avlist  attributes);
void myproc(Textsw textsw, Attr_avlist  attributes)
{
  int  pass_on = FALSE;
  Attr_avlist   attrs;
  for (attrs = attributes; *attrs; attrs = attr_next(attrs)) {
    //    switch ((Textsw_action)(*attrs)) {
    //    case TEXTSW_ACTION_TOOL_DESTROY:
      ATTR_CONSUME(*attrs);
      //      break;
      //    case TEXTSW_ACTION_TOOL_QUIT:
      //      ATTR_CONSUME(*attrs);
      //      break;
      //    defaults:
      pass_on = TRUE;
      //      break;
      //    }
  }
  if (pass_on) textsw_default_notify(textsw, attributes);
}

void reset_HR_lead0(int leadx)
{
	switch (leadx) {
          case 0:
	    lead0_plot_button_status.HRate=FALSE;
	    lead0_plot_button_status.HRRaw=FALSE;
	    lead0_plot_button_status.STFine=FALSE;
	    lead0_plot_button_status.STslFine=FALSE;
	    lead0_plot_button_status.STslRaw=FALSE;
	    lead0_plot_button_status.Episodes=FALSE;
	    lead0_plot_button_status.HideHR=FALSE;
	    lead0_plot_button_status.ISOJ=FALSE;
	    lead0_plot_button_status.Mode9=FALSE;
	    lead0_plot_button_status.Mode10=FALSE;
	    break;
          case 1: 
	    lead1_plot_button_status.HRate=FALSE;
	    lead1_plot_button_status.HRRaw=FALSE;
	    lead1_plot_button_status.STFine=FALSE;
	    lead1_plot_button_status.STslFine=FALSE;
	    lead1_plot_button_status.STslRaw=FALSE;
	    lead1_plot_button_status.Episodes=FALSE;
	    lead1_plot_button_status.HideHR=FALSE;
	    lead1_plot_button_status.ISOJ=FALSE;
	    lead1_plot_button_status.Mode9=FALSE;
	    lead1_plot_button_status.Mode10=FALSE;
	    break;
	  case 2:
	    lead2_plot_button_status.HRate=FALSE;
	    lead2_plot_button_status.HRRaw=FALSE;
	    lead2_plot_button_status.STFine=FALSE;
	    lead2_plot_button_status.STslFine=FALSE;
	    lead2_plot_button_status.STslRaw=FALSE;
	    lead2_plot_button_status.Episodes=FALSE;
	    lead2_plot_button_status.HideHR=FALSE;
	    lead2_plot_button_status.ISOJ=FALSE;
	    lead2_plot_button_status.Mode9=FALSE;
	    lead2_plot_button_status.Mode10=FALSE;
	    break;
	} // end switch
}

void data_fin_def::Init(void)
{
      index=0;
      HR=0;
      l0_ST80=0;l0_ST20=0;
      l1_ST80=0;l1_ST20=0;
      l2_ST80=0;l2_ST20=0;
      STk1=0;STk2=0;STk3=0;STk4=0;STk5=0;
      ST_f=0;
      QRSk1=0;QRSk2=0;QRSk3=0;QRSk4=0;QRSk5=0;
      QRS_f=0;
      nPB=0; nPE=0; nISO=0; nQ=0; nJ=0; nTB=0; nTX=0; nTE=0;
      lin_v[0]=0.0;lin_v[1]=0.0;lin_v[2]=0.0; 
      sub_v[0]=0.0;  sub_v[1]=0.0;sub_v[2]=0.0;
} // data_fin_def::Init

void data_fin_def::Insert(data_fin_def value)
{
      index=value.index;
      HR=value.HR;
      l0_ST80=value.l0_ST80;l0_ST20=value.l0_ST20;
      l1_ST80=value.l1_ST80;l1_ST20=value.l1_ST20;
      l2_ST80=value.l2_ST80;l2_ST20=value.l2_ST20;
      STk1=value.STk1;STk2=value.STk2;STk3=value.STk3;STk4=value.STk4;STk5=value.STk5;
      ST_f=value.ST_f;
      QRSk1=value.QRSk1;QRSk2=value.QRSk2;QRSk3=value.QRSk3;QRSk4=value.QRSk4;QRSk5=value.QRSk5;
      QRS_f=value.QRS_f;
      nPB=value.nPB; nPE=value.nPE; nISO=value.nISO; nQ=value.nQ;
      nJ=value.nJ; nTB=value.nTB; nTX=value.nTX; nTE=value.nTE;
} // data_fin_def::Insert

void reference_def::copy_ref(reference_def source)
{
      set = source.set;
      raw_index=source.raw_index;
      fine_index=source.fine_index;
      code1= source.code1;
      code2 =source.code2;
      lead=source.lead;
      raw_HR=source.raw_HR; fine_HR=source.fine_HR;
      raw_ST80=source.raw_ST80; raw_ST20 = source.raw_ST20; 
      fine_ST80 = source.fine_ST80; fine_ST20= source.fine_ST20;
      STd = source.STd; STsl = source.STsl;
      ST80=source.ST80;
      ST_sub=source.ST_sub;
      nPB = source.nPB;  nPE = source.nPE;
      nISO = source.nISO;  nQ = source.nQ ;  nJ =  source.nJ;  nJ80 =  source.nJ80; 
      nTB =  source.nTB;   nTX =  source.nTX;   nTE =  source.nTE;
      window =  source.window ;   NL= source.NL; NR =  source.NR;   NS =  source.NS;
} // reference_def::copy(reference_def source, dest) 

void insert_ref(int leadx, reference_def source,int code1x, int code2x)
{
 long i, j;
 long ref_index;

   references_index[leadx]++; ref_index=references_index[leadx]; 
   for (i=0; (i < ref_index) && ( references[leadx][i].raw_index < source.raw_index ) ; i++);
   if ( i < ref_index ) { for (j=ref_index; j > i; j--) references[leadx][j].copy_ref(references[leadx][j-1]);}
   references[leadx][i].copy_ref(source);
   references[leadx][i].code1=code1x;
   references[leadx][i].code2=code2x;
   reference_act[leadx]=i; 
}  // end insert_ref

void button_lead_status_def::copy_button_status(  button_lead_status_def source)
{   
   Auto_s=source.Auto_s;  Subtr_s=source.Subtr_s;  OvrApp_s= source.OvrApp_s; ConsLR_s= source.ConsLR_s;
   Mark = source.Mark; Dmy = source.Dmy; Auto = source.Auto; Subtr = source.Subtr; Cmpt = source.Cmpt; 
   OvrApp = source.OvrApp; OvrLds = source.OvrLds; GlR = source.GlR; SetLB = source.SetLB; SetLE = source.SetLE; 
   DelLI = source.DelLI; Isc = source.Isc; Rate_r = source.Rate_r; Cnd= source.Cnd; 
   AxS = source.AxS; Exm = source.Exm; Atr = source.Atr; Move = source.Move; Del = source.Del; DelA = source.DelA;  
   ChAtr = source.ChAtr; ChAtrA = source.ChAtrA; ConsLR = source.ConsLR; LcRef =source.LcRef;
   Cancel=source.Cancel; Rpt= source.Rpt;
} // end copy_button_status

void warning_message(int lines)
{
	  xv_set(Sem_0_w_pw.w_m_message1, PANEL_LABEL_STRING,message1, NULL);
	  if ( lines < 2 ) strcpy(message2,"");
	  if ( lines < 3) strcpy(message3, "");
	  xv_set(Sem_0_w_pw.w_m_message2, PANEL_LABEL_STRING,message2, NULL);
	  xv_set(Sem_0_w_pw.w_m_message3, PANEL_LABEL_STRING,message3, NULL);
	   if (xv_get(Sem_0_w_pw.w_pw, FRAME_CLOSED)) 
	     xv_set(Sem_0_w_pw.w_pw, FRAME_CLOSED, FALSE, NULL);
	   xv_set(Sem_0_w_pw.w_pw, FRAME_CMD_PUSHPIN_IN, FALSE, NULL);
	   xv_set(Sem_0_w_pw.w_pw, XV_SHOW, TRUE, NULL);
} // end warnig_message

long Round(double value)
{
   // Plain vanila round function
   if(value >= 0.0)
      return(long(value + 0.5));
   else
      return(long(value - 0.5));   
}

long TimeToIndex(long time)
{
   return((long)(time * double(FSAMP)));
}

void TimeToHoursMinSec(long time, long *hou, long *min, long *sec, long *hou_l)
{
   long timeTemp;
   
   timeTemp = time;
   timeTemp = long(timeTemp / 60);
   timeTemp = timeTemp * 60;
   
   *sec = time - timeTemp;
   
   time = long(time / 60);
   timeTemp = time;
   timeTemp = long(timeTemp / 60);
   timeTemp = timeTemp * 60;
   
   *min = time - timeTemp;
   
   time = long(time / 60);
   *hou_l = time;

   timeTemp = time;
   timeTemp = long(timeTemp / 24);
   timeTemp = timeTemp * 24;
   
   *hou = time - timeTemp;
}

long IndexToTime(long idx)
{
   return(long(double(idx) / FSAMP));
}

long Coor_x_l0(long index)
{
  long timex;
  
  timex=long(double(index)*1000.0 / FSAMP);
  return ((long)(160 + double(timex)*960.0 /(double) time_scale_0/1000.0));
} // coor_x_l0

long Coor_y_l0(float value)
{
  return(60-Round(double(value)*20000.0/STAMPL/ampl_0)); // 20000.0 = 20 pix  x 1000 uV
}  // coor_y_l0

long Coor_y_l1(float value)
{
  return(60-Round(double(value)*20000.0/STAMPL/ampl_1)); // 20000.0 = 20 pix  x 1000 uV
}  // coor_y_l1

long Coor_y_l2(float value)
{
  return(60-Round(double(value)*20000.0/STAMPL/ampl_2)); // 20000.0 = 20 pix  x 1000 uV
}  // coor_y_l2

long Coor_x_data(long index)
{
  long timex;
  
  timex=long(double(index) * 1000.0 / FSAMP);
  return ((long)(160 + double(timex)*960.0 /(double) data_scale / 1000.0));
} // coor_x_l0

long Coor_y_data_M(float value)
{
  return(270-Round(double(value)*40000.0/STAMPL/ampl_d)); // 20000.0 = 20 pix  x 1000 uV
}  // coor_y_l0

void reset_global_reference(void) {
int l;
  
  for (l=0; l < 3; l++ ) {
      global_ref[l].set=FALSE;
      global_ref[l].raw_index=0;
      global_ref[l].fine_index=0;
      global_ref[l].code1= 0;
      global_ref[l].code2 =-1;
      global_ref[l].lead=l;
      global_ref[l].raw_HR=0; global_ref[l].fine_HR=0;
      global_ref[l].raw_ST80=0; global_ref[l].raw_ST20 = 0; 
      global_ref[l].fine_ST80 = 0; global_ref[l].fine_ST20= 0;
      global_ref[l].STd = 0; global_ref[l].STsl = 0; global_ref[l].ST_sub = 0;
      global_ref[l].nPB = 0;  global_ref[l].nPE = 0; global_ref[l].ST80 = 0;
      global_ref[l].nISO = 0;  global_ref[l].nQ =0 ;  global_ref[l].nJ = 0;  global_ref[l].nJ80 = 0; 
      global_ref[l].nTB = 0;   global_ref[l].nTX = 0;   global_ref[l].nTE = 0;
      global_ref[l].window = 0;   global_ref[l].NL=0; global_ref[l].NR = 0;  global_ref[l].NS = 0;

      act_ref_data[l].copy_ref(global_ref[l]);
     
      references_index[l]=-1;
      reference_act[l]=-1;
      loc_interval_b[l].set=FALSE;
      loc_interval_e[l].set=FALSE;
  }
  global_set=FALSE;
} // end  reset_global_reference

float raw_st80(int leadx, long indexx)
{
  float v;
	switch (leadx) {
          case 0: v=data_raw[indexx].l0_ST80;  break;
          case 1: v=data_raw[indexx].l1_ST80;  break;
	  case 2: v=data_raw[indexx].l2_ST80;  break;
	} // end switch
	return(v);
} //  end raw_st80

Bool Is_code(int leadx, long indexx, int cod1, int cod2)
{
  if ( cod1 == 0 && cod2 == 0 &&  global_ref[0].set &&  act_reference[leadx].change ) return(TRUE);
  if ( indexx < 0 ) return(FALSE);
  return((references[leadx][indexx].code1 == cod1) && (references[leadx][indexx].code2 == cod2));
} // end Is_code 

void lin_function(int leadx)
{
  long i, r_i, end_i;
  float val_1, val_2;
  double fk;
  long tim_1, tim_2;
  long first_r, last_r, next_r, GR_index,act_ind;

  act_ind=reference_act[leadx];
  end_i=references_index[leadx];

  // temp insert GR
  insert_ref(leadx,global_ref[leadx],0,0);
  end_i=end_i+1; 

  GR_index=reference_act[leadx]; 

  first_r=0; while (!Is_code(leadx,first_r,0,0)) first_r++;
  last_r=end_i; while (!Is_code(leadx,last_r,0,0)) last_r--; 
  next_r=first_r;

  val_1=raw_st80(leadx,references[leadx][first_r].raw_index); 
  val_2=raw_st80(leadx,references[leadx][first_r].raw_index); 
  tim_1=data_raw[references[leadx][first_r].raw_index].index; 
  tim_2=data_raw[references[leadx][first_r].raw_index].index; 
  fk=0.0;

  i=0;
  while ( i <= references[leadx][first_r].raw_index ){
      data_raw[i].lin_v[leadx]=val_2;
      data_raw[i].sub_v[leadx]=raw_st80(leadx,i)- val_2;
      i++;
  } // while befor first
      
  while ( next_r < last_r ) {

    val_1=val_2; tim_1=tim_2;
    next_r++;  while (!Is_code(leadx,next_r,0,0)) next_r++;

    val_2=raw_st80(leadx,references[leadx][next_r].raw_index); 
    tim_2=data_raw[references[leadx][next_r].raw_index].index;

    fk=(val_2 - val_1) / ( tim_2 - tim_1);

    while ( i <= references[leadx][next_r].raw_index ){
      data_raw[i].lin_v[leadx]=val_1 + fk * (data_raw[i].index - tim_1);
      data_raw[i].sub_v[leadx]=raw_st80(leadx,i)- data_raw[i].lin_v[leadx];
      i++;
    } // while to next
  } // while in ref interval

  while ( i <= raw_last_index ){
      data_raw[i].lin_v[leadx]=val_2;
      data_raw[i].sub_v[leadx]=raw_st80(leadx,i)- val_2;
      i++;
  } // while after last set to end data

	  for (r_i=GR_index; r_i < end_i; r_i++) {
	    references[leadx][r_i].copy_ref( references[leadx][r_i+1]); }

  reference_act[leadx]=act_ind;
  references_index[leadx]--;
}  // end lin_function

void get_display_code(int leadx, long indexx)
{
            strcpy(ref_code,"??");

            switch (references[leadx][indexx].code1){
	    case -1:if(Is_code(leadx,indexx,-1,1))  strcpy(ref_code,"BI");
                    if(Is_code(leadx,indexx,-1,7))  strcpy(ref_code,"BR");
                    if(Is_code(leadx,indexx,-1,11))  strcpy(ref_code,"BO");
	      break;
	    case -3:if(Is_code(leadx,indexx,-3,1))  strcpy(ref_code,"EI");
                    if(Is_code(leadx,indexx,-3,7))  strcpy(ref_code,"ER");
                    if(Is_code(leadx,indexx,-3,11))  strcpy(ref_code,"EO");
	      break;
	    case 0: if(Is_code(leadx,indexx,0,-1))  strcpy(ref_code,"GR");
                    if(Is_code(leadx,indexx,0,0))  strcpy(ref_code,"LR");
	      break;
 	     case 2:if(Is_code(leadx,indexx,2,1))  strcpy(ref_code,"XI");
                    if(Is_code(leadx,indexx,2,7))  strcpy(ref_code,"XR");
                    if(Is_code(leadx,indexx,2,11))  strcpy(ref_code,"XO");
	      break;
	    case 4: if(Is_code(leadx,indexx,4,0))  strcpy(ref_code,"DY");
	      break;
	    case 10:if(Is_code(leadx,indexx,10,0))  strcpy(ref_code,"NO");
	      break;
	    case 11:if(Is_code(leadx,indexx,11,0))  strcpy(ref_code,"UR");
	      break;
	    case 12:if(Is_code(leadx,indexx,12,0))  strcpy(ref_code,"PR");
	      break;
	    case 13:if(Is_code(leadx,indexx,13,0)) strcpy(ref_code,"AX");
	      break;
	    case 14:if(Is_code(leadx,indexx,14,0)) strcpy(ref_code,"CC");
	      break;
	    case 15:if(Is_code(leadx,indexx,15,0))  strcpy(ref_code,"UB");
	      break;
	    case 16:if(Is_code(leadx,indexx,16,0))  strcpy(ref_code,"UE");
	      break;
	    case 17:if(Is_code(leadx,indexx,17,0))  strcpy(ref_code,"A6");
	      break;
	    case 18:if(Is_code(leadx,indexx,18,0))  strcpy(ref_code,"A7");
	      break;
	    } // end code1
	      //	    return(ref_code);
} // end get_display_code

Bool IS_free(int leadx, long indexx, int act_op)
{
 long i;
 Bool test= TRUE;
 Bool test_l0=FALSE;
 Bool test_l1=FALSE;
 Bool test_l2=FALSE;
 long code_0, code_1, code_2;
 char d_c[2];

 if ( global_ref[0].set ) {
   if ( global_ref[0].raw_index == indexx ) {
     strcpy(message1,"Attempt to overlap Global Reference !");
     warning_message(1);
     return(FALSE);
   }
 }
 
 switch (leadx ){
 case 0: test_l0=TRUE; if (act_op == 2) { test_l1=lead1_data; test_l2=lead2_data; }
   break;
 case 1: test_l1=TRUE; if (act_op == 2) { test_l0=TRUE; test_l2=lead2_data; }
   break;
 case 2: test_l2=TRUE; if (act_op == 2) { test_l0=TRUE; test_l1=TRUE; }
   break;
 }

 if ( test_l0 ) {
   test_l0=FALSE;
   if ( references_index[0] > - 1) {
     for (i=0; i <= references_index[0]; i++) 
       if ( indexx == references[0][i].raw_index ) { test=FALSE; test_l0=TRUE; code_0=i;}
     
   }
 } // test_l0
 if ( test_l1 ) {
   test_l1=FALSE;
   if ( references_index[1] > - 1) {
     for (i=0; i <= references_index[1]; i++) 
       if ( indexx == references[1][i].raw_index ) { test=FALSE; test_l1=TRUE; code_1=i;}
   }
 } // test_l1
 if ( test_l2 ) {
   test_l2=FALSE;
   if ( references_index[2] > - 1) {
     for (i=0; i <= references_index[2]; i++) 
       if ( indexx == references[2][i].raw_index ) { test=FALSE; test_l2=TRUE; code_2=i;}
   }
 } // test_l2

 strcpy(message1,"");  strcpy(message2,""); strcpy(message3,"");

 if (test_l0 ) { 
   get_display_code(0,code_0);
   sprintf(message1,"Lead 0:   At  %s:", mstimstr(data_raw[indexx].index));
   sprintf(message2,"Attempt to overlap existing annotation (%s) !", ref_code);
 }
 if (test_l1 ) { 
   get_display_code(1,code_1);
   sprintf(message1,"Lead 1:   At  %s:", mstimstr(data_raw[indexx].index));
   sprintf(message2,"Attempt to overlap existing annotation (%s) !", ref_code);
 }
 if (test_l2 ) { 
   get_display_code(2,code_2);
   sprintf(message1,"Lead 2:   At  %s:", mstimstr(data_raw[indexx].index));
   sprintf(message2,"Attempt to overlap existing annotation (%s) !", ref_code);
 }
 if ( test_l0 OR test_l1 OR test_l2 ) warning_message(3);

 return(test);
} // end IS_free

Bool Is_prop_mode(int leadx)
{ 	
Bool test, t0, t1, t2;;

 test=        ( status_manual_mode   && status_unsubtracted  && 
		status_manual_mode1  && status_unsubtracted1 && 
	        status_manual_mode2  && status_unsubtracted2);
 t0= status_manual_mode   && status_unsubtracted ;
 t1= status_manual_mode1  && status_unsubtracted1;
 t2= status_manual_mode2  && status_unsubtracted2;

 switch (leadx){
   case 0: test=test &&	Lead1_operation == 0 && Lead2_operation == 0;
     t1= t1 && 	Lead1_operation == 0;
     t2= t2 && 	Lead2_operation == 0;
     break;
   case 1: test=test &&	Lead0_operation == 0 && Lead2_operation == 0;
     t0= t0 && 	Lead0_operation == 0;
     t2= t2 && 	Lead2_operation == 0;
     break;
   case 2: test=test &&	Lead0_operation == 0 && Lead1_operation == 0;
     t0= t0 && 	Lead0_operation == 0;
     t1= t1 && 	Lead1_operation == 0;
     break;
 }
 if ( ! test ) {
   strcpy(message1,"");  strcpy(message2,""); strcpy(message3,"");
   if (! t0 )    sprintf(message1,"Incorrect mode in Lead 0 ! " );
   if (! t1 )    sprintf(message2,"Incorrect mode in Lead 1 ! " );
   if (! t2 )    sprintf(message3,"Incorrect mode in Lead 2 ! " );
    warning_message(3);
 } 

 return(test);
} // end  Is_prop_mode

float avr_in_avrbeat(int i,int  point, int mean_smp)
{
  long iso_off_n;
  float avr, avr1;
// i = lead
        iso_off_n= 125-point;

	switch (mean_smp) {
	case 1:  avr1 =A_buff_M[i][iso_off_n]; break; 
	case 3:  avr1 = (A_buff_M[i][iso_off_n]+A_buff_M[i][iso_off_n-1]+A_buff_M[i][iso_off_n+1]) / 3.0; break; 
	case 5:  avr1 = (A_buff_M[i][iso_off_n]+A_buff_M[i][iso_off_n-1]+A_buff_M[i][iso_off_n+1]+A_buff_M[i][iso_off_n-2]+A_buff_M[i][iso_off_n+2]) / 5.0; break; 
	case 7:  avr1 = (A_buff_M[i][iso_off_n]+A_buff_M[i][iso_off_n-1]+A_buff_M[i][iso_off_n+1]+A_buff_M[i][iso_off_n-2]+A_buff_M[i][iso_off_n+2] + A_buff_M[i][iso_off_n-3]+A_buff_M[i][iso_off_n+3]) / 7.0; break; 
	}

  avr =STAMPL * long(Round(1000.0* avr1/STAMPL))/1000.0;
  return(avr);
}  // end avr_in_avrbeat

float avr_in_avrbeat_r(int i,int  point, int mean_smp)
{
  long iso_off_n;
  float avr, avr1;

        iso_off_n= 125-point;

	switch (mean_smp) {
	case 1:  avr1 =A_buff_R[i][iso_off_n]; break; 
	case 3:  avr1 = (A_buff_R[i][iso_off_n]+A_buff_R[i][iso_off_n-1]+A_buff_R[i][iso_off_n+1]) / 3.0; break; 
	case 5:  avr1 = (A_buff_R[i][iso_off_n]+A_buff_R[i][iso_off_n-1]+A_buff_R[i][iso_off_n+1]+A_buff_R[i][iso_off_n-2]+A_buff_R[i][iso_off_n+2]) / 5.0; break; 
	case 7:  avr1 = (A_buff_R[i][iso_off_n]+A_buff_R[i][iso_off_n-1]+A_buff_R[i][iso_off_n+1]+A_buff_R[i][iso_off_n-2]+A_buff_R[i][iso_off_n+2] + A_buff_R[i][iso_off_n-3]+A_buff_R[i][iso_off_n+3]) / 7.0; break; 
	}
  avr =STAMPL * long(Round(1000.0* avr1/STAMPL))/1000.0;
  return(avr);
}  // end avr_in_avrbeat_r

void plot_point_symbol(int s_type, long x, long y)
{
  return;
} //end plot_point_symbol

int mk_uv(float x_v)
{
  return((long)(Round(1000.0* x_v/STAMPL)));
}

void write_ref_data_l0(void)
{

long hours=0,hours_l=0,  minutes=0, seconds=0;
int lead=0;

   my_display=l_b_display; my_window=l_b_window; my_gc= gcLead0;

   XAllocNamedColor(my_display, cmap,"white", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   XFillRectangle(my_display, my_window, my_gc, 1,54,130,92);

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   if (Marker[lead].set ) {
     
   XAllocNamedColor(my_display, cmap,set_color8, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
   XFillRectangle(my_display, my_window, my_gc, 1,55,130,12);
   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   sprintf(pr_buff, "RAW: %14s",mstimstr(data_raw[Marker[lead].raw_index].index));
   XDrawString(my_display, my_window, my_gc, 2, 66, pr_buff, strlen(pr_buff));

   sprintf(pr_buff, "HRate: %9d [bpm]",data_raw[Marker[lead].raw_index].HR);
   XDrawString(my_display, my_window, my_gc, 2, 78, pr_buff, strlen(pr_buff));

   XAllocNamedColor(my_display, cmap,set_color8, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
   XFillRectangle(my_display, my_window, my_gc, 1,79,130,24);
   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   sprintf(pr_buff,"ST80:");
   XDrawString(my_display, my_window, my_gc, 2, 90, pr_buff, strlen(pr_buff));

   if ( reference_act[lead] == -1 && references_index[lead] == -1 ) {
   sprintf(pr_buff," %6d/%6d",mk_uv(data_raw[Marker[lead].raw_index].l0_ST80),
	   act_ref_data[lead].raw_ST80); // ***
 } else if (reference_act[lead] > -1 ) {
   sprintf(pr_buff," %6d/%6d",mk_uv(data_raw[Marker[lead].raw_index].l0_ST80),
	   references[lead][reference_act[lead]].raw_ST80 ); }
 else
   { sprintf(pr_buff," %6d/%6s",mk_uv(data_raw[Marker[lead].raw_index].l0_ST80), " "); }   

   XDrawString(my_display, my_window, my_gc, 40, 90, pr_buff, strlen(pr_buff));

   sprintf(pr_buff,"STSb:");
   XDrawString(my_display, my_window, my_gc, 2, 102, pr_buff, strlen(pr_buff));

 if ( reference_act[lead] == -1 && references_index[lead] == -1) {
   sprintf(pr_buff," %6d/%6d",mk_uv(data_raw[Marker[lead].raw_index].sub_v[lead]),
	   act_ref_data[lead].ST_sub );
 } else if (reference_act[lead] > -1 ) {
   sprintf(pr_buff," %6d/%6d",mk_uv(data_raw[Marker[lead].raw_index].sub_v[lead]),
                                         references[lead][reference_act[lead]].ST_sub );
 } else {
   sprintf(pr_buff," %6d/%6s",mk_uv(data_raw[Marker[lead].raw_index].sub_v[lead]), " ");
 }

   XDrawString(my_display, my_window, my_gc, 40, 102, pr_buff, strlen(pr_buff));

   XAllocNamedColor(my_display, cmap,set_color8, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
   XFillRectangle(my_display, my_window, my_gc, 1,109,130,12);
   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   sprintf(pr_buff, "FINE: %14s",mstimstr(data_fin[Marker[lead].fine_index].index));
   XDrawString(my_display, my_window, my_gc, 2, 120, pr_buff, strlen(pr_buff));

   sprintf(pr_buff, "HRate: %9d [bpm]", data_fin[Marker[lead].fine_index].HR);
   XDrawString(my_display, my_window, my_gc, 2, 132, pr_buff, strlen(pr_buff));

   sprintf(pr_buff,"ST80:");
   XDrawString(my_display, my_window, my_gc, 2, 144, pr_buff, strlen(pr_buff));

 if ( reference_act[lead] == -1 && references_index[lead] == -1) {
   sprintf(pr_buff," %6d/%6d", mk_uv( data_fin[Marker[lead].fine_index].l0_ST80), 
	   act_ref_data[lead].fine_ST80 );
 } else if (reference_act[lead] > -1 ) {
   sprintf(pr_buff," %6d/%6d", mk_uv( data_fin[Marker[lead].fine_index].l0_ST80), 
                                       references[lead][reference_act[lead]].fine_ST80 );
 } else {
   sprintf(pr_buff," %6d/%6s",mk_uv(data_fin[Marker[lead].fine_index].l0_ST80), " ");
 }

   XDrawString(my_display, my_window, my_gc, 40, 144, pr_buff, strlen(pr_buff));

  }

   XAllocNamedColor(my_display, cmap,set_color8, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   XFillRectangle(my_display, my_window, my_gc, 1,13,130,24);

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   if ( status_manual_mode ) XDrawString(my_display, my_window, my_gc, 2,24,"MANUAL MODE",11);
                        else XDrawString(my_display, my_window, my_gc, 2,24,"AUTOMATIC MODE",14);

   if ( status_unsubtracted ) XDrawString(my_display, my_window, my_gc, 2,36,"UNSUBTRACTED",12);
                         else XDrawString(my_display, my_window, my_gc, 2,36,"SUBTRACTED",10);

     if ( act_reference[0].set ){
        if ( act_reference[0].typ == 1 ) 	  sprintf(pr_buff, "ACTIVE: Global Ref");
        if ( act_reference[0].typ == 2 ) 	  sprintf(pr_buff, "ACTIVE: Local Ref");
						}
                   else {
		     sprintf(pr_buff, "ACTIVE:");
		   }

   XDrawString(my_display, my_window, my_gc, 2, 48, pr_buff, strlen(pr_buff));
}// write_ref_data_l0 

void write_ref_data_l1(void)
{

long hours=0,hours_l=0,  minutes=0, seconds=0;

int lead=1;

   my_display=l_b1_display; my_window=l_b1_window; my_gc= gcLead1;

   XAllocNamedColor(my_display, cmap,"white", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   XFillRectangle(my_display, my_window, my_gc, 1,54,130,92);

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   if (Marker[lead].set ) {
     
   XAllocNamedColor(my_display, cmap,set_color8, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
   XFillRectangle(my_display, my_window, my_gc, 1,55,130,12);
   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
   sprintf(pr_buff, "RAW: %14s",mstimstr(data_raw[Marker[lead].raw_index].index));
   XDrawString(my_display, my_window, my_gc, 2, 66, pr_buff, strlen(pr_buff));

   sprintf(pr_buff, "HRate: %9d [bpm]",data_raw[Marker[lead].raw_index].HR);
   XDrawString(my_display, my_window, my_gc, 2, 78, pr_buff, strlen(pr_buff));

   XAllocNamedColor(my_display, cmap,set_color8, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
   XFillRectangle(my_display, my_window, my_gc, 1,79,130,24);
   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   sprintf(pr_buff,"ST80:");
   XDrawString(my_display, my_window, my_gc, 2, 90, pr_buff, strlen(pr_buff));

   if ( reference_act[lead] == -1 && references_index[lead] == -1 ) {
   sprintf(pr_buff," %6d/%6d",mk_uv(data_raw[Marker[lead].raw_index].l1_ST80),
	   act_ref_data[lead].raw_ST80); // **
 } else if (reference_act[lead] > -1 ) {
   sprintf(pr_buff," %6d/%6d",mk_uv(data_raw[Marker[lead].raw_index].l1_ST80),
	   references[lead][reference_act[lead]].raw_ST80 ); }
 else
   { sprintf(pr_buff," %6d/%6s",mk_uv(data_raw[Marker[lead].raw_index].l1_ST80), " "); }   

   XDrawString(my_display, my_window, my_gc, 40, 90, pr_buff, strlen(pr_buff));

   sprintf(pr_buff,"STSb:");
   XDrawString(my_display, my_window, my_gc, 2, 102, pr_buff, strlen(pr_buff));

 if ( reference_act[lead] == -1 && references_index[lead] == -1) {
   sprintf(pr_buff," %6d/%6d",mk_uv(data_raw[Marker[lead].raw_index].sub_v[lead]),
	   act_ref_data[lead].ST_sub ); // **
 } else if (reference_act[lead] > -1 ) {
   sprintf(pr_buff," %6d/%6d",mk_uv(data_raw[Marker[lead].raw_index].sub_v[lead]),
                                         references[lead][reference_act[lead]].ST_sub );
 } else {
   sprintf(pr_buff," %6d/%6s",mk_uv(data_raw[Marker[lead].raw_index].sub_v[lead]), " ");
 }

   XDrawString(my_display, my_window, my_gc, 40, 102, pr_buff, strlen(pr_buff));

   XAllocNamedColor(my_display, cmap,set_color8, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
   XFillRectangle(my_display, my_window, my_gc, 1,109,130,12);
   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   sprintf(pr_buff, "FINE: %14s",mstimstr(data_fin[Marker[lead].fine_index].index));
   XDrawString(my_display, my_window, my_gc, 2, 120, pr_buff, strlen(pr_buff));

   sprintf(pr_buff, "HRate: %9d [bpm]", data_fin[Marker[lead].fine_index].HR);
   XDrawString(my_display, my_window, my_gc, 2, 132, pr_buff, strlen(pr_buff));

   sprintf(pr_buff,"ST80:");
   XDrawString(my_display, my_window, my_gc, 2, 144, pr_buff, strlen(pr_buff));

 if ( reference_act[lead] == -1 && references_index[lead] == -1) {
   sprintf(pr_buff," %6d/%6d", mk_uv( data_fin[Marker[lead].fine_index].l1_ST80), 
	   act_ref_data[lead].fine_ST80 ); // **
 } else if (reference_act[lead] > -1 ) {
   sprintf(pr_buff," %6d/%6d", mk_uv( data_fin[Marker[lead].fine_index].l1_ST80), 
                                       references[lead][reference_act[lead]].fine_ST80 );
 } else {
   sprintf(pr_buff," %6d/%6s",mk_uv(data_fin[Marker[lead].fine_index].l1_ST80), " ");
 }
   XDrawString(my_display, my_window, my_gc, 40, 144, pr_buff, strlen(pr_buff));
  }

   XAllocNamedColor(my_display, cmap,set_color8, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   XFillRectangle(my_display, my_window, my_gc, 1,13,130,24);

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   if ( status_manual_mode1 ) XDrawString(my_display, my_window, my_gc, 2,24,"MANUAL MODE",11);
                        else XDrawString(my_display, my_window, my_gc, 2,24,"AUTOMATIC MODE",14);

   if ( status_unsubtracted1 ) XDrawString(my_display, my_window, my_gc, 2,36,"UNSUBTRACTED",12);
                         else XDrawString(my_display, my_window, my_gc, 2,36,"SUBTRACTED",10);

     if ( act_reference[1].set ){
        if ( act_reference[1].typ == 1 ) 	  sprintf(pr_buff, "ACTIVE: Global Ref");
        if ( act_reference[1].typ == 2 ) 	  sprintf(pr_buff, "ACTIVE: Local Ref");
						}
                   else {
		     sprintf(pr_buff, "ACTIVE:");
		   }

   XDrawString(my_display, my_window, my_gc, 2, 48, pr_buff, strlen(pr_buff));
}// write_ref_data_l1 

void write_ref_data_l2(void)
{

long hours=0,hours_l=0,  minutes=0, seconds=0;

int lead=2;

   my_display=l_b2_display; my_window=l_b2_window; my_gc= gcLead2;

   XAllocNamedColor(my_display, cmap,"white", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   XFillRectangle(my_display, my_window, my_gc, 1,54,130,92);

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   if (Marker[lead].set ) {
     
   XAllocNamedColor(my_display, cmap,set_color8, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
   XFillRectangle(my_display, my_window, my_gc, 1,55,130,12);
   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   sprintf(pr_buff, "RAW: %14s",mstimstr(data_raw[Marker[lead].raw_index].index));
   XDrawString(my_display, my_window, my_gc, 2, 66, pr_buff, strlen(pr_buff));

   sprintf(pr_buff, "HRate: %9d [bpm]",data_raw[Marker[lead].raw_index].HR);
   XDrawString(my_display, my_window, my_gc, 2, 78, pr_buff, strlen(pr_buff));

   XAllocNamedColor(my_display, cmap,set_color8, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
   XFillRectangle(my_display, my_window, my_gc, 1,79,130,24);
   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   sprintf(pr_buff,"ST80:");
   XDrawString(my_display, my_window, my_gc, 2, 90, pr_buff, strlen(pr_buff));

   if ( reference_act[lead] == -1 && references_index[lead] == -1 ) {
   sprintf(pr_buff," %6d/%6d",mk_uv(data_raw[Marker[lead].raw_index].l2_ST80),
	   act_ref_data[lead].raw_ST80); // **
 } else if (reference_act[lead] > -1 ) {
   sprintf(pr_buff," %6d/%6d",mk_uv(data_raw[Marker[lead].raw_index].l2_ST80),
	   references[lead][reference_act[lead]].raw_ST80 ); }
 else
   { sprintf(pr_buff," %6d/%6s",mk_uv(data_raw[Marker[lead].raw_index].l2_ST80), " "); }   

   XDrawString(my_display, my_window, my_gc, 40, 90, pr_buff, strlen(pr_buff));

   sprintf(pr_buff,"STSb:");
   XDrawString(my_display, my_window, my_gc, 2, 102, pr_buff, strlen(pr_buff));

 if ( reference_act[lead] == -1 && references_index[lead] == -1) {
   sprintf(pr_buff," %6d/%6d",mk_uv(data_raw[Marker[lead].raw_index].sub_v[lead]),
	   act_ref_data[lead].ST_sub ); // **
 } else if (reference_act[lead] > -1 ) {
   sprintf(pr_buff," %6d/%6d",mk_uv(data_raw[Marker[lead].raw_index].sub_v[lead]),
                                         references[lead][reference_act[lead]].ST_sub );
 } else {
   sprintf(pr_buff," %6d/%6s",mk_uv(data_raw[Marker[lead].raw_index].sub_v[lead]), " ");
 }

   XDrawString(my_display, my_window, my_gc, 40, 102, pr_buff, strlen(pr_buff));

   XAllocNamedColor(my_display, cmap,set_color8, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
   XFillRectangle(my_display, my_window, my_gc, 1,109,130,12);
   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   sprintf(pr_buff, "FINE: %14s",mstimstr(data_fin[Marker[lead].fine_index].index));
   XDrawString(my_display, my_window, my_gc, 2, 120, pr_buff, strlen(pr_buff));

   sprintf(pr_buff, "HRate: %9d [bpm]", data_fin[Marker[lead].fine_index].HR);
   XDrawString(my_display, my_window, my_gc, 2, 132, pr_buff, strlen(pr_buff));

   sprintf(pr_buff,"ST80:");
   XDrawString(my_display, my_window, my_gc, 2, 144, pr_buff, strlen(pr_buff));

 if ( reference_act[lead] == -1 && references_index[lead] == -1) {
   sprintf(pr_buff," %6d/%6d", mk_uv( data_fin[Marker[lead].fine_index].l2_ST80), 
	   act_ref_data[lead].fine_ST80 ); // **
 } else if (reference_act[lead] > -1 ) {
   sprintf(pr_buff," %6d/%6d", mk_uv( data_fin[Marker[lead].fine_index].l2_ST80), 
                                       references[lead][reference_act[lead]].fine_ST80 );
 } else {
   sprintf(pr_buff," %6d/%6s",mk_uv(data_fin[Marker[lead].fine_index].l2_ST80), " ");
 }
   XDrawString(my_display, my_window, my_gc, 40, 144, pr_buff, strlen(pr_buff));
  }

   XAllocNamedColor(my_display, cmap,set_color8, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   XFillRectangle(my_display, my_window, my_gc, 1,13,130,24);

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   if ( status_manual_mode2 ) XDrawString(my_display, my_window, my_gc, 2,24,"MANUAL MODE",11);
                        else XDrawString(my_display, my_window, my_gc, 2,24,"AUTOMATIC MODE",14);

   if ( status_unsubtracted2 ) XDrawString(my_display, my_window, my_gc, 2,36,"UNSUBTRACTED",12);
                         else XDrawString(my_display, my_window, my_gc, 2,36,"SUBTRACTED",10);

     if ( act_reference[2].set ){
        if ( act_reference[2].typ == 1 ) 	  sprintf(pr_buff, "ACTIVE: Global Ref");
        if ( act_reference[2].typ == 2 ) 	  sprintf(pr_buff, "ACTIVE: Local Ref");
						}
                   else {
		     sprintf(pr_buff, "ACTIVE:");
		   }

   XDrawString(my_display, my_window, my_gc, 2, 48, pr_buff, strlen(pr_buff));
}// write_ref_data_l2 

void draw_lead0_A(void)
{
long i, begmisx, begmise, j, ischonbegx, ischonbege;
long x_0, x_1, x_x, y_0, y_1, y1_0, y1_1;
Bool act_loc;

// episodes
 Bool pl_epi=FALSE, pl_epii=FALSE;
 Bool epi_error=FALSE, epi_error_first=TRUE;
 long ep_index=0;
 int ep_status_i=0, ep_status_r=0, ep_status_o=0;

   index_0_b=TimeToIndex(diagram_time_begin_lead);
   index_0_e=TimeToIndex(diagram_time_begin_lead+time_scale_0);
   index_0=index_0_b;

   XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);

   if ( ovr0_l1 ) { 
   XAllocNamedColor(my_display, cmap,set_color5, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   i=0; 
   while (data_raw[i].index < index_0_b) i++;
   x_0=Coor_x_l0(data_raw[i].index-index_0_b); y_0=Coor_y_l0(data_raw[i].l1_ST80);
   while ( (data_raw[i].index < index_0_e ) && ( i < raw_last_index) ){
     i++;
     x_1=Coor_x_l0(data_raw[i].index-index_0_b); y_1=Coor_y_l0(data_raw[i].l1_ST80);

     if ((x_1 > x_0 ) OR PLOT_ALL ) { 
          XDrawLine(my_display, my_window, my_gc, x_0,y_0, x_1,y_1);
	  x_0=x_1; y_0=y_1;
	}

   } // end while

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
 }

   if ( ovr0_l2 ) { 
   XAllocNamedColor(my_display, cmap,set_color6, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   i=0; 
   while (data_raw[i].index < index_0_b) i++;
   x_0=Coor_x_l0(data_raw[i].index-index_0_b); y_0=Coor_y_l0(data_raw[i].l2_ST80);
   while ( (data_raw[i].index < index_0_e ) && ( i < raw_last_index) ){
     i++;
     x_1=Coor_x_l0(data_raw[i].index-index_0_b); y_1=Coor_y_l0(data_raw[i].l2_ST80);

     if ((x_1 > x_0 ) OR PLOT_ALL ) { 
          XDrawLine(my_display, my_window, my_gc, x_0,y_0, x_1,y_1);
	  x_0=x_1; y_0=y_1;
	}
   } // end while

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
 }

   if ( ovr0_app ) { 
   XAllocNamedColor(my_display, cmap,set_color3, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   i=0; 
   while (data_raw[i].index < index_0_b) i++;
   x_0=Coor_x_l0(data_raw[i].index-index_0_b); y_0=Coor_y_l0(data_raw[i].lin_v[0]);
   while ( (data_raw[i].index < index_0_e ) && ( i < raw_last_index) ){
     i++;
     x_1=Coor_x_l0(data_raw[i].index-index_0_b); y_1=Coor_y_l0(data_raw[i].lin_v[0]);

     if ((x_1 > x_0 ) OR PLOT_ALL ) { 
          XDrawLine(my_display, my_window, my_gc, x_0,y_0, x_1,y_1);
	  x_0=x_1; y_0=y_1;
	}
   } // end while

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   }

   index_0_b=TimeToIndex(diagram_time_begin_lead);
   index_0_e=TimeToIndex(diagram_time_begin_lead+time_scale_0);
   index_0=index_0_b;

   XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);

   i=0; 
   while (data_raw[i].index < index_0_b) i++;
   raw_display_begin=i;
   fin_display_begin=i;
   x_0=Coor_x_l0(data_raw[i].index-index_0_b);  
   if (status_unsubtracted ) {y_0=Coor_y_l0(data_raw[i].l0_ST80);}
    else  {y_0=Coor_y_l0(data_raw[i].sub_v[0]);}
   if (lead0_plot_button_status.HRRaw ) { y1_0=170-data_raw[i].HR/2; 
					  XDrawString(my_display, my_window, my_gc, 2,161, "Heart Rate Raw [bpm]",20);}

   if (lead0_plot_button_status.STslRaw ) { y1_0=60+Coor_y_l0(data_raw[i].l0_ST80-data_raw[i].l0_ST20); 
                                            XDrawString(my_display, my_window, my_gc, 2,161, "ST Slope Raw [uV]",17);}

   if ((lead0_plot_button_status.Episodes ) && (references_index[0] >= 0)) {
                                            XDrawString(my_display, my_window, my_gc, 2,161, "Episodes",8);}

   begmisx = -1;  begmise = -1; ischonbegx = -1; ischonbege = -1;
   while ( (data_raw[i].index < index_0_e ) && ( i < raw_last_index) ) {

   if ((lead0_plot_button_status.Episodes ) && (references_index[0] >= 0)) { 

     while (( references[0][ep_index].raw_index <= i ) && ( ep_index <= references_index[0] )){

       if (Is_code(0,ep_index,-1,1)){
	 if ( (ep_status_i == 0 ) && (ep_status_r == 0) && (ep_status_o == 0) ) { ep_status_i=1; pl_epi=TRUE; pl_epii=TRUE;}
	 else { epi_error = TRUE; pl_epi=FALSE; pl_epii=FALSE; }     }
       if (Is_code(0,ep_index,2,1)){
	 if (( ep_status_i == 1  ) && (ep_status_r == 0) && (ep_status_o == 0)) { ep_status_i=2; pl_epi=TRUE; pl_epii=TRUE;}
	 else { if (ep_status_i == 0) begmisx = i; ischonbegx = i; epi_error = TRUE; pl_epi=FALSE;  pl_epii=FALSE;}     }
       if (Is_code(0,ep_index,-3,1)){
	 if (( ep_status_i == 2  ) && (ep_status_r == 0) && (ep_status_o == 0)) { ep_status_i=0; pl_epi=FALSE; pl_epii=FALSE;}
	 else { if (ep_status_i == 0) begmise = i; ischonbege = i; epi_error = TRUE; pl_epi=FALSE;  pl_epii=FALSE;}       }

        if (Is_code(0,ep_index,-1,7)){
	 if (( ep_status_r == 0  ) && (ep_status_i == 0) && (ep_status_o == 0)) { ep_status_r=1; pl_epi=TRUE;}
	 else { epi_error = TRUE; pl_epi=FALSE; }       }
       if (Is_code(0,ep_index,2,7)){
	 if (( ep_status_r == 1  ) && (ep_status_i == 0) && (ep_status_o == 0)) { ep_status_r=2; pl_epi=TRUE;}
	 else { if (ep_status_r == 0) begmisx = i; epi_error = TRUE; pl_epi=FALSE; }      }
       if (Is_code(0,ep_index,-3,7)){
	 if (( ep_status_r == 2  ) && (ep_status_i == 0) && (ep_status_o == 0)) { ep_status_r=0; pl_epi=FALSE;}
	 else { if (ep_status_r == 0) begmise = i; epi_error = TRUE; pl_epi=FALSE; }      }

       if (Is_code(0,ep_index,-1,11)){
	 if (( ep_status_o == 0  ) && (ep_status_r == 0) && (ep_status_i == 0)) { ep_status_o=1; pl_epi=TRUE;}
	 else { epi_error = TRUE; pl_epi=FALSE; }       }
       if (Is_code(0,ep_index,2,11)){
	 if (( ep_status_o == 1  ) && (ep_status_r == 0) && (ep_status_i == 0)) { ep_status_o=2; pl_epi=TRUE;}
	 else { if (ep_status_o == 0) begmisx = i; epi_error = TRUE; pl_epi=FALSE; }       }
       if (Is_code(0,ep_index,-3,11)){
	 if (( ep_status_o == 2  ) && (ep_status_r == 0) && (ep_status_i == 0)) { ep_status_o=0; pl_epi=FALSE;}
	 else { if (ep_status_o == 0) begmise = i; epi_error = TRUE; pl_epi=FALSE; }       }

       if ( epi_error) sprintf(message2, "Time: %14s",mstimstr(data_raw[references[0][ep_index].raw_index].index)); 
       ep_index++; 
      if ((ep_index > references_index[0] ) && ((ep_status_i != 0) || (ep_status_r != 0) || (ep_status_o != 0)) ) {
	   epi_error=TRUE;
           sprintf(message2, "Time: %14s",mstimstr(data_raw[references[0][references_index[0]].raw_index].index));       }
       if ( epi_error && epi_error_first )  {
           strcpy(message1,"Lead 0: Inconsistent episode !");
//
//           warning_message(2); 
//
           epi_error=FALSE; ep_status_i=0; ep_status_r=0; ep_status_o=0; epi_error_first=FALSE; }
     }
       if (pl_epi) {
	  XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
	  XDrawLine(my_display, my_window, my_gc, x_0,116, x_0,120);
//	  XDrawLine(my_display, my_window, my_gc, x_0,146, x_0,150);
	  XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);
	  //	  pl_epi=ep_status != 0;
		   }
//       if (pl_epii) {
//	  XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
//	  XDrawLine(my_display, my_window, my_gc, x_0,136, x_0,140);
//	  XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);
//	  //	  pl_epi=ep_status != 0;
//		   }
   } // end episodes

     i++;
     x_1=Coor_x_l0(data_raw[i].index-index_0_b);
     if (status_unsubtracted ) {y_1=Coor_y_l0(data_raw[i].l0_ST80);}
       else  {y_1=Coor_y_l0(data_raw[i].sub_v[0]);}

     if ((x_1 > x_0 ) OR PLOT_ALL ) { 
          XDrawLine(my_display, my_window, my_gc, x_0,y_0, x_1,y_1);
	  XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
	  XDrawLine(my_display, my_window, my_gc, x_0,156, x_0,160);
	  XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);

	  if (lead0_plot_button_status.HRRaw ){
	    y1_1=170-data_raw[i].HR/2;
	    XDrawLine(my_display, my_window, my_gc, x_0,y1_0, x_1,y1_1);
	    y1_0=y1_1;
	  }

	  if (lead0_plot_button_status.STslRaw ){
	    y1_1=60+Coor_y_l0(data_raw[i].l0_ST80-data_raw[i].l0_ST20);
	    XDrawLine(my_display, my_window, my_gc, x_0,y1_0, x_1,y1_1);
	    y1_0=y1_1;
	  }
	  x_0=x_1; y_0=y_1;
	}

   } // end while

	  XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
	  XDrawLine(my_display, my_window, my_gc, x_0,156, x_0,160);
	  XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);

   if (begmisx != -1 && begmise != -1) {
      j=begmise; begmisx = begmise = -1;
      x_x=Coor_x_l0(data_raw[j].index-index_0_b);  
      while ( (data_raw[j].index >= index_0_b ) && ( j >= 0) ) {
	  XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
	  XDrawLine(my_display, my_window, my_gc, x_x,116, x_x,120);
//	  XDrawLine(my_display, my_window, my_gc, x_x,146, x_x,150);
	  XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);
	  j--;
          x_x=Coor_x_l0(data_raw[j].index-index_0_b);  
      }
   }

//   if (ischonbegx != -1 && ischonbege != -1) {
//      j=ischonbegx; ischonbegx = ischonbege = -1;
//      x_x=Coor_x_l0(data_raw[j].index-index_0_b);  
//      while ( (data_raw[j].index >= index_0_b ) && ( j >= 0) ) {
//	  XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
//	  XDrawLine(my_display, my_window, my_gc, x_x,136, x_x,140);
//	  XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);
//	  j--;
//          x_x=Coor_x_l0(data_raw[j].index-index_0_b);  
//      }
//   }

   raw_display_end=i-1;
    fin_display_end=raw_display_end; 
     while ( (data_fin[fin_display_end].index < index_0_e) && ( fin_display_end < fin_last_index) )     fin_display_end++; 
    fin_display_end=fin_display_end-1; 

   i=0;  
   while (data_fin[i].index < index_0_b) i++;
   fin_display_begin=i;
if  (lead0_plot_button_status.HRate OR lead0_plot_button_status.STFine OR lead0_plot_button_status.STslFine OR lead0_plot_button_status.ISOJ ){ 

   x_0=Coor_x_l0(data_fin[i].index-index_0_b);
   if (lead0_plot_button_status.HRate ) { y_0=170-data_fin[i].HR/2; XDrawString(my_display, my_window, my_gc, 2,161, "Heart Rate [bpm]",16);}
   if (lead0_plot_button_status.STFine ) { y_0=60+Coor_y_l0(data_fin[i].l0_ST80); 
					   XDrawString(my_display, my_window, my_gc, 2,161, "ST Fine [uV]",12);}
   if (lead0_plot_button_status.STslFine ) { y_0=60+Coor_y_l0(data_fin[i].l0_ST80-data_fin[i].l0_ST20); 
					     XDrawString(my_display, my_window, my_gc, 2,161, "ST Slope Fine [uV]",18);}

    if (lead0_plot_button_status.ISOJ ) { y_0=(long)(160-1000.0*(data_fin[i].nISO +data_fin[i].nJ)/FSAMP/3); 
					  XDrawString(my_display, my_window, my_gc, 2,161, "ISO - J [ms]",12);}
  while ( (data_fin[i].index < index_0_e) && ( i < fin_last_index) ) {
     i++;
     x_1=Coor_x_l0(data_fin[i].index-index_0_b); 
     if (lead0_plot_button_status.HRate ) y_1=170-data_fin[i].HR/2;
     if (lead0_plot_button_status.STFine ) y_1=60+Coor_y_l0(data_fin[i].l0_ST80);
     if (lead0_plot_button_status.STslFine ) y_1=60+Coor_y_l0(data_fin[i].l0_ST80-data_fin[i].l0_ST20);
     if (lead0_plot_button_status.ISOJ )  y_1=(long)(160-1000.0*(data_fin[i].nISO +data_fin[i].nJ)/FSAMP/3); 
     if ((x_1 > x_0 ) OR PLOT_ALL ) { 
          XDrawLine(my_display, my_window, my_gc, x_0,y_0, x_1,y_1);
	  XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
	  XDrawLine(my_display, my_window, my_gc, x_0,160, x_0,163);
	  XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);

	  x_0=x_1; y_0=y_1;
	}
       } // end while
	  XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
	  XDrawLine(my_display, my_window, my_gc, x_0,160, x_0,163);
	  XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);
    fin_display_end=i-1; 
     } // if hrate

   if ( references_index[0] >= 0 ){
     for (i=0; i <= references_index[0]; i++){
       if ( (data_raw[references[0][i].raw_index].index >= index_0_b) && (data_raw[references[0][i].raw_index].index <= index_0_e) ) {
	 act_loc=FALSE;
	 if ( Is_code(0,i,0,0) ){
	    act_loc= act_reference[0].set && ( act_reference[0].typ == 2 ) && (act_reference[0].index == i);

            if (( i == reference_act[0] ) OR act_loc ) {
	      XAllocNamedColor(my_display, cmap,set_color1, &col, & unused);
	      XSetForeground(my_display, my_gc, col.pixel);
	    }
	    x_0=Coor_x_l0(data_raw[references[0][i].raw_index].index-index_0_b);

	    XDrawLine(my_display, my_window, my_gc, x_0,10, x_0,160);
	    XDrawString(my_display, my_window, my_gc, x_0 - 10 ,10, "LR",2);
            if (( i == reference_act[0] ) OR act_loc ) {
	      XAllocNamedColor(my_display, cmap,"black", &col, & unused);
	      XSetForeground(my_display, my_gc, col.pixel);
	    }
	 } 
	 else  // other ref
	 {
            if ( i == reference_act[0] ) {
	      XAllocNamedColor(my_display, cmap,set_color2, &col, & unused);
	      XSetForeground(my_display, my_gc, col.pixel);
	    }
	    x_0=Coor_x_l0(data_raw[references[0][i].raw_index].index-index_0_b);

	    XDrawLine(my_display, my_window, my_gc, x_0,10, x_0,160);
	    get_display_code(0,i);
	    XDrawString(my_display, my_window, my_gc, x_0 - 10 ,10, ref_code,2);
            if ( i == reference_act[0] ) {
	      XAllocNamedColor(my_display, cmap,"black", &col, & unused);
	      XSetForeground(my_display, my_gc, col.pixel);
	    }
	 }
       }
     } // end for
   } // plot ref.
   
   if ( loc_interval_b[0].set  && (data_raw[loc_interval_b[0].raw_index].index >= index_0_b) && (data_raw[loc_interval_b[0].raw_index].index <= index_0_e) ) {
   x_0=Coor_x_l0(data_raw[loc_interval_b[0].raw_index].index-index_0_b);
   XAllocNamedColor(my_display, cmap,set_color3, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   XDrawLine(my_display, my_window, my_gc, x_0,10, x_0,160);
   XDrawString(my_display, my_window, my_gc, x_0 - 9 ,20, "B",1);

  }

   if ( loc_interval_e[0].set  && (data_raw[loc_interval_e[0].raw_index].index >= index_0_b) && (data_raw[loc_interval_e[0].raw_index].index <= index_0_e) ) {
   x_0=Coor_x_l0(data_raw[loc_interval_e[0].raw_index].index-index_0_b);
   XAllocNamedColor(my_display, cmap,set_color3, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   XDrawLine(my_display, my_window, my_gc, x_0,10, x_0,160);
   XDrawString(my_display, my_window, my_gc, x_0 - 9 ,20, "E",1);

  }

   if ( global_set  && (data_raw[global_ref[0].raw_index].index >= index_0_b) && (data_raw[global_ref[0].raw_index].index <= index_0_e) ) {
   XAllocNamedColor(my_display, cmap,set_color1, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   x_0=Coor_x_l0(data_raw[global_ref[0].raw_index].index-index_0_b);

   XDrawLine(my_display, my_window, my_gc, x_0,10, x_0,160);
   XDrawString(my_display, my_window, my_gc, x_0 - 10 ,10, "GR",2);

  }

  if ( Marker[0].set  && (data_raw[Marker[0].raw_index].index >= index_0_b) && (data_raw[Marker[0].raw_index].index <= index_0_e) ) {
   XAllocNamedColor(my_display, cmap,set_color3, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   x_0=Coor_x_l0(data_raw[Marker[0].raw_index].index-index_0_b);

   XDrawLine(my_display, my_window, my_gc, x_0,10, x_0,160);
   XDrawString(my_display, my_window, my_gc, x_0 - 11 ,20, "M",1);

   x_1=Coor_x_l0(data_fin[Marker[0].fine_index].index-index_0_b);
   if ( x_1 == x_0) x_1++;
   XDrawLine(my_display, my_window, my_gc, x_1,80, x_1,160);

  } // end marker

   XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
    

} // end draw_lead0_A(void)

void draw_lead1_A(void)
{
long i, begmisx, begmise, j, ischonbegx, ischonbege;
long x_0, x_1, x_x, y_0, y_1, y1_0,y1_1;
Bool act_loc;

 Bool pl_epi=FALSE, pl_epii=FALSE;
 Bool epi_error=FALSE, epi_error_first=TRUE;
 long ep_index=0;
 int ep_status_i=0, ep_status_r=0, ep_status_o=0;

   index_0_b=TimeToIndex(diagram_time_begin_lead);
   index_0_e=TimeToIndex(diagram_time_begin_lead+time_scale_0);
   index_0=index_0_b;

   XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);

   if ( ovr1_l0 ) { 
     XAllocNamedColor(my_display, cmap,set_color4, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   i=0; 
   while (data_raw[i].index < index_0_b) i++;
   x_0=Coor_x_l0(data_raw[i].index-index_0_b); y_0=Coor_y_l1(data_raw[i].l0_ST80);
   while ( (data_raw[i].index < index_0_e ) && ( i < raw_last_index) ){
     i++;
     x_1=Coor_x_l0(data_raw[i].index-index_0_b); y_1=Coor_y_l1(data_raw[i].l0_ST80);

     if ((x_1 > x_0 ) OR PLOT_ALL ) { 
          XDrawLine(my_display, my_window, my_gc, x_0,y_0, x_1,y_1);
	  x_0=x_1; y_0=y_1;
	}

   } // end while

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
 }

   if ( ovr1_l2 ) { 
   XAllocNamedColor(my_display, cmap,set_color6, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   i=0; 
   while (data_raw[i].index < index_0_b) i++;
   x_0=Coor_x_l0(data_raw[i].index-index_0_b); y_0=Coor_y_l1(data_raw[i].l2_ST80);
   while ( (data_raw[i].index < index_0_e ) && ( i < raw_last_index) ){
     i++;
     x_1=Coor_x_l0(data_raw[i].index-index_0_b); y_1=Coor_y_l1(data_raw[i].l2_ST80);

     if ((x_1 > x_0 ) OR PLOT_ALL ) { 
          XDrawLine(my_display, my_window, my_gc, x_0,y_0, x_1,y_1);
	  x_0=x_1; y_0=y_1;
	}

   } // end while

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
 }

   if ( ovr1_app ) { 
   XAllocNamedColor(my_display, cmap,set_color3, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   i=0; 
   while (data_raw[i].index < index_0_b) i++;
   x_0=Coor_x_l0(data_raw[i].index-index_0_b); y_0=Coor_y_l1(data_raw[i].lin_v[1]);
   while ( (data_raw[i].index < index_0_e ) && ( i < raw_last_index) ){
     i++;
     x_1=Coor_x_l0(data_raw[i].index-index_0_b); y_1=Coor_y_l1(data_raw[i].lin_v[1]);

     if ((x_1 > x_0 ) OR PLOT_ALL ) { 
          XDrawLine(my_display, my_window, my_gc, x_0,y_0, x_1,y_1);
	  x_0=x_1; y_0=y_1;
	}

   } // end while

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
 }
   XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);

   i=0; 
   while (data_raw[i].index < index_0_b) i++;
   raw_display_begin=i;
   x_0=Coor_x_l0(data_raw[i].index-index_0_b);  
   if (status_unsubtracted1 ) {y_0=Coor_y_l1(data_raw[i].l1_ST80);}
    else  {y_0=Coor_y_l1(data_raw[i].sub_v[1]);}
   if (lead1_plot_button_status.HRRaw ) { y1_0=170-data_raw[i].HR/2; 
					  XDrawString(my_display, my_window, my_gc, 2,161, "Heart Rate Raw [bpm]",20);}

   if (lead1_plot_button_status.STslRaw ) { y1_0=60+Coor_y_l1(data_raw[i].l1_ST80-data_raw[i].l1_ST20); 
                                            XDrawString(my_display, my_window, my_gc, 2,161, "ST Slope Raw [uV]",17);}

   if ((lead1_plot_button_status.Episodes ) && (references_index[1] >= 0)) {
                                         XDrawString(my_display, my_window, my_gc, 2,161, "Episodes",8);}

   begmisx = -1; begmise = -1; ischonbegx = -1; ischonbege = -1;
   while ( (data_raw[i].index < index_0_e ) && ( i < raw_last_index) ){

    if ((lead1_plot_button_status.Episodes ) && (references_index[1] >= 0)) { 

     while (( references[1][ep_index].raw_index <= i ) && ( ep_index <= references_index[1] )){

       if (Is_code(1,ep_index,-1,1)){
	 if ( (ep_status_i == 0 ) && (ep_status_r == 0) && (ep_status_o == 0) ) { ep_status_i=1; pl_epi=TRUE; pl_epii=TRUE;}
	 else { epi_error = TRUE; pl_epi=FALSE;  pl_epii=FALSE; }       }
       if (Is_code(1,ep_index,2,1)){
	 if (( ep_status_i == 1  ) && (ep_status_r == 0) && (ep_status_o == 0)) { ep_status_i=2; pl_epi=TRUE; pl_epii=TRUE;}
	 else { if (ep_status_i == 0) begmisx = i; ischonbegx = i; epi_error = TRUE; pl_epi=FALSE;  pl_epii=FALSE;}       }
       if (Is_code(1,ep_index,-3,1)){
	 if (( ep_status_i == 2  ) && (ep_status_r == 0) && (ep_status_o == 0)) { ep_status_i=0; pl_epi=FALSE; pl_epii=FALSE;}
	 else { if (ep_status_i == 0) begmise = i; ischonbege = i; epi_error = TRUE; pl_epi=FALSE;  pl_epii=FALSE;}       }

        if (Is_code(1,ep_index,-1,7)){
	 if (( ep_status_r == 0  ) && (ep_status_i == 0) && (ep_status_o == 0)) { ep_status_r=1; pl_epi=TRUE;}
	 else { epi_error = TRUE; pl_epi=FALSE; }       }
       if (Is_code(1,ep_index,2,7)){
	 if (( ep_status_r == 1  ) && (ep_status_i == 0) && (ep_status_o == 0)) { ep_status_r=2; pl_epi=TRUE;}
	 else { if (ep_status_r == 0) begmisx = i; epi_error = TRUE; pl_epi=FALSE; }       }
       if (Is_code(1,ep_index,-3,7)){
	 if (( ep_status_r == 2  ) && (ep_status_i == 0) && (ep_status_o == 0)) { ep_status_r=0; pl_epi=FALSE;}
	 else { if (ep_status_r == 0) begmise = i; epi_error = TRUE; pl_epi=FALSE; }       }

      if (Is_code(1,ep_index,-1,11)){
	 if (( ep_status_o == 0  ) && (ep_status_r == 0) && (ep_status_i == 0)) { ep_status_o=1; pl_epi=TRUE;}
	 else { epi_error = TRUE; pl_epi=FALSE; }       }
       if (Is_code(1,ep_index,2,11)){
	 if (( ep_status_o == 1  ) && (ep_status_r == 0) && (ep_status_i == 0)) { ep_status_o=2; pl_epi=TRUE;}
	 else { if (ep_status_o == 0) begmisx = i; epi_error = TRUE; pl_epi=FALSE; }       }
       if (Is_code(1,ep_index,-3,11)){
	 if (( ep_status_o == 2  ) && (ep_status_r == 0) && (ep_status_i == 0)) { ep_status_o=0; pl_epi=FALSE;}
	 else { if (ep_status_o == 0) begmise = i; epi_error = TRUE; pl_epi=FALSE; }       }

       if ( epi_error) sprintf(message2, "Time: %14s",mstimstr(data_raw[references[1][ep_index].raw_index].index)); 
       ep_index++; 

      if ((ep_index > references_index[1] ) && ((ep_status_i != 0) || (ep_status_r != 0) || (ep_status_o != 0)) ) {
	   epi_error=TRUE;
           sprintf(message2, "Time: %14s",mstimstr(data_raw[references[1][references_index[1]].raw_index].index)); 

       }

       if ( epi_error && epi_error_first )  {

           strcpy(message1,"Lead 1: Inconsistent episode !");
//
//           warning_message(2);
//
           epi_error=FALSE; ep_status_i=0; ep_status_r=0; ep_status_o=0; epi_error_first=FALSE; }
     }

       if (pl_epi) {
	  XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
	  XDrawLine(my_display, my_window, my_gc, x_0,116, x_0,120);
//	  XDrawLine(my_display, my_window, my_gc, x_0,146, x_0,150);
	  XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);
	  //	  pl_epi=ep_status != 0;
		   }
//       if (pl_epii) {
//	  XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
//	  XDrawLine(my_display, my_window, my_gc, x_0,136, x_0,140);
//	  XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);
//	  //	  pl_epi=ep_status != 0;
//		   }
   } // end episodes

     i++;
     x_1=Coor_x_l0(data_raw[i].index-index_0_b);
     if (status_unsubtracted1) {y_1=Coor_y_l1(data_raw[i].l1_ST80);}
       else  {y_1=Coor_y_l1(data_raw[i].sub_v[1]);}

     if ((x_1 > x_0 ) OR PLOT_ALL ) { 
          XDrawLine(my_display, my_window, my_gc, x_0,y_0, x_1,y_1);
	  XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
	  XDrawLine(my_display, my_window, my_gc, x_0,156, x_0,160);
	  XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);

	  if (lead1_plot_button_status.HRRaw ){
	    y1_1=170-data_raw[i].HR/2;
	    XDrawLine(my_display, my_window, my_gc, x_0,y1_0, x_1,y1_1);
	    y1_0=y1_1;
	  }

	  if (lead1_plot_button_status.STslRaw ){
	    y1_1=60+Coor_y_l1(data_raw[i].l1_ST80-data_raw[i].l1_ST20);
	    XDrawLine(my_display, my_window, my_gc, x_0,y1_0, x_1,y1_1);
	    y1_0=y1_1;
	  }
	  x_0=x_1; y_0=y_1;
	}

   } // end while

	  XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
	  XDrawLine(my_display, my_window, my_gc, x_0,156, x_0,160);
	  XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);

   if (begmisx != -1 && begmise != -1) {
      j=begmise; begmisx = begmise = -1;
      x_x=Coor_x_l0(data_raw[j].index-index_0_b);  
      while ( (data_raw[j].index >= index_0_b ) && ( j >= 0) ) {
	  XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
	  XDrawLine(my_display, my_window, my_gc, x_x,116, x_x,120);
//	  XDrawLine(my_display, my_window, my_gc, x_x,146, x_x,150);
	  XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);
	  j--;
          x_x=Coor_x_l0(data_raw[j].index-index_0_b);  
      }
   }

//   if (ischonbegx != -1 && ischonbege != -1) {
//      j=ischonbegx; ischonbegx = ischonbege = -1;
//      x_x=Coor_x_l0(data_raw[j].index-index_0_b);  
//      while ( (data_raw[j].index >= index_0_b ) && ( j >= 0) ) {
//	  XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
//	  XDrawLine(my_display, my_window, my_gc, x_x,136, x_x,140);
//	  XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);
//	  j--;
//          x_x=Coor_x_l0(data_raw[j].index-index_0_b);  
//      }
//   }

   raw_display_end=i-1;

    fin_display_end=raw_display_end; 
     while ( (data_fin[fin_display_end].index < index_0_e) && ( fin_display_end < fin_last_index) )     fin_display_end++; 
    fin_display_end=fin_display_end-1; 

   i=0;  
   while (data_fin[i].index < index_0_b) i++;
   fin_display_begin=i;

   if  (lead1_plot_button_status.HRate OR lead1_plot_button_status.STFine OR lead1_plot_button_status.STslFine OR lead1_plot_button_status.ISOJ ){ 

   x_0=Coor_x_l0(data_fin[i].index-index_0_b);
   if (lead1_plot_button_status.HRate ) { y_0=170-data_fin[i].HR/2; XDrawString(my_display, my_window, my_gc, 2,161, "Heart Rate [bpm]",16);}
   if (lead1_plot_button_status.STFine ) { y_0=60+Coor_y_l1(data_fin[i].l1_ST80); 
					   XDrawString(my_display, my_window, my_gc, 2,161, "ST Fine [uV]",12);}
   if (lead1_plot_button_status.STslFine ) { y_0=60+Coor_y_l1(data_fin[i].l1_ST80-data_fin[i].l1_ST20); 
					     XDrawString(my_display, my_window, my_gc, 2,161, "ST Slope Fine [uV]",18);}

    if (lead1_plot_button_status.ISOJ ) { y_0=(long)(160-1000.0*(data_fin[i].nISO +data_fin[i].nJ)/FSAMP/3); 
					  XDrawString(my_display, my_window, my_gc, 2,161, "ISO - J [ms]",12);}
  while ( (data_fin[i].index < index_0_e) && ( i < fin_last_index) ) {
     i++;
     x_1=Coor_x_l0(data_fin[i].index-index_0_b); 
     if (lead1_plot_button_status.HRate ) y_1=170-data_fin[i].HR/2;
     if (lead1_plot_button_status.STFine ) y_1=60+Coor_y_l1(data_fin[i].l1_ST80);
     if (lead1_plot_button_status.STslFine ) y_1=60+Coor_y_l1(data_fin[i].l1_ST80-data_fin[i].l1_ST20);
     if (lead1_plot_button_status.ISOJ )  y_1=(long)(160-1000.0*(data_fin[i].nISO +data_fin[i].nJ)/FSAMP/3); 
     if ((x_1 > x_0 ) OR PLOT_ALL ) { 
          XDrawLine(my_display, my_window, my_gc, x_0,y_0, x_1,y_1);
	  XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
	  XDrawLine(my_display, my_window, my_gc, x_0,160, x_0,163);
	  XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);

	  x_0=x_1; y_0=y_1;
	}

        } // end while
	  XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
	  XDrawLine(my_display, my_window, my_gc, x_0,160, x_0,163);
	  XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);
    fin_display_end=i-1; 
     } // if hrate

   if ( references_index[1] >= 0 ){
     for (i=0; i <= references_index[1]; i++){
       if ( (data_raw[references[1][i].raw_index].index >= index_0_b) && (data_raw[references[1][i].raw_index].index <= index_0_e) ) {
	 act_loc=FALSE;
	 if ( Is_code(1,i,0,0) ){
	    act_loc= act_reference[1].set && ( act_reference[1].typ == 2 ) && (act_reference[1].index == i);

            if (( i == reference_act[1] ) OR act_loc ) {
	      XAllocNamedColor(my_display, cmap,set_color1, &col, & unused);
	      XSetForeground(my_display, my_gc, col.pixel);
	    }
	    x_0=Coor_x_l0(data_raw[references[1][i].raw_index].index-index_0_b);

	    XDrawLine(my_display, my_window, my_gc, x_0,10, x_0,160);
	    XDrawString(my_display, my_window, my_gc, x_0 - 10 ,10, "LR",2);
            if (( i == reference_act[1] ) OR act_loc ) {
	      XAllocNamedColor(my_display, cmap,"black", &col, & unused);
	      XSetForeground(my_display, my_gc, col.pixel);
	    }
	 } 
	 else  // other ref
	 {
            if ( i == reference_act[1] ) {
	      XAllocNamedColor(my_display, cmap,set_color2, &col, & unused);
	      XSetForeground(my_display, my_gc, col.pixel);
	    }
	    x_0=Coor_x_l0(data_raw[references[1][i].raw_index].index-index_0_b);

	    XDrawLine(my_display, my_window, my_gc, x_0,10, x_0,160);
	    get_display_code(1,i);
	    XDrawString(my_display, my_window, my_gc, x_0 - 10 ,10, ref_code,2);
            if ( i == reference_act[1] ) {
	      XAllocNamedColor(my_display, cmap,"black", &col, & unused);
	      XSetForeground(my_display, my_gc, col.pixel);
	    }
	 }
       }
     } // end for
   } // plot ref.
   

   if ( loc_interval_b[1].set  && (data_raw[loc_interval_b[1].raw_index].index >= index_0_b) && (data_raw[loc_interval_b[1].raw_index].index <= index_0_e) ) {
   x_0=Coor_x_l0(data_raw[loc_interval_b[1].raw_index].index-index_0_b);
   XAllocNamedColor(my_display, cmap,set_color3, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   XDrawLine(my_display, my_window, my_gc, x_0,10, x_0,160);
   XDrawString(my_display, my_window, my_gc, x_0 - 9 ,20, "B",1);

  }

   if ( loc_interval_e[1].set  && (data_raw[loc_interval_e[1].raw_index].index >= index_0_b) && (data_raw[loc_interval_e[1].raw_index].index <= index_0_e) ) {
   x_0=Coor_x_l0(data_raw[loc_interval_e[1].raw_index].index-index_0_b);
   XAllocNamedColor(my_display, cmap,set_color3, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   XDrawLine(my_display, my_window, my_gc, x_0,10, x_0,160);
   XDrawString(my_display, my_window, my_gc, x_0 - 9 ,20, "E",1);

  }

   if ( global_set  && (data_raw[global_ref[1].raw_index].index >= index_0_b) && (data_raw[global_ref[1].raw_index].index <= index_0_e) ) {
   XAllocNamedColor(my_display, cmap,set_color1, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   x_0=Coor_x_l0(data_raw[global_ref[1].raw_index].index-index_0_b);

   XDrawLine(my_display, my_window, my_gc, x_0,10, x_0,160);
   XDrawString(my_display, my_window, my_gc, x_0 - 10 ,10, "GR",2);

  }

  if ( Marker[1].set  && (data_raw[Marker[1].raw_index].index >= index_0_b) && (data_raw[Marker[1].raw_index].index <= index_0_e) ) {
   XAllocNamedColor(my_display, cmap,set_color3, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   x_0=Coor_x_l0(data_raw[Marker[1].raw_index].index-index_0_b);

   XDrawLine(my_display, my_window, my_gc, x_0,10, x_0,160);
   XDrawString(my_display, my_window, my_gc, x_0 - 11 ,20, "M",1);

   x_1=Coor_x_l0(data_fin[Marker[1].fine_index].index-index_0_b);
   if ( x_1 == x_0) x_1++;
   XDrawLine(my_display, my_window, my_gc, x_1,80, x_1,160);

  } // end marker

   XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

} // end draw_lead1_A(void)

void draw_lead2_A(void)
{
long i, begmisx, begmise, j, ischonbegx, ischonbege;
long x_0, x_1, x_x, y_0, y_1, y1_0,y1_1;
Bool act_loc;

 Bool pl_epi=FALSE, pl_epii=FALSE;
 Bool epi_error=FALSE, epi_error_first=TRUE;
 long ep_index=0;
 int ep_status_i=0, ep_status_r=0, ep_status_o=0;

   index_0_b=TimeToIndex(diagram_time_begin_lead);
   index_0_e=TimeToIndex(diagram_time_begin_lead+time_scale_0);
   index_0=index_0_b;

   XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);

   if ( ovr2_l0 ) { 
     XAllocNamedColor(my_display, cmap,set_color4, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   i=0; 
   while (data_raw[i].index < index_0_b) i++;
   x_0=Coor_x_l0(data_raw[i].index-index_0_b); y_0=Coor_y_l2(data_raw[i].l0_ST80);
   while ( (data_raw[i].index < index_0_e ) && ( i < raw_last_index) ){
     i++;
     x_1=Coor_x_l0(data_raw[i].index-index_0_b); y_1=Coor_y_l2(data_raw[i].l0_ST80);

     if ((x_1 > x_0 ) OR PLOT_ALL ) { 
          XDrawLine(my_display, my_window, my_gc, x_0,y_0, x_1,y_1);
	  x_0=x_1; y_0=y_1;
	}

   } // end while

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

 }
   if ( ovr2_l1 ) { 
     XAllocNamedColor(my_display, cmap,set_color5, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   i=0; 
   while (data_raw[i].index < index_0_b) i++;
   x_0=Coor_x_l0(data_raw[i].index-index_0_b); y_0=Coor_y_l2(data_raw[i].l1_ST80);
   while ( (data_raw[i].index < index_0_e ) && ( i < raw_last_index) ){
     i++;
     x_1=Coor_x_l0(data_raw[i].index-index_0_b); y_1=Coor_y_l2(data_raw[i].l1_ST80);

     if ((x_1 > x_0 ) OR PLOT_ALL ) { 
          XDrawLine(my_display, my_window, my_gc, x_0,y_0, x_1,y_1);
	  x_0=x_1; y_0=y_1;
	}

   } // end while

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
 }

   if ( ovr2_app ) { 
   XAllocNamedColor(my_display, cmap,set_color3, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   i=0; 
   while (data_raw[i].index < index_0_b) i++;
   x_0=Coor_x_l0(data_raw[i].index-index_0_b); y_0=Coor_y_l2(data_raw[i].lin_v[2]);
   while ( (data_raw[i].index < index_0_e ) && ( i < raw_last_index) ){
     i++;
     x_1=Coor_x_l0(data_raw[i].index-index_0_b); y_1=Coor_y_l2(data_raw[i].lin_v[2]);

     if ((x_1 > x_0 ) OR PLOT_ALL ) { 
          XDrawLine(my_display, my_window, my_gc, x_0,y_0, x_1,y_1);
	  x_0=x_1; y_0=y_1;
	}

   } // end while

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
 }

   XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);

   i=0; 
   while (data_raw[i].index < index_0_b) i++;
   raw_display_begin=i;
   x_0=Coor_x_l0(data_raw[i].index-index_0_b);  
   if (status_unsubtracted2 ) {y_0=Coor_y_l2(data_raw[i].l2_ST80);}
    else  {y_0=Coor_y_l2(data_raw[i].sub_v[2]);}
   if (lead2_plot_button_status.HRRaw ) { y1_0=170-data_raw[i].HR/2; 
					  XDrawString(my_display, my_window, my_gc, 2,161, "Heart Rate Raw [bpm]",20);}

   if (lead2_plot_button_status.STslRaw ) { y1_0=60+Coor_y_l2(data_raw[i].l2_ST80-data_raw[i].l2_ST20); 
                                            XDrawString(my_display, my_window, my_gc, 2,161, "ST Slope Raw [uV]",17);}

   if ((lead2_plot_button_status.Episodes ) && (references_index[2] >= 0)) {
                                         XDrawString(my_display, my_window, my_gc, 2,161, "Episodes",8);}

   begmisx = -1; begmise = -1; ischonbegx = -1; ischonbege = -1;
   while ( (data_raw[i].index < index_0_e ) && ( i < raw_last_index) ){

   if ((lead2_plot_button_status.Episodes ) && (references_index[2] >= 0)) { 

     while (( references[2][ep_index].raw_index <= i ) && ( ep_index <= references_index[2] )){

       if (Is_code(2,ep_index,-1,1)){
	 if ( (ep_status_i == 0 ) && (ep_status_r == 0) && (ep_status_o == 0) ) { ep_status_i=1; pl_epi=TRUE; pl_epii=TRUE;}
	 else { epi_error = TRUE; pl_epi=FALSE; pl_epii=FALSE;}       }
       if (Is_code(2,ep_index,2,1)){
	 if (( ep_status_i == 1  ) && (ep_status_r == 0) && (ep_status_o == 0)) { ep_status_i=2; pl_epi=TRUE; pl_epii=TRUE;}
	 else { if (ep_status_i == 0) begmisx = i; ischonbegx = i; epi_error = TRUE; pl_epi=FALSE; pl_epii=FALSE;}       }
       if (Is_code(2,ep_index,-3,1)){
	 if (( ep_status_i == 2  ) && (ep_status_r == 0) && (ep_status_o == 0)) { ep_status_i=0; pl_epi=FALSE; pl_epii=FALSE;}
	 else { if (ep_status_i == 0) begmise = i; ischonbege = i; epi_error = TRUE; pl_epi=FALSE; pl_epii=FALSE;}       }

        if (Is_code(2,ep_index,-1,7)){
	 if (( ep_status_r == 0  ) && (ep_status_i == 0) && (ep_status_o == 0)) { ep_status_r=1; pl_epi=TRUE;}
	 else { epi_error = TRUE; pl_epi=FALSE; }       }
       if (Is_code(2,ep_index,2,7)){
	 if (( ep_status_r == 1  ) && (ep_status_i == 0) && (ep_status_o == 0)) { ep_status_r=2; pl_epi=TRUE;}
	 else { if (ep_status_r == 0) begmisx = i; epi_error = TRUE; pl_epi=FALSE; }       }
       if (Is_code(2,ep_index,-3,7)){
	 if (( ep_status_r == 2  ) && (ep_status_i == 0) && (ep_status_o == 0)) { ep_status_r=0; pl_epi=FALSE;}
	 else { if (ep_status_r == 0) begmise = i; epi_error = TRUE; pl_epi=FALSE; }       }

      if (Is_code(2,ep_index,-1,11)){
	 if (( ep_status_o == 0  ) && (ep_status_r == 0) && (ep_status_i == 0)) { ep_status_o=1; pl_epi=TRUE;}
	 else { epi_error = TRUE; pl_epi=FALSE; }       }
       if (Is_code(2,ep_index,2,11)){
	 if (( ep_status_o == 1  ) && (ep_status_r == 0) && (ep_status_i == 0)) { ep_status_o=2; pl_epi=TRUE;}
	 else { if (ep_status_o == 0) begmisx = i; epi_error = TRUE; pl_epi=FALSE; }       }
       if (Is_code(2,ep_index,-3,11)){
	 if (( ep_status_o == 2  ) && (ep_status_r == 0) && (ep_status_i == 0)) { ep_status_o=0; pl_epi=FALSE;}
	 else { if (ep_status_o == 0) begmise = i; epi_error = TRUE; pl_epi=FALSE; }       }

       if ( epi_error) sprintf(message2, "Time: %14s",mstimstr(data_raw[references[2][ep_index].raw_index].index)); 
       ep_index++; 

      if ((ep_index > references_index[2] ) && ((ep_status_i != 0) || (ep_status_r != 0) || (ep_status_o != 0)) ) {
	   epi_error=TRUE;
           sprintf(message2, "Time: %14s",mstimstr(data_raw[references[2][references_index[2]].raw_index].index)); 

       }

       if ( epi_error && epi_error_first )  {

           strcpy(message1,"Lead 2: Inconsistent episode !");
//
//           warning_message(2);
//
           epi_error=FALSE; ep_status_i=0; ep_status_r=0; ep_status_o=0; epi_error_first=FALSE; }
     }

       if (pl_epi) {
	  XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
	  XDrawLine(my_display, my_window, my_gc, x_0,116, x_0,120);
//	  XDrawLine(my_display, my_window, my_gc, x_0,146, x_0,150);
	  XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);
		   }
//       if (pl_epii) {
//	  XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
//	  XDrawLine(my_display, my_window, my_gc, x_0,136, x_0,140);
//	  XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);
//	  //	  pl_epi=ep_status != 0;
//		   }
   } // end episodes

     i++;
     x_1=Coor_x_l0(data_raw[i].index-index_0_b);
     if (status_unsubtracted2 ) {y_1=Coor_y_l2(data_raw[i].l2_ST80);}
       else  {y_1=Coor_y_l2(data_raw[i].sub_v[2]);}

     if ((x_1 > x_0 ) OR PLOT_ALL ) { 
          XDrawLine(my_display, my_window, my_gc, x_0,y_0, x_1,y_1);
	  XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
	  XDrawLine(my_display, my_window, my_gc, x_0,156, x_0,160);
	  XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);

	  if (lead2_plot_button_status.HRRaw ){
	    y1_1=170-data_raw[i].HR/2;
	    XDrawLine(my_display, my_window, my_gc, x_0,y1_0, x_1,y1_1);
	    y1_0=y1_1;
	  }
   
	  if (lead2_plot_button_status.STslRaw ){
	    y1_1=60+Coor_y_l2(data_raw[i].l2_ST80-data_raw[i].l2_ST20);
	    XDrawLine(my_display, my_window, my_gc, x_0,y1_0, x_1,y1_1);
	    y1_0=y1_1;
	  }
	  x_0=x_1; y_0=y_1;
	}

   } // end while

	  XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
	  XDrawLine(my_display, my_window, my_gc, x_0,156, x_0,160);
	  XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);

   if (begmisx != -1 && begmise != -1) {
      j=begmise; begmisx = begmise = -1;
      x_x=Coor_x_l0(data_raw[j].index-index_0_b);  
      while ( (data_raw[j].index >= index_0_b ) && ( j >= 0) ) {
	  XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
	  XDrawLine(my_display, my_window, my_gc, x_x,116, x_x,120);
//	  XDrawLine(my_display, my_window, my_gc, x_x,146, x_x,150);
	  XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);
	  j--;
          x_x=Coor_x_l0(data_raw[j].index-index_0_b);  
      }
   }

//   if (ischonbegx != -1 && ischonbege != -1) {
//      j=ischonbegx; ischonbegx = ischonbege = -1;
//      x_x=Coor_x_l0(data_raw[j].index-index_0_b);  
//      while ( (data_raw[j].index >= index_0_b ) && ( j >= 0) ) {
//	  XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
//	  XDrawLine(my_display, my_window, my_gc, x_x,136, x_x,140);
//	  XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);
//	  j--;
//          x_x=Coor_x_l0(data_raw[j].index-index_0_b);  
//      }
//   }

   raw_display_end=i-1;

    fin_display_end=raw_display_end; 
    while ( (data_fin[fin_display_end].index < index_0_e) && ( fin_display_end < fin_last_index) )     fin_display_end++; 
    fin_display_end=fin_display_end-1; 

   i=0;  
   while (data_fin[i].index < index_0_b) i++;
   fin_display_begin=i;

   if  (lead2_plot_button_status.HRate OR lead2_plot_button_status.STFine OR lead2_plot_button_status.STslFine OR lead2_plot_button_status.ISOJ ){ 

   x_0=Coor_x_l0(data_fin[i].index-index_0_b);
   if (lead2_plot_button_status.HRate ) { y_0=170-data_fin[i].HR/2; XDrawString(my_display, my_window, my_gc, 2,161, "Heart Rate [bpm]",16);}
   if (lead2_plot_button_status.STFine ) { y_0=60+Coor_y_l2(data_fin[i].l2_ST80); 
					   XDrawString(my_display, my_window, my_gc, 2,161, "ST Fine [uV]",12);}
   if (lead2_plot_button_status.STslFine ) { y_0=60+Coor_y_l2(data_fin[i].l2_ST80-data_fin[i].l2_ST20); 
					     XDrawString(my_display, my_window, my_gc, 2,161, "ST Slope Fine [uV]",18);}

    if (lead2_plot_button_status.ISOJ ) { y_0=(long)(160-1000.0*(data_fin[i].nISO +data_fin[i].nJ)/FSAMP/3); 
					  XDrawString(my_display, my_window, my_gc, 2,161, "ISO - J [ms]",12);}
  while ( (data_fin[i].index < index_0_e) && ( i < fin_last_index) ) {
     i++;
     x_1=Coor_x_l0(data_fin[i].index-index_0_b); 
     if (lead2_plot_button_status.HRate ) y_1=170-data_fin[i].HR/2;
     if (lead2_plot_button_status.STFine ) y_1=60+Coor_y_l2(data_fin[i].l2_ST80);
     if (lead2_plot_button_status.STslFine ) y_1=60+Coor_y_l2(data_fin[i].l2_ST80-data_fin[i].l2_ST20);
     if (lead2_plot_button_status.ISOJ )  y_1=(long)(160-1000.0*(data_fin[i].nISO +data_fin[i].nJ)/FSAMP/3); 
     if ((x_1 > x_0 ) OR PLOT_ALL ) { 
          XDrawLine(my_display, my_window, my_gc, x_0,y_0, x_1,y_1);
	  XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
	  XDrawLine(my_display, my_window, my_gc, x_0,160, x_0,163);
	  XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);

	  x_0=x_1; y_0=y_1;
	}

        } // end while
	  XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
	  XDrawLine(my_display, my_window, my_gc, x_0,160, x_0,163);
	  XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);
    fin_display_end=i-1; 
     } // if hrate

   if ( references_index[2] >= 0 ){
     for (i=0; i <= references_index[2]; i++){
       if ( (data_raw[references[2][i].raw_index].index >= index_0_b) && (data_raw[references[2][i].raw_index].index <= index_0_e) ) {
	 act_loc=FALSE;
	 if ( Is_code(2,i,0,0) ){
	    act_loc= act_reference[2].set && ( act_reference[2].typ == 2 ) && (act_reference[2].index == i);

            if (( i == reference_act[2] ) OR act_loc ) {
	      XAllocNamedColor(my_display, cmap,set_color1, &col, & unused);
	      XSetForeground(my_display, my_gc, col.pixel);
	    }
	    x_0=Coor_x_l0(data_raw[references[2][i].raw_index].index-index_0_b);

	    XDrawLine(my_display, my_window, my_gc, x_0,10, x_0,160);
	    XDrawString(my_display, my_window, my_gc, x_0 - 10 ,10, "LR",2);
            if (( i == reference_act[2] ) OR act_loc ) {
	      XAllocNamedColor(my_display, cmap,"black", &col, & unused);
	      XSetForeground(my_display, my_gc, col.pixel);
	    }
	 } 
	 else  // other ref
	 {
            if ( i == reference_act[2] ) {
	      XAllocNamedColor(my_display, cmap,set_color2, &col, & unused);
	      XSetForeground(my_display, my_gc, col.pixel);
	    }
	    x_0=Coor_x_l0(data_raw[references[2][i].raw_index].index-index_0_b);

	    XDrawLine(my_display, my_window, my_gc, x_0,10, x_0,160);
	    get_display_code(2,i);
	    XDrawString(my_display, my_window, my_gc, x_0 - 10 ,10, ref_code,2);
            if ( i == reference_act[2] ) {
	      XAllocNamedColor(my_display, cmap,"black", &col, & unused);
	      XSetForeground(my_display, my_gc, col.pixel);
	    }
	 }
       }
     } // end for
   } // plot ref.
   
   if ( loc_interval_b[2].set  && (data_raw[loc_interval_b[2].raw_index].index >= index_0_b) && (data_raw[loc_interval_b[2].raw_index].index <= index_0_e) ) {
   x_0=Coor_x_l0(data_raw[loc_interval_b[2].raw_index].index-index_0_b);
   XAllocNamedColor(my_display, cmap,set_color3, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   XDrawLine(my_display, my_window, my_gc, x_0,10, x_0,160);
   XDrawString(my_display, my_window, my_gc, x_0 - 9 ,20, "B",1);

  }

   if ( loc_interval_e[2].set  && (data_raw[loc_interval_e[2].raw_index].index >= index_0_b) && (data_raw[loc_interval_e[2].raw_index].index <= index_0_e) ) {
   x_0=Coor_x_l0(data_raw[loc_interval_e[2].raw_index].index-index_0_b);
   XAllocNamedColor(my_display, cmap,set_color3, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   XDrawLine(my_display, my_window, my_gc, x_0,10, x_0,160);
   XDrawString(my_display, my_window, my_gc, x_0 - 9 ,20, "E",1);

  }

   if ( global_set  && (data_raw[global_ref[2].raw_index].index >= index_0_b) && (data_raw[global_ref[2].raw_index].index <= index_0_e) ) {
   XAllocNamedColor(my_display, cmap,set_color1, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   x_0=Coor_x_l0(data_raw[global_ref[2].raw_index].index-index_0_b);

   XDrawLine(my_display, my_window, my_gc, x_0,10, x_0,160);
   XDrawString(my_display, my_window, my_gc, x_0 - 10 ,10, "GR",2);
  }

  if ( Marker[2].set  && (data_raw[Marker[2].raw_index].index >= index_0_b) && (data_raw[Marker[2].raw_index].index <= index_0_e) ) {
   XAllocNamedColor(my_display, cmap,set_color3, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   x_0=Coor_x_l0(data_raw[Marker[2].raw_index].index-index_0_b);

   XDrawLine(my_display, my_window, my_gc, x_0,10, x_0,160);
   XDrawString(my_display, my_window, my_gc, x_0 - 11 ,20, "M",1);

   x_1=Coor_x_l0(data_fin[Marker[2].fine_index].index-index_0_b);
   if ( x_1 == x_0) x_1++;
   XDrawLine(my_display, my_window, my_gc, x_1,80, x_1,160);

  } // end marker

   XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

} // end draw_lead2_A(void)

void draw_grid_lead0(int lead)
{

Bool draw_type_B, draw_type_C, draw_type_D, draw_type_E;

	switch(lead){
	case 0: my_display=l_b_display; my_window=l_b_window; my_gc= gcLead0;
	  draw_type_B=lead0_plot_button_status.HRate OR lead0_plot_button_status.HRRaw;
	  draw_type_C=lead0_plot_button_status.STFine OR lead0_plot_button_status.STslFine OR 
	    lead0_plot_button_status.STslRaw ;
	  draw_type_D=lead0_plot_button_status.Episodes;
	  draw_type_E=lead0_plot_button_status.ISOJ;
	  break;
	case 1: my_display=l_b1_display; my_window=l_b1_window; my_gc= gcLead1;
	  draw_type_B=lead1_plot_button_status.HRate OR lead1_plot_button_status.HRRaw;
	  draw_type_C=lead1_plot_button_status.STFine OR lead1_plot_button_status.STslFine OR 
	    lead1_plot_button_status.STslRaw ;
	  draw_type_D=lead1_plot_button_status.Episodes;
	  draw_type_E=lead1_plot_button_status.ISOJ;
	  break;
	case 2: my_display=l_b2_display; my_window=l_b2_window; my_gc= gcLead2;
	  draw_type_B=lead2_plot_button_status.HRate OR lead2_plot_button_status.HRRaw;
	  draw_type_C=lead2_plot_button_status.STFine OR lead2_plot_button_status.STslFine OR 
	    lead2_plot_button_status.STslRaw ;
	  draw_type_D=lead2_plot_button_status.Episodes;
	  draw_type_E=lead2_plot_button_status.ISOJ;
	  break;
	}

XGCValues line_type;
long c_Time=0, hours=0,hours_l=0,  minutes=0, seconds=0;
char pr_time[8];
int i,j, lx, lxx, ampl, imax;
long x_0, x_1, y_0, y_1;

   XClearWindow(my_display, my_window);
   XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);

   cmap=XDefaultColormap(my_display, DefaultScreen(my_display));
   XAllocNamedColor(my_display, cmap,"white", &col, & unused);
   XSetBackground(my_display, my_gc, col.pixel);
   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
	
   XDrawLine(my_display, my_window, my_gc, 1120, 0, 1120,180);
   XDrawLine(my_display, my_window, my_gc, 160, 0, 160,180);
   XDrawLine(my_display, my_window, my_gc, 160,60, 1120,60);
   XDrawLine(my_display, my_window, my_gc, 160,120, 1120,120);

   line_type.line_style=LineOnOffDash;
   XChangeGC(my_display, my_gc, GCLineStyle,&line_type);
   
   XDrawLine(my_display, my_window, my_gc, 160,10, 1120,10);
   XDrawLine(my_display, my_window, my_gc, 160,20, 1120,20);
   XDrawLine(my_display, my_window, my_gc, 160,30, 1120,30);
   XDrawLine(my_display, my_window, my_gc, 160,40, 1120,40);
   XDrawLine(my_display, my_window, my_gc, 160,50, 1120,50);

   XDrawLine(my_display, my_window, my_gc, 160,70, 1120,70);
   XDrawLine(my_display, my_window, my_gc, 160,80, 1120,80);
   XDrawLine(my_display, my_window, my_gc, 160,90, 1120,90);
   XDrawLine(my_display, my_window, my_gc, 160,100, 1120,100);
   XDrawLine(my_display, my_window, my_gc, 160,110, 1120,110);

   XDrawLine(my_display, my_window, my_gc, 160,130, 1120,130);
   XDrawLine(my_display, my_window, my_gc, 160,140, 1120,140);
   XDrawLine(my_display, my_window, my_gc, 160,150, 1120,150);
   XDrawLine(my_display, my_window, my_gc, 160,160, 1120,160);

   XDrawString(my_display, my_window, my_gc, 142,20, " 2",2);
   XDrawString(my_display, my_window, my_gc, 142,40, " 1",2);
   XDrawString(my_display, my_window, my_gc, 142,60, " 0",2);
   XDrawString(my_display, my_window, my_gc, 142,80, "-1",2);

   XDrawLine(my_display, my_window, my_gc, 1120, 0, 1120,180);
   XDrawLine(my_display, my_window, my_gc, 160, 0, 160,180);
   XDrawLine(my_display, my_window, my_gc, 160,60, 1120,60);
   XDrawLine(my_display, my_window, my_gc, 160,120, 1120,120);
	
   line_type.line_style=LineOnOffDash;
   XChangeGC(my_display, my_gc, GCLineStyle,&line_type);
   
   XDrawLine(my_display, my_window, my_gc, 160,10, 1120,10);
   XDrawLine(my_display, my_window, my_gc, 160,20, 1120,20);
   XDrawLine(my_display, my_window, my_gc, 160,30, 1120,30);
   XDrawLine(my_display, my_window, my_gc, 160,40, 1120,40);
   XDrawLine(my_display, my_window, my_gc, 160,50, 1120,50);
   XDrawLine(my_display, my_window, my_gc, 160,70, 1120,70);
   XDrawLine(my_display, my_window, my_gc, 160,80, 1120,80);
   XDrawLine(my_display, my_window, my_gc, 160,90, 1120,90);
   XDrawLine(my_display, my_window, my_gc, 160,100, 1120,100);
   XDrawLine(my_display, my_window, my_gc, 160,110, 1120,110);
   XDrawLine(my_display, my_window, my_gc, 160,130, 1120,130);
   XDrawLine(my_display, my_window, my_gc, 160,140, 1120,140);
   XDrawLine(my_display, my_window, my_gc, 160,150, 1120,150);
   XDrawLine(my_display, my_window, my_gc, 160,160, 1120,160);

   XDrawLine(my_display, my_window, my_gc, 240,10, 240,180);
   XDrawLine(my_display, my_window, my_gc, 320,10, 320,180);
   XDrawLine(my_display, my_window, my_gc, 400,10, 400,180);
   XDrawLine(my_display, my_window, my_gc, 480,10, 480,180);
   XDrawLine(my_display, my_window, my_gc, 560,10, 560,180);
   XDrawLine(my_display, my_window, my_gc, 640,10, 640,180);
   XDrawLine(my_display, my_window, my_gc, 720,10, 720,180);
   XDrawLine(my_display, my_window, my_gc, 800,10, 800,180);
   XDrawLine(my_display, my_window, my_gc, 880,10, 880,180);
   XDrawLine(my_display, my_window, my_gc, 960,10, 960,180);
   XDrawLine(my_display, my_window, my_gc, 1040,10, 1040,180);

   line_type.line_style=LineSolid;
   XChangeGC(my_display, gcLead0, GCLineStyle,&line_type);
   XDrawString(my_display, my_window, my_gc, 2,174, "[time]",6);
   sprintf(pr_buff, "[units] [uV] R:%s[%d]", inp_rec_name, lead);

   XDrawString(my_display, my_window, my_gc, 2,12,pr_buff, strlen(pr_buff));

   XAllocNamedColor(my_display, cmap,"white", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   XFillRectangle(my_display, my_window, my_gc, 1,54,130,38);

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   c_Time = diagram_time_begin_lead;
   for(i = 0; i < 12; i++)
   {
      TimeToHoursMinSec(c_Time, &hours, &minutes, &seconds, &hours_l);
      sprintf(pr_time, "%ld:%ld:%ld", hours_l, minutes, seconds);
      XDrawString(my_display, my_window, my_gc, (162 + i * 80), 174, pr_time, strlen(pr_time));
      c_Time +=scale_time_tick;
    }

  if (draw_type_B ){
     XDrawString(my_display, my_window, my_gc, 134,120, "100",3);
     XDrawString(my_display, my_window, my_gc, 136,140, " 60",3);

   }
   if (draw_type_C ){
     XDrawString(my_display, my_window, my_gc, 142,100, " 1",2);
     XDrawString(my_display, my_window, my_gc, 142,120, " 0",2);
     XDrawString(my_display, my_window, my_gc, 142,140, "-1",2);
   }

   if (draw_type_E ){
     XDrawString(my_display, my_window, my_gc, 134,120, "120",3);
     XDrawString(my_display, my_window, my_gc, 136,140, " 60",3);
   }

	switch(lead){
	case 0:
	  write_ref_data_l0();
	  draw_lead0_A();set_buttons_lead0();
	  break;
	case 1:
	  write_ref_data_l1();
	  draw_lead1_A();set_buttons_lead1();
	  break;
	case 2:
	  write_ref_data_l2();
	  draw_lead2_A();set_buttons_lead2();
	  break;
	} // end lead
} // end draw_grid_lead0

void draw_ovrly_coeff(void)
{
int i;
long x_0, x_1, y_0, y_1;
   
   my_display=k_b_display; my_window=k_b_window; my_gc= gckoeff;
   XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);

   index_0_b=TimeToIndex(diagram_time_begin_lead);
   index_0_e=TimeToIndex(diagram_time_begin_lead+time_scale_0);
   index_0=index_0_b;

   if (  ovr_coef ) { 

   XAllocNamedColor(my_display, cmap,"white", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   XFillRectangle(my_display, my_window, my_gc, 100,144,30,14);
   XAllocNamedColor(my_display, cmap,set_color3, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   i=raw_display_begin;
   x_0=Coor_x_l0(data_raw[i].index-index_0_b);
  
   if ( KL_coefficents ) {
        y_0=(long)(157-(double(data_raw[i].ST_f) /5.0 /ampl_c));
      }
    else {
        y_0=(long)(157-(double(data_raw[i].QRS_f) /5.0 /ampl_c));
    }

   while ( (data_raw[i].index < index_0_e ) && ( i < raw_last_index) ){
     i++;
     x_1=Coor_x_l0(data_raw[i].index-index_0_b);
   if ( KL_coefficents ) {
        y_1=(long)(157-(double(data_raw[i].ST_f) /5.0 /ampl_c));
      }
    else {
        y_1=(long)(157-(double(data_raw[i].QRS_f) /5.0 /ampl_c));
    }

     if ((x_1 > x_0 ) OR PLOT_ALL ) { 
          XDrawLine(my_display, my_window, my_gc, x_0,y_0, x_1,y_1);
	  x_0=x_1; y_0=y_1;
	}

   } // end while

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   XDrawString(my_display, my_window, my_gc, 5,157, "KL 5 ......................Dist..",34);
 }
} // end draw_ovrly_coeff(void);

void draw_grid_coeff(void)
{
	my_display=k_b_display; my_window=k_b_window; my_gc= gckoeff;

XGCValues line_type;
long c_Time=0, hours=0,hours_l=0,  minutes=0, seconds=0;
char pr_time[8], pr_m[1];
int i,j, lx, lxx, ampl, imax;
long x_0, x_1, y_0, y_1;

   XClearWindow(my_display, my_window);
   XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);

   cmap=XDefaultColormap(my_display, DefaultScreen(my_display));
   XAllocNamedColor(my_display, cmap,"white", &col, & unused);
   XSetBackground(my_display, my_gc, col.pixel);
   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
	
   XDrawLine(my_display, my_window, my_gc, 1120, 0, 1120,196);
   XDrawLine(my_display, my_window, my_gc, 160, 0, 160,196);
   XDrawLine(my_display, my_window, my_gc, 160,37, 1120,37);
   XDrawLine(my_display, my_window, my_gc, 160,67, 1120,67);
   XDrawLine(my_display, my_window, my_gc, 160,97, 1120,97);
   XDrawLine(my_display, my_window, my_gc, 160,127, 1120,127);
   XDrawLine(my_display, my_window, my_gc, 160,157, 1120,157);

   line_type.line_style=LineOnOffDash;
   XChangeGC(my_display, my_gc, GCLineStyle,&line_type);
   
   XDrawLine(my_display, my_window, my_gc, 160,7, 1120,7);
   XDrawLine(my_display, my_window, my_gc, 160,17, 1120,17);
   XDrawLine(my_display, my_window, my_gc, 160,27, 1120,27);

   XDrawLine(my_display, my_window, my_gc, 160,47, 1120,47);
   XDrawLine(my_display, my_window, my_gc, 160,57, 1120,57);

   XDrawLine(my_display, my_window, my_gc, 160,77, 1120,77);
   XDrawLine(my_display, my_window, my_gc, 160,87, 1120,87);

   XDrawLine(my_display, my_window, my_gc, 160,107, 1120,107);
   XDrawLine(my_display, my_window, my_gc, 160,117, 1120,117);

   XDrawLine(my_display, my_window, my_gc, 160,137, 1120,137);
   XDrawLine(my_display, my_window, my_gc, 160,147, 1120,147);

   XDrawLine(my_display, my_window, my_gc, 160,167, 1120,167);
   XDrawLine(my_display, my_window, my_gc, 160,177, 1120,177);

   XDrawString(my_display, my_window, my_gc, 145,17, " 1",2);
   XDrawString(my_display, my_window, my_gc, 145,37, " 0",2);
   XDrawString(my_display, my_window, my_gc, 145,67, " 0",2);
   XDrawString(my_display, my_window, my_gc, 145,97, " 0",2);
   XDrawString(my_display, my_window, my_gc, 145,127, " 0",2);
   XDrawString(my_display, my_window, my_gc, 145,157, " 0",2);
   XDrawString(my_display, my_window, my_gc, 145,177, "-1",2);

   XDrawString(my_display, my_window, my_gc, 145,47, " 1",2);
   XDrawString(my_display, my_window, my_gc, 145,77, " 1",2);
   XDrawString(my_display, my_window, my_gc, 145,107, " 1",2);
   XDrawString(my_display, my_window, my_gc, 145,137, " 1",2);

   XDrawLine(my_display, my_window, my_gc, 240,7, 240,180);
   XDrawLine(my_display, my_window, my_gc, 320,7, 320,180);
   XDrawLine(my_display, my_window, my_gc, 400,7, 400,180);
   XDrawLine(my_display, my_window, my_gc, 480,7, 480,180);
   XDrawLine(my_display, my_window, my_gc, 560,7, 560,180);
   XDrawLine(my_display, my_window, my_gc, 640,7, 640,180);
   XDrawLine(my_display, my_window, my_gc, 720,7, 720,180);
   XDrawLine(my_display, my_window, my_gc, 800,7, 800,180);
   XDrawLine(my_display, my_window, my_gc, 880,7, 880,180);
   XDrawLine(my_display, my_window, my_gc, 960,7, 960,180);
   XDrawLine(my_display, my_window, my_gc, 1040,7, 1040,180);

   line_type.line_style=LineSolid;
   XChangeGC(my_display, gcLead0, GCLineStyle,&line_type);
   XDrawString(my_display, my_window, my_gc, 2,190, "[time]",6);

   sprintf(pr_buff, "[units] [std] R:%s", inp_rec_name);

   XDrawString(my_display, my_window, my_gc, 2,12,pr_buff, strlen(pr_buff));

   c_Time = diagram_time_begin_lead;
   for(i = 0; i < 12; i++)
   {
      TimeToHoursMinSec(c_Time, &hours, &minutes, &seconds, &hours_l);
      sprintf(pr_time, "%ld:%ld:%ld", hours, minutes, seconds);
      XDrawString(my_display, my_window, my_gc, (162 + i * 80), 190, pr_time, strlen(pr_time));
      c_Time +=scale_time_tick;
    }

int k1_0, k2_0, k3_0, k4_0, k5_0, k1_1, k2_1, k3_1, k4_1, k5_1;

   index_0_b=TimeToIndex(diagram_time_begin_lead);
   index_0_e=TimeToIndex(diagram_time_begin_lead+time_scale_0);
   index_0=index_0_b;

	XDrawString(my_display, my_window, my_gc, 5,37, "KL 1 ..................................",40);
	XDrawString(my_display, my_window, my_gc, 5,67, "KL 2 ..................................",40);
	XDrawString(my_display, my_window, my_gc, 5,97, "KL 3 ..................................",40);
	XDrawString(my_display, my_window, my_gc, 5,127, "KL 4 ..................................",40);
	XDrawString(my_display, my_window, my_gc, 5,157, "KL 5 ..................................",40);

   XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);

   i=0; 
   while (data_raw[i].index < index_0_b) i++;
   raw_display_begin=i;
   x_0=Coor_x_l0(data_raw[i].index-index_0_b);
   if (  KL_coefficents ) {
        k1_0=(int)(37-(double(data_raw[i].STk1) /5.0 /ampl_c));
        k2_0=(int)(67-(double(data_raw[i].STk2) /5.0 /ampl_c));
        k3_0=(int)(97-(double(data_raw[i].STk3) /5.0 /ampl_c));
        k4_0=(int)(127-(double(data_raw[i].STk4) /5.0 /ampl_c));
        k5_0=(int)(157-(double(data_raw[i].STk5) /5.0 /ampl_c));

      }
    else {
        k1_0=(int)(37-(double(data_raw[i].QRSk1) /5.0 /ampl_c));
        k2_0=(int)(67-(double(data_raw[i].QRSk2) /5.0 /ampl_c));
        k3_0=(int)(97-(double(data_raw[i].QRSk3) /5.0 /ampl_c));
        k4_0=(int)(127-(double(data_raw[i].QRSk4) /5.0 /ampl_c));
        k5_0=(int)(157-(double(data_raw[i].QRSk5) /5.0 /ampl_c));
    }

   while ( (data_raw[i].index < index_0_e ) && ( i < raw_last_index) ){
     i++;
     x_1=Coor_x_l0(data_raw[i].index-index_0_b); 
   if ( KL_coefficents ) {
        k1_1=(int)(37-(double(data_raw[i].STk1) /5.0 /ampl_c));
        k2_1=(int)(67-(double(data_raw[i].STk2) /5.0 /ampl_c));
        k3_1=(int)(97-(double(data_raw[i].STk3) /5.0 /ampl_c));
        k4_1=(int)(127-(double(data_raw[i].STk4) /5.0 /ampl_c));
        k5_1=(int)(157-(double(data_raw[i].STk5) /5.0 /ampl_c));

      }
    else {
        k1_1=(int)(37-(double(data_raw[i].QRSk1) /5.0 /ampl_c));
        k2_1=(int)(67-(double(data_raw[i].QRSk2) /5.0 /ampl_c));
        k3_1=(int)(97-(double(data_raw[i].QRSk3) /5.0 /ampl_c));
        k4_1=(int)(127-(double(data_raw[i].QRSk4) /5.0 /ampl_c));
        k5_1=(int)(157-(double(data_raw[i].QRSk5) /5.0 /ampl_c));

    }

     if ((x_1 > x_0 ) OR PLOT_ALL ) { 
          XDrawLine(my_display, my_window, my_gc, x_0,k1_0, x_1,k1_1); k1_0=k1_1;
          XDrawLine(my_display, my_window, my_gc, x_0,k2_0, x_1,k2_1); k2_0=k2_1;
          XDrawLine(my_display, my_window, my_gc, x_0,k3_0, x_1,k3_1); k3_0=k3_1;
          XDrawLine(my_display, my_window, my_gc, x_0,k4_0, x_1,k4_1); k4_0=k4_1;
          XDrawLine(my_display, my_window, my_gc, x_0,k5_0, x_1,k5_1); k5_0=k5_1;
	  x_0=x_1; 
	}

   } // end while
 raw_display_end=i-1;
 draw_ovrly_coeff();

  for (i=0; i<= 2; i++){
  if ( Marker[i].set  && (data_raw[Marker[i].raw_index].index >= index_0_b) && (data_raw[Marker[i].raw_index].index <= index_0_e) ) {
       XAllocNamedColor(my_display, cmap,set_color3, &col, & unused);
       XSetForeground(my_display, my_gc, col.pixel);

       x_0=Coor_x_l0(data_raw[Marker[i].raw_index].index-index_0_b);

       XDrawLine(my_display, my_window, my_gc, x_0,10, x_0,177);
       sprintf(pr_m,"%d",i);
       XDrawString(my_display, my_window, my_gc, x_0 - 6 ,10, pr_m,1);

     } // end marker
 }

   XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

} // end draw_grid_coeff

void data_new_r_read(void)
{

long i,j,i_fin;
long data_b_0, data_e_0, t_index;
char time[15], time_b[15],time_e[15];
long R_end;

   data_b_0=reference_mstime_index - (150 * FSAMP + FSAMP / 2 ); // - 150 sec= 2.5 min  as max display offset + 1/2 avr ( 1000 ms /2 )
   data_e_0=reference_mstime_index + (150 * FSAMP + FSAMP / 2 ); // + 150 sec as max display offset

   i=LEN_BUFF_D-1;
   while ( data_b_0 < 0 ){
     L_buff_R[0][i]=0; L_buff_R[1][i]=0; L_buff_R[2][i]=0; L_buff_R[3][i]=0; L_buff_R[4][i]=0; L_buff_R[5][i]=0;
     data_b_0++;
     i--;
   }  

   t_index=data_b_0;

   i_fin=0; 
   while ( data_fin[i_fin].index < t_index ) i_fin++;
   isigsettime(data_b_0);  
   
     while ( i >= 0 ) {
      if (getvec(v_sample) <= 0) 
      {
         fprintf(stderr,"Error reading data (1)\n"); 
         exit(-1);
      }

      for (j = 0; j< nsig; j++)
         L_buff_R[j][i]=v_sample[j];
      L_buff_R[4][i]=t_index; 
      if ( t_index == data_fin[i_fin].index ) { 
             L_buff_R[5][i]=1; i_fin++;
	   }
        else  {
             L_buff_R[5][i]=0;
            }
      t_index++;
      i--;
    }

      for (j = 0; j< 6; j++)
         R_buff_R[j][0]= L_buff_R[j][0];

   i=1;
   R_end= LEN_BUFF_D;
   while ( data_raw[raw_last_index].index < data_e_0  ){
     R_buff_R[0][data_e_0]=0; R_buff_R[1][data_e_0]=0; R_buff_R[2][data_e_0]=0; R_buff_R[3][data_e_0]=0; R_buff_R[4][data_e_0]=0; R_buff_R[5][data_e_0]=0;
     data_e_0--;
      R_end--;
   }  

     while ( i < R_end ) {
      if (getvec(v_sample) <= 0) 
      {
         fprintf(stderr,"Error reading data (2)\n"); 
         exit(-1);
      }

      for (j = 0; j< nsig; j++)
         R_buff_R[j][i]=v_sample[j];
      R_buff_R[4][i]=t_index; 
      if ( t_index == data_fin[i_fin].index ) { 
             R_buff_R[5][i]=1; i_fin++;
	   }
        else  {
             R_buff_R[5][i]=0;
            }
      t_index++;
      i++;
    }

 i--;  

} // end data_new_r_read

void data_new_m_read(void)
{

long i,j,i_fin;
long data_b_0, data_e_0, t_index;
char time[15], time_b[15],time_e[15];
 long R_end;

   data_b_0=data_mstime_index - (150 * FSAMP + FSAMP / 2 ); // - 150 sec= 2.5 min  as max display offset + 1/2 avr ( 1000 ms /2 )
   data_e_0=data_mstime_index + (150 * FSAMP + FSAMP / 2 ); // + 150 sec as max display offset

   i=LEN_BUFF_D-1;
   while ( data_b_0 < 0 ){
     L_buff_M[0][i]=0; L_buff_M[1][i]=0; L_buff_M[2][i]=0; L_buff_M[3][i]=0; L_buff_M[4][i]=0; L_buff_M[5][i]=0;
     data_b_0++;
     i--;
   }  

   t_index=data_b_0;

   i_fin=0; 
   while ( data_fin[i_fin].index < t_index ) i_fin++;
   isigsettime(data_b_0);  
   
   while ( i >= 0 )
   {
      if (getvec(v_sample) <= 0) 
      {
         fprintf(stderr,"Error reading data (3)\n"); 
         exit(-1);
      }

      for (j = 0; j< nsig; j++)
         L_buff_M[j][i]=v_sample[j];
      L_buff_M[4][i]=t_index; 
      if ( t_index == data_fin[i_fin].index ) { 
             L_buff_M[5][i]=1; i_fin++;
	   }
        else  {
             L_buff_M[5][i]=0;
            }
      t_index++;
      i--;
    }

   for (j = 0; j< 6; j++)
         R_buff_M[j][0]= L_buff_M[j][0];

   i=1;
   
   R_end= LEN_BUFF_D-1;
   while ( data_raw[raw_last_index].index < data_e_0  ){
     R_buff_M[0][R_end]=0; R_buff_M[1][R_end]=0; R_buff_M[2][R_end]=0; R_buff_M[3][R_end]=0; R_buff_M[4][R_end]=0; R_buff_M[5][R_end]=0;
     data_e_0--;
      R_end--;
   }  

   while ( i < R_end)
   {
      if (getvec(v_sample) <= 0) 
      {
         fprintf(stderr,"Error reading data (4)\n"); 
         exit(-1);
      }

      for (j = 0; j< nsig; j++)
         R_buff_M[j][i]=v_sample[j];
      R_buff_M[4][i]=t_index; 
      if ( t_index == data_fin[i_fin].index ) { 
             R_buff_M[5][i]=1; i_fin++;
	   }
        else  {
             R_buff_M[5][i]=0;
            }
      t_index++;
      i++;
    }

 i--;  

} // end data_new_m_read

void data_plot_marker_x(int Data_lead_x, int pos)
{
long d_display_index;
long j;
long i;
long x_0, x_1, y_0, y_1, y_s;
float y;
long x;
char time[15], time_b[15];
float v_iso, v_j, v_j80;

   XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);

   d_display_index= data_scale * FSAMP / 2;

  	  v_iso =  avr_in_avrbeat(Data_lead_x, Marker[Data_lead].nISO,Marker[Data_lead].NS);
  	  v_j =  avr_in_avrbeat(Data_lead_x,- Marker[Data_lead].nJ,Marker[Data_lead].NS);
  	  v_j80 =  avr_in_avrbeat(Data_lead_x,- Marker[Data_lead].nJ80,Marker[Data_lead].NS);

    i=d_display_index;

   y=L_buff_M[Data_lead_x][i]- v_iso;
   x=L_buff_M[4][i]-L_buff_M[4][d_display_index];
   x_0=Coor_x_data(x); y_0=Coor_y_data_M(y)+pos;

   while ( i > d_avrg_index ){ 

    i--;
     y=L_buff_M[Data_lead_x][i]- v_iso;
     x=L_buff_M[4][i]-L_buff_M[4][d_display_index];
     x_1=Coor_x_data(x); y_1=Coor_y_data_M(y)+pos;

     if ( L_buff_M[5][i] == 1 ) XDrawString(my_display, my_window, my_gc, x_0,191, "*",1);
	   
     if ((x_1 > x_0 ) OR PLOT_ALL ) { 
          XDrawLine(my_display, my_window, my_gc, x_0,y_0, x_1,y_1);
	  x_0=x_1; y_0=y_1;
	}

   } // end while
   XDrawLine(my_display, my_window, my_gc, x_0,y_0-10, x_0,y_0+10);

   i = d_avrg_index;
   y=A_buff_M[Data_lead_x][125-i]- v_iso;
   x=L_buff_M[4][i]-L_buff_M[4][d_display_index];
   x_0=Coor_x_data(x); y_0=Coor_y_data_M(y)+pos;
   XDrawLine(my_display, my_window, my_gc, x_0,y_0-10, x_0,y_0+10);
   
   while ( i > -d_avrg_index ){ 

     if (( i ==  Marker[Data_lead].nISO ) && ( data_scale < 3 ))
     {
       y_s=Coor_y_data_M(0.0)+pos;
       plot_point_symbol(set_marker, x_0, y_s);
     }
      if (( -i ==  Marker[Data_lead].nJ )  && ( data_scale < 3 )) {
       y_s=Coor_y_data_M(v_j- v_iso)+pos;
       plot_point_symbol(set_marker, x_0, y_s);
     }

     i--;
     y=A_buff_M[Data_lead_x][125-i]- v_iso;
     if ( i >= 0 ) { x=L_buff_M[4][i]-L_buff_M[4][d_display_index];     
                     if ( L_buff_M[5][i] == 1 ) XDrawString(my_display, my_window, my_gc, x_0,191, "*",1);

		   }
        else  { x=R_buff_M[4][-i]-L_buff_M[4][d_display_index]; 
                if ( R_buff_M[5][-i] == 1 ) XDrawString(my_display, my_window, my_gc, x_0,191, "*",1);
               }
     x_1=Coor_x_data(x); y_1=Coor_y_data_M(y)+pos;

     if ((x_1 > x_0 ) OR PLOT_ALL ) { 
          XDrawLine(my_display, my_window, my_gc, x_0,y_0, x_1,y_1);
	  x_0=x_1; y_0=y_1;
	}
      if (( -i ==  Marker[Data_lead].nJ80 ) && ( data_scale < 3 )) {
       y_s=Coor_y_data_M(v_j80 - v_iso)+pos;
       plot_point_symbol(set_marker, x_0, y_s);
     }

   } // end while
   XDrawLine(my_display, my_window, my_gc, x_0,y_0-10, x_0,y_0+10);

   i = d_avrg_index;
   y=R_buff_M[Data_lead_x][i]- v_iso;
   x=R_buff_M[4][i]-L_buff_M[4][d_display_index];
   x_0=Coor_x_data(x); y_0=Coor_y_data_M(y)+pos;
   XDrawLine(my_display, my_window, my_gc, x_0,y_0-10, x_0,y_0+10);
   while ( i < d_display_index ){ 
     i++;
     y=R_buff_M[Data_lead_x][i]- v_iso;
     x=R_buff_M[4][i]-L_buff_M[4][d_display_index];
     x_1=Coor_x_data(x); y_1=Coor_y_data_M(y)+pos;

     if ( R_buff_M[5][i] == 1 ) XDrawString(my_display, my_window, my_gc, x_0,191, "*",1);
	   
     if ((x_1 > x_0 ) OR PLOT_ALL ) { 
          XDrawLine(my_display, my_window, my_gc, x_0,y_0, x_1,y_1);
	  x_0=x_1; y_0=y_1;
	}

   } // end while

   XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);

} // data_plot_marker_x

void data_plot_marker(void)
{
int pos0, pos1, pos2, posx;

   pos0=0; pos1=0; pos2=0; posx=0;

   if ( data_ovrly_shift ) {  pos0= -40; pos1=0; pos2=40;
			      switch ( Data_lead){
			       case 0: posx=pos0; break;
			       case 1: posx=pos1; break;
			       case 2: posx=pos2; break;
			      };
			    };
   if ( data_ovr_l0 ) { 
   XAllocNamedColor(my_display, cmap,set_color4, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   data_plot_marker_x(0,pos0);

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

 }

   if ( data_ovr_l1 ) { 
   XAllocNamedColor(my_display, cmap,set_color5, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   data_plot_marker_x(1,pos1);

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

 }
   if ( data_ovr_l2 ) { 
   XAllocNamedColor(my_display, cmap,set_color6, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   data_plot_marker_x(2,pos2);

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

 }

   data_plot_marker_x(Data_lead,posx);
} //  end  data_plot_marker 

void data_plot_ref_x(int Data_lead_x ,int pos, Bool plot_box, int Data_lead_x_act)
{

long d_display_index;

long j;
long i;
long x_0, x_1, y_0, y_1, y_s;
float y;
long x;
char time[15], time_b[15];
float v_iso, v_j, v_j80;

   XSetLineAttributes(my_display, my_gc,set_line_width, LineSolid, CapRound, JoinRound);

   d_display_index= data_scale * FSAMP / 2;

   i=d_display_index;

   v_iso =  avr_in_avrbeat_r(Data_lead_x, act_ref_data[Data_lead_x_act].nISO,act_ref_data[Data_lead_x_act].NS);
   v_j =  avr_in_avrbeat_r(Data_lead_x,- act_ref_data[Data_lead_x_act].nJ,act_ref_data[Data_lead_x_act].NS);
   v_j80 =  avr_in_avrbeat_r(Data_lead_x,- act_ref_data[Data_lead_x_act].nJ80,act_ref_data[Data_lead_x_act].NS);

   i=d_display_index;
   y=L_buff_R[Data_lead_x][i]-v_iso;
   x=L_buff_R[4][i]-L_buff_R[4][d_display_index];
   x_0=Coor_x_data(x); y_0=Coor_y_data_M(y)-180+pos;

   while ( i > d_avrg_index ){ 
     i--;
     y=L_buff_R[Data_lead_x][i]-v_iso;
     x=L_buff_R[4][i]-L_buff_R[4][d_display_index];
     x_1=Coor_x_data(x); y_1=Coor_y_data_M(y)-180+pos;

     if ( L_buff_R[5][i] == 1 ) XDrawString(my_display, my_window, my_gc, x_0,20, "*",1);
	   
     if ((x_1 > x_0 ) OR PLOT_ALL) { 
          XDrawLine(my_display, my_window, my_gc, x_0,y_0, x_1,y_1);
	  x_0=x_1; y_0=y_1;
	}

   } // end while
   XDrawLine(my_display, my_window, my_gc, x_0,y_0-10, x_0,y_0+10);

   i = d_avrg_index;
   y=A_buff_R[Data_lead_x][125-i]-v_iso;
   x=L_buff_R[4][i]-L_buff_R[4][d_display_index];
   x_0=Coor_x_data(x); y_0=Coor_y_data_M(y)-180+pos;
   XDrawLine(my_display, my_window, my_gc, x_0,y_0-10, x_0,y_0+10);
   
   while ( i > -d_avrg_index ){ 

     if (( i ==   act_ref_data[Data_lead_x_act].nISO )  && (plot_box ) && ( data_scale < 3 )){ 
       y_s=Coor_y_data_M(0.0)-180+pos;
       
       plot_point_symbol(set_marker, x_0, y_s);
     }

      if (( -i ==  act_ref_data[Data_lead_x_act].nJ  )  && (plot_box ) && ( data_scale < 3 )){
       y_s=Coor_y_data_M(v_j - v_iso)-180+pos;
       plot_point_symbol(set_marker, x_0, y_s);
     }

     i--;
     y=A_buff_R[Data_lead_x][125-i]- v_iso;
     if ( i >= 0 ) { x=L_buff_R[4][i]-L_buff_R[4][d_display_index]; 
		     if (( L_buff_R[5][i] == 1 )  && ( !data_ovr_ref)) XDrawString(my_display, my_window, my_gc, x_0,20, "*",1);
		   }
        else  { x=R_buff_R[4][-i]-L_buff_R[4][d_display_index];  
		if (( R_buff_R[5][-i] == 1 )  && ( !data_ovr_ref))  XDrawString(my_display, my_window, my_gc, x_0,20, "*",1);
	      }
     x_1=Coor_x_data(x); y_1=Coor_y_data_M(y)-180+pos;

     if ((x_1 > x_0 ) OR PLOT_ALL) { 
          XDrawLine(my_display, my_window, my_gc, x_0,y_0, x_1,y_1);
	  x_0=x_1; y_0=y_1;
	}

      if (( -i ==  act_ref_data[Data_lead_x_act].nJ80 )  && (plot_box ) && ( data_scale < 3 )){

       y_s=Coor_y_data_M(v_j80 - v_iso)-180+pos;
       plot_point_symbol(set_marker, x_0, y_s);
     }

   } // end while
   XDrawLine(my_display, my_window, my_gc, x_0,y_0-10, x_0,y_0+10);

   i = d_avrg_index;
   y=R_buff_R[Data_lead_x][i]- v_iso;
   x=R_buff_R[4][i]-L_buff_R[4][d_display_index];
   x_0=Coor_x_data(x); y_0=Coor_y_data_M(y)-180+pos;
   XDrawLine(my_display, my_window, my_gc, x_0,y_0-10, x_0,y_0+10);
   while ( i < d_display_index ){ 
     i++;
     y=R_buff_R[Data_lead_x][i]- v_iso;
     x=R_buff_R[4][i]-L_buff_R[4][d_display_index];
     x_1=Coor_x_data(x); y_1=Coor_y_data_M(y)-180+pos;

     if ( R_buff_R[5][i] == 1 ) XDrawString(my_display, my_window, my_gc, x_0,20, "*",1);
	   
     if ((x_1 > x_0 ) OR PLOT_ALL) { 
          XDrawLine(my_display, my_window, my_gc, x_0,y_0, x_1,y_1);
	  x_0=x_1; y_0=y_1;
	}

   } // end while

   XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);
} // data_plot_ref_x

void data_plot_reference(void)
{
long d_display_index;

char time[15], time_b[15];

int pos0, pos1, pos2, posx;

   pos0=0; pos1=0; pos2=0; posx=0;

   if ( data_ovrly_shift ) {  pos0= -40; pos1=0; pos2=40;
			      switch ( Data_lead){
			       case 0: posx=pos0; break;
			       case 1: posx=pos1; break;
			       case 2: posx=pos2; break;
			      };
			    };
   if ( data_ovr_l0 ) { 
   XAllocNamedColor(my_display, cmap,set_color4, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   data_plot_ref_x(0,pos0, TRUE, Data_lead);

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

 }

   if ( data_ovr_l1 ) { 
   XAllocNamedColor(my_display, cmap,set_color5, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   data_plot_ref_x(1,pos1, TRUE, Data_lead);

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
 }

   if ( data_ovr_l2 ) { 
   XAllocNamedColor(my_display, cmap,set_color6, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   data_plot_ref_x(2,pos2, TRUE, Data_lead);

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
 }

   if ( data_ovr_ref ) { 
   XAllocNamedColor(my_display, cmap,set_color3, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   data_plot_ref_x(Data_lead,posx+180, FALSE, Data_lead);

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

 }
   data_plot_ref_x(Data_lead,posx, TRUE, Data_lead);
} //  end  data_plot_reference 

void draw_grid_data(void)
{
XGCValues line_type;
int     i,x, x_0, x_1;
long    d_display_index;
float   v_j80, v_j20, v_iso, v_isor, v_j80r;

float   v_j80_str, v_j20_str, v_iso_str, v_isor_str, v_j80r_str;
int     v_j80_str_i, v_j20_str_i, v_slo_str_i, v_dev_str_i;

   d_display_index= data_scale * FSAMP / 2;

//   XClearWindow(my_display, my_window, 0, 0, 1128,1087);

   XAllocNamedColor(my_display, cmap,"white", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
   XFillRectangle(my_display, my_window, my_gc, 0, 0, 1128, 1087);  

   XSetLineAttributes(my_display, my_gc,1, LineSolid, CapRound, JoinRound);

   cmap=XDefaultColormap(my_display, DefaultScreen(my_display));

   XAllocNamedColor(my_display, cmap,set_color7, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
   x=L_buff_R[4][d_avrg_index]-L_buff_R[4][d_display_index];
   x_0=Coor_x_data(x);
   x=R_buff_R[4][d_avrg_index]-L_buff_R[4][d_display_index];
   x_1=Coor_x_data(x);

   if ( d_avrg_index > 0 ) XFillRectangle(my_display, my_window, my_gc, x_0,0,x_1-x_0,550); // 360

   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

   XDrawLine(my_display, my_window, my_gc, 1120, 0, 1120,550); //
   XDrawLine(my_display, my_window, my_gc, 160, 0, 160,550); //
   XDrawLine(my_display, my_window, my_gc, 160,90, 1120,90); //
   XDrawLine(my_display, my_window, my_gc, 160,180, 1120,180); //
   XDrawLine(my_display, my_window, my_gc, 160,270, 1120,270); //
   XDrawLine(my_display, my_window, my_gc, 160,550, 1120,550); //
   XDrawLine(my_display, my_window, my_gc, 640,0, 640,550); //

   line_type.line_style=LineOnOffDash;
   XChangeGC(my_display, my_gc, GCLineStyle,&line_type);
   
   XDrawLine(my_display, my_window, my_gc, 160,10, 1120,10);
   for (i=30; i <= 550; i+=20) // < 360
     XDrawLine(my_display, my_window, my_gc, 160,i, 1120,i);

      x=(int)data_grid_tick;
   i=1;
   while(x < 480)
   {
     XDrawLine(my_display, my_window, my_gc, 640 + x, 0, 640 + x, 550); // 360
      XDrawLine(my_display, my_window, my_gc, 639 - x, 0, 639 - x, 550); // 360
      i++;
      x = (int)(i * data_grid_tick);
   }

   XDrawString(my_display, my_window, my_gc, 143,10, " 2",2);
   XDrawString(my_display, my_window, my_gc, 143,50, " 1",2);
   XDrawString(my_display, my_window, my_gc, 143,90, " 0",2);
   XDrawString(my_display, my_window, my_gc, 143,130, "-1",2);
   XDrawString(my_display, my_window, my_gc, 143,170, "-2",2);
   XDrawString(my_display, my_window, my_gc, 143,190, " 2",2);
   XDrawString(my_display, my_window, my_gc, 143,230, " 1",2);
   XDrawString(my_display, my_window, my_gc, 143,270, " 0",2);
   XDrawString(my_display, my_window, my_gc, 143,310, "-1",2);
   XDrawString(my_display, my_window, my_gc, 143,350, "-2",2);
   XDrawString(my_display, my_window, my_gc, 143,390, "-3",2); //
   XDrawString(my_display, my_window, my_gc, 143,430, "-4",2); //
   XDrawString(my_display, my_window, my_gc, 143,470, "-5",2); //
   XDrawString(my_display, my_window, my_gc, 143,510, "-6",2); //
   XDrawString(my_display, my_window, my_gc, 143,550, "-7",2); //

   sprintf(pr_buff, "[units] [uV] R:%s", inp_rec_name);

   XDrawString(my_display, my_window, my_gc, 2,12,pr_buff, strlen(pr_buff));

     if ( act_reference[Data_lead].set ){
                          sprintf(pr_buff,"Refer.");   
                          XDrawString(my_display, my_window, my_gc, 2,90, pr_buff,strlen(pr_buff));
                          sprintf(pr_buff,"%s", mstimstr(data_fin[act_ref_data[Data_lead].fine_index].index));   
                          XDrawString(my_display, my_window, my_gc, 50,90, pr_buff,strlen(pr_buff));
 
			  v_isor =  avr_in_avrbeat_r(Data_lead, act_ref_data[Data_lead].nISO,act_ref_data[Data_lead].NS);
			  v_j80r =  avr_in_avrbeat_r(Data_lead,- act_ref_data[Data_lead].nJ80,act_ref_data[Data_lead].NS);

			}
                   else {
		          XDrawString(my_display, my_window, my_gc, 2,90, "NO Reference set .....",22);
			  v_isor=0.0;
			  v_j80r= avr_in_avrbeat(Data_lead,- Marker[Data_lead].nJ80,Marker[Data_lead].NS)
			          -avr_in_avrbeat(Data_lead, Marker[Data_lead].nISO,Marker[Data_lead].NS);
		   }
   if ( Marker[Data_lead].set ) { 
			  v_iso =  avr_in_avrbeat(Data_lead, Marker[Data_lead].nISO,Marker[Data_lead].NS);
			  v_j20 =  avr_in_avrbeat(Data_lead,- (Marker[Data_lead].nJ+5),Marker[Data_lead].NS);
			  v_j80 =  avr_in_avrbeat(Data_lead,- Marker[Data_lead].nJ80,Marker[Data_lead].NS);

   XAllocNamedColor(my_display, cmap,set_color8, &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);
   XFillRectangle(my_display, my_window, my_gc, 1,13,140,25);
   XAllocNamedColor(my_display, cmap,"black", &col, & unused);
   XSetForeground(my_display, my_gc, col.pixel);

	                  sprintf(pr_buff,"HRate:  %d [bpm]",Marker[Data_lead].fine_HR);   
                          XDrawString(my_display, my_window, my_gc, 2,36, pr_buff,strlen(pr_buff));

	                  sprintf(pr_buff,"Mean:");   
                          XDrawString(my_display, my_window, my_gc, 2,54, pr_buff,strlen(pr_buff));
	         if ( reference_act[Data_lead] == -1 && references_index[Data_lead] == -1) {
	                  sprintf(pr_buff,"%4d/%5d",Marker[Data_lead].NS, act_ref_data[Data_lead].NS );   
		 } else if ( reference_act[Data_lead] > -1 ) {
                         sprintf(pr_buff,"%4d/%4d",Marker[Data_lead].NS,
                                      references[Data_lead][reference_act[Data_lead]].NS  );   
		 } else {
                         sprintf(pr_buff,"%4d/%4s",Marker[Data_lead].NS, " " );   
		 }
                          XDrawString(my_display, my_window, my_gc, 46,54, pr_buff,strlen(pr_buff));
	                  sprintf(pr_buff,"[smp]");   
                          XDrawString(my_display, my_window, my_gc, 105,54, pr_buff,strlen(pr_buff));

	                  sprintf(pr_buff,"ABeat:");   
                          XDrawString(my_display, my_window, my_gc, 2,66, pr_buff,strlen(pr_buff));
	         if ( reference_act[Data_lead] == -1 && references_index[Data_lead] == -1) {
	                  sprintf(pr_buff,"%4d/%4d",Marker[Data_lead].window, act_ref_data[Data_lead].window );   
		 } else  if ( reference_act[Data_lead] > -1 ) {
                         sprintf(pr_buff,"%4d/%4d",Marker[Data_lead].window,
                                      references[Data_lead][reference_act[Data_lead]].window  );   
		 } else {
                         sprintf(pr_buff,"%4d/%4s",Marker[Data_lead].window, " ");
		 }
                          XDrawString(my_display, my_window, my_gc, 42,66, pr_buff,strlen(pr_buff));
	                  sprintf(pr_buff,"[sec]");   
                          XDrawString(my_display, my_window, my_gc, 112,66, pr_buff,strlen(pr_buff));

	                  strcpy(pr_buff,"PB:");   

	                  strcpy(pr_buff,"PE:");   

	                  sprintf(pr_buff,"ISO:");   

	         if ( reference_act[Data_lead] == -1 && references_index[Data_lead] == -1 ) {
	                  sprintf(pr_buff,"%4d/%4d",-1000* Marker[Data_lead].nISO/FSAMP,
				  -1000* act_ref_data[Data_lead].nISO/FSAMP);
		 } else if ( reference_act[Data_lead] > -1) {
	                  sprintf(pr_buff,"%4d/%4d",-1000* Marker[Data_lead].nISO/FSAMP,
				  -1000* references[Data_lead][reference_act[Data_lead]].nISO/FSAMP);
		 } else {
	                  sprintf(pr_buff,"%4d/%4s",-1000* Marker[Data_lead].nISO/FSAMP, " ");
		 }

	                  sprintf(pr_buff,"[ms]");   
	
	                  strcpy(pr_buff,"Q:");   

	                  sprintf(pr_buff,"J: ");   

	         if ( reference_act[Data_lead] == -1 && references_index[Data_lead] == -1 ) {
                          sprintf(pr_buff,"%4d/%4d",1000* Marker[Data_lead].nJ/FSAMP,
                                      1000* act_ref_data[Data_lead].nJ/FSAMP);
		 } else if ( reference_act[Data_lead] > -1 ) {
	                  sprintf(pr_buff,"%4d/%4d",1000* Marker[Data_lead].nJ/FSAMP,
                                      1000* references[Data_lead][reference_act[Data_lead]].nJ/FSAMP);
		 } else {
		   sprintf(pr_buff,"%4d/%4s",1000* Marker[Data_lead].nJ/FSAMP, " ");
		 }

	                  sprintf(pr_buff,"[ms]");   

	                  sprintf(pr_buff,"ST:");   

	         if ( reference_act[Data_lead] == -1 && references_index[Data_lead] == -1) {
	                  sprintf(pr_buff,"%4d/%4d", 1000*Marker[Data_lead].nJ80/FSAMP,
                                       1000* act_ref_data[Data_lead].nJ80/FSAMP);
		 } else  if ( reference_act[Data_lead] > -1 ) {
	                  sprintf(pr_buff,"%4d/%4d", 1000*Marker[Data_lead].nJ80/FSAMP,
                                       1000* references[Data_lead][reference_act[Data_lead]].nJ80/FSAMP);
		 } else {
		   sprintf(pr_buff,"%4d/%4s", 1000*Marker[Data_lead].nJ80/FSAMP, " ");
		 }

	                  sprintf(pr_buff,"[ms]");   

	                  strcpy(pr_buff,"TB:" );   

	                  strcpy(pr_buff,"TX:");   

	                  strcpy(pr_buff,"TE:" );   

                          sprintf(pr_buff,"Marker");   
                          XDrawString(my_display, my_window, my_gc, 2,270, pr_buff,strlen(pr_buff));
                          sprintf(pr_buff,"%s", mstimstr(data_fin[Marker[Data_lead].fine_index].index));   
                          XDrawString(my_display, my_window, my_gc, 50,270, pr_buff,strlen(pr_buff));

	         if ( reference_act[Data_lead] == -1) {
			    v_j80_str_i =  act_ref_data[Data_lead].ST80;
			    v_j20_str_i =  act_ref_data[Data_lead].ST80 -
			                   act_ref_data[Data_lead].STsl;
                            v_slo_str_i =  act_ref_data[Data_lead].STsl;
                            v_dev_str_i =  act_ref_data[Data_lead].STd;
		  } else {
			    v_j80_str_i =  references[Data_lead][reference_act[Data_lead]].ST80;
			    v_j20_str_i =  references[Data_lead][reference_act[Data_lead]].ST80 -
			                   references[Data_lead][reference_act[Data_lead]].STsl;
                            v_slo_str_i =  references[Data_lead][reference_act[Data_lead]].STsl;
                            v_dev_str_i =  references[Data_lead][reference_act[Data_lead]].STd;
	          }

                          sprintf(pr_buff,"ST80:");

			  if (reference_act[Data_lead] == -1 && references_index[Data_lead] > -1)
                                sprintf(pr_buff, "%6d/%6s", mk_uv(v_j80 - v_iso), " ");
                          else  sprintf(pr_buff, "%6d/%6d", mk_uv(v_j80 - v_iso), v_j80_str_i);

                          sprintf(pr_buff,"ST20:");

			  if (reference_act[Data_lead] == -1 && references_index[Data_lead] > -1)
                               sprintf(pr_buff, "%6d/%6s", mk_uv(v_j20 - v_iso), " ");
                          else sprintf(pr_buff, "%6d/%6d", mk_uv(v_j20 - v_iso), v_j20_str_i);

                          sprintf(pr_buff,"STsl:");

			  if (reference_act[Data_lead] == -1 && references_index[Data_lead] > -1)
                               sprintf(pr_buff, "%6d/%6s", mk_uv(v_j80- v_j20), " ");
                          else sprintf(pr_buff, "%6d/%6d", mk_uv(v_j80- v_j20), v_slo_str_i);

                          sprintf(pr_buff,"STdev:");

			  if (reference_act[Data_lead] == -1 && references_index[Data_lead] > -1)
                               sprintf(pr_buff,"%6d/%6s",mk_uv(v_j80- v_iso - (v_j80r-v_isor )), " ");
                          else sprintf(pr_buff,"%6d/%6d",mk_uv(v_j80- v_iso - (v_j80r-v_isor )),v_dev_str_i );

			}
                   else {
		          XDrawString(my_display, my_window, my_gc, 2,270, "NO Marker set ........",22);
		   }

   XDrawString(my_display, my_window, my_gc, 2, 24, "FINE MODE", 9);

   sprintf(pr_buff, "Time tick: %ld msec", data_tick);
   XDrawString(my_display, my_window, my_gc, 2, 358, pr_buff, strlen(pr_buff));
}; //  end  draw_grid_data

void get_average_M(void)
{
long i, j, l;
long n_av=1;

   current_nl=0; current_nr=0;

   for ( i= d_avrg_index; i >= 0; i--){
     for (j=0; j < 6; j++)
     {  A_buff_M[j][125-i]= L_buff_M[j][i];
        A_buff_M[j][125+i]= R_buff_M[j][i];}
   }

   for ( i=1; i <= current_average_window_index; i++) {
     if ( L_buff_M[5][i] == 1 ) { 
       n_av++; current_nl++;
       for (l=0; l < nsig; l++)
	 for ( j= d_avrg_index; j >= -d_avrg_index; j--)  A_buff_M[l][125-j] += L_buff_M[l][i+j];
     }
     if ( R_buff_M[5][i] == 1 ) { 
       n_av++; current_nr++;
       for (l=0; l < nsig; l++)
	 for ( j= d_avrg_index; j >= -d_avrg_index; j--)  A_buff_M[l][125-j] += R_buff_M[l][i-j];
     }

   }
   for ( i= d_avrg_index; i >=  -d_avrg_index; i--){
     for (j=0; j < nsig; j++)
      A_buff_M[j][125-i] = Round(( (double)A_buff_M[j][125-i]) / n_av);
   }
} // end get_average_M

void get_average_R(void)
{
  long i, j, l, n_av=1;
long  ref_average_window_index;

   ref_average_window_index = current_average_window_index;

   for ( i= d_avrg_index; i >= 0; i--){
     for (j=0; j < nsig; j++)
       A_buff_R[j][125-i]= L_buff_R[j][i];
     for (j=0; j < nsig; j++)
       A_buff_R[j][125+i]= R_buff_R[j][i];
   }

   for ( i=1; i <= ref_average_window_index; i++) {
     if ( L_buff_R[5][i] == 1 ) { 
       n_av++;
       for (l=0; l < nsig; l++)
	 for ( j= d_avrg_index; j >= -d_avrg_index; j--)  A_buff_R[l][125-j] += L_buff_R[l][i+j];
     }
     if ( R_buff_R[5][i] == 1 ) { 
       n_av++;
       for (l=0; l < nsig; l++)
	 for ( j= d_avrg_index; j >= -d_avrg_index; j--)  A_buff_R[l][125-j] += R_buff_R[l][i-j];
     }

   }
   for ( i= d_avrg_index; i >=  -d_avrg_index; i--){
     for (j=0; j < nsig; j++)
      A_buff_R[j][125-i] = Round(( (double)A_buff_R[j][125-i]) / n_av);
   }
} // end get_average_R

void show_data(int leadx, Bool xx_lead, Bool xx_kl)
{

  if (xx_kl)  draw_grid_coeff();
  if (( leadx == Data_lead ) || xx_lead ) {

	my_display=d_b_display;
	my_window=d_b_window;
	my_gc=gcdata;

      if ( Marker[Data_lead].set ) {
       data_mstime_index= data_fin[Marker[Data_lead].fine_index].index;
       data_new_m_read();
       update_marker(Data_lead,999);
     }

    draw_grid_data();

     if ( Marker[Data_lead].set ) {
       data_plot_marker();
     }

     if ( act_reference[Data_lead].set ) {
       reference_mstime_index= data_fin[act_ref_data[Data_lead].fine_index].index; //r
       data_new_r_read(); //r
       get_average_R();  //r
      data_plot_reference();
     }
  }
} // end show_data

//**

void set_buttons_lead0()
{
  Bool selected;
  Bool loc_int_set;
  Bool sel_lr;

if (Lead0_buttons.Auto_s == 1) 
            { status_manual_mode=TRUE; }
	  else  
	    { status_manual_mode=FALSE;}
if (Lead0_buttons.Subtr_s == 1) 
               { xv_set(Sem_0_l_bw.l_b_Subtr, PANEL_LABEL_STRING, "Subtr", NULL);status_unsubtracted =TRUE; } 
	  else  
               { xv_set(Sem_0_l_bw.l_b_Subtr, PANEL_LABEL_STRING, "UnSubtr", NULL); status_unsubtracted =FALSE;}
if (Lead0_buttons.OvrApp_s == 1) 
               {xv_set(Sem_0_l_bw.l_b_OvrApp, PANEL_LABEL_STRING, "OvrApp", NULL);  ovr0_app = FALSE;}
	  else  
	       {xv_set(Sem_0_l_bw.l_b_OvrApp, PANEL_LABEL_STRING, "UnOvAp", NULL);  ovr0_app = TRUE;}

if (Lead0_buttons.ConsLR ){
if (Lead0_buttons.ConsLR_s == 1)
               { xv_set(Sem_0_l_bw.l_b_ConsLR, PANEL_LABEL_STRING, "ConsLR", NULL); status_consider_localref =TRUE;
	       sel_lr=Is_code(0,reference_act[0],0,0) && status_manual_mode && status_unsubtracted;} 
            else  
               {xv_set(Sem_0_l_bw.l_b_ConsLR, PANEL_LABEL_STRING, "ConsGR", NULL);  status_consider_localref =FALSE;
	       sel_lr=TRUE;}
 }

selected = reference_act[0] >= 0;
if (  status_manual_mode && !status_unsubtracted && Is_code(0,reference_act[0],0,0) ) selected=FALSE; 
loc_int_set = loc_interval_b[0].set && loc_interval_e[0].set; 

xv_set(Sem_0_l_bw.l_b_Mark, PANEL_INACTIVE,! Lead0_buttons.Mark,NULL);

xv_set(Sem_0_l_bw.l_b_Subtr, PANEL_INACTIVE,! Lead0_buttons.Subtr,NULL);
xv_set(Sem_0_l_bw.l_b_OvrApp, PANEL_INACTIVE,! Lead0_buttons.OvrApp,NULL);
xv_set(Sem_0_l_bw.l_b_OvrLds_menu, PANEL_INACTIVE,! Lead0_buttons.OvrLds,NULL);

xv_set(Sem_0_l_bw.l_b_Exm, PANEL_INACTIVE,! Lead0_buttons.Exm,NULL);
xv_set(Sem_0_l_bw.l_b_ConsLR, PANEL_INACTIVE,! (Lead0_buttons.ConsLR && sel_lr),NULL);

};// set_buttons_lead0

void set_buttons_lead0_start()
{

Lead0_buttons.Auto_s = 1; Lead0_buttons.Subtr_s=1; Lead0_buttons.OvrApp_s=1; Lead0_buttons.ConsLR_s=1;

Lead0_buttons.Mark=TRUE;Lead0_buttons.Dmy=FALSE; Lead0_buttons.Auto= FALSE; Lead0_buttons.Subtr=FALSE; Lead0_buttons.Cmpt= TRUE; 
Lead0_buttons.OvrApp= TRUE;  Lead0_buttons.OvrLds= TRUE; Lead0_buttons.GlR =TRUE; Lead0_buttons.SetLB= FALSE;
Lead0_buttons.SetLE= FALSE; Lead0_buttons.DelLI= FALSE; 
Lead0_buttons.Isc= FALSE; Lead0_buttons.Rate_r= FALSE;
Lead0_buttons.Cnd= FALSE; Lead0_buttons.AxS= FALSE; Lead0_buttons.Atr= FALSE;  Lead0_buttons.Exm= FALSE; Lead0_buttons.Move= FALSE;
Lead0_buttons.Del= FALSE; Lead0_buttons.DelA= FALSE; Lead0_buttons.ChAtr= FALSE; Lead0_buttons.ChAtrA= FALSE; 
Lead0_buttons.ConsLR= FALSE;
Lead0_buttons.LcRef= FALSE; Lead0_buttons.Cancel= FALSE; Lead0_buttons.Rpt= FALSE;	

};// set_buttons_lead0_start

void set_buttons_lead0_reset_all()
{
Lead0_buttons.Mark=FALSE; Lead0_buttons.Dmy=FALSE; Lead0_buttons.Auto= FALSE; Lead0_buttons.Subtr=FALSE; Lead0_buttons.Cmpt= TRUE; 
Lead0_buttons.OvrApp= TRUE;  Lead0_buttons.OvrLds= TRUE; Lead0_buttons.GlR =FALSE; Lead0_buttons.SetLB= FALSE;
Lead0_buttons.SetLE= FALSE; Lead0_buttons.DelLI= FALSE; Lead0_buttons.Isc= FALSE; Lead0_buttons.Rate_r= FALSE;
Lead0_buttons.Cnd= FALSE; Lead0_buttons.AxS= FALSE; Lead0_buttons.Atr= FALSE;  Lead0_buttons.Exm= FALSE; Lead0_buttons.Move= FALSE;
Lead0_buttons.Del= FALSE; Lead0_buttons.DelA= FALSE; Lead0_buttons.ChAtr= FALSE; Lead0_buttons.ChAtrA= FALSE; 
Lead0_buttons.ConsLR= FALSE;
Lead0_buttons.LcRef= FALSE; Lead0_buttons.Cancel= TRUE; Lead0_buttons.Rpt= FALSE;	

};// set_buttons_lead0_reset_all

void set_buttons_lead0_setGR()
{
   Lead0_buttons.Auto_s = 1;
   Lead0_buttons.Subtr_s= 1; 

   Lead0_buttons.ConsLR_s = 1;

Lead0_buttons.Mark=TRUE;Lead0_buttons.Dmy=TRUE; Lead0_buttons.Auto= TRUE; Lead0_buttons.Subtr=TRUE; Lead0_buttons.Cmpt= TRUE; 
Lead0_buttons.OvrApp= TRUE;  Lead0_buttons.OvrLds= TRUE; Lead0_buttons.GlR =TRUE; Lead0_buttons.SetLB= TRUE;
Lead0_buttons.SetLE= TRUE; Lead0_buttons.DelLI= loc_interval_b[0].set || loc_interval_e[0].set; 
Lead0_buttons.Isc= FALSE; Lead0_buttons.Rate_r= FALSE;
Lead0_buttons.Cnd= TRUE; Lead0_buttons.AxS= TRUE; Lead0_buttons.Atr= FALSE;  Lead0_buttons.Exm= TRUE; Lead0_buttons.Move= TRUE;
Lead0_buttons.Del= TRUE; Lead0_buttons.DelA= FALSE; Lead0_buttons.ChAtr= FALSE; Lead0_buttons.ChAtrA= FALSE; 
Lead0_buttons.ConsLR=  Is_code(0,reference_act[0],0,0) || !status_consider_localref;
Lead0_buttons.LcRef= TRUE; Lead0_buttons.Cancel= FALSE; Lead0_buttons.Rpt= FALSE;	

};// set_buttons_lead0_setGR

void set_buttons_lead0_unsubtr_manual()
{

     Lead0_buttons.ConsLR_s = 1;

Lead0_buttons.Mark=TRUE;Lead0_buttons.Dmy=TRUE; Lead0_buttons.Auto= TRUE; Lead0_buttons.Subtr=TRUE; Lead0_buttons.Cmpt= TRUE; 
Lead0_buttons.OvrApp= TRUE;  Lead0_buttons.OvrLds= TRUE; Lead0_buttons.GlR =TRUE; Lead0_buttons.SetLB= TRUE;
Lead0_buttons.SetLE= TRUE; Lead0_buttons.DelLI=  loc_interval_b[0].set || loc_interval_e[0].set; 
Lead0_buttons.Isc= FALSE; Lead0_buttons.Rate_r= FALSE;
Lead0_buttons.Cnd= TRUE; Lead0_buttons.AxS= TRUE; Lead0_buttons.Atr= FALSE;  Lead0_buttons.Exm= TRUE; Lead0_buttons.Move= TRUE;
Lead0_buttons.Del= TRUE; Lead0_buttons.DelA= FALSE; Lead0_buttons.ChAtr= FALSE; Lead0_buttons.ChAtrA= FALSE; 
Lead0_buttons.ConsLR=   Is_code(0,reference_act[0],0,0) || !status_consider_localref;

Lead0_buttons.LcRef= TRUE; Lead0_buttons.Cancel= FALSE; Lead0_buttons.Rpt= FALSE;	

};// set_buttons_lead0_unsubtr_manual

void set_buttons_lead0_subtr_manual()
{
     Lead0_buttons.ConsLR_s = 1;

Lead0_buttons.Mark=TRUE;Lead0_buttons.Dmy=FALSE; Lead0_buttons.Auto= TRUE; Lead0_buttons.Subtr=TRUE; Lead0_buttons.Cmpt= TRUE; 
Lead0_buttons.OvrApp= TRUE;  Lead0_buttons.OvrLds= TRUE; Lead0_buttons.GlR =FALSE; Lead0_buttons.SetLB= TRUE;
Lead0_buttons.SetLE= TRUE; Lead0_buttons.DelLI=  loc_interval_b[0].set || loc_interval_e[0].set; 
Lead0_buttons.Isc= FALSE; Lead0_buttons.Rate_r= FALSE;
Lead0_buttons.Cnd= FALSE; Lead0_buttons.AxS= FALSE; Lead0_buttons.Atr= TRUE;  Lead0_buttons.Exm= TRUE; Lead0_buttons.Move= TRUE;
Lead0_buttons.Del= TRUE; Lead0_buttons.DelA= FALSE; Lead0_buttons.ChAtr= TRUE; Lead0_buttons.ChAtrA= FALSE; 
Lead0_buttons.ConsLR= FALSE;
Lead0_buttons.LcRef= FALSE; Lead0_buttons.Cancel= FALSE; Lead0_buttons.Rpt= FALSE;	

};// set_buttons_lead0_subtr_manual

void set_buttons_lead0_subtr_auto()
{
     Lead0_buttons.ConsLR_s = 1;

Lead0_buttons.Mark=TRUE;Lead0_buttons.Dmy=FALSE; Lead0_buttons.Auto= TRUE; Lead0_buttons.Subtr=TRUE; Lead0_buttons.Cmpt= TRUE; 
Lead0_buttons.OvrApp= TRUE;  Lead0_buttons.OvrLds= TRUE; Lead0_buttons.GlR =FALSE; Lead0_buttons.SetLB= TRUE;
Lead0_buttons.SetLE= TRUE; Lead0_buttons.DelLI= loc_interval_b[0].set || loc_interval_e[0].set;
Lead0_buttons.Isc= TRUE; Lead0_buttons.Rate_r= TRUE;
Lead0_buttons.Cnd= FALSE; Lead0_buttons.AxS= FALSE; Lead0_buttons.Atr= FALSE;  Lead0_buttons.Exm= TRUE; Lead0_buttons.Move= FALSE;
Lead0_buttons.Del= FALSE; Lead0_buttons.DelA= TRUE; Lead0_buttons.ChAtr= FALSE; Lead0_buttons.ChAtrA= TRUE; 
Lead0_buttons.ConsLR= FALSE;
Lead0_buttons.LcRef= FALSE; Lead0_buttons.Cancel= FALSE; Lead0_buttons.Rpt= FALSE;	

};// set_buttons_lead0_subtr_auto

void set_buttons_lead0_unsubtr_auto()
{

     Lead0_buttons.ConsLR_s = 1;

Lead0_buttons.Mark=TRUE;Lead0_buttons.Dmy=FALSE; Lead0_buttons.Auto= TRUE; Lead0_buttons.Subtr=TRUE; Lead0_buttons.Cmpt= TRUE; 
Lead0_buttons.OvrApp= TRUE;  Lead0_buttons.OvrLds= TRUE; Lead0_buttons.GlR =FALSE; Lead0_buttons.SetLB= TRUE;
Lead0_buttons.SetLE= TRUE; Lead0_buttons.DelLI=  loc_interval_b[0].set || loc_interval_e[0].set;
Lead0_buttons.Isc= FALSE; Lead0_buttons.Rate_r= FALSE;
Lead0_buttons.Cnd= FALSE; Lead0_buttons.AxS= FALSE; Lead0_buttons.Atr= FALSE;  Lead0_buttons.Exm= TRUE; Lead0_buttons.Move= FALSE;
Lead0_buttons.Del= FALSE; Lead0_buttons.DelA= TRUE; Lead0_buttons.ChAtr= FALSE; Lead0_buttons.ChAtrA= TRUE; 
Lead0_buttons.ConsLR= FALSE;
Lead0_buttons.LcRef= FALSE; Lead0_buttons.Cancel= FALSE; Lead0_buttons.Rpt= FALSE;	

};// set_buttons_lead0_unsubtr_auto

void set_buttons_lead0_conslr()
{

Lead0_buttons.Mark=TRUE;Lead0_buttons.Dmy=FALSE; Lead0_buttons.Auto= FALSE; Lead0_buttons.Subtr=FALSE; Lead0_buttons.Cmpt= TRUE; 
Lead0_buttons.OvrApp= TRUE;  Lead0_buttons.OvrLds= TRUE; Lead0_buttons.GlR =FALSE; Lead0_buttons.SetLB= TRUE;
Lead0_buttons.SetLE= TRUE; Lead0_buttons.DelLI=  loc_interval_b[0].set || loc_interval_e[0].set;
Lead0_buttons.Isc= FALSE; Lead0_buttons.Rate_r= FALSE;
Lead0_buttons.Cnd= FALSE; Lead0_buttons.AxS= FALSE; Lead0_buttons.Atr= FALSE;  Lead0_buttons.Exm= TRUE; Lead0_buttons.Move= FALSE;
Lead0_buttons.Del= FALSE; Lead0_buttons.DelA= FALSE; Lead0_buttons.ChAtr= FALSE; Lead0_buttons.ChAtrA= FALSE; 
 Lead0_buttons.ConsLR=   Is_code(0,reference_act[0],0,0) || !status_consider_localref;

Lead0_buttons.LcRef= FALSE; Lead0_buttons.Cancel= FALSE; Lead0_buttons.Rpt= FALSE;	

};// set_buttons_lead0_conslr

void update_marker(int leadx,long cal)
{    
    float v_isor, v_j80r, v_iso, v_j20, v_j80;

    Marker[leadx].window = 2 * current_average_window_time;
    Marker[leadx].NS=current_mean_smp;
    get_average_M();
    Marker[leadx].NL=current_nl; Marker[leadx].NR=current_nr;
     v_iso =  avr_in_avrbeat(leadx, Marker[leadx].nISO,Marker[leadx].NS);
     v_j20 =  avr_in_avrbeat(leadx,- (Marker[leadx].nJ+5),Marker[leadx].NS);
     v_j80 =  avr_in_avrbeat(leadx,- Marker[leadx].nJ80,Marker[leadx].NS);


     if ( act_reference[leadx].set ){
			v_isor =  avr_in_avrbeat_r(leadx, act_ref_data[leadx].nISO,act_ref_data[leadx].NS);
			v_j80r =  avr_in_avrbeat_r(leadx,- act_ref_data[leadx].nJ80,act_ref_data[leadx].NS);
     }
                   else {
			  v_isor=0.0;
			  v_j80r=v_j80-v_iso;
			}

    Marker[leadx].ST80 = mk_uv(v_j80 - v_iso);
    Marker[leadx].STd = mk_uv(v_j80- v_iso - (v_j80r-v_isor ));
    Marker[leadx].STsl = mk_uv(v_j80- v_j20);
    Marker[leadx].ST_sub = mk_uv(data_raw[Marker[leadx].raw_index].sub_v[leadx]);

    switch (leadx) {
    case 0:
       Marker[leadx].fine_ST80 = mk_uv(data_fin[Marker[leadx].fine_index].l0_ST80);
       Marker[leadx].raw_ST80 = mk_uv(data_raw[Marker[leadx].raw_index].l0_ST80);
       Marker[leadx].fine_ST20 = mk_uv(data_fin[Marker[leadx].fine_index].l0_ST20);
       Marker[leadx].raw_ST20 = mk_uv(data_raw[Marker[leadx].raw_index].l0_ST20);
       break;
    case 1:
       Marker[leadx].fine_ST80 = mk_uv(data_fin[Marker[leadx].fine_index].l1_ST80);
       Marker[leadx].raw_ST80 = mk_uv(data_raw[Marker[leadx].raw_index].l1_ST80);
       Marker[leadx].fine_ST20 = mk_uv(data_fin[Marker[leadx].fine_index].l1_ST20);
       Marker[leadx].raw_ST20 = mk_uv(data_raw[Marker[leadx].raw_index].l1_ST20);
       break;
    case 2:
       Marker[leadx].fine_ST80 = mk_uv(data_fin[Marker[leadx].fine_index].l2_ST80);
       Marker[leadx].raw_ST80 = mk_uv(data_raw[Marker[leadx].raw_index].l2_ST80);
       Marker[leadx].fine_ST20 = mk_uv(data_fin[Marker[leadx].fine_index].l2_ST20);
       Marker[leadx].raw_ST20 = mk_uv(data_raw[Marker[leadx].raw_index].l2_ST20);
       break;
    }

} // end update_marker

void update_global_ref(int leadx, Bool iso_j, long cal)
{    
    global_ref[leadx].window=Marker[leadx].window;

    global_ref[leadx].NS=Marker[leadx].NS;
    global_ref[leadx].NL=Marker[leadx].NL; 
    global_ref[leadx].NR=Marker[leadx].NR;
    if (iso_j ) {
      global_ref[leadx].nISO=Marker[leadx].nISO;
      global_ref[leadx].nJ=Marker[leadx].nJ;
      global_ref[leadx].nJ80=Marker[leadx].nJ80;
    }
    global_ref[leadx].ST80=Marker[leadx].ST80;
    global_ref[leadx].STd=Marker[leadx].STd;
    global_ref[leadx].STsl=Marker[leadx].STsl;
    global_ref[leadx].ST_sub=Marker[leadx].ST_sub;
          
    global_ref[leadx].fine_ST80=Marker[leadx].fine_ST80;
    global_ref[leadx].raw_ST80=Marker[leadx].raw_ST80;
    global_ref[leadx].fine_ST20=Marker[leadx].fine_ST20;
    global_ref[leadx].raw_ST20=Marker[leadx].raw_ST20;
 
} // end update_global_ref

void update_act_ann(int leadx, long indexx, Bool iso_j, long cal)
{    
float v_isor, v_j80r, v_iso, v_j20, v_j80;

  if (indexx >= 0 ) {
    references[leadx][indexx].window=Marker[leadx].window;
    references[leadx][indexx].NL=Marker[leadx].NL;
    references[leadx][indexx].NR=Marker[leadx].NR;
    references[leadx][indexx].NS=Marker[leadx].NS;
    if (iso_j ) {
      references[leadx][indexx].nISO=Marker[leadx].nISO;
      references[leadx][indexx].nJ=Marker[leadx].nJ;
      references[leadx][indexx].nJ80=Marker[leadx].nJ80;
    }

     v_iso =  avr_in_avrbeat(leadx, references[leadx][indexx].nISO,references[leadx][indexx].NS);
     v_j20 =  avr_in_avrbeat(leadx,- (references[leadx][indexx].nJ+5),references[leadx][indexx].NS);
     v_j80 =  avr_in_avrbeat(leadx,- references[leadx][indexx].nJ80,references[leadx][indexx].NS);

     if ( act_reference[leadx].set ){
		       v_isor =  avr_in_avrbeat_r(leadx, act_ref_data[leadx].nISO,act_ref_data[leadx].NS);
		       v_j80r =  avr_in_avrbeat_r(leadx,- act_ref_data[leadx].nJ80,act_ref_data[leadx].NS);
			}
                   else {  v_isor=0.0;  v_j80r=v_j80-v_iso;
		   }

    references[leadx][indexx].ST80 = mk_uv(v_j80 - v_iso);
    references[leadx][indexx].STd = mk_uv(v_j80- v_iso - (v_j80r-v_isor ));
    references[leadx][indexx].STsl = mk_uv(v_j80- v_j20);
    references[leadx][indexx].ST_sub = mk_uv(data_raw[references[leadx][indexx].raw_index].sub_v[leadx]);

    references[leadx][indexx].fine_ST80=Marker[leadx].fine_ST80;
    references[leadx][indexx].raw_ST80=Marker[leadx].raw_ST80;
    references[leadx][indexx].fine_ST20=Marker[leadx].fine_ST20;
    references[leadx][indexx].raw_ST20=Marker[leadx].raw_ST20;

  }
} // end update_act_ann
          
void set_marker_l(int leadx)
{
int vj;

    Marker[leadx].fine_HR = data_fin[Marker[leadx].fine_index].HR;
    Marker[leadx].nPB = data_fin[Marker[leadx].fine_index].nPB;
    Marker[leadx].nPE = data_fin[Marker[leadx].fine_index].nPE;
    Marker[leadx].nQ = data_fin[Marker[leadx].fine_index].nQ;

    Marker[leadx].nISO = data_fin[Marker[leadx].fine_index].nISO;
    Marker[leadx].nJ = data_fin[Marker[leadx].fine_index].nJ;
    current_j_m=  Marker[leadx].nJ;
    current_iso_m=  Marker[leadx].nISO;

    vj = 20;
    if ( ( Marker[leadx].fine_HR >= 100 ) && ( Marker[leadx].fine_HR < 110 )) vj=18;
    if ( ( Marker[leadx].fine_HR >= 110 ) && ( Marker[leadx].fine_HR < 120 )) vj=16;
    if   ( Marker[leadx].fine_HR >= 120 ) vj=15;
    Marker[leadx].nJ80 = Marker[leadx].nJ + vj;

    Marker[leadx].nTB = data_fin[Marker[leadx].fine_index].nTB;
    Marker[leadx].nTX = data_fin[Marker[leadx].fine_index].nTX;
    Marker[leadx].nTE = data_fin[Marker[leadx].fine_index].nTE;
    Marker[leadx].raw_HR = data_raw[Marker[leadx].raw_index].HR;

    Marker[leadx].window = 2 * current_average_window_time;
    Marker[leadx].NS=current_mean_smp;
    Marker[leadx].ST_sub = mk_uv(data_raw[Marker[leadx].raw_index].sub_v[leadx]);

    Marker[leadx].STd = mk_uv(0);

    Marker[leadx].lead=leadx; 

    switch (leadx) {
    case 0:
       Marker[0].fine_ST80 = mk_uv(data_fin[Marker[0].fine_index].l0_ST80);
       Marker[0].raw_ST80 = mk_uv(data_raw[Marker[0].raw_index].l0_ST80);
       Marker[0].fine_ST20 = mk_uv(data_fin[Marker[0].fine_index].l0_ST20);
       Marker[0].raw_ST20 = mk_uv(data_raw[Marker[0].raw_index].l0_ST20);
       break;
    case 1:
       Marker[1].fine_ST80 = mk_uv(data_fin[Marker[1].fine_index].l1_ST80);
       Marker[1].raw_ST80 = mk_uv(data_raw[Marker[1].raw_index].l1_ST80);
       Marker[1].fine_ST20 = mk_uv(data_fin[Marker[1].fine_index].l1_ST20);
       Marker[1].raw_ST20 = mk_uv(data_raw[Marker[1].raw_index].l1_ST20);
       break;
    case 2:
       Marker[2].fine_ST80 = mk_uv(data_fin[Marker[2].fine_index].l2_ST80);
       Marker[2].raw_ST80 = mk_uv(data_raw[Marker[2].raw_index].l2_ST80);
       Marker[2].fine_ST20 = mk_uv(data_fin[Marker[2].fine_index].l2_ST20);
       Marker[2].raw_ST20 = mk_uv(data_raw[Marker[2].raw_index].l2_ST20);
       break;
     } // end switch

    if (last_set_all ) { Marker[0].set = FALSE;  Marker[1].set = FALSE; Marker[2].set = FALSE;
    reference_act[0]=-1; reference_act[1]=-1; reference_act[2]=-1; x_lead =TRUE;
    switch (leadx) {
      case 0: if (lead1_data) draw_grid_lead0(1); 
	if (lead2_data) draw_grid_lead0(2); 
	break;
      case 1:  draw_grid_lead0(0); 
	if (lead2_data) draw_grid_lead0(2); 
	break;
      case 2:  
	draw_grid_lead0(0); draw_grid_lead0(1);
	break; }
}
    last_set_all= FALSE;
    
    Marker[leadx].set= TRUE;
    Marker[leadx].code1=-1; 

    data_mstime_index= data_fin[Marker[leadx].fine_index].index;

    act_reference[0].change=FALSE;
    act_reference[1].change=FALSE;
    act_reference[2].change=FALSE;
    data_new_m_read();

    update_marker(leadx,1);

} //  end set_marker_l

void set_marker_r(int leadx_op)
{
int  vj;

    Marker[0].fine_HR = data_fin[Marker[0].fine_index].HR;
    Marker[0].nPB = data_fin[Marker[0].fine_index].nPB;
    Marker[0].nPE = data_fin[Marker[0].fine_index].nPE;
    Marker[0].nQ = data_fin[Marker[0].fine_index].nQ;
    if (leadx_op == 2) {

      if (current_j_m == 0)
          Marker[0].nJ = data_fin[Marker[0].fine_index].nJ;
      else
        Marker[0].nJ=current_j_m;
      if (current_iso_m == 0)
        Marker[0].nISO = data_fin[Marker[0].fine_index].nISO;
      else
        Marker[0].nISO=current_iso_m;

    }
    else {
      Marker[0].nISO = data_fin[Marker[0].fine_index].nISO;
      Marker[0].nJ = data_fin[Marker[0].fine_index].nJ;
      current_j_m=Marker[0].nJ;
      current_iso_m=Marker[0].nISO;
    }
        vj = 20;
        if ( ( Marker[0].fine_HR >= 100 ) && ( Marker[0].fine_HR < 110 )) vj=18;
        if ( ( Marker[0].fine_HR >= 110 ) && ( Marker[0].fine_HR < 120 )) vj=16;
        if   ( Marker[0].fine_HR >= 120 ) vj=15;
    Marker[0].nJ80 = Marker[0].nJ + vj;

    Marker[0].nTB = data_fin[Marker[0].fine_index].nTB;
    Marker[0].nTX = data_fin[Marker[0].fine_index].nTX;
    Marker[0].nTE = data_fin[Marker[0].fine_index].nTE;
    Marker[0].raw_HR = data_raw[Marker[0].raw_index].HR;

    Marker[0].window = 2 * current_average_window_time;
    Marker[0].NS = current_mean_smp;

    Marker[1].copy_ref(Marker[0]);  Marker[2].copy_ref(Marker[0]); 
    Marker[1].lead=1;  Marker[2].lead=2; 

    Marker[0].fine_ST80 = mk_uv(data_fin[Marker[0].fine_index].l0_ST80);
    Marker[1].fine_ST80 = mk_uv(data_fin[Marker[0].fine_index].l1_ST80);
    Marker[2].fine_ST80 = mk_uv(data_fin[Marker[0].fine_index].l2_ST80);

    Marker[0].raw_ST80 = mk_uv(data_raw[Marker[0].raw_index].l0_ST80);
    Marker[1].raw_ST80 = mk_uv(data_raw[Marker[0].raw_index].l1_ST80);
    Marker[2].raw_ST80 = mk_uv(data_raw[Marker[0].raw_index].l2_ST80);

    Marker[0].ST_sub = mk_uv(data_raw[Marker[0].raw_index].sub_v[0]);
    Marker[1].ST_sub = mk_uv(data_raw[Marker[0].raw_index].sub_v[1]);
    Marker[2].ST_sub = mk_uv(data_raw[Marker[0].raw_index].sub_v[2]);

 
    Marker[0].fine_ST20 = mk_uv(data_fin[Marker[0].fine_index].l0_ST20);
    Marker[1].fine_ST20 = mk_uv(data_fin[Marker[0].fine_index].l1_ST20);
    Marker[2].fine_ST20 = mk_uv(data_fin[Marker[0].fine_index].l2_ST20);

    Marker[0].raw_ST20 = mk_uv(data_raw[Marker[0].raw_index].l0_ST20);
    Marker[1].raw_ST20 = mk_uv(data_raw[Marker[0].raw_index].l1_ST20);
    Marker[2].raw_ST20 = mk_uv(data_raw[Marker[0].raw_index].l2_ST20);

    Marker[0].STd = mk_uv(0); Marker[1].STd = mk_uv(0); Marker[2].STd = mk_uv(0);

    Marker[0].set= TRUE; Marker[1].set = lead1_data; Marker[2].set=lead2_data;
    Marker[0].code1=-1;  Marker[1].code1=-1;  Marker[2].code1=-1; 

    data_mstime_index= data_fin[Marker[0].fine_index].index;
    data_new_m_read(); 
    update_marker(0,2);

    if (Marker[1].set ) {update_marker(1,1003); }
    if (Marker[2].set ) {update_marker(2,2004); }

    act_reference[0].change=FALSE;
    act_reference[1].change=FALSE;
    act_reference[2].change=FALSE;

} //  end set_marker_r

void new_global_reference(int cal)
{
long i;
float off_r_0, off_r_1, off_r_2;

      off_r_0 = data_raw[Marker[0].raw_index].l0_ST80;
      off_r_1 = data_raw[Marker[1].raw_index].l1_ST80;
      off_r_2 = data_raw[Marker[2].raw_index].l2_ST80;

    for (i=0; i <= raw_last_index; i++ ){
      data_raw[i].l0_ST80 = data_raw[i].l0_ST80 - off_r_0;
      data_raw[i].l0_ST20 = data_raw[i].l0_ST20 - off_r_0;

      data_raw[i].l1_ST80 = data_raw[i].l1_ST80 - off_r_1;
      data_raw[i].l1_ST20 = data_raw[i].l1_ST20 - off_r_1;

      data_raw[i].l2_ST80 = data_raw[i].l2_ST80 - off_r_2;
      data_raw[i].l2_ST20 = data_raw[i].l2_ST20 - off_r_2;

      data_raw[i].lin_v[0] = 0.; data_raw[i].lin_v[1] = 0.; data_raw[i].lin_v[2] = 0.;
      data_raw[i].sub_v[0] = 0.; data_raw[i].sub_v[1] = 0.; data_raw[i].sub_v[2] = 0.;
    }
    for (i=0; i <= fin_last_index; i++ ){

      data_fin[i].l0_ST80 = data_fin[i].l0_ST80 - off_r_0;
      data_fin[i].l0_ST20 = data_fin[i].l0_ST20 - off_r_0;

      data_fin[i].l1_ST80 = data_fin[i].l1_ST80 - off_r_1;
      data_fin[i].l1_ST20 = data_fin[i].l1_ST20 - off_r_1;

      data_fin[i].l2_ST80 = data_fin[i].l2_ST80 - off_r_2;
      data_fin[i].l2_ST20 = data_fin[i].l2_ST20 - off_r_2;

    }

} // end  new_global_reference(void)

void sub_op0_start(void)
{
    if (!repeat_set  ) Lead0_op_begin_status.copy_button_status(Lead0_buttons);

  switch (Lead0_operation) {
  case 0: return; 
  case 1: 
    allow_l0=TRUE;
    set_buttons_lead0_reset_all(); if (!repeat_set  ) Lead0_buttons.Rpt= TRUE; set_buttons_lead0();
    break;

  case 9: 
    allow_l0=TRUE;
    set_buttons_lead0_reset_all(); set_buttons_lead0();
   break;

  }
}; // sub_op0_start

void sub_op0_exec(void)
{

long r_i;
int del_code1, del_code2, ii;
long i_r, end_i, l_b, l_e;
long GR_index,act_ind, act_ind_r;
Bool no_gr1, test, test1;
Bool refresh_all =FALSE;
Bool  no_other, no_gr2, no_other2;
long l_l_b, l_l_e;
Bool refresh;

 refresh=FALSE; x_lead=FALSE;
 switch (Lead0_operation) {
  case 0: return; 
  case 1: 
    if (IS_free(0, click_l0.raw,1)) {

    Marker[0].set=TRUE;
    Marker[0].raw_index=click_l0.raw; Marker[0].fine_index=click_l0.fine;
    allow_l0=FALSE;
    set_marker_l(0);
    draw_grid_lead0(0); 
    show_data(0, x_lead, TRUE);

    if (repeat_set  ) {
          allow_l0=TRUE;
	  set_buttons_lead0_reset_all(); set_buttons_lead0();
	}
    else  {
            Lead0_operation=0; 
	    Lead0_buttons.copy_button_status(Lead0_op_begin_status);
	    set_buttons_lead0();
	  }
    }
    else {
            Lead0_operation=0; 
	    Lead0_buttons.copy_button_status(Lead0_op_begin_status);
	    set_buttons_lead0();
	    }      
    break;

  case 9: 
    refresh_all=FALSE;

    if ( references_index[0] > -1 ) {

      for (r_i=0; (r_i < references_index[0] ) && ( click_l0.raw > references[0][r_i].raw_index); r_i++);

      	if  ( click_l0.raw !=  references[0][r_i].raw_index ) {
      	  if ((r_i <= references_index[0] ) && (r_i > 0 )){
      	    if ( (  data_raw[click_l0.raw].index-
      		    data_raw[ references[0][r_i-1].raw_index].index ) <
      	         (  data_raw[ references[0][r_i].raw_index].index -
      		    data_raw[click_l0.raw].index) ) r_i=r_i-1; 
      	  }
      	}
    if  ( abs(click_l0.x - Coor_x_l0( data_raw[ references[0][r_i].raw_index].index-TimeToIndex(diagram_time_begin_lead))) <= 7 ) {
 if ( Is_code(0,r_i,4,0) )
        if ( Is_prop_mode(0) ) last_set_all  = TRUE;
	  if ((! Is_code(0,r_i,4,0) ) OR
	      ( Is_prop_mode(0) &&

                Is_code(0,r_i,4,0))) {
	  if (last_set_all ) { Marker[1].set=FALSE; Marker[2].set=FALSE; refresh_all=TRUE;
	                       reference_act[1]=-1; reference_act[2] =-1; last_set_all=FALSE; x_lead=TRUE; }

	  Marker[0].copy_ref( references[0][r_i]);
	  Marker[0].set=TRUE;
	  current_j_m=Marker[0].nJ;
	  current_iso_m=Marker[0].nISO;

	  reference_act[0]=r_i; 
	  data_mstime_index= data_fin[Marker[0].fine_index].index;
	  act_reference[0].change=FALSE;
	  act_reference[1].change=FALSE;
	  act_reference[2].change=FALSE;
	  data_new_m_read(); 
	  update_marker(0,190);
	  }
     if (! (status_consider_localref)  && Is_code(0,r_i,0,0)  ) { 
	      act_ref_data[0].copy_ref(references[0][reference_act[0]]);
	      act_reference[0].set=TRUE;
	      act_reference[0].change=FALSE;
	      act_reference[0].typ=2; // local
	      act_reference[0].index=reference_act[0];
	      act_reference[1].change=FALSE;
	      act_reference[2].change=FALSE;

	      reference_mstime_index= data_fin[act_ref_data[0].fine_index].index;
	      data_new_r_read();
	      get_average_R();
	      update_marker(0,193);
       }

	  if (Is_code(0,r_i,4,0) ) { // dy
	  if (Is_prop_mode(0) ) {
	    last_set_all=TRUE;
	    if ( references_index[1] > -1){
	    for (r_i=0; (r_i <= references_index[1] ) && (  references[0][reference_act[0]].raw_index > references[1][r_i].raw_index); r_i++);
	    if ( (r_i <= references_index[1] ) && ( r_i > -1 )) {
	      if  (  references[0][reference_act[0]].raw_index  ==  references[1][r_i].raw_index ) {

		Marker[1].copy_ref( references[1][r_i]);
		Marker[1].set=TRUE;
		reference_act[1]=r_i; 
		update_marker(1,100190); refresh_all=TRUE; 
	      }}
	    } // end set lead1
	    if ( references_index[2] > -1){
	    for (r_i=0; (r_i <= references_index[2] ) && ( references[0][reference_act[0]].raw_index  > references[2][r_i].raw_index); r_i++);

	    if ( (r_i <= references_index[2] ) && ( r_i > -1 )) {
	      if  (  references[0][reference_act[0]].raw_index  ==  references[2][r_i].raw_index ) {

		Marker[2].copy_ref( references[2][r_i]); Marker[2].set=TRUE; reference_act[2]=r_i; 
		update_marker(2,200190); refresh_all=TRUE; 
	      }}
	    } 
	   }} 
	  draw_grid_lead0(0); 
	  if (refresh_all && lead1_data )  draw_grid_lead0(1);
	  if (refresh_all && lead2_data )  draw_grid_lead0(2);
	  show_data(0, x_lead,TRUE);
    } }

    if (fast0_center) break;

    Lead0_op_begin_status.ConsLR=   Is_code(0,reference_act[0],0,0) || !status_consider_localref;
    Lead0_buttons.copy_button_status(Lead0_op_begin_status);
    set_buttons_lead0();
    Lead0_operation=0;
    break;

  }
 refresh=FALSE;

}; // sub_op0_exec

void sub_op0_cancel(void)
{

 Lead0_buttons.copy_button_status(Lead0_op_begin_status);

 repeat_set =FALSE;
 
  switch (Lead0_operation) {
  case 0: return; 
  case 1:  
    allow_l0=FALSE;
    break;

  case 9:  
    allow_l0=FALSE;
    break;

  }

  Lead0_buttons.Cancel=FALSE;set_buttons_lead0();
  Lead0_operation=0;

}; // sub_op0_cancel

//**

void set_buttons_lead1()
{
  Bool selected;
  Bool loc_int_set;
  Bool sel_lr;
 
if (Lead1_buttons.Auto_s == 1) 
            { status_manual_mode1=TRUE; }
	  else  
	    { status_manual_mode1=FALSE;}
if (Lead1_buttons.Subtr_s == 1) 
               { xv_set(Sem_0_l_bw1.l_b_Subtr1, PANEL_LABEL_STRING, "Subtr", NULL);status_unsubtracted1 =TRUE; } 
	  else  
               { xv_set(Sem_0_l_bw1.l_b_Subtr1, PANEL_LABEL_STRING, "UnSubtr", NULL); status_unsubtracted1 =FALSE;}
if (Lead1_buttons.OvrApp_s == 1) 
               {xv_set(Sem_0_l_bw1.l_b_OvrApp1, PANEL_LABEL_STRING, "OvrApp", NULL);  ovr1_app = FALSE;}
	  else  
	       {xv_set(Sem_0_l_bw1.l_b_OvrApp1, PANEL_LABEL_STRING, "UnOvAp", NULL);  ovr1_app = TRUE;}

if (Lead1_buttons.ConsLR ){
if (Lead1_buttons.ConsLR_s == 1)
  { xv_set(Sem_0_l_bw1.l_b_ConsLR1, PANEL_LABEL_STRING, "ConsLR", NULL); status_consider_localref1 =TRUE;  
	       sel_lr=Is_code(1,reference_act[1],0,0) && status_manual_mode1 && status_unsubtracted1;} 
	   else    
	      {xv_set(Sem_0_l_bw1.l_b_ConsLR1, PANEL_LABEL_STRING, "ConsGR", NULL);  status_consider_localref1 =FALSE;
	      sel_lr=TRUE;}
}

 selected = reference_act[1] >= 0;
 if (  status_manual_mode1 && !status_unsubtracted1 && Is_code(1,reference_act[1],0,0) ) selected=FALSE; 
 loc_int_set = loc_interval_b[1].set && loc_interval_e[1].set; 

xv_set(Sem_0_l_bw1.l_b_Mark1, PANEL_INACTIVE,! Lead1_buttons.Mark,NULL);

xv_set(Sem_0_l_bw1.l_b_Subtr1, PANEL_INACTIVE,! Lead1_buttons.Subtr,NULL);
xv_set(Sem_0_l_bw1.l_b_OvrApp1, PANEL_INACTIVE,! Lead1_buttons.OvrApp,NULL);
xv_set(Sem_0_l_bw1.l_b_OvrLds_menu1, PANEL_INACTIVE,! Lead1_buttons.OvrLds,NULL);

xv_set(Sem_0_l_bw1.l_b_Exm1, PANEL_INACTIVE,! Lead1_buttons.Exm,NULL);
xv_set(Sem_0_l_bw1.l_b_ConsLR1, PANEL_INACTIVE,! (Lead1_buttons.ConsLR && sel_lr),NULL);

} // set_buttons_lead1

void set_buttons_lead1_start()
{

Lead1_buttons.Auto_s = 1; Lead1_buttons.Subtr_s=1; Lead1_buttons.OvrApp_s=1; Lead1_buttons.ConsLR_s=1;

Lead1_buttons.Mark=TRUE;Lead1_buttons.Dmy=FALSE; Lead1_buttons.Auto= FALSE; Lead1_buttons.Subtr=FALSE; Lead1_buttons.Cmpt= TRUE; 
Lead1_buttons.OvrApp= TRUE;  Lead1_buttons.OvrLds= TRUE; Lead1_buttons.GlR =TRUE; Lead1_buttons.SetLB= FALSE;
Lead1_buttons.SetLE= FALSE; Lead1_buttons.DelLI= FALSE; 
Lead1_buttons.Isc= FALSE; Lead1_buttons.Rate_r= FALSE;
Lead1_buttons.Cnd= FALSE; Lead1_buttons.AxS= FALSE; Lead1_buttons.Atr= FALSE;  Lead1_buttons.Exm= FALSE; Lead1_buttons.Move= FALSE;
Lead1_buttons.Del= FALSE; Lead1_buttons.DelA= FALSE; Lead1_buttons.ChAtr= FALSE; Lead1_buttons.ChAtrA= FALSE; 
Lead1_buttons.ConsLR= FALSE;
Lead1_buttons.LcRef= FALSE; Lead1_buttons.Cancel= FALSE; Lead1_buttons.Rpt= FALSE;	

};// set_buttons_lead1_start

void set_buttons_lead1_reset_all()
{

Lead1_buttons.Mark=FALSE; Lead1_buttons.Dmy=FALSE; Lead1_buttons.Auto= FALSE; Lead1_buttons.Subtr=FALSE; Lead1_buttons.Cmpt= TRUE; 
Lead1_buttons.OvrApp= TRUE;  Lead1_buttons.OvrLds= TRUE; Lead1_buttons.GlR =FALSE; Lead1_buttons.SetLB= FALSE;
Lead1_buttons.SetLE= FALSE; Lead1_buttons.DelLI= FALSE; Lead1_buttons.Isc= FALSE; Lead1_buttons.Rate_r= FALSE;
Lead1_buttons.Cnd= FALSE; Lead1_buttons.AxS= FALSE; Lead1_buttons.Atr= FALSE;  Lead1_buttons.Exm= FALSE; Lead1_buttons.Move= FALSE;
Lead1_buttons.Del= FALSE; Lead1_buttons.DelA= FALSE; Lead1_buttons.ChAtr= FALSE; Lead1_buttons.ChAtrA= FALSE; 
Lead1_buttons.ConsLR= FALSE;
Lead1_buttons.LcRef= FALSE; Lead1_buttons.Cancel= TRUE; Lead1_buttons.Rpt= FALSE;	

};// set_buttons_lead1_reset_all

void set_buttons_lead1_setGR()
{
   Lead1_buttons.Auto_s = 1;
   Lead1_buttons.Subtr_s= 1; 

   Lead1_buttons.ConsLR_s = 1;

Lead1_buttons.Mark=TRUE;Lead1_buttons.Dmy=TRUE; Lead1_buttons.Auto= TRUE; Lead1_buttons.Subtr=TRUE; Lead1_buttons.Cmpt= TRUE; 
Lead1_buttons.OvrApp= TRUE;  Lead1_buttons.OvrLds= TRUE; Lead1_buttons.GlR =TRUE; Lead1_buttons.SetLB= TRUE;
Lead1_buttons.SetLE= TRUE; Lead1_buttons.DelLI= loc_interval_b[1].set || loc_interval_e[1].set; 
Lead1_buttons.Isc= FALSE; Lead1_buttons.Rate_r= FALSE;
Lead1_buttons.Cnd= TRUE; Lead1_buttons.AxS= TRUE; Lead1_buttons.Atr= FALSE;  Lead1_buttons.Exm= TRUE; Lead1_buttons.Move= TRUE;
Lead1_buttons.Del= TRUE; Lead1_buttons.DelA= FALSE; Lead1_buttons.ChAtr= FALSE; Lead1_buttons.ChAtrA= FALSE; 
Lead1_buttons.ConsLR=  Is_code(1,reference_act[1],0,0) || !status_consider_localref1;
Lead1_buttons.LcRef= TRUE; Lead1_buttons.Cancel= FALSE; Lead1_buttons.Rpt= FALSE;	

};// set_buttons_lead1_setGR

void set_buttons_lead1_unsubtr_manual()
{

     Lead1_buttons.ConsLR_s = 1;

Lead1_buttons.Mark=TRUE;Lead1_buttons.Dmy=TRUE; Lead1_buttons.Auto= TRUE; Lead1_buttons.Subtr=TRUE; Lead1_buttons.Cmpt= TRUE; 
Lead1_buttons.OvrApp= TRUE;  Lead1_buttons.OvrLds= TRUE; Lead1_buttons.GlR =TRUE; Lead1_buttons.SetLB= TRUE;
Lead1_buttons.SetLE= TRUE; Lead1_buttons.DelLI=  loc_interval_b[1].set || loc_interval_e[1].set; 
Lead1_buttons.Isc= FALSE; Lead1_buttons.Rate_r= FALSE;
Lead1_buttons.Cnd= TRUE; Lead1_buttons.AxS= TRUE; Lead1_buttons.Atr= FALSE;  Lead1_buttons.Exm= TRUE; Lead1_buttons.Move= TRUE;
Lead1_buttons.Del= TRUE; Lead1_buttons.DelA= FALSE; Lead1_buttons.ChAtr= FALSE; Lead1_buttons.ChAtrA= FALSE; 
 Lead1_buttons.ConsLR=   Is_code(1,reference_act[1],0,0) || !status_consider_localref1;

Lead1_buttons.LcRef= TRUE; Lead1_buttons.Cancel= FALSE; Lead1_buttons.Rpt= FALSE;	

};// set_buttons_lead1_unsubtr_manual

void set_buttons_lead1_subtr_manual()
{
     Lead1_buttons.ConsLR_s = 1;

Lead1_buttons.Mark=TRUE;Lead1_buttons.Dmy=FALSE; Lead1_buttons.Auto= TRUE; Lead1_buttons.Subtr=TRUE; Lead1_buttons.Cmpt= TRUE; 
Lead1_buttons.OvrApp= TRUE;  Lead1_buttons.OvrLds= TRUE; Lead1_buttons.GlR =FALSE; Lead1_buttons.SetLB= TRUE;
Lead1_buttons.SetLE= TRUE; Lead1_buttons.DelLI=  loc_interval_b[1].set || loc_interval_e[1].set; 
Lead1_buttons.Isc= FALSE; Lead1_buttons.Rate_r= FALSE;
Lead1_buttons.Cnd= FALSE; Lead1_buttons.AxS= FALSE; Lead1_buttons.Atr= TRUE;  Lead1_buttons.Exm= TRUE; Lead1_buttons.Move= TRUE;
Lead1_buttons.Del= TRUE; Lead1_buttons.DelA= FALSE; Lead1_buttons.ChAtr= TRUE; Lead1_buttons.ChAtrA= FALSE; 
Lead1_buttons.ConsLR= FALSE;
Lead1_buttons.LcRef= FALSE; Lead1_buttons.Cancel= FALSE; Lead1_buttons.Rpt= FALSE;	

};// set_buttons_lead1_subtr_manual

void set_buttons_lead1_subtr_auto()
{
     Lead1_buttons.ConsLR_s = 1;

Lead1_buttons.Mark=TRUE;Lead1_buttons.Dmy=FALSE; Lead1_buttons.Auto= TRUE; Lead1_buttons.Subtr=TRUE; Lead1_buttons.Cmpt= TRUE; 
Lead1_buttons.OvrApp= TRUE;  Lead1_buttons.OvrLds= TRUE; Lead1_buttons.GlR =FALSE; Lead1_buttons.SetLB= TRUE;
Lead1_buttons.SetLE= TRUE; Lead1_buttons.DelLI= loc_interval_b[1].set || loc_interval_e[1].set;
Lead1_buttons.Isc= TRUE; Lead1_buttons.Rate_r= TRUE;
Lead1_buttons.Cnd= FALSE; Lead1_buttons.AxS= FALSE; Lead1_buttons.Atr= FALSE;  Lead1_buttons.Exm= TRUE; Lead1_buttons.Move= FALSE;
Lead1_buttons.Del= FALSE; Lead1_buttons.DelA= TRUE; Lead1_buttons.ChAtr= FALSE; Lead1_buttons.ChAtrA= TRUE; 
Lead1_buttons.ConsLR= FALSE;
Lead1_buttons.LcRef= FALSE; Lead1_buttons.Cancel= FALSE; Lead1_buttons.Rpt= FALSE;	

};// set_buttons_lead1_subtr_auto

void set_buttons_lead1_unsubtr_auto()
{
     Lead1_buttons.ConsLR_s = 1;

Lead1_buttons.Mark=TRUE;Lead1_buttons.Dmy=FALSE; Lead1_buttons.Auto= TRUE; Lead1_buttons.Subtr=TRUE; Lead1_buttons.Cmpt= TRUE; 
Lead1_buttons.OvrApp= TRUE;  Lead1_buttons.OvrLds= TRUE; Lead1_buttons.GlR =FALSE; Lead1_buttons.SetLB= TRUE;
Lead1_buttons.SetLE= TRUE; Lead1_buttons.DelLI=  loc_interval_b[1].set || loc_interval_e[1].set;
Lead1_buttons.Isc= FALSE; Lead1_buttons.Rate_r= FALSE;
Lead1_buttons.Cnd= FALSE; Lead1_buttons.AxS= FALSE; Lead1_buttons.Atr= FALSE;  Lead1_buttons.Exm= TRUE; Lead1_buttons.Move= FALSE;
Lead1_buttons.Del= FALSE; Lead1_buttons.DelA= TRUE; Lead1_buttons.ChAtr= FALSE; Lead1_buttons.ChAtrA= TRUE; 
Lead1_buttons.ConsLR= FALSE;
Lead1_buttons.LcRef= FALSE; Lead1_buttons.Cancel= FALSE; Lead1_buttons.Rpt= FALSE;	

};// set_buttons_lead1_unsubtr_auto

void set_buttons_lead1_conslr()
{

Lead1_buttons.Mark=TRUE;Lead1_buttons.Dmy=FALSE; Lead1_buttons.Auto= FALSE; Lead1_buttons.Subtr=FALSE; Lead1_buttons.Cmpt= TRUE; 
Lead1_buttons.OvrApp= TRUE;  Lead1_buttons.OvrLds= TRUE; Lead1_buttons.GlR =FALSE; Lead1_buttons.SetLB= TRUE;
Lead1_buttons.SetLE= TRUE; Lead1_buttons.DelLI=  loc_interval_b[1].set || loc_interval_e[1].set;
Lead1_buttons.Isc= FALSE; Lead1_buttons.Rate_r= FALSE;
Lead1_buttons.Cnd= FALSE; Lead1_buttons.AxS= FALSE; Lead1_buttons.Atr= FALSE;  Lead1_buttons.Exm= TRUE; Lead1_buttons.Move= FALSE;
Lead1_buttons.Del= FALSE; Lead1_buttons.DelA= FALSE; Lead1_buttons.ChAtr= FALSE; Lead1_buttons.ChAtrA= FALSE; 
Lead1_buttons.ConsLR=   Is_code(1,reference_act[1],0,0) || !status_consider_localref1;

Lead1_buttons.LcRef= FALSE; Lead1_buttons.Cancel= FALSE; Lead1_buttons.Rpt= FALSE;	

};// set_buttons_lead1_conslr

void sub_op1_start(void)
{
  if (!repeat_set1 ) Lead1_op_begin_status.copy_button_status(Lead1_buttons);

  switch (Lead1_operation) {
  case 0: return; 
  case 1: 
    allow_l1=TRUE;
    set_buttons_lead1_reset_all(); if (!repeat_set1 ) Lead1_buttons.Rpt= TRUE; set_buttons_lead1();
    break;

  case 9: 
    allow_l1=TRUE;
    set_buttons_lead1_reset_all(); set_buttons_lead1();
   break;

  }
}; // sub_op1_start

void sub_op1_exec(void)
{

long r_i;
int del_code1, del_code2, ii;
long i_r, end_i, l_b, l_e;
long GR_index,act_ind, act_ind_r;
Bool no_gr1, test, test1;
Bool refresh_all =FALSE;
Bool  no_other, no_other2, no_gr2;
long l_l_b, l_l_e;
Bool refresh=FALSE;

 refresh=FALSE; x_lead=FALSE;
 switch (Lead1_operation) {
  case 0: return; 
  case 1: 
    if (IS_free(1, click_l1.raw,1)) {
    Marker[1].set=TRUE;
    Marker[1].raw_index=click_l1.raw; Marker[1].fine_index=click_l1.fine;
    allow_l1=FALSE;
    set_marker_l(1);
    draw_grid_lead0(1); 

    show_data(1, x_lead, TRUE);

    if (repeat_set1 ) {
          allow_l1=TRUE;
	  set_buttons_lead1_reset_all(); set_buttons_lead1();
	}
    else  {
            Lead1_operation=0; 
	    Lead1_buttons.copy_button_status(Lead1_op_begin_status);
	    set_buttons_lead1();
	  }      
	}
    else  {
            Lead1_operation=0; 
	    Lead1_buttons.copy_button_status(Lead1_op_begin_status);
	    set_buttons_lead1();
	  }
    break;

  case 9: // set examine
    refresh_all =FALSE;

    if ( references_index[1] > -1 ) {

      for (r_i=0; (r_i < references_index[1] ) && ( click_l1.raw > references[1][r_i].raw_index); r_i++);

      	if  ( click_l1.raw !=  references[1][r_i].raw_index ) {
	  // find nearest ann
      	  if ((r_i <= references_index[1] ) && (r_i > 0 )){
      	    if ( (  data_raw[click_l1.raw].index-
      		    data_raw[ references[1][r_i-1].raw_index].index ) <
      	         (  data_raw[ references[1][r_i].raw_index].index -
      		    data_raw[click_l1.raw].index) ) r_i=r_i-1; 
      	  }
      	}
    if  ( abs(click_l1.x - Coor_x_l0( data_raw[ references[1][r_i].raw_index].index-TimeToIndex(diagram_time_begin_lead))) <= 7 ) {

 if ( Is_code(1,r_i,4,0) )
        if ( Is_prop_mode(1) ) last_set_all  = TRUE;

	  if ((! Is_code(1,r_i,4,0) ) OR
	    ( Is_prop_mode(1) &&
                Is_code(1,r_i,4,0))) {
	  if (last_set_all ) { Marker[0].set=FALSE; Marker[2].set=FALSE; refresh_all =TRUE;
	                        reference_act[0]=-1; reference_act[2] =-1; last_set_all=FALSE;    x_lead=TRUE; }

	  Marker[1].copy_ref( references[1][r_i]);
	  Marker[1].set=TRUE;
	  current_j_m=Marker[1].nJ;
	  current_iso_m=Marker[1].nISO;

	  reference_act[1]=r_i; 
	  data_mstime_index= data_fin[Marker[1].fine_index].index;
	  act_reference[0].change=FALSE;
	  act_reference[1].change=FALSE;
	  act_reference[2].change=FALSE;
	  data_new_m_read(); 
	  update_marker(1,190);
	  }
     if (! (status_consider_localref1)  && Is_code(1,r_i,0,0)  ) { 
	      act_ref_data[1].copy_ref(references[1][reference_act[1]]);
	      act_reference[1].set=TRUE;
	      act_reference[0].change=FALSE;
	      act_reference[1].typ=2; // local
	      act_reference[1].index=reference_act[1];
	      act_reference[1].change=FALSE;
	      act_reference[2].change=FALSE;

	      reference_mstime_index= data_fin[act_ref_data[1].fine_index].index;
	      data_new_r_read();
	      get_average_R();
	      update_marker(1,193);
       }

	  if (Is_code(1,r_i,4,0) ) { // dy
	    if( Is_prop_mode(1) ) {
	    last_set_all=TRUE;
	    if ( references_index[0] > -1){
	    for (r_i=0; (r_i <= references_index[0] ) && (  references[1][reference_act[1]].raw_index > references[0][r_i].raw_index); r_i++);

	    if ( (r_i <= references_index[0] ) && ( r_i > -1 )) {
	      if  (  references[1][reference_act[1]].raw_index  ==  references[0][r_i].raw_index ) {

		Marker[0].copy_ref( references[0][r_i]);
		Marker[0].set=TRUE;
		reference_act[0]=r_i; 
		update_marker(0,100190); refresh_all=TRUE;
	      }}
	    } 
	    if ( references_index[2] > -1){
	    for (r_i=0; (r_i <= references_index[2] ) && ( references[1][reference_act[1]].raw_index  > references[2][r_i].raw_index); r_i++);

	    if ( (r_i <= references_index[2] ) && ( r_i > -1 )) {
	      if  (  references[1][reference_act[1]].raw_index  ==  references[2][r_i].raw_index ) {

		Marker[2].copy_ref( references[2][r_i]); Marker[2].set=TRUE; reference_act[2]=r_i; 
		update_marker(2,200190); refresh_all=TRUE;
	      }}
	    }
	   }} 
	  if ( refresh_all) draw_grid_lead0(0);
	  draw_grid_lead0(1);	
	  if ( refresh_all && lead2_data ) draw_grid_lead0(2);
 	  show_data(1, x_lead, TRUE);
    } }

    if (fast1_center) break;

    Lead1_op_begin_status.ConsLR=   Is_code(1,reference_act[1],0,0) || !status_consider_localref1;
    Lead1_buttons.copy_button_status(Lead1_op_begin_status);
    set_buttons_lead1();
    Lead1_operation=0;
    break;

  }
 refresh = FALSE;

}; // sub_op1_exec

void sub_op1_cancel(void)
{

 Lead1_buttons.copy_button_status(Lead1_op_begin_status);

 repeat_set1=FALSE;
 
  switch (Lead1_operation) {
  case 0: return; 
  case 1: 
    allow_l1=FALSE;
    break;

  case 9:  // set examine
    allow_l1=FALSE;
    break;

  }

  Lead1_buttons.Cancel=FALSE;set_buttons_lead1();
  Lead1_operation=0;

}; // sub_op1_cancel

//**

void set_buttons_lead2()
{
  Bool selected;
  Bool loc_int_set;
  Bool sel_lr;

if (Lead2_buttons.Auto_s == 1) 
            { status_manual_mode2=TRUE; }
	  else  
	    { status_manual_mode2=FALSE;}
if (Lead2_buttons.Subtr_s == 1) 
               { xv_set(Sem_0_l_bw2.l_b_Subtr2, PANEL_LABEL_STRING, "Subtr", NULL);status_unsubtracted2 =TRUE; } 
	  else  
               { xv_set(Sem_0_l_bw2.l_b_Subtr2, PANEL_LABEL_STRING, "UnSubtr", NULL); status_unsubtracted2 =FALSE;}
if (Lead2_buttons.OvrApp_s == 1) 
               {xv_set(Sem_0_l_bw2.l_b_OvrApp2, PANEL_LABEL_STRING, "OvrApp", NULL);  ovr2_app = FALSE;}
	  else  
	       {xv_set(Sem_0_l_bw2.l_b_OvrApp2, PANEL_LABEL_STRING, "UnOvAp", NULL);  ovr2_app = TRUE;}

if (Lead2_buttons.ConsLR ){
if (Lead2_buttons.ConsLR_s == 1)
               { xv_set(Sem_0_l_bw2.l_b_ConsLR2, PANEL_LABEL_STRING, "ConsLR", NULL); status_consider_localref2 =TRUE;
		       sel_lr=Is_code(2,reference_act[2],0,0) && status_manual_mode2 && status_unsubtracted2;} 
            else  
               {xv_set(Sem_0_l_bw2.l_b_ConsLR2, PANEL_LABEL_STRING, "ConsGR", NULL);  status_consider_localref2 =FALSE;
	       sel_lr=TRUE;}
 }

 selected = reference_act[2] >= 0;
 if (  status_manual_mode2 && !status_unsubtracted2 && Is_code(2,reference_act[2],0,0) ) selected=FALSE; 
 loc_int_set = loc_interval_b[2].set && loc_interval_e[2].set; 

xv_set(Sem_0_l_bw2.l_b_Mark2, PANEL_INACTIVE,! Lead2_buttons.Mark,NULL);

xv_set(Sem_0_l_bw2.l_b_Subtr2, PANEL_INACTIVE,! Lead2_buttons.Subtr,NULL);
xv_set(Sem_0_l_bw2.l_b_OvrApp2, PANEL_INACTIVE,! Lead2_buttons.OvrApp,NULL);
xv_set(Sem_0_l_bw2.l_b_OvrLds_menu2, PANEL_INACTIVE,! Lead2_buttons.OvrLds,NULL);

xv_set(Sem_0_l_bw2.l_b_Exm2, PANEL_INACTIVE,! Lead2_buttons.Exm,NULL);
xv_set(Sem_0_l_bw2.l_b_ConsLR2, PANEL_INACTIVE,! (Lead2_buttons.ConsLR && sel_lr),NULL);

};// set_buttons_lead2

void set_buttons_lead2_start()
{

Lead2_buttons.Auto_s = 1; Lead2_buttons.Subtr_s=1; Lead2_buttons.OvrApp_s=1; Lead2_buttons.ConsLR_s=1;

Lead2_buttons.Mark=TRUE;Lead2_buttons.Dmy=FALSE; Lead2_buttons.Auto= FALSE; Lead2_buttons.Subtr=FALSE; Lead2_buttons.Cmpt= TRUE; 
Lead2_buttons.OvrApp= TRUE;  Lead2_buttons.OvrLds= TRUE; Lead2_buttons.GlR =TRUE; Lead2_buttons.SetLB= FALSE;
Lead2_buttons.SetLE= FALSE; Lead2_buttons.DelLI= FALSE; 
Lead2_buttons.Isc= FALSE; Lead2_buttons.Rate_r= FALSE;
Lead2_buttons.Cnd= FALSE; Lead2_buttons.AxS= FALSE; Lead2_buttons.Atr= FALSE;  Lead2_buttons.Exm= FALSE; Lead2_buttons.Move= FALSE;
Lead2_buttons.Del= FALSE; Lead2_buttons.DelA= FALSE; Lead2_buttons.ChAtr= FALSE; Lead2_buttons.ChAtrA= FALSE; 
Lead2_buttons.ConsLR= FALSE;
Lead2_buttons.LcRef= FALSE; Lead2_buttons.Cancel= FALSE; Lead2_buttons.Rpt= FALSE;	

};// set_buttons_lead2_start

void set_buttons_lead2_reset_all()
{

Lead2_buttons.Mark=FALSE; Lead2_buttons.Dmy=FALSE; Lead2_buttons.Auto= FALSE; Lead2_buttons.Subtr=FALSE; Lead2_buttons.Cmpt= TRUE; 
Lead2_buttons.OvrApp= TRUE;  Lead2_buttons.OvrLds= TRUE; Lead2_buttons.GlR =FALSE; Lead2_buttons.SetLB= FALSE;
Lead2_buttons.SetLE= FALSE; Lead2_buttons.DelLI= FALSE; Lead2_buttons.Isc= FALSE; Lead2_buttons.Rate_r= FALSE;
Lead2_buttons.Cnd= FALSE; Lead2_buttons.AxS= FALSE; Lead2_buttons.Atr= FALSE;  Lead2_buttons.Exm= FALSE; Lead2_buttons.Move= FALSE;
Lead2_buttons.Del= FALSE; Lead2_buttons.DelA= FALSE; Lead2_buttons.ChAtr= FALSE; Lead2_buttons.ChAtrA= FALSE; 
Lead2_buttons.ConsLR= FALSE;
Lead2_buttons.LcRef= FALSE; Lead2_buttons.Cancel= TRUE; Lead2_buttons.Rpt= FALSE;	

};// set_buttons_lead2_reset_all

void set_buttons_lead2_setGR()
{
   Lead2_buttons.Auto_s = 1;
   Lead2_buttons.Subtr_s= 1; 
   Lead2_buttons.ConsLR_s = 1;

Lead2_buttons.Mark=TRUE;Lead2_buttons.Dmy=TRUE; Lead2_buttons.Auto= TRUE; Lead2_buttons.Subtr=TRUE; Lead2_buttons.Cmpt= TRUE; 
Lead2_buttons.OvrApp= TRUE;  Lead2_buttons.OvrLds= TRUE; Lead2_buttons.GlR =TRUE; Lead2_buttons.SetLB= TRUE;
Lead2_buttons.SetLE= TRUE; Lead2_buttons.DelLI= loc_interval_b[2].set || loc_interval_e[2].set; 
Lead2_buttons.Isc= FALSE; Lead2_buttons.Rate_r= FALSE;
Lead2_buttons.Cnd= TRUE; Lead2_buttons.AxS= TRUE; Lead2_buttons.Atr= FALSE;  Lead2_buttons.Exm= TRUE; Lead2_buttons.Move= TRUE;
Lead2_buttons.Del= TRUE; Lead2_buttons.DelA= FALSE; Lead2_buttons.ChAtr= FALSE; Lead2_buttons.ChAtrA= FALSE; 
Lead2_buttons.ConsLR=  Is_code(2,reference_act[2],0,0) || !status_consider_localref2;
Lead2_buttons.LcRef= TRUE; Lead2_buttons.Cancel= FALSE; Lead2_buttons.Rpt= FALSE;	

};// set_buttons_lead2_setGR

void set_buttons_lead2_unsubtr_manual()
{
     Lead2_buttons.ConsLR_s = 1;

Lead2_buttons.Mark=TRUE;Lead2_buttons.Dmy=TRUE; Lead2_buttons.Auto= TRUE; Lead2_buttons.Subtr=TRUE; Lead2_buttons.Cmpt= TRUE; 
Lead2_buttons.OvrApp= TRUE;  Lead2_buttons.OvrLds= TRUE; Lead2_buttons.GlR =TRUE; Lead2_buttons.SetLB= TRUE;
Lead2_buttons.SetLE= TRUE; Lead2_buttons.DelLI=  loc_interval_b[2].set || loc_interval_e[2].set; 
Lead2_buttons.Isc= FALSE; Lead2_buttons.Rate_r= FALSE;
Lead2_buttons.Cnd= TRUE; Lead2_buttons.AxS= TRUE; Lead2_buttons.Atr= FALSE;  Lead2_buttons.Exm= TRUE; Lead2_buttons.Move= TRUE;
Lead2_buttons.Del= TRUE; Lead2_buttons.DelA= FALSE; Lead2_buttons.ChAtr= FALSE; Lead2_buttons.ChAtrA= FALSE; 
 Lead2_buttons.ConsLR=   Is_code(2,reference_act[2],0,0) || !status_consider_localref2;

Lead2_buttons.LcRef= TRUE; Lead2_buttons.Cancel= FALSE; Lead2_buttons.Rpt= FALSE;	

};// set_buttons_lead2_unsubtr_manual

void set_buttons_lead2_subtr_manual()
{
     Lead2_buttons.ConsLR_s = 1;

Lead2_buttons.Mark=TRUE;Lead2_buttons.Dmy=FALSE; Lead2_buttons.Auto= TRUE; Lead2_buttons.Subtr=TRUE; Lead2_buttons.Cmpt= TRUE; 
Lead2_buttons.OvrApp= TRUE;  Lead2_buttons.OvrLds= TRUE; Lead2_buttons.GlR =FALSE; Lead2_buttons.SetLB= TRUE;
Lead2_buttons.SetLE= TRUE; Lead2_buttons.DelLI=  loc_interval_b[2].set || loc_interval_e[2].set; 
Lead2_buttons.Isc= FALSE; Lead2_buttons.Rate_r= FALSE;
Lead2_buttons.Cnd= FALSE; Lead2_buttons.AxS= FALSE; Lead2_buttons.Atr= TRUE;  Lead2_buttons.Exm= TRUE; Lead2_buttons.Move= TRUE;
Lead2_buttons.Del= TRUE; Lead2_buttons.DelA= FALSE; Lead2_buttons.ChAtr= TRUE; Lead2_buttons.ChAtrA= FALSE; 
Lead2_buttons.ConsLR= FALSE;
Lead2_buttons.LcRef= FALSE; Lead2_buttons.Cancel= FALSE; Lead2_buttons.Rpt= FALSE;	

};// set_buttons_lead2_subtr_manual

void set_buttons_lead2_subtr_auto()
{
     Lead2_buttons.ConsLR_s = 1;

Lead2_buttons.Mark=TRUE;Lead2_buttons.Dmy=FALSE; Lead2_buttons.Auto= TRUE; Lead2_buttons.Subtr=TRUE; Lead2_buttons.Cmpt= TRUE; 
Lead2_buttons.OvrApp= TRUE;  Lead2_buttons.OvrLds= TRUE; Lead2_buttons.GlR =FALSE; Lead2_buttons.SetLB= TRUE;
Lead2_buttons.SetLE= TRUE; Lead2_buttons.DelLI= loc_interval_b[2].set || loc_interval_e[2].set;
Lead2_buttons.Isc= TRUE; Lead2_buttons.Rate_r= TRUE;
Lead2_buttons.Cnd= FALSE; Lead2_buttons.AxS= FALSE; Lead2_buttons.Atr= FALSE;  Lead2_buttons.Exm= TRUE; Lead2_buttons.Move= FALSE;
Lead2_buttons.Del= FALSE; Lead2_buttons.DelA= TRUE; Lead2_buttons.ChAtr= FALSE; Lead2_buttons.ChAtrA= TRUE; 
Lead2_buttons.ConsLR= FALSE;
Lead2_buttons.LcRef= FALSE; Lead2_buttons.Cancel= FALSE; Lead2_buttons.Rpt= FALSE;	

};// set_buttons_lead2_subtr_auto

void set_buttons_lead2_unsubtr_auto()
{
     Lead2_buttons.ConsLR_s = 1;

Lead2_buttons.Mark=TRUE;Lead2_buttons.Dmy=FALSE; Lead2_buttons.Auto= TRUE; Lead2_buttons.Subtr=TRUE; Lead2_buttons.Cmpt= TRUE; 
Lead2_buttons.OvrApp= TRUE;  Lead2_buttons.OvrLds= TRUE; Lead2_buttons.GlR =FALSE; Lead2_buttons.SetLB= TRUE;
Lead2_buttons.SetLE= TRUE; Lead2_buttons.DelLI=  loc_interval_b[2].set || loc_interval_e[2].set;
Lead2_buttons.Isc= FALSE; Lead2_buttons.Rate_r= FALSE;
Lead2_buttons.Cnd= FALSE; Lead2_buttons.AxS= FALSE; Lead2_buttons.Atr= FALSE;  Lead2_buttons.Exm= TRUE; Lead2_buttons.Move= FALSE;
Lead2_buttons.Del= FALSE; Lead2_buttons.DelA= TRUE; Lead2_buttons.ChAtr= FALSE; Lead2_buttons.ChAtrA= TRUE; 
Lead2_buttons.ConsLR= FALSE;
Lead2_buttons.LcRef= FALSE; Lead2_buttons.Cancel= FALSE; Lead2_buttons.Rpt= FALSE;	

};// set_buttons_lead2_unsubtr_auto

void set_buttons_lead2_conslr()
{

Lead2_buttons.Mark=TRUE;Lead2_buttons.Dmy=FALSE; Lead2_buttons.Auto= FALSE; Lead2_buttons.Subtr=FALSE; Lead2_buttons.Cmpt= TRUE; 
Lead2_buttons.OvrApp= TRUE;  Lead2_buttons.OvrLds= TRUE; Lead2_buttons.GlR =FALSE; Lead2_buttons.SetLB= TRUE;
Lead2_buttons.SetLE= TRUE; Lead2_buttons.DelLI=  loc_interval_b[2].set || loc_interval_e[2].set;
Lead2_buttons.Isc= FALSE; Lead2_buttons.Rate_r= FALSE;
Lead2_buttons.Cnd= FALSE; Lead2_buttons.AxS= FALSE; Lead2_buttons.Atr= FALSE;  Lead2_buttons.Exm= TRUE; Lead2_buttons.Move= FALSE;
Lead2_buttons.Del= FALSE; Lead2_buttons.DelA= FALSE; Lead2_buttons.ChAtr= FALSE; Lead2_buttons.ChAtrA= FALSE; 
Lead2_buttons.ConsLR=   Is_code(2,reference_act[2],0,0) || !status_consider_localref2;

Lead2_buttons.LcRef= FALSE; Lead2_buttons.Cancel= FALSE; Lead2_buttons.Rpt= FALSE;	

};// set_buttons_lead2_conslr

void sub_op2_start(void)
{
  if (!repeat_set2 ) Lead2_op_begin_status.copy_button_status(Lead2_buttons);

  switch (Lead2_operation) {
  case 0: return; 
  case 1: 
    allow_l2=TRUE;
    set_buttons_lead2_reset_all(); if (!repeat_set2 ) Lead2_buttons.Rpt= TRUE; set_buttons_lead2();
    break;

  case 9: // set examine
    allow_l2=TRUE;
    set_buttons_lead2_reset_all(); set_buttons_lead2();
   break;

  }

} // end sub_op2_star

void sub_op2_exec (void)
{

long r_i;
int del_code1, del_code2, ii;
long i_r, end_i, l_b, l_e;
long GR_index,act_ind, act_ind_r;
Bool no_gr1, test, test1;
Bool refresh_all=FALSE;
Bool  no_other, no_other2, no_gr2;
long l_l_b, l_l_e;
Bool refresh;

 refresh=FALSE;    x_lead=FALSE;

  switch (Lead2_operation) {
  case 0: return; 
  case 1: 
    if (IS_free(2, click_l2.raw,1)) {
    Marker[2].set=TRUE;
    Marker[2].raw_index=click_l2.raw; Marker[2].fine_index=click_l2.fine;
    allow_l2=FALSE;
    set_marker_l(2);
    draw_grid_lead0(2); 

    show_data(2, x_lead, TRUE);

    if (repeat_set2 ) {
          allow_l2=TRUE;
	  set_buttons_lead2_reset_all(); set_buttons_lead2();
	}
    else  {
            Lead2_operation=0; 
	    Lead2_buttons.copy_button_status(Lead2_op_begin_status);
	    set_buttons_lead2();
	  }
	}
    else  {
            Lead2_operation=0; 
	    Lead2_buttons.copy_button_status(Lead2_op_begin_status);
	    set_buttons_lead2();
	  }
     break;

  case 9: // set examine
    refresh_all=FALSE;
    if ( references_index[2] > -1 ) {

      for (r_i=0; (r_i < references_index[2] ) && ( click_l2.raw > references[2][r_i].raw_index); r_i++);

      	if  ( click_l2.raw !=  references[2][r_i].raw_index ) {
	  // find nearest ann
      	  if ((r_i <= references_index[2] ) && (r_i > 0 )){
      	    if ( (  data_raw[click_l2.raw].index-
      		    data_raw[ references[2][r_i-1].raw_index].index ) <
      	         (  data_raw[ references[2][r_i].raw_index].index -
      		    data_raw[click_l2.raw].index) ) r_i=r_i-1; 
      	  }
      	}

    if  ( abs(click_l2.x - Coor_x_l0( data_raw[ references[2][r_i].raw_index].index-TimeToIndex(diagram_time_begin_lead))) <= 7 ) {

 if ( Is_code(2,r_i,4,0) )
        if ( Is_prop_mode(2) ) last_set_all  = TRUE;

	  if ((! Is_code(2,r_i,4,0) ) OR
	    ( Is_prop_mode(2) &&
                Is_code(2,r_i,4,0))) {
	  if (last_set_all ) { Marker[0].set=FALSE; Marker[1].set=FALSE;refresh_all=TRUE; 
	                        reference_act[0]=-1; reference_act[1] =-1; last_set_all=FALSE;     x_lead=TRUE;}

	  Marker[2].copy_ref( references[2][r_i]);
	  Marker[2].set=TRUE;
	  current_j_m=Marker[2].nJ;
	  current_iso_m=Marker[2].nISO;

	  reference_act[2]=r_i; 
	  data_mstime_index= data_fin[Marker[2].fine_index].index;
	  act_reference[0].change=FALSE;
	  act_reference[1].change=FALSE;
	  act_reference[2].change=FALSE;
	  data_new_m_read(); 
	  update_marker(2,190);
	  }
     if (! (status_consider_localref2)  && Is_code(2,r_i,0,0)  ) { 
	      act_ref_data[2].copy_ref(references[2][reference_act[2]]);
	      act_reference[2].set=TRUE;
	      act_reference[0].change=FALSE;
	      act_reference[2].typ=2; // local
	      act_reference[2].index=reference_act[2];
	      act_reference[1].change=FALSE;
	      act_reference[2].change=FALSE;

	      reference_mstime_index= data_fin[act_ref_data[2].fine_index].index;
	      data_new_r_read();
	      get_average_R();
	      update_marker(2,193);
       }

	  if (Is_code(2,r_i,4,0) ) { // dy
	    x_lead=TRUE;
	    if( Is_prop_mode(2) ) {
	    last_set_all=TRUE;
	    if ( references_index[0] > -1){
	    for (r_i=0; (r_i <= references_index[0] ) && (  references[2][reference_act[2]].raw_index > references[0][r_i].raw_index); r_i++);

		    if ( (r_i <= references_index[0] ) && ( r_i > -1 )) {
	      if  (  references[2][reference_act[2]].raw_index  ==  references[0][r_i].raw_index ) {

		Marker[0].copy_ref( references[0][r_i]);
		Marker[0].set=TRUE;
		reference_act[0]=r_i; 
		update_marker(0,100190); refresh_all=TRUE;    set_buttons_lead0();

	      }}
	    } 
	    if ( references_index[1] > -1){
	    for (r_i=0; (r_i <= references_index[1] ) && ( references[2][reference_act[2]].raw_index  > references[1][r_i].raw_index); r_i++);
	    if ( (r_i <= references_index[1] ) && ( r_i > -1 )) {
	      if  (  references[2][reference_act[2]].raw_index  ==  references[1][r_i].raw_index ) {

		Marker[1].copy_ref( references[1][r_i]); Marker[1].set=TRUE; reference_act[1]=r_i; 
		update_marker(1,100190);     set_buttons_lead1();

	      }}
	    }
	   }} 
	  if (refresh_all) {  draw_grid_lead0(0);draw_grid_lead0(1); }
	  draw_grid_lead0(2); 	  
	  show_data(2, x_lead, TRUE);
    } }
    if (fast2_center) break;

    Lead2_op_begin_status.ConsLR=   Is_code(2,reference_act[2],0,0) || !status_consider_localref2;
    Lead2_buttons.copy_button_status(Lead2_op_begin_status);
    set_buttons_lead2();
    Lead2_operation=0;
  break;

  }
  refresh = FALSE;

} // end sub_op2_exec

void sub_op2_cancel(void)
{

 Lead2_buttons.copy_button_status(Lead2_op_begin_status);

 repeat_set2=FALSE;
 
  switch (Lead2_operation) {
  case 0: return; 
  case 1: 
    allow_l2=FALSE;
    break;

  case 9:  // set examine
    allow_l2=FALSE;
    break;

  }
  Lead2_buttons.Cancel=FALSE;set_buttons_lead2();
  Lead2_operation=0;
}

//End user functions =====================================================================================

// Destroy function
Notify_value destroy_func(Notify_client client, Destroy_status status)
{
    if (status == DESTROY_CHECKING) {
	int result;

	result = notice_prompt((Frame)client, (Event *)NULL,
		NOTICE_MESSAGE_STRINGS, "Quit ?", NULL,
				   NOTICE_BUTTON_YES, "Cancel",
				   NOTICE_BUTTON_NO, "Quit",
				   NULL);
	if (result != NOTICE_NO)
	    notify_veto_destroy(client);
    } else if (status == DESTROY_CLEANUP) {
	return notify_next_destroy_func(client, status);
    }
    return NOTIFY_DONE;
}

#ifdef MAIN

Attr_attribute	INSTANCE;

main(int argc, char **argv)
{
	//
	// Initialize XView.
	//
	xv_init(XV_INIT_ARGC_PTR_ARGV, &argc, argv, NULL);
	INSTANCE = xv_unique_key();

	//
	// Initialize user interface components.
	//

	Sem_0_m_bw.objects_initialize(0L);
	Sem_0_k_bw.objects_initialize(Sem_0_m_bw.m_bw);
	Sem_0_o_pw.objects_initialize(Sem_0_m_bw.m_bw);
	Sem_0_q_pw.objects_initialize(Sem_0_m_bw.m_bw);
	Sem_0_w_pw.objects_initialize(Sem_0_m_bw.m_bw);
	Sem_0_d_bw.objects_initialize(Sem_0_m_bw.m_bw);
	Sem_0_l_bw.objects_initialize(Sem_0_m_bw.m_bw);
	Sem_0_l_bw1.objects_initialize(Sem_0_m_bw.m_bw);
        Sem_0_l_bw2.objects_initialize(Sem_0_m_bw.m_bw);
	Sem_0_d_pw.objects_initialize(Sem_0_m_bw.m_bw);
	Sem_0_c_pw.objects_initialize(Sem_0_m_bw.m_bw);
	Sem_0_h_pw.objects_initialize(Sem_0_m_bw.m_bw);
	
        // Install the destroy_func signal handler for cleanup before quiting
        notify_interpose_destroy_func((Notify_client) Sem_0_m_bw.m_bw, (Notify_value (*)(...)) destroy_func);
	// notify_interpose_destroy_func(Sem_0_m_bw.m_bw, destroy_func);

	//
	// Turn control over to XView.
	//

        xv_main_loop(Sem_0_m_bw.m_bw);
	exit(0);
}

#endif

//
// Menu handler for `l_menu_OvrLds (Lead0)'.
//
Menu_item
l_call_OvrLds_Lead0(Menu_item item, Menu_generate op)
{
	sem_0_l_bw_objects * ip = (sem_0_l_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
		
     	switch (op) {
	case MENU_DISPLAY:
		xv_set(item, MENU_INACTIVE, TRUE, 0);
		break;

	case MENU_DISPLAY_DONE:
		break;

	case MENU_NOTIFY:

		// gxv_start_connections DO NOT EDIT THIS SECTION
		// gxv_end_connections

		break;

	case MENU_NOTIFY_DONE:
		break;
	}
	return item;
}

//
// Menu handler for `l_menu_OvrLds (Lead1)'.
//
Menu_item
l_call_OvrLds_Lead1(Menu_item item, Menu_generate op)
{
	sem_0_l_bw_objects * ip = (sem_0_l_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (op) {
	case MENU_DISPLAY:
	  	if ( ovr0_l1 OR ( ! lead1_data) ) { xv_set(item, MENU_INACTIVE, TRUE, 0);
						  }
		else
		  { xv_set(item, MENU_INACTIVE, FALSE, 0);
						  }
		break;

	case MENU_DISPLAY_DONE:
		break;

	case MENU_NOTIFY:

		ovr0_l1=TRUE; draw_grid_lead0(0);
		
		// gxv_start_connections DO NOT EDIT THIS SECTION
		// gxv_end_connections

		break;

	case MENU_NOTIFY_DONE:
		break;
	}
	return item;
}

//
// Menu handler for `l_menu_OvrLds (Lead2)'.
//
Menu_item
l_call_OvrLds_Lead2(Menu_item item, Menu_generate op)
{
	sem_0_l_bw_objects * ip = (sem_0_l_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (op) {
	case MENU_DISPLAY:
	  if ( ovr0_l2  OR ( ! lead2_data))  xv_set(item, MENU_INACTIVE, TRUE, 0);

		else
		  { xv_set(item, MENU_INACTIVE, FALSE, 0);
						  }
		break;

	case MENU_DISPLAY_DONE:
		break;

	case MENU_NOTIFY:

		ovr0_l2=TRUE; draw_grid_lead0(0);
		
		// gxv_start_connections DO NOT EDIT THIS SECTION
		// gxv_end_connections

		break;

	case MENU_NOTIFY_DONE:
		break;
	}
	return item;
}

//
// Menu handler for `l_menu_OvrLds (UnOvrly)'.
//
Menu_item
l_call_OvrLds_UnOvrly(Menu_item item, Menu_generate op)
{
	sem_0_l_bw_objects * ip = (sem_0_l_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (op) {
	case MENU_DISPLAY:
	  if ( ovr0_l1 || ovr0_l2 )
		xv_set(item, MENU_INACTIVE, FALSE, 0);
	  else
		xv_set(item, MENU_INACTIVE, TRUE, 0);
		break;

	case MENU_DISPLAY_DONE:
		break;

	case MENU_NOTIFY:

		ovr0_l1=FALSE; ovr0_l2=FALSE; draw_grid_lead0(0);

		// gxv_start_connections DO NOT EDIT THIS SECTION
		// gxv_end_connections

		break;

	case MENU_NOTIFY_DONE:
		break;
	}
	return item;
}

//
// Menu handler for `d_menu_OvrLds (Lead0)'.
//
Menu_item
d_call_OvrLds_Lead0(Menu_item item, Menu_generate op)
{
	sem_0_d_bw_objects * ip = (sem_0_d_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (op) {
	case MENU_DISPLAY:
	  if ( ( Data_lead == 0 ) OR ( data_ovr_l0 )  )  xv_set(item, MENU_INACTIVE, TRUE, 0);
	  else xv_set(item, MENU_INACTIVE, FALSE, 0);
		break;

	case MENU_DISPLAY_DONE:
		break;

	case MENU_NOTIFY:
		 
          data_ovr_l0=TRUE;

	  show_data(Data_lead,FALSE, FALSE);

		// gxv_start_connections DO NOT EDIT THIS SECTION
		// gxv_end_connections

		break;

	case MENU_NOTIFY_DONE:
		break;
	}
	return item;
}

//
// Menu handler for `d_menu_OvrLds (Lead1)'.
//
Menu_item
d_call_OvrLds_Lead1(Menu_item item, Menu_generate op)
{
	sem_0_d_bw_objects * ip = (sem_0_d_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (op) {
	case MENU_DISPLAY:
  if ( Data_lead == 1  OR ( ! lead1_data) OR ( data_ovr_l1) )  xv_set(item, MENU_INACTIVE, TRUE, 0);
	  else  xv_set(item, MENU_INACTIVE, FALSE, 0);
		break;

	case MENU_DISPLAY_DONE:
		break;

	case MENU_NOTIFY:

	  data_ovr_l1=TRUE;

	  show_data(Data_lead,FALSE, FALSE);

		// gxv_start_connections DO NOT EDIT THIS SECTION
		// gxv_end_connections

		break;

	case MENU_NOTIFY_DONE:
		break;
	}
	return item;
}

//
// Menu handler for `d_menu_OvrLds (Lead2)'.
//
Menu_item
d_call_OvrLds_Lead2(Menu_item item, Menu_generate op)
{
	sem_0_d_bw_objects * ip = (sem_0_d_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (op) {
	case MENU_DISPLAY:
	  if ( Data_lead == 2  OR ( ! lead2_data) OR ( data_ovr_l2)  )  xv_set(item, MENU_INACTIVE, TRUE, 0);
	  else xv_set(item, MENU_INACTIVE, FALSE, 0);
		break;

	case MENU_DISPLAY_DONE:
		break;

	case MENU_NOTIFY:

	data_ovr_l2=TRUE;
	
        show_data(Data_lead,FALSE, FALSE);
		
		// gxv_start_connections DO NOT EDIT THIS SECTION
		// gxv_end_connections

		break;

	case MENU_NOTIFY_DONE:
		break;
	}
	return item;
}

//
// Menu handler for `d_menu_OvrLds (UnOvrly)'.
//
Menu_item
d_call_OvrLds_UnOvrly(Menu_item item, Menu_generate op)
{
	sem_0_d_bw_objects * ip = (sem_0_d_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (op) {
	case MENU_DISPLAY:
	  if ( 	data_ovr_l0 OR  data_ovr_l1 OR  data_ovr_l2)  
               xv_set(item, MENU_INACTIVE, FALSE, 0);
	  else xv_set(item, MENU_INACTIVE, TRUE, 0);
		break;

	case MENU_DISPLAY_DONE:
		break;

	case MENU_NOTIFY:

	data_ovr_l0=FALSE; data_ovr_l1=FALSE; data_ovr_l2=FALSE;

        data_ovrly_shift=FALSE;

	  show_data(Data_lead,FALSE, FALSE);

		// gxv_start_connections DO NOT EDIT THIS SECTION
		// gxv_end_connections

		break;

	case MENU_NOTIFY_DONE:
		break;
	}
	return item;
}

//
// Menu handler for `l_menu_OvrLds1 (Lead0)'.
//
Menu_item
l_call_OvrLds1_Lead0(Menu_item item, Menu_generate op)
{
	sem_0_l_bw1_objects * ip = (sem_0_l_bw1_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (op) {
	case MENU_DISPLAY:
	  if ( ovr1_l0 ) { xv_set(item, MENU_INACTIVE, TRUE, 0);}
		else
		  { xv_set(item, MENU_INACTIVE, FALSE, 0);  }
		break;

	case MENU_DISPLAY_DONE:
		break;

	case MENU_NOTIFY:

		ovr1_l0=TRUE; draw_grid_lead0(1);
		
		// gxv_start_connections DO NOT EDIT THIS SECTION
		// gxv_end_connections

		break;

	case MENU_NOTIFY_DONE:
		break;
	}
	return item;
}

//
// Menu handler for `l_menu_OvrLds1 (Lead1)'.
//
Menu_item
l_call_OvrLds1_Lead1(Menu_item item, Menu_generate op)
{
	sem_0_l_bw1_objects * ip = (sem_0_l_bw1_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (op) {
	case MENU_DISPLAY:
		xv_set(item, MENU_INACTIVE, TRUE, 0);
		break;

	case MENU_DISPLAY_DONE:
		break;

	case MENU_NOTIFY:

		// gxv_start_connections DO NOT EDIT THIS SECTION
		// gxv_end_connections

		break;

	case MENU_NOTIFY_DONE:
		break;
	}
	return item;
}

//
// Menu handler for `l_menu_OvrLds1 (Lead2)'.
//
Menu_item
l_call_OvrLds1_Lead2(Menu_item item, Menu_generate op)
{
	sem_0_l_bw1_objects * ip = (sem_0_l_bw1_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (op) {
	case MENU_DISPLAY:
	  if ( ovr1_l2  OR ( ! lead2_data))  xv_set(item, MENU_INACTIVE, TRUE, 0);
      
		else
		  { xv_set(item, MENU_INACTIVE, FALSE, 0);}
		break;

	case MENU_DISPLAY_DONE:
		break;

	case MENU_NOTIFY:

		ovr1_l2=TRUE; draw_grid_lead0(1);
		
		// gxv_start_connections DO NOT EDIT THIS SECTION
		// gxv_end_connections

		break;

	case MENU_NOTIFY_DONE:
		break;
	}
	return item;
}

//
// Menu handler for `l_menu_OvrLds1 (UnOvrly)'.
//
Menu_item
l_call_OvrLds1_UnOvrly(Menu_item item, Menu_generate op)
{
	sem_0_l_bw1_objects * ip = (sem_0_l_bw1_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (op) {
	case MENU_DISPLAY:
	  if ( ovr1_l0 || ovr1_l2 )
		xv_set(item, MENU_INACTIVE, FALSE, 0);
	  else
		xv_set(item, MENU_INACTIVE, TRUE, 0);
		break;

	case MENU_DISPLAY_DONE:
		break;

	case MENU_NOTIFY:

		ovr1_l0=FALSE; ovr1_l2=FALSE; draw_grid_lead0(1);
			
		// gxv_start_connections DO NOT EDIT THIS SECTION
		// gxv_end_connections

		break;

	case MENU_NOTIFY_DONE:
		break;
	}
	return item;
}

//
// Menu handler for `l_menu_OvrLds2 (Lead0)'.
//
Menu_item
l_call_OvrLds2_Lead0(Menu_item item, Menu_generate op)
{
	sem_0_l_bw2_objects * ip = (sem_0_l_bw2_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (op) {
	case MENU_DISPLAY:
	  if ( ovr2_l0 ) { xv_set(item, MENU_INACTIVE, TRUE, 0);}
		else
		  { xv_set(item, MENU_INACTIVE, FALSE, 0);}
		break;

	case MENU_DISPLAY_DONE:
		break;

	case MENU_NOTIFY:

		ovr2_l0=TRUE; draw_grid_lead0(2);
		
		// gxv_start_connections DO NOT EDIT THIS SECTION
		// gxv_end_connections

		break;

	case MENU_NOTIFY_DONE:
		break;
	}
	return item;
}

//
// Menu handler for `l_menu_OvrLds2 (Lead1)'.
//
Menu_item
l_call_OvrLds2_Lead1(Menu_item item, Menu_generate op)
{
	sem_0_l_bw2_objects * ip = (sem_0_l_bw2_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (op) {
	case MENU_DISPLAY:
	  	if ( ovr2_l1 OR ( ! lead1_data) ) { xv_set(item, MENU_INACTIVE, TRUE, 0);
						  }
		else
		  { xv_set(item, MENU_INACTIVE, FALSE, 0);
						  }
			break;

	case MENU_DISPLAY_DONE:
		break;

	case MENU_NOTIFY:

		 ovr2_l1=TRUE; draw_grid_lead0(2);
	
		// gxv_start_connections DO NOT EDIT THIS SECTION
		// gxv_end_connections

		break;

	case MENU_NOTIFY_DONE:
		break;
	}
	return item;
}

//
// Menu handler for `l_menu_OvrLds2 (Lead2)'.
//
Menu_item
l_call_OvrLds2_Lead2(Menu_item item, Menu_generate op)
{
	sem_0_l_bw2_objects * ip = (sem_0_l_bw2_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (op) {
	case MENU_DISPLAY:
		xv_set(item, MENU_INACTIVE, TRUE, 0);
		break;

	case MENU_DISPLAY_DONE:
		break;

	case MENU_NOTIFY:

		// gxv_start_connections DO NOT EDIT THIS SECTION
		// gxv_end_connections

		break;

	case MENU_NOTIFY_DONE:
		break;
	}
	return item;
}

//
// Menu handler for `l_menu_OvrLds2 (UnOvrly)'.
//
Menu_item
l_call_OvrLds2_UnOvrly(Menu_item item, Menu_generate op)
{
	sem_0_l_bw2_objects * ip = (sem_0_l_bw2_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (op) {
	case MENU_DISPLAY:
	  if ( ovr2_l1 || ovr2_l0 )
		xv_set(item, MENU_INACTIVE, FALSE, 0);
	  else
		xv_set(item, MENU_INACTIVE, TRUE, 0);
		break;

	case MENU_DISPLAY_DONE:
		break;

	case MENU_NOTIFY:

		ovr2_l1=FALSE; ovr2_l0=FALSE; draw_grid_lead0(2);
			
		// gxv_start_connections DO NOT EDIT THIS SECTION
		// gxv_end_connections

		break;

	case MENU_NOTIFY_DONE:
		break;
	}
	return item;
}

//
// Notify callback function for `m_b_Open'.
//
void
sem_0_m_bw_m_b_Open_notify_callback(Panel_item item, Event *event)
{
	sem_0_m_bw_objects *ip = (sem_0_m_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION

	main_open_init(item, event);
	
	xv_set(Sem_0_k_bw.k_bw, XV_SHOW, FALSE, NULL);
	
	xv_set(Sem_0_o_pw.o_pw, FRAME_CMD_PUSHPIN_IN, TRUE, NULL);
	xv_set(Sem_0_o_pw.o_pw, XV_SHOW, TRUE, NULL);
	
	xv_set(Sem_0_q_pw.q_pw, FRAME_CMD_PUSHPIN_IN, FALSE, NULL);
	xv_set(Sem_0_q_pw.q_pw, XV_SHOW, FALSE, NULL);
	
	xv_set(Sem_0_w_pw.w_pw, FRAME_CMD_PUSHPIN_IN, FALSE, NULL);
	xv_set(Sem_0_w_pw.w_pw, XV_SHOW, FALSE, NULL);
	
	xv_set(Sem_0_d_bw.d_bw, XV_SHOW, FALSE, NULL);
	
	xv_set(Sem_0_l_bw.l_bw, XV_SHOW, FALSE, NULL);
	
	xv_set(Sem_0_d_pw.d_pw, FRAME_CMD_PUSHPIN_IN, FALSE, NULL);
	xv_set(Sem_0_d_pw.d_pw, XV_SHOW, FALSE, NULL);

	xv_set(Sem_0_c_pw.c_pw, FRAME_CMD_PUSHPIN_IN, FALSE, NULL);
	xv_set(Sem_0_c_pw.c_pw, XV_SHOW, FALSE, NULL);

//	xv_set(Sem_0_h_pw.h_pw, FRAME_CMD_PUSHPIN_IN, FALSE, NULL);
//	xv_set(Sem_0_h_pw.h_pw, XV_SHOW, FALSE, NULL); 

	xv_set(Sem_0_l_bw1.l_bw1, XV_SHOW, FALSE, NULL);
	
	xv_set(Sem_0_l_bw2.l_bw2, XV_SHOW, FALSE, NULL);
	
	// gxv_end_connections

}

//
// Notify callback function for `m_b_Lead0'.
//
void
init_Lead(Panel_item item, Event *event)
{
	sem_0_m_bw_objects *ip = (sem_0_m_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);

	// gxv_start_connections DO NOT EDIT THIS SECTION

	if (xv_get(Sem_0_l_bw.l_bw, FRAME_CLOSED))
		xv_set(Sem_0_l_bw.l_bw, FRAME_CLOSED, FALSE, NULL);

	xv_set(Sem_0_l_bw.l_bw, XV_SHOW, TRUE, NULL);
	
	l_ini_lcp_b(item, event);
	
	// gxv_end_connections

}

//
// Notify callback function for `m_b_Data'.
//
void
init_data(Panel_item item, Event *event)
{
	sem_0_m_bw_objects *ip = (sem_0_m_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION

	if (xv_get(Sem_0_d_bw.d_bw, FRAME_CLOSED))
		xv_set(Sem_0_d_bw.d_bw, FRAME_CLOSED, FALSE, NULL);

	xv_set(Sem_0_d_bw.d_bw, XV_SHOW, TRUE, NULL);
	
	d_ini_cp_b(item, event);
	
	// gxv_end_connections

}

//
// Notify callback function for `m_b_Lead1'.
//
void
init_Lead1(Panel_item item, Event *event)
{
	sem_0_m_bw_objects *ip = (sem_0_m_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION

	if (xv_get(Sem_0_l_bw1.l_bw1, FRAME_CLOSED))
		xv_set(Sem_0_l_bw1.l_bw1, FRAME_CLOSED, FALSE, NULL);

	xv_set(Sem_0_l_bw1.l_bw1, XV_SHOW, TRUE, NULL);
	
	l_ini_cp1_b(item, event);
	
	// gxv_end_connections

}

//
// Notify callback function for `m_b_KLCoeff'.
//
void
init_kl(Panel_item item, Event *event)
{
	sem_0_m_bw_objects *ip = (sem_0_m_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION

	if (xv_get(Sem_0_k_bw.k_bw, FRAME_CLOSED))
		xv_set(Sem_0_k_bw.k_bw, FRAME_CLOSED, FALSE, NULL);

	xv_set(Sem_0_k_bw.k_bw, XV_SHOW, TRUE, NULL);
	
	k_ini_cp_b(item, event);
	
	// gxv_end_connections

}

//
// Notify callback function for `m_b_AplOp'.
//
void
apply_options(Panel_item item, Event *event)
{
	sem_0_m_bw_objects *ip = (sem_0_m_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
FILE *set_data=NULL;
char i_str1[132], i_str2[132];
int x, i, j, l;
int test=0;

	if((set_data=fopen("semia.opt","r")) != NULL )
	   {
	     l=fscanf(set_data,"%s\n",&i_str1);

	     i=0; j=0;
	     while ((i_str1[i] != ':') && ( i < 132) ) i++;
	     i++;
	     while (i_str1[i] != 0 ) { i_str2[j]=i_str1[i]; i++; j++;}
	     i_str2[j]=0;
	     x=(int)(strtod(i_str2,0));

             set_line_width=x;
	     if ((x > 0) && (x < 5) )
	       { set_line_width=x;}
	     else 
	       { test++;}

	     l=fscanf(set_data,"%s\n",&i_str1);

	     i=0; j=0;
	     while ((i_str1[i] != ':') && ( i < 132) ) i++;
	     i++;
	     while (i_str1[i] != 0 ) { set_color1[j]=i_str1[i]; i++; j++;}
	     set_color1[j]=0;
	     if (j == 0) test++;

	     l=fscanf(set_data,"%s\n",&i_str1);

	     i=0; j=0;
	     while ((i_str1[i] != ':') && ( i < 132) ) i++;
	     i++;
	     while (i_str1[i] != 0 ) { set_color2[j]=i_str1[i]; i++; j++;}  
	     set_color2[j]=0;
	     if (j == 0) test++;

	     l=fscanf(set_data,"%s\n",&i_str1);

             i=0; j=0;
	     while ((i_str1[i] != ':') && ( i < 132) ) i++;
	     i++;
	     while (i_str1[i] != 0 ) { set_color3[j]=i_str1[i]; i++; j++;}  
	     set_color3[j]=0;
	     if (j == 0) test++;

	     l=fscanf(set_data,"%s\n",&i_str1);

	     i=0; j=0;
	     while ((i_str1[i] != ':') && ( i < 132) ) i++;
	     i++;
	     while (i_str1[i] != 0 ) { set_color4[j]=i_str1[i]; i++; j++;}  
	     set_color4[j]=0;
	     if (j == 0) test++;

	     l=fscanf(set_data,"%s\n",&i_str1);

	     i=0; j=0;
	     while ((i_str1[i] != ':') && ( i < 132) ) i++;
	     i++;
	     while (i_str1[i] != 0 ) { set_color5[j]=i_str1[i]; i++; j++;}  
	     set_color5[j]=0;
	     if (j == 0) test++;

	     l=fscanf(set_data,"%s\n",&i_str1);

	     i=0; j=0;
	     while ((i_str1[i] != ':') && ( i < 132) ) i++;
	     i++;
	     while (i_str1[i] != 0 ) { set_color6[j]=i_str1[i]; i++; j++;}  
	     set_color6[j]=0;
	     if (j == 0) test++;

	if (test > 0 ){ 
	       sprintf(message1,"Incorrect options !",test);
	       sprintf(message2,"LineWidth=%d",set_line_width);
	       sprintf(message3,"%s,%s,%s,%s,%s,%s",set_color1,set_color2,set_color3,set_color4,set_color5,set_color6);
	       warning_message(3);
               }
	  }
	else
	  {
 	   sprintf(message1,"No <semia.opt> file !");
	   warning_message(1);
          }

	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections

}

//
// Notify callback function for `m_b_Quit'.
//
void
sem_0_m_bw_m_b_Quit_notify_callback(Panel_item item, Event *event)
{
	sem_0_m_bw_objects *ip = (sem_0_m_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);

	xv_set(Sem_0_m_bw.m_b_Open, PANEL_INACTIVE, FALSE, NULL);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION

	xv_set(Sem_0_q_pw.q_pw, FRAME_CMD_PUSHPIN_IN, TRUE, NULL);
	xv_set(Sem_0_q_pw.q_pw, XV_SHOW, TRUE, NULL);
	
	// gxv_end_connections

}

//
// Notify callback function for `m_b_Lead2'.
//
void
init_Lead2(Panel_item item, Event *event)
{
	sem_0_m_bw_objects *ip = (sem_0_m_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION

	if (xv_get(Sem_0_l_bw2.l_bw2, FRAME_CLOSED))
		xv_set(Sem_0_l_bw2.l_bw2, FRAME_CLOSED, FALSE, NULL);

	xv_set(Sem_0_l_bw2.l_bw2, XV_SHOW, TRUE, NULL);
	
	l_ini_cp2_b(item, event);
	
	// gxv_end_connections

}

//
// Notify callback function for `k_ss_ST'.
//
void
k_call_ST(Panel_item item, int value, Event *event)
{
	sem_0_k_bw_objects *ip = (sem_0_k_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	KL_coefficents=  value == 0 ;
	draw_grid_coeff();
	
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections

}

//
// Notify callback function for `k_ss_1std'.
//
void
k_call_1std(Panel_item item, int value, Event *event)
{
	sem_0_k_bw_objects *ip = (sem_0_k_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (value){
	case 0:  ampl_c=0.1; break;
	case 1:  ampl_c=0.125; break;
	case 2:  ampl_c=0.2; break;
	case 3:  ampl_c=0.25; break;
	case 4:  ampl_c=0.5; break;
	case 5:  ampl_c=1.0; break;
	case 6:  ampl_c=2.0; break;
	case 7:  ampl_c=4.0; break;
	case 8:  ampl_c=5.0; break;
	case 9:  ampl_c=8.0; break;	
	case 10:  ampl_c=10.0; break;	
	case 11:  ampl_c=20.0; break;
      	}

	draw_grid_coeff();

	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections

}

//
// Notify callback function for `k_b_Overlay'.
//
void
k_call_Overlay(Panel_item item, Event *event)
{
	sem_0_k_bw_objects *ip = (sem_0_k_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	if ( !ovr_coef ) {
	  xv_set(Sem_0_k_bw.k_b_Overlay, PANEL_LABEL_STRING, "UnDistF", NULL);
	  ovr_coef=TRUE;
	  draw_ovrly_coeff();
	}
	else {
	  xv_set(Sem_0_k_bw.k_b_Overlay, PANEL_LABEL_STRING, "DistF", NULL);
	  ovr_coef=FALSE;
	  draw_grid_coeff();
	}

	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections

}

//
// Event callback function for `k_cp'.
//
Notify_value
sem_0_k_bw_k_cp_event_callback(Xv_window win, Event *event, Notify_arg arg, Notify_event_type type)
{
	sem_0_k_bw_objects *ip = (sem_0_k_bw_objects *) xv_get(xv_get(win, CANVAS_PAINT_CANVAS_WINDOW), XV_KEY_DATA, INSTANCE);

	// gxv_start_connections DO NOT EDIT THIS SECTION

	if (event_action(event) == ACTION_SELECT)
	{
		k_call_left(win, event, arg, type);
	}
	
	if (event_action(event) == ACTION_ADJUST)
	{
		k_call_center(win, event, arg, type);
	}
	
	if (event_action(event) == ACTION_MENU)
	{
		k_call_right(win, event, arg, type);
	}
	
	// gxv_end_connections

	return notify_next_event_func(win, (Notify_event) event, arg, type);
}

//
// User-defined action for `k_cp'.
//
void
k_call_left(Xv_window win, Event *event, Notify_arg arg, Notify_event_type type)
{
long x,y,i, dx;
long c_Time;
char pr_time[12];

	sem_0_k_bw_objects *ip = (sem_0_k_bw_objects *) xv_get(xv_get(win, CANVAS_PAINT_CANVAS_WINDOW), XV_KEY_DATA, INSTANCE);
	
        x=(event->ie_xevent)->xbutton.x ;
        if (( x < 160 ) OR (x > 1120 )) return;

        c_Time = (long)(FSAMP *(diagram_time_begin_lead+ double(x-160.0)*time_scale_0/960.0));

        i=raw_display_begin;
        while ( (c_Time > data_raw[i].index) && (i < raw_display_end) )
        {  i++; }

        dx= abs(c_Time - data_raw[i].index);

        click_c.first=! click_c.first;

        click_c.x=(event->ie_xevent)->xbutton.x;
        click_c.y=(event->ie_xevent)->xbutton.y;
        if ( click_c.first ){	

   XAllocNamedColor(k_b_display, cmap,"white", &col, & unused);
   XSetForeground(k_b_display, gckoeff, col.pixel);

   XFillRectangle( k_b_display, k_b_window, gckoeff,35,20,112,155);
   XFillRectangle(k_b_display, k_b_window, gckoeff, 40,180,90,15);

   XAllocNamedColor(k_b_display, cmap,"black", &col, & unused);
   XSetForeground(k_b_display, gckoeff, col.pixel);


   sprintf(pr_time, "%s",mstimstr(c_Time));
   XDrawString(k_b_display, k_b_window, gckoeff, 42, 190, pr_time, strlen(pr_time));

   dx= abs(c_Time - data_raw[i].index);
   if (dx == 0) {
     click_c.raw_l=i; click_c.raw_r=i; click_c.raw=i; 
   }
   else { click_c.raw_l=i-1; click_c.raw_r=i;
	  if ( dx < FSAMP / 2) { click_c.raw=i;}
	  else  { click_c.raw=i-1;}
   }
   i=click_c.raw;

  if ( KL_coefficents ) {
//        y_0=157-(double(data_raw[i].ST_f) /5.0 /ampl_c);
	sprintf(pr_buff, "%5.2f  ....................",data_raw[i].STk1/100.0);
	XDrawString(k_b_display, k_b_window, gckoeff, 40, 37, pr_buff, strlen(pr_buff));
	sprintf(pr_buff, "%5.2f  ....................",data_raw[i].STk2/100.0);
	XDrawString(k_b_display, k_b_window, gckoeff, 40, 67, pr_buff, strlen(pr_buff));
	sprintf(pr_buff, "%5.2f  ....................",data_raw[i].STk3/100.0);
	XDrawString(k_b_display, k_b_window, gckoeff, 40, 97, pr_buff, strlen(pr_buff));
	sprintf(pr_buff, "%5.2f  ....................",data_raw[i].STk4/100.0);
	XDrawString(k_b_display, k_b_window, gckoeff, 40, 127, pr_buff, strlen(pr_buff));
	if ( ovr_coef) sprintf(pr_buff, "%5.2f   Dis %5.2f",data_raw[i].STk5/100.0,data_raw[i].ST_f/100.0);
           else sprintf(pr_buff, "%5.2f  ....................",data_raw[i].STk5/100.0);
	XDrawString(k_b_display, k_b_window, gckoeff, 40, 157, pr_buff, strlen(pr_buff));
      }
    else {
//        y_0=157-(double(data_raw[i].QRS_f) /5.0 /ampl_c);
	sprintf(pr_buff, "%5.2f  ....................",data_raw[i].QRSk1/100.0);
	XDrawString(k_b_display, k_b_window, gckoeff, 40, 37, pr_buff, strlen(pr_buff));
	sprintf(pr_buff, "%5.2f  ....................",data_raw[i].QRSk2/100.0);
	XDrawString(k_b_display, k_b_window, gckoeff, 40, 67, pr_buff, strlen(pr_buff));
	sprintf(pr_buff, "%5.2f  ....................",data_raw[i].QRSk3/100.0);
	XDrawString(k_b_display, k_b_window, gckoeff, 40, 97, pr_buff, strlen(pr_buff));
	sprintf(pr_buff, "%5.2f  ....................",data_raw[i].QRSk4/100.0);
	XDrawString(k_b_display, k_b_window, gckoeff, 40, 127, pr_buff, strlen(pr_buff));
	if ( ovr_coef) sprintf(pr_buff, "%5.2f   Dis %5.2f",data_raw[i].QRSk5/100.0,data_raw[i].QRS_f/100.0);
           else sprintf(pr_buff, "%5.2f  ....................",data_raw[i].QRSk5/100.0);
	XDrawString(k_b_display, k_b_window, gckoeff, 40, 157, pr_buff, strlen(pr_buff));
     }        
             }
        else {
   XAllocNamedColor(k_b_display, cmap,"white", &col, & unused);
   XSetForeground(k_b_display, gckoeff, col.pixel);

   XFillRectangle(k_b_display, k_b_window, gckoeff, 35,20,112,155);
   XFillRectangle(k_b_display, k_b_window, gckoeff, 40,180,90,15);

   XAllocNamedColor(k_b_display, cmap,"black", &col, & unused);
   XSetForeground(k_b_display, gckoeff, col.pixel);
    if (  ovr_coef ) { 
         XDrawString(k_b_display, k_b_window, gckoeff, 35,157, "......................Dist.......",33);}
    else {XDrawString(k_b_display, k_b_window, gckoeff, 35,157,"....................................",36); }
	  XDrawString(k_b_display, k_b_window, gckoeff, 35,37, "....................................",36);
	  XDrawString(k_b_display, k_b_window, gckoeff, 35,67, "....................................",36);
	  XDrawString(k_b_display, k_b_window, gckoeff, 35,97, "....................................",36);
	  XDrawString(k_b_display, k_b_window, gckoeff, 35,127, "....................................",36);
	}
}

//
// User-defined action for `k_cp'.
//
void
k_call_center(Xv_window win, Event *event, Notify_arg arg, Notify_event_type type)
{
	sem_0_k_bw_objects *ip = (sem_0_k_bw_objects *) xv_get(xv_get(win, CANVAS_PAINT_CANVAS_WINDOW), XV_KEY_DATA, INSTANCE);

}

//
// User-defined action for `k_cp'.
//
void
k_call_right(Xv_window win, Event *event, Notify_arg arg, Notify_event_type type)
{
	sem_0_k_bw_objects *ip = (sem_0_k_bw_objects *) xv_get(xv_get(win, CANVAS_PAINT_CANVAS_WINDOW), XV_KEY_DATA, INSTANCE);

}

//
// Notify callback function for `o_file_name'.
//
Panel_setting
get_record_name(Panel_item item, Event *event)
{
	sem_0_o_pw_objects *ip = (sem_0_o_pw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	char *	value = (char *) xv_get(item, PANEL_VALUE);

	strcpy(inp_rec_name,"");
	if ((strlen(value) > 6 )|| (strlen(value) < 1 )) {  
	        sprintf(message1, "Incorrect lenght of record name ! ");
		warning_message(1);
		
		xv_set(Sem_0_m_bw.m_m_Record, PANEL_INACTIVE, FALSE, NULL);
		xv_set(Sem_0_o_pw.o_b_OK, PANEL_INACTIVE, TRUE, NULL);
				  }
	else  
	  { strcpy(inp_rec_name,value);
	   xv_set(Sem_0_m_bw.m_m_Record, PANEL_INACTIVE, FALSE, NULL);
	   xv_set(Sem_0_o_pw.o_b_OK, PANEL_INACTIVE,FALSE, NULL);		       
	  }

	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections

	return panel_text_notify(item, event);
}

//
// Notify callback function for `o_b_Cancel'.
//
void
sem_0_o_pw_o_b_Cancel_notify_callback(Panel_item item, Event *event)
{
	sem_0_o_pw_objects *ip = (sem_0_o_pw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION

	xv_set(Sem_0_o_pw.o_pw, FRAME_CMD_PUSHPIN_IN, FALSE, NULL);
	xv_set(Sem_0_o_pw.o_pw, XV_SHOW, FALSE, NULL);
	xv_set(Sem_0_o_pw.o_b_OK, PANEL_INACTIVE, TRUE, NULL);
	
	// gxv_end_connections

}

//
// Notify callback function for `o_b_OK'.
//
void
open_input_record(Panel_item item, Event *event)
{
	sem_0_o_pw_objects *ip = (sem_0_o_pw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);

FILE *file_fin=NULL, *file_raw=NULL;
char fin_name[16], raw_name[16], backup_name[48];
int  succ;
long i,i1;
int n_data;
long hours_b=0, minutes_b=0, seconds_b=0, hour_l=0;
long hours_e=0, minutes_e=0, seconds_e=0;

     long index;
     long HR;
     float  l0_ST80,l0_ST20,
            l1_ST80,l1_ST20,
            l2_ST80,l2_ST20;
     int STk1,STk2,STk3,STk4,STk5,
            ST_f,
            QRSk1,QRSk2,QRSk3,QRSk4,QRSk5,
            QRS_f,
            nPB, nPE, nISO, nQ, nJ, nTB, nTX, nTE;

	xv_set(Sem_0_m_bw.m_m_Record, XV_SHOW, FALSE, NULL);
	
        auto_save_counter = 0;

	sprintf(fin_name,"%s_fin.dmy",inp_rec_name);
        sprintf(raw_name,"%s_raw.dmy",inp_rec_name);
	sprintf(save_name,"%s_1.sta",inp_rec_name);

        file_save=fopen(save_name,"r"); 

       	if (file_save == NULL){
	  sprintf(message1,"No <%s_1.sta> file !",inp_rec_name);
	  sprintf(message2,"",inp_rec_name);
          warning_message(2);		
	  xv_set(Sem_0_o_pw.o_b_OK, PANEL_INACTIVE, TRUE, NULL);
          return;
	}

	file_fin=fopen(fin_name,"r"); file_raw=fopen(raw_name,"r");

       	if ((file_fin == NULL) || (file_raw == NULL)){
	  sprintf(message1,"No <%s_fin.dmy> or",inp_rec_name);
	  sprintf(message2,"     <%s_raw.dmy> file !",inp_rec_name);
          warning_message(2);		
	  xv_set(Sem_0_o_pw.o_b_OK, PANEL_INACTIVE, TRUE, NULL);
          return;
	}

	if ((file_fin != NULL) && (file_raw != NULL)){
	  nsig = isigopen(inp_rec_name, DB_s, WFDB_MAXSIG);
	  if (nsig < 1 ) 
	    {
	      sprintf(message1,"No <%s.hea> or",inp_rec_name);
	      sprintf(message2,"      <%s.dat> file !",inp_rec_name);
              warning_message(2);
	      xv_set(Sem_0_o_pw.o_b_OK, PANEL_INACTIVE, TRUE, NULL);

	      return;
	    }
	  else
	    {
              sprintf(message,"Record:  %s",inp_rec_name);
	      while ( strlen(message) < 46 ) strcat(message," ");
              sprintf(message2,"( %d Lead",nsig);
	      if ( nsig > 1 ) strcat(message2,"s");
	      strcat(message,message2); strcat(message," )");
	      xv_set(Sem_0_m_bw.m_m_Record, PANEL_LABEL_STRING,message, NULL);
	      xv_set(Sem_0_m_bw.m_m_Record,XV_SHOW, TRUE, NULL);
	   
	      xv_set(Sem_0_m_bw.m_b_Data, PANEL_INACTIVE, FALSE, NULL);
	      xv_set(Sem_0_m_bw.m_b_KLCoeff, PANEL_INACTIVE, FALSE, NULL);
	      xv_set(Sem_0_m_bw.m_b_DiagData, PANEL_INACTIVE, FALSE, NULL);
	      xv_set(Sem_0_m_bw.m_b_NumEpis, PANEL_INACTIVE, FALSE, NULL);

	      xv_set(Sem_0_m_bw.m_b_Lead0, PANEL_INACTIVE, FALSE, NULL);
	      xv_set(Sem_0_m_bw.m_b_Open, PANEL_INACTIVE, TRUE, NULL);
	      lead1_data=FALSE; lead2_data=FALSE;
	      xv_set(Sem_0_m_bw.m_b_Lead1, PANEL_INACTIVE, TRUE, NULL);
	      xv_set(Sem_0_m_bw.m_b_Lead2, PANEL_INACTIVE, TRUE, NULL);
	      if (nsig > 1)  { xv_set(Sem_0_m_bw.m_b_Lead1, PANEL_INACTIVE, FALSE, NULL); lead1_data=TRUE;}
	      if (nsig > 2)  { xv_set(Sem_0_m_bw.m_b_Lead2, PANEL_INACTIVE, FALSE, NULL); lead2_data=TRUE;}

	i=0; 

	strcpy(message1,"Reading the data ...");

	xv_set(Sem_0_o_pw.o_b_Cancel, XV_SHOW, FALSE, NULL);
	xv_set(Sem_0_o_pw.o_b_OK, XV_SHOW, FALSE, NULL);
	
	while( ( n_data=fscanf(file_raw,"%ld%d%f%f%f%f%f%f%d%d%d%d%d%d%d%d%d%d%d%d",
		&index,&HR,&l0_ST80,&l1_ST80,&l2_ST80,&l0_ST20,&l1_ST20,&l2_ST20,
                &STk1,&STk2,&STk3,&STk4,&STk5,&ST_f,&QRSk1,&QRSk2,&QRSk3,&QRSk4,&QRSk5,&QRS_f) > 0) &&
	       ( i < LEN_BUFF_R ) ){
	  data_raw[i].index=index;
          data_raw[i].HR=HR;
          data_raw[i].l0_ST80=l0_ST80; data_raw[i].l0_ST20=l0_ST20;
          data_raw[i].l1_ST80=l1_ST80; data_raw[i].l1_ST20=l1_ST20;
          data_raw[i].l2_ST80=l2_ST80; data_raw[i].l2_ST20=l2_ST20;
		  if ( ALL_ONE ){
          data_raw[i].l0_ST80=l0_ST80; data_raw[i].l0_ST20=l0_ST20;
          data_raw[i].l1_ST80=l0_ST80; data_raw[i].l1_ST20=l0_ST20;
          data_raw[i].l2_ST80=l0_ST80; data_raw[i].l2_ST20=l0_ST20;
	  }
          data_raw[i].STk1=STk1; data_raw[i].STk2=STk2; data_raw[i].STk3=STk3; data_raw[i].STk4=STk4; data_raw[i].STk5=STk5;
          data_raw[i].ST_f=ST_f;
          data_raw[i].QRSk1=QRSk1; data_raw[i].QRSk2=QRSk2; data_raw[i].QRSk3=QRSk3; data_raw[i].QRSk4=QRSk4; data_raw[i].QRSk5=QRSk5;
          data_raw[i].QRS_f=QRS_f;

	  data_raw[i].lin_v[0]=0.0; data_raw[i].lin_v[1]=0.0; data_raw[i].lin_v[2]=0.0; 
	  data_raw[i].sub_v[0]=0.0; data_raw[i].sub_v[1]=0.0; data_raw[i].sub_v[2]=0.0;

	  i++;
	}
        i--;

      sprintf(message1,"Data interval:");
      time_begin_lead=IndexToTime(data_raw[0].index);
      raw_last_index=i;
      time_end_lead=IndexToTime(data_raw[i].index);
      diagram_time_begin_lead=time_begin_lead;
      TimeToHoursMinSec(time_begin_lead, &hours_b, &minutes_b, &seconds_b, &hour_l);
      TimeToHoursMinSec(time_end_lead, &hour_l, &minutes_e, &seconds_e, &hours_e);
      sprintf(message2, "[%ld:%ld:%ld - %ld:%ld:%ld]", hours_b, minutes_b, seconds_b, hours_e, minutes_e, seconds_e);
      if ( n_data > 0 ) {	 sprintf(message3,"Some data unread !"); warning_message(3); 
			       }
	      else {
                    warning_message(2);}
	} 

	i=0; 

	strcpy(message1,"Reading the data ...");

	xv_set(Sem_0_o_pw.o_b_Cancel, XV_SHOW, FALSE, NULL);
	xv_set(Sem_0_o_pw.o_b_OK, XV_SHOW, FALSE, NULL);
	
	while( ( n_data=fscanf(file_fin,"%ld%d%f%f%f%f%f%f%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d",
		&index,&HR,&l0_ST80,&l1_ST80,&l2_ST80,&l0_ST20,&l1_ST20,&l2_ST20,
                &STk1,&STk2,&STk3,&STk4,&STk5,&ST_f,&QRSk1,&QRSk2,&QRSk3,&QRSk4,&QRSk5,&QRS_f, &nPB, &nPE, &nISO, &nQ, &nJ, &nTB, &nTX, &nTE
) > 0) &&
	       ( i < LEN_BUFF_F ) ){
	  
	  data_fin[i].index=index;
          data_fin[i].HR=HR;
          data_fin[i].l0_ST80=l0_ST80; data_fin[i].l0_ST20=l0_ST20;
          data_fin[i].l1_ST80=l1_ST80; data_fin[i].l1_ST20=l1_ST20;
          data_fin[i].l2_ST80=l2_ST80; data_fin[i].l2_ST20=l2_ST20;
		  if ( ALL_ONE ){
          data_fin[i].l0_ST80=l0_ST80; data_fin[i].l0_ST20=l0_ST20;
          data_fin[i].l1_ST80=l0_ST80; data_fin[i].l1_ST20=l0_ST20;
          data_fin[i].l2_ST80=l0_ST80; data_fin[i].l2_ST20=l0_ST20;
			  }
          data_fin[i].STk1=STk1; data_fin[i].STk2=STk2; data_fin[i].STk3=STk3; data_fin[i].STk4=STk4; data_fin[i].STk5=STk5;
          data_fin[i].ST_f=ST_f;
          data_fin[i].QRSk1=QRSk1; data_fin[i].QRSk2=QRSk2; data_fin[i].QRSk3=QRSk3; data_fin[i].QRSk4=QRSk4; data_fin[i].QRSk5=QRSk5;
          data_fin[i].QRS_f=QRS_f;
          data_fin[i].nPB=nPB; data_fin[i].nPE=nPE; data_fin[i].nQ=nQ;
	  data_fin[i].nJ=nJ; data_fin[i].nTB=nTB; data_fin[i].nTX=nTX; data_fin[i].nTE=nTE; data_fin[i].nISO=nISO;

	  data_fin[i].lin_v[0]=0.0; data_fin[i].lin_v[1]=0.0; data_fin[i].lin_v[2]=0.0; 
	  data_fin[i].sub_v[0]=0.0; data_fin[i].sub_v[1]=0.0; data_fin[i].sub_v[2]=0.0;

	  i++;
	}
	 i--;

      fin_last_index=i;

      time_begin_lead=IndexToTime(data_fin[0].index);
      time_end_lead=IndexToTime(data_fin[i].index);

      TimeToHoursMinSec(time_begin_lead, &hours_b, &minutes_b, &seconds_b, &hour_l);
      TimeToHoursMinSec(time_end_lead, &hour_l, &minutes_e, &seconds_e, &hours_e);

	  while ( data_raw[raw_last_index].index > data_fin[fin_last_index].index ) raw_last_index--;
	  while ( data_raw[raw_last_index].index < data_fin[fin_last_index-1].index ) fin_last_index--;
          time_end_lead=IndexToTime(data_raw[raw_last_index].index);
	} 
	
	time_begin_lead=0;
	diagram_time_begin_lead=0;

      current_iso_m = data_fin[0].nISO; 
      current_j_m = data_fin[0].nJ;

  long  r_i, end_i;
  long GR_index,act_ind;
  int leadx;

  references_index[0]=-1;  references_index[1]=-1;  references_index[2]=-1;

  if (file_save != NULL ) { 

    reset_global_reference();
    Marker[0].set=FALSE;     Marker[1].set=FALSE;     Marker[2].set=FALSE; 

    n_data=1;
    i=0; leadx=0;
    while ( n_data > 0) {
	n_data=  fscanf(file_save,"%ld %ld %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d \n",&references[leadx][i].raw_index, &references[leadx][i].fine_index,&references[leadx][i].lead, &references[leadx][i].code1, &references[leadx][i].code2, &references[leadx][i].raw_ST80,&references[leadx][i].raw_ST20,&references[leadx][i].ST_sub, &references[leadx][i].fine_ST80,&references[leadx][i].fine_ST20,&references[leadx][i].STd,&references[leadx][i].ST80,&references[leadx][i].STsl,&references[leadx][i].raw_HR,&references[leadx][i].fine_HR,&references[leadx][i].nPB,&references[leadx][i].nPE,&references[leadx][i].nISO,&references[leadx][i].nQ,&references[leadx][i].nJ,&references[leadx][i].nJ80,&references[leadx][i].nTB,&references[leadx][i].nTX,&references[leadx][i].nTE,&references[leadx][i].window,&references[leadx][i].NL,&references[leadx][i].NR,&references[leadx][i].NS);
	
	if ((leadx == 0 ) && (references[leadx][i].lead == 1)){
	  references_index[0]= i-1;
	  references[1][0].copy_ref( references[0][i]); 
	  leadx=1;
	  i=0;
	}
	if ((leadx == 1 ) && (references[leadx][i].lead == 2)){
	  references_index[1]= i-1;
	  references[2][0].copy_ref( references[1][i]); 
	  leadx=2;
	  i=0;
	}
	i++;
	}

    references_index[leadx]= i-2;

	i=0;
	while (!Is_code(0,i,0, -1 )){
	  for (r_i=0; (data_raw[r_i].index != references[0][i].raw_index ); r_i++);
	  references[0][i].raw_index =r_i;
	  for (r_i=0; (data_fin[r_i].index != references[0][i].fine_index ) && (r_i < fin_last_index ); r_i++);
	  references[0][i].fine_index =r_i;
	  i++;
	}
	// GR
	  for (r_i=0; (data_raw[r_i].index != references[0][i].raw_index ) && (r_i < raw_last_index ); r_i++);
	  references[0][i].raw_index =r_i;
	  for (r_i=0; (data_fin[r_i].index != references[0][i].fine_index ) && (r_i < fin_last_index ); r_i++);
	  references[0][i].fine_index =r_i;
	  global_ref[0].copy_ref( references[0][i]);
	  global_ref[0].set=TRUE;
	  global_set=TRUE;

	  act_reference[0].set=TRUE;
	  act_reference[0].change=FALSE;
	  act_reference[0].typ=1; // global
	  act_reference[0].index=-1; 

	  act_reference[1].set=TRUE;
	  act_reference[1].change=FALSE;
	  act_reference[1].typ=1; // global
	  act_reference[1].index=-1; 

	  act_reference[2].set=TRUE;
	  act_reference[2].change=FALSE;
	  act_reference[2].typ=1; // global
	  act_reference[2].index=-1; 

    data_mstime_index= data_fin[global_ref[0].fine_index].index;
    reference_mstime_index= data_mstime_index;
    data_new_r_read(); 
    act_ref_data[0].copy_ref(global_ref[0]);

    new_global_reference(1);
 
    get_average_R();
    data_new_m_read();  

    global_set=TRUE;

	  for (; i < references_index[0]; i++) {
	    references[0][i].copy_ref( references[0][i+1]); 
	    for (r_i=0; (data_raw[r_i].index != references[0][i].raw_index ) && (r_i < raw_last_index ); r_i++);
	    references[0][i].raw_index =r_i;
	    for (r_i=0; (data_fin[r_i].index != references[0][i].fine_index ) && (r_i < fin_last_index ); r_i++);
	    references[0][i].fine_index =r_i;
	
	  }
	  references_index[0]=references_index[0]-1; 
	  reference_act[0]=-1; reference_act[1]=-1; reference_act[2]=-1;

	  if (references_index[1] >= 0 ) {

	i=0;
	while (!Is_code(1,i,0, -1 )){
	  for (r_i=0; (data_raw[r_i].index != references[1][i].raw_index ); r_i++);
	  references[1][i].raw_index =r_i;
	  for (r_i=0; (data_fin[r_i].index != references[1][i].fine_index ) && (r_i < fin_last_index ); r_i++);
	  references[1][i].fine_index =r_i;
	  i++;
	}

	  for (r_i=0; (data_raw[r_i].index != references[1][i].raw_index ) && (r_i < raw_last_index ); r_i++);
	  references[1][i].raw_index =r_i;
	  for (r_i=0; (data_fin[r_i].index != references[1][i].fine_index ) && (r_i < fin_last_index ); r_i++);
	  references[1][i].fine_index =r_i;
	  global_ref[1].copy_ref( references[1][i]);
	  global_ref[1].set=TRUE;
	  act_ref_data[1].copy_ref(global_ref[1]);

	  for (; i < references_index[1]; i++) {
	    references[1][i].copy_ref( references[1][i+1]); 
	    for (r_i=0; (data_raw[r_i].index != references[1][i].raw_index ) && (r_i < raw_last_index ); r_i++);
	    references[1][i].raw_index =r_i;
	    for (r_i=0; (data_fin[r_i].index != references[1][i].fine_index ) && (r_i < fin_last_index ); r_i++);
	    references[1][i].fine_index =r_i;
	
	    }
	  references_index[1]=references_index[1]-1;
	  }
  
	  if (references_index[2] >= 0 ) {

	i=0;
	while (!Is_code(2,i,0, -1 )){
	  for (r_i=0; (data_raw[r_i].index != references[2][i].raw_index ); r_i++);
	  references[2][i].raw_index =r_i;
	  for (r_i=0; (data_fin[r_i].index != references[2][i].fine_index ) && (r_i < fin_last_index ); r_i++);
	  references[2][i].fine_index =r_i;
	  i++;
	}

	  for (r_i=0; (data_raw[r_i].index != references[2][i].raw_index ) && (r_i < raw_last_index ); r_i++);
	  references[2][i].raw_index =r_i;
	  for (r_i=0; (data_fin[r_i].index != references[2][i].fine_index ) && (r_i < fin_last_index ); r_i++);
	  references[2][i].fine_index =r_i;
	  global_ref[2].copy_ref( references[2][i]);
	  global_ref[2].set=TRUE;
	  act_ref_data[2].copy_ref(global_ref[2]);

	  for (; i < references_index[2]; i++) {
	    references[2][i].copy_ref( references[2][i+1]); 
	    for (r_i=0; (data_raw[r_i].index != references[2][i].raw_index ) && (r_i < raw_last_index ); r_i++);
	    references[2][i].raw_index =r_i;
	    for (r_i=0; (data_fin[r_i].index != references[2][i].fine_index ) && (r_i < fin_last_index ); r_i++);
	    references[2][i].fine_index =r_i;
	
	    }
	  references_index[2]=references_index[2]-1;
	  }
      
	fclose(file_save);

data_mstime_index= data_fin[global_ref[0].fine_index].index;
reference_mstime_index= data_fin[global_ref[0].fine_index].index;

   xv_set(Sem_0_d_bw.d_b_OvrRef, PANEL_INACTIVE, FALSE, NULL); 

   data_new_r_read();  

   act_ref_data[0].copy_ref(global_ref[0]);
   act_ref_data[1].copy_ref(global_ref[1]);
   act_ref_data[2].copy_ref(global_ref[2]);
   Marker[0].raw_index=global_ref[0].raw_index;
   Marker[1].raw_index=global_ref[0].raw_index;
   Marker[2].raw_index=global_ref[0].raw_index;

   new_global_reference(3);
   lin_function(0);

    set_buttons_lead0_setGR();
    set_buttons_lead0();
    Lead0_operation=0;

    draw_grid_lead0(0); 

    if (lead1_data ) {
      lin_function(1);
      draw_grid_lead0(1); 
      set_buttons_lead1_setGR();
      set_buttons_lead1();
   }
     if (lead2_data ) {
      lin_function(2);
      draw_grid_lead0(2); 
      set_buttons_lead2_setGR();
      set_buttons_lead2();
   }

    show_data(Data_lead,TRUE, FALSE);
 
    int l;
    l=0;

    } // read annottations

	xv_set(Sem_0_o_pw.o_b_Cancel, XV_SHOW, TRUE, NULL);
       	xv_set(Sem_0_o_pw.o_b_OK, XV_SHOW, TRUE, NULL);
      	xv_set(Sem_0_o_pw.o_m_message1, XV_SHOW, FALSE, NULL);

	// gxv_start_connections DO NOT EDIT THIS SECTION

	xv_set(Sem_0_o_pw.o_pw, FRAME_CMD_PUSHPIN_IN, FALSE, NULL);
	xv_set(Sem_0_o_pw.o_pw, XV_SHOW, FALSE, NULL);
	
	// gxv_end_connections
}

//
// Notify callback function for `q_b_Cancel'.
//
void
sem_0_q_pw_q_b_Cancel_notify_callback(Panel_item item, Event *event)
{
	sem_0_q_pw_objects *ip = (sem_0_q_pw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION

	xv_set(Sem_0_q_pw.q_pw, FRAME_CMD_PUSHPIN_IN, FALSE, NULL);
	xv_set(Sem_0_q_pw.q_pw, XV_SHOW, FALSE, NULL);
	
	// gxv_end_connections
}

//
// Notify callback function for `q_b_Quit'.
//
void
semia_terminate(Panel_item item, Event *event)
{
	sem_0_q_pw_objects *ip = (sem_0_q_pw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION

	xv_set(Sem_0_o_pw.o_pw, FRAME_CMD_PUSHPIN_IN, FALSE, NULL);
	xv_set(Sem_0_o_pw.o_pw, XV_SHOW, FALSE, NULL);
	
	xv_set(Sem_0_k_bw.k_bw, XV_SHOW, FALSE, NULL);
	
	xv_set(Sem_0_m_bw.m_bw, XV_SHOW, FALSE, NULL);
	
	xv_set(Sem_0_q_pw.q_pw, FRAME_CMD_PUSHPIN_IN, FALSE, NULL);
	xv_set(Sem_0_q_pw.q_pw, XV_SHOW, FALSE, NULL);
	
	xv_set(Sem_0_w_pw.w_pw, FRAME_CMD_PUSHPIN_IN, FALSE, NULL);
	xv_set(Sem_0_w_pw.w_pw, XV_SHOW, FALSE, NULL);
	
	xv_set(Sem_0_d_bw.d_bw, XV_SHOW, FALSE, NULL);
	
	xv_set(Sem_0_l_bw.l_bw, XV_SHOW, FALSE, NULL);
	
	xv_set(Sem_0_d_pw.d_pw, FRAME_CMD_PUSHPIN_IN, FALSE, NULL);
	xv_set(Sem_0_d_pw.d_pw, XV_SHOW, FALSE, NULL);
	
	xv_set(Sem_0_c_pw.c_pw, FRAME_CMD_PUSHPIN_IN, FALSE, NULL);
	xv_set(Sem_0_c_pw.c_pw, XV_SHOW, FALSE, NULL);

	xv_set(Sem_0_h_pw.h_pw, FRAME_CMD_PUSHPIN_IN, FALSE, NULL);
	xv_set(Sem_0_h_pw.h_pw, XV_SHOW, FALSE, NULL);

	xv_set(Sem_0_l_bw1.l_bw1, XV_SHOW, FALSE, NULL);
	
	xv_set(Sem_0_l_bw2.l_bw2, XV_SHOW, FALSE, NULL);
	
	// gxv_end_connections

	exit(0);
}

//
// Notify callback function for `w_b_OK'.
//
void
sem_0_w_pw_w_b_OK_notify_callback(Panel_item item, Event *event)
{
	sem_0_w_pw_objects *ip = (sem_0_w_pw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION

	xv_set(Sem_0_w_pw.w_pw, FRAME_CMD_PUSHPIN_IN, FALSE, NULL);
	xv_set(Sem_0_w_pw.w_pw, XV_SHOW, FALSE, NULL);
	
	// gxv_end_connections

}

//
// Notify callback function for `d_ss_16s'.
//
void
d_call_16s(Panel_item item, int value, Event *event)
{
	sem_0_d_bw_objects *ip = (sem_0_d_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (value){
	case 0:   current_average_window_time= 0;   break; // single
	case 1:   current_average_window_time= 1;   break; // 2 sec
	case 2:   current_average_window_time= 2 ;   break; // 4 sec
	case 3:   current_average_window_time= 3 ;   break; // 6 sec
	case 4:   current_average_window_time= 5 ;   break; // 10 sec
	case 5:   current_average_window_time= 8 ;   break; // 16 sec  - default
	case 6:   current_average_window_time= 10 ;   break; // 20 sec
	case 7:   current_average_window_time= 15 ;   break; // 30 sec
	case 8:   current_average_window_time= 30 ;   break; // 60 sec
	case 9:   current_average_window_time= 60 ;   break; // 120 sec = 2 min
	case 10:   current_average_window_time= 90 ;   break; // 180 sec = 3 min
	case 11:   current_average_window_time= 120 ;   break; // 240 sec = 4 min
	case 12:   current_average_window_time= 150 ;   break; // 300 sec = 5 min
	}

	Marker[Data_lead].window= 2 * current_average_window_time;
 	current_average_window_index=current_average_window_time * FSAMP; // sec to index

	if ( (act_reference[0].set ) && (act_reference[0].change ) ) {
	  if ( act_reference[0].typ == 1 )  {          
	    act_ref_data[Data_lead].window=Marker[Data_lead].window;
	    get_average_R();}
	}
 
	if (  last_set_all ) {
	     Marker[0].window= 2 * current_average_window_time; update_marker(0,161);
	     if (lead1_data) {Marker[1].window= 2 * current_average_window_time;update_marker(1,100161);}
	     if (lead2_data) {Marker[2].window= 2 * current_average_window_time;update_marker(2,200161);}
	}
	else update_marker(Data_lead,25);

	if ( (act_reference[0].set ) && (act_reference[0].change ) ) {
	  if ( act_reference[0].typ == 1 )  {          
                    update_global_ref(0,TRUE,33);
                    act_ref_data[0].copy_ref(global_ref[0]); 
                    update_marker(0,34); 
						  
	     if (lead1_data) { update_global_ref(1,TRUE,10036); act_ref_data[1].copy_ref(global_ref[1]);
	                       update_marker(1,10040);  }

             if (lead2_data) { update_global_ref(2,TRUE,20038); act_ref_data[2].copy_ref(global_ref[2]); 
                               update_marker(2,20041);  }
	                                 }
	}

       if (status_consider_localref) { 
	 if ((reference_act[Data_lead] >= 0 ) && ( Marker[Data_lead].raw_index  ==  references[Data_lead][reference_act[Data_lead]].raw_index )  ){
	  if ( Is_code(Data_lead,reference_act[Data_lead],4,0) ) { // dumy 
	    update_act_ann(0, reference_act[0], TRUE,27);
	    if (lead1_data) { update_act_ann(1, reference_act[1], TRUE,10030);}
	    if (lead2_data) { update_act_ann(2, reference_act[2], TRUE,20031);}
	  }
	  else {
	    // 

	    if ( Is_code(Data_lead,reference_act[Data_lead],18,0) ) {  update_act_ann(Data_lead, reference_act[Data_lead], TRUE, 23); }
	      else
	    // 

	    update_act_ann(Data_lead, reference_act[Data_lead], FALSE,32);
	  }
	}
      	}
	show_data(Data_lead,TRUE, FALSE);

	// write_ref_data_l0();

	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections

}

//
// Notify callback function for `d_ss_520ms'.
//
void
d_call_520ms(Panel_item item, int value, Event *event)
{
	sem_0_d_bw_objects *ip = (sem_0_d_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	current_average_beat_time=200 + 80 *value ; // 200 m sec
        d_avrg_index = current_average_beat_time / ( 1000 / FSAMP ) /2 ;

       	if ( (act_reference[0].set ) && (act_reference[0].change ) ) {
	  if ( act_reference[0].typ == 1 )  {          
	    act_ref_data[Data_lead].window=Marker[Data_lead].window;
	    data_mstime_index= data_fin[Marker[Data_lead].fine_index].index;
	    reference_mstime_index= data_mstime_index;
	    data_new_r_read(); 
	    get_average_R();}
	}
 
	if (  last_set_all ) {
	     update_marker(0,162);
	     if (lead1_data) {update_marker(1,100162);}
	     if (lead2_data) {update_marker(2,200162);}
	}
	else update_marker(Data_lead,163);

	if ( (act_reference[0].set ) && (act_reference[0].change ) ) {
	  if ( act_reference[0].typ == 1 )  {          
                    update_global_ref(0,TRUE,164);
                    act_ref_data[0].copy_ref(global_ref[0]); 
                    update_marker(0,165); 
						  
	     if (lead1_data) { update_global_ref(1,TRUE,100166); act_ref_data[1].copy_ref(global_ref[1]);
	                       update_marker(1,100167);  }

             if (lead2_data) { update_global_ref(2,TRUE,200168); act_ref_data[2].copy_ref(global_ref[2]); 
                               update_marker(2,200169);  }
	                                 }
	}

       if (status_consider_localref) { 
	if (reference_act[Data_lead] >= 0 ){
	  if ( Is_code(Data_lead,reference_act[Data_lead],4,0) ) { // dumy 
	    update_act_ann(0, reference_act[0], TRUE,170);
	    if (lead1_data) { update_act_ann(1, reference_act[1], TRUE,100171);}
	    if (lead2_data) { update_act_ann(2, reference_act[2], TRUE,100172);}
	  }
	  else {
	    //

	    if ( Is_code(Data_lead,reference_act[Data_lead],18,0) ) {  update_act_ann(Data_lead, reference_act[Data_lead], TRUE, 23); }
	      else
	    // 

	    update_act_ann(Data_lead, reference_act[Data_lead], FALSE,173);

	  }
	}
       	}
	show_data(Data_lead,TRUE, FALSE);

	// write_ref_data_l0();

	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `d_ss_6s'.
//
void
d_call_6s(Panel_item item, int value, Event *event)
{
	sem_0_d_bw_objects *ip = (sem_0_d_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (value){
	case 0:   data_scale= 1; data_tick=80;  break; // 80*960/1000 / 1
	case 1:   data_scale = 2; data_tick=80; break;
	case 2:   data_scale = 4; data_tick=80;break;
	case 3:   data_scale = 5; data_tick=160;break;
	case 4:  data_scale = 6; data_tick=160;break;
	case 5:  data_scale = 8; data_tick=160;break;
	case 6:  data_scale = 10; data_tick=160;break;
	case 7:  data_scale = 12; data_tick=320;break;
	case 8:  data_scale = 15; data_tick=320;break;
	case 9:  data_scale = 20; data_tick=320;break;
	case 10: data_scale = 25; data_tick=640; break;	
	case 11: data_scale = 30; data_tick=640;break;
	case 12: data_scale = 45; data_tick=1280; break;	
	case 13: data_scale = 60; data_tick=1280;break;
	} 

	data_grid_tick= data_tick * 960.0 / data_scale / 1000.0;

	show_data(Data_lead,TRUE,FALSE);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `d_ss_1mV'.
//
void
d_call_1mV(Panel_item item, int value, Event *event)
{
	sem_0_d_bw_objects *ip = (sem_0_d_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (value){
	case 0:   ampl_d= 50;   break; // 50 uV
	case 1:   ampl_d= 75;   break;
	case 2:   ampl_d= 100;   break;
	case 3:   ampl_d= 125;   break;
	case 4:   ampl_d= 150;   break;
	case 5:   ampl_d= 200;   break;
	case 6:   ampl_d= 250;   break;
	case 7:   ampl_d= 500;   break;
	case 8:   ampl_d= 750;   break;
	case 9:   ampl_d= 1000;   break; // default 1mV
	case 10:   ampl_d= 2000;   break;
	case 11:   ampl_d= 5000;   break;
	}

	show_data(Data_lead,TRUE,FALSE);
		
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `d_b_OvrLds_menu'.
//
void
d_call_menu_OvrLds(Panel_item item, Event *event)
{
	sem_0_d_bw_objects *ip = (sem_0_d_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
		
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `d_b_OvrRef'.
//
void
d_call_OvrRef(Panel_item item, Event *event)
{
	sem_0_d_bw_objects *ip = (sem_0_d_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	if (!data_ovr_ref ) {
	  xv_set(Sem_0_d_bw.d_b_OvrRef, PANEL_LABEL_STRING, "UnOvrRef", NULL);
	  data_ovr_ref=TRUE;
	}
	else {
	  xv_set(Sem_0_d_bw.d_b_OvrRef, PANEL_LABEL_STRING, "OvrRef", NULL);
	  data_ovr_ref=FALSE;
	}

	show_data(Data_lead,FALSE, FALSE);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Event callback function for `d_cp'.
//
Notify_value
sem_0_d_bw_d_cp_event_callback(Xv_window win, Event *event, Notify_arg arg, Notify_event_type type)
{
	sem_0_d_bw_objects *ip = (sem_0_d_bw_objects *) xv_get(xv_get(win, CANVAS_PAINT_CANVAS_WINDOW), XV_KEY_DATA, INSTANCE);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION

	if (event_action(event) == ACTION_SELECT)
	{
		d_call_left(win, event, arg, type);
	}
	
	if (event_action(event) == ACTION_ADJUST)
	{
		d_call_center(win, event, arg, type);
	}
	
	if (event_action(event) == ACTION_MENU)
	{
		d_call_right(win, event, arg, type);
	}
	
	// gxv_end_connections

	return notify_next_event_func(win, (Notify_event) event, arg, type);
}

//
// User-defined action for `d_cp'.
//
void
d_call_left(Xv_window win, Event *event, Notify_arg arg, Notify_event_type type)
{
	sem_0_d_bw_objects *ip = (sem_0_d_bw_objects *) xv_get(xv_get(win, CANVAS_PAINT_CANVAS_WINDOW), XV_KEY_DATA, INSTANCE);
}

//
// User-defined action for `d_cp'.
//
void
d_call_center(Xv_window win, Event *event, Notify_arg arg, Notify_event_type type)
{
	sem_0_d_bw_objects *ip = (sem_0_d_bw_objects *) xv_get(xv_get(win, CANVAS_PAINT_CANVAS_WINDOW), XV_KEY_DATA, INSTANCE);
}

//
// User-defined action for `d_cp'.
//
void
d_call_right(Xv_window win, Event *event, Notify_arg arg, Notify_event_type type)
{
	sem_0_d_bw_objects *ip = (sem_0_d_bw_objects *) xv_get(xv_get(win, CANVAS_PAINT_CANVAS_WINDOW), XV_KEY_DATA, INSTANCE);
}

//
// Notify callback function for `l_b_shift_ll'.
//
void
l_call_shift_ll(Panel_item item, Event *event)
{
	sem_0_l_bw_objects *ip = (sem_0_l_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
		
long x,y;

        y=TimeToIndex(diagram_time_begin_lead);

        if ( TimeToIndex(diagram_time_begin_lead) > TimeToIndex(time_begin_lead)) {
	  x=TimeToIndex(diagram_time_begin_lead-time_scale_0);
	  if ( x < 0 ) x=0;

	  xv_set(Sem_0_l_bw.l_b_shift_r, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_rr, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_r1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_rr1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_r2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_rr2, PANEL_INACTIVE, FALSE, NULL);

	}
	else
	  {
	    x=0;
	     xv_set(Sem_0_l_bw.l_b_shift_ll, PANEL_INACTIVE, TRUE, NULL);
	     xv_set(Sem_0_l_bw1.l_b_shift_ll1, PANEL_INACTIVE, TRUE, NULL);
	     xv_set(Sem_0_l_bw1.l_b_shift_ll1, PANEL_INACTIVE, TRUE, NULL);

	     sprintf(message1,"You are at the beginning of data !"); 
	     warning_message(1);
	  }
	  diagram_time_begin_lead=IndexToTime(x);

	  draw_grid_lead0(0);

	  if (lead1_data )  draw_grid_lead0(1); 
	  if (lead2_data )  draw_grid_lead0(2); 
	  draw_grid_coeff();

	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_b_shift_l'.
//
void
l_call_shift_l(Panel_item item, Event *event)
{
	sem_0_l_bw_objects *ip = (sem_0_l_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
long x,y;

        y=TimeToIndex(diagram_time_begin_lead);
        if ( (x=TimeToIndex(diagram_time_begin_lead-time_scale_0/2)) >= TimeToIndex(time_begin_lead)) {

	  xv_set(Sem_0_l_bw.l_b_shift_rr, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_r, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_rr1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_r1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_rr2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_r2, PANEL_INACTIVE, FALSE, NULL);

	}
	else
	  {
	    x=0;
       	     xv_set(Sem_0_l_bw.l_b_shift_l, PANEL_INACTIVE, TRUE, NULL);
	     xv_set(Sem_0_l_bw.l_b_shift_ll, PANEL_INACTIVE, TRUE, NULL);
       	     xv_set(Sem_0_l_bw1.l_b_shift_l1, PANEL_INACTIVE, TRUE, NULL);
	     xv_set(Sem_0_l_bw1.l_b_shift_ll1, PANEL_INACTIVE, TRUE, NULL);
       	     xv_set(Sem_0_l_bw2.l_b_shift_l2, PANEL_INACTIVE, TRUE, NULL);
	     xv_set(Sem_0_l_bw2.l_b_shift_ll2, PANEL_INACTIVE, TRUE, NULL);
	     sprintf(message1,"You are at the beginning of data !"); 
	     warning_message(1);
	  }

	  diagram_time_begin_lead=IndexToTime(x);

	  draw_grid_lead0(0);

	  if (lead1_data )  draw_grid_lead0(1); 
	  if (lead2_data )  draw_grid_lead0(2); 
	  draw_grid_coeff();	

	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_b_shift_r'.
//
void
l_call_shift_r(Panel_item item, Event *event)
{
	sem_0_l_bw_objects *ip = (sem_0_l_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
long x,y;

        y=TimeToIndex(diagram_time_begin_lead);
        if ( (x=TimeToIndex(diagram_time_begin_lead+time_scale_0/2)) <= TimeToIndex(time_end_lead)) {

	  xv_set(Sem_0_l_bw.l_b_shift_ll, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_l, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_ll1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_l1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_ll2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_l2, PANEL_INACTIVE, FALSE, NULL);
	}
	else
	  {
            x=TimeToIndex(time_end_lead);

	    y = x % 60000;
	    if ( y  > 30000 )  { y = - (60000 -y); }
	    x=x - y;
	    if (x < 0 ) x=0;

	    xv_set(Sem_0_l_bw.l_b_shift_r, PANEL_INACTIVE, TRUE, NULL);
	    xv_set(Sem_0_l_bw.l_b_shift_rr, PANEL_INACTIVE, TRUE, NULL);
	    xv_set(Sem_0_l_bw1.l_b_shift_r1, PANEL_INACTIVE, TRUE, NULL);
	    xv_set(Sem_0_l_bw1.l_b_shift_rr1, PANEL_INACTIVE, TRUE, NULL);
	    xv_set(Sem_0_l_bw2.l_b_shift_r2, PANEL_INACTIVE, TRUE, NULL);
	    xv_set(Sem_0_l_bw2.l_b_shift_rr2, PANEL_INACTIVE, TRUE, NULL);
	     sprintf(message1,"You are at the end of data !"); 
	     warning_message(1);
	  }

	  diagram_time_begin_lead=IndexToTime(x);
	  xv_set(Sem_0_l_bw.l_b_shift_ll, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_l, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_ll1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_l1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_ll2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_l2, PANEL_INACTIVE, FALSE, NULL);

	  draw_grid_lead0(0);
	
	  if (lead1_data )  draw_grid_lead0(1); 
	  if (lead2_data )  draw_grid_lead0(2); 
	  draw_grid_coeff();

	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_b_shift_rr'.
//
void
l_call_shift_rr(Panel_item item, Event *event)
{
	sem_0_l_bw_objects *ip = (sem_0_l_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
long x,y;

        y=TimeToIndex(diagram_time_begin_lead);
        if ( (x=TimeToIndex(diagram_time_begin_lead+time_scale_0)) <= TimeToIndex(time_end_lead)) {

	  xv_set(Sem_0_l_bw.l_b_shift_ll, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_l, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_ll1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_l1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_ll2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_l2, PANEL_INACTIVE, FALSE, NULL);
	}
	else
	  {
            x=TimeToIndex(time_end_lead);

	    y = x % 60000;
	    if ( y  > 30000 )  { y = - (60000 -y); }
	    x=x - y;
	    if (x < 0 ) x=0;

	     xv_set(Sem_0_l_bw.l_b_shift_rr, PANEL_INACTIVE, TRUE, NULL);
	     xv_set(Sem_0_l_bw1.l_b_shift_rr1, PANEL_INACTIVE, TRUE, NULL);
	     xv_set(Sem_0_l_bw2.l_b_shift_rr2, PANEL_INACTIVE, TRUE, NULL);
	     sprintf(message1,"You are at the end of data !"); 
	     warning_message(1);
	  }

       	  diagram_time_begin_lead=IndexToTime(x);
	  xv_set(Sem_0_l_bw.l_b_shift_ll, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_l, PANEL_INACTIVE, FALSE, NULL);

	  draw_grid_lead0(0);    

	  if (lead1_data )  draw_grid_lead0(1); 
	  if (lead2_data )  draw_grid_lead0(2); 

	  draw_grid_coeff();

	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_ss_HRate'.
//
void
l_call_HRate(Panel_item item, int value, Event *event)
{
	sem_0_l_bw_objects *ip = (sem_0_l_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	reset_HR_lead0(0);

	switch (value){
	case 0:  lead0_plot_button_status.HRate=TRUE; break;
	case 1:  lead0_plot_button_status.HRRaw=TRUE;break;
	case 2:  lead0_plot_button_status.STFine=TRUE;break;
	case 3:  lead0_plot_button_status.STslFine=TRUE;break;
	case 4:  lead0_plot_button_status.STslRaw=TRUE;break;
	case 5:  lead0_plot_button_status.Episodes=TRUE;break;
	case 6:  lead0_plot_button_status.HideHR=TRUE;	break;
	case 7:  lead0_plot_button_status.ISOJ=TRUE;  break;
	case 8:  lead0_plot_button_status.HRate=TRUE; 	  
	  xv_set(Sem_0_l_bw.l_ss_HRate, PANEL_VALUE, 0, NULL);
	  break;
	case 9:  lead0_plot_button_status.HRate=TRUE; 	  
	  xv_set(Sem_0_l_bw.l_ss_HRate, PANEL_VALUE, 0, NULL);
	  break;

		} // end select
     
	draw_grid_lead0(0);

	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_ss_12min'.
//
void
l_call_12min(Panel_item item, int value, Event *event)
{
	sem_0_l_bw_objects *ip = (sem_0_l_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (value){
	case 0: time_scale_0=60; break;
	case 1: time_scale_0=120; break;
	case 2: time_scale_0=180; break;
	case 3: time_scale_0=360; break;
	case 4: time_scale_0=540; break;
	case 5: time_scale_0=720; break;
	case 6: time_scale_0=1440; break;
	case 7: time_scale_0=1800; break;
	case 8: time_scale_0=3600; break;
	case 9: time_scale_0=7200; break;
	case 10: time_scale_0=14400; break;
	case 11: time_scale_0=21600; break;
	case 12: time_scale_0=43200; break;
	case 13: time_scale_0=86400; break;
	case 14: time_scale_0=172800; break;
	case 15: time_scale_0=345600; break;
	} 

   scale_time_tick=(long)(time_scale_0 / 12.0);
	  xv_set(Sem_0_l_bw.l_b_shift_ll, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_l, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_rr, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_r, PANEL_INACTIVE, FALSE, NULL);

	  xv_set(Sem_0_l_bw1.l_b_shift_ll1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_l1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_rr1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_r1, PANEL_INACTIVE, FALSE, NULL);

	  xv_set(Sem_0_l_bw2.l_b_shift_ll2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_l2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_rr2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_r2, PANEL_INACTIVE, FALSE, NULL);

	 xv_set(Sem_0_l_bw1.l_ss_12min1, PANEL_VALUE,value,NULL);
	 xv_set(Sem_0_l_bw2.l_ss_12min2, PANEL_VALUE,value,NULL);
	
         draw_grid_lead0(0);

	 if (lead1_data )  draw_grid_lead0(1); 
	 if (lead2_data )  draw_grid_lead0(2); 
	  draw_grid_coeff();

	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_ss_100mV'.
//
void
l_call_100mV(Panel_item item, int value, Event *event)
{
	sem_0_l_bw_objects *ip = (sem_0_l_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (value){
	case 0: ampl_0=20; break;
	case 1: ampl_0=25; break;
	case 2: ampl_0=50; break;
	case 3: ampl_0=75; break;
	case 4: ampl_0=100; break;
	case 5: ampl_0=125; break;
	case 6: ampl_0=150; break;
	case 7: ampl_0=200; break;
	case 8: ampl_0=250; break;
	case 9: ampl_0=500; break;
	case 10: ampl_0=750; break;
	case 11: ampl_0=1000; break;
	case 12: ampl_0=2000; break;
	case 13: ampl_0=5000; break;
	} 
	draw_grid_lead0(0);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION

	// gxv_end_connections
}

//
// Notify callback function for `l_b_Mark'.
//
void
l_call_Mark(Panel_item item, Event *event)
{
	sem_0_l_bw_objects *ip = (sem_0_l_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	Lead0_operation=1;
	sub_op0_start();

	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}


//
// Notify callback function for `l_b_Subtr'.
//
void
l_call_Subtr(Panel_item item, Event *event)
{
	sem_0_l_bw_objects *ip = (sem_0_l_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	if ( status_unsubtracted ) {
	  Lead0_buttons.Subtr_s=2;
	  status_unsubtracted =FALSE;

          if (status_manual_mode) 
                set_buttons_lead0_subtr_manual();
          else
                set_buttons_lead0_subtr_auto();   
	}
	else {
	  Lead0_buttons.Subtr_s=1;
	  status_unsubtracted =TRUE;

          if (status_manual_mode)
                 set_buttons_lead0_unsubtr_manual();
          else
                 set_buttons_lead0_unsubtr_auto();
	}

	set_buttons_lead0(); draw_grid_lead0(0); 
		
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_b_OvrApp'.
//
void
l_call_OvrApp(Panel_item item, Event *event)
{
	sem_0_l_bw_objects *ip = (sem_0_l_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	if ( Lead0_buttons.OvrApp_s == 1 ) {
	    Lead0_buttons.OvrApp_s=2; ovr0_app = TRUE;
	}
	else {
	    Lead0_buttons.OvrApp_s=1; ovr0_app = FALSE;
	}

	set_buttons_lead0();   draw_grid_lead0(0); 

	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_b_OvrLds_menu'.
//
void
l_call_menu_OvrLds(Panel_item item, Event *event)
{
	sem_0_l_bw_objects *ip = (sem_0_l_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
		
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_b_Exm'.
//
void
l_call_Exm(Panel_item item, Event *event)
{
	sem_0_l_bw_objects *ip = (sem_0_l_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	Lead0_operation=9;
	sub_op0_start();
	
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_b_ConsLR'.
//
void
l_call_ConsLR(Panel_item item, Event *event)
{
	sem_0_l_bw_objects *ip = (sem_0_l_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	if ( status_manual_mode && status_unsubtracted && Lead0_buttons.ConsLR_s == 1 ) {
	  if ( reference_act[0] > -1 )
	  if ( Is_code(0,reference_act[0],0,0)) {
	    Lead0_buttons.ConsLR_s=2;
	    status_consider_localref=FALSE;
            set_buttons_lead0_conslr();

	      act_ref_data[0].copy_ref(references[0][reference_act[0]]);

	      act_reference[0].set=TRUE;
	      act_reference[0].change=FALSE;
	      act_reference[1].change=FALSE;
	      act_reference[2].change=FALSE;
	      act_reference[0].typ=2; // local
	      act_reference[0].index=reference_act[0];

	      data_mstime_index= data_fin[Marker[0].fine_index].index;
	      reference_mstime_index= data_fin[act_ref_data[0].fine_index].index;
 
	      data_new_r_read();
	      get_average_R();
	      update_marker(0,192);

	    draw_grid_lead0(0); 
	    show_data(0,FALSE, FALSE);

	    } // end cons loc ref 
	}
	else if ( Lead0_buttons.ConsLR_s == 2 ) { 
	    Lead0_buttons.ConsLR_s=1;
	    status_consider_localref=TRUE;
            set_buttons_lead0_unsubtr_manual();

	    if ( global_ref[0].set) {
	      act_ref_data[0].copy_ref(global_ref[0]);
	      act_ref_data[0].code1=0;

	      act_reference[0].set=TRUE;
	      act_reference[0].change=FALSE;
	      act_reference[1].change=FALSE;
	      act_reference[2].change=FALSE;
	      act_reference[0].typ=1; // global
	      act_reference[0].index=-1;

	      data_mstime_index= data_fin[Marker[0].fine_index].index;
	      reference_mstime_index= data_fin[act_ref_data[0].fine_index].index;

	      data_new_r_read();
	      get_average_R();
	      update_marker(0,192);

	    } // end cons loc ref 
	      draw_grid_lead0(0); 
	      show_data(0,FALSE, FALSE);
	}
	set_buttons_lead0();

	// gxv_start_connections DO NOT EDIT THIS SECTION

	// gxv_end_connections

}

//
// Event callback function for `l_cp'.
//
Notify_value
sem_0_l_bw_l_cp_event_callback(Xv_window win, Event *event, Notify_arg arg, Notify_event_type type)
{
	sem_0_l_bw_objects *ip = (sem_0_l_bw_objects *) xv_get(xv_get(win, CANVAS_PAINT_CANVAS_WINDOW), XV_KEY_DATA, INSTANCE);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION

	if (event_action(event) == ACTION_SELECT)
	{
		l_call_left(win, event, arg, type);
	}
	
	if (event_action(event) == ACTION_ADJUST)
	{
		l_call_center(win, event, arg, type);
	}
	
	if (event_action(event) == ACTION_MENU)
	{
		l_call_right(win, event, arg, type);
	}
	
	// gxv_end_connections

	return notify_next_event_func(win, (Notify_event) event, arg, type);
}

//
// Repaint callback function for `l_cp'.
//
void
l_ini_lcp(Canvas canvas, Xv_window paint_window, Display *display, Window xid, Xv_xrectlist *rects)
{

	gcLead0 = DefaultGC(display, DefaultScreen(display));
	l_b_display = display;
	l_b_window = xid;

	// gxv_start_connections DO NOT EDIT THIS SECTION

	// gxv_end_connections

}

//
// User-defined action for `l_cp'.
//
void
l_call_left(Xv_window win, Event *event, Notify_arg arg, Notify_event_type type)
{
	sem_0_l_bw_objects *ip = (sem_0_l_bw_objects *) xv_get(xv_get(win, CANVAS_PAINT_CANVAS_WINDOW), XV_KEY_DATA, INSTANCE);
	
long x,y,i, dx;
long c_Time;
char pr_time[12];

int lead = 0;

        x=(event->ie_xevent)->xbutton.x ;
        c_Time = (long)(FSAMP *(diagram_time_begin_lead+ double(x-160.0)*time_scale_0/960.0));

	if ( ( c_Time < data_raw[raw_display_begin].index) || ( c_Time > data_fin[fin_display_end].index ) ) return;

        i=raw_display_begin;
        while ( (c_Time > data_raw[i].index) && (i < (raw_display_end)) ) i++;
        dx= abs(c_Time - data_raw[i].index);

        click_l0.first=! click_l0.first;

        click_l0.x=(event->ie_xevent)->xbutton.x;
        click_l0.y=(event->ie_xevent)->xbutton.y;
        if ( click_l0.first ){	

   dx= abs(c_Time - data_raw[i].index);
   if (dx == 0) {
     click_l0.raw_l=i; click_l0.raw_r=i; click_l0.raw=i; 
   }
   else { click_l0.raw_l=i-1; click_l0.raw_r=i;
	  if ( dx < FSAMP) { click_l0.raw=i;}
	  else  { click_l0.raw=i-1;}
   }
   i=click_l0.raw;

   i=fin_display_begin;

   while ( ( data_raw[click_l0.raw].index > data_fin[i].index) && (i < (fin_display_end+1)) )
     {

 i++;
 }
   dx= abs( data_raw[click_l0.raw].index - data_fin[i].index);
   if (dx == 0) {
     click_l0.fine_l=i; click_l0.fine_r=i; click_l0.fine=i; 
   }
   else { click_l0.fine_l=i-1; click_l0.fine_r=i;
	  click_l0.fine=i;
   }
   i=click_l0.fine;

   XAllocNamedColor(l_b_display, cmap,set_color8, &col, & unused);
   XSetForeground(l_b_display, gcLead0, col.pixel);

 if (Lead0_operation == 0 || ( Lead0_operation != 0 && click_l0.y > BORDER_SEP_CLICK) ) {
  if ( click_l0.y > BORDER_SEP_CLICK ) {

   XFillRectangle(l_b_display, l_b_window, gcLead0, 40,162,90,15);

   XAllocNamedColor(l_b_display, cmap,"black", &col, & unused);
   XSetForeground(l_b_display, gcLead0, col.pixel);

   sprintf(pr_time, "%s",mstimstr(c_Time));
   XDrawString(l_b_display, l_b_window, gcLead0, 42, 174, pr_time, strlen(pr_time));

   XAllocNamedColor(l_b_display, cmap,"white", &col, & unused);
   XSetForeground(l_b_display, gcLead0, col.pixel);
   XFillRectangle(l_b_display, l_b_window, gcLead0, 1,55,130,90);

   XAllocNamedColor(l_b_display, cmap,set_color8, &col, & unused);
   XSetForeground(l_b_display, gcLead0, col.pixel);
   XFillRectangle(l_b_display, l_b_window, gcLead0, 1, 55,130,12);
   XFillRectangle(l_b_display, l_b_window, gcLead0, 1, 79,130,24);
   XFillRectangle(l_b_display, l_b_window, gcLead0, 1, 108, 130,12);

   XAllocNamedColor(l_b_display, cmap,"black", &col, & unused);
   XSetForeground(l_b_display, gcLead0, col.pixel);

   sprintf(pr_buff, "RAW: %14s",mstimstr(data_raw[click_l0.raw].index));
   XDrawString(l_b_display, l_b_window, gcLead0, 2, 66, pr_buff, strlen(pr_buff));

   sprintf(pr_buff, "HRate: %9d [bpm]",data_raw[click_l0.raw].HR);
   XDrawString(l_b_display, l_b_window, gcLead0, 2, 78, pr_buff, strlen(pr_buff));

   sprintf(pr_buff,"ST80:");
   XDrawString(l_b_display, l_b_window, gcLead0, 2, 90, pr_buff, strlen(pr_buff));
   sprintf(pr_buff," %6d/%6d",mk_uv(data_raw[click_l0.raw].l0_ST80),
                              mk_uv(data_raw[click_l0.raw].l0_ST80)-click_ST80_0);
   click_ST80_0 = mk_uv(data_raw[click_l0.raw].l0_ST80);
   XDrawString(l_b_display, l_b_window, gcLead0, 40, 90, pr_buff, strlen(pr_buff));

   sprintf(pr_buff,"STSb:");
   XDrawString(l_b_display, l_b_window, gcLead0, 2, 102, pr_buff, strlen(pr_buff));
   sprintf(pr_buff," %6d/%6d",mk_uv(data_raw[click_l0.raw].sub_v[lead]),
                              mk_uv(data_raw[click_l0.raw].sub_v[lead]) - click_STsb_0);
   click_STsb_0 = mk_uv(data_raw[click_l0.raw].sub_v[lead]);
   XDrawString(l_b_display, l_b_window,  gcLead0, 40, 102, pr_buff, strlen(pr_buff));

   sprintf(pr_buff, "FINE: %14s",mstimstr(data_fin[click_l0.fine].index));
   XDrawString(l_b_display, l_b_window, gcLead0, 2, 120, pr_buff, strlen(pr_buff));

   sprintf(pr_buff, "HRate: %9d [bpm]", data_fin[click_l0.fine].HR);
   XDrawString(l_b_display, l_b_window, gcLead0, 2, 132, pr_buff, strlen(pr_buff));

   sprintf(pr_buff,"ST80:");
   XDrawString(l_b_display, l_b_window, gcLead0, 2, 144, pr_buff, strlen(pr_buff));
   sprintf(pr_buff," %6d/%6d", mk_uv( data_fin[click_l0.fine].l0_ST80),
                 	   mk_uv( data_fin[click_l0.fine].l0_ST80) - click_ST80_f0);
   click_ST80_f0 = mk_uv( data_fin[click_l0.fine].l0_ST80);
   XDrawString(l_b_display, l_b_window, gcLead0, 40, 144, pr_buff, strlen(pr_buff));
   }
   else {
    if (IS_free(0, click_l0.raw,0)) {

       Lead0_operation = 1;
       Marker[0].set=TRUE;
       Marker[0].raw_index=click_l0.raw; Marker[0].fine_index=click_l0.fine;
       set_marker_l(0);
       draw_grid_lead0(0); 
       show_data(0,FALSE, TRUE);
       Lead0_operation = 0;}
   }
  } else {
      sub_op0_exec();
  }
             }
        else {

   XAllocNamedColor(l_b_display, cmap,"white", &col, & unused);
   XSetForeground(l_b_display, gcLead0, col.pixel);

   XFillRectangle(l_b_display, l_b_window, gcLead0, 40,162,90,15);

   XAllocNamedColor(l_b_display, cmap,"black", &col, & unused);
   XSetForeground(l_b_display, gcLead0, col.pixel);
	}

}

//
// User-defined action for `l_cp'.
//
void
l_call_center(Xv_window win, Event *event, Notify_arg arg, Notify_event_type type)
{
	sem_0_l_bw_objects *ip = (sem_0_l_bw_objects *) xv_get(xv_get(win, CANVAS_PAINT_CANVAS_WINDOW), XV_KEY_DATA, INSTANCE);

	if (Lead0_operation != 0 )  return;

def_click click_tmp0;

long x,y,i, dx;
long c_Time;
char pr_time[12];

long  r_i;
int   lead = 0;
short Lead0_operation_tmp;

        x=(event->ie_xevent)->xbutton.x ;
        c_Time = (long)(FSAMP *(diagram_time_begin_lead+ double(x-160.0)*time_scale_0/960.0));

	if ( ( c_Time < data_raw[raw_display_begin].index) || ( c_Time > data_fin[fin_display_end].index ) ) return;

        i=raw_display_begin;
        while ( (c_Time > data_raw[i].index) && (i < (raw_display_end)) ) i++;
        dx= abs(c_Time - data_raw[i].index);

        click_c0.first=! click_c0.first;

        click_c0.x=(event->ie_xevent)->xbutton.x;
        click_c0.y=(event->ie_xevent)->xbutton.y;
        if ( click_c0.first ){	

   dx= abs(c_Time - data_raw[i].index);
   if (dx == 0) {
     click_c0.raw_l=i; click_c0.raw_r=i; click_c0.raw=i; 
   }
   else { click_c0.raw_l=i-1; click_c0.raw_r=i;
	  if ( dx < FSAMP) { click_c0.raw=i;}
	  else  { click_c0.raw=i-1;}
   }
   i=click_c0.raw;

   i=fin_display_begin;

   while ( ( data_raw[click_c0.raw].index > data_fin[i].index) && (i < (fin_display_end+1)) )
     {

i++;
}

   dx= abs( data_raw[click_c0.raw].index - data_fin[i].index);
   if (dx == 0) {
     click_c0.fine_l=i; click_c0.fine_r=i; click_c0.fine=i; 
   }
   else { click_c0.fine_l=i-1; click_c0.fine_r=i;
	  click_c0.fine=i;
   }
   i=click_c0.fine;

   if ( click_c0.y <= BORDER_SEP_CLICK ) {
       Lead0_operation_tmp = Lead0_operation;
       Lead0_operation = 9;

       click_tmp0.first = click_l0.first;
       click_tmp0.x = click_l0.x;
       click_tmp0.y = click_l0.y;
       click_tmp0.time_index = click_l0.time_index;
       click_tmp0.raw = click_l0.raw;
       click_tmp0.raw_l = click_l0.raw_l;
       click_tmp0.raw_r = click_l0.raw_r;
       click_tmp0.fine = click_l0.fine;
       click_tmp0.fine_l = click_l0.fine_l;
       click_tmp0.fine_r = click_l0.fine_r;

       click_l0.first = click_c0.first;
       click_l0.x = click_c0.x;
       click_l0.y = click_c0.y;
       click_l0.time_index = click_c0.time_index;
       click_l0.raw = click_c0.raw;
       click_l0.raw_l = click_c0.raw_l;
       click_l0.raw_r = click_c0.raw_r;
       click_l0.fine = click_c0.fine;
       click_l0.fine_l = click_c0.fine_l;
       click_l0.fine_r = click_c0.fine_r;

       fast0_center = TRUE;
       
       if (!repeat_set) {
         fast0_center = FALSE; // &&
         sub_op0_start();      // &&
       }
       sub_op0_exec();
       fast0_center = FALSE;

       click_l0.first = click_tmp0.first;
       click_l0.x = click_tmp0.x;
       click_l0.y = click_tmp0.y;
       click_l0.time_index = click_tmp0.time_index;
       click_l0.raw = click_tmp0.raw;
       click_l0.raw_l = click_tmp0.raw_l;
       click_l0.raw_r = click_tmp0.raw_r;
       click_l0.fine = click_tmp0.fine;
       click_l0.fine_l = click_tmp0.fine_l;
       click_l0.fine_r = click_tmp0.fine_r;

    Lead0_operation = Lead0_operation_tmp;

   }
 }

}

//
// User-defined action for `l_cp'.
//
void
l_call_right(Xv_window win, Event *event, Notify_arg arg, Notify_event_type type)
{
	sem_0_l_bw_objects *ip = (sem_0_l_bw_objects *) xv_get(xv_get(win, CANVAS_PAINT_CANVAS_WINDOW), XV_KEY_DATA, INSTANCE);
}

//
// Notify callback function for `l_b_shift_ll1'.
//
void
l_call_shift_ll1(Panel_item item, Event *event)
{
	sem_0_l_bw1_objects *ip = (sem_0_l_bw1_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
long x,y;

        y=TimeToIndex(diagram_time_begin_lead);

        if ( TimeToIndex(diagram_time_begin_lead) > TimeToIndex(time_begin_lead)) {
	  x=TimeToIndex(diagram_time_begin_lead-time_scale_0);
	  if ( x < 0 ) x=0;

	  xv_set(Sem_0_l_bw.l_b_shift_r, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_rr, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_r1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_rr1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_r2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_rr2, PANEL_INACTIVE, FALSE, NULL);

	}
	else
	  {
	    x=0;
	     xv_set(Sem_0_l_bw.l_b_shift_ll, PANEL_INACTIVE, TRUE, NULL);
	     xv_set(Sem_0_l_bw1.l_b_shift_ll1, PANEL_INACTIVE, TRUE, NULL);
	     xv_set(Sem_0_l_bw2.l_b_shift_ll2, PANEL_INACTIVE, TRUE, NULL);

	     sprintf(message1,"You are at the beginning of data !"); 
	     warning_message(1);
	  }
	  diagram_time_begin_lead=IndexToTime(x);

	  draw_grid_lead0(0);

	  if (lead1_data )  draw_grid_lead0(1); 
	  if (lead2_data )  draw_grid_lead0(2); 
	  draw_grid_coeff();
	
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_b_shift_l1'.
//
void
l_call_shift_l1(Panel_item item, Event *event)
{
	sem_0_l_bw1_objects *ip = (sem_0_l_bw1_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
long x,y;

        y=TimeToIndex(diagram_time_begin_lead);
        if ( (x=TimeToIndex(diagram_time_begin_lead-time_scale_0/2)) >= TimeToIndex(time_begin_lead)) {

	  xv_set(Sem_0_l_bw.l_b_shift_rr, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_r, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_rr1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_r1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_rr2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_r2, PANEL_INACTIVE, FALSE, NULL);

	}
	else
	  {
	    x=0;
       	     xv_set(Sem_0_l_bw.l_b_shift_l, PANEL_INACTIVE, TRUE, NULL);
	     xv_set(Sem_0_l_bw.l_b_shift_ll, PANEL_INACTIVE, TRUE, NULL);
       	     xv_set(Sem_0_l_bw1.l_b_shift_l1, PANEL_INACTIVE, TRUE, NULL);
	     xv_set(Sem_0_l_bw1.l_b_shift_ll1, PANEL_INACTIVE, TRUE, NULL);
       	     xv_set(Sem_0_l_bw2.l_b_shift_l2, PANEL_INACTIVE, TRUE, NULL);
	     xv_set(Sem_0_l_bw2.l_b_shift_ll2, PANEL_INACTIVE, TRUE, NULL);
	     sprintf(message1,"You are at the beginning of data !"); 
	     warning_message(1);
	  }

	  diagram_time_begin_lead=IndexToTime(x);
	  draw_grid_lead0(0);

	  if (lead1_data )  draw_grid_lead0(1); 
	  if (lead2_data )  draw_grid_lead0(2); 
	  draw_grid_coeff();	

	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_b_shift_r1'.
//
void
l_call_shift_r1(Panel_item item, Event *event)
{
	sem_0_l_bw1_objects *ip = (sem_0_l_bw1_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
long x,y;

        y=TimeToIndex(diagram_time_begin_lead);
        if ( (x=TimeToIndex(diagram_time_begin_lead+time_scale_0/2)) <= TimeToIndex(time_end_lead)) {

	  xv_set(Sem_0_l_bw.l_b_shift_ll, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_l, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_ll1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_l1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_ll2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_l2, PANEL_INACTIVE, FALSE, NULL);
	}
	else
	  {
            x=TimeToIndex(time_end_lead);

	    y = x % 60000;
	    if ( y  > 30000 )  { y = - (60000 -y); }
	    x=x - y;
	    if (x < 0 ) x=0;

	    xv_set(Sem_0_l_bw.l_b_shift_r, PANEL_INACTIVE, TRUE, NULL);
	    xv_set(Sem_0_l_bw.l_b_shift_rr, PANEL_INACTIVE, TRUE, NULL);
	    xv_set(Sem_0_l_bw1.l_b_shift_r1, PANEL_INACTIVE, TRUE, NULL);
	    xv_set(Sem_0_l_bw1.l_b_shift_rr1, PANEL_INACTIVE, TRUE, NULL);
	    xv_set(Sem_0_l_bw2.l_b_shift_r2, PANEL_INACTIVE, TRUE, NULL);
	    xv_set(Sem_0_l_bw2.l_b_shift_rr2, PANEL_INACTIVE, TRUE, NULL);
	     sprintf(message1,"You are at the end of data !"); 
	     warning_message(1);
	  }

	  diagram_time_begin_lead=IndexToTime(x);
	  xv_set(Sem_0_l_bw.l_b_shift_ll, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_l, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_ll1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_l1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_ll2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_l2, PANEL_INACTIVE, FALSE, NULL);

	  draw_grid_lead0(0);
	
	  if (lead1_data )  draw_grid_lead0(1); 
	  if (lead2_data )  draw_grid_lead0(2); 
	  draw_grid_coeff();
	
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_b_shift_rr1'.
//
void
l_call_shift_rr1(Panel_item item, Event *event)
{
	sem_0_l_bw1_objects *ip = (sem_0_l_bw1_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
long x,y;

        y=TimeToIndex(diagram_time_begin_lead);
        if ( (x=TimeToIndex(diagram_time_begin_lead+time_scale_0)) <= TimeToIndex(time_end_lead)) {

	  xv_set(Sem_0_l_bw.l_b_shift_ll, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_l, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_ll1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_l1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_ll2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_l2, PANEL_INACTIVE, FALSE, NULL);
	}
	else
	  {
            x=TimeToIndex(time_end_lead);

	    y = x % 60000;
	    if ( y  > 30000 )  { y = - (60000 -y); }
	    x=x - y;
	    if (x < 0 ) x=0;

	     xv_set(Sem_0_l_bw.l_b_shift_rr, PANEL_INACTIVE, TRUE, NULL);
	     xv_set(Sem_0_l_bw1.l_b_shift_rr1, PANEL_INACTIVE, TRUE, NULL);
	     xv_set(Sem_0_l_bw2.l_b_shift_rr2, PANEL_INACTIVE, TRUE, NULL);
	     sprintf(message1,"You are at the end of data !"); 
	     warning_message(1);
	  }

     	  diagram_time_begin_lead=IndexToTime(x);
	  xv_set(Sem_0_l_bw.l_b_shift_ll, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_l, PANEL_INACTIVE, FALSE, NULL);

	  draw_grid_lead0(0);    

	  if (lead1_data )  draw_grid_lead0(1); 
	  if (lead2_data )  draw_grid_lead0(2); 
	  draw_grid_coeff();
	
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_ss_HRate1'.
//
void
l_call_HRate1(Panel_item item, int value, Event *event)
{
	sem_0_l_bw1_objects *ip = (sem_0_l_bw1_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	reset_HR_lead0(1);

	switch (value){
	case 0:  lead1_plot_button_status.HRate=TRUE; break;
	case 1:  lead1_plot_button_status.HRRaw=TRUE;break;
	case 2:  lead1_plot_button_status.STFine=TRUE;break;
	case 3:  lead1_plot_button_status.STslFine=TRUE;break;
	case 4:  lead1_plot_button_status.STslRaw=TRUE;break;
	case 5:  lead1_plot_button_status.Episodes=TRUE;break;
	case 6:  lead1_plot_button_status.HideHR=TRUE;	break;
	case 7:  lead1_plot_button_status.ISOJ=TRUE;  break;
	case 8:  lead1_plot_button_status.HRate=TRUE; 	  
	  xv_set(Sem_0_l_bw1.l_ss_HRate1, PANEL_VALUE, 0, NULL);
	  break;
	case 9:  lead1_plot_button_status.HRate=TRUE; 	  
	  xv_set(Sem_0_l_bw1.l_ss_HRate1, PANEL_VALUE, 0, NULL);
	  break;
	} // end select

	draw_grid_lead0(1);

	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_ss_12min1'.
//
void
l_call_12min1(Panel_item item, int value, Event *event)
{
	sem_0_l_bw1_objects *ip = (sem_0_l_bw1_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);

	switch (value){
	case 0: time_scale_0=60; break;
	case 1: time_scale_0=120; break;
	case 2: time_scale_0=180; break;
	case 3: time_scale_0=360; break;
	case 4: time_scale_0=540; break;
	case 5: time_scale_0=720; break;
	case 6: time_scale_0=1440; break;
	case 7: time_scale_0=1800; break;
	case 8: time_scale_0=3600; break;
	case 9: time_scale_0=7200; break;
	case 10: time_scale_0=14400; break;
	case 11: time_scale_0=21600; break;
	case 12: time_scale_0=43200; break;
	case 13: time_scale_0=86400; break;
	case 14: time_scale_0=172800; break;
	case 15: time_scale_0=345600; break;
	} // end select

   scale_time_tick=(long)(time_scale_0 / 12.0);
	  xv_set(Sem_0_l_bw.l_b_shift_ll, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_l, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_rr, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_r, PANEL_INACTIVE, FALSE, NULL);

	  xv_set(Sem_0_l_bw1.l_b_shift_ll1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_l1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_rr1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_r1, PANEL_INACTIVE, FALSE, NULL);

	  xv_set(Sem_0_l_bw2.l_b_shift_ll2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_l2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_rr2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_r2, PANEL_INACTIVE, FALSE, NULL);


	 xv_set(Sem_0_l_bw.l_ss_12min, PANEL_VALUE,value,NULL);
	 xv_set(Sem_0_l_bw2.l_ss_12min2, PANEL_VALUE,value,NULL);
	
         draw_grid_lead0(0);

	 if (lead1_data )  draw_grid_lead0(1); 
	 if (lead2_data )  draw_grid_lead0(2); 
	 draw_grid_coeff();

	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_ss_100mV1'.
//
void
l_call_100mV1(Panel_item item, int value, Event *event)
{
	sem_0_l_bw1_objects *ip = (sem_0_l_bw1_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (value){
	case 0: ampl_1=20; break;
	case 1: ampl_1=25; break;
	case 2: ampl_1=50; break;
	case 3: ampl_1=75; break;
	case 4: ampl_1=100; break;
	case 5: ampl_1=125; break;
	case 6: ampl_1=150; break;
	case 7: ampl_1=200; break;
	case 8: ampl_1=250; break;
	case 9: ampl_1=500; break;
	case 10: ampl_1=750; break;
	case 11: ampl_1=1000; break;
	case 12: ampl_1=2000; break;
	case 13: ampl_1=5000; break;
	} // end select
	draw_grid_lead0(1);
		
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_b_Mark1'.
//
void
l_call_Mark1(Panel_item item, Event *event)
{
	sem_0_l_bw1_objects *ip = (sem_0_l_bw1_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	Lead1_operation=1;
	sub_op1_start();
	
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_b_Subtr1'.
//
void
l_call_Subtr1(Panel_item item, Event *event)
{
	sem_0_l_bw1_objects *ip = (sem_0_l_bw1_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);

	if ( status_unsubtracted1 ) {
	  Lead1_buttons.Subtr_s=2;
	  status_unsubtracted1 =FALSE;

          if (status_manual_mode1) 
                set_buttons_lead1_subtr_manual();
          else
                set_buttons_lead1_subtr_auto();   
	}
	else {
	  Lead1_buttons.Subtr_s=1;
	  status_unsubtracted1 =TRUE;

          if (status_manual_mode1)
                 set_buttons_lead1_unsubtr_manual();
          else
                 set_buttons_lead1_unsubtr_auto();
	}

	set_buttons_lead1(); draw_grid_lead0(1); 
		
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_b_OvrApp1'.
//
void
l_call_OvrApp1(Panel_item item, Event *event)
{
	sem_0_l_bw1_objects *ip = (sem_0_l_bw1_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
       	if ( Lead1_buttons.OvrApp_s == 1 ) {
	    Lead1_buttons.OvrApp_s=2; ovr1_app = TRUE;
	}
	else {
	    Lead1_buttons.OvrApp_s=1; ovr1_app = FALSE;
	}

	set_buttons_lead1();   draw_grid_lead0(1); 

	// gxv_start_connections DO NOT EDIT THIS SECTION

	// gxv_end_connections

}

//
// Notify callback function for `l_b_OvrLds_menu1'.
//
void
l_call_menu_OvrLds1(Panel_item item, Event *event)
{
	sem_0_l_bw1_objects *ip = (sem_0_l_bw1_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_b_Exm1'.
//
void
l_call_Exm1(Panel_item item, Event *event)
{
	sem_0_l_bw1_objects *ip = (sem_0_l_bw1_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	Lead1_operation=9;
	sub_op1_start();

	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_b_ConsLR1'.
//
void
l_call_ConsLR1(Panel_item item, Event *event)
{
	sem_0_l_bw1_objects *ip = (sem_0_l_bw1_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	if ( status_manual_mode1 && status_unsubtracted1 && Lead1_buttons.ConsLR_s == 1 ) {
	  if ( reference_act[1] > -1 )
	  if ( Is_code(1,reference_act[1],0,0)) {
	    Lead1_buttons.ConsLR_s=2;
	    status_consider_localref1=FALSE;
            set_buttons_lead1_conslr();

	      act_ref_data[1].copy_ref(references[1][reference_act[1]]);

	      act_reference[1].set=TRUE;
	      act_reference[0].change=FALSE;
	      act_reference[1].change=FALSE;
	      act_reference[2].change=FALSE;
	      act_reference[1].typ=2; // local
	      act_reference[1].index=reference_act[1];

	      data_mstime_index= data_fin[Marker[1].fine_index].index;
	      reference_mstime_index= data_fin[act_ref_data[1].fine_index].index;

	      data_new_r_read();
	      get_average_R();
	      update_marker(1,192);

	    draw_grid_lead0(1); 
	    show_data(1,FALSE, TRUE);

	    } // end cons loc ref 
	}
	else if ( Lead1_buttons.ConsLR_s == 2 ) { 
	    Lead1_buttons.ConsLR_s=1;
	    status_consider_localref1=TRUE;
            set_buttons_lead1_unsubtr_manual();

	    if ( global_ref[1].set) {
	      act_ref_data[1].copy_ref(global_ref[1]);
	      act_ref_data[1].code1=0;

	      act_reference[1].set=TRUE;
	      act_reference[0].change=FALSE;
	      act_reference[1].change=FALSE;
	      act_reference[2].change=FALSE;
	      act_reference[1].typ=1; // global
	      act_reference[1].index=-1;

	      data_mstime_index= data_fin[Marker[1].fine_index].index;
	      reference_mstime_index= data_fin[act_ref_data[0].fine_index].index;

	      data_new_r_read();
	      get_average_R();
	      update_marker(1,192);

	    } // end cons loc ref 
	      draw_grid_lead0(1); 
	      show_data(1,FALSE, TRUE);
	}
	set_buttons_lead1();
	
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Event callback function for `l_cp1'.
//
Notify_value
sem_0_l_bw1_l_cp1_event_callback(Xv_window win, Event *event, Notify_arg arg, Notify_event_type type)
{
	sem_0_l_bw1_objects *ip = (sem_0_l_bw1_objects *) xv_get(xv_get(win, CANVAS_PAINT_CANVAS_WINDOW), XV_KEY_DATA, INSTANCE);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION

	if (event_action(event) == ACTION_SELECT)
	{
		l_call_left1(win, event, arg, type);
	}
	
	if (event_action(event) == ACTION_ADJUST)
	{
		l_call_center1(win, event, arg, type);
	}
	
	if (event_action(event) == ACTION_MENU)
	{
		l_call_right1(win, event, arg, type);
	}
	
	// gxv_end_connections

	return notify_next_event_func(win, (Notify_event) event, arg, type);
}

//
// User-defined action for `l_cp1'.
//
void
l_call_left1(Xv_window win, Event *event, Notify_arg arg, Notify_event_type type)
{
	sem_0_l_bw1_objects *ip = (sem_0_l_bw1_objects *) xv_get(xv_get(win, CANVAS_PAINT_CANVAS_WINDOW), XV_KEY_DATA, INSTANCE);
	
long x,y,i, dx;
long c_Time;
char pr_time[12];
int lead = 1;

        x=(event->ie_xevent)->xbutton.x ;
        c_Time = (long)(FSAMP *(diagram_time_begin_lead+ double(x-160.0)*time_scale_0/960.0));

	if ( ( c_Time < data_raw[raw_display_begin].index) || ( c_Time > data_fin[fin_display_end].index ) ) return;

        i=raw_display_begin;
        while ( (c_Time > data_raw[i].index) && (i < (raw_display_end)) ) i++;
        dx= abs(c_Time - data_raw[i].index);

        click_l1.first=! click_l1.first;

        click_l1.x=(event->ie_xevent)->xbutton.x;
        click_l1.y=(event->ie_xevent)->xbutton.y;
        if ( click_l1.first ){	

   dx= abs(c_Time - data_raw[i].index);
   if (dx == 0) {
     click_l1.raw_l=i; click_l1.raw_r=i; click_l1.raw=i; 
   }
   else { click_l1.raw_l=i-1; click_l1.raw_r=i;
	  if ( dx < FSAMP) { click_l1.raw=i;}
	  else  { click_l1.raw=i-1;}
   }
   i=click_l1.raw;

   i=fin_display_begin;

   while ( ( data_raw[click_l1.raw].index > data_fin[i].index) && (i < (fin_display_end+1)) )
     {  i++;  }

   dx= abs( data_raw[click_l1.raw].index - data_fin[i].index);
   if (dx == 0) {
     click_l1.fine_l=i; click_l1.fine_r=i; click_l1.fine=i; 
   }
   else { click_l1.fine_l=i-1; click_l1.fine_r=i;
	  click_l1.fine=i;
   }
   i=click_l1.fine;

   XAllocNamedColor(l_b1_display, cmap,set_color8, &col, & unused);
   XSetForeground(l_b1_display, gcLead1, col.pixel);

 if (Lead1_operation == 0 || ( Lead1_operation != 0 && click_l1.y > BORDER_SEP_CLICK) ) {
  if ( click_l1.y > BORDER_SEP_CLICK ) {

   XFillRectangle(l_b1_display, l_b1_window, gcLead1, 40,162,90,15);

   XAllocNamedColor(l_b1_display, cmap,"black", &col, & unused);
   XSetForeground(l_b1_display, gcLead1, col.pixel);

   sprintf(pr_time, "%s",mstimstr(c_Time));
   XDrawString(l_b1_display, l_b1_window, gcLead1, 42, 174, pr_time, strlen(pr_time));

   XAllocNamedColor(l_b1_display, cmap,"white", &col, & unused);
   XSetForeground(l_b1_display, gcLead1, col.pixel);
   XFillRectangle(l_b1_display, l_b1_window, gcLead1, 1,55,130,90);

   XAllocNamedColor(l_b1_display, cmap,set_color8, &col, & unused);
   XSetForeground(l_b1_display, gcLead1, col.pixel);
   XFillRectangle(l_b1_display, l_b1_window, gcLead1, 1, 55,130,12);
   XFillRectangle(l_b1_display, l_b1_window, gcLead1, 1, 79,130,24);
   XFillRectangle(l_b1_display, l_b1_window, gcLead1, 1, 108, 130,12);

   XAllocNamedColor(l_b1_display, cmap,"black", &col, & unused);
   XSetForeground(l_b1_display, gcLead1, col.pixel);

   sprintf(pr_buff, "RAW: %14s",mstimstr(data_raw[click_l1.raw].index));
   XDrawString(l_b1_display, l_b1_window, gcLead1, 2, 66, pr_buff, strlen(pr_buff));

   sprintf(pr_buff, "HRate: %9d [bpm]",data_raw[click_l1.raw].HR);
   XDrawString(l_b1_display, l_b1_window, gcLead1, 2, 78, pr_buff, strlen(pr_buff));

   sprintf(pr_buff,"ST80:");
   XDrawString(l_b1_display, l_b1_window, gcLead1, 2, 90, pr_buff, strlen(pr_buff));
   sprintf(pr_buff," %6d/%6d",mk_uv(data_raw[click_l1.raw].l1_ST80),
                              mk_uv(data_raw[click_l1.raw].l1_ST80)-click_ST80_1);
   click_ST80_1 = mk_uv(data_raw[click_l1.raw].l1_ST80);
   XDrawString(l_b1_display, l_b1_window, gcLead1, 40, 90, pr_buff, strlen(pr_buff));

   sprintf(pr_buff,"STSb:");
   XDrawString(l_b1_display, l_b1_window, gcLead1, 2, 102, pr_buff, strlen(pr_buff));
   sprintf(pr_buff," %6d/%6d",mk_uv(data_raw[click_l1.raw].sub_v[lead]),
                              mk_uv(data_raw[click_l1.raw].sub_v[lead]) - click_STsb_1);
   click_STsb_1 = mk_uv(data_raw[click_l1.raw].sub_v[lead]);
   XDrawString(l_b1_display, l_b1_window,  gcLead1, 40, 102, pr_buff, strlen(pr_buff));

   sprintf(pr_buff, "FINE: %14s",mstimstr(data_fin[click_l1.fine].index));
   XDrawString(l_b1_display, l_b1_window, gcLead1, 2, 120, pr_buff, strlen(pr_buff));

   sprintf(pr_buff, "HRate: %9d [bpm]", data_fin[click_l1.fine].HR);
   XDrawString(l_b1_display, l_b1_window, gcLead1, 2, 132, pr_buff, strlen(pr_buff));

   sprintf(pr_buff,"ST80:");
   XDrawString(l_b1_display, l_b1_window, gcLead1, 2, 144, pr_buff, strlen(pr_buff));
   sprintf(pr_buff," %6d/%6d", mk_uv( data_fin[click_l1.fine].l1_ST80),
                 	   mk_uv( data_fin[click_l1.fine].l1_ST80) - click_ST80_f1);
   click_ST80_f1 = mk_uv( data_fin[click_l1.fine].l1_ST80);
   XDrawString(l_b1_display, l_b1_window, gcLead1, 40, 144, pr_buff, strlen(pr_buff));
   }
   else {
    if (IS_free(1, click_l1.raw,0)) {

       Lead1_operation = 1;
       Marker[1].set=TRUE;
       Marker[1].raw_index=click_l1.raw; Marker[1].fine_index=click_l1.fine;
       set_marker_l(1);
       draw_grid_lead0(1); 

       show_data(1,FALSE, TRUE);
       Lead1_operation = 0;}
   }
  } else {
      sub_op1_exec();
  }
             }
        else {

   XAllocNamedColor(l_b1_display, cmap,"white", &col, & unused);
   XSetForeground(l_b1_display, gcLead1, col.pixel);

   XFillRectangle(l_b1_display, l_b1_window, gcLead1, 40,162,90,15);

   XAllocNamedColor(l_b1_display, cmap,"black", &col, & unused);
   XSetForeground(l_b1_display, gcLead1, col.pixel);

	}
}

//
// User-defined action for `l_cp1'.
//
void
l_call_center1(Xv_window win, Event *event, Notify_arg arg, Notify_event_type type)
{
	sem_0_l_bw1_objects *ip = (sem_0_l_bw1_objects *) xv_get(xv_get(win, CANVAS_PAINT_CANVAS_WINDOW), XV_KEY_DATA, INSTANCE);

	if (Lead1_operation != 0 )  return;

def_click click_tmp1;

long x,y,i, dx;
long c_Time;
char pr_time[12];

long  r_i;
int   lead = 1;
short Lead1_operation_tmp;

        x=(event->ie_xevent)->xbutton.x;
        c_Time = (long)(FSAMP *(diagram_time_begin_lead+ double(x-160.0)*time_scale_0/960.0));

	if ( ( c_Time < data_raw[raw_display_begin].index) || ( c_Time > data_fin[fin_display_end].index ) ) return;

        i=raw_display_begin;
        while ( (c_Time > data_raw[i].index) && (i < (raw_display_end)) ) i++;
        dx= abs(c_Time - data_raw[i].index);

        click_c1.first=! click_c1.first;

        click_c1.x=(event->ie_xevent)->xbutton.x;
        click_c1.y=(event->ie_xevent)->xbutton.y;
        if ( click_c1.first ){	

   dx= abs(c_Time - data_raw[i].index);
   if (dx == 0) {
     click_c1.raw_l=i; click_c1.raw_r=i; click_c1.raw=i; 
   }
   else { click_c1.raw_l=i-1; click_c1.raw_r=i;
	  if ( dx < FSAMP) { click_c1.raw=i;}
	  else  { click_c1.raw=i-1;}
   }
   i=click_c1.raw;
   i=fin_display_begin;

   while ( ( data_raw[click_c1.raw].index > data_fin[i].index) && (i < (fin_display_end+1)) )
     {

 i++;
 }

   dx= abs( data_raw[click_c1.raw].index - data_fin[i].index);
   if (dx == 0) {
     click_c1.fine_l=i; click_c1.fine_r=i; click_c1.fine=i; 
   }
   else { click_c1.fine_l=i-1; click_c1.fine_r=i;
	  click_c1.fine=i;
   }
   i=click_c1.fine;

   if ( click_c1.y <= BORDER_SEP_CLICK ) {
       Lead1_operation_tmp = Lead1_operation;
       Lead1_operation = 9;

       click_tmp1.first = click_l1.first;
       click_tmp1.x = click_l1.x;
       click_tmp1.y = click_l1.y;
       click_tmp1.time_index = click_l1.time_index;
       click_tmp1.raw = click_l1.raw;
       click_tmp1.raw_l = click_l1.raw_l;
       click_tmp1.raw_r = click_l1.raw_r;
       click_tmp1.fine = click_l1.fine;
       click_tmp1.fine_l = click_l1.fine_l;
       click_tmp1.fine_r = click_l1.fine_r;

       click_l1.first = click_c1.first;
       click_l1.x = click_c1.x;
       click_l1.y = click_c1.y;
       click_l1.time_index = click_c1.time_index;
       click_l1.raw = click_c1.raw;
       click_l1.raw_l = click_c1.raw_l;
       click_l1.raw_r = click_c1.raw_r;
       click_l1.fine = click_c1.fine;
       click_l1.fine_l = click_c1.fine_l;
       click_l1.fine_r = click_c1.fine_r;

       fast1_center = TRUE;
       
       if (!repeat_set1) {
         fast1_center = FALSE;
         sub_op1_start();     
       }
       sub_op1_exec();
       fast1_center = FALSE;

       click_l1.first = click_tmp1.first;
       click_l1.x = click_tmp1.x;
       click_l1.y = click_tmp1.y;
       click_l1.time_index = click_tmp1.time_index;
       click_l1.raw = click_tmp1.raw;
       click_l1.raw_l = click_tmp1.raw_l;
       click_l1.raw_r = click_tmp1.raw_r;
       click_l1.fine = click_tmp1.fine;
       click_l1.fine_l = click_tmp1.fine_l;
       click_l1.fine_r = click_tmp1.fine_r;

    Lead1_operation = Lead1_operation_tmp;

   }
 }
}

//
// User-defined action for `l_cp1'.
//
void
l_call_right1(Xv_window win, Event *event, Notify_arg arg, Notify_event_type type)
{
	sem_0_l_bw1_objects *ip = (sem_0_l_bw1_objects *) xv_get(xv_get(win, CANVAS_PAINT_CANVAS_WINDOW), XV_KEY_DATA, INSTANCE);
	
}

//
// Notify callback function for `l_b_shift_ll2'.
//
void
l_call_shift_ll2(Panel_item item, Event *event)
{
	sem_0_l_bw2_objects *ip = (sem_0_l_bw2_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
long x,y;

        y=TimeToIndex(diagram_time_begin_lead);

        if ( TimeToIndex(diagram_time_begin_lead) > TimeToIndex(time_begin_lead)) {
	  x=TimeToIndex(diagram_time_begin_lead-time_scale_0);
	  if ( x < 0 ) x=0;

	  xv_set(Sem_0_l_bw.l_b_shift_r, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_rr, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_r1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_rr1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_r2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_rr2, PANEL_INACTIVE, FALSE, NULL);

	}
	else
	  {
	    x=0;
	     xv_set(Sem_0_l_bw.l_b_shift_ll, PANEL_INACTIVE, TRUE, NULL);
	     xv_set(Sem_0_l_bw1.l_b_shift_ll1, PANEL_INACTIVE, TRUE, NULL);
	     xv_set(Sem_0_l_bw1.l_b_shift_ll1, PANEL_INACTIVE, TRUE, NULL);

	     sprintf(message1,"You are at the beginning of data !"); 
	     warning_message(1);
	  }
	  diagram_time_begin_lead=IndexToTime(x);

	  draw_grid_lead0(0);

	  if (lead1_data )  draw_grid_lead0(1); 
	  if (lead2_data )  draw_grid_lead0(2); 

	  draw_grid_coeff();
	
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_b_shift_l2'.
//
void
l_call_shift_l2(Panel_item item, Event *event)
{
	sem_0_l_bw2_objects *ip = (sem_0_l_bw2_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
long x,y;

        y=TimeToIndex(diagram_time_begin_lead);
        if ( (x=TimeToIndex(diagram_time_begin_lead-time_scale_0/2)) >= TimeToIndex(time_begin_lead)) {

	  xv_set(Sem_0_l_bw.l_b_shift_rr, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_r, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_rr1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_r1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_rr2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_r2, PANEL_INACTIVE, FALSE, NULL);

	}
	else
	  {
	    x=0;
       	     xv_set(Sem_0_l_bw.l_b_shift_l, PANEL_INACTIVE, TRUE, NULL);
	     xv_set(Sem_0_l_bw.l_b_shift_ll, PANEL_INACTIVE, TRUE, NULL);
       	     xv_set(Sem_0_l_bw1.l_b_shift_l1, PANEL_INACTIVE, TRUE, NULL);
	     xv_set(Sem_0_l_bw1.l_b_shift_ll1, PANEL_INACTIVE, TRUE, NULL);
       	     xv_set(Sem_0_l_bw2.l_b_shift_l2, PANEL_INACTIVE, TRUE, NULL);
	     xv_set(Sem_0_l_bw2.l_b_shift_ll2, PANEL_INACTIVE, TRUE, NULL);
	     sprintf(message1,"You are at the beginning of data !"); 
	     warning_message(1);
	  }

	  diagram_time_begin_lead=IndexToTime(x);

	  draw_grid_lead0(0);

	  if (lead1_data )  draw_grid_lead0(1); 
	  if (lead2_data )  draw_grid_lead0(2); 
	  draw_grid_coeff();	
	
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_b_shift_r2'.
//
void
l_call_shift_r2(Panel_item item, Event *event)
{
	sem_0_l_bw2_objects *ip = (sem_0_l_bw2_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
long x,y;

        y=TimeToIndex(diagram_time_begin_lead);
        if ( (x=TimeToIndex(diagram_time_begin_lead+time_scale_0/2)) <= TimeToIndex(time_end_lead)) {

	  xv_set(Sem_0_l_bw.l_b_shift_ll, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_l, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_ll1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_l1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_ll2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_l2, PANEL_INACTIVE, FALSE, NULL);
	}
	else
	  {
            x=TimeToIndex(time_end_lead);

	    y = x % 60000;
	    if ( y  > 30000 )  { y = - (60000 -y); }
	    x=x - y;
	    if (x < 0 ) x=0;

	    xv_set(Sem_0_l_bw.l_b_shift_r, PANEL_INACTIVE, TRUE, NULL);
	    xv_set(Sem_0_l_bw.l_b_shift_rr, PANEL_INACTIVE, TRUE, NULL);
	    xv_set(Sem_0_l_bw1.l_b_shift_r1, PANEL_INACTIVE, TRUE, NULL);
	    xv_set(Sem_0_l_bw1.l_b_shift_rr1, PANEL_INACTIVE, TRUE, NULL);
	    xv_set(Sem_0_l_bw2.l_b_shift_r2, PANEL_INACTIVE, TRUE, NULL);
	    xv_set(Sem_0_l_bw2.l_b_shift_rr2, PANEL_INACTIVE, TRUE, NULL);
	     sprintf(message1,"You are at the end of data !"); 
	     warning_message(1);
	  }

	  diagram_time_begin_lead=IndexToTime(x);
	  xv_set(Sem_0_l_bw.l_b_shift_ll, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_l, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_ll1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_l1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_ll2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_l2, PANEL_INACTIVE, FALSE, NULL);

	  draw_grid_lead0(0);
	
	  if (lead1_data )  draw_grid_lead0(1); 
	  if (lead2_data )  draw_grid_lead0(2); 
	  draw_grid_coeff();
	
	
	// gxv_start_connections DO NOT EDIT THIS SECTION

	// gxv_end_connections

}

//
// Notify callback function for `l_b_shift_rr2'.
//
void
l_call_shift_rr2(Panel_item item, Event *event)
{
	sem_0_l_bw2_objects *ip = (sem_0_l_bw2_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
long x,y;

        y=TimeToIndex(diagram_time_begin_lead);
        if ( (x=TimeToIndex(diagram_time_begin_lead+time_scale_0)) <= TimeToIndex(time_end_lead)) {

	  xv_set(Sem_0_l_bw.l_b_shift_ll, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_l, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_ll1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_l1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_ll2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_l2, PANEL_INACTIVE, FALSE, NULL);
	}
	else
	  {
            x=TimeToIndex(time_end_lead);

	    y = x % 60000;
	    if ( y  > 30000 )  { y = - (60000 -y); }
	    x=x - y;
	    if (x < 0 ) x=0;

	     xv_set(Sem_0_l_bw.l_b_shift_rr, PANEL_INACTIVE, TRUE, NULL);
	     xv_set(Sem_0_l_bw1.l_b_shift_rr1, PANEL_INACTIVE, TRUE, NULL);
	     xv_set(Sem_0_l_bw2.l_b_shift_rr2, PANEL_INACTIVE, TRUE, NULL);
	     sprintf(message1,"You are at the end of data !"); 
	     warning_message(1);
	  }

      	  diagram_time_begin_lead=IndexToTime(x);
	  xv_set(Sem_0_l_bw.l_b_shift_ll, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_l, PANEL_INACTIVE, FALSE, NULL);

	  draw_grid_lead0(0);    

	  if (lead1_data )  draw_grid_lead0(1); 
	  if (lead2_data )  draw_grid_lead0(2); 
	  draw_grid_coeff();
		
	// gxv_start_connections DO NOT EDIT THIS SECTION

	// gxv_end_connections

}

//
// Notify callback function for `l_ss_HRate2'.
//
void
l_call_HRate2(Panel_item item, int value, Event *event)
{
	sem_0_l_bw2_objects *ip = (sem_0_l_bw2_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
		
	reset_HR_lead0(2);

	switch (value){
	case 0:  lead2_plot_button_status.HRate=TRUE; break;
	case 1:  lead2_plot_button_status.HRRaw=TRUE;break;
	case 2:  lead2_plot_button_status.STFine=TRUE;break;
	case 3:  lead2_plot_button_status.STslFine=TRUE;break;
	case 4:  lead2_plot_button_status.STslRaw=TRUE;break;
	case 5:  lead2_plot_button_status.Episodes=TRUE;break;
	case 6:  lead2_plot_button_status.HideHR=TRUE;	break;
	case 7:  lead2_plot_button_status.ISOJ=TRUE;  break;
	case 8:  lead2_plot_button_status.HRate=TRUE; 	  
	  xv_set(Sem_0_l_bw2.l_ss_HRate2, PANEL_VALUE, 0, NULL);
	  break;
	case 9:  lead2_plot_button_status.HRate=TRUE; 	  
	  xv_set(Sem_0_l_bw2.l_ss_HRate2, PANEL_VALUE, 0, NULL);
	  break;

       	} // end select
 
	draw_grid_lead0(2);

	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_ss_12min2'.
//
void
l_call_12min2(Panel_item item, int value, Event *event)
{
	sem_0_l_bw2_objects *ip = (sem_0_l_bw2_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (value){
	case 0: time_scale_0=60; break;
	case 1: time_scale_0=120; break;
	case 2: time_scale_0=180; break;
	case 3: time_scale_0=360; break;
	case 4: time_scale_0=540; break;
	case 5: time_scale_0=720; break;
	case 6: time_scale_0=1440; break;
	case 7: time_scale_0=1800; break;
	case 8: time_scale_0=3600; break;
	case 9: time_scale_0=7200; break;
	case 10: time_scale_0=14400; break;
	case 11: time_scale_0=21600; break;
	case 12: time_scale_0=43200; break;
	case 13: time_scale_0=86400; break;
	case 14: time_scale_0=172800; break;
	case 15: time_scale_0=345600; break;
	} // end select

   scale_time_tick=(long)(time_scale_0 / 12.0);
	  xv_set(Sem_0_l_bw.l_b_shift_ll, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_l, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_rr, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_r, PANEL_INACTIVE, FALSE, NULL);

	  xv_set(Sem_0_l_bw1.l_b_shift_ll1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_l1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_rr1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_r1, PANEL_INACTIVE, FALSE, NULL);

	  xv_set(Sem_0_l_bw2.l_b_shift_ll2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_l2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_rr2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_r2, PANEL_INACTIVE, FALSE, NULL);


	 xv_set(Sem_0_l_bw.l_ss_12min, PANEL_VALUE,value,NULL);
	 xv_set(Sem_0_l_bw1.l_ss_12min1, PANEL_VALUE,value,NULL);
	
         draw_grid_lead0(0);

	 if (lead1_data )  draw_grid_lead0(1); 
	 if (lead2_data )  draw_grid_lead0(2); 
	  draw_grid_coeff();

	// gxv_start_connections DO NOT EDIT THIS SECTION

	// gxv_end_connections

}

//
// Notify callback function for `l_ss_100mV2'.
//
void
l_call_100mV2(Panel_item item, int value, Event *event)
{
	sem_0_l_bw2_objects *ip = (sem_0_l_bw2_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (value){
	case 0: ampl_2=20; break;
	case 1: ampl_2=25; break;
	case 2: ampl_2=50; break;
	case 3: ampl_2=75; break;
	case 4: ampl_2=100; break;
	case 5: ampl_2=125; break;
	case 6: ampl_2=150; break;
	case 7: ampl_2=200; break;
	case 8: ampl_2=250; break;
	case 9: ampl_2=500; break;
	case 10: ampl_2=750; break;
	case 11: ampl_2=1000; break;
	case 12: ampl_2=2000; break;
	case 13: ampl_2=5000; break;
	} // end select

	draw_grid_lead0(2);
		
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_b_Mark2'.
//
void
l_call_Mark2(Panel_item item, Event *event)
{
	sem_0_l_bw2_objects *ip = (sem_0_l_bw2_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	Lead2_operation=1;
	sub_op2_start();
	
	// gxv_start_connections DO NOT EDIT THIS SECTION

	// gxv_end_connections

}

//
// Notify callback function for `l_b_Subtr2'.
//
void
l_call_Subtr2(Panel_item item, Event *event)
{
	sem_0_l_bw2_objects *ip = (sem_0_l_bw2_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	if ( status_unsubtracted2 ) {
	  Lead2_buttons.Subtr_s=2;
	  status_unsubtracted2 =FALSE;

          if (status_manual_mode2) 
                set_buttons_lead2_subtr_manual();
          else
                set_buttons_lead2_subtr_auto();   
	}
	else {
	  Lead2_buttons.Subtr_s=1;
	  status_unsubtracted2 =TRUE;

          if (status_manual_mode2)
                 set_buttons_lead2_unsubtr_manual();
          else
                 set_buttons_lead2_unsubtr_auto();

	}

	set_buttons_lead2(); draw_grid_lead0(2); 
		
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_b_OvrApp2'.
//
void
l_call_OvrApp2(Panel_item item, Event *event)
{
	sem_0_l_bw2_objects *ip = (sem_0_l_bw2_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	if ( Lead2_buttons.OvrApp_s == 1 ) {
	    Lead2_buttons.OvrApp_s=2; ovr2_app = TRUE;
	}
	else {
	    Lead2_buttons.OvrApp_s=1; ovr2_app = FALSE;
	}

	set_buttons_lead2();   draw_grid_lead0(2); 
	
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_b_OvrLds_menu2'.
//
void
l_call_menu_OvrLds2(Panel_item item, Event *event)
{
	sem_0_l_bw2_objects *ip = (sem_0_l_bw2_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_b_Exm2'.
//
void
l_call_Exm2(Panel_item item, Event *event)
{
	sem_0_l_bw2_objects *ip = (sem_0_l_bw2_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	Lead2_operation=9;
	sub_op2_start();
	
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Notify callback function for `l_b_ConsLR2'.
//
void
l_call_ConsLR2(Panel_item item, Event *event)
{
	sem_0_l_bw2_objects *ip = (sem_0_l_bw2_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	if ( status_manual_mode2 && status_unsubtracted2 && Lead2_buttons.ConsLR_s == 1 ) {
	  if ( reference_act[2] > -1 )
	  if ( Is_code(2,reference_act[2],0,0)) {
	    Lead2_buttons.ConsLR_s=2;
	    status_consider_localref2=FALSE;
            set_buttons_lead2_conslr();

	      act_ref_data[2].copy_ref(references[2][reference_act[2]]);

	      act_reference[2].set=TRUE;
	      act_reference[0].change=FALSE;
	      act_reference[1].change=FALSE;
	      act_reference[2].change=FALSE;
	      act_reference[2].typ=2; // local
	      act_reference[2].index=reference_act[1];

	      data_mstime_index= data_fin[Marker[2].fine_index].index;
	      reference_mstime_index= data_fin[act_ref_data[2].fine_index].index;

	      data_new_r_read();
	      get_average_R();
	      update_marker(2,192);

	    draw_grid_lead0(2); 
	    show_data(2,FALSE, TRUE);

	    } // end cons loc ref 

	}
	else if ( Lead2_buttons.ConsLR_s == 2 ) { 
	    Lead2_buttons.ConsLR_s=1;
	    status_consider_localref2=TRUE;
            set_buttons_lead2_unsubtr_manual();

	    if ( global_ref[2].set) {
	      act_ref_data[2].copy_ref(global_ref[2]);
	      act_ref_data[2].code1=0;

	      act_reference[2].set=TRUE;
	      act_reference[0].change=FALSE;
	      act_reference[1].change=FALSE;
	      act_reference[2].change=FALSE;
	      act_reference[2].typ=1; // global
	      act_reference[2].index=-1;

	      data_mstime_index= data_fin[Marker[2].fine_index].index;
	      reference_mstime_index= data_fin[act_ref_data[2].fine_index].index;

	      data_new_r_read();
	      get_average_R();
	      update_marker(2,192);

	    } // end cons loc ref 
	      draw_grid_lead0(2); 
	      show_data(2,FALSE,TRUE) ;

	}
	set_buttons_lead2();

	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Event callback function for `l_cp2'.
//
Notify_value
sem_0_l_bw2_l_cp2_event_callback(Xv_window win, Event *event, Notify_arg arg, Notify_event_type type)
{
	sem_0_l_bw2_objects *ip = (sem_0_l_bw2_objects *) xv_get(xv_get(win, CANVAS_PAINT_CANVAS_WINDOW), XV_KEY_DATA, INSTANCE);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION

	if (event_action(event) == ACTION_SELECT)
	{
		l_call_left2(win, event, arg, type);
	}
	
	if (event_action(event) == ACTION_ADJUST)
	{
		l_call_center2(win, event, arg, type);
	}
	
	if (event_action(event) == ACTION_MENU)
	{
		l_call_right2(win, event, arg, type);
	}
	
	// gxv_end_connections

	return notify_next_event_func(win, (Notify_event) event, arg, type);
}

//
// User-defined action for `l_cp2'.
//
void
l_call_left2(Xv_window win, Event *event, Notify_arg arg, Notify_event_type type)
{
	sem_0_l_bw2_objects *ip = (sem_0_l_bw2_objects *) xv_get(xv_get(win, CANVAS_PAINT_CANVAS_WINDOW), XV_KEY_DATA, INSTANCE);
	
long x,y,i, dx;
long c_Time;
char pr_time[12];
int lead = 2;

        x=(event->ie_xevent)->xbutton.x ;
        c_Time = (long)(FSAMP *(diagram_time_begin_lead+ double(x-160.0)*time_scale_0/960.0));

	if ( ( c_Time < data_raw[raw_display_begin].index) || ( c_Time > data_fin[fin_display_end].index ) ) return;

        i=raw_display_begin;
        while ( (c_Time > data_raw[i].index) && (i < (raw_display_end)) ) i++;
        dx= abs(c_Time - data_raw[i].index);

        click_l2.first=! click_l2.first;

        click_l2.x=(event->ie_xevent)->xbutton.x;
        click_l2.y=(event->ie_xevent)->xbutton.y;
        if ( click_l2.first ){	

   dx= abs(c_Time - data_raw[i].index);
   if (dx == 0) {
     click_l2.raw_l=i; click_l2.raw_r=i; click_l2.raw=i; 
   }
   else { click_l2.raw_l=i-1; click_l2.raw_r=i;
	  if ( dx < FSAMP) { click_l2.raw=i;}
	  else  { click_l2.raw=i-1;}
   }
   i=click_l2.raw;

   i=fin_display_begin;

   while ( ( data_raw[click_l2.raw].index > data_fin[i].index) && (i < (fin_display_end+1)) )
     {

 i++;
 }

   dx= abs( data_raw[click_l2.raw].index - data_fin[i].index);
   if (dx == 0) {
     click_l2.fine_l=i; click_l2.fine_r=i; click_l2.fine=i; 
   }
   else { click_l2.fine_l=i-1; click_l2.fine_r=i;
	  click_l2.fine=i;
   }
   i=click_l2.fine;

   XAllocNamedColor(l_b2_display, cmap,set_color8, &col, & unused);
   XSetForeground(l_b2_display, gcLead1, col.pixel);

 if (Lead2_operation == 0 || ( Lead2_operation != 0 && click_l2.y > BORDER_SEP_CLICK) ) {
  if ( click_l2.y > BORDER_SEP_CLICK ) {

   XFillRectangle(l_b2_display, l_b2_window, gcLead2, 40,162,90,15);

   XAllocNamedColor(l_b2_display, cmap,"black", &col, & unused);
   XSetForeground(l_b2_display, gcLead2, col.pixel);

   sprintf(pr_time, "%s",mstimstr(c_Time));
   XDrawString(l_b2_display, l_b2_window, gcLead2, 42, 174, pr_time, strlen(pr_time));

   XAllocNamedColor(l_b2_display, cmap,"white", &col, & unused);
   XSetForeground(l_b2_display, gcLead2, col.pixel);
   XFillRectangle(l_b2_display, l_b2_window, gcLead2, 1,55,130,90);

   XAllocNamedColor(l_b2_display, cmap,set_color8, &col, & unused);
   XSetForeground(l_b2_display, gcLead2, col.pixel);
   XFillRectangle(l_b2_display, l_b2_window, gcLead2, 1, 55,130,12);
   XFillRectangle(l_b2_display, l_b2_window, gcLead2, 1, 79,130,24);
   XFillRectangle(l_b2_display, l_b2_window, gcLead2, 1, 108, 130,12);

   XAllocNamedColor(l_b2_display, cmap,"black", &col, & unused);
   XSetForeground(l_b2_display, gcLead2, col.pixel);

   sprintf(pr_buff, "RAW: %14s",mstimstr(data_raw[click_l2.raw].index));
   XDrawString(l_b2_display, l_b2_window, gcLead2, 2, 66, pr_buff, strlen(pr_buff));

   sprintf(pr_buff, "HRate: %9d [bpm]",data_raw[click_l2.raw].HR);
   XDrawString(l_b2_display, l_b2_window, gcLead2, 2, 78, pr_buff, strlen(pr_buff));

   sprintf(pr_buff,"ST80:");
   XDrawString(l_b2_display, l_b2_window, gcLead2, 2, 90, pr_buff, strlen(pr_buff));
   sprintf(pr_buff," %6d/%6d",mk_uv(data_raw[click_l2.raw].l2_ST80),
                              mk_uv(data_raw[click_l2.raw].l2_ST80)-click_ST80_2);
   click_ST80_2 = mk_uv(data_raw[click_l2.raw].l2_ST80);
   XDrawString(l_b2_display, l_b2_window, gcLead2, 40, 90, pr_buff, strlen(pr_buff));

   sprintf(pr_buff,"STSb:");
   XDrawString(l_b2_display, l_b2_window, gcLead2, 2, 102, pr_buff, strlen(pr_buff));
   sprintf(pr_buff," %6d/%6d",mk_uv(data_raw[click_l2.raw].sub_v[lead]),
                              mk_uv(data_raw[click_l2.raw].sub_v[lead]) - click_STsb_2);
   click_STsb_2 = mk_uv(data_raw[click_l2.raw].sub_v[lead]);
   XDrawString(l_b2_display, l_b2_window,  gcLead2, 40, 102, pr_buff, strlen(pr_buff));

   sprintf(pr_buff, "FINE: %14s",mstimstr(data_fin[click_l2.fine].index));
   XDrawString(l_b2_display, l_b2_window, gcLead2, 2, 120, pr_buff, strlen(pr_buff));

   sprintf(pr_buff, "HRate: %9d [bpm]", data_fin[click_l2.fine].HR);
   XDrawString(l_b2_display, l_b2_window, gcLead2, 2, 132, pr_buff, strlen(pr_buff));

   sprintf(pr_buff,"ST80:");
   XDrawString(l_b2_display, l_b2_window, gcLead2, 2, 144, pr_buff, strlen(pr_buff));
   sprintf(pr_buff," %6d/%6d", mk_uv( data_fin[click_l2.fine].l2_ST80),
                 	   mk_uv( data_fin[click_l2.fine].l2_ST80) - click_ST80_f2);
   click_ST80_f2 = mk_uv( data_fin[click_l2.fine].l2_ST80);
   XDrawString(l_b2_display, l_b2_window, gcLead2, 40, 144, pr_buff, strlen(pr_buff));
   }
   else {
     if (IS_free(2, click_l2.raw,0)) {

      Lead2_operation = 1;

       Marker[2].set=TRUE;
       Marker[2].raw_index=click_l2.raw; Marker[2].fine_index=click_l2.fine;
       set_marker_l(2);
       draw_grid_lead0(2); 
       show_data(2,FALSE, TRUE);
       Lead2_operation = 0;}
   }
  } else {
      sub_op2_exec();
  }
             }
        else {

   XAllocNamedColor(l_b2_display, cmap,"white", &col, & unused);
   XSetForeground(l_b2_display, gcLead2, col.pixel);

   XFillRectangle(l_b2_display, l_b2_window, gcLead2, 40,162,90,15);

   XAllocNamedColor(l_b2_display, cmap,"black", &col, & unused);
   XSetForeground(l_b2_display, gcLead2, col.pixel);
	}
}

//
// User-defined action for `l_cp2'.
//
void
l_call_center2(Xv_window win, Event *event, Notify_arg arg, Notify_event_type type)
{
	sem_0_l_bw2_objects *ip = (sem_0_l_bw2_objects *) xv_get(xv_get(win, CANVAS_PAINT_CANVAS_WINDOW), XV_KEY_DATA, INSTANCE);
	
	if (Lead2_operation != 0 )  return;

def_click click_tmp2;

long x,y,i, dx;
long c_Time;
char pr_time[12];
long  r_i;
int   lead = 2;
short Lead2_operation_tmp;

        x=(event->ie_xevent)->xbutton.x;
        c_Time = (long)(FSAMP *(diagram_time_begin_lead+ double(x-160.0)*time_scale_0/960.0));

	if ( ( c_Time < data_raw[raw_display_begin].index) || ( c_Time > data_fin[fin_display_end].index ) ) return;

        i=raw_display_begin;
        while ( (c_Time > data_raw[i].index) && (i < (raw_display_end)) ) i++;
        dx= abs(c_Time - data_raw[i].index);

        click_c2.first=! click_c2.first;

        click_c2.x=(event->ie_xevent)->xbutton.x;
        click_c2.y=(event->ie_xevent)->xbutton.y;
        if ( click_c2.first ){	

   dx= abs(c_Time - data_raw[i].index);
   if (dx == 0) {
     click_c2.raw_l=i; click_c2.raw_r=i; click_c2.raw=i; 
   }
   else { click_c2.raw_l=i-1; click_c2.raw_r=i;
	  if ( dx < FSAMP) { click_c2.raw=i;}
	  else  { click_c2.raw=i-1;}
   }
   i=click_c2.raw;

   i=fin_display_begin;

   while ( ( data_raw[click_c2.raw].index > data_fin[i].index) && (i < (fin_display_end+1)) )
     {

 i++;
 }

   dx= abs( data_raw[click_c2.raw].index - data_fin[i].index);
   if (dx == 0) {
     click_c2.fine_l=i; click_c2.fine_r=i; click_c2.fine=i; 
   }
   else { click_c2.fine_l=i-1; click_c2.fine_r=i;
	  click_c2.fine=i;
   }
   i=click_c2.fine;

   if ( click_c2.y <= BORDER_SEP_CLICK ) {
       Lead2_operation_tmp = Lead2_operation;
       Lead2_operation = 9;

       click_tmp2.first = click_l2.first;
       click_tmp2.x = click_l2.x;
       click_tmp2.y = click_l2.y;
       click_tmp2.time_index = click_l2.time_index;
       click_tmp2.raw = click_l2.raw;
       click_tmp2.raw_l = click_l2.raw_l;
       click_tmp2.raw_r = click_l2.raw_r;
       click_tmp2.fine = click_l2.fine;
       click_tmp2.fine_l = click_l2.fine_l;
       click_tmp2.fine_r = click_l2.fine_r;

       click_l2.first = click_c2.first;
       click_l2.x = click_c2.x;
       click_l2.y = click_c2.y;
       click_l2.time_index = click_c2.time_index;
       click_l2.raw = click_c2.raw;
       click_l2.raw_l = click_c2.raw_l;
       click_l2.raw_r = click_c2.raw_r;
       click_l2.fine = click_c2.fine;
       click_l2.fine_l = click_c2.fine_l;
       click_l2.fine_r = click_c2.fine_r;

       fast2_center = TRUE;
      
       if (!repeat_set2) {
         fast2_center = FALSE;
         sub_op2_start();     
       }
       sub_op2_exec();
       fast2_center = FALSE;

       click_l2.first = click_tmp2.first;
       click_l2.x = click_tmp2.x;
       click_l2.y = click_tmp2.y;
       click_l2.time_index = click_tmp2.time_index;
       click_l2.raw = click_tmp2.raw;
       click_l2.raw_l = click_tmp2.raw_l;
       click_l2.raw_r = click_tmp2.raw_r;
       click_l2.fine = click_tmp2.fine;
       click_l2.fine_l = click_tmp2.fine_l;
       click_l2.fine_r = click_tmp2.fine_r;

    Lead2_operation = Lead2_operation_tmp;

   }
 }
}

//
// User-defined action for `l_cp2'.
//
void
l_call_right2(Xv_window win, Event *event, Notify_arg arg, Notify_event_type type)
{
	sem_0_l_bw2_objects *ip = (sem_0_l_bw2_objects *) xv_get(xv_get(win, CANVAS_PAINT_CANVAS_WINDOW), XV_KEY_DATA, INSTANCE);
	
}

//
// User-defined action for `m_b_Lead0'.
//
void
l_ini_lcp_b(Panel_item item, Event *event)
{
	sem_0_m_bw_objects *ip = (sem_0_m_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	draw_grid_lead0(0);  
	if (lead1_data )  draw_grid_lead0(1); 
	if (lead2_data )  draw_grid_lead0(2); 

}

//
// User-defined action for `m_b_Data'.
//
void
d_ini_cp_b(Panel_item item, Event *event)
{
	sem_0_m_bw_objects *ip = (sem_0_m_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	show_data(Data_lead,TRUE, FALSE);
}

//
// User-defined action for `m_b_Lead1'.
//
void
l_ini_cp1_b(Panel_item item, Event *event)
{
	sem_0_m_bw_objects *ip = (sem_0_m_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
        draw_grid_lead0(1); 
}

//
// User-defined action for `m_b_KLCoeff'.
//
void
k_ini_cp_b(Panel_item item, Event *event)
{
	sem_0_m_bw_objects *ip = (sem_0_m_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
        draw_grid_coeff();
}

//
// User-defined action for `m_b_Lead2'.
//
void
l_ini_cp2_b(Panel_item item, Event *event)
{
	sem_0_m_bw_objects *ip = (sem_0_m_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
    
        draw_grid_lead0(2); 
}

//
// Repaint callback function for `k_cp'.
//
void
k_ini_cpb(Canvas canvas, Xv_window paint_window, Display *display, Window xid, Xv_xrectlist *rects)
{
	gckoeff = DefaultGC(display, DefaultScreen(display));
	k_b_display = display;
	k_b_window = xid;
	
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Repaint callback function for `d_cp'.
//
void
d_ini_cpb(Canvas canvas, Xv_window paint_window, Display *display, Window xid, Xv_xrectlist *rects)
{
	gcdata = DefaultGC(display, DefaultScreen(display));
	d_b_display = display;
	d_b_window = xid;

	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Repaint callback function for `l_cp1'.
//
void
l_ini_cp1b(Canvas canvas, Xv_window paint_window, Display *display, Window xid, Xv_xrectlist *rects)
{
       	gcLead1 = DefaultGC(display, DefaultScreen(display));
	l_b1_display = display;
	l_b1_window = xid;

	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Repaint callback function for `l_cp2'.
//
void
l_ini_cp2b(Canvas canvas, Xv_window paint_window, Display *display, Window xid, Xv_xrectlist *rects)
{
	gcLead2 = DefaultGC(display, DefaultScreen(display));
	l_b2_display = display;
	l_b2_window = xid;


	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Event callback function for `m_b_Open'.
//
void
sem_0_m_bw_m_b_Open_event_callback(Panel_item item, Event *event)
{
	sem_0_m_bw_objects *ip = (sem_0_m_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections

	panel_default_handle_event(item, event);
}

//
// User-defined action for `m_b_Open'.
//
void
main_open_init(Panel_item item, Event *event)
{
	sem_0_m_bw_objects *ip = (sem_0_m_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);

// set parameters

FILE *set_data=NULL;
char i_str1[132], i_str2[132];
int x, i, j, l;
int test=0;

	if((set_data=fopen("semia.opt","r")) != NULL )
	   {
	     l=fscanf(set_data,"%s\n",&i_str1);

	     i=0; j=0;
	     while ((i_str1[i] != ':') && ( i < 132) ) i++;
	     i++;
	     while (i_str1[i] != 0 ) { i_str2[j]=i_str1[i]; i++; j++;}
	     i_str2[j]=0;
	     x=(int)(strtod(i_str2,0));

             set_line_width=x;
	     if ((x > 0) && (x < 5) )
	       { set_line_width=x;}
	     else 
	       { test++;}

	     l=fscanf(set_data,"%s\n",&i_str1);

	     i=0; j=0;
	     while ((i_str1[i] != ':') && ( i < 132) ) i++;
	     i++;
	     while (i_str1[i] != 0 ) { set_color1[j]=i_str1[i]; i++; j++;}
	     set_color1[j]=0;
	     if (j == 0) test++;

	     l=fscanf(set_data,"%s\n",&i_str1);

	     i=0; j=0;
	     while ((i_str1[i] != ':') && ( i < 132) ) i++;
	     i++;
	     while (i_str1[i] != 0 ) { set_color2[j]=i_str1[i]; i++; j++;}  
	     set_color2[j]=0;
	     if (j == 0) test++;

	     l=fscanf(set_data,"%s\n",&i_str1);

             i=0; j=0;
	     while ((i_str1[i] != ':') && ( i < 132) ) i++;
	     i++;
	     while (i_str1[i] != 0 ) { set_color3[j]=i_str1[i]; i++; j++;}  
	     set_color3[j]=0;
	     if (j == 0) test++;

	     l=fscanf(set_data,"%s\n",&i_str1);

	     i=0; j=0;
	     while ((i_str1[i] != ':') && ( i < 132) ) i++;
	     i++;
	     while (i_str1[i] != 0 ) { set_color4[j]=i_str1[i]; i++; j++;}  
	     set_color4[j]=0;
	     if (j == 0) test++;

	     l=fscanf(set_data,"%s\n",&i_str1);

	     i=0; j=0;
	     while ((i_str1[i] != ':') && ( i < 132) ) i++;
	     i++;
	     while (i_str1[i] != 0 ) { set_color5[j]=i_str1[i]; i++; j++;}  
	     set_color5[j]=0;
	     if (j == 0) test++;

	     l=fscanf(set_data,"%s\n",&i_str1);

	     i=0; j=0;
	     while ((i_str1[i] != ':') && ( i < 132) ) i++;
	     i++;
	     while (i_str1[i] != 0 ) { set_color6[j]=i_str1[i]; i++; j++;}  
	     set_color6[j]=0;
	     if (j == 0) test++;

	if (test > 0 ){ 
               fprintf(stderr,"semia: incorrect options (semia.opt file)\n");
               fprintf(stderr,"LineWidth:%d\n",set_line_width);
               fprintf(stderr,"Color1:%s\n",set_color1);
               fprintf(stderr,"Color2:%s\n",set_color2);
               fprintf(stderr,"Color3:%s\n",set_color3);
               fprintf(stderr,"Color4:%s\n",set_color4);
               fprintf(stderr,"Color5:%s\n",set_color5);
               fprintf(stderr,"Color6:%s\n",set_color6);
                      }
	  }
	else
	  {
           fprintf(stderr,"semia: no semia.opt file\n");
          }

	xv_set(Sem_0_o_pw.o_b_OK, PANEL_INACTIVE, TRUE, NULL);

        xv_set(Sem_0_m_bw.m_b_Lead0, PANEL_INACTIVE, TRUE, NULL);
        xv_set(Sem_0_m_bw.m_b_Lead1, PANEL_INACTIVE, TRUE, NULL);
        xv_set(Sem_0_m_bw.m_b_Lead2, PANEL_INACTIVE, TRUE, NULL);
        xv_set(Sem_0_m_bw.m_b_Data, PANEL_INACTIVE, TRUE, NULL);
        xv_set(Sem_0_m_bw.m_b_KLCoeff, PANEL_INACTIVE, TRUE, NULL);
        xv_set(Sem_0_m_bw.m_b_DiagData, PANEL_INACTIVE, TRUE, NULL);
        xv_set(Sem_0_m_bw.m_b_NumEpis, PANEL_INACTIVE, TRUE, NULL);

	  xv_set(Sem_0_l_bw.l_b_shift_l, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_ll, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_l1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_ll1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_l2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_ll2, PANEL_INACTIVE, FALSE, NULL);

	  xv_set(Sem_0_l_bw.l_b_shift_r, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw.l_b_shift_rr, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_r1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw1.l_b_shift_rr1, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_r2, PANEL_INACTIVE, FALSE, NULL);
	  xv_set(Sem_0_l_bw2.l_b_shift_rr2, PANEL_INACTIVE, FALSE, NULL);

nsig=0;

// set initial state

final_save = FALSE;
auto_save  = FALSE;     
auto_save_counter = 0;
lead1_data=FALSE,  lead2_data=FALSE; // given data
last_set_all = FALSE;
Lead0_operation=0; Lead1_operation=0; Lead2_operation=0;
change_atribute0=FALSE;  change_atribute1=FALSE; change_atribute2=FALSE;
how0=FALSE; how1=FALSE; how2=FALSE;
Data_lead=0;
repeat_set =FALSE; repeat_set1=FALSE; repeat_set2=FALSE;

global_set= FALSE;
act_reference[0].set=FALSE; act_reference[1].set=FALSE; act_reference[2].set=FALSE;
Marker[0].set = FALSE;  Marker[1].set = FALSE;  Marker[2].set= FALSE;

status_manual_mode=TRUE, status_unsubtracted=TRUE, status_consider_localref=TRUE;
status_manual_mode1=TRUE, status_unsubtracted1=TRUE, status_consider_localref1=TRUE;
status_manual_mode2=TRUE, status_unsubtracted2=TRUE, status_consider_localref2=TRUE;

status_consider_localref = TRUE; status_consider_localref1 = TRUE; status_consider_localref2 = TRUE;
   
reset_HR_lead0(0);   reset_HR_lead0(1);   reset_HR_lead0(2);

set_buttons_lead0_start();
lead0_plot_button_status.HRate=TRUE;
set_buttons_lead0();
set_buttons_lead1_start();
lead1_plot_button_status.HRate=TRUE;
set_buttons_lead1();
set_buttons_lead2_start();
lead2_plot_button_status.HRate=TRUE;
set_buttons_lead2();

// lead window general
time_scale_0=720, time_scale_1=720, time_scale_2=720;  // 720 = 12 min 
time_scale_d=6; // 6 = 6sec

scale_time_tick=60; // 720 / 12 = 60

	 xv_set(Sem_0_l_bw.l_ss_12min, PANEL_VALUE,5,NULL);
	 xv_set(Sem_0_l_bw1.l_ss_12min1, PANEL_VALUE,5,NULL);
	 xv_set(Sem_0_l_bw2.l_ss_12min2, PANEL_VALUE,5,NULL);

	 xv_set(Sem_0_l_bw.l_ss_100mV, PANEL_VALUE,4,NULL);
	 xv_set(Sem_0_l_bw1.l_ss_100mV1, PANEL_VALUE,4,NULL);
	 xv_set(Sem_0_l_bw2.l_ss_100mV2, PANEL_VALUE,4,NULL);

	 xv_set(Sem_0_l_bw.l_ss_HRate, PANEL_VALUE,0,NULL);
	 xv_set(Sem_0_l_bw1.l_ss_HRate1, PANEL_VALUE,0,NULL);
	 xv_set(Sem_0_l_bw2.l_ss_HRate2, PANEL_VALUE,0,NULL);

// lead0 window
ampl_0=100; ampl_1=100; ampl_2=100;
allow_l0=FALSE;
click_l0.first=FALSE; 
click_r0.first=FALSE; 
auto_ampl_2[0]= 75 * STAMPL / 1000;

// active = true
   ovr0_l1=FALSE; ovr0_l2=FALSE; 
   ovr0_app = FALSE;  

   click_ST80_0 = 0, click_STsb_0 = 0, click_ST80_f0 = 0;
   fast0_center = FALSE; 
   fast0_right  = FALSE; 

// lead1 window
   ampl_1=100;
   click_ST80_1 = 0, click_STsb_1 = 0, click_ST80_f1 = 0;
   fast1_center = FALSE; 
   fast1_right  = FALSE; 
   ovr1_l0=FALSE,  ovr1_l2=FALSE;
   ovr1_app = FALSE; 
   allow_l1=FALSE;
   click_l1.first=FALSE; 
   click_r1.first=FALSE; 
   auto_ampl_2[1]= 75 * STAMPL / 1000;

// lead2 window
   ampl_2=100; // 100 = 100uV
   click_ST80_2 = 0, click_STsb_2 = 0, click_ST80_f2 = 0;
   fast2_center = FALSE; 
   fast2_right  = FALSE; 
   ovr2_l1=FALSE,  ovr2_l0=FALSE;
   ovr2_app = FALSE;
   allow_l2=FALSE;
   click_l2.first=FALSE; 
   click_r2.first=FALSE; 
   auto_ampl_2[2]= 75 * STAMPL / 1000;

// coeff window
KL_coefficents=TRUE; // display = true
ampl_c=1.0;
click_c.first=FALSE; 
ovr_coef=FALSE; // overly

// data window
Data_lead=0; 
data_ovrly=1; 
data_ovrly_shift=FALSE;
data_ovr_ref=FALSE;
x_lead =FALSE;

  xv_set(Sem_0_d_bw.d_b_lead, PANEL_LABEL_STRING, "Lead 0", NULL);
  xv_set(Sem_0_d_bw.d_ss_6s, PANEL_VALUE,4,NULL);
  xv_set(Sem_0_d_bw.d_ss_1mV, PANEL_VALUE,9,NULL);
  xv_set(Sem_0_d_bw.d_ss_520ms, PANEL_VALUE,4,NULL);
  xv_set(Sem_0_d_bw.d_ss_16s, PANEL_VALUE,5,NULL);

  xv_set(Sem_0_d_bw.d_ss_Ovrly, PANEL_VALUE,0,NULL);

  xv_set(Sem_0_d_bw.d_b_OvrRef, PANEL_INACTIVE, TRUE, NULL); 

ampl_d=1000;   // default 1mV

data_tick=160;
data_scale=6;

data_grid_tick= data_tick * 960.0 / data_scale / 1000.0;
data_ovr_l0= FALSE;  data_ovr_l1= FALSE;  data_ovr_l2= FALSE;

current_average_beat_time=520 ;           // 520 msec
d_avrg_index = current_average_beat_time / ( 1000 / FSAMP ) /2 ;

current_average_window_index= 8 *FSAMP;   // index =( time [sec] / 2 ) -> msec
current_average_window_time= 8 ;          // 16 sec  - default

xv_set(Sem_0_k_bw.k_ss_ST, PANEL_VALUE,0,NULL);
xv_set(Sem_0_k_bw.k_ss_1std, PANEL_VALUE,5,NULL);
xv_set(Sem_0_k_bw.k_b_Overlay, PANEL_LABEL_STRING, "DistF", NULL);

ovr_coef=FALSE;
	
current_mean_smp=5;

reset_global_reference();

}

//
// Notify callback function for `o_fike_button1'.
//
void
sem_0_o_pw_o_fike_button1_notify_callback(Panel_item item, Event *event)
{
	sem_0_o_pw_objects *ip = (sem_0_o_pw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections

}

//
// Notify callback function for `d_b_lead'.
//
void
d_call_menu_lead(Panel_item item, Event *event)
{
	sem_0_d_bw_objects *ip = (sem_0_d_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections
}

//
// Menu handler for `d_menu_lead (Lead0)'.
//
Menu_item
d_menu_call_lead0(Menu_item item, Menu_generate op)
{
	sem_0_d_bw_objects * ip = (sem_0_d_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (op) {
	case MENU_DISPLAY:
	  	if (  Data_lead == 0 ) { xv_set(item, MENU_INACTIVE, TRUE, 0);
						  }
		else
		  { xv_set(item, MENU_INACTIVE, FALSE, 0);}
		break;

	case MENU_DISPLAY_DONE:
		break;

	case MENU_NOTIFY:

	  xv_set(Sem_0_d_bw.d_b_lead, PANEL_LABEL_STRING, "Lead 0", NULL);

          Data_lead=0; 
	  data_ovr_l0= FALSE;  data_ovr_l1= FALSE;  data_ovr_l2= FALSE;

	  current_j_m=Marker[Data_lead].nJ;
	  current_iso_m=Marker[Data_lead].nISO;

          show_data(Data_lead,FALSE, FALSE);

		// gxv_start_connections DO NOT EDIT THIS SECTION
		// gxv_end_connections

		break;

	case MENU_NOTIFY_DONE:
		break;
	}
	return item;
}

//
// Menu handler for `d_menu_lead (Lead1)'.
//
Menu_item
d_menu_call_lead1(Menu_item item, Menu_generate op)
{
	sem_0_d_bw_objects * ip = (sem_0_d_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (op) {

	case MENU_DISPLAY:
	  	if ( (! lead1_data) OR (Data_lead ==1) ) { xv_set(item, MENU_INACTIVE, TRUE, 0);
						  }
		else
		  { xv_set(item, MENU_INACTIVE, FALSE, 0);
						  }
		break;

	case MENU_DISPLAY_DONE:
		break;

	case MENU_NOTIFY:
		
	  xv_set(Sem_0_d_bw.d_b_lead, PANEL_LABEL_STRING, "Lead 1", NULL);
          Data_lead=1;
	  data_ovr_l0= FALSE;  data_ovr_l1= FALSE;  data_ovr_l2= FALSE;

	  current_j_m=Marker[Data_lead].nJ;
	  current_iso_m=Marker[Data_lead].nISO;

		 show_data(Data_lead,FALSE, FALSE);

		// gxv_start_connections DO NOT EDIT THIS SECTION
		// gxv_end_connections

		break;

	case MENU_NOTIFY_DONE:
		break;
	}
	return item;
}

//
// Menu handler for `d_menu_lead (Lead2)'.
//
Menu_item
d_menu_call_lead2(Menu_item item, Menu_generate op)
{
	sem_0_d_bw_objects * ip = (sem_0_d_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	switch (op) {
	case MENU_DISPLAY:
	  	if ( (! lead2_data)  OR ( Data_lead == 2) ) { xv_set(item, MENU_INACTIVE, TRUE, 0);
						  }
		else
		  { xv_set(item, MENU_INACTIVE, FALSE, 0);
						  }
		break;

	case MENU_DISPLAY_DONE:
		break;

	case MENU_NOTIFY:

		
	  xv_set(Sem_0_d_bw.d_b_lead, PANEL_LABEL_STRING, "Lead 2", NULL);
          Data_lead=2; 
	  data_ovr_l0= FALSE;  data_ovr_l1= FALSE;  data_ovr_l2= FALSE;

	  current_j_m=Marker[Data_lead].nJ;
	  current_iso_m=Marker[Data_lead].nISO;

		show_data(Data_lead,FALSE, FALSE);

		// gxv_start_connections DO NOT EDIT THIS SECTION
		// gxv_end_connections

		break;

	case MENU_NOTIFY_DONE:
		break;
	}
	return item;
}

//
// Notify callback function for `d_ss_Ovrly'.
//
void
d_call_menu_Ovrly(Panel_item item, int value, Event *event)
{
	sem_0_d_bw_objects *ip = (sem_0_d_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	if (value == 0) { data_ovrly_shift=FALSE; }
	if (value == 1) { data_ovrly_shift=TRUE; }
	if (value == 2) { data_ovrly_shift=FALSE; }

	if (value == 3) { data_ovrly_shift=FALSE; }
	if (value == 4) { data_ovrly_shift=FALSE; }
	
	// gxv_start_connections DO NOT EDIT THIS SECTION
	// gxv_end_connections

	show_data(Data_lead,FALSE, FALSE);
}

//
// Notify callback function for `m_b_NumEpis'.
//
void
sem_0_m_bw_m_b_NumEpis_notify_callback(Panel_item item, Event *event)
{
	sem_0_m_bw_objects *ip = (sem_0_m_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION

	xv_set(Sem_0_c_pw.c_pw, FRAME_CMD_PUSHPIN_IN, TRUE, NULL);
	xv_set(Sem_0_c_pw.c_pw, XV_SHOW, TRUE, NULL);
	
	init_counts(item, event);
	
	show_counts(item, event);
	
	// gxv_end_connections

}

//
// User-defined action for `m_b_NumEpis'.
//
void
init_counts(Panel_item item, Event *event)
{
	sem_0_m_bw_objects *ip = (sem_0_m_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
}
//
// User-defined action for `m_b_NumEpis'.
//
void
show_counts(Panel_item item, Event *event)
{
	sem_0_m_bw_objects *ip = (sem_0_m_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
FILE *file_counts=NULL;
char counts_name[16];
char bufferc[512];
static int al=0;

	xv_set(Sem_0_c_pw.textpane_numepis, TEXTSW_READ_ONLY, FALSE, NULL);
        xv_set(Sem_0_c_pw.textpane_numepis, TEXTSW_IGNORE_LIMIT, TEXTSW_INFINITY, NULL);

        textsw_delete(Sem_0_c_pw.textpane_numepis,0,TEXTSW_INFINITY);
        textsw_reset(Sem_0_c_pw.textpane_numepis,0,TEXTSW_INFINITY);
        al = 0;

	xv_set(Sem_0_c_pw.textpane_numepis, TEXTSW_READ_ONLY, TRUE, NULL);
        xv_set(Sem_0_c_pw.textpane_numepis, TEXTSW_IGNORE_LIMIT, TEXTSW_INFINITY, NULL);
                
        sprintf(counts_name,"%s.cnt",inp_rec_name);
	file_counts=fopen(counts_name,"r");

   	if (file_counts == NULL) {
	  sprintf(bufferc,"\n\n    No <%s.cnt> file !\n\n",  inp_rec_name );
          textsw_replace_bytes(Sem_0_c_pw.textpane_numepis,al,al,
                                                       bufferc,strlen(bufferc));
          al += strlen(bufferc);
	} else {
	  while (fgets(bufferc,512,file_counts) != NULL) {
	    textsw_replace_bytes(Sem_0_c_pw.textpane_numepis,al,al,
                                                        " ",strlen(" "));
            al += strlen(" ");
	    textsw_replace_bytes(Sem_0_c_pw.textpane_numepis,al,al,
                                                        bufferc,strlen(bufferc));
            al += strlen(bufferc);
	  }
        fclose(file_counts);
        textsw_normalize_view(Sem_0_c_pw.textpane_numepis, 0);
	} 
	xv_set(Sem_0_c_pw.textpane_numepis, TEXTSW_READ_ONLY, TRUE, NULL);
        xv_set(Sem_0_c_pw.textpane_numepis, TEXTSW_IGNORE_LIMIT, TEXTSW_INFINITY, NULL);
}

//
// Notify callback function for `m_b_DiagData'.
//
void
sem_0_m_bw_m_b_DiagData_notify_callback(Panel_item item, Event *event)
{
	sem_0_m_bw_objects *ip = (sem_0_m_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION

	xv_set(Sem_0_d_pw.d_pw, FRAME_CMD_PUSHPIN_IN, TRUE, NULL);
	xv_set(Sem_0_d_pw.d_pw, XV_SHOW, TRUE, NULL);
	
	init_diagdata(item, event);
	
	show_diagdata(item, event);
	
	// gxv_end_connections
}

//
// User-defined action for `m_b_DiagData'.
//
void
init_diagdata(Panel_item item, Event *event)
{
	sem_0_m_bw_objects *ip = (sem_0_m_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
}

//
// User-defined action for `m_b_DiagData'.
//
void
show_diagdata(Panel_item item, Event *event)
{
	sem_0_m_bw_objects *ip = (sem_0_m_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);

FILE   *file_diag=NULL;
char   diag_name[16];
char   buffer[512];
char   mrec[8], cleads[3], fsamp[5], durat[32], stime[64], lname[32];
int    ix,ix1,ix2,ix3, theleads, ihours, imin, isec;
double sec, ddurat;
long   ldurat;
static int ad=0;
static int clines=0;

	xv_set(Sem_0_d_pw.textpane_data, TEXTSW_READ_ONLY, FALSE, NULL);
        xv_set(Sem_0_d_pw.textpane_data, TEXTSW_IGNORE_LIMIT, TEXTSW_INFINITY, NULL);

        textsw_delete(Sem_0_d_pw.textpane_data,0,TEXTSW_INFINITY);
        textsw_reset(Sem_0_d_pw.textpane_data,0,TEXTSW_INFINITY);
        ad = 0;

	xv_set(Sem_0_d_pw.textpane_data, TEXTSW_READ_ONLY, TRUE, NULL);
        xv_set(Sem_0_d_pw.textpane_data, TEXTSW_IGNORE_LIMIT, TEXTSW_INFINITY, NULL);

	sprintf(diag_name,"%s.hea",inp_rec_name);
	file_diag=fopen(diag_name,"r");

   	if (file_diag == NULL) {
	  sprintf(buffer,"\n\n    No <%s.hea> file !\n\n",  inp_rec_name );
          textsw_replace_bytes(Sem_0_d_pw.textpane_data,ad,ad,
                                                     buffer,strlen(buffer));
          ad += strlen(buffer);
	} else {
            fgets(buffer,512,file_diag);
            clines++;
              ix = ix1 = 0;
              while (buffer[ix] != ' ') { mrec[ix1] = buffer[ix]; ix1++; ix++; }
              mrec[ix1] = '\0';
              ix++; ix1=0;
              cleads[ix1] = buffer[ix];
              ix1++; ix++;
              cleads[ix1] = '\0';  theleads = atoi(cleads);
              ix++; ix1=0;

              while (buffer[ix] != ' ') { fsamp[ix1] = buffer[ix]; ix1++; ix++; }
              fsamp[ix1] = '\0';
              ix++; ix1=0;
              while ((buffer[ix] != ' ')&&(buffer[ix] != '\n')) { durat[ix1] = buffer[ix]; ix1++; ix++; }
              durat[ix1] = '\0';
              if (buffer[ix]!='\n') ix++; 
              ix1=0;
              while (buffer[ix] != '\n') { stime[ix1] = buffer[ix]; ix1++; ix++; }
              stime[ix1] = '\0';

              ldurat = atol(durat);
              ldurat *= 4;
              ddurat = (double)ldurat/1000.;
              ihours = (int)((double)ddurat / 3600.);
              ddurat = ddurat - (ihours * 3600);
              imin   = (int)((double)ddurat / 60.);
              ddurat = ddurat - (imin * 60);
        
              sprintf(buffer,"\n Record: %s    Leads: %s    Sampling frequency: %s[samples/sec]\n\n Start time, recording date: %s\n Duration: %2d:%2d:%6.3f\n\n",  mrec, cleads, fsamp, stime, ihours, imin, ddurat);

	    textsw_replace_bytes(Sem_0_d_pw.textpane_data,ad,ad,
                                                        buffer,strlen(buffer));
            ad += strlen(buffer);

            ix = 0;
            while (ix < theleads) {
               fgets(buffer,512,file_diag);
               clines++;

               ix1 = 0; while (buffer[ix1] != '\0') ix1++;
               ix2 = ix1;
               while (buffer[ix2] != ' ') ix2--;
               for (ix3=ix2+1; ix3 <= ix1; ix3++) lname[ix3-ix2-1] = buffer[ix3];

               sprintf(buffer," Lead %1d:  %s", ix, lname);
	       textsw_replace_bytes(Sem_0_d_pw.textpane_data,ad,ad,
                                                        buffer,strlen(buffer));
               ad += strlen(buffer);
               
               ix++;                  
	    }
          sprintf(buffer,"\n");
	  textsw_replace_bytes(Sem_0_d_pw.textpane_data,ad,ad,
                                                        buffer,strlen(buffer));
          ad += strlen(buffer);
	  while (fgets(buffer,512,file_diag) != NULL) {
            clines++;
            if (buffer[0] == '#') buffer[0] = ' ';
	    textsw_replace_bytes(Sem_0_d_pw.textpane_data,ad,ad,
                                                        buffer,strlen(buffer));
            ad += strlen(buffer);
	  }
	  fclose(file_diag);
          textsw_normalize_view(Sem_0_d_pw.textpane_data, 0);
	}
	xv_set(Sem_0_d_pw.textpane_data, TEXTSW_READ_ONLY, TRUE, NULL);
        xv_set(Sem_0_d_pw.textpane_data, TEXTSW_IGNORE_LIMIT, TEXTSW_INFINITY, NULL);
}

//
// Notify callback function for `m_b_help'.
//
void
sem_0_m_bw_m_b_help_notify_callback(Panel_item item, Event *event)
{
	sem_0_m_bw_objects *ip = (sem_0_m_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
	
	// gxv_start_connections DO NOT EDIT THIS SECTION

	xv_set(Sem_0_h_pw.h_pw, FRAME_CMD_PUSHPIN_IN, TRUE, NULL);
	xv_set(Sem_0_h_pw.h_pw, XV_SHOW, TRUE, NULL);
	
	init_help(item, event);

	show_help(item, event);
	
	// gxv_end_connections

}

//
// User-defined action for `m_b_help'.
//
void
init_help(Panel_item item, Event *event)
{
	sem_0_m_bw_objects *ip = (sem_0_m_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);
}

//
// User-defined action for `m_b_help'.
//
void
show_help(Panel_item item, Event *event)
{
	sem_0_m_bw_objects *ip = (sem_0_m_bw_objects *) xv_get(item, XV_KEY_DATA, INSTANCE);

FILE *file_counts=NULL;
char counts_name[16];
char bufferh[512];
static int ah=0;

	xv_set(Sem_0_h_pw.textpane_help, TEXTSW_READ_ONLY, FALSE, NULL);
        xv_set(Sem_0_h_pw.textpane_help, TEXTSW_IGNORE_LIMIT, TEXTSW_INFINITY, NULL);

        textsw_delete(Sem_0_h_pw.textpane_help,0,TEXTSW_INFINITY);
        textsw_reset(Sem_0_h_pw.textpane_help,0,TEXTSW_INFINITY);
        ah = 0;

	xv_set(Sem_0_h_pw.textpane_help, TEXTSW_READ_ONLY, TRUE, NULL);
        xv_set(Sem_0_h_pw.textpane_help, TEXTSW_IGNORE_LIMIT, TEXTSW_INFINITY, NULL);
                
        sprintf(counts_name,"semia.hlp");
	file_counts=fopen(counts_name,"r");

   	if (file_counts == NULL) {
	  sprintf(bufferh,"\n\n    No <%s.hlp> file !\n\n",  inp_rec_name );
          textsw_replace_bytes(Sem_0_h_pw.textpane_help,ah,ah,
                                                       bufferh,strlen(bufferh));
          ah += strlen(bufferh);
	} else {
	  while (fgets(bufferh,512,file_counts) != NULL) {
	    textsw_replace_bytes(Sem_0_h_pw.textpane_help,ah,ah,
                                                        bufferh,strlen(bufferh));
            ah += strlen(bufferh);
	  }
        fclose(file_counts);
        textsw_normalize_view(Sem_0_h_pw.textpane_help, 0);
	} 
	xv_set(Sem_0_h_pw.textpane_help, TEXTSW_READ_ONLY, TRUE, NULL);
        xv_set(Sem_0_h_pw.textpane_help, TEXTSW_IGNORE_LIMIT, TEXTSW_INFINITY, NULL);
}
//=========================================================================================================


