* Project: 01. Evolución de la pobreza monetaria 2008-2019
* Author: Carlos Eduardo Torres Garcia 
* Email: carlo.eduardo749@gmail.com
* GitHub: CarloEduardo
* Last modified: Aug 2026
* INEI Report Link: https://www.inei.gob.pe/media/cifras_de_pobreza/informe_pobreza2019.pdf
********************************************************************************
cls
clear all
set more off

global Path    = "E:\01. DataBase\01. INEI\01. ENAHO" 
global Dataset = "E:\07. GitHub\03-Construccion-de-indicadores-a-partir-de-la-ENAHO\01. Evolución de la pobreza monetaria 2008-2019"

********************************************************************************
* Years:
********************************************************************************
* (2004/2005/2006/2007/2008/2009/2010/2011/2012/2013/2014/2015/2016/2017/2018/2019/2020/2021/2022/2023/2024/2025)	
mat ENAHO_YEARS = (280\281\282\283\284\285\279\291\324\404\440\498\546\603\634\687\737\759\784\906\966\1031)

********************************************************************************
* Modules:
********************************************************************************
* 1. Module	1 – Características de la Vivienda y del Hogar				
* 2. Module	2 – Características de los Miembros del Hogar				
* 3. Module	3 – Educación				
* 4. Module	4 – Salud				
* 5. Module	5 – Empleo e Ingresos				
* 6. Module	7 – Gastos en Alimentos y Bebidas (Módulo 601)				
* 7. Module	8 – Instituciones Beneficas				
* 8. Module	9 – Mantenimiento de la Vivienda				
* 9. Module	10 – Transportes y Comunicaciones				
*10. Module	11 – Servicios a la Vivienda				
*11. Module	12 – Esparcimiento , Diversion y Servicios de Cultura				
*12. Module	13 – Vestido y Calzado				
*13. Module	15 – Gastos de Transferencias				
*14. Module	16 – Muebles y Enseres				
*15. Module	17 – Otros Bienes y Servicios				
*16. Module	18 – Equipamiento del Hogar				
*17. Module	22 – Producción Agrícola				
*18. Module	23 – Subproductos Agricolas				
*19. Module	24 – Producción Forestal				
*20. Module	25 – Gastos en Actividades Agricolas y/o Forestales				
*21. Module	26 – Producción Pecuaria				
*22. Module	27 – Subproductos Pecuarios				
*23. Module	28 – Gastos en Actividades Pecuarias				
*24. Module	34 – Sumarias (Variables Calculadas)				
*25. Module	37 – Programas Sociales (Miembros del Hogar)				
*26. Module	77 – Ingresos del Trabajador Independiente				
*27. Module	78 – Bienes y Servicios de Cuidados Personales				
*28. Module	84 – Participación Ciudadana				
*29. Module	85 – Gobernabilidad, Democracia y Transparencia	
*30. Module	1825 – Beneficiarios de Instituciones sin fines de lucro: Olla Común
*31. Module	2081 – Crianza de Mascotas en el Hogar
*32. Module	2082 – Inseguridad Alimentaria

mat base_modules = (1,2,3,4,5,7,8,9,10,11,12,13,15,16,17,18,22,23,24,25,26,27,28,34,37,77,78,84,85,1825,2081,2082)
mat ENAHO_MODULES = J(22,32,.)
forvalues r = 1(1)22 {
    mat ENAHO_MODULES[`r',1] = base_modules
}

matlist ENAHO_YEARS
matlist ENAHO_MODULES

********************************************************************************
* Append modules
********************************************************************************
* Here you can choose the range of years you want to append
local y_start         = 4
local y_end           = 25

local y_start_minus_1 = `y_start' - 1

forvalues i = `y_start'(1)`y_end' {
    local year = 2000 + `i'
    local t    = `i' - `y_start_minus_1'
    
    *capture mkdir "$Dataset/`year'"
    *cd            "$Dataset/`year'"
    
    local survey_id = ENAHO_YEARS[`t',1]
    
	* Here you can choose which modules you want to append
	foreach j in 24 {        
        local survey_mod = ENAHO_MODULES[`t',`j']		
		
		*display "$Dataset/`year'/`survey_id'-Modulo`survey_mod'/sumaria-`year'.dta"
		
        if `i' == `y_start' {
            use "$Path/`year'/`survey_id'-Modulo`survey_mod'/sumaria-`year'.dta", clear
			rename a*o year	
        }
        else {
			preserve
				*append using "$Dataset/`year'/`survey_id'-Modulo`survey_mod'/sumaria-`year'.dta"
				use "$Path/`year'/`survey_id'-Modulo`survey_mod'/sumaria-`year'.dta", clear
				rename a*o year
				tempfile data_`year'
				save data_`year'.dta, replace
			restore
			append using "data_`year'.dta"
        }
    }
}

save "$Dataset/sumaria-2004-2025.dta", replace

/*******************************************************************************
mdesc
foreach x_var of varlist ingpeihd ingotrhd g01hd ig02hd1 ig02hd3 ig02hd2 ig03hd ig04hd gru35hd gru35hd1 gru35hd2 gru35hd3 gru52hd2 factor-sig28 {
    gen miss_`x_var' = missing(`x_var')
}

table year, c(sum miss_ingpeihd         sum miss_ingotrhd)
table year, c(sum miss_g01hd            sum miss_ig02hd1        sum miss_ig02hd3      sum miss_ig02hd2    sum miss_ig03hd)
table year, c(sum miss_ig04hd           sum miss_gru35hd        sum miss_gru35hd1     sum miss_gru35hd2   sum miss_gru35hd3)
table year, c(sum miss_gru52hd2)
table year, c(sum miss_factor           sum miss_ingtpu01       sum miss_ingtpu02     sum miss_ig02hd4    sum miss_ingtpu03) 
table year, c(sum miss_ingtpu04         sum miss_ld             sum miss_ingtpu05     sum miss_ig03hd1    sum miss_ig03hd2) 
table year, c(sum miss_ig03hd3          sum miss_ig03hd4        sum miss_estrsocial   sum miss_nconglome  sum miss_gashog21) 
table year, c(sum miss_gashog22         sum miss_gashog23       sum miss_gashog24     sum miss_gashog26   sum miss_gashog25) 
table year, c(sum miss_insedthd1        sum miss_paesechd1      sum miss_ingtrahd1    sum miss_ingtpuhd1  sum miss_ingtpu021) 
table year, c(sum miss_ingtpu06         sum miss_ingtpu061      sum miss_ingtpu07     sum miss_ingtpu071  sum miss_ingtpu08) 
table year, c(sum miss_ingtpu081        sum miss_ingtpu09       sum miss_ingtpu091    sum miss_inghog1d1  sum miss_inghog2d1) 
table year, c(sum miss_tipocuestionario sum miss_tipoentrevista sum miss_sub_conglome sum miss_lineav_rpl sum miss_lineav) 
table year, c(sum miss_pobrezav         sum miss_ingtpu01a      sum miss_ingtpu03a    sum miss_ingtpu10   sum miss_ingtpu11) 
table year, c(sum miss_ingtpu12         sum miss_ingtpu13a      sum miss_ingtpu14     sum miss_ingtpu15   sum miss_ingtpu13) 
table year, c(sum miss_ingtpu141        sum miss_ingtpu151      sum miss_gru51hd1     sum miss_gru52hd11  sum miss_gru53hd11) 
table year, c(sum miss_gru53hd21        sum miss_gru53hd31      sum miss_gru54hd1     sum miss_ingmo1hd1  sum miss_ingmo2hd1) 
table year, c(sum miss_ingtpu16         sum miss_sg27           sum miss_sig28)

preserve
	gen n=1
	collapse (sum) n miss_ingpeihd-miss_sig28, by(year)
	
	foreach x_var of varlist miss_ingpeihd-miss_sig28 {
		replace `x_var' = . if `x_var' == 0
}
	egen miss_mean = rowmean(miss_ingpeihd-miss_sig28)
	order year n miss_mean
	
	*export excel using "$Dataset\01-Missing-sumaria-2004-2025.xlsx", sheetmodify firstrow(variables) sheet("Missing")
restore

*******************************************************************************/

