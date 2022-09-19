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
 
#define nrn_init _nrn_init__ichan3
#define _nrn_initial _nrn_initial__ichan3
#define nrn_cur _nrn_cur__ichan3
#define _nrn_current _nrn_current__ichan3
#define nrn_jacob _nrn_jacob__ichan3
#define nrn_state _nrn_state__ichan3
#define _net_receive _net_receive__ichan3 
#define states states__ichan3 
 
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
#define gnabar _p[0]
#define gkfbar _p[1]
#define gksbar _p[2]
#define gkabar _p[3]
#define ina _p[4]
#define ik _p[5]
#define gna _p[6]
#define gkf _p[7]
#define gks _p[8]
#define gka _p[9]
#define m _p[10]
#define n1 _p[11]
#define h _p[12]
#define n2 _p[13]
#define k _p[14]
#define l _p[15]
#define ena _p[16]
#define ek _p[17]
#define Dm _p[18]
#define Dn1 _p[19]
#define Dh _p[20]
#define Dn2 _p[21]
#define Dk _p[22]
#define Dl _p[23]
#define v _p[24]
#define _g _p[25]
#define _ion_ena	*_ppvar[0]._pval
#define _ion_ina	*_ppvar[1]._pval
#define _ion_dinadv	*_ppvar[2]._pval
#define _ion_ek	*_ppvar[3]._pval
#define _ion_ik	*_ppvar[4]._pval
#define _ion_dikdv	*_ppvar[5]._pval
 
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
 /* declaration of user functions */
 static void _hoc_al(void);
 static void _hoc_ak(void);
 static void _hoc_an2(void);
 static void _hoc_an1(void);
 static void _hoc_ah(void);
 static void _hoc_am(void);
 static void _hoc_bl(void);
 static void _hoc_bk(void);
 static void _hoc_bn2(void);
 static void _hoc_bn1(void);
 static void _hoc_bh(void);
 static void _hoc_bm(void);
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
 "setdata_ichan3", _hoc_setdata,
 "al_ichan3", _hoc_al,
 "ak_ichan3", _hoc_ak,
 "an2_ichan3", _hoc_an2,
 "an1_ichan3", _hoc_an1,
 "ah_ichan3", _hoc_ah,
 "am_ichan3", _hoc_am,
 "bl_ichan3", _hoc_bl,
 "bk_ichan3", _hoc_bk,
 "bn2_ichan3", _hoc_bn2,
 "bn1_ichan3", _hoc_bn1,
 "bh_ichan3", _hoc_bh,
 "bm_ichan3", _hoc_bm,
 0, 0
};
#define al al_ichan3
#define ak ak_ichan3
#define an2 an2_ichan3
#define an1 an1_ichan3
#define ah ah_ichan3
#define am am_ichan3
#define bl bl_ichan3
#define bk bk_ichan3
#define bn2 bn2_ichan3
#define bn1 bn1_ichan3
#define bh bh_ichan3
#define bm bm_ichan3
 extern double al( _threadargsprotocomma_ double );
 extern double ak( _threadargsprotocomma_ double );
 extern double an2( _threadargsprotocomma_ double );
 extern double an1( _threadargsprotocomma_ double );
 extern double ah( _threadargsprotocomma_ double );
 extern double am( _threadargsprotocomma_ double );
 extern double bl( _threadargsprotocomma_ double );
 extern double bk( _threadargsprotocomma_ double );
 extern double bn2( _threadargsprotocomma_ double );
 extern double bn1( _threadargsprotocomma_ double );
 extern double bh( _threadargsprotocomma_ double );
 extern double bm( _threadargsprotocomma_ double );
 /* declare global and static user variables */
#define vshiftna vshiftna_ichan3
 double vshiftna = 0;
#define vshiftks vshiftks_ichan3
 double vshiftks = 0;
