* Tema: Caracterizar a la PEA que gana 3,000 o menos al mes
* Elaboracion: Carlos Torres 
********************************************************************************
clear all
set more off

global Fuente           = "G:\Mi unidad\00. Bases\01. ENAHO"

global Vivienda_hogar   = "01 Características de la Vivienda y del Hogar"
global Miembros_hogar   = "02 Características de los Miembros del Hogar"
global Educación        = "03 Educación"
global Salud            = "04 Salud"
global Empleo_ingresos  = "05 Empleo e Ingresos"
global Sumarias         = "34 Sumarias (Variables Calculadas)"
global Deflactores      = "34 Sumarias (Variables Calculadas)\ConstVarGasto-Metodologia actualizada"

global Consultoria_3    = "G:\Mi unidad\10. Job\03. CONSULTORIAS\03. ENAHO"

********************************************************************************

* Quiero agarrar un grupo de personas y caracterizarlo lo más que se puede.
* El grupo es: PEA que gana 3,000 o menos al mes. 

* Quisiera saber:
* - Qué porcentaje de la PEA gana 3,000 soles o menos al mes (y también en número de personas)
* - Cuáles son las ocupaciones más presentes acá (p.e. obreros, seguridad, limpieza , ...?)
* - Carga familiar (número de hijos + otras cargas)
* - Género
* - Nivel de estudios
* - Región donde vive
* - Tipo de empresa en que trabaja
* - Otras variables que consideres útiles

********************************************************************************
/*
local x = 2019
local y = 2020 
local z = 2021
		use "$Fuente\\`x'\\$Vivienda_hogar\enaho01-`x'-100.dta", clear
		append using "$Fuente\\`y'\\$Vivienda_hogar\enaho01-`y'-100.dta"
		append using "$Fuente\\`z'\\$Vivienda_hogar\enaho01-`z'-100.dta"
		rename a*o año
		save "$Consultoria_3\enaho01-`x'-`z'-100.dta", replace

		use "$Fuente\\`x'\\$Miembros_hogar\enaho01-`x'-200.dta", clear
		append using "$Fuente\\`y'\\$Miembros_hogar\enaho01-`y'-200.dta", force
		append using "$Fuente\\`z'\\$Miembros_hogar\enaho01-`z'-200.dta"
		rename a*o año		
		save "$Consultoria_3\enaho01-`x'-`z'-200.dta", replace
		
		use "$Fuente\\`x'\\$Salud\enaho01a-`x'-400.dta"
		append using "$Fuente\\`y'\\$Salud\enaho01a-`y'-400.dta"
		append using "$Fuente\\`z'\\$Salud\enaho01a-`z'-400.dta"
		rename a*o año		
		save "$Consultoria_3\enaho01a-`x'-`z'-400.dta", replace

		use "$Fuente\\`x'\\$Empleo_ingresos\enaho01a-`x'-500.dta", clear
		append using "$Fuente\\`y'\\$Empleo_ingresos\enaho01a-`y'-500.dta"
		append using "$Fuente\\`z'\\$Empleo_ingresos\enaho01a-`z'-500.dta"
		rename a*o año		
		save "$Consultoria_3\enaho01a-`x'-`z'-500.dta", replace

		use "$Fuente\\`x'\\$Sumarias\sumaria-`x'.dta", clear
		append using "$Fuente\\`y'\\$Sumarias\sumaria-`y'.dta"
		append using "$Fuente\\`z'\\$Sumarias\sumaria-`z'.dta"
		rename a*o año		
		save "$Consultoria_3\sumaria-`x'-`z'.dta", replace
*/

*		use "$Consultoria_3\enaho01-2019-2021-100.dta", clear
*		use "$Consultoria_3\enaho01-2019-2021-200.dta", clear
*		use "$Consultoria_3\enaho01a-2019-2021-400.dta", clear		
*		use "$Consultoria_3\enaho01a-2019-2021-500.dta", clear
*		use "$Consultoria_3\sumaria-2019-2021.dta", clear

/*
use "$Consultoria_3\enaho01a-2019-2021-500.dta", clear
merge 1:1 año conglome vivienda hogar codperso using "$Consultoria_3\enaho01a-2019-2021-400.dta", gen(salud_merge) // se eliminan a los menores de 3 años 
merge 1:1 año conglome vivienda hogar codperso using "$Consultoria_3\enaho01-2019-2021-200.dta", keepusing(p209 p203b) gen(miembros_merge)
merge m:1 año conglome vivienda hogar          using "$Consultoria_3\enaho01-2019-2021-100.dta",  gen(vivienda_merge)
merge m:1 año conglome vivienda hogar          using "$Consultoria_3\sumaria-2019-2021.dta",  gen(sumaria_merge)
save "$Consultoria_3\Modulo 100-200-400-500-sumaria 2019-2021.dta", replace
*/

use "$Consultoria_3\Modulo 100-200-400-500-sumaria 2019-2021.dta", clear
destring año, replace