use "$Path/2019/687-Modulo34/Gasto2019/Bases/deflactores_base2019_new.dta", clear
save "$Dataset/deflactores-base2019-new.dta", replace

use "$Path/2019/687-Modulo34/Gasto2019/Bases/despacial_ldnew.dta", clear
save "$Dataset/despacial-ldnew-2019.dta", replace

********************************************************************************

use "$Dataset/sumaria-2004-2025.dta", clear

destring conglome, replace
tostring conglome, replace format(%06.0f)

recode gru52hd2-gashog2d (.= 0)
recode ingtpu01 ingtpu02 ingtpu03 ingtpu04 ingtpu05 ig03hd1 ig03hd2 ig03hd3 ig03hd4 (.= 0)

*Renombro la variable año
rename year año

gen aniorec = real(año)

keep if aniorec>=2008 & aniorec <=2019 

save "$Dataset/sumaria-2008-2019.dta", replace

*Genero variable departamento
gen dpto     = real(substr(ubigeo,1,2))
gen Regiones = real(substr(ubigeo,1,2))
replace dpto=15 if (dpto==7)
label define dpto 1"Amazonas"   2"Ancash"         3"Apurimac"     4"Arequipa"      5"Ayacucho" ///
                  6"Cajamarca"  7"Callao"         8"Cusco"        9"Huancavelica" 10"Huanuco" ///
				  11"Ica"      12"Junin"         13"La_Libertad" 14"Lambayeque"   15"Lima" ///
				  16"Loreto"   17"Madre_de_Dios" 18"Moquegua"    19"Pasco"        20"Piura" /// 
				  21"Puno"     22"San_Martin"    23"Tacna"       24"Tumbes"       25"Ucayali" 
lab val dpto dpto 
lab val Regiones dpto

sort aniorec dpto
merge m:1 aniorec dpto using "$Dataset/deflactores-base2019-new.dta"
tab _m
drop if _merge==2
drop _m

*Genero las variables de area de residencia, región natural y dominio geográfico
replace estrato = 1 if dominio ==8 
gen     area = estrato <6
replace area = 2 if area==0
label define area 2 "rural" 1 "urbana"
label val area area

gen     region=1 if dominio>=1 & dominio<=3 
replace region=1 if dominio==8
replace region=2 if dominio>=4 & dominio<=6 
replace region=3 if dominio==7 
label define region 1 "Costa" 2 "Sierra" 3 "Selva"
label values region region

gen     domin02 = 1 if dominio>=1 & dominio<=3 & area==1
replace domin02 = 2 if dominio>=1 & dominio<=3 & area==2
replace domin02 = 3 if dominio>=4 & dominio<=6 & area==1
replace domin02 = 4 if dominio>=4 & dominio<=6 & area==2
replace domin02 = 5 if dominio==7 & area==1
replace domin02 = 6 if dominio==7 & area==2
replace domin02 = 7 if dominio==8
label define domin02 1 "Costa_urbana" 2 "Costa_rural"  3 "Sierra_urbana" ///
                     4 "Sierra_rural" 5 "Selva_urbana" 6 "Selva_rural"   ///
					 7 "Lima_Metropolitana"
label value domin02 domin02

gen areag = dominio == 8
replace areag = 2 if dominio >= 1 & dominio <= 7 & estrato >= 1 & estrato <= 5
replace areag = 3 if dominio >= 1 & dominio <= 7 & estrato >= 6 & estrato <= 8
lab define areag 1 "Lima_Metro" 2 "Resto_Urbano" 3 "Rural" 
label values areag  areag

gen     dominioA =  1 if dominio==1 & area==1
replace dominioA =  2 if dominio==1 & area==2
replace dominioA =  3 if dominio==2 & area==1
replace dominioA =  4 if dominio==2 & area==2
replace dominioA =  5 if dominio==3 & area==1
replace dominioA =  6 if dominio==3 & area==2
replace dominioA =  7 if dominio==4 & area==1
replace dominioA =  8 if dominio==4 & area==2
replace dominioA =  9 if dominio==5 & area==1
replace dominioA = 10 if dominio==5 & area==2
replace dominioA = 11 if dominio==6 & area==1
replace dominioA = 12 if dominio==6 & area==2
replace dominioA = 13 if dominio==7 & area==1
replace dominioA = 14 if dominio==7 & area==2
replace dominioA = 15 if dominio==7 & (dpto==16 | dpto==17 | dpto==25) & area==1
replace dominioA = 16 if dominio==7 & (dpto==16 | dpto==17 | dpto==25) & area==2
replace dominioA = 17 if dominio==8 & area==1
replace dominioA = 17 if dominio==8 & area==2
label define dominioA  1 "Costa norte urbana"    2 "Costa norte rural"   /// 
                       3 "Costa centro urbana"   4 "Costa centro rural"  /// 
                       5 "Costa sur urbana"      6 "Costa sur rural"     ///	
                       7 "Sierra norte urbana"	 8 "Sierra norte rural"	 ///
                       9 "Sierra centro urbana" 10 "Sierra centro rural" /// 
                      11 "Sierra sur urbana"    12 "Sierra sur rural"    ///
                      13 "Selva alta urbana"	14 "Selva alta rural"    /// 
                      15 "Selva baja urbana"    16 "Selva baja rural"    ///
                      17 "Lima Metropolitana"
lab val dominioA dominioA 

drop ld
sort  dominioA
merge m:1 dominioA using "$Dataset/despacial-ldnew-2019.dta"

tab _m
drop _m

recode dpto (1=24) (2=10) (3=17)   (4=9)   (5=18)  (6=16)         (8=12) (9=19) (10=15) (11=6) (12=11) (13=3) ///
            (14=7) (15=1) (16=23) (17=20) (18=4)  (19=14) (20=8) (21=13) (22=22) (23=2) (24=5)  (24=5) (25=21), gen(recdpto)
label define recdpto  1 "Lima"       2 "Tacna"       3 "La Libertad" 4 "Moquega"       5 "Tumbes" /// 
                      6 "Ica"        7 "Lambayeque"  8 "Piura"       9 "Arequipa"     10 "Ancash" /// 
					 11"Junín"      12 "Cusco"      13 "Puno"       14 "Pasco"        15 "Huanuco" ///
                     16 "Cajamarca" 17 "Apurimac"   18 "Ayacucho"   19 "Huancavelica" 20 "Madre de Dios" ///
                     21 "Ucayali"   22 "San Martín" 23 "Loreto"     24 "Amazonas"
label val recdpto recdpto

