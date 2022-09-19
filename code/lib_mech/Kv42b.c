/* Created by Language version: 6.2.0 */
/* VECTORIZED */
#define NRN_VECTORIZED 1
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "scoplib_ansi.h"
#undef PI
#define nil 0
#include "md1redef.h"
#include "section.h"
#include "nrniv_mf.h"
#include "md2redef.h"
 
#if METHOD3
extern int _method3;
#endif

#if !NRNGPU
#undef exp
#define exp hoc_Exp
extern double hoc_Exp(double);
#endif
 
#define nrn_init _nrn_init__Kv42b
#define _nrn_initial _nrn_initial__Kv42b
#define nrn_cur _nrn_cur__Kv42b
#define _nrn_current _nrn_current__Kv42b
#define nrn_jacob _nrn_jacob__Kv42b
#define nrn_state _nrn_state__Kv42b
#define _net_receive _net_receive__Kv42b 
#define kin kin__Kv42b 
#define rate rate__Kv42b 
 
#define _threadargscomma_ _p, _ppvar, _thread, _nt,
#define _threadargsprotocomma_ double* _p, Datum* _ppvar, Datum* _thread, _NrnThread* _nt,
#define _threadargs_ _p, _ppvar, _thread, _nt
#define _threadargsproto_ double* _p, Datum* _ppvar, Datum* _thread, _NrnThread* _nt
 	/*SUPPRESS 761*/
	/*SUPPRESS 762*/
	/*SUPPRESS 763*/
	/*SUPPRESS 765*/
	 extern double *getarg();
 /* Thread safe. No static _p or _ppvar. */
 
#define t _nt->_t
#define dt _nt->_dt
#define gkbar _p[0]
#define ik _p[1]
#define gk _p[2]
#define O _p[3]
#define C0 _p[4]
#define C1 _p[5]
#define C2 _p[6]
#define C3 _p[7]
#define C4 _p[8]
#define I0 _p[9]
#define I1 _p[10]
#define I2 _p[11]
#define I3 _p[12]
#define I4 _p[13]
#define IO1 _p[14]
#define IO2 _p[15]
#define I5 _p[16]
#define C5 _p[17]
#define DO _p[18]
#define DC0 _p[19]
#define DC1 _p[20]
#define DC2 _p[21]
#define DC3 _p[22]
#define DC4 _p[23]
#define DI0 _p[24]
#define DI1 _p[25]
#define DI2 _p[26]
#define DI3 _p[27]
#define DI4 _p[28]
#define DIO1 _p[29]
#define DIO2 _p[30]
#define DI5 _p[31]
#define DC5 _p[32]
#define ek _p[33]
#define alpha _p[34]
#define beta _p[35]
#define gamma _p[36]
#define delta _p[37]
#define epsilon _p[38]
#define phi _p[39]
#define v _p[40]
#define _g _p[41]
#define _ion_ek	*_ppvar[0]._pval
#define _ion_ik	*_ppvar[1]._pval
#define _ion_dikdv	*_ppvar[2]._pval
 
#if MAC
#if !defined(v)
#define v _mlhv
#endif
#if !defined(h)
#define h _mlhh
#endif
#endif
 