tab salud_merge, miss
/*
            salud_merge |      Freq.     Percent        Cum.
------------------------+-----------------------------------
         using only (2) |     85,993       20.79       20.79
            matched (3) |    270,215       65.32       86.11
                      . |     57,481       13.89      100.00
------------------------+-----------------------------------
                  Total |    413,689      100.00
*/
tab miembros_merge, miss
tab vivienda_merge, miss
tab sumaria_merge, mis
keep if salud_merge==3 & miembros_merge==3 & vivienda_merge==3 & sumaria_merge==3 // 270,215
		
*Area de residencia
gen     area=1 if estrato<=5
replace area=2 if estrato>=6 & estrato<=8
lab def area 1 "urbano" 2 "rural"
lab val area area

*Region natural
gen     region_natural=1 if dominio>=1 & dominio<=3 
replace region_natural=1 if dominio==8
replace region_natural=2 if dominio>=4 & dominio<=6 
replace region_natural=3 if dominio==7 
label define region_natural 1 "Costa" 2 "Sierra" 3 "Selva"
lab val region_natural region_natural

*Dominio geografico
gen     domin02=1 if dominio>=1 & dominio<=3 & area==1
replace domin02=2 if dominio>=1 & dominio<=3 & area==2
replace domin02=3 if dominio>=4 & dominio<=6 & area==1
replace domin02=4 if dominio>=4 & dominio<=6 & area==2
replace domin02=5 if dominio==7 & area==1
replace domin02=6 if dominio==7 & area==2
replace domin02=7 if dominio==8
label define domin02 1 "Costa_urbana" 2 "Costa_rural" 3 "Sierra_urbana" /// 
 4 "Sierra_rural" 5 "Selva_urbana" 6 "Selva_rural" 7 "Lima_Metropolitana"
label value domin02 domin02

*ReDepartamento
gen     region=real(substr(ubigeo,1,2))
gen     dpto  =region
replace dpto=15 if (dpto==7)
label define region 1"Amazonas" 2"Ancash" 3"Apurimac" 4"Arequipa" 5"Ayacucho" 6"Cajamarca" 7"Callao" 8"Cusco" 9"Huancavelica" 10"Huanuco" 11"Ica" 12"Junin" 13"La_Libertad" 14"Lambayeque" 15"Lima" 16"Loreto" 17"Madre_de_Dios" 18"Moquegua" 19"Pasco" 20"Piura" 21"Puno" 22"San_Martin" 23"Tacna" 24"Tumbes" 25"Ucayali" 26"Lima metropolitana" 27"Lima provincia" 
lab val region region 
lab val dpto   region 

gen reg_prov=substr(ubigeo,1,4)
tab reg_prov dominio if dpto==15, miss

*Departamento Lima Metropolitana y Callao
clonevar region_1=region
replace  region_1=26 if region==15 & reg_prov=="1501"
replace  region_1=27 if region==15 & reg_prov!="1501"

egen  Ing_tra_A= rowtotal(i524a1 d529t i530a d536 i538a1 d540t i541a d543 d544t) 
gen   Ing_tra_M= Ing_tra_A/12
label var   Ing_tra_A "ingreso por trabajo anual"
label var   Ing_tra_M "ingreso por trabajo mensual"

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
egen horas_S=rowtotal(i513t i518) if p519==1, missing
replace horas_S=i520 if p519==2 & i520!=.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

gen Ing_tra_horas = Ing_tra_M/(4*horas_S)

*Se establece quienes son residentes habituales
gen resi=1 if ((p204==1 & p205==2) | (p204==2 & p206==1))

*keep if ocu500==1 & Ing_tra_M>0 

********************************************************************************

*Grupos de edad
gen     edad_g1=1 if p208a>13 & p208a<25
replace edad_g1=2 if p208a>24 & p208a<60
replace edad_g1=3 if p208a>59 & p208a<65
replace edad_g1=4 if p208a>64
label define edad_g1 1 "14-24" 2 "25-59" 3 "60-64" 4 "65 y mas"
lab val edad_g1 edad_g1

*Grupos de edad
gen     edad_g2=1 if p208a>13 & p208a<25
replace edad_g2=2 if p208a>24 & p208a<45
replace edad_g2=3 if p208a>44 & p208a<60
replace edad_g2=4 if p208a>59 & p208a<65
replace edad_g2=5 if p208a>64
label define edad_g2 1 "14-24" 2 "25-44" 3 "45-59" 4 "60-64" 5 "65 y mas"
lab val edad_g2 edad_g2

*Estado civil 1
gen     ecivil_1=1 if p209==3 | p209==4 | p209==5
replace ecivil_1=2 if p209==6
replace ecivil_1=3 if p209==1 | p209==2
lab def ecivil_1 1 "Alguna vez unido/a 2/" 2 "Soltero/a" 3 "Unido/a 1/" 
lab val ecivil_1 ecivil_1
*1/ Incluye : Conviviente y casado/a
*2/ Incluye: Separado/a, divorciado/a y viudo/a.