gen     limareg = 1 if  (substr(ubigeo,1,4))=="1501"
replace limareg = 2 if  (substr(ubigeo,1,2))=="07"
replace limareg = 3 if ((substr(ubigeo,1,4))>="1502" & (substr(ubigeo,1,4))<"1599")
label define limareg 1 "Lima Prov" 2 "Prov Const. Callao" 3 "Región Lima"
label val limareg limareg

********************************************************************************
*                                GASTOS REALES                                 *
********************************************************************************
{
********************************************************************************
* CREANDO VARIABLES DEL GASTO DEFLACTADO A PRECIOS DE LIMA Y BASE 2018 a nivel total
********************************************************************************

* Gasto por 8  grupos de la canastas
************************************	
gen gpcrg3  = (gru11hd + gru12hd1 + gru12hd2 + gru13hd1 + gru13hd2 + gru13hd3)/(12*mieperho*ld*i01)
gen gpcrg6  = ((g05hd + g05hd1 + g05hd2 + g05hd3 + g05hd4 + g05hd5 + g05hd6 + ig06hd)/(12*mieperho*ld*i01))
gen gpcrg8  = ((sg23 + sig24)/(12*mieperho*ld*i01))
gen gpcrg9  = ((gru14hd + gru14hd1 + gru14hd2 + gru14hd3 + gru14hd4 + gru14hd5 + sg25 + sig26)/(12*mieperho*ld*i01))
gen gpcrg10 = ((gru21hd + gru22hd1 + gru22hd2 + gru23hd1 + gru23hd2 + gru23hd3 + gru24hd)/(12*mieperho*ld*i02))
gen gpcrg12 = ((gru31hd + gru32hd1 + gru32hd2 + gru33hd1 + gru33hd2 + gru33hd3 + gru34hd)/(12*mieperho*ld*i03))
gen gpcrg14 = ((gru41hd + gru42hd1 + gru42hd2 + gru43hd1 + gru43hd2 + gru43hd3 + gru44hd + sg421 + sg42d1 + sg423 + sg42d3)/(12*mieperho*ld*i04))
gen gpcrg16 = ((gru51hd + gru52hd1 + gru52hd2 + gru53hd1 + gru53hd2 + gru53hd3 + gru54hd)/(12*mieperho*ld*i05))
gen gpcrg18 = ((gru61hd + gru62hd1 + gru62hd2 + gru63hd1 + gru63hd2 + gru63hd3 + gru64hd + g07hd + ig08hd + sg422 + sg42d2)/(12*mieperho*ld*i06))
gen gpcrg19 = ((gru71hd + gru72hd1 + gru72hd2 + gru73hd1 + gru73hd2 + gru73hd3 + gru74hd + sg42 + sg42d)/(12*mieperho*ld*i07))
gen gpcrg21 = ((gru81hd + gru82hd1 + gru82hd2 + gru83hd1 + gru83hd2 + gru83hd3 + gru84hd)/(12*mieperho*ld*i08))

label var gpcrg3  "Preparados dentro del hogar"
label var gpcrg6  "Adquiridos Fuera del hogar 559"
label var gpcrg8  "Adquiridos de instituciones beneficas 602a "
label var gpcrg9  "Adquiridos fuera del hogar item 47 y 50 y 602"
label var gpcrg10 "Vestido y calzado"
label var gpcrg12 "Gasto Alquiler de vivienda y combustible"
label var gpcrg14 "Muebles y enseres"
label var gpcrg16 "Cuidados de la salud"
label var gpcrg18 "Transporte y comunicaciones"
label var gpcrg19 "Esparcimiento diversión y cultura"
label var gpcrg21 "Otros gastos de bienes y servicios"

* RECODIFICANDO POR grupo de gastos
***********************************
gen gpgru2  = gpcrg3
gen gpgru3  = gpcrg6 + gpcrg8 + gpcrg9
gen gpgru4  = gpcrg10
gen gpgru5  = gpcrg12
gen gpgru6  = gpcrg14
gen gpgru7  = gpcrg16
gen gpgru8  = gpcrg18
gen gpgru9  = gpcrg19
gen gpgru10 = gpcrg21 
gen gpgru1  = gpgru2 + gpgru3
gen gpgru0  = gpgru1 + gpgru4 + gpgru5 + gpgru6 + gpgru7 + gpgru8 + gpgru9 + gpgru10 

label var gpgru1  "G01. Total en Alimentos real"
label var gpgru2  "G011.Alimentos dentro del hogar real"
label var gpgru3  "G012.Alimentos fuera del hogar real"
label var gpgru4  "G02. Vestido y calzado real"
label var gpgru5  "G03. Alquiler de Vivienda y combustible real"
label var gpgru6  "G04. Muebles y enseres real"
label var gpgru7  "G05. Cuidados de la salud real"
label var gpgru8  "G06. Transportes y comunicaciones real"
label var gpgru9  "G07. Esparcimiento diversion y cultura real"
label var gpgru10 "G08. otros gastos en bienes y servicios real"

* TIPOS DE ADQUISICION DE GASTOS
********************************

gen gpcnr1 = (((gru11hd +gru14hd + sg23 + g05hd + g05hd1 + g05hd2 + g05hd3 + g05hd4 + g05hd5 + g05hd6 + sg25)/(12*mieperho * ld*i01)) + ///
			                    (gru21hd/(12*mieperho * ld*i02)) + ///
                                (gru31hd/(12*mieperho * ld*i03)) + ///
			  ((gru41hd + sg421 + sg423)/(12*mieperho * ld*i04)) + ///
                                (gru51hd/(12*mieperho * ld*i05)) + ///
			  ((gru61hd + g07hd + sg422)/(12*mieperho * ld*i06)) + ///
                       ((gru71hd + sg42)/(12*mieperho * ld*i07)) + ///
			                    (gru81hd/(12*mieperho * ld*i08)))

gen gpcnr2 = (((gru12hd1 + gru14hd1)/(12*mieperho * ld*i01)) + (gru22hd1/(12*mieperho * ld*i02)) + ///
                           (gru32hd1/(12*mieperho * ld*i03)) + (gru42hd1/(12*mieperho * ld*i04)) + ///
                           (gru52hd1/(12*mieperho * ld*i05)) + (gru62hd1/(12*mieperho * ld*i06)) + ///
                           (gru72hd1/(12*mieperho * ld*i07)) + (gru82hd1/(12*mieperho * ld*i08)))

gen gpcnr3 = (((gru12hd2 + gru14hd2)/(12*mieperho * ld*i01)) + (gru22hd2/(12*mieperho * ld*i02)) + ///
                           (gru32hd2/(12*mieperho * ld*i03)) + (gru42hd2/(12*mieperho * ld*i04)) + ///
                           (gru52hd2/(12*mieperho * ld*i05)) + (gru62hd2/(12*mieperho * ld*i06)) + ///
                           (gru72hd2/(12*mieperho * ld*i07)) + (gru82hd2/(12*mieperho * ld*i08)))

gen gpcnr4 = (((gru13hd1 + gru14hd3 + sig24 + sig26)/(12*mieperho * ld*i01)) + (gru23hd1/(12*mieperho * ld*i02)) + ///
                                           (gru33hd1/(12*mieperho * ld*i03)) + (gru43hd1/(12*mieperho * ld*i04)) + ///
                                           (gru53hd1/(12*mieperho * ld*i05)) + (gru63hd1/(12*mieperho * ld*i06)) + ///
                                           (gru73hd1/(12*mieperho * ld*i07)) + (gru83hd1/(12*mieperho * ld*i08)))

gen gpcnr5 = (((gru13hd2 + gru14hd4 + ig06hd)/(12*mieperho * ld*i01)) +                     (gru23hd2/(12*mieperho * ld*i02)) + ///
                                    (gru33hd2/(12*mieperho * ld*i03)) + ((gru43hd2 + sg42d1 + sg42d3)/(12*mieperho * ld*i04)) + ///
                                    (gru53hd2/(12*mieperho * ld*i05)) + ((gru63hd2 + ig08hd + sg42d2)/(12*mieperho * ld*i06)) + ///
                          ((gru73hd2 + sg42d)/(12*mieperho * ld*i07)) +                     (gru83hd2/(12*mieperho * ld*i08)))

gen gpcnr6 = (((gru13hd3 + gru14hd5)/(12*mieperho * ld*i01)) + (gru23hd3/(12*mieperho * ld*i02)) + ///
                           (gru33hd3/(12*mieperho * ld*i03)) + (gru43hd3/(12*mieperho * ld*i04)) + ///
                           (gru53hd3/(12*mieperho * ld*i05)) + (gru63hd3/(12*mieperho * ld*i06)) + ///
                           (gru73hd3/(12*mieperho * ld*i07)) + (gru83hd3/(12*mieperho * ld*i08)))

gen gpcnr7 = ((gru24hd/(12*mieperho * ld*i02)) + (gru34hd/(12*mieperho * ld*i03)) + ///
              (gru44hd/(12*mieperho * ld*i04)) + (gru54hd/(12*mieperho * ld*i05)) + ///
              (gru64hd/(12*mieperho * ld*i06)) + (gru74hd/(12*mieperho * ld*i07)) + ///
              (gru84hd/(12*mieperho * ld*i08)))

gen gpcnr0 = gpcnr1 + gpcnr2 + gpcnr3 + gpcnr4 + gpcnr5 + gpcnr6 + gpcnr7

label var gpcnr0 "gasto nueva metodologia"
label var gpcnr1 "Compra"
label var gpcnr2 "Autoconsumo"
label var gpcnr3 "Pago en especie"
label var gpcnr4 "gasto donaciones publicas"
label var gpcnr5 "gasto donaciones privadas"
label var gpcnr6 "gasto otro grupo"	
label var gpcnr7 "gasto imputado"

****************************************************
**************  POR  GRUPO  Y  TIPO  ***************
****************************************************
* Comprado
gen    gpctg1 = gpcnr1
gen    gpctg2 = (gru11hd + gru14hd + sg23 + g05hd + g05hd1 + g05hd2 + g05hd3 + g05hd4 + g05hd5 + g05hd6 + sg25)/(12*mieperho*ld*i01)
gen    gpctg3 =                 (gru21hd)/(12*mieperho*ld*i02)
gen    gpctg4 =                 (gru31hd)/(12*mieperho*ld*i03)
gen    gpctg5 = (gru41hd + sg421 + sg423)/(12*mieperho*ld*i04)
gen    gpctg6 =                 (gru51hd)/(12*mieperho*ld*i05)
gen    gpctg7 = (gru61hd + g07hd + sg422)/(12*mieperho*ld*i06)
gen    gpctg8 =          (gru71hd + sg42)/(12*mieperho*ld*i07)
gen    gpctg9 =                 (gru81hd)/(12*mieperho*ld*i08)
recode gpctg2 gpctg3 gpctg4 gpctg5 gpctg5 gpctg6 gpctg7 gpctg7 gpctg8 gpctg9(.=0)

*Autoconsumo (ajustado alquiler de vivienda)
gen gpctg10 = gpcnr2
gen gpctg11 = (gru12hd1 + gru14hd1)/(12*mieperho*ld*i01)
gen gpctg12 =            (gru22hd1)/(12*mieperho*ld*i02)
gen gpctg13 =            (gru32hd1)/(12*mieperho*ld*i03)
gen gpctg14 =            (gru42hd1)/(12*mieperho*ld*i04)
gen gpctg15 =            (gru52hd1)/(12*mieperho*ld*i05)
gen gpctg16 =            (gru62hd1)/(12*mieperho*ld*i06)
gen gpctg17 =            (gru72hd1)/(12*mieperho*ld*i07)
gen gpctg18 =            (gru82hd1)/(12*mieperho*ld*i08)

* Pago en especie
gen gpctg19 = gpcnr3
gen gpctg20 = (gru12hd2 + gru14hd2)/(12*mieperho*ld*i01)
gen gpctg21 =            (gru22hd2)/(12*mieperho*ld*i02)
gen gpctg22 =            (gru32hd2)/(12*mieperho*ld*i03)
gen gpctg23 =            (gru42hd2)/(12*mieperho*ld*i04)
gen gpctg24 =            (gru52hd2)/(12*mieperho*ld*i05)
gen gpctg25 =            (gru62hd2)/(12*mieperho*ld*i06)
gen gpctg26 =            (gru72hd2)/(12*mieperho*ld*i07)
gen gpctg27 =            (gru82hd2)/(12*mieperho*ld*i08)

* Donacion Pública
gen gpctg28 = gpcnr4
gen gpctg29 = (gru13hd1 + gru14hd3 + sig24 + sig26)/(12*mieperho*ld*i01)
gen gpctg30 =                            (gru23hd1)/(12*mieperho*ld*i02)
gen gpctg31 =                            (gru33hd1)/(12*mieperho*ld*i03)
gen gpctg32 =                            (gru43hd1)/(12*mieperho*ld*i04)
gen gpctg33 =                            (gru53hd1)/(12*mieperho*ld*i05)
gen gpctg34 =                            (gru63hd1)/(12*mieperho*ld*i06)
gen gpctg35 =                            (gru73hd1)/(12*mieperho*ld*i07)
gen gpctg36 =                            (gru83hd1)/(12*mieperho*ld*i08)

* Donación privada
gen gpctg37 = gpcnr5
gen gpctg38 = (gru13hd2 + gru14hd4 + ig06hd)/(12*mieperho*ld*i01)
gen gpctg39 =                     (gru23hd2)/(12*mieperho*ld*i02)
gen gpctg40 =                     (gru33hd2)/(12*mieperho*ld*i03)
gen gpctg41 =   (gru43hd2 + sg42d1 + sg42d3)/(12*mieperho*ld*i04)
gen gpctg42 =                     (gru53hd2)/(12*mieperho*ld*i05)
gen gpctg43 =   (gru63hd2 + ig08hd + sg42d2)/(12*mieperho*ld*i06)
gen gpctg44 =             (gru73hd2 + sg42d)/(12*mieperho*ld*i07)
gen gpctg45 =                     (gru83hd2)/(12*mieperho*ld*i08)

* Otro grupo
gen gpctg46 = gpcnr6
gen gpctg47 = (gru13hd3 + gru14hd5)/(12*mieperho*ld*i01)
gen gpctg48 =            (gru23hd3)/(12*mieperho*ld*i02)
gen gpctg49 =            (gru33hd3)/(12*mieperho*ld*i03)
gen gpctg50 =            (gru43hd3)/(12*mieperho*ld*i04)
gen gpctg51 =            (gru53hd3)/(12*mieperho*ld*i05)
gen gpctg52 =            (gru63hd3)/(12*mieperho*ld*i06)
gen gpctg53 =            (gru73hd3)/(12*mieperho*ld*i07)
gen gpctg54 =            (gru83hd3)/(12*mieperho*ld*i08)

* Imputado ajustado alquiler vivienda (gru34hd)
gen gpctg55 = gpcnr7
gen gpctg56 = (gru24hd)/(12*mieperho*ld*i02)

* Alquiler vivienda (gru34hd)
gen gpctg57 = (gru34hd)/(12*mieperho*ld*i03)
gen gpctg58 = (gru44hd)/(12*mieperho*ld*i04)
gen gpctg59 = (gru54hd)/(12*mieperho*ld*i05)
gen gpctg60 = (gru64hd)/(12*mieperho*ld*i06)
gen gpctg61 = (gru74hd)/(12*mieperho*ld*i07)
gen gpctg62 = (gru84hd)/(12*mieperho*ld*i08)

gen gpctg0 = gpctg1 + gpctg10 + gpctg19 + gpctg28 + gpctg37 + gpctg46 + gpctg55
}