#if defined(__cplusplus)
extern "C" {
#endif
 static int hoc_nrnpointerindex =  -1;
 static Datum* _extcall_thread;
 static Prop* _extcall_prop;
 /* external NEURON variables */
 extern double celsius;
 /* declaration of user functions */
 static void _hoc_exponential(void);
 static void _hoc_rate(void);
 static int _mechtype;
extern void _nrn_cacheloop_reg(int, int);
extern void hoc_register_prop_size(int, int, int);
extern void hoc_register_limits(int, HocParmLimits*);
extern void hoc_register_units(int, HocParmUnits*);
extern void nrn_promote(Prop*, int, int);
extern Memb_func* memb_func;
 extern void _nrn_setdata_reg(int, void(*)(Prop*));
 static void _setdata(Prop* _prop) {
 _extcall_prop = _prop;
 }
 static void _hoc_setdata() {
 Prop *_prop, *hoc_getdata_range(int);
 _prop = hoc_getdata_range(_mechtype);
   _setdata(_prop);
 hoc_retpushx(1.);
}
 /* connect user functions to hoc names */
 static VoidFunc hoc_intfunc[] = {
 "setdata_Kv42b", _hoc_setdata,
 "exponential_Kv42b", _hoc_exponential,
 "rate_Kv42b", _hoc_rate,
 0, 0
};
#define exponential exponential_Kv42b
 extern double exponential( _threadargsprotocomma_ double , double , double , double );
 /* declare global and static user variables */
#define a0 a0_Kv42b
 double a0 = 1.589;
#define b0 b0_Kv42b
 double b0 = 0.0184;
#define c0 c0_Kv42b
 double c0 = 6.668;
#define d0 d0_Kv42b
 double d0 = 2.381;
#define e0 e0_Kv42b
 double e0 = 0.503;
#define f0 f0_Kv42b
 double f0 = 0.174;
#define f f_Kv42b
 double f = 0.045;
#define g g_Kv42b
 double g = 1.03;
#define kappa2 kappa2_Kv42b
 double kappa2 = 0.0487;
#define kappa1 kappa1_Kv42b
 double kappa1 = 0.229;
#define kic kic_Kv42b
 double kic = 3e-005;
#define kci kci_Kv42b
 double kci = 0.047;
#define lambda2 lambda2_Kv42b
 double lambda2 = 0.0065;
#define lambda1 lambda1_Kv42b
 double lambda1 = 0.151;
#define vshift vshift_Kv42b
 double vshift = 0;
#define zf zf_Kv42b
 double zf = -0.25;
#define ze ze_Kv42b
 double ze = 0.07;
#define zd zd_Kv42b
 double zd = -1.21;
#define zc zc_Kv42b
 double zc = 0.15;
#define zb zb_Kv42b
 double zb = -1.31;
#define za za_Kv42b
 double za = 0.64;
 /* some parameters have upper and lower limits */
 static HocParmLimits _hoc_parm_limits[] = {
 0,0,0
};
 static HocParmUnits _hoc_parm_units[] = {
 "a0_Kv42b", "/ms",
 "b0_Kv42b", "/ms",
 "c0_Kv42b", "/ms",
 "d0_Kv42b", "/ms",
 "e0_Kv42b", "/ms",
 "f0_Kv42b", "/ms",
 "kci_Kv42b", "/ms",
 "kic_Kv42b", "/ms",
 "kappa1_Kv42b", "/ms",
 "lambda1_Kv42b", "/ms",
 "kappa2_Kv42b", "/ms",
 "lambda2_Kv42b", "/ms",
 "vshift_Kv42b", "mV",
 "gkbar_Kv42b", "S/cm2",
 "ik_Kv42b", "mA/cm2",
 "gk_Kv42b", "S/cm2",
 0,0
};
 static double C50 = 0;
 static double C40 = 0;
 static double C30 = 0;
 static double C20 = 0;
 static double C10 = 0;
 static double C00 = 0;
 static double I50 = 0;
 static double IO20 = 0;
 static double IO10 = 0;
 static double I40 = 0;
 static double I30 = 0;
 static double I20 = 0;
 static double I10 = 0;
 static double I00 = 0;
 static double O0 = 0;
 static double delta_t = 0.01;
 /* connect global user variables to hoc */
 static DoubScal hoc_scdoub[] = {
 "f_Kv42b", &f_Kv42b,
 "g_Kv42b", &g_Kv42b,
 "a0_Kv42b", &a0_Kv42b,
 "za_Kv42b", &za_Kv42b,
 "b0_Kv42b", &b0_Kv42b,
 "zb_Kv42b", &zb_Kv42b,
 "c0_Kv42b", &c0_Kv42b,
 "zc_Kv42b", &zc_Kv42b,
 "d0_Kv42b", &d0_Kv42b,
 "zd_Kv42b", &zd_Kv42b,
 "e0_Kv42b", &e0_Kv42b,
 "ze_Kv42b", &ze_Kv42b,
 "f0_Kv42b", &f0_Kv42b,
 "zf_Kv42b", &zf_Kv42b,
 "kci_Kv42b", &kci_Kv42b,
 "kic_Kv42b", &kic_Kv42b,
 "kappa1_Kv42b", &kappa1_Kv42b,
 "lambda1_Kv42b", &lambda1_Kv42b,
 "kappa2_Kv42b", &kappa2_Kv42b,
 "lambda2_Kv42b", &lambda2_Kv42b,
 "vshift_Kv42b", &vshift_Kv42b,
 0,0
};
 static DoubVec hoc_vdoub[] = {
 0,0,0
};
 static double _sav_indep;
 static void nrn_alloc(Prop*);
static void  nrn_init(_NrnThread*, _Memb_list*, int);
static void nrn_state(_NrnThread*, _Memb_list*, int);
 static void nrn_cur(_NrnThread*, _Memb_list*, int);
static void  nrn_jacob(_NrnThread*, _Memb_list*, int);
 
static int _ode_count(int);
static void _ode_map(int, double**, double**, double*, Datum*, double*, int);
static void _ode_spec(_NrnThread*, _Memb_list*, int);
static void _ode_matsol(_NrnThread*, _Memb_list*, int);
 
#define _cvode_ieq _ppvar[3]._i
 static void _ode_matsol_instance1(_threadargsproto_);
 /* connect range variables in _p that hoc is supposed to know about */
 static const char *_mechanism[] = {
 "6.2.0",
"Kv42b",
 "gkbar_Kv42b",
 0,
 "ik_Kv42b",
 "gk_Kv42b",
 0,
 "O_Kv42b",
 "C0_Kv42b",
 "C1_Kv42b",
 "C2_Kv42b",
 "C3_Kv42b",
 "C4_Kv42b",
 "I0_Kv42b",
 "I1_Kv42b",
 "I2_Kv42b",
 "I3_Kv42b",
 "I4_Kv42b",
 "IO1_Kv42b",
 "IO2_Kv42b",
 "I5_Kv42b",
 "C5_Kv42b",
 0,
 0};
 static Symbol* _k_sym;
 
extern Prop* need_memb(Symbol*);

static void nrn_alloc(Prop* _prop) {
	Prop *prop_ion;
	double *_p; Datum *_ppvar;
 	_p = nrn_prop_data_alloc(_mechtype, 42, _prop);
 	/*initialize range parameters*/
 	gkbar = 0.00015;
 	_prop->param = _p;
 	_prop->param_size = 42;
 	_ppvar = nrn_prop_datum_alloc(_mechtype, 4, _prop);
 	_prop->dparam = _ppvar;
 	/*connect ionic variables to this model*/
 prop_ion = need_memb(_k_sym);
 nrn_promote(prop_ion, 0, 1);
 	_ppvar[0]._pval = &prop_ion->param[0]; /* ek */
 	_ppvar[1]._pval = &prop_ion->param[3]; /* ik */
 	_ppvar[2]._pval = &prop_ion->param[4]; /* _ion_dikdv */
 
}
 static void _initlists();
  /* some states have an absolute tolerance */
 static Symbol** _atollist;
 static HocStateTolerance _hoc_state_tol[] = {
 0,0
};
 static void _thread_cleanup(Datum*);
 static void _update_ion_pointer(Datum*);
 extern Symbol* hoc_lookup(const char*);
extern void _nrn_thread_reg(int, int, void(*)(Datum*));
extern void _nrn_thread_table_reg(int, void(*)(double*, Datum*, Datum*, _NrnThread*, int));
extern void hoc_register_tolerance(int, HocStateTolerance*, Symbol***);
extern void _cvode_abstol( Symbol**, double*, int);

 void _Kv42b_reg() {
	int _vectorized = 1;
  _initlists();
 	ion_reg("k", -10000.);
 	_k_sym = hoc_lookup("k_ion");
 	register_mech(_mechanism, nrn_alloc,nrn_cur, nrn_jacob, nrn_state, nrn_init, hoc_nrnpointerindex, 3);
  _extcall_thread = (Datum*)ecalloc(2, sizeof(Datum));
 _mechtype = nrn_get_mechtype(_mechanism[1]);
     _nrn_setdata_reg(_mechtype, _setdata);
     _nrn_thread_reg(_mechtype, 0, _thread_cleanup);
     _nrn_thread_reg(_mechtype, 2, _update_ion_pointer);
  hoc_register_prop_size(_mechtype, 42, 4);
  hoc_register_dparam_semantics(_mechtype, 0, "k_ion");
  hoc_register_dparam_semantics(_mechtype, 1, "k_ion");
  hoc_register_dparam_semantics(_mechtype, 2, "k_ion");
  hoc_register_dparam_semantics(_mechtype, 3, "cvodeieq");
 	hoc_register_cvode(_mechtype, _ode_count, _ode_map, _ode_spec, _ode_matsol);
 	hoc_register_tolerance(_mechtype, _hoc_state_tol, &_atollist);
 	hoc_register_var(hoc_scdoub, hoc_vdoub, hoc_intfunc);
 	ivoc_help("help ?1 Kv42b C:/Scan/lib_mech/Kv42b.mod\n");
 hoc_register_limits(_mechtype, _hoc_parm_limits);
 hoc_register_units(_mechtype, _hoc_parm_units);
 }
 static double FARADAY = 96.4853;
 static double R = 8.31342;
static int _reset;
static char *modelname = "Kv4.2 with auxilliary subunits";

static int error;
static int _ninits = 0;
static int _match_recurse=1;
static void _modl_cleanup(){ _match_recurse=1;}
static int rate(_threadargsprotocomma_ double);
 
#define _MATELM1(_row,_col) *(_nrn_thread_getelm(_so, _row + 1, _col + 1))
 
#define _RHS1(_arg) _rhs[_arg+1]
  static int _cvspth1 = 1;
 
static int _ode_spec1(_threadargsproto_);
/*static int _ode_matsol1(_threadargsproto_);*/
 extern double *_nrn_thread_getelm();
 
#define _MATELM1(_row,_col) *(_nrn_thread_getelm(_so, _row + 1, _col + 1))
 
#define _RHS1(_arg) _rhs[_arg+1]
  
#define _linmat1  1
 static int _spth1 = 0;
 static int _slist1[15], _dlist1[15]; static double *_temp1;
 static int kin();
 
static int kin (void* _so, double* _rhs, double* _p, Datum* _ppvar, Datum* _thread, _NrnThread* _nt)
 {int _reset=0;
 {
   double b_flux, f_flux, _term; int _i;
 {int _i; double _dt1 = 1.0/dt;
for(_i=1;_i<15;_i++){
  	_RHS1(_i) = -_dt1*(_p[_slist1[_i]] - _p[_dlist1[_i]]);
	_MATELM1(_i, _i) = _dt1;
      
} }
 rate ( _threadargscomma_ v ) ;
   /* ~ I0 <-> I1 ( 4.0 * alpha / f , beta * f )*/
 f_flux =  4.0 * alpha / f * I0 ;
 b_flux =  beta * f * I1 ;
 _RHS1( 13) -= (f_flux - b_flux);
 _RHS1( 12) += (f_flux - b_flux);
 
 _term =  4.0 * alpha / f ;
 _MATELM1( 13 ,13)  += _term;
 _MATELM1( 12 ,13)  -= _term;
 _term =  beta * f ;
 _MATELM1( 13 ,12)  -= _term;
 _MATELM1( 12 ,12)  += _term;
 /*REACTION*/
  /* ~ I1 <-> I2 ( 3.0 * alpha / f , 2.0 * beta * f )*/
 f_flux =  3.0 * alpha / f * I1 ;
 b_flux =  2.0 * beta * f * I2 ;
 _RHS1( 12) -= (f_flux - b_flux);
 _RHS1( 11) += (f_flux - b_flux);
 
 _term =  3.0 * alpha / f ;
 _MATELM1( 12 ,12)  += _term;
 _MATELM1( 11 ,12)  -= _term;
 _term =  2.0 * beta * f ;
 _MATELM1( 12 ,11)  -= _term;
 _MATELM1( 11 ,11)  += _term;
 /*REACTION*/
  /* ~ I2 <-> I3 ( 2.0 * alpha / f , 3.0 * beta * f )*/
 f_flux =  2.0 * alpha / f * I2 ;
 b_flux =  3.0 * beta * f * I3 ;
 _RHS1( 11) -= (f_flux - b_flux);
 _RHS1( 10) += (f_flux - b_flux);
 
 _term =  2.0 * alpha / f ;
 _MATELM1( 11 ,11)  += _term;
 _MATELM1( 10 ,11)  -= _term;
 _term =  3.0 * beta * f ;
 _MATELM1( 11 ,10)  -= _term;
 _MATELM1( 10 ,10)  += _term;
 /*REACTION*/
  /* ~ I3 <-> I4 ( alpha / f , 4.0 * beta * f )*/
 f_flux =  alpha / f * I3 ;
 b_flux =  4.0 * beta * f * I4 ;
 _RHS1( 10) -= (f_flux - b_flux);
 _RHS1( 9) += (f_flux - b_flux);
 
 _term =  alpha / f ;
 _MATELM1( 10 ,10)  += _term;
 _MATELM1( 9 ,10)  -= _term;
 _term =  4.0 * beta * f ;
 _MATELM1( 10 ,9)  -= _term;
 _MATELM1( 9 ,9)  += _term;
 /*REACTION*/
  /* ~ I4 <-> I5 ( gamma * g , delta / g )*/
 f_flux =  gamma * g * I4 ;
 b_flux =  delta / g * I5 ;
 _RHS1( 9) -= (f_flux - b_flux);
 _RHS1( 6) += (f_flux - b_flux);
 
 _term =  gamma * g ;
 _MATELM1( 9 ,9)  += _term;
 _MATELM1( 6 ,9)  -= _term;
 _term =  delta / g ;
 _MATELM1( 9 ,6)  -= _term;
 _MATELM1( 6 ,6)  += _term;
 /*REACTION*/
  /* ~ C0 <-> I0 ( kci * pow( f , 4.0 ) , kic / pow( f , 4.0 ) )*/
 f_flux =  kci * pow( f , 4.0 ) * C0 ;
 b_flux =  kic / pow( f , 4.0 ) * I0 ;
 _RHS1( 5) -= (f_flux - b_flux);
 _RHS1( 13) += (f_flux - b_flux);
 
 _term =  kci * pow( f , 4.0 ) ;
 _MATELM1( 5 ,5)  += _term;
 _MATELM1( 13 ,5)  -= _term;
 _term =  kic / pow( f , 4.0 ) ;
 _MATELM1( 5 ,13)  -= _term;
 _MATELM1( 13 ,13)  += _term;
 /*REACTION*/
  /* ~ C1 <-> I1 ( kci * pow( f , 3.0 ) , kic / pow( f , 3.0 ) )*/
 f_flux =  kci * pow( f , 3.0 ) * C1 ;
 b_flux =  kic / pow( f , 3.0 ) * I1 ;
 _RHS1( 4) -= (f_flux - b_flux);
 _RHS1( 12) += (f_flux - b_flux);
 
 _term =  kci * pow( f , 3.0 ) ;
 _MATELM1( 4 ,4)  += _term;
 _MATELM1( 12 ,4)  -= _term;
 _term =  kic / pow( f , 3.0 ) ;
 _MATELM1( 4 ,12)  -= _term;
 _MATELM1( 12 ,12)  += _term;
 /*REACTION*/
  /* ~ C2 <-> I2 ( kci * pow( f , 2.0 ) , kic / pow( f , 2.0 ) )*/
 f_flux =  kci * pow( f , 2.0 ) * C2 ;
 b_flux =  kic / pow( f , 2.0 ) * I2 ;
 _RHS1( 3) -= (f_flux - b_flux);
 _RHS1( 11) += (f_flux - b_flux);
 
 _term =  kci * pow( f , 2.0 ) ;
 _MATELM1( 3 ,3)  += _term;
 _MATELM1( 11 ,3)  -= _term;
 _term =  kic / pow( f , 2.0 ) ;
 _MATELM1( 3 ,11)  -= _term;
 _MATELM1( 11 ,11)  += _term;
 /*REACTION*/
  /* ~ C3 <-> I3 ( kci * f , kic / f )*/
 f_flux =  kci * f * C3 ;
 b_flux =  kic / f * I3 ;
 _RHS1( 2) -= (f_flux - b_flux);
 _RHS1( 10) += (f_flux - b_flux);
 
 _term =  kci * f ;
 _MATELM1( 2 ,2)  += _term;
 _MATELM1( 10 ,2)  -= _term;
 _term =  kic / f ;
 _MATELM1( 2 ,10)  -= _term;
 _MATELM1( 10 ,10)  += _term;
 /*REACTION*/
  /* ~ C4 <-> I4 ( kci , kic )*/
 f_flux =  kci * C4 ;
 b_flux =  kic * I4 ;
 _RHS1( 1) -= (f_flux - b_flux);
 _RHS1( 9) += (f_flux - b_flux);
 
 _term =  kci ;
 _MATELM1( 1 ,1)  += _term;
 _MATELM1( 9 ,1)  -= _term;
 _term =  kic ;
 _MATELM1( 1 ,9)  -= _term;
 _MATELM1( 9 ,9)  += _term;
 /*REACTION*/
  /* ~ C5 <-> I5 ( kci * g , kic / g )*/
 f_flux =  kci * g * C5 ;
 b_flux =  kic / g * I5 ;
 _RHS1( 6) += (f_flux - b_flux);
 
 _term =  kci * g ;
 _MATELM1( 6 ,0)  -= _term;
 _term =  kic / g ;
 _MATELM1( 6 ,6)  += _term;
 /*REACTION*/
  /* ~ C0 <-> C1 ( 4.0 * alpha , beta )*/
 f_flux =  4.0 * alpha * C0 ;
 b_flux =  beta * C1 ;
 _RHS1( 5) -= (f_flux - b_flux);
 _RHS1( 4) += (f_flux - b_flux);
 
 _term =  4.0 * alpha ;
 _MATELM1( 5 ,5)  += _term;
 _MATELM1( 4 ,5)  -= _term;
 _term =  beta ;
 _MATELM1( 5 ,4)  -= _term;
 _MATELM1( 4 ,4)  += _term;
 /*REACTION*/
  /* ~ C1 <-> C2 ( 3.0 * alpha , 2.0 * beta )*/
 f_flux =  3.0 * alpha * C1 ;
 b_flux =  2.0 * beta * C2 ;
 _RHS1( 4) -= (f_flux - b_flux);
 _RHS1( 3) += (f_flux - b_flux);
 
 _term =  3.0 * alpha ;
 _MATELM1( 4 ,4)  += _term;
 _MATELM1( 3 ,4)  -= _term;
 _term =  2.0 * beta ;
 _MATELM1( 4 ,3)  -= _term;
 _MATELM1( 3 ,3)  += _term;
 /*REACTION*/
  /* ~ C2 <-> C3 ( 2.0 * alpha , 3.0 * beta )*/
 f_flux =  2.0 * alpha * C2 ;
 b_flux =  3.0 * beta * C3 ;
 _RHS1( 3) -= (f_flux - b_flux);
 _RHS1( 2) += (f_flux - b_flux);
 
 _term =  2.0 * alpha ;
 _MATELM1( 3 ,3)  += _term;
 _MATELM1( 2 ,3)  -= _term;
 _term =  3.0 * beta ;
 _MATELM1( 3 ,2)  -= _term;
 _MATELM1( 2 ,2)  += _term;
 /*REACTION*/
  /* ~ C3 <-> C4 ( alpha , 4.0 * beta )*/
 f_flux =  alpha * C3 ;
 b_flux =  4.0 * beta * C4 ;
 _RHS1( 2) -= (f_flux - b_flux);
 _RHS1( 1) += (f_flux - b_flux);
 
 _term =  alpha ;
 _MATELM1( 2 ,2)  += _term;
 _MATELM1( 1 ,2)  -= _term;
 _term =  4.0 * beta ;
 _MATELM1( 2 ,1)  -= _term;
 _MATELM1( 1 ,1)  += _term;
 /*REACTION*/
  /* ~ C4 <-> C5 ( gamma , delta )*/
 f_flux =  gamma * C4 ;
 b_flux =  delta * C5 ;
 _RHS1( 1) -= (f_flux - b_flux);
 
 _term =  gamma ;
 _MATELM1( 1 ,1)  += _term;
 _term =  delta ;
 _MATELM1( 1 ,0)  -= _term;
 /*REACTION*/
  /* ~ C5 <-> O ( epsilon , phi )*/
 f_flux =  epsilon * C5 ;
 b_flux =  phi * O ;
 _RHS1( 14) += (f_flux - b_flux);
 
 _term =  epsilon ;
 _MATELM1( 14 ,0)  -= _term;
 _term =  phi ;
 _MATELM1( 14 ,14)  += _term;
 /*REACTION*/
  /* ~ O <-> IO1 ( kappa1 , lambda1 )*/
 f_flux =  kappa1 * O ;
 b_flux =  lambda1 * IO1 ;
 _RHS1( 14) -= (f_flux - b_flux);
 _RHS1( 8) += (f_flux - b_flux);
 
 _term =  kappa1 ;
 _MATELM1( 14 ,14)  += _term;
 _MATELM1( 8 ,14)  -= _term;
 _term =  lambda1 ;
 _MATELM1( 14 ,8)  -= _term;
 _MATELM1( 8 ,8)  += _term;
 /*REACTION*/
  /* ~ IO1 <-> IO2 ( kappa2 , lambda2 )*/
 f_flux =  kappa2 * IO1 ;
 b_flux =  lambda2 * IO2 ;
 _RHS1( 8) -= (f_flux - b_flux);
 _RHS1( 7) += (f_flux - b_flux);
 
 _term =  kappa2 ;
 _MATELM1( 8 ,8)  += _term;
 _MATELM1( 7 ,8)  -= _term;
 _term =  lambda2 ;
 _MATELM1( 8 ,7)  -= _term;
 _MATELM1( 7 ,7)  += _term;
 /*REACTION*/
   /* O + C0 + C1 + C2 + C3 + C4 + I0 + I1 + I2 + I3 + I4 + IO1 + IO2 + I5 + C5 = 1.0 */
 _RHS1(0) =  1.0;
 _MATELM1(0, 0) = 1;
 _RHS1(0) -= C5 ;
 _MATELM1(0, 6) = 1;
 _RHS1(0) -= I5 ;
 _MATELM1(0, 7) = 1;
 _RHS1(0) -= IO2 ;
 _MATELM1(0, 8) = 1;
 _RHS1(0) -= IO1 ;
 _MATELM1(0, 9) = 1;
 _RHS1(0) -= I4 ;
 _MATELM1(0, 10) = 1;
 _RHS1(0) -= I3 ;
 _MATELM1(0, 11) = 1;
 _RHS1(0) -= I2 ;
 _MATELM1(0, 12) = 1;
 _RHS1(0) -= I1 ;
 _MATELM1(0, 13) = 1;
 _RHS1(0) -= I0 ;
 _MATELM1(0, 1) = 1;
 _RHS1(0) -= C4 ;
 _MATELM1(0, 2) = 1;
 _RHS1(0) -= C3 ;
 _MATELM1(0, 3) = 1;
 _RHS1(0) -= C2 ;
 _MATELM1(0, 4) = 1;
 _RHS1(0) -= C1 ;
 _MATELM1(0, 5) = 1;
 _RHS1(0) -= C0 ;
 _MATELM1(0, 14) = 1;
 _RHS1(0) -= O ;
 /*CONSERVATION*/
   } return _reset;
 }
 
static int  rate ( _threadargsprotocomma_ double _lv ) {
   alpha = exponential ( _threadargscomma_ a0 , za , _lv , vshift ) ;
   beta = exponential ( _threadargscomma_ b0 , zb , _lv , vshift ) ;
   gamma = exponential ( _threadargscomma_ c0 , zc , _lv , vshift ) ;
   delta = exponential ( _threadargscomma_ d0 , zd , _lv , vshift ) ;
   epsilon = exponential ( _threadargscomma_ e0 , ze , _lv , vshift ) ;
   phi = exponential ( _threadargscomma_ f0 , zf , _lv , vshift ) ;
    return 0; }
 
static void _hoc_rate(void) {
  double _r;
   double* _p; Datum* _ppvar; Datum* _thread; _NrnThread* _nt;
   if (_extcall_prop) {_p = _extcall_prop->param; _ppvar = _extcall_prop->dparam;}else{ _p = (double*)0; _ppvar = (Datum*)0; }
  _thread = _extcall_thread;
  _nt = nrn_threads;
 _r = 1.;
 rate ( _p, _ppvar, _thread, _nt, *getarg(1) );
 hoc_retpushx(_r);
}
 
double exponential ( _threadargsprotocomma_ double _lA , double _lz , double _lv , double _lD ) {
   double _lexponential;
 _lexponential = _lA * exp ( _lz * ( _lv - _lD ) * FARADAY / ( R * ( celsius + 273.15 ) ) ) ;
   
return _lexponential;
 }
 
static void _hoc_exponential(void) {
  double _r;
   double* _p; Datum* _ppvar; Datum* _thread; _NrnThread* _nt;
   if (_extcall_prop) {_p = _extcall_prop->param; _ppvar = _extcall_prop->dparam;}else{ _p = (double*)0; _ppvar = (Datum*)0; }
  _thread = _extcall_thread;
  _nt = nrn_threads;
 _r =  exponential ( _p, _ppvar, _thread, _nt, *getarg(1) , *getarg(2) , *getarg(3) , *getarg(4) );
 hoc_retpushx(_r);
}
 
/*CVODE ode begin*/
 static int _ode_spec1(double* _p, Datum* _ppvar, Datum* _thread, _NrnThread* _nt) {int _reset=0;{
 double b_flux, f_flux, _term; int _i;
 {int _i; for(_i=0;_i<15;_i++) _p[_dlist1[_i]] = 0.0;}
 rate ( _threadargscomma_ v ) ;
 /* ~ I0 <-> I1 ( 4.0 * alpha / f , beta * f )*/
 f_flux =  4.0 * alpha / f * I0 ;
 b_flux =  beta * f * I1 ;
 DI0 -= (f_flux - b_flux);
 DI1 += (f_flux - b_flux);
 
 /*REACTION*/
  /* ~ I1 <-> I2 ( 3.0 * alpha / f , 2.0 * beta * f )*/
 f_flux =  3.0 * alpha / f * I1 ;
 b_flux =  2.0 * beta * f * I2 ;
 DI1 -= (f_flux - b_flux);
 DI2 += (f_flux - b_flux);
 
 /*REACTION*/
  /* ~ I2 <-> I3 ( 2.0 * alpha / f , 3.0 * beta * f )*/
 f_flux =  2.0 * alpha / f * I2 ;
 b_flux =  3.0 * beta * f * I3 ;
 DI2 -= (f_flux - b_flux);
 DI3 += (f_flux - b_flux);
 
 /*REACTION*/
  /* ~ I3 <-> I4 ( alpha / f , 4.0 * beta * f )*/
 f_flux =  alpha / f * I3 ;
 b_flux =  4.0 * beta * f * I4 ;
 DI3 -= (f_flux - b_flux);
 DI4 += (f_flux - b_flux);
 
 /*REACTION*/
  /* ~ I4 <-> I5 ( gamma * g , delta / g )*/
 f_flux =  gamma * g * I4 ;
 b_flux =  delta / g * I5 ;
 DI4 -= (f_flux - b_flux);
 DI5 += (f_flux - b_flux);
 
 /*REACTION*/
  /* ~ C0 <-> I0 ( kci * pow( f , 4.0 ) , kic / pow( f , 4.0 ) )*/
 f_flux =  kci * pow( f , 4.0 ) * C0 ;
 b_flux =  kic / pow( f , 4.0 ) * I0 ;
 DC0 -= (f_flux - b_flux);
 DI0 += (f_flux - b_flux);
 
 /*REACTION*/
  /* ~ C1 <-> I1 ( kci * pow( f , 3.0 ) , kic / pow( f , 3.0 ) )*/
 f_flux =  kci * pow( f , 3.0 ) * C1 ;
 b_flux =  kic / pow( f , 3.0 ) * I1 ;
 DC1 -= (f_flux - b_flux);
 DI1 += (f_flux - b_flux);
 
 /*REACTION*/
  /* ~ C2 <-> I2 ( kci * pow( f , 2.0 ) , kic / pow( f , 2.0 ) )*/
 f_flux =  kci * pow( f , 2.0 ) * C2 ;
 b_flux =  kic / pow( f , 2.0 ) * I2 ;
 DC2 -= (f_flux - b_flux);
 DI2 += (f_flux - b_flux);
 
 /*REACTION*/
  /* ~ C3 <-> I3 ( kci * f , kic / f )*/
 f_flux =  kci * f * C3 ;
 b_flux =  kic / f * I3 ;
 DC3 -= (f_flux - b_flux);
 DI3 += (f_flux - b_flux);
 
 /*REACTION*/
  /* ~ C4 <-> I4 ( kci , kic )*/
 f_flux =  kci * C4 ;
 b_flux =  kic * I4 ;
 DC4 -= (f_flux - b_flux);
 DI4 += (f_flux - b_flux);
 
 /*REACTION*/
  /* ~ C5 <-> I5 ( kci * g , kic / g )*/
 f_flux =  kci * g * C5 ;
 b_flux =  kic / g * I5 ;
 DC5 -= (f_flux - b_flux);
 DI5 += (f_flux - b_flux);
 
 /*REACTION*/
  /* ~ C0 <-> C1 ( 4.0 * alpha , beta )*/
 f_flux =  4.0 * alpha * C0 ;
 b_flux =  beta * C1 ;
 DC0 -= (f_flux - b_flux);
 DC1 += (f_flux - b_flux);
 
 /*REACTION*/
  /* ~ C1 <-> C2 ( 3.0 * alpha , 2.0 * beta )*/
 f_flux =  3.0 * alpha * C1 ;
 b_flux =  2.0 * beta * C2 ;
 DC1 -= (f_flux - b_flux);
 DC2 += (f_flux - b_flux);
 
 /*REACTION*/
  /* ~ C2 <-> C3 ( 2.0 * alpha , 3.0 * beta )*/
 f_flux =  2.0 * alpha * C2 ;
 b_flux =  3.0 * beta * C3 ;
 DC2 -= (f_flux - b_flux);
 DC3 += (f_flux - b_flux);
 
 /*REACTION*/
  /* ~ C3 <-> C4 ( alpha , 4.0 * beta )*/
 f_flux =  alpha * C3 ;
 b_flux =  4.0 * beta * C4 ;
 DC3 -= (f_flux - b_flux);
 DC4 += (f_flux - b_flux);
 
 /*REACTION*/
  /* ~ C4 <-> C5 ( gamma , delta )*/
 f_flux =  gamma * C4 ;
 b_flux =  delta * C5 ;
 DC4 -= (f_flux - b_flux);
 DC5 += (f_flux - b_flux);
 
 /*REACTION*/
  /* ~ C5 <-> O ( epsilon , phi )*/
 f_flux =  epsilon * C5 ;
 b_flux =  phi * O ;
 DC5 -= (f_flux - b_flux);
 DO += (f_flux - b_flux);
 
 /*REACTION*/
  /* ~ O <-> IO1 ( kappa1 , lambda1 )*/
 f_flux =  kappa1 * O ;
 b_flux =  lambda1 * IO1 ;
 DO -= (f_flux - b_flux);
 DIO1 += (f_flux - b_flux);
 
 /*REACTION*/
  /* ~ IO1 <-> IO2 ( kappa2 , lambda2 )*/
 f_flux =  kappa2 * IO1 ;
 b_flux =  lambda2 * IO2 ;
 DIO1 -= (f_flux - b_flux);
 DIO2 += (f_flux - b_flux);
 
 /*REACTION*/
   /* O + C0 + C1 + C2 + C3 + C4 + I0 + I1 + I2 + I3 + I4 + IO1 + IO2 + I5 + C5 = 1.0 */
 /*CONSERVATION*/
   } return _reset;
 }
 
/*CVODE matsol*/
 static int _ode_matsol1(void* _so, double* _rhs, double* _p, Datum* _ppvar, Datum* _thread, _NrnThread* _nt) {int _reset=0;{
 double b_flux, f_flux, _term; int _i;
   b_flux = f_flux = 0.;
 {int _i; double _dt1 = 1.0/dt;
for(_i=0;_i<15;_i++){
  	_RHS1(_i) = _dt1*(_p[_dlist1[_i]]);
	_MATELM1(_i, _i) = _dt1;
      
} }
 rate ( _threadargscomma_ v ) ;
 /* ~ I0 <-> I1 ( 4.0 * alpha / f , beta * f )*/
 _term =  4.0 * alpha / f ;
 _MATELM1( 13 ,13)  += _term;
 _MATELM1( 12 ,13)  -= _term;
 _term =  beta * f ;
 _MATELM1( 13 ,12)  -= _term;
 _MATELM1( 12 ,12)  += _term;
 /*REACTION*/
  /* ~ I1 <-> I2 ( 3.0 * alpha / f , 2.0 * beta * f )*/
 _term =  3.0 * alpha / f ;
 _MATELM1( 12 ,12)  += _term;
 _MATELM1( 11 ,12)  -= _term;
 _term =  2.0 * beta * f ;
 _MATELM1( 12 ,11)  -= _term;
 _MATELM1( 11 ,11)  += _term;
 /*REACTION*/
  /* ~ I2 <-> I3 ( 2.0 * alpha / f , 3.0 * beta * f )*/
 _term =  2.0 * alpha / f ;
 _MATELM1( 11 ,11)  += _term;
 _MATELM1( 10 ,11)  -= _term;
 _term =  3.0 * beta * f ;
 _MATELM1( 11 ,10)  -= _term;
 _MATELM1( 10 ,10)  += _term;
 /*REACTION*/
  /* ~ I3 <-> I4 ( alpha / f , 4.0 * beta * f )*/
 _term =  alpha / f ;
 _MATELM1( 10 ,10)  += _term;
 _MATELM1( 9 ,10)  -= _term;
 _term =  4.0 * beta * f ;
 _MATELM1( 10 ,9)  -= _term;
 _MATELM1( 9 ,9)  += _term;
 /*REACTION*/
  /* ~ I4 <-> I5 ( gamma * g , delta / g )*/
 _term =  gamma * g ;
 _MATELM1( 9 ,9)  += _term;
 _MATELM1( 6 ,9)  -= _term;
 _term =  delta / g ;
 _MATELM1( 9 ,6)  -= _term;
 _MATELM1( 6 ,6)  += _term;
 /*REACTION*/
  /* ~ C0 <-> I0 ( kci * pow( f , 4.0 ) , kic / pow( f , 4.0 ) )*/
 _term =  kci * pow( f , 4.0 ) ;
 _MATELM1( 5 ,5)  += _term;
 _MATELM1( 13 ,5)  -= _term;
 _term =  kic / pow( f , 4.0 ) ;
 _MATELM1( 5 ,13)  -= _term;
 _MATELM1( 13 ,13)  += _term;
 /*REACTION*/
  /* ~ C1 <-> I1 ( kci * pow( f , 3.0 ) , kic / pow( f , 3.0 ) )*/
 _term =  kci * pow( f , 3.0 ) ;
 _MATELM1( 4 ,4)  += _term;
 _MATELM1( 12 ,4)  -= _term;
 _term =  kic / pow( f , 3.0 ) ;
 _MATELM1( 4 ,12)  -= _term;
 _MATELM1( 12 ,12)  += _term;
 /*REACTION*/
  /* ~ C2 <-> I2 ( kci * pow( f , 2.0 ) , kic / pow( f , 2.0 ) )*/
 _term =  kci * pow( f , 2.0 ) ;
 _MATELM1( 3 ,3)  += _term;
 _MATELM1( 11 ,3)  -= _term;
 _term =  kic / pow( f , 2.0 ) ;
 _MATELM1( 3 ,11)  -= _term;
 _MATELM1( 11 ,11)  += _term;
 /*REACTION*/
  /* ~ C3 <-> I3 ( kci * f , kic / f )*/
 _term =  kci * f ;
 _MATELM1( 2 ,2)  += _term;
 _MATELM1( 10 ,2)  -= _term;
 _term =  kic / f ;
 _MATELM1( 2 ,10)  -= _term;
 _MATELM1( 10 ,10)  += _term;
 /*REACTION*/
  /* ~ C4 <-> I4 ( kci , kic )*/
 _term =  kci ;
 _MATELM1( 1 ,1)  += _term;
 _MATELM1( 9 ,1)  -= _term;
 _term =  kic ;
 _MATELM1( 1 ,9)  -= _term;
 _MATELM1( 9 ,9)  += _term;
 /*REACTION*/
  /* ~ C5 <-> I5 ( kci * g , kic / g )*/
 _term =  kci * g ;
 _MATELM1( 0 ,0)  += _term;
 _MATELM1( 6 ,0)  -= _term;
 _term =  kic / g ;
 _MATELM1( 0 ,6)  -= _term;
 _MATELM1( 6 ,6)  += _term;
 /*REACTION*/
  /* ~ C0 <-> C1 ( 4.0 * alpha , beta )*/
 _term =  4.0 * alpha ;
 _MATELM1( 5 ,5)  += _term;
 _MATELM1( 4 ,5)  -= _term;
 _term =  beta ;
 _MATELM1( 5 ,4)  -= _term;
 _MATELM1( 4 ,4)  += _term;
 /*REACTION*/
  /* ~ C1 <-> C2 ( 3.0 * alpha , 2.0 * beta )*/
 _term =  3.0 * alpha ;
 _MATELM1( 4 ,4)  += _term;
 _MATELM1( 3 ,4)  -= _term;
 _term =  2.0 * beta ;
 _MATELM1( 4 ,3)  -= _term;
 _MATELM1( 3 ,3)  += _term;
 /*REACTION*/
  /* ~ C2 <-> C3 ( 2.0 * alpha , 3.0 * beta )*/
 _term =  2.0 * alpha ;
 _MATELM1( 3 ,3)  += _term;
 _MATELM1( 2 ,3)  -= _term;
 _term =  3.0 * beta ;
 _MATELM1( 3 ,2)  -= _term;
 _MATELM1( 2 ,2)  += _term;
 /*REACTION*/
  /* ~ C3 <-> C4 ( alpha , 4.0 * beta )*/
 _term =  alpha ;
 _MATELM1( 2 ,2)  += _term;
 _MATELM1( 1 ,2)  -= _term;
 _term =  4.0 * beta ;
 _MATELM1( 2 ,1)  -= _term;
 _MATELM1( 1 ,1)  += _term;
 /*REACTION*/
  /* ~ C4 <-> C5 ( gamma , delta )*/
 _term =  gamma ;
 _MATELM1( 1 ,1)  += _term;
 _MATELM1( 0 ,1)  -= _term;
 _term =  delta ;
 _MATELM1( 1 ,0)  -= _term;
 _MATELM1( 0 ,0)  += _term;
 /*REACTION*/
  /* ~ C5 <-> O ( epsilon , phi )*/
 _term =  epsilon ;
 _MATELM1( 0 ,0)  += _term;
 _MATELM1( 14 ,0)  -= _term;
 _term =  phi ;
 _MATELM1( 0 ,14)  -= _term;
 _MATELM1( 14 ,14)  += _term;
 /*REACTION*/
  /* ~ O <-> IO1 ( kappa1 , lambda1 )*/
 _term =  kappa1 ;
 _MATELM1( 14 ,14)  += _term;
 _MATELM1( 8 ,14)  -= _term;
 _term =  lambda1 ;
 _MATELM1( 14 ,8)  -= _term;
 _MATELM1( 8 ,8)  += _term;
 /*REACTION*/
  /* ~ IO1 <-> IO2 ( kappa2 , lambda2 )*/
 _term =  kappa2 ;
 _MATELM1( 8 ,8)  += _term;
 _MATELM1( 7 ,8)  -= _term;
 _term =  lambda2 ;
 _MATELM1( 8 ,7)  -= _term;
 _MATELM1( 7 ,7)  += _term;
 /*REACTION*/
   /* O + C0 + C1 + C2 + C3 + C4 + I0 + I1 + I2 + I3 + I4 + IO1 + IO2 + I5 + C5 = 1.0 */
 /*CONSERVATION*/
   } return _reset;
 }
 
/*CVODE end*/
 
static int _ode_count(int _type){ return 15;}
 
static void _ode_spec(_NrnThread* _nt, _Memb_list* _ml, int _type) {
   double* _p; Datum* _ppvar; Datum* _thread;
   Node* _nd; double _v; int _iml, _cntml;
  _cntml = _ml->_nodecount;
  _thread = _ml->_thread;
  for (_iml = 0; _iml < _cntml; ++_iml) {
    _p = _ml->_data[_iml]; _ppvar = _ml->_pdata[_iml];
    _nd = _ml->_nodelist[_iml];
    v = NODEV(_nd);
  ek = _ion_ek;
     _ode_spec1 (_p, _ppvar, _thread, _nt);
  }}
 
static void _ode_map(int _ieq, double** _pv, double** _pvdot, double* _pp, Datum* _ppd, double* _atol, int _type) { 
	double* _p; Datum* _ppvar;
 	int _i; _p = _pp; _ppvar = _ppd;
	_cvode_ieq = _ieq;
	for (_i=0; _i < 15; ++_i) {
		_pv[_i] = _pp + _slist1[_i];  _pvdot[_i] = _pp + _dlist1[_i];
		_cvode_abstol(_atollist, _atol, _i);
	}
 }
 
static void _ode_matsol_instance1(_threadargsproto_) {
 _cvode_sparse_thread(&_thread[_cvspth1]._pvoid, 15, _dlist1, _p, _ode_matsol1, _ppvar, _thread, _nt);
 }
 
static void _ode_matsol(_NrnThread* _nt, _Memb_list* _ml, int _type) {
   double* _p; Datum* _ppvar; Datum* _thread;
   Node* _nd; double _v; int _iml, _cntml;
  _cntml = _ml->_nodecount;
  _thread = _ml->_thread;
  for (_iml = 0; _iml < _cntml; ++_iml) {
    _p = _ml->_data[_iml]; _ppvar = _ml->_pdata[_iml];
    _nd = _ml->_nodelist[_iml];
    v = NODEV(_nd);
  ek = _ion_ek;
 _ode_matsol_instance1(_threadargs_);
 }}
 
static void _thread_cleanup(Datum* _thread) {
   _nrn_destroy_sparseobj_thread(_thread[_spth1]._pvoid);
   _nrn_destroy_sparseobj_thread(_thread[_cvspth1]._pvoid);
 }
 extern void nrn_update_ion_pointer(Symbol*, Datum*, int, int);
 static void _update_ion_pointer(Datum* _ppvar) {
   nrn_update_ion_pointer(_k_sym, _ppvar, 0, 0);
   nrn_update_ion_pointer(_k_sym, _ppvar, 1, 3);
   nrn_update_ion_pointer(_k_sym, _ppvar, 2, 4);
 }

static void initmodel(double* _p, Datum* _ppvar, Datum* _thread, _NrnThread* _nt) {
  int _i; double _save;{
  C5 = C50;
  C4 = C40;
  C3 = C30;
  C2 = C20;
  C1 = C10;
  C0 = C00;
  I5 = I50;
  IO2 = IO20;
  IO1 = IO10;
  I4 = I40;
  I3 = I30;
  I2 = I20;
  I1 = I10;
  I0 = I00;
  O = O0;
 {
   rate ( _threadargscomma_ v ) ;
    _ss_sparse_thread(&_thread[_spth1]._pvoid, 15, _slist1, _dlist1, _p, &t, dt, kin, _linmat1, _ppvar, _thread, _nt);
     if (secondorder) {
    int _i;
    for (_i = 0; _i < 15; ++_i) {
      _p[_slist1[_i]] += dt*_p[_dlist1[_i]];
    }}
 }
 
}
}

static void nrn_init(_NrnThread* _nt, _Memb_list* _ml, int _type){
double* _p; Datum* _ppvar; Datum* _thread;
Node *_nd; double _v; int* _ni; int _iml, _cntml;
#if CACHEVEC
    _ni = _ml->_nodeindices;
#endif
_cntml = _ml->_nodecount;
_thread = _ml->_thread;
for (_iml = 0; _iml < _cntml; ++_iml) {
 _p = _ml->_data[_iml]; _ppvar = _ml->_pdata[_iml];
#if CACHEVEC
  if (use_cachevec) {
    _v = VEC_V(_ni[_iml]);
  }else
#endif
  {
    _nd = _ml->_nodelist[_iml];
    _v = NODEV(_nd);
  }
 v = _v;
  ek = _ion_ek;
 initmodel(_p, _ppvar, _thread, _nt);
 }
}

static double _nrn_current(double* _p, Datum* _ppvar, Datum* _thread, _NrnThread* _nt, double _v){double _current=0.;v=_v;{ {
   gk = gkbar * O ;
   ik = gk * ( v - ek ) ;
   }
 _current += ik;

} return _current;
}

static void nrn_cur(_NrnThread* _nt, _Memb_list* _ml, int _type) {
double* _p; Datum* _ppvar; Datum* _thread;
Node *_nd; int* _ni; double _rhs, _v; int _iml, _cntml;
#if CACHEVEC
    _ni = _ml->_nodeindices;
#endif
_cntml = _ml->_nodecount;
_thread = _ml->_thread;
for (_iml = 0; _iml < _cntml; ++_iml) {
 _p = _ml->_data[_iml]; _ppvar = _ml->_pdata[_iml];
#if CACHEVEC
  if (use_cachevec) {
    _v = VEC_V(_ni[_iml]);
  }else
#endif
  {
    _nd = _ml->_nodelist[_iml];
    _v = NODEV(_nd);
  }
  ek = _ion_ek;
 _g = _nrn_current(_p, _ppvar, _thread, _nt, _v + .001);
 	{ double _dik;
  _dik = ik;
 _rhs = _nrn_current(_p, _ppvar, _thread, _nt, _v);
  _ion_dikdv += (_dik - ik)/.001 ;
 	}
 _g = (_g - _rhs)/.001;
  _ion_ik += ik ;
#if CACHEVEC
  if (use_cachevec) {
	VEC_RHS(_ni[_iml]) -= _rhs;
  }else
#endif
  {
	NODERHS(_nd) -= _rhs;
  }
 
}
 
}

static void nrn_jacob(_NrnThread* _nt, _Memb_list* _ml, int _type) {
double* _p; Datum* _ppvar; Datum* _thread;
Node *_nd; int* _ni; int _iml, _cntml;
#if CACHEVEC
    _ni = _ml->_nodeindices;
#endif
_cntml = _ml->_nodecount;
_thread = _ml->_thread;
for (_iml = 0; _iml < _cntml; ++_iml) {
 _p = _ml->_data[_iml];
#if CACHEVEC
  if (use_cachevec) {
	VEC_D(_ni[_iml]) += _g;
  }else
#endif
  {
     _nd = _ml->_nodelist[_iml];
	NODED(_nd) += _g;
  }
 
}
 
}

static void nrn_state(_NrnThread* _nt, _Memb_list* _ml, int _type) {
double* _p; Datum* _ppvar; Datum* _thread;
Node *_nd; double _v = 0.0; int* _ni; int _iml, _cntml;
double _dtsav = dt;
if (secondorder) { dt *= 0.5; }
#if CACHEVEC
    _ni = _ml->_nodeindices;
#endif
_cntml = _ml->_nodecount;
_thread = _ml->_thread;
for (_iml = 0; _iml < _cntml; ++_iml) {
 _p = _ml->_data[_iml]; _ppvar = _ml->_pdata[_iml];
 _nd = _ml->_nodelist[_iml];
#if CACHEVEC
  if (use_cachevec) {
    _v = VEC_V(_ni[_iml]);
  }else
#endif
  {
    _nd = _ml->_nodelist[_iml];
    _v = NODEV(_nd);
  }
 v=_v;
{
  ek = _ion_ek;
 {  sparse_thread(&_thread[_spth1]._pvoid, 15, _slist1, _dlist1, _p, &t, dt, kin, _linmat1, _ppvar, _thread, _nt);
     if (secondorder) {
    int _i;
    for (_i = 0; _i < 15; ++_i) {
      _p[_slist1[_i]] += dt*_p[_dlist1[_i]];
    }}
 } }}
 dt = _dtsav;
}

static void terminal(){}

static void _initlists(){
 double _x; double* _p = &_x;
 int _i; static int _first = 1;
  if (!_first) return;
 _slist1[0] = &(C5) - _p;  _dlist1[0] = &(DC5) - _p;
 _slist1[1] = &(C4) - _p;  _dlist1[1] = &(DC4) - _p;
 _slist1[2] = &(C3) - _p;  _dlist1[2] = &(DC3) - _p;
 _slist1[3] = &(C2) - _p;  _dlist1[3] = &(DC2) - _p;
 _slist1[4] = &(C1) - _p;  _dlist1[4] = &(DC1) - _p;
 _slist1[5] = &(C0) - _p;  _dlist1[5] = &(DC0) - _p;
 _slist1[6] = &(I5) - _p;  _dlist1[6] = &(DI5) - _p;
 _slist1[7] = &(IO2) - _p;  _dlist1[7] = &(DIO2) - _p;
 _slist1[8] = &(IO1) - _p;  _dlist1[8] = &(DIO1) - _p;
 _slist1[9] = &(I4) - _p;  _dlist1[9] = &(DI4) - _p;
 _slist1[10] = &(I3) - _p;  _dlist1[10] = &(DI3) - _p;
 _slist1[11] = &(I2) - _p;  _dlist1[11] = &(DI2) - _p;
 _slist1[12] = &(I1) - _p;  _dlist1[12] = &(DI1) - _p;
 _slist1[13] = &(I0) - _p;  _dlist1[13] = &(DI0) - _p;
 _slist1[14] = &(O) - _p;  _dlist1[14] = &(DO) - _p;
_first = 0;
}

#if defined(__cplusplus)
} /* extern "C" */
#endif