*Estado civil 2
gen     ecivil_2=1 if p209==1
replace ecivil_2=2 if p209==2
replace ecivil_2=3 if p209==3 | p209==4 | p209==5
replace ecivil_2=4 if p209==6
lab def ecivil_2 1"Conviviente" 2"Casado/a" 3"Alguna vez unido/a 1/" 4"Soltero/a"
lab val ecivil_2 ecivil_2
*1/ Incluye: Separado/a, divorciado/a y viudo/a.

*Educacion
gen     educ=1 if p301a<5  | p301a==12 | p301a==.
replace educ=2 if p301a==5 | p301a==6
replace educ=3 if p301a==7 | p301a==8
replace educ=4 if p301a==9 | p301a==10 | p301a==11
replace educ=5 if p301a==.
lab def educ 1 "Primaria 1/" 2 "Educacion secundaria" 3 "Superior no universitaria" 4 "Superior universitaria" 5 "No Especificado"
lab val educ educ
*1/ Incluye sin nivel e inicial. A partir del año 2017 se incluye educación básica especial

gen educ_1=educ
replace educ_1=3 if educ==4
lab def educ_1 1 "Primaria 1/" 2 "Secundaria" 3 "Superior" 4 "No Especificado"
lab val educ_1 educ_1
*1/ Incluye sin nivel e inicial. A partir del año 2017 se incluye educación básica especial
*2/Incluye: Superior universitaria y no universitaria.

*Etnia
gen     etnia=1 if p558c<4 | p558c==9
replace etnia=2 if p558c==4
replace etnia=3 if p558c==6
replace etnia=4 if p558c==5 | p558c==7 
replace etnia=5 if p558c==8
lab def etnia 1 "Indigena 1/" 2 "Negro, mulato, Afro peruano" 3 "Mestizo/a" 4 "Otro 2/" 5 "No sabe"
lab val etnia etnia
*1/ Incluye: Quechua, Aimara y Nativo o Indígena de la Amazonía.
*2/ Incluye: Blanco y otro

tab p512b p512a, miss

* Tamaño de empresa
gen     tamahno=1 if p512b>0  & p512b<11
replace tamahno=2 if p512b>10 & p512b<51
replace tamahno=3 if p512b>50
replace tamahno=4 if p512b==. & (p512a==1 | p512a==2 | p512a==3) 	
replace tamahno=3 if p512b==. & p512a==3
label def tamahno 1 "De 1 a 10 trabajadores" 2 "De 11 a 50 trabajadores" 3 "De 51 a más trabajadores" 4 "No especificado" 
label val tamahno tamahno

* Rama de actividad
* CIIU
gen      ciiu_auxl =substr("0"+string(p506r4),1,.)
replace  ciiu_auxl =substr(string(p506r4),1,.) if p506r4>999
gen      ciiu_aux2 =substr(ciiu_auxl,1,2)
destring ciiu_aux2, generate (ciiu_2d)

gen      ciiu_ld=1  if  ciiu_2d<=2
replace  ciiu_ld=2  if  ciiu_2d==3
replace  ciiu_ld=3  if (ciiu_2d>=5   & ciiu_2d<=9)
replace  ciiu_ld=4  if (ciiu_2d>=10  & ciiu_2d<=33)
replace  ciiu_ld=5  if (ciiu_2d>=41  & ciiu_2d<=43)
replace  ciiu_ld=6  if (ciiu_2d>=45  & ciiu_2d<=47)
replace  ciiu_ld=7  if (ciiu_2d>=49  & ciiu_2d<=53) | (ciiu_2d>=58 & ciiu_2d<=63)
replace  ciiu_ld=8  if (ciiu_2d==84)
replace  ciiu_ld=9  if (ciiu_2d>=55  & ciiu_2d<=56)
replace  ciiu_ld=10 if (ciiu_2d==68) | (ciiu_2d>=69 & ciiu_2d<=82)
replace  ciiu_ld=11 if (ciiu_2d==85)
replace  ciiu_ld=12 if (ciiu_2d>=35 & ciiu_2d<=39) | (ciiu_2d>=64 & ciiu_2d<=66) | (ciiu_2d>=86 & ciiu_2d<=88) | (ciiu_2d>=90 & ciiu_2d<=93) | (ciiu_2d>=94 & ciiu_2d<=98) | ciiu_2d==99
label def ciiu_ld 1 "Agricultura" 2 "Pesca" 3 "Mineria" 4 "Manufactura" 5 "Construccion" 6 "Comercio" 7 "Transportes y Comunicaciones" 8 "Gobierno" 9 "Hoteles y Restaurantes" 10 "Inmobiliarias y alquileres" 11 "Ensehnanza" 12 "Otros Servicios 1/"
label var ciiu_ld "Division CIIU"
label values ciiu_ld ciiu_ld
* 1/ Otros Servicios lo componen las ramas de actividad de Electricidad, Gas y Agua,
*    Intermediación Financiera, Actividades de Servicios Sociales y de Salud, Otras activ.
*    de Serv. Comunitarias, Sociales y Personales y Hogares privadgs con servicio doméstico.

tab ciiu_ld [iw= fac500a] if resi==1 & ocu500==1, m