********************************************************************************
*                                   INGRESOS                                   *
********************************************************************************
{
gen ipcr_2 =                       (ingbruhd + ingindhd)/(12*mieperho*ld*i00)
gen ipcr_3 =                       (insedthd + ingseihd)/(12*mieperho*ld*i00)
gen ipcr_4 = (pagesphd + paesechd + ingauthd + isecauhd)/(12*mieperho*ld*i00)
gen ipcr_5 =                                  (ingexthd)/(12*mieperho*ld*i00)
gen ipcr_1 = (ipcr_2 + ipcr_3 + ipcr_4 + ipcr_5)

gen ipcr_7 = (ingtrahd)/(12*mieperho*ld*i00)
gen ipcr_8 = (ingtexhd)/(12*mieperho*ld*i00)
gen ipcr_6 = (ipcr_7 + ipcr_8)

gen ipcr_9  = (ingtprhd)/(12*mieperho*ld*i00)
gen ipcr_10 = (ingtpuhd)/(12*mieperho*ld*i00)
gen ipcr_11 = (ingtpu01)/(12*mieperho*ld*i00)
gen ipcr_12 = (ingtpu03)/(12*mieperho*ld*i00)
gen ipcr_13 = (ingtpu05)/(12*mieperho*ld*i00)
gen ipcr_14 = (ingtpu04)/(12*mieperho*ld*i00)
gen ipcr_15 = (ingtpu02)/(12*mieperho*ld*i00)
gen ipcr_16 = (ingrenhd)/(12*mieperho*ld*i00)
gen ipcr_17 = (ingoexhd + gru13hd3 + gru23hd3 + gru33hd3 + gru43hd3 + gru53hd3 + gru63hd3 + gru73hd3 + /// 
               gru83hd3 + gru24hd + gru44hd + gru54hd + gru74hd + gru84hd + gru14hd5)/(12*mieperho*ld*i00)

* Ajuste por el alquiler imputado
gen ipcr_18 = (ia01hd + gru34hd - ga04hd + gru64hd)/(12*mieperho*ld*i00)

gen ipcr_19 = (gru13hd1 + sig24 + gru23hd1 + gru33hd1 + gru43hd1 + gru53hd1 + gru63hd1 + gru73hd1 + gru83hd1 + gru14hd3 + sig26)/(12*mieperho*ld*i00)

gen ipcr_20 = (gru13hd2 + ig06hd + gru23hd2 + gru33hd2 + gru43hd2 + gru53hd2 + gru63hd2 + ig08hd + gru73hd2 + gru83hd2 + gru14hd4 + sg42d + sg42d1 + sg42d2 + sg42d3)/(12*mieperho*ld*i00)

gen ipcr_0  = ipcr_2 + ipcr_3 + ipcr_4 + ipcr_5 + ipcr_7 + ipcr_8 + ipcr_16 + ipcr_17 + ipcr_18 + ipcr_19 + ipcr_20

label var ipcr_0  "Ingreso percapita mensual a precios de Lima monetario"
label var ipcr_1  "Ingreso percapita mensual a precios de Lima monetario por trabajo"
label var ipcr_2  "Ingreso percapita mensual a precios de Lima monetario por trabajo principal"
label var ipcr_3  "Ingreso percapita mensual a precios de Lima monetario por trabajo secundario"
label var ipcr_4  "Ingreso percapita mensual a precios de Lima pago en especie y autocon"
label var ipcr_5  "Ingreso percapita mensual a precios de Lima pago extraordinario por trabajo"
label var ipcr_6  "Ingreso percapita mensual a precios de Lima transferencia corriente"
label var ipcr_7  "Ingreso percapita mensual a precios de Lima transferencia monetaria del pais"
label var ipcr_8  "Ingreso percapita mensual a precios de Lima transferencia monetaria extranjero"
label var ipcr_9  "Ingreso percapita mensual a precios de Lima transferencia monetaria privada"
label var ipcr_10 "Ingreso percapita mensual a precios de Lima transferencia monetaria Publica total"
label var ipcr_11 "Ingreso percapita mensual a precios de Lima transferencia monetaria Publica Juntos"
label var ipcr_12 "Ingreso percapita mensual a precios de Lima transferencia monetaria Publica Pensión65"
label var ipcr_13 "Ingreso percapita mensual a precios de Lima transferencia monetaria Bono Gas"
label var ipcr_14 "Ingreso percapita mensual a precios de Lima transferencia monetaria Beca 18"
label var ipcr_15 "Ingreso percapita mensual a precios de Lima transferencia monetaria Otros Publica"
label var ipcr_16 "Ingreso percapita mensual a precios de Lima renta"
label var ipcr_17 "Ingreso percapita mensual a precios de Lima extraordinario"
label var ipcr_18 "Ingreso percapita mensual a precios de Lima alquiler imputado"
label var ipcr_19 "Ingreso percapita mensual a precios de Lima donacion publica"
label var ipcr_20 "Ingreso percapita mensual a precios de Lima donacion privada"
}