#define vshiftak vshiftak_ichan3
 double vshiftak = 0;
 /* some parameters have upper and lower limits */
 static HocParmLimits _hoc_parm_limits[] = {
 0,0,0
};
 static HocParmUnits _hoc_parm_units[] = {
 "vshiftak_ichan3", "mV",
 "vshiftks_ichan3", "mV",
 "vshiftna_ichan3", "mV",
 "gnabar_ichan3", "S/cm2",
 "gkfbar_ichan3", "S/cm2",
 "gksbar_ichan3", "S/cm2",
 "gkabar_ichan3", "S/cm2",
 "ina_ichan3", "mA/cm2",
 "ik_ichan3", "mA/cm2",
 "gna_ichan3", "S/cm2",
 "gkf_ichan3", "S/cm2",
 "gks_ichan3", "S/cm2",
 "gka_ichan3", "S/cm2",
 0,0
};
 static double delta_t = 0.01;
 static double h0 = 0;
 static double k0 = 0;
 static double l0 = 0;
 static double m0 = 0;
 static double n20 = 0;
 static double n10 = 0;
 /* connect global user variables to hoc */
 static DoubScal hoc_scdoub[] = {
 "vshiftak_ichan3", &vshiftak_ichan3,
 "vshiftks_ichan3", &vshiftks_ichan3,
 "vshiftna_ichan3", &vshiftna_ichan3,
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
 
#define _cvode_ieq _ppvar[6]._i
 static void _ode_matsol_instance1(_threadargsproto_);
 /* connect range variables in _p that hoc is supposed to know about */
 static const char *_mechanism[] = {
 "6.2.0",
"ichan3",
 "gnabar_ichan3",
 "gkfbar_ichan3",
 "gksbar_ichan3",
 "gkabar_ichan3",
 0,
 "ina_ichan3",
 "ik_ichan3",
 "gna_ichan3",
 "gkf_ichan3",
 "gks_ichan3",
 "gka_ichan3",
 0,
 "m_ichan3",
 "n1_ichan3",
 "h_ichan3",
 "n2_ichan3",
 "k_ichan3",
 "l_ichan3",
 0,
 0};
 static Symbol* _na_sym;
 static Symbol* _k_sym;
 
extern Prop* need_memb(Symbol*);

static void nrn_alloc(Prop* _prop) {
	Prop *prop_ion;
	double *_p; Datum *_ppvar;
 	_p = nrn_prop_data_alloc(_mechtype, 26, _prop);
 	/*initialize range parameters*/
 	gnabar = 0;
 	gkfbar = 0;
 	gksbar = 0;
 	gkabar = 0;
 	_prop->param = _p;
 	_prop->param_size = 26;
 	_ppvar = nrn_prop_datum_alloc(_mechtype, 7, _prop);
 	_prop->dparam = _ppvar;
 	/*connect ionic variables to this model*/
 prop_ion = need_memb(_na_sym);
 nrn_promote(prop_ion, 0, 1);
 	_ppvar[0]._pval = &prop_ion->param[0]; /* ena */
 	_ppvar[1]._pval = &prop_ion->param[3]; /* ina */
 	_ppvar[2]._pval = &prop_ion->param[4]; /* _ion_dinadv */
 prop_ion = need_memb(_k_sym);
 nrn_promote(prop_ion, 0, 1);
 	_ppvar[3]._pval = &prop_ion->param[0]; /* ek */
 	_ppvar[4]._pval = &prop_ion->param[3]; /* ik */
 	_ppvar[5]._pval = &prop_ion->param[4]; /* _ion_dikdv */
 
}
 static void _initlists();
  /* some states have an absolute tolerance */
 static Symbol** _atollist;
 static HocStateTolerance _hoc_state_tol[] = {
 0,0
};
 static void _update_ion_pointer(Datum*);
 extern Symbol* hoc_lookup(const char*);
extern void _nrn_thread_reg(int, int, void(*)(Datum*));
extern void _nrn_thread_table_reg(int, void(*)(double*, Datum*, Datum*, _NrnThread*, int));
extern void hoc_register_tolerance(int, HocStateTolerance*, Symbol***);
extern void _cvode_abstol( Symbol**, double*, int);

 void _ichan3_reg() {
	int _vectorized = 1;
  _initlists();
 	ion_reg("na", -10000.);
 	ion_reg("k", -10000.);
 	_na_sym = hoc_lookup("na_ion");
 	_k_sym = hoc_lookup("k_ion");
 	register_mech(_mechanism, nrn_alloc,nrn_cur, nrn_jacob, nrn_state, nrn_init, hoc_nrnpointerindex, 1);
 _mechtype = nrn_get_mechtype(_mechanism[1]);
     _nrn_setdata_reg(_mechtype, _setdata);
     _nrn_thread_reg(_mechtype, 2, _update_ion_pointer);
  hoc_register_prop_size(_mechtype, 26, 7);
  hoc_register_dparam_semantics(_mechtype, 0, "na_ion");
  hoc_register_dparam_semantics(_mechtype, 1, "na_ion");
  hoc_register_dparam_semantics(_mechtype, 2, "na_ion");
  hoc_register_dparam_semantics(_mechtype, 3, "k_ion");
  hoc_register_dparam_semantics(_mechtype, 4, "k_ion");
  hoc_register_dparam_semantics(_mechtype, 5, "k_ion");
  hoc_register_dparam_semantics(_mechtype, 6, "cvodeieq");
 	hoc_register_cvode(_mechtype, _ode_count, _ode_map, _ode_spec, _ode_matsol);
 	hoc_register_tolerance(_mechtype, _hoc_state_tol, &_atollist);
 	hoc_register_var(hoc_scdoub, hoc_vdoub, hoc_intfunc);
 	ivoc_help("help ?1 ichan3 C:/Scan/lib_mech/ichan3.mod\n");
 hoc_register_limits(_mechtype, _hoc_parm_limits);
 hoc_register_units(_mechtype, _hoc_parm_units);
 }
static int _reset;
static char *modelname = "";

static int error;
static int _ninits = 0;
static int _match_recurse=1;
static void _modl_cleanup(){ _match_recurse=1;}
 
static int _ode_spec1(_threadargsproto_);
/*static int _ode_matsol1(_threadargsproto_);*/
 static int _slist1[6], _dlist1[6];
 static int states(_threadargsproto_);
 
/*CVODE*/
 static int _ode_spec1 (double* _p, Datum* _ppvar, Datum* _thread, _NrnThread* _nt) {int _reset = 0; {
   Dm = ( 1.0 - m ) * am ( _threadargscomma_ v ) - m * bm ( _threadargscomma_ v ) ;
   Dh = ( 1.0 - h ) * ah ( _threadargscomma_ v ) - h * bh ( _threadargscomma_ v ) ;
   Dn1 = ( 1.0 - n1 ) * an1 ( _threadargscomma_ v ) - n1 * bn1 ( _threadargscomma_ v ) ;
   Dn2 = ( 1.0 - n2 ) * an2 ( _threadargscomma_ v ) - n2 * bn2 ( _threadargscomma_ v ) ;
   Dk = ( 1.0 - k ) * ak ( _threadargscomma_ v ) - k * bk ( _threadargscomma_ v ) ;
   Dl = ( 1.0 - l ) * al ( _threadargscomma_ v ) - l * bl ( _threadargscomma_ v ) ;
   }
 return _reset;
}
 static int _ode_matsol1 (double* _p, Datum* _ppvar, Datum* _thread, _NrnThread* _nt) {
 Dm = Dm  / (1. - dt*( ( ( ( - 1.0 ) ) )*( am ( _threadargscomma_ v ) ) - ( 1.0 )*( bm ( _threadargscomma_ v ) ) )) ;
 Dh = Dh  / (1. - dt*( ( ( ( - 1.0 ) ) )*( ah ( _threadargscomma_ v ) ) - ( 1.0 )*( bh ( _threadargscomma_ v ) ) )) ;
 Dn1 = Dn1  / (1. - dt*( ( ( ( - 1.0 ) ) )*( an1 ( _threadargscomma_ v ) ) - ( 1.0 )*( bn1 ( _threadargscomma_ v ) ) )) ;
 Dn2 = Dn2  / (1. - dt*( ( ( ( - 1.0 ) ) )*( an2 ( _threadargscomma_ v ) ) - ( 1.0 )*( bn2 ( _threadargscomma_ v ) ) )) ;
 Dk = Dk  / (1. - dt*( ( ( ( - 1.0 ) ) )*( ak ( _threadargscomma_ v ) ) - ( 1.0 )*( bk ( _threadargscomma_ v ) ) )) ;
 Dl = Dl  / (1. - dt*( ( ( ( - 1.0 ) ) )*( al ( _threadargscomma_ v ) ) - ( 1.0 )*( bl ( _threadargscomma_ v ) ) )) ;
 return 0;
}
 /*END CVODE*/
 static int states (double* _p, Datum* _ppvar, Datum* _thread, _NrnThread* _nt) { {
    m = m + (1. - exp(dt*(( ( ( - 1.0 ) ) )*( am ( _threadargscomma_ v ) ) - ( 1.0 )*( bm ( _threadargscomma_ v ) ))))*(- ( ( ( 1.0 ) )*( am ( _threadargscomma_ v ) ) ) / ( ( ( ( - 1.0 ) ) )*( am ( _threadargscomma_ v ) ) - ( 1.0 )*( bm ( _threadargscomma_ v ) ) ) - m) ;
    h = h + (1. - exp(dt*(( ( ( - 1.0 ) ) )*( ah ( _threadargscomma_ v ) ) - ( 1.0 )*( bh ( _threadargscomma_ v ) ))))*(- ( ( ( 1.0 ) )*( ah ( _threadargscomma_ v ) ) ) / ( ( ( ( - 1.0 ) ) )*( ah ( _threadargscomma_ v ) ) - ( 1.0 )*( bh ( _threadargscomma_ v ) ) ) - h) ;
    n1 = n1 + (1. - exp(dt*(( ( ( - 1.0 ) ) )*( an1 ( _threadargscomma_ v ) ) - ( 1.0 )*( bn1 ( _threadargscomma_ v ) ))))*(- ( ( ( 1.0 ) )*( an1 ( _threadargscomma_ v ) ) ) / ( ( ( ( - 1.0 ) ) )*( an1 ( _threadargscomma_ v ) ) - ( 1.0 )*( bn1 ( _threadargscomma_ v ) ) ) - n1) ;
    n2 = n2 + (1. - exp(dt*(( ( ( - 1.0 ) ) )*( an2 ( _threadargscomma_ v ) ) - ( 1.0 )*( bn2 ( _threadargscomma_ v ) ))))*(- ( ( ( 1.0 ) )*( an2 ( _threadargscomma_ v ) ) ) / ( ( ( ( - 1.0 ) ) )*( an2 ( _threadargscomma_ v ) ) - ( 1.0 )*( bn2 ( _threadargscomma_ v ) ) ) - n2) ;
    k = k + (1. - exp(dt*(( ( ( - 1.0 ) ) )*( ak ( _threadargscomma_ v ) ) - ( 1.0 )*( bk ( _threadargscomma_ v ) ))))*(- ( ( ( 1.0 ) )*( ak ( _threadargscomma_ v ) ) ) / ( ( ( ( - 1.0 ) ) )*( ak ( _threadargscomma_ v ) ) - ( 1.0 )*( bk ( _threadargscomma_ v ) ) ) - k) ;
    l = l + (1. - exp(dt*(( ( ( - 1.0 ) ) )*( al ( _threadargscomma_ v ) ) - ( 1.0 )*( bl ( _threadargscomma_ v ) ))))*(- ( ( ( 1.0 ) )*( al ( _threadargscomma_ v ) ) ) / ( ( ( ( - 1.0 ) ) )*( al ( _threadargscomma_ v ) ) - ( 1.0 )*( bl ( _threadargscomma_ v ) ) ) - l) ;
   }
  return 0;
}
 
double am ( _threadargsprotocomma_ double _lVm ) {
   double _lam;
 double _lx ;
  _lx = 0.2 * ( _lVm - ( - 45.0 + vshiftna ) ) ;
   if ( fabs ( _lx ) > 1e-6 ) {
     _lam = 1.5 * _lx / ( 1.0 - exp ( - _lx ) ) ;
     }
   else {
     _lam = 1.5 / ( 1.0 + 0.5 * _lx ) ;
     }
    
return _lam;
 }
 
static void _hoc_am(void) {
  double _r;
   double* _p; Datum* _ppvar; Datum* _thread; _NrnThread* _nt;
   if (_extcall_prop) {_p = _extcall_prop->param; _ppvar = _extcall_prop->dparam;}else{ _p = (double*)0; _ppvar = (Datum*)0; }
  _thread = _extcall_thread;
  _nt = nrn_threads;
 _r =  am ( _p, _ppvar, _thread, _nt, *getarg(1) );
 hoc_retpushx(_r);
}
 
double bm ( _threadargsprotocomma_ double _lVm ) {
   double _lbm;
 double _lx ;
  _lx = - 0.2 * ( _lVm - ( - 17.0 + vshiftna ) ) ;
   if ( fabs ( _lx ) > 1e-6 ) {
     _lbm = 1.5 * _lx / ( 1.0 - exp ( - _lx ) ) ;
     }
   else {
     _lbm = 1.5 / ( 1.0 + 0.5 * _lx ) ;
     }
    
return _lbm;
 }
 
static void _hoc_bm(void) {
  double _r;
   double* _p; Datum* _ppvar; Datum* _thread; _NrnThread* _nt;
   if (_extcall_prop) {_p = _extcall_prop->param; _ppvar = _extcall_prop->dparam;}else{ _p = (double*)0; _ppvar = (Datum*)0; }
  _thread = _extcall_thread;
  _nt = nrn_threads;
 _r =  bm ( _p, _ppvar, _thread, _nt, *getarg(1) );
 hoc_retpushx(_r);
}
 
double ah ( _threadargsprotocomma_ double _lVm ) {
   double _lah;
  _lah = 0.23 * exp ( - 0.05 * ( _lVm - ( - 67.0 + vshiftna ) ) ) ;
    
return _lah;
 }
 
static void _hoc_ah(void) {
  double _r;
   double* _p; Datum* _ppvar; Datum* _thread; _NrnThread* _nt;
   if (_extcall_prop) {_p = _extcall_prop->param; _ppvar = _extcall_prop->dparam;}else{ _p = (double*)0; _ppvar = (Datum*)0; }
  _thread = _extcall_thread;
  _nt = nrn_threads;
 _r =  ah ( _p, _ppvar, _thread, _nt, *getarg(1) );
 hoc_retpushx(_r);
}
 
double bh ( _threadargsprotocomma_ double _lVm ) {
   double _lbh;
 double _lx ;
  _lx = - ( - 0.1 ) * ( ( - 14.5 + vshiftna ) - _lVm ) ;
   _lbh = 3.33 / ( 1.0 + exp ( _lx ) ) ;
    
return _lbh;
 }
 
static void _hoc_bh(void) {
  double _r;
   double* _p; Datum* _ppvar; Datum* _thread; _NrnThread* _nt;
   if (_extcall_prop) {_p = _extcall_prop->param; _ppvar = _extcall_prop->dparam;}else{ _p = (double*)0; _ppvar = (Datum*)0; }
  _thread = _extcall_thread;
  _nt = nrn_threads;
 _r =  bh ( _p, _ppvar, _thread, _nt, *getarg(1) );
 hoc_retpushx(_r);
}
 
double an1 ( _threadargsprotocomma_ double _lVm ) {
   double _lan1;
 double _lx ;
  _lx = 0.16667 * ( _lVm + 23.0 ) ;
   if ( fabs ( _lx ) > 1e-6 ) {
     _lan1 = 0.42 * _lx / ( 1.0 - exp ( - _lx ) ) ;
     }
   else {
     _lan1 = 0.42 / ( 1.0 + 0.5 * _lx ) ;
     }
    
return _lan1;
 }
 
static void _hoc_an1(void) {
  double _r;
   double* _p; Datum* _ppvar; Datum* _thread; _NrnThread* _nt;
   if (_extcall_prop) {_p = _extcall_prop->param; _ppvar = _extcall_prop->dparam;}else{ _p = (double*)0; _ppvar = (Datum*)0; }
  _thread = _extcall_thread;
  _nt = nrn_threads;
 _r =  an1 ( _p, _ppvar, _thread, _nt, *getarg(1) );
 hoc_retpushx(_r);
}
 
double bn1 ( _threadargsprotocomma_ double _lVm ) {
   double _lbn1;
  _lbn1 = 0.264 * exp ( - 0.025 * ( _lVm + 48.0 ) ) ;
    
return _lbn1;
 }
 
static void _hoc_bn1(void) {
  double _r;
   double* _p; Datum* _ppvar; Datum* _thread; _NrnThread* _nt;
   if (_extcall_prop) {_p = _extcall_prop->param; _ppvar = _extcall_prop->dparam;}else{ _p = (double*)0; _ppvar = (Datum*)0; }
  _thread = _extcall_thread;
  _nt = nrn_threads;
 _r =  bn1 ( _p, _ppvar, _thread, _nt, *getarg(1) );
 hoc_retpushx(_r);
}
 
double an2 ( _threadargsprotocomma_ double _lVm ) {
   double _lan2;
 double _lx ;
  _lx = 0.16667 * ( _lVm - ( - 35.0 + vshiftks ) ) ;
   if ( fabs ( _lx ) > 1e-6 ) {
     _lan2 = 0.168 * _lx / ( 1.0 - exp ( - _lx ) ) ;
     }
   else {
     _lan2 = 0.42 / ( 1.0 + 0.5 * _lx ) ;
     }
    
return _lan2;
 }
 
static void _hoc_an2(void) {
  double _r;
   double* _p; Datum* _ppvar; Datum* _thread; _NrnThread* _nt;
   if (_extcall_prop) {_p = _extcall_prop->param; _ppvar = _extcall_prop->dparam;}else{ _p = (double*)0; _ppvar = (Datum*)0; }
  _thread = _extcall_thread;
  _nt = nrn_threads;
 _r =  an2 ( _p, _ppvar, _thread, _nt, *getarg(1) );
 hoc_retpushx(_r);
}
 
double bn2 ( _threadargsprotocomma_ double _lVm ) {
   double _lbn2;
  _lbn2 = 0.1056 * exp ( - 0.025 * ( _lVm - ( - 60.0 + vshiftks ) ) ) ;
    
return _lbn2;
 }
 
static void _hoc_bn2(void) {
  double _r;
   double* _p; Datum* _ppvar; Datum* _thread; _NrnThread* _nt;
   if (_extcall_prop) {_p = _extcall_prop->param; _ppvar = _extcall_prop->dparam;}else{ _p = (double*)0; _ppvar = (Datum*)0; }
  _thread = _extcall_thread;
  _nt = nrn_threads;
 _r =  bn2 ( _p, _ppvar, _thread, _nt, *getarg(1) );
 hoc_retpushx(_r);
}
 
double ak ( _threadargsprotocomma_ double _lVm ) {
   double _lak;
 double _lx ;
  _lx = 0.066667 * ( _lVm - ( - 25.0 + vshiftak ) ) ;
   if ( fabs ( _lx ) > 1e-6 ) {
     _lak = 0.75 * _lx / ( 1.0 - exp ( - _lx ) ) ;
     }
   else {
     _lak = 0.75 / ( 1.0 + 0.5 * _lx ) ;
     }
    
return _lak;
 }
 
static void _hoc_ak(void) {
  double _r;
   double* _p; Datum* _ppvar; Datum* _thread; _NrnThread* _nt;
   if (_extcall_prop) {_p = _extcall_prop->param; _ppvar = _extcall_prop->dparam;}else{ _p = (double*)0; _ppvar = (Datum*)0; }
  _thread = _extcall_thread;
  _nt = nrn_threads;
 _r =  ak ( _p, _ppvar, _thread, _nt, *getarg(1) );
 hoc_retpushx(_r);
}
 
double bk ( _threadargsprotocomma_ double _lVm ) {
   double _lbk;
 double _lx ;
  _lx = - 0.125 * ( _lVm - ( - 15.0 + vshiftak ) ) ;
   if ( fabs ( _lx ) > 1e-6 ) {
     _lbk = 0.8 * _lx / ( 1.0 - exp ( - _lx ) ) ;
     }
   else {
     _lbk = 0.8 / ( 1.0 + 0.5 * _lx ) ;
     }
    
return _lbk;
 }
 
static void _hoc_bk(void) {
  double _r;
   double* _p; Datum* _ppvar; Datum* _thread; _NrnThread* _nt;
   if (_extcall_prop) {_p = _extcall_prop->param; _ppvar = _extcall_prop->dparam;}else{ _p = (double*)0; _ppvar = (Datum*)0; }
  _thread = _extcall_thread;
  _nt = nrn_threads;
 _r =  bk ( _p, _ppvar, _thread, _nt, *getarg(1) );
 hoc_retpushx(_r);
}
 
double al ( _threadargsprotocomma_ double _lVm ) {
   double _lal;
  _lal = 0.00015 * exp ( - 0.066667 * ( _lVm - ( - 13.0 + vshiftak ) ) ) ;
    
return _lal;
 }
 
static void _hoc_al(void) {
  double _r;
   double* _p; Datum* _ppvar; Datum* _thread; _NrnThread* _nt;
   if (_extcall_prop) {_p = _extcall_prop->param; _ppvar = _extcall_prop->dparam;}else{ _p = (double*)0; _ppvar = (Datum*)0; }
  _thread = _extcall_thread;
  _nt = nrn_threads;
 _r =  al ( _p, _ppvar, _thread, _nt, *getarg(1) );
 hoc_retpushx(_r);
}
 
double bl ( _threadargsprotocomma_ double _lVm ) {
   double _lbl;
  _lbl = 0.06 / ( 1.0 + exp ( - ( - 0.083333 ) * ( ( - 68.0 + vshiftak ) - _lVm ) ) ) ;
    
return _lbl;
 }
 
static void _hoc_bl(void) {
  double _r;
   double* _p; Datum* _ppvar; Datum* _thread; _NrnThread* _nt;
   if (_extcall_prop) {_p = _extcall_prop->param; _ppvar = _extcall_prop->dparam;}else{ _p = (double*)0; _ppvar = (Datum*)0; }
  _thread = _extcall_thread;
  _nt = nrn_threads;
 _r =  bl ( _p, _ppvar, _thread, _nt, *getarg(1) );
 hoc_retpushx(_r);
}
 
static int _ode_count(int _type){ return 6;}
 
static void _ode_spec(_NrnThread* _nt, _Memb_list* _ml, int _type) {
   double* _p; Datum* _ppvar; Datum* _thread;
   Node* _nd; double _v; int _iml, _cntml;
  _cntml = _ml->_nodecount;
  _thread = _ml->_thread;
  for (_iml = 0; _iml < _cntml; ++_iml) {
    _p = _ml->_data[_iml]; _ppvar = _ml->_pdata[_iml];
    _nd = _ml->_nodelist[_iml];
    v = NODEV(_nd);
  ena = _ion_ena;
  ek = _ion_ek;
     _ode_spec1 (_p, _ppvar, _thread, _nt);
   }}
 
static void _ode_map(int _ieq, double** _pv, double** _pvdot, double* _pp, Datum* _ppd, double* _atol, int _type) { 
	double* _p; Datum* _ppvar;
 	int _i; _p = _pp; _ppvar = _ppd;
	_cvode_ieq = _ieq;
	for (_i=0; _i < 6; ++_i) {
		_pv[_i] = _pp + _slist1[_i];  _pvdot[_i] = _pp + _dlist1[_i];
		_cvode_abstol(_atollist, _atol, _i);
	}
 }
 
static void _ode_matsol_instance1(_threadargsproto_) {
 _ode_matsol1 (_p, _ppvar, _thread, _nt);
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
  ena = _ion_ena;
  ek = _ion_ek;
 _ode_matsol_instance1(_threadargs_);
 }}
 extern void nrn_update_ion_pointer(Symbol*, Datum*, int, int);
 static void _update_ion_pointer(Datum* _ppvar) {
   nrn_update_ion_pointer(_na_sym, _ppvar, 0, 0);
   nrn_update_ion_pointer(_na_sym, _ppvar, 1, 3);
   nrn_update_ion_pointer(_na_sym, _ppvar, 2, 4);
   nrn_update_ion_pointer(_k_sym, _ppvar, 3, 0);
   nrn_update_ion_pointer(_k_sym, _ppvar, 4, 3);
   nrn_update_ion_pointer(_k_sym, _ppvar, 5, 4);
 }