*Población ocupada en empleo informal por Rama de Actividad
gen     ciiu_6c=1 if ciiu_ld<4
replace ciiu_6c=2 if ciiu_ld==4
replace ciiu_6c=3 if ciiu_ld==5
replace ciiu_6c=4 if ciiu_ld==6
replace ciiu_6c=5 if ciiu_ld==7
replace ciiu_6c=6 if ciiu_ld>7
label var ciiu_6c "Division CIIU-6 categorias"
label def ciiu_6c 1 "Agricultura/Pesca/Mineria" 2 "Manufactura" 3 "Construcción" 4 "Comercio" 5 "Transportes y Comunicaciones" 6 "Otros Servicios 1/"
label val ciiu_6c ciiu_6c

tab ciiu_6c ocupinf [iw= fac500a] if resi==1 & ocu500==1, nofreq row

***    ***    ***    ***    ***    ***    ***    ***    ***    ***    ***    ***
********************************************************************************
***    ***    ***    ***    ***    ***    ***    ***    ***    ***    ***    ***

recode p4191 p4192 p4193 p4194 p4195 p4196 p4197 p4198 (2=0)
*no incluyo a los que tienen seguro escolar
gen     seguro= p4191 + p4192 + p4193 + p4194 + p4195 + p4196 + p4198
tab     seguro
replace seguro=1 if seguro>=1 & seguro<=4

***    ***    ***    ***    ***    ***    ***    ***    ***    ***    ***    ***
********************************************************************************
***    ***    ***    ***    ***    ***    ***    ***    ***    ***    ***    ***

********************************************************************************
*Tasa de actividad
*El cociente de la Población Económicamente Activa entre el total de Población en Edad de Trabajar
gen     t_act=0  if p208a>=14
replace t_act=1  if ocu500==1 | ocu500==2
lab def t_act 0 "" 1 "Tasa de Actividad"
lab val t_act t_act

tab t_act area   [iw= fac500a] if  resi==1, col nofreq
tab t_act region_natural [iw= fac500a] if  resi==1, col nofreq

********************************************************************************
*Componentes de la Población Económicamente Inactiva, según sexo
gen     c_pei=1 if p546==6
replace c_pei=2 if p546==3 | p546==8
replace c_pei=3 if p546==7
replace c_pei=4 if p546==4
replace c_pei=5 if p546==5
lab def c_pei 1 "Vivía de su pensión o jubilación u otras rentas" 2 "Otro 1/" ///
3 "Enfermo o incapacitado" 4 "Estudiando" 5 "Quehaceres del hogar"
lab val c_pei c_pei
*1/ Incluye : Esperando el inicio de un trabajo dependiente, otro y no especificado

tab  c_pei p207  [iw= fac500a ] if ocu500>2 & resi==1, nofreq col

********************************************************************************
*Tasa de desempleo abierto
*Es la proporción de la fuerza de trabajo desocupada disponible y que busca activamente trabajo
gen     t_de_a=0 if ocu500==1 | ocu500==2
replace t_de_a=1 if ocu500==2
lab def t_de_a 0 "" 1 "Tasa de Desempleo Abierto"
lab val t_de_a t_de_a
	
***    ***    ***    ***    ***    ***    ***    ***    ***    ***    ***    ***
********************************************************************************
***    ***    ***    ***    ***    ***    ***    ***    ***    ***    ***    ***
*codebook Ing_tra_M if ocu500==1 & Ing_tra_M<0  //       0 observaciones
codebook Ing_tra_M if ocu500==1 & Ing_tra_M==0 //  28,003 observaciones
codebook Ing_tra_M if ocu500==1 & Ing_tra_M>0  // 153,501 observaciones

*codebook horas_S if ocu500==1 & horas_S<0  //       0 observaciones
codebook horas_S if ocu500==1 & horas_S==0 //       1 observaciones
codebook horas_S if ocu500==1 & horas_S>0  // 181,503 observaciones

gen PCT_Ing_tra_M=.
label var PCT_Ing_tra_M               "10 quantiles of Ing_tra_M, 2019-2021, Perú" 
forvalues i = 2019(1)2021 {
	xtile PCT_Ing_tra_M`i' = Ing_tra_M if (ocu500==1 & Ing_tra_M>0) & año==`i', nq(10) 
	replace PCT_Ing_tra_M=PCT_Ing_tra_M`i' if PCT_Ing_tra_M==. 
	drop PCT_Ing_tra_M`i'
}

***    ***    ***    ***    ***    ***    ***    ***    ***    ***    ***    ***
********************************************************************************
***    ***    ***    ***    ***    ***    ***    ***    ***    ***    ***    ***

********************************************************************************
* Cuadro Nº 1.1 
* Perú: Población en Edad de Trabajar, según ámbito geográfico, 2007 , 2018 y 2019
* (Miles de personas)
tab area   año [iw= fac500a] if resi==1 & (ocu500==1 | ocu500==2 | ocu500==3 | ocu500==4) & año==2019
tab region_natural año [iw= fac500a] if resi==1 & (ocu500==1 | ocu500==2 | ocu500==3 | ocu500==4) & año==2019