********************************************************************************
*                                    SALIDAS                                   *
********************************************************************************
* Cálculamos el factor de ponderación a nivel de la población
gen factornd07=round(factor07*mieperho,1)

svyset [pweight = factornd07], psu(conglome)strata(estrato)

*** Gasto real promedio percapita mensual***
svy:mean gpgru0, over(aniorec)
svy:mean gpgru0 if aniorec==2019, over(area)
svy:mean gpgru0 if aniorec==2019, over(domin02)
svy:mean gpgru0 if aniorec==2019, over(dpto)

*** Ingreso real promedio percapita mensual ***
svy:mean ipcr_0, over(aniorec)
svy:mean ipcr_0 if aniorec==2019, over(area)
svy:mean ipcr_0 if aniorec==2019, over(domin02)
svy:mean ipcr_0 if aniorec==2019, over(dpto)

save "$Dataset/sumaria-2008-2019-v1.dta", replace

{
*********************************** Nacional ***********************************
preserve
	* Nacional
	gen ambito = 1
	tempfile Nacional
	save `Nacional'
restore
preserve
	* Urbana
	keep if area == 1
	gen ambito = 2
	tempfile Urbana
	save `Urbana'
restore
preserve
	* Rural
	keep if area == 2
	gen ambito = 3
	tempfile Rural
	save `Rural'
restore
******************************** Región Natural ********************************
preserve
	* Costa
	keep if region == 1
	gen ambito = 4
	tempfile Costa
	save `Costa'
restore
preserve
	* Sierra
	keep if region == 2
	gen ambito = 5
	tempfile Sierra
	save `Sierra'
restore
preserve
	* Selva
	keep if region == 3
	gen ambito = 6
	tempfile Selva
	save `Selva'
restore
*********************************** Dominio ************************************
preserve
	* Costa_urbana
	keep if domin02 == 1
	gen ambito = 7
	tempfile Costa_urbana
	save `Costa_urbana'
restore
preserve
	* Costa_rural
	keep if domin02 == 2
	gen ambito = 8
	tempfile Costa_rural
	save `Costa_rural'
restore
preserve
	* Sierra_urbana
	keep if domin02 == 3
	gen ambito = 9
	tempfile Sierra_urbana
	save `Sierra_urbana'
restore

preserve
	* Sierra_rural
	keep if domin02 == 4
	gen ambito = 10
	tempfile Sierra_rural
	save `Sierra_rural'
restore
preserve
	* Selva_urbana
	keep if domin02 == 5
	gen ambito = 11
	tempfile Selva_urbana
	save `Selva_urbana'
restore
preserve
	* Selva_rural
	keep if domin02 == 6
	gen ambito = 12
	tempfile Selva_rural
	save `Selva_rural'
restore
preserve
	* Lima_Metropolitana
	keep if domin02 == 7
	gen ambito = 13
	tempfile Lima_Metropolitana
	save `Lima_Metropolitana'
restore

use    `Nacional', clear
append using `Urbana'
append using `Rural'
append using `Costa'
append using `Sierra'	
append using `Selva'
append using `Costa_urbana'	
append using `Costa_rural'	
append using `Sierra_urbana'	
append using `Sierra_rural'
append using `Selva_urbana'	
append using `Selva_rural'	
append using `Lima_Metropolitana'

label define ambito_lbl 1  "Nacional"      2 "Urbana"        3 "Rural" ///
                        4  "Costa"         5 "Sierra"        6 "Selva" ///
                        7  "Costa urbana"  8 "Costa rural"   9 "Sierra urbana" ///
                        10 "Sierra rural" 11 "Selva urbana" 12 "Selva rural" 13 "Lima Metropolitana"
label values ambito ambito_lbl
}
save "$Dataset/sumaria-2008-2019-v2.dta", replace