static void initmodel(double* _p, Datum* _ppvar, Datum* _thread, _NrnThread* _nt) {
  int _i; double _save;{
  h = h0;
  k = k0;
  l = l0;
  m = m0;
  n2 = n20;
  n1 = n10;
 {
   m = am ( _threadargscomma_ v ) / ( am ( _threadargscomma_ v ) + bm ( _threadargscomma_ v ) ) ;
   h = ah ( _threadargscomma_ v ) / ( ah ( _threadargscomma_ v ) + bh ( _threadargscomma_ v ) ) ;
   n1 = an1 ( _threadargscomma_ v ) / ( an1 ( _threadargscomma_ v ) + bn1 ( _threadargscomma_ v ) ) ;
   n2 = an2 ( _threadargscomma_ v ) / ( an2 ( _threadargscomma_ v ) + bn2 ( _threadargscomma_ v ) ) ;
   k = ak ( _threadargscomma_ v ) / ( ak ( _threadargscomma_ v ) + bk ( _threadargscomma_ v ) ) ;
   l = al ( _threadargscomma_ v ) / ( al ( _threadargscomma_ v ) + bl ( _threadargscomma_ v ) ) ;
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
  ena = _ion_ena;
  ek = _ion_ek;
 initmodel(_p, _ppvar, _thread, _nt);
  }
}

static double _nrn_current(double* _p, Datum* _ppvar, Datum* _thread, _NrnThread* _nt, double _v){double _current=0.;v=_v;{ {
   gna = gnabar * pow( m , 3.0 ) * h ;
   gkf = gkfbar * pow( n1 , 4.0 ) ;
   gks = gksbar * pow( n2 , 4.0 ) ;
   gka = gkabar * k * l ;
   ina = gna * ( v - ena ) ;
   ik = ( gks + gka ) * ( v - ek ) ;
   }
 _current += ina;
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
  ena = _ion_ena;
  ek = _ion_ek;
 _g = _nrn_current(_p, _ppvar, _thread, _nt, _v + .001);
 	{ double _dik;
 double _dina;
  _dina = ina;
  _dik = ik;
 _rhs = _nrn_current(_p, _ppvar, _thread, _nt, _v);
  _ion_dinadv += (_dina - ina)/.001 ;
  _ion_dikdv += (_dik - ik)/.001 ;
 	}
 _g = (_g - _rhs)/.001;
  _ion_ina += ina ;
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
  ena = _ion_ena;
  ek = _ion_ek;
 {   states(_p, _ppvar, _thread, _nt);
  }  }}

}

static void terminal(){}

static void _initlists(){
 double _x; double* _p = &_x;
 int _i; static int _first = 1;
  if (!_first) return;
 _slist1[0] = &(m) - _p;  _dlist1[0] = &(Dm) - _p;
 _slist1[1] = &(h) - _p;  _dlist1[1] = &(Dh) - _p;
 _slist1[2] = &(n1) - _p;  _dlist1[2] = &(Dn1) - _p;
 _slist1[3] = &(n2) - _p;  _dlist1[3] = &(Dn2) - _p;
 _slist1[4] = &(k) - _p;  _dlist1[4] = &(Dk) - _p;
 _slist1[5] = &(l) - _p;  _dlist1[5] = &(Dl) - _p;
_first = 0;
}

#if defined(__cplusplus)
} /* extern "C" */
#endif