* Cuadro Nº 1.2
* Perú: Población en Edad de Trabajar por sexo, según ámbito geográfico, 2007 y 2019
* (Miles de personas)
tab area   p207 [iw= fac500a] if resi==1 & (ocu500==1 | ocu500==2 | ocu500==3 | ocu500==4) & año==2019
tab region_natural p207 [iw= fac500a] if resi==1 & (ocu500==1 | ocu500==2 | ocu500==3 | ocu500==4) & año==2019

* Cuadro Nº 1.3 
* Perú: Población en Edad de Trabajar, según área de residencia y grupos de edad, 2007, 2018 y 2019
* (Miles de personas)
tab edad_g1 area [iw= fac500a] if resi==1 & (ocu500==1 | ocu500==2 | ocu500==3 | ocu500==4) & año==2019

* Cuadro Nº 1.4 
* Perú: Población Económicamente Activa, según ámbito geográfico, 2007 – 2019
* (Miles de personas)
tab area   [iw= fac500a] if resi==1 & (ocu500==1 | ocu500==2) & año==2019
tab region_natural [iw= fac500a] if resi==1 & (ocu500==1 | ocu500==2) & año==2019

*keep if ocu500==1 & Ing_tra_M>0 

* Cuadro Nº 1.5 
* Perú: Población Económicamente Activa, según nivel educativo y área de residencia, 2007, 2018 y 2019
* (Miles de personas)
tab educ area [iw= fac500a] if resi==1 & (ocu500==1 | ocu500==2) & año==2019 

* Cuadro Nº 1.6 
* Perú: Población Económicamente No Activa, según principales características, 2007, 2018 y 2019
* (Miles de personas)
tab p207    [iw= fac500a] if resi==1 & (ocu500==3 | ocu500==4) & año==2019
tab edad_g1 [iw= fac500a] if resi==1 & (ocu500==3 | ocu500==4) & año==2019
tab educ    [iw= fac500a] if resi==1 & (ocu500==3 | ocu500==4) & año==2019