********************************************************************************
********************************************************************************
* I. EVOLUCIÓN DEL GASTO E INGRESO
********************************************************************************
********************************************************************************

* CUADRO N° 1.1
* PERÚ: EVOLUCIÓN DEL GASTO REAL PROMEDIO PER CÁPITA MENSUAL, SEGÚN ÁREA DE RESIDENCIA, REGIÓN NATURAL Y DOMINIOS GEOGRÁFICOS, 2008-2019
* (Soles constantes base=2019 a precios de Lima Metropolitana)
* Página 13
table ambito aniorec [pweight = factornd07], c(mean gpgru0) format(%9.0f)

fre ambito
keep if ambito==1

{
********************************************************************************
********************************************************************************
gen PCT_Perú_Gasto=.
gen PCT_Lima_Metropolitana_Gasto=.
label var PCT_Perú_Gasto               "10 quantiles of gpgru0, 2008-2019, Perú"
label var PCT_Lima_Metropolitana_Gasto "10 quantiles of gpgru0, 2008-2019, Lima Metropolitana"
forvalues i = 2008(1)2019 {
	xtile PCT_Perú_Gasto`i' = gpgru0 [fweight=factornd07] if aniorec==`i', nq(10) 
	replace PCT_Perú_Gasto = PCT_Perú_Gasto`i' if PCT_Perú_Gasto==. 
	drop  PCT_Perú_Gasto`i'

	xtile PCT_Lima_Metropolitana_Gasto`i' = gpgru0 [fweight=factornd07] if aniorec==`i' & domin02==7, nq(10) 
	replace PCT_Lima_Metropolitana_Gasto = PCT_Lima_Metropolitana_Gasto`i' if PCT_Lima_Metropolitana_Gasto==. 
	drop  PCT_Lima_Metropolitana_Gasto`i'
}
********************************************************************************
********************************************************************************
preserve
	replace PCT_Perú_Gasto = 0
	replace PCT_Lima_Metropolitana_Gasto = 0 if PCT_Lima_Metropolitana_Gasto!=.
	tempfile Nacional
	save `Nacional'
restore

append using `Nacional'

label define decil_gasto_lbl 0 "Nacional"      ///
                             1 "Decil 1" 2 "Decil 2" 3 "Decil 3" 4 "Decil 4"  5 "Decil 5" ///
                             6 "Decil 6" 7 "Decil 7" 8 "Decil 8" 9 "Decil 9" 10 "Decil 10" 
label values PCT_Perú_Gasto               decil_gasto_lbl
label values PCT_Lima_Metropolitana_Gasto decil_gasto_lbl
********************************************************************************
********************************************************************************
}

* CUADRO N° 1.2
* PERÚ: EVOLUCIÓN DEL GASTO REAL PROMEDIO PER CÁPITA MENSUAL, SEGÚN DECILES DE GASTO, 2008-2019
* (Soles constantes base=2019 a precios de Lima Metropolitana)
* Página 14
table PCT_Perú_Gasto aniorec [pweight = factornd07], c(mean gpgru0) format(%9.0f)

* CUADRO N° 1.3
* LIMA METROPOLITANA: GASTO REAL PROMEDIO PER CÁPITA MENSUAL, SEGÚN DECILES DE GASTO, 2008-2019
* (Soles constantes base=2019 a precios de Lima Metropolitana)
* Página 15
table PCT_Lima_Metropolitana_Gasto aniorec [pweight = factornd07] if PCT_Lima_Metropolitana_Gasto!=., c(mean gpgru0) format(%9.0f)

* CUADRO N° 1.4
* PERÚ: EVOLUCIÓN DEL GASTO REAL PROMEDIO PER CÁPITA MENSUAL, SEGÚN GRUPOS DE GASTO, 2008 – 2019
* (Soles constantes base=2019 a precios de Lima Metropolitana)
* Página 18

* CUADRO N° 1.5
* PERÚ: EVOLUCIÓN DEL INGRESO REAL PROMEDIO PER CÁPITA MENSUAL, SEGÚN ÁMBITOS Y DOMINIOS GEOGRÁFICOS, 2008 - 2019
* (Soles constantes base=2019 a precios de Lima Metropolitana)
* Página 23
use "$Dataset/sumaria-2008-2019-v2.dta", clear
table ambito aniorec [pweight = factornd07], c(mean ipcr_0) format(%9.0f)

fre ambito
keep if ambito==1

{
********************************************************************************
********************************************************************************
gen PCT_Perú_Ingreso=.
gen PCT_Lima_Metropolitana_Ingreso=.
label var PCT_Perú_Ingreso               "10 quantiles of ipcr_0, 2008-2019, Perú"
label var PCT_Lima_Metropolitana_Ingreso "10 quantiles of ipcr_0, 2008-2019, Lima Metropolitana"
forvalues i = 2008(1)2019 {
	xtile PCT_Perú_Ingreso`i' = ipcr_0 [fweight=factornd07] if aniorec==`i', nq(10) 
	replace PCT_Perú_Ingreso=PCT_Perú_Ingreso`i' if PCT_Perú_Ingreso==. 
	drop  PCT_Perú_Ingreso`i'

	xtile PCT_Lima_M_Ingreso`i' = ipcr_0 [fweight=factornd07] if aniorec==`i' & domin02==7, nq(10) 
	replace PCT_Lima_Metropolitana_Ingreso=PCT_Lima_M_Ingreso`i' if PCT_Lima_Metropolitana_Ingreso==. 
	drop  PCT_Lima_M_Ingreso`i'
}
********************************************************************************
********************************************************************************
preserve
	replace PCT_Perú_Ingreso = 0
	replace PCT_Lima_Metropolitana_Ingreso = 0 if PCT_Lima_Metropolitana_Ingreso!=.
	tempfile Nacional
	save `Nacional'
restore

append using `Nacional'

label define decil_ingreso_lbl 0 "Nacional" ///
                               1 "Decil 1" 2 "Decil 2" 3 "Decil 3" 4 "Decil 4"  5 "Decil 5"  ///
                               6 "Decil 6" 7 "Decil 7" 8 "Decil 8" 9 "Decil 9" 10 "Decil 10" 
label values PCT_Perú_Ingreso               decil_ingreso_lbl
label values PCT_Lima_Metropolitana_Ingreso decil_ingreso_lbl
********************************************************************************
********************************************************************************
}

* CUADRO N° 1.6
* PERÚ: EVOLUCIÓN DEL INGRESO PROMEDIO PER CÁPITA MENSUAL, SEGÚN DECILES DE INGRESO, 2008 - 2019
* (Soles constantes base=2019 a precios de Lima Metropolitana)
* Página 24
table PCT_Perú_Ingreso aniorec [pweight = factornd07], c(mean ipcr_0) format(%9.0f)

* CUADRO Nº 1.7
* LIMA METROPOLITANA: EVOLUCIÓN DEL INGRESO REAL PROMEDIO PER CÁPITA MENSUAL, SEGÚN DECILES DE INGRESO, 2008-2019
* (Soles constantes base=2019 a precios de Lima Metropolitana)
* Página 25
table PCT_Lima_Metropolitana_Ingreso aniorec [pweight = factornd07] if PCT_Lima_Metropolitana_Ingreso!=., c(mean ipcr_0) format(%9.0f)

fre PCT_Perú_Ingreso
keep if PCT_Perú_Ingreso==0

* CUADRO N° 1.8
* PERÚ: EVOLUCIÓN DEL INGRESO REAL PROMEDIO PER CÁPITA MENSUAL, SEGÚN TIPO DE INGRESO, 2008-2019
* (Soles constantes base=2019 a precios de Lima Metropolitana)
* Página 27
************ Nacional
table PCT_Perú_Ingreso aniorec [pweight = factornd07], c(mean ipcr_0) format(%9.0f)
************ Ingreso Monetario
table aniorec [pweight = factornd07], c(mean ipcr_1 mean ipcr_6 mean ipcr_16 mean ipcr_17) format(%9.0f)
* ipcr_1  // Trabajo
* ipcr_6  // Transferencias Corrientes 
* ipcr_16 // Renta 
* ipcr_17 // Ingreso Extraordinario 
************ Ingreso No Monetario
table aniorec [pweight = factornd07], c(mean ipcr_18 mean ipcr_19 mean ipcr_20) format(%9.0f)
* ipcr_18 // Alquiler Imputado 
* ipcr_19 // Ingreso Donación pública 
* ipcr_20 // Ingreso Donación Privada 

********************************************************************************
********************************************************************************
* II. EVOLUCIÓN DE LAS LÍNEAS DE POBREZA
********************************************************************************
********************************************************************************

* CUADRO N° 2.1
* PERÚ: EVOLUCIÓN DE LA LÍNEA DE POBREZA EXTREMA, SEGÚN ÁMBITO Y DOMINIOS GEOGRÁFICOS, 2008-2019 CANASTA BÁSICA DE ALIMENTOS PER CÁPITA MENSUAL
* (En soles)
* Página 32
use "$Dataset/sumaria-2008-2019-v2.dta", clear
table ambito aniorec [pweight = factornd07], c(mean linpe) format(%9.0f)

fre ambito
keep if ambito==1

* CUADRO N° 2.2
* PERÚ: EVOLUCIÓN DE LA LÍNEA DE POBREZA, SEGÚN ÁREA, ÁMBITO Y DOMINIOS GEOGRÁFICOS, 2008-2019
* (En soles)
* Página 35
table ambito aniorec [pweight = factornd07], c(mean linea) format(%9.0f)

********************************************************************************
********************************************************************************
* III. POBREZA MONETARIA
********************************************************************************
********************************************************************************

* CUADRO N° 3.1
* PERÚ: EVOLUCIÓN DE LA INCIDENCIA DE LA POBREZA MONETARIA TOTAL, SEGÚN ÁMBITO Y DOMINIOS GEOGRÁFICOS, 2008-2019
* (Porcentaje respecto del total de población)
* Página 39
recode pobreza (1 2 = 1 "Pobre") (3 = 0 "No pobre"), gen(pobre) label(pobre)
table ambito aniorec [pweight = factornd07], c(mean pobre) format(%9.3f)

* CUADRO Nº 3.2
* PERÚ: GRUPOS DE DEPARTAMENTOS CON NIVELES DE POBREZA MONETARIA ESTADÍSTICAMENTE SEMEJANTES,
* 2008 – 2019
* Página 42

* CUADRO Nº 3.3
* PERÚ: EVOLUCIÓN DE LA POBREZA EXTREMA, SEGÚN ÁMBITOS Y DOMINIOS GEOGRÁFICOS, 2008-2019
* (Porcentaje respecto del total de población)
* Página 46
recode pobreza (1 = 1 "Pobre extremo") (2 3 = 0 "Pobre y no pobre"), gen(pobre_extremo) label(pobre_extremo)
table ambito aniorec [pweight = factornd07], c(mean pobre_extremo) format(%9.3f)

* CUADRO Nº 3.4
* PERÚ: GRUPOS DE DEPARTAMENTOS CON NIVELES DE POBREZA EXTREMA ESTADÍSTICAMENTE SEMEJANTES, 2013 – 2019
* Página 49

* CUADRO Nº 3.5
* PERÚ: EVOLUCIÓN DE LA BRECHA DE LA POBREZA TOTAL, SEGÚN ÁMBITOS Y DOMINIOS GEOGRÁFICOS, 2008-2019
* (Porcentaje)
* Página 51
gen gpc = gashog2d / (mieperho * 12)
gen brecha = 0
replace brecha = (linea - gpc) / linea if gpc < linea
table ambito aniorec [pweight = factornd07], c(mean brecha) format(%9.3f)

* CUADRO Nº 3.6
* PERÚ: EVOLUCIÓN DE LA SEVERIDAD DE LA POBREZA, SEGÚN ÁMBITOS Y DOMINIOS GEOGRÁFICOS, 2008 - 2019
* (Porcentaje)
* Página 53
gen severidad = 0
replace severidad = ((linea - gpc) / linea)^2 if gpc < linea
table ambito aniorec [pweight = factornd07], c(mean severidad) format(%9.3f)

********************************************************************************
* IV. PERFIL DE LA POBREZA
********************************************************************************

use "$Dataset/sumaria-2008-2019-v2.dta", clear
table ambito aniorec [pweight = factornd07], c(mean linpe) format(%9.0f)