* Cuadro Nº 2.1
* Perú: Población ocupada, según ámbito geográfico, 2007 - 2019
* (Miles de personas y porcentaje
tab area   [iw= fac500a] if resi==1 & (ocu500==1) & año==2019
tab region_natural [iw= fac500a] if resi==1 & (ocu500==1) & año==2019

* Cuadro Nº 2.2 
* Perú: Población ocupada, según sexo y grupos de edad, 2007, 2018 y 2019
* (Miles de personas y porcentaje)
tab p207    [iw= fac500a] if resi==1 & (ocu500==1) & año==2019
tab edad_g2 [iw= fac500a] if resi==1 & (ocu500==1) & año==2019

* Cuadro Nº 2.3 
* Perú: Población ocupada, según ramas de actividad, 2008, 2018 y 2019
* (Miles de personas
tab ciiu_ld [iw= fac500a] if resi==1 & (ocu500==1) & año==2019

* Cuadro Nº 2.4 
* Perú: Promedio de horas trabajadas, según ramas de actividad, 2008, 2018 y 2019
* (Promedio de horas por semana)
table ciiu_ld [iw= fac500a] if resi==1 & (ocu500==1) & horas_S>0 & año==2019, c(mean horas) format(%9.3f)

* Cuadro Nº 2.5 
* Perú: Población ocupada de 18 y más años de edad que accede al sistema financiero, según 
* principales características demográficas y ámbito geográfico,2015 y 2019
* (Porcentaje)

* Cuadro Nº 2.6 
* Perú: Inclusión financiera de la población ocupada de 18 y más años de edad por sexo, según 
* condición de informalidad, 2015, 2018 y 2019
* (Porcentaje

* Cuadro Nº 2.7 
* Perú: Población ocupada por acceso a Internet, según principales características, 2007, 2018 y 2019
* (Porcentaje)

* Cuadro Nº 2.8 
* Perú: Población ocupada con acceso a Internet por medio a través del cual accede, 
* según principales características, 2019
* (Porcentaje)

* Cuadro Nº 3.1 
* Perú: Población económicamente activa, según niveles de empleo, 2007, 2018 y 2019
* (Miles de personas)
tab ocu500  [iw= fac500a] if resi==1 & (ocu500==1 | ocu500==2) & año==2019, miss

tab ocupinf [iw= fac500a] if resi==1 & (ocu500==1 | ocu500==2) & año==2019 & ocu500==1, miss 
tab emplpsec [iw= fac500a] if resi==1 & (ocu500==1 | ocu500==2) & año==2019 & ocu500==1, miss 
tab emplpsec [iw= fac500a] if resi==1 & (ocu500==1 | ocu500==2) & año==2019, miss 

* Cuadro Nº 3.2 
* Perú: Población económicamente activa por ámbito geográfico, según niveles de empleo, 2007 y 2019
* (Porcentaje)

* Cuadro Nº 3.3 
* Perú: Tasa de empleo adecuado, subempleo y desempleo según sexo, 2007, 2018 y 2019
* (Porcentaje)

* Cuadro Nº 4.1 
* Perú: Población ocupada asalariada, según ámbito geográfico, 2007 - 2019
* (Miles de personas
tab area [iw=fac500a] if resi==1 & (ocu500==1) & Ing_tra_M>0 & año==2019


* Cuadro Nº 4.2 
* Perú: Población ocupada asalariada, según sexo y grupos de edad, 2007, 2018 y 2019
* (Miles de personas)

* Cuadro Nº 4.3 
* Perú: Población ocupada asalariada, según tipo de contrato y área urbana, 2007, 2018 y 2019
* (Miles de personas)

* Cuadro Nº 4.4 
* Perú: Población ocupada asalariada por condición de tenencia de contrato, 
* según ramas de actividad, 2019
* (Porcentaje)

* Cuadro Nº 4.5 
* Perú: Población ocupada asalariada, según sector donde labora y tipo de contrato, 2007, 2018 y 2019
* (Miles de personas)

* Cuadro Nº 4.6 
* Perú: Población ocupada asalariada según tenencia de seguro de salud y sexo, 2007 -2019
* (Miles de personas)

* Cuadro Nº 4.7 
* Perú: Población ocupada asalariada según tipo de seguro de salud y sexo, 2007, 2018 y 2019
* (Miles de personas)

* Cuadro Nº 5.1 
* Perú: Población ocupada con seguro de salud, según área de residencia, 2007 - 2019
* (Miles de personas y porcentaje)
tab seguro area [iw= fac500a] if resi==1 & (ocu500==1) & año==2019, row

* Cuadro Nº 5.2 
* Perú: Población ocupada con seguro de salud, según tipo y área de residencia, 2007, 2018 y 2019 
* (Miles de personas)

* Cuadro Nº 5.3 
* Perú: Población ocupada con seguro de salud, según tipo y sexo 2007, 2018 y 2019
* (Miles de personas)

* Cuadro Nº 5.4 
* Perú: Población ocupada con seguro de salud, según tamaño de empresa y sexo, 2007, 2018 y 2019
* (Miles de personas y porcentaje del total de ocupados en cada tamaño de empresa)
tab tamahno seguro [iw= fac500a] if resi==1 & (ocu500==1) & año==2019, row
tab tamahno seguro [iw= fac500a] if resi==1 & (ocu500==1) & p207==1 & año==2019 , row
tab tamahno seguro [iw= fac500a] if resi==1 & (ocu500==1) & p207==2 & año==2019 , row

* Cuadro Nº 5.5 
* Perú: Población ocupada afiliada a un sistema de pensiones, según ámbito geográfico, 2007 , 2018 y 2019
* (Miles de personas)

* Cuadro Nº 5.6 
* Perú: Población ocupada masculina y femenina afiliada a un sistema de pensiones, 
* según área de residencia, 2007, 2018 y 2019
*  (Miles de personas)

* Cuadro Nº 5.7 
* Perú: Población ocupada afiliada a un sistema de pensiones, según tipo y área de residencia, 2007, 2018 y 2019
* (Miles de personas)

* Cuadro Nº 5.8 
* Perú: Población ocupada masculina y femenina afiliada a un sistema de pensiones, 
* según tipo, 2007, 2018 y 2019
* (Porcentaje

* Cuadro Nº 5.9 
* Perú: Población ocupada afiliada a un sistema de pensiones, según 
* tamaño de empresa y área de residencia, 2007, 2018 y 2019
* (Miles de personas)

* Cuadro Nº 5.10 
* Perú: Población ocupada afiliada a un sistema de pensiones, según 
* ramas de actividad, 2007, 2018 y 2019
* (Miles de personas)

* Cuadro Nº 6.1
* Perú: Población en Edad de Trabajar de 14 a 29 años, según ámbito geográfico, 2007, 2018 y 2019
* (Miles de personas)

* Cuadro Nº 6.2
* Perú: Población Económicamente Activa de 14 a 29 años , según ámbito geográfico, 2007 - 2019
* (Miles de personas)

* Cuadro Nº 6.3
* Perú: Población Económicamente Activa de 14 a 29 años por sexo, según ámbito geográfico, 2007 y 2019
* (Miles de personas)

* Cuadro Nº 6.4
* Perú: Población Económicamente Inactiva de 14 a 29 años, según ámbito geográfico, 2007, 2018 y 2019
* (Miles de personas)

* Cuadro Nº 6.5
* Perú: Población ocupada de 14 a 29 años, según ámbito geográfico, 2007- 2019
* (Miles de personas)

* Cuadro Nº 6.6
* Perú: Población ocupada de 14 a 29 años por sexo, según área de residencia, 2007 y 2019
* (Miles de personas

* Gráfico Nº 6.8
* Perú: Participación de la población ocupada joven de 14 a 29 años por ramas de actividad, 2019
* (Porcentaje)

* Cuadro Nº 6.7
* Perú: Población desempleada joven de 14 a 29 años, según sexo y grupos de edad, 
* 2007, 2018 y 2019
* (Miles de personas y porcentaje

* Cuadro Nº 7.1 
* Perú: Población ocupada por empleo formal e informal, según ámbito geográfico 2008, 2018 y 2019
* (Miles de personas)

* Cuadro Nº 7.2 
* Perú: Población ocupada por empleo formal e informal, según sexo y área de residencia, 2008 y 2019
* (Miles de personas y porcentaje)

* Cuadro Nº 7.3 
* Perú: Población ocupada con empleo informal por sexo, según nivel educativo, 2018 y 2019 
* (Porcentaje)

* Cuadro Nº 7.4 
* Perú: Población ocupada en empleo informal, según principales características, 2008, 2018 y 2019
* (Porcentaje)

* Cuadro Nº 7.5 
* Perú: Población ocupada por empleo informal, según quintiles, 2018 y 2019
* (Miles de personas y porcentaje)

* Cuadro Nº 8.1
* Perú: Población desempleada, según área de residencia, 2007 - 2019
* (Miles de personas)

* Cuadro Nº 8.2 
* Perú: Población desempleada, según sexo y grupos de edad, 2007, 2018 y 2019
* (Miles de personas)

* Cuadro Nº 8.3 
* Perú urbano: Tasa de desempleo abierto por sexo, según etnia, 2017 - 2019
* (Porcentaje)

* Cuadro Nº 9.1
* Perú: Características sociodemográficas de la población ocupada , 
* según condición de migración interna reciente, 2019
* (Porcentaje

*¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨*
*¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨*
* X. INGRESO PROMEDIO PROVENIENTE DEL TRABAJO
*¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨*
*¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨*
123
{
* Cuadro Nº 10.1 
* Perú: Ingreso promedio mensual proveniente del trabajo, según ámbito geográfico, 2007 - 2019
* (Soles corrientes
table area   [iw=fac500a] if resi==1 & Ing_tra_M>0 & año==2019, c(mean Ing_tra_M) row
table region_natural [iw=fac500a] if resi==1 & Ing_tra_M>0 & año==2019, c(mean Ing_tra_M) row

* Gráfico Nº 10.2 
* Perú: Ingreso promedio mensual proveniente del trabajo, según departamento, 2019
* (Soles corrientes)
table dpto_lima [iw=fac500a] if resi==1 & Ing_tra_M>0 & año==2019, c(mean Ing_tra_M) row

* Cuadro Nº 10.2 
* Perú: Ingreso promedio mensual proveniente del trabajo de hombres y mujeres, según 
* área de residencia, 2007, 2018 y 2019
* (Soles corrientes)
table area p207 [iw=fac500a] if resi==1 & (ocu500==1) & Ing_tra_M>0 & año==2019, c(mean Ing_tra_M) row

* Cuadro Nº 10.3 
* Perú: Ingreso promedio mensual proveniente del trabajo, según 
* grupos de edad, 2007, 2018 y 2019
* (Soles corrientes)
table edad_g2 [iw=fac500a] if resi==1 & (ocu500==1) & Ing_tra_M>0 & año==2019, c(mean Ing_tra_M) row

* Cuadro Nº 10.4 
* Perú: Ingreso promedio mensual proveniente del trabajo, según nivel educativo y área urbana, 
* 2007, 2018 y 2019
* (Soles corrientes)
table educ [iw=fac500a] if resi==1 & (ocu500==1) & Ing_tra_M>0 & año==2019, c(mean Ing_tra_M) row
table educ [iw=fac500a] if resi==1 & (ocu500==1) & Ing_tra_M>0 & area==1 & año==2019, c(mean Ing_tra_M) row

* Gráfico Nº 10.8 
* Perú: Ingreso promedio proveniente del trabajo de la PEA ocupada por nivel de educación alcanzado, 
* según departamento, 2019
* (Soles corrientes)
table region_1 educ_1 [iw=fac500a] if resi==1 & (ocu500==1) & Ing_tra_M>0 & año==2019, c(mean Ing_tra_M) row

* Cuadro Nº 10.5 
* Perú: Ingreso promedio mensual proveniente del trabajo de la población ocupada, según 
* etnia, 2013, 2018 y 2019
* (Soles corrientes 
table etnia [iw=fac500a] if resi==1 & (ocu500==1) & Ing_tra_M>0 & año==2019, c(mean Ing_tra_M) row

* Cuadro Nº 10.6 
* Perú: Ingreso promedio mensual proveniente del trabajo, según estado civil o conyugal, 2007, 2018 y 2019
* (Soles corrientes)
table ecivil_2 [iw=fac500a] if resi==1 & (ocu500==1) & Ing_tra_M>0 & año==2019, c(mean Ing_tra_M) row

* Cuadro Nº 10.7 
* Perú: Ingreso promedio mensual proveniente del trabajo, según tamaño de empresa y 
* área urbana, 2007, 2018 y 2019
* (Soles corrientes)
table tamahno [iw=fac500a] if resi==1 & (ocu500==1) & Ing_tra_M>0 & año==2019, c(mean Ing_tra_M) row

* Cuadro Nº 10.8 
* Perú: Ingreso promedio por hora proveniente del trabajo de hombres y mujeres, según 
* ámbito geográfico, 2007 y 2019
* (Soles corrientes)
*table area p207 [iw=fac500a] if resi==1 & (ocu500==1) & Ing_tra_M>0 & horas>0 & año==2019, c(mean Ing_tra_horas) row

	

ecivil

}


11111111111111111111111111111111111111111111111111111111111111111111111111111111
22222222222222222222222222222222222222222222222222222222222222222222222222222222
33333333333333333333333333333333333333333333333333333333333333333333333333333333
44444444444444444444444444444444444444444444444444444444444444444444444444444444
55555555555555555555555555555555555555555555555555555555555555555555555555555555
66666666666666666666666666666666666666666666666666666666666666666666666666666666
77777777777777777777777777777777777777777777777777777777777777777777777777777777
88888888888888888888888888888888888888888888888888888888888888888888888888888888
99999999999999999999999999999999999999999999999999999999999999999999999999999999

*if ocu500==1 & Ing_tra_M>0 
*Población en Edad de Trabajar por sexo, según ámbito geográfico
tab area   p207 [iw= factor07]  if resi==1
tab region_natural p207 [iw= factora07] if resi==1 

factor07 factora07

*Población en Edad de Trabajar, según área de residencia y grupos de edad
tab edad area [iw= fac500a] if resi==1

********************************************************************************
*Poblacion Economicamente Activa, según ámbito geográfico
tab area   ocu500 [iw= fac500a ] if ocu500<3 & resi==1 & año==2019
tab region_natural ocu500 [iw= fac500a ] if ocu500<3 & resi==1

*Población Económicamente Activa según etnia
tab etnia   ocu500 [iw= fac500a ] if ocu500<3 & resi==1, nofreq col

*Población Económicamente Activa, según estado civil o conyugal y sexo
tab ecivil   p207 [iw= fac500a ] if ocu500<3 & resi==1, nofreq col

********************************************************************************
*Tasa de actividad
*El cociente de la Población Económicamente Activa entre el total de Población en Edad de Trabajar
gen     t_act=0  if p208a>=14
replace t_act=1  if ocu500==1 | ocu500==2
lab def t_act 0 "" 1 "Tasa de Actividad"
lab val t_act t_act

tab t_act area   [iw= fac500a] if  resi==1, col nofreq
tab t_act region_natural [iw= fac500a] if  resi==1, col nofreq

********************************************************************************
*Componentes de la Población Económicamente Inactiva, según sexo
gen     c_pei=1 if p546==6
replace c_pei=2 if p546==3 | p546==8
replace c_pei=3 if p546==7
replace c_pei=4 if p546==4
replace c_pei=5 if p546==5
lab def c_pei 1 "Vivía de su pensión o jubilación u otras rentas" 2 "Otro 1/" ///
3 "Enfermo o incapacitado" 4 "Estudiando" 5 "Quehaceres del hogar"
lab val c_pei c_pei
*1/ Incluye : Esperando el inicio de un trabajo dependiente, otro y no especificado

tab  c_pei p207  [iw= fac500a ] if ocu500>2 & resi==1, nofreq col

********************************************************************************
*Población ocupada según nivel de educación alcanzado
tab  educ  [iw= fac500a ] if ocu500==1 & resi==1 


********************************************************************************
*Tasa de desempleo abierto
*Es la proporción de la fuerza de trabajo desocupada disponible y que busca activamente trabajo
gen     t_de_a=0 if ocu500==1 | ocu500==2
replace t_de_a=1 if ocu500==2
lab def t_de_a 0 "" 1 "Tasa de Desempleo Abierto"
lab val t_de_a t_de_a

*Perú urbano: Tasa de desempleo abierto por sexo, según etnia
tab etnia t_de_a  [iw= fac500a] if  resi==1 & area==1 & p207==1, row nofreq
tab etnia t_de_a  [iw= fac500a] if  resi==1 & area==1 & p207==2, row nofreq

* Cuadro Nº 10.1 
* Perú: Ingreso promedio mensual proveniente del trabajo, según ámbito geográfico, 2007 - 2019
* (Soles corrientes
table area [iw=fac500a] if resi==1 & Ing_tra_M>0 & año==2019, c(mean Ing_tra_M) row

* Gráfico Nº 10.2 
* Perú: Ingreso promedio mensual proveniente del trabajo, según departamento, 2019
* (Soles corrientes)
table dpto_lima [iw=fac500a] if resi==1 & Ing_tra_M>0 & año==2019, c(mean Ing_tra_M) row

* Cuadro Nº 10.2 
* Perú: Ingreso promedio mensual proveniente del trabajo de hombres y mujeres, según 
* área de residencia, 2007, 2018 y 2019
* (Soles corrientes)
table area p207 [iw=fac500a] if resi==1 & (ocu500==1) & Ing_tra_M>0 & año==2019, c(mean Ing_tra_M) row

* Cuadro Nº 10.3 
* Perú: Ingreso promedio mensual proveniente del trabajo, según 
* grupos de edad, 2007, 2018 y 2019
* (Soles corrientes)
table edad [iw=fac500a] if resi==1, c(mean Ing_tra_M) row


edad