fre ambito
keep if ambito==1 | ambito==2 | ambito==3

* CUADRO Nº 4.1
* PERÚ: EVOLUCIÓN DE LA INCIDENCIA DE LA POBREZA, SEGÚN GRUPOS DE EDAD Y ÁREA DE RESIDENCIA, 2008-2019
* (Porcentaje)
* Página 57

* CUADRO Nº 4.2
* PERÚ: EVOLUCIÓN DE LA INCIDENCIA DE LA POBREZA SEGÚN LENGUA MATERNA Y ÁREA DE RESIDENCIA, 2008 - 2019
* (Porcentaje respecto del total de población de cada lengua materna)
* Página 59

* CUADRO Nº 4.3
* PERÚ: LOCALIZACIÓN TERRITORIAL DE LA POBLACIÓN POBRE, SEGÚN ÁREA DE RESIDENCIA, 2008 - 2019
* (Porcentual)
* Página 61

* CUADRO Nº 4.4
* PERÚ: EVOLUCIÓN DEL NIVEL DE EDUCACIÓN ALCANZADO POR LA POBLACIÓN DE 15 Y MÁS AÑOS DE EDAD, SEGÚN CONDICIÓN DE POBREZA, 2008 - 2019
* (Porcentaje)
* Página 62

* CUADRO Nº 4.5
* PERÚ: PROMEDIO DE AÑOS DE ESTUDIOS DE LA POBLACIÓN DE 25 Y MÁS AÑOS DE EDAD, SEGÚN CONDICIÓN DE POBREZA Y ÁREA DE RESIDENCIA, 2008 - 2019
* (Años de estudio)
* Página 64

* CUADRO Nº 4.6
* PERÚ: EVOLUCIÓN DE LA TASA NETA DE ASISTENCIA ESCOLAR, SEGÚN CONDICIÓN DE POBREZA, 2008 - 2019
* (Porcentaje)
* Página 68

* CUADRO Nº 4.7
* PERÚ: EVOLUCIÓN DE LA TASA DE ANALFABETISMO, SEGÚN CONDICIÓN DE POBREZA Y ÁREA DE RESIDENCIA, 2008-2019
* (Porcentaje respecto del total de población de 15 y más años de edad)
* Página 6.9

* CUADRO Nº 4.8
* PERÚ: EVOLUCIÓN DE LA TENENCIA DE SEGURO DE SALUD, SEGÚN CONDICIÓN DE POBREZA Y TIPO DE SEGURO, 2008 - 2019
* (Porcentaje)
* Página 71

* CUADRO Nº 4.9
* PERÚ: EVOLUCIÓN DE LA TASA DE ACTIVIDAD ECONÓMICA SEGÚN CONDICIÓN DE POBREZA, 2008- 2019
* (Porcentaje respecto del total de población de 14 y más años de edad)
* Página 72

* CUADRO Nº 4.10
* PERÚ: POBLACIÓN ECONÓMICAMENTE ACTIVA OCUPADA, SEGÚN TAMAÑO DE EMPRESA Y CONDICIÓN DE POBREZA, 2009-2019
* (Porcentaje)
* Página 73

* CUADRO Nº 4.11
* PERÚ: EVOLUCIÓN DE LA POBLACIÓN ECONÓMICAMENTE ACTIVA OCUPADA, SEGÚN CONDICIÓN DE POBREZA Y CATEGORÍA DE OCUPACIÓN, 2008-2019
* (Porcentaje)
* Página 74

* CUADRO Nº 4.12
* PERÚ: EVOLUCIÓN DE LA POBLACIÓN ECONÓMICAMENTE ACTIVA OCUPADA, SEGÚN RAMAS DE ACTIVIDAD Y CONDICIÓN DE POBREZA, 2008-2019
* (Porcentaje)
* Página 75

* CUADRO Nº 4.13
* PERÚ: COMPOSICIÓN DE LOS HOGARES SEGÚN EDAD DE LOS MIEMBROS Y CONDICIÓN DE POBREZA, 2008 -2019
* (Porcentaje)
* Página 77

* CUADRO Nº 4.14
* PERÚ: EVOLUCIÓN DE HOGARES CON AL MENOS UN ADULTO MAYOR ENTRE SUS MIEMBROS, SEGÚN CONDICIÓN DE POBREZA 2008-2019
* (Porcentaje)
* Página 79

* CUADRO Nº 4.15
* PERÚ: HOGARES CON ALGÚN MIEMBRO DISCAPACITADO, SEGÚN CONDICIÓN DE POBREZA, 2014 - 2019
* (Porcentaje)
* Página 80

* CUADRO Nº 4.16
* PERÚ: EDAD PROMEDIO DEL JEFE DE HOGAR, SEGÚN CONDICIÓN DE POBREZA Y ÁREA DE RESIDENCIA, 2008- 2019
* (Años)
* Página 81

* CUADRO Nº 4.17
* PERÚ: EVOLUCIÓN DEL PROMEDIO DE MIEMBROS DEL HOGAR, SEGÚN CONDICIÓN DE POBREZA Y ÁREA DE RESIDENCIA, 2008 - 2019
* (Número de personas)
* Página 82

* CUADRO Nº 4.18
* PERÚ: JEFATURA DE HOGAR, SEGÚN CONDICIÓN DE POBREZA Y SEXO, 2008-2019
* (Porcentaje)
* Página 83

* CUADRO Nº 4.19
* PERÚ: MATERIAL PREDOMINANTE EN PAREDES EXTERIORES DE LA VIVIENDA, SEGÚN CONDICIÓN DE POBREZA, 2008-2019
* (Porcentaje)
* Página 84

* CUADRO Nº 4.20
* PERÚ: MATERIAL PREDOMINANTE EN EL PISO DE LA VIVIENDA, SEGÚN CONDICIÓN DE POBREZA, 2008-2019
* (Porcentaje)
* Página 85

* CUADRO Nº 4.21
* PERÚ: EVOLUCIÓN DE LAS FORMAS DE ABASTECIMIENTO DE AGUA PARA CONSUMO HUMANO, SEGÚN CONDICIÓN DE POBREZA, 2008-2019
* (Porcentaje)
* Página 87

* CUADRO Nº 4.22
* PERÚ: EVOLUCIÓN DE LAS FORMAS DE ELIMINACIÓN DE EXCRETAS, SEGÚN CONDICIÓN DE POBREZA, 2012-2019
* (Porcentaje)
* Página 89

* CUADRO Nº 4.23
* PERÚ: EVOLUCIÓN DEL TIPO DE ALUMBRADO QUE UTILIZAN LOS HOGARES SEGÚN CONDICIÓN DE POBREZA, 2008-2019
* (Porcentaje)
* Página 90

* CUADRO Nº 4.24
* PERÚ: EVOLUCIÓN DE LOS HOGARES CON ACCESO A LAS TECNOLOGÍAS DE INFORMACIÓN Y COMUNICACIONES, SEGÚN CONDICIÓN DE POBREZA, 2008-2019
* (Porcentaje)
* Página 92

* CUADRO Nº 4.25
* PERÚ: EVOLUCIÓN DEL TIPO DE COMBUSTIBLE QUE USAN LOS HOGARES PARA COCINAR LOS ALIMENTOS, SEGÚN CONDICIÓN DE POBREZA, 2008-2019
* (Porcentaje)
* Página 93

*** fin ***
*** fin ***
*** fin ***
*** fin ***
*** fin ***


