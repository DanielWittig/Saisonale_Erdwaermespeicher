# Wirtschaftlichkeit Saisonaler Erdwärmespeicher


Hier entsteht gerade die Kette der Rechnungen in Python, als deren
Ergebnis die 61 EUR/a/Kopf Heizkosten erwartet werden.

``` r
library(reticulate)
```

``` python
# first empty the Python environment
Z_my_previous_python_variables =\
  [k for k in globals().keys() if not (k.startswith("__") | (k == "r")) ]
print(Z_my_previous_python_variables)
```

    []

``` python
for key in Z_my_previous_python_variables:
  exec('del('+key+')')

import numpy as np
import pandas as pd
import re
import pickle
import pprint

# saisonale Kurven
sheet_e = pd.read_excel(
  '_base/jahreslauf_roebel.xlsx'
  , sheet_name='e', header = 1)
print(sheet_e.shape)
```

    (737, 28)

``` python
kurven = sheet_e.iloc[1:732,:18]; kurven.head()
```

      Tag                Datum  ... Speicher Iinhalt Speicher Temperatur
    1   0  2019-03-21 00:00:00  ...                0                  40
    2   1  2019-03-22 00:00:00  ...         2.611305           40.025395
    3   2  2019-03-23 00:00:00  ...         5.695147           40.055386
    4   3  2019-03-24 00:00:00  ...         9.251385           40.089971
    5   4  2019-03-25 00:00:00  ...        13.279741           40.129148

    [5 rows x 18 columns]

``` python
einheiten = sheet_e.iloc[0,:18]
original = kurven.copy()

#make_var_name
def make_var_name(input_string):
  """
  Generate a python object name from a variable description
  """
  inter = input_string
  inter = re.sub('\.', '', inter)
  inter = re.sub(', entspricht', '', inter)
  inter = re.sub('[\s:\(\),;-]', '_', inter)
  inter = re.sub('ä', 'ae', inter)
  inter = re.sub('ö', 'oe', inter)
  inter = re.sub('ü', 'ue', inter)
  inter = re.sub('Ä', 'Ae', inter)
  inter = re.sub('Ö', 'Oe', inter)
  inter = re.sub('Ü', 'Ue', inter)
  inter = re.sub('ß', 'ss', inter)
  inter = re.sub('&', 'u' , inter)
  inter = re.sub('\+', '_u_' , inter)
  inter = re.sub('/', '_pro_', inter)
  inter = re.sub('²', '2', inter)
  inter = re.sub('³', '3', inter)
  inter = re.sub('%', 'Prozent', inter)
  inter = re.sub('°', '_Grad_', inter)
  inter = re.sub('=', '_gleich_', inter)
  inter = re.sub('€', '_Euro_', inter)
  inter = re.sub('±', '_plusminus_', inter)
  return inter

new_column_names = [make_var_name(col) for col in list(original)]
kurven.columns = new_column_names


#input_values
input_values = pickle.load(open('input_dict_roebel.p', 'rb'))
for key in input_values.keys():
  globals()[key] = input_values[key]

pprint.pprint(input_values)
```

    {'Abschreibungsjahre_fuer_Bodenpreis_fuer_externes_Kollektorfeld_': 100,
     'Abschreibungsjahre_fuer_Brutto_Kosten_fuer_Montage_und_Installationsmaterial_Kollektorfeld_': 40,
     'Abschreibungsjahre_fuer_Bruttopreis_der_eingesetzten_Roehrenkollektoren__Ritter_CPC_XL_1921_': 25,
     'Abschreibungsjahre_fuer_Investitionskosten_fuer_Heizkraftwerk_': 30,
     'Abschreibungsjahre_fuer_Kosten_Hauptverteilung_Kanal_mit_Rohren_': 25,
     'Abschreibungsjahre_fuer_Kosten_Hausanschluss_': 25,
     'Abschreibungsjahre_fuer_Kosten_der_Umwaelzpumpen_': 20,
     'Abschreibungsjahre_fuer_Preis_der_Pufferspeicher_im_Haus_': 25,
     'Abschreibungsjahre_fuer_Saisonspeicher__gesamt_': 50,
     'Anteil_an_Roehrenkollektoren__Prozent': 30,
     'Anteil_der_Nichtwohngebaeude_am_Endenergieverbrauch__Prozent': 37,
     'Bevoelkerung__Personen': 7518,
     'Effizienznachlass_der_Kollektoren_im_langjaehrigen_Praxisbetrieb_auf__Prozent': 85,
     'Einwohner_favorisiert_Bollewick__Personen': 641,
     'Einwohner_favorisiert_Buetow__Personen': 179,
     'Einwohner_favorisiert_Dambeck__Personen': 324,
     'Einwohner_favorisiert_Gotthun__Personen': 317,
     'Einwohner_favorisiert_Gross_Kelle__Personen': 103,
     'Einwohner_favorisiert_Leizen__Personen': 480,
     'Einwohner_favorisiert_Ludorf__Personen': 481,
     'Einwohner_favorisiert_Minzow__Personen': 357,
     'Einwohner_favorisiert_Roebel__Personen': 5044,
     'Endenergie_nur_fuer_Warmwasser_WW__fuer_alle_Gebaeude_pro_Kopf__kWh_pro_a_pro_Kopf': 1437,
     'Flaeche_Summe__m2': 8110448,
     'Gastarif___Euro__pro_kWh': 0.05,
     'Globalstrahlung_im_Dezember__langjaehriges_Mittel__Berlin___kWh_pro_m2': 13,
     'Globalstrahlung_im_Juni__langjaehriges_Mittel__Berlin___kWh_pro_m2': 166,
     'Jahresertrag_Flachkollektoren__Wuerzburg_bei_T_gleich_50_Grad_C__SUNEX_SA_AMP_2__kWh_pro_a_pro_m2': 370,
     'Jahresertrag_der_Roehrenkollektoren__Wuerzburg_bei_T_gleich_75_Grad_C__Ritter_CPC_XL_1921__kWh_pro_a_pro_m2': 529,
     'Kollektoren_Bodenrichtwert_Kollektorfeld___Euro__pro_m2': 0.5,
     'Kollektoren_Brutto_Kosten_fuer_Montage_und_Installationsmaterial_Kollektorfeld___Euro__pro_m2': 188,
     'Kollektoren_Brutto_pro_netto_Faktor_externes_Kollektorfeld_': 2.75,
     'Kollektoren_Bruttopreis_der_eingesetzten_Flachkollektoren__SUNEX_SA_AMP_20___Euro__pro_m2': 124,
     'Kollektoren_Bruttopreis_der_eingesetzten_Roehrenkollektoren__Ritter_CPC_XL_1921___Euro__pro_m2': 360,
     'Kollektoren_Globalstrahlung_Wuerzburg_langjaehriges_Mittel_Standort_fuer_Kollektorvergleich_Keymark__kWh_pro_m2': 1141,
     'Kollektoren_Maximal_moegliche_taegliche_Globalstrahlung__kWh_pro_d_pro_m2': 7.5,
     'Kollektoren_Mengenrabatt_Kollektoren_und_Installation__Prozent': 20,
     'Kollektoren_Preis_der_Pufferspeicher_im_Haus___Euro__pro_l': 4.2,
     'Leitwert_Rohr_Daemmung__Hauptverteilung_erdverlegt__W_pro_m_pro_K': 0.035,
     'Leitwert_Rohr_Daemmung__Unterverteilung_erdverlegt__W_pro_m_pro_K': 0.035,
     'Moeglichkeit_zur_Eingabe_einer_anderen_Speichertiefe__m': 116,
     'Nebenkosten_der_gesamten_Anlage__Prozent': 20,
     'Norm_Geschwindigkeit_des_Waermetraegers_in_Unterverteilung__UV___m_pro_s': 0.9,
     'Normgeschwindigkeit_in_Hauptverteilung__m_pro_s': 1.2,
     'Rohr_Daemmung_Staerke__Hauptverteilung_erdverlegt__m': 0.07,
     'Rohr_Daemmung_Staerke__Unterverteilung_erdverlegt__m': 0.1,
     'Saisonspeicher_Bodentemperatur_in_50m_Tiefe____Grad_C': 12,
     'Saisonspeicher_Foerderleistung_eines_Brunnens__m3_pro_h': 30,
     'Saisonspeicher_Grundwassergeschwindigkeit_an_Grundwasseroberflaeche__m_pro_d': 0.05,
     'Saisonspeicher_Grundwassergeschwindigkeit_in_Speicherbodentiefe__m_pro_d': 0.005,
     'Saisonspeicher_Hoehe_der_trockenen_Fuellbodenabdeckung__m': 2,
     'Saisonspeicher_Kosten_Technikgebaeude_am_Speicherrand___Euro_': 400000,
     'Saisonspeicher_Kosten_fuer_Abdeckung_mit_2_Folien_pro_m2___Euro__pro_m2': 16,
     'Saisonspeicher_Kosten_fuer_Aushub_u_Erdbewegung___Euro__pro_m3': 5.7,
     'Saisonspeicher_Kosten_fuer_Bohrungen_pro_m___Euro__pro_m': 300,
     'Saisonspeicher_Kosten_fuer_Dichtwand_pro_m2___Euro__pro_m2': 80,
     'Saisonspeicher_Kosten_fuer_Pufferspeicher_am_Saisonspeicher_pro_m3___Euro__pro_m3': 100,
     'Saisonspeicher_Mengenrabatt_Bohren__Prozent': 40,
     'Saisonspeicher_Speichertemperatur_Arbeitsspanne__K': 40,
     'Saisonspeicher_Speichertemperatur_Mittel___Grad_C': 60,
     'Saisonspeicher_Ueberlappung_der_Speicherabdeckung_ueber_den_Rand__m': 10,
     'Saisonspeicher_Waermeleitwert__trockener_sandiger_Fuellboden__W_pro_m_pro_K': 0.4,
     'Saisonspeicher_hydraulische_Leitfaehigkeit_kf_SpeicheruUmgebung__m_pro_s': 0.0001,
     'Saisonspeicher_mehrjaehrig_gemittelte_Lufttemperatur___Grad_C': 9.72,
     'Saisonspeicher_mehrjaehrig_gemittelte_Niederschlagsmenge__m_pro_a': 0.57,
     'Saisonspeicher_stroemungsaktives_Porenvolumen_bzgl_Speichervolumen__Prozent': 15,
     'Saisonspeicherverluste_durch_Waermeleitung_im_Boden__kWh_pro_a': 5000000,
     'Stromtarif__Bezug___Euro__pro_kWh': 0.22,
     'Stromtarif__Einspeisung___Euro__pro_kWh': 0.05,
     'Summe_Anzahl_Wohngebaeude': 1347,
     'Tag_': 0,
     'Temperatur_Vorlauf__Unterverteilung_erdverlegt___Grad_C': 60,
     'Transport__und_Verschattungsverluste_im_ausserstaedtischen_Kollektorfeld___Prozent': 11,
     'Transportverluste_Fernheizung__Prozent': 9,
     'Trassenlaenge_Leitung_10__m': 4400,
     'Trassenlaenge_Leitung_11__m': 1360,
     'Trassenlaenge_Leitung_1__m': 3090,
     'Trassenlaenge_Leitung_2__m': 3740,
     'Trassenlaenge_Leitung_3__m': 2140,
     'Trassenlaenge_Leitung_4__m': 3570,
     'Trassenlaenge_Leitung_5__m': 1800,
     'Trassenlaenge_Leitung_6__m': 1360,
     'Trassenlaenge_Leitung_7__m': 2560,
     'Trassenlaenge_Leitung_8__m': 2090,
     'Trassenlaenge_Leitung_9__m': 1560,
     'Verteilung_Investitionskosten_fuer_Heizkraftwerk___Euro__pro_kW': 585,
     'Verteilung_Kosten_Hauptverteilung_Kanal_mit_Rohren___Euro__pro_m': 500,
     'Verteilung_Kosten_Hausanschluss___Euro_': 3171,
     'Verteilung_Kosten_Unterverteilung_Kanal_mit_Rohren___Euro__pro_m': 222,
     'Verteilung_Kosten_Waermetauscher__DoppelnutzgSpeicher_Fernwaerme_Kollektoren_Speicher____Euro__pro_kW': 1,
     'Verteilung_Kosten_der_Umwaelzpumpen___Euro__pro_kW': 216,
     'Waermespeicherzahl_fuer_Erdboden__kWh_pro_m3_pro_K': 0.611,
     'Waermeverbrauch_unter_100_Grad__Haushalte_Gewerbe_Industrie_pro_Kopf__BRD_2017__kWh_pro_a_pro_Kopf': 10641,
     'Wartung_Heizung___Euro__pro_a_pro_Haushalt': 160,
     'Wirkungsgrad_BHKW__Prozent': 39,
     'ausserhalb_noetige_Brutto_Kollektorflaeche__ohne_Aufstellungsumgebung___m2_pro_Kopf': 28,
     'benoetigte_Endenergie_fuer_Heizung_u_Warmwasser_WW___sanierte_Gebaeude__kWh_pro_a_pro_m2': 80,
     'besiedelte_Flaeche__km2': 8.11044795918367,
     'dazu_die_moegliche_Ausnutzung_dieser_inneroertlichen_Flaechen_fuer_Kollektoren__Prozent': 80,
     'durchschnittliche_Wohnflaeche_pro_Kopf__m2_pro_Kopf': 46.5,
     'inneroertliche_Dach__und_Fassadenflaechen_fuer_Kollektoren_pro_Kopf__m2_pro_Kopf': 0,
     'mittlere_Speicherverluste_pro_Jahr__bezogen_auf_die_gespeicherte_Waerme__Prozent': 23,
     'mittlere_Zweiglaenge__m': 500.678571428572}

``` python
Bevoelkerung_Gross_Kelle__Personen=\
  \
  Einwohner_favorisiert_Gross_Kelle__Personen\
  *0.9485
```

    97.7

``` python
Bevoelkerung_Ludorf__Personen=\
  \
  Einwohner_favorisiert_Ludorf__Personen\
  *0.9485
```

    456.2

``` python
Bevoelkerung_Roebel__Personen=\
  \
  Einwohner_favorisiert_Roebel__Personen\
  *0.9485
```

    4784.2

``` python
Bevoelkerung_Gotthun__Personen=\
  \
  Einwohner_favorisiert_Gotthun__Personen\
  *0.9485
```

    300.7

``` python
Bevoelkerung_Minzow__Personen=\
  \
  Einwohner_favorisiert_Minzow__Personen\
  *0.9485
```

    338.6

``` python
Bevoelkerung_Leizen__Personen=\
  \
  Einwohner_favorisiert_Leizen__Personen\
  *0.9485
```

    455.3

``` python
Bevoelkerung_Buetow__Personen=\
  \
  Einwohner_favorisiert_Buetow__Personen\
  *0.9485
```

    169.8

``` python
Bevoelkerung_Dambeck__Personen=\
  \
  Einwohner_favorisiert_Dambeck__Personen\
  *0.9485
```

    307.3

``` python
Bevoelkerung_Bollewick__Personen=\
  \
  Einwohner_favorisiert_Bollewick__Personen\
  *0.9485
```

    608.0

``` python
Einwohner_aus_Quelle__Personen=\
  \
    Bevoelkerung_Gross_Kelle__Personen\
    + Bevoelkerung_Ludorf__Personen\
    + Bevoelkerung_Roebel__Personen\
    + Bevoelkerung_Gotthun__Personen\
    + Bevoelkerung_Minzow__Personen\
    + Bevoelkerung_Leizen__Personen\
    + Bevoelkerung_Buetow__Personen\
    + Bevoelkerung_Dambeck__Personen\
    + Bevoelkerung_Bollewick__Personen
```

    7517.8

``` python
Flaeche_pro_Wohngebaeude__m2=\
  \
    Flaeche_Summe__m2\
    /Summe_Anzahl_Wohngebaeude
```

    6021.1

``` python
Grundstueckslaenge__m=\
  \
  Flaeche_pro_Wohngebaeude__m2\
  **\
  0.5
```

    77.6

``` python
Bewohner_pro_Wohngebaeude=\
  \
    Einwohner_aus_Quelle__Personen\
    /Summe_Anzahl_Wohngebaeude
```

    5.6

``` python
mittlere_Zweiglaenge__Unterverteilung_erdverlegt__m=\
  \
  mittlere_Zweiglaenge__m
```

    500.7

``` python
Bevoelkerung_Ludorf__Personen=\
  \
  Bevoelkerung_Ludorf__Personen
```

    456.2

``` python
Bevoelkerung_Roebel__Personen=\
  \
  Bevoelkerung_Roebel__Personen
```

    4784.2

``` python
Bevoelkerung_Gross_Kelle__Personen=\
  \
  Bevoelkerung_Gross_Kelle__Personen
```

    97.7

``` python
Bevoelkerung_Gotthun__Personen=\
  \
  Bevoelkerung_Gotthun__Personen
```

    300.7

``` python
Bevoelkerung_Minzow__Personen=\
  \
  Bevoelkerung_Minzow__Personen
```

    338.6

``` python
Bevoelkerung_Leizen__Personen=\
  \
  Bevoelkerung_Leizen__Personen
```

    455.3

``` python
Bevoelkerung_Buetow__Personen=\
  \
  Bevoelkerung_Buetow__Personen
```

    169.8

``` python
Bevoelkerung_Dambeck__Personen=\
  \
  Bevoelkerung_Dambeck__Personen
```

    307.3

``` python
Bevoelkerung_Bollewick__Personen=\
  \
  Bevoelkerung_Bollewick__Personen
```

    608.0

``` python
versorgte_Bewohner_Leitung_1_=\
  \
  Bevoelkerung_Ludorf__Personen\
  +Bevoelkerung_Roebel__Personen
```

    5240.5

``` python
versorgte_Bewohner_Leitung_2_=\
  \
  Bevoelkerung_Ludorf__Personen
```

    456.2

``` python
versorgte_Bewohner_Leitung_3_=\
  \
  Bevoelkerung_Roebel__Personen\
  /3
```

    1594.7

``` python
versorgte_Bewohner_Leitung_4_=\
  \
  Bevoelkerung_Gross_Kelle__Personen\
  +Bevoelkerung_Gotthun__Personen
```

    398.4

``` python
versorgte_Bewohner_Leitung_5_=\
  \
  Bevoelkerung_Gotthun__Personen
```

    300.7

``` python
versorgte_Bewohner_Leitung_6_=\
  \
  Bevoelkerung_Gross_Kelle__Personen
```

    97.7

``` python
versorgte_Bewohner_Leitung_7_=\
  \
  Bevoelkerung_Minzow__Personen
```

    338.6

``` python
versorgte_Bewohner_Leitung_8_=\
  \
  Bevoelkerung_Leizen__Personen
```

    455.3

``` python
versorgte_Bewohner_Leitung_9_=\
  \
  Bevoelkerung_Buetow__Personen
```

    169.8

``` python
versorgte_Bewohner_Leitung_10_=\
  \
  Bevoelkerung_Buetow__Personen\
  +Bevoelkerung_Leizen__Personen\
  +Bevoelkerung_Dambeck__Personen\
  +Bevoelkerung_Minzow__Personen
```

    1271.0

``` python
versorgte_Bewohner_Leitung_11_=\
  \
  Bevoelkerung_Bollewick__Personen
```

    608.0

``` python
Gebaeudeanzahl_bis_Abschnittende_Zweigabschnitt_1_bei_Auslegungsleistung_=\
  \
    mittlere_Zweiglaenge__Unterverteilung_erdverlegt__m\
    /Grundstueckslaenge__m/2
```

    3.2

``` python
endet_bei_Meter_Zweigabschnitt_1_bei_Auslegungsleistung_=\
  \
  mittlere_Zweiglaenge__Unterverteilung_erdverlegt__m\
  /2
```

    250.3

``` python
Variation_der_taeglichen_Globalstrahlung_um_dieses_Mittel_im_Jahreslauf___plusminus___kWh_pro_m2_pro_d=\
  \
  (Globalstrahlung_im_Juni__langjaehriges_Mittel__Berlin___kWh_pro_m2\
  -Globalstrahlung_im_Dezember__langjaehriges_Mittel__Berlin___kWh_pro_m2\
  )/2/30.44
```

    2.5

``` python
Gesamt_Wirkungsgrad_der_Kollektoren__Prozent=\
  \
  (Jahresertrag_der_Roehrenkollektoren__Wuerzburg_bei_T_gleich_75_Grad_C__Ritter_CPC_XL_1921__kWh_pro_a_pro_m2\
  *Anteil_an_Roehrenkollektoren__Prozent\
  /100+Jahresertrag_Flachkollektoren__Wuerzburg_bei_T_gleich_50_Grad_C__SUNEX_SA_AMP_2__kWh_pro_a_pro_m2\
  *(1-Anteil_an_Roehrenkollektoren__Prozent\
  /100))/1244*Effizienznachlass_der_Kollektoren_im_langjaehrigen_Praxisbetrieb_auf__Prozent
```

    28.5

``` python
Geschwindigkeit_des_Waermetraegers_bei_Auslegungsleistung_in_UV__m_pro_s=\
  \
  2*Norm_Geschwindigkeit_des_Waermetraegers_in_Unterverteilung__UV___m_pro_s
```

    1.8

``` python
Kollektorflaeche_brutto__inneroertlich_moeglich__m2_pro_Kopf=\
  \
  inneroertliche_Dach__und_Fassadenflaechen_fuer_Kollektoren_pro_Kopf__m2_pro_Kopf\
  *dazu_die_moegliche_Ausnutzung_dieser_inneroertlichen_Flaechen_fuer_Kollektoren__Prozent\
  /100
```

    0.0

``` python
Globalstrahlung_in_einem_Jahr__langjaehriges_Mittel__Berlin___kWh_pro_a_pro_m2=\
  \
  (Globalstrahlung_im_Dezember__langjaehriges_Mittel__Berlin___kWh_pro_m2\
  /31+Globalstrahlung_im_Juni__langjaehriges_Mittel__Berlin___kWh_pro_m2\
  /30)/2*365
```

    1086.4

``` python
Verteilung_mittlere_Laenge_eines_Unterverteilungszweiges__m=\
  \
  mittlere_Zweiglaenge__m
```

    500.7

``` python
Trassenlaenge_Leitung___m=\
  \
    Trassenlaenge_Leitung_1__m\
    +Trassenlaenge_Leitung_2__m\
    +Trassenlaenge_Leitung_3__m\
    +Trassenlaenge_Leitung_4__m\
    +Trassenlaenge_Leitung_5__m\
    +Trassenlaenge_Leitung_6__m\
    +Trassenlaenge_Leitung_7__m\
    +Trassenlaenge_Leitung_8__m\
    +Trassenlaenge_Leitung_9__m\
    +Trassenlaenge_Leitung_10__m\
    +Trassenlaenge_Leitung_11__m
```

    27670

``` python
komplett_mit_Waerme_versorgte_Geschossflaeche_pro_Kopf__Wohnung_u_Gewerbe___m2=\
  \
  durchschnittliche_Wohnflaeche_pro_Kopf__m2_pro_Kopf\
  /(1-Anteil_der_Nichtwohngebaeude_am_Endenergieverbrauch__Prozent\
  /100)
```

    73.8

``` python
Endenergie_Direktbezug_aus_Kollektoren__am_Saisonspeicher_vorbei__Jahressumme__kWh_pro_d_pro_Kopf=\
  \
    sum(kurven["Endenergie_Direktbezug_aus_Kollektoren__am_Saisonspeicher_vorbei"])/2
```

    2689.7

``` python
Endenergie__EE__Verbrauch_fuer_Heizung_u_Warmwasser__Jahressumme__kWh_pro_d_pro_Kopf=\
  \
    sum(kurven["Endenergie__EE__Verbrauch__fuer_Heizung_u_Warmwasser"])/2
```

    5912.9

``` python
Globalstrahlung_in_einem_Jahr__langjaehriges_Mittel__Berlin___kWh_pro_a_pro_m2=\
  \
  Globalstrahlung_in_einem_Jahr__langjaehriges_Mittel__Berlin___kWh_pro_a_pro_m2
```

    1086.4

``` python
Investition_Technikgebaeude_am_Speicherrand__geschaetzt___Euro_=\
  \
  Saisonspeicher_Kosten_Technikgebaeude_am_Speicherrand___Euro_
```

    400000

``` python
Kollektoren_noetiger_Pufferspeicher_im_Haus_pro_Person__l_pro_Kopf=\
  \
  Kollektoren_Maximal_moegliche_taegliche_Globalstrahlung__kWh_pro_d_pro_m2\
  *inneroertliche_Dach__und_Fassadenflaechen_fuer_Kollektoren_pro_Kopf__m2_pro_Kopf\
  *dazu_die_moegliche_Ausnutzung_dieser_inneroertlichen_Flaechen_fuer_Kollektoren__Prozent\
  /100*Jahresertrag_der_Roehrenkollektoren__Wuerzburg_bei_T_gleich_75_Grad_C__Ritter_CPC_XL_1921__kWh_pro_a_pro_m2\
  /Kollektoren_Globalstrahlung_Wuerzburg_langjaehriges_Mittel_Standort_fuer_Kollektorvergleich_Keymark__kWh_pro_m2\
  *Effizienznachlass_der_Kollektoren_im_langjaehrigen_Praxisbetrieb_auf__Prozent\
  /100*3600/4.2/40*18/24
```

    0.0

``` python
Verteilung_Anzahl_der_Wohngebaeude_im_Plangebiet_dieser_Tabelle__Gebaeude=\
  \
  Summe_Anzahl_Wohngebaeude
```

    1347

``` python
Hauptverteilung_Gesamtlaenge_aller_Hauptverteilungstrassen__jeweils_3_Leitungen___km=\
  \
  Trassenlaenge_Leitung___m\
  /1000
```

    27.7

``` python
komplett_mit_Waerme_versorgte_Geschossflaeche_pro_Kopf__Wohnung_u_Gewerbe___m2=\
  \
  komplett_mit_Waerme_versorgte_Geschossflaeche_pro_Kopf__Wohnung_u_Gewerbe___m2
```

    73.8

``` python
Anteil_Endenergie_Direktbezug_aus_Kollektoren__am_Saisonspeicher_vorbei__Prozent=\
  \
  Endenergie_Direktbezug_aus_Kollektoren__am_Saisonspeicher_vorbei__Jahressumme__kWh_pro_d_pro_Kopf\
  /Endenergie__EE__Verbrauch_fuer_Heizung_u_Warmwasser__Jahressumme__kWh_pro_d_pro_Kopf\
  *100
```

    45.5

``` python
Investition_Waermespeicher_in_den_Gebaeuden___Euro_=\
  \
  Kollektoren_noetiger_Pufferspeicher_im_Haus_pro_Person__l_pro_Kopf\
  *Kollektoren_Preis_der_Pufferspeicher_im_Haus___Euro__pro_l\
  *Bevoelkerung__Personen
```

    0.0

``` python
Investition_Fernwaermeleitungen_fuer_Hauptverteilung___Euro_=\
  \
  Verteilung_Kosten_Hauptverteilung_Kanal_mit_Rohren___Euro__pro_m\
  *Hauptverteilung_Gesamtlaenge_aller_Hauptverteilungstrassen__jeweils_3_Leitungen___km\
  *1000
```

    13835000.0

``` python
Abschreibungsjahre_fuer_Umwaelzpumpen_Unterverteilung_=\
  \
  Abschreibungsjahre_fuer_Kosten_der_Umwaelzpumpen_
```

    20

``` python
Abschreibungsjahre_fuer_Umwaelzpumpen_Hauptverteilung_=\
  \
  Abschreibungsjahre_fuer_Kosten_der_Umwaelzpumpen_
```

    20

``` python
Abschreibungsjahre_fuer_Kollektoren_=\
  \
  Abschreibungsjahre_fuer_Bruttopreis_der_eingesetzten_Roehrenkollektoren__Ritter_CPC_XL_1921_
```

    25

``` python
Abschreibungsjahre_fuer_Aufstellung__Installation_der_Kollektoren_=\
  \
  Abschreibungsjahre_fuer_Brutto_Kosten_fuer_Montage_und_Installationsmaterial_Kollektorfeld_
```

    40

``` python
Abschreibungsjahre_fuer_Waermespeicher_in_den_Gebaeuden_=\
  \
  Abschreibungsjahre_fuer_Preis_der_Pufferspeicher_im_Haus_
```

    25

``` python
Abschreibungsjahre_fuer_Fernwaermeleitungen_fuer_Unterverteilung_und_Hausanschluesse_=\
  \
  Abschreibungsjahre_fuer_Kosten_Hausanschluss_
```

    25

``` python
Abschreibungsjahre_fuer_Fernwaermeleitungen_fuer_Hauptverteilung_=\
  \
  Abschreibungsjahre_fuer_Kosten_Hauptverteilung_Kanal_mit_Rohren_
```

    25

``` python
Endenergie_fuer_Heizung_u_WW__Wohn_uNichtwohngebaeude__nach_moderater_Sanierung__kWh_pro_a_pro_Kopf=\
  \
  benoetigte_Endenergie_fuer_Heizung_u_Warmwasser_WW___sanierte_Gebaeude__kWh_pro_a_pro_m2\
  *komplett_mit_Waerme_versorgte_Geschossflaeche_pro_Kopf__Wohnung_u_Gewerbe___m2
```

    5904.8

``` python
moeglicher_Anteil_an_direkter_Waermeversorgung__am_Speicher_vorbei__Prozent=\
  \
  Anteil_Endenergie_Direktbezug_aus_Kollektoren__am_Saisonspeicher_vorbei__Prozent
```

    45.5

``` python
mittlere_Speicherverluste_pro_Jahr__Prozent=\
  \
  mittlere_Speicherverluste_pro_Jahr__bezogen_auf_die_gespeicherte_Waerme__Prozent
```

    23

``` python
Investitionskosten_Waermespeicher_in_den_Gebaeuden___Euro__pro_a_pro_Kopf=\
  \
  Investition_Waermespeicher_in_den_Gebaeuden___Euro_\
  /Abschreibungsjahre_fuer_Waermespeicher_in_den_Gebaeuden_\
  /Bevoelkerung__Personen
```

    0.0

``` python
Investitionskosten_Fernwaermeleitungen_fuer_Hauptverteilung___Euro__pro_a_pro_Kopf=\
  \
  Investition_Fernwaermeleitungen_fuer_Hauptverteilung___Euro_\
  /Abschreibungsjahre_fuer_Fernwaermeleitungen_fuer_Hauptverteilung_\
  /Bevoelkerung__Personen
```

    73.6

``` python
laufende_Kosten_Betrieb__Wartung___Euro__pro_a=\
  \
  Wartung_Heizung___Euro__pro_a_pro_Haushalt\
  /1.97*Bevoelkerung__Personen
```

    610599.0

``` python
Waermebedarf_bis100_Grad_2017__Haushalte_Gewerbe_Industrie__u_Verlustausgleich__kWh_pro_a=\
  \
  Waermeverbrauch_unter_100_Grad__Haushalte_Gewerbe_Industrie_pro_Kopf__BRD_2017__kWh_pro_a_pro_Kopf\
  *Bevoelkerung__Personen\
  /(1-Transportverluste_Fernheizung__Prozent\
  /100)
```

    87911030.8

``` python
Jahreswaermebedarf__Wohn_u_Nichtwohn_Heizg_u_WW___saniert__u_Verlustausgleich_JWBwnhwsv__kWh_pro_a=\
  \
  Bevoelkerung__Personen\
  *Endenergie_fuer_Heizung_u_WW__Wohn_uNichtwohngebaeude__nach_moderater_Sanierung__kWh_pro_a_pro_Kopf\
  /(1-Transportverluste_Fernheizung__Prozent\
  /100)*((1-moeglicher_Anteil_an_direkter_Waermeversorgung__am_Speicher_vorbei__Prozent\
  /100)/(1-mittlere_Speicherverluste_pro_Jahr__Prozent\
  /100)+moeglicher_Anteil_an_direkter_Waermeversorgung__am_Speicher_vorbei__Prozent\
  /100)
```

    56725455.6

``` python
laufende_Kosten_Betrieb__Wartung___Euro__pro_a_pro_Kopf=\
  \
  laufende_Kosten_Betrieb__Wartung___Euro__pro_a\
  /Bevoelkerung__Personen
```

    81.2

``` python
Abschreibungsjahre_fuer_BHKW__ohne_Energiekosten__=\
  \
  Abschreibungsjahre_fuer_Investitionskosten_fuer_Heizkraftwerk_
```

    30

``` python
laufende_Kosten_Energiekosten_BHKW___Euro__pro_a=\
  \
  (Waermebedarf_bis100_Grad_2017__Haushalte_Gewerbe_Industrie__u_Verlustausgleich__kWh_pro_a\
  -Jahreswaermebedarf__Wohn_u_Nichtwohn_Heizg_u_WW___saniert__u_Verlustausgleich_JWBwnhwsv__kWh_pro_a\
  )*(100/(100-Wirkungsgrad_BHKW__Prozent\
  ))*Gastarif___Euro__pro_kWh
```

    2556194.7

``` python
laufende_Kosten_Ertrag_BHKW__Elektroenergie___Euro__pro_a=\
  \
  -(Waermebedarf_bis100_Grad_2017__Haushalte_Gewerbe_Industrie__u_Verlustausgleich__kWh_pro_a\
  -Jahreswaermebedarf__Wohn_u_Nichtwohn_Heizg_u_WW___saniert__u_Verlustausgleich_JWBwnhwsv__kWh_pro_a\
  )*(Wirkungsgrad_BHKW__Prozent\
  /(100-Wirkungsgrad_BHKW__Prozent\
  ))*Stromtarif__Einspeisung___Euro__pro_kWh
```

    -996915.9

``` python
laufende_Kosten_Energiekosten_BHKW___Euro__pro_a_pro_Kopf=\
  \
  laufende_Kosten_Energiekosten_BHKW___Euro__pro_a\
  /Bevoelkerung__Personen
```

    340.0

``` python
laufende_Kosten_Ertrag_BHKW__Elektroenergie___Euro__pro_a_pro_Kopf=\
  \
  laufende_Kosten_Ertrag_BHKW__Elektroenergie___Euro__pro_a\
  /Bevoelkerung__Personen
```

    -132.6

``` python
Verteilung_mittlere_zu_einem_Gebaeude_gehoerige_Siedlungsflaeche__m2=\
  \
  besiedelte_Flaeche__km2\
  *1000000/Verteilung_Anzahl_der_Wohngebaeude_im_Plangebiet_dieser_Tabelle__Gebaeude
```

    6021.1

``` python
Jahresmittelwert_der_taeglichen_Globalstrahlung__kWh_pro_m2_pro_d=\
  \
  Globalstrahlung_in_einem_Jahr__langjaehriges_Mittel__Berlin___kWh_pro_a_pro_m2\
  /365
```

    3.0

``` python
Vom_Jahreswaermebedarf_JWBwnhwsv_muessen_gespeichert_werden__kWh_pro_a=\
  \
  Jahreswaermebedarf__Wohn_u_Nichtwohn_Heizg_u_WW___saniert__u_Verlustausgleich_JWBwnhwsv__kWh_pro_a\
  *(1-moeglicher_Anteil_an_direkter_Waermeversorgung__am_Speicher_vorbei__Prozent\
  /100)
```

    30921759.8

``` python
Verteilung_mittlere_Seitenlaenge_des_einem_Gebaeude_zugeordneten_Flaechenstueckes__m=\
  \
  Verteilung_mittlere_zu_einem_Gebaeude_gehoerige_Siedlungsflaeche__m2\
  **\
  0.5
```

    77.6

``` python
beim_Verbraucher_verfuegbare_EE_aus_inneroertlichen_Kollektoren__kWh_pro_d_pro_Kopf=\
  \
  (Jahresmittelwert_der_taeglichen_Globalstrahlung__kWh_pro_m2_pro_d\
  +Variation_der_taeglichen_Globalstrahlung_um_dieses_Mittel_im_Jahreslauf___plusminus___kWh_pro_m2_pro_d\
  *np.sin(\
  2*np.pi\
  /365*Tag_\
  ))*Gesamt_Wirkungsgrad_der_Kollektoren__Prozent\
  /100*inneroertliche_Dach__und_Fassadenflaechen_fuer_Kollektoren_pro_Kopf__m2_pro_Kopf\
  *dazu_die_moegliche_Ausnutzung_dieser_inneroertlichen_Flaechen_fuer_Kollektoren__Prozent\
  /100
```

    0.0

``` python
beim_Verbraucher_verfuegbare_EE_aus_externen_Kollektoren__kWh_pro_d_pro_Kopf=\
  \
  (Jahresmittelwert_der_taeglichen_Globalstrahlung__kWh_pro_m2_pro_d\
  +Variation_der_taeglichen_Globalstrahlung_um_dieses_Mittel_im_Jahreslauf___plusminus___kWh_pro_m2_pro_d\
  *np.sin(\
  2*np.pi\
  /365*Tag_\
  ))*Gesamt_Wirkungsgrad_der_Kollektoren__Prozent\
  /100*ausserhalb_noetige_Brutto_Kollektorflaeche__ohne_Aufstellungsumgebung___m2_pro_Kopf\
  *(1-Transport__und_Verschattungsverluste_im_ausserstaedtischen_Kollektorfeld___Prozent\
  /100)*(1-Transportverluste_Fernheizung__Prozent\
  /100)
```

    19.3

``` python
Endenergie_Tagesverbrauch_fuer_Waerme_pro_Person__Jahresdurchschnitt__kWh_pro_d_pro_Kopf=\
  \
  komplett_mit_Waerme_versorgte_Geschossflaeche_pro_Kopf__Wohnung_u_Gewerbe___m2\
  *benoetigte_Endenergie_fuer_Heizung_u_Warmwasser_WW___sanierte_Gebaeude__kWh_pro_a_pro_m2\
  /365
```

    16.2

``` python
SpeicherVolumen__m3=\
  \
  Vom_Jahreswaermebedarf_JWBwnhwsv_muessen_gespeichert_werden__kWh_pro_a\
  /Waermespeicherzahl_fuer_Erdboden__kWh_pro_m3_pro_K\
  /Saisonspeicher_Speichertemperatur_Arbeitsspanne__K
```

    1265211.1

``` python
Verteilung_mittlere_Anzahl_der_Grundstuecke_an_einem_Unterverteilungszweig__Grundst_pro_Zw=\
  \
  Verteilung_mittlere_Laenge_eines_Unterverteilungszweiges__m\
  /Verteilung_mittlere_Seitenlaenge_des_einem_Gebaeude_zugeordneten_Flaechenstueckes__m
```

    6.5

``` python
Endenergie__EE__Verbrauch_fuer_Heizung_u_Warmwasser__kWh_pro_d_pro_Kopf=\
  \
  Endenergie_Tagesverbrauch_fuer_Waerme_pro_Person__Jahresdurchschnitt__kWh_pro_d_pro_Kopf\
  -Endenergie_Tagesverbrauch_fuer_Waerme_pro_Person__Jahresdurchschnitt__kWh_pro_d_pro_Kopf\
  *np.sin(\
  2*np.pi\
  /365*Tag_\
  )
```

    16.2

``` python
als_SpeicherDurchmesser_ergibt_sich_nach_der_Vorgabe_der_Tiefe_in_D105___m=\
  \
  (SpeicherVolumen__m3\
  /Moeglichkeit_zur_Eingabe_einer_anderen_Speichertiefe__m\
  *4/np.pi\
  )**\
  0.5
```

    117.8

``` python
Verteilung_Anzahl_der_Unterverteilungszweige__Zweige=\
  \
  Verteilung_Anzahl_der_Wohngebaeude_im_Plangebiet_dieser_Tabelle__Gebaeude\
  /Verteilung_mittlere_Anzahl_der_Grundstuecke_an_einem_Unterverteilungszweig__Grundst_pro_Zw
```

    208.8

``` python
thermische_Auslegungsleistung_Blockheizkraftwerk__MW_thermisch=\
  \
  (Waermebedarf_bis100_Grad_2017__Haushalte_Gewerbe_Industrie__u_Verlustausgleich__kWh_pro_a\
  -Jahreswaermebedarf__Wohn_u_Nichtwohn_Heizg_u_WW___saniert__u_Verlustausgleich_JWBwnhwsv__kWh_pro_a\
  )/(180*24)/1000*2
```

    14.4

``` python
Investition_Saisonspeicher__Abdeckung___Euro_=\
  \
  np.pi\
  /4*(als_SpeicherDurchmesser_ergibt_sich_nach_der_Vorgabe_der_Tiefe_in_D105___m\
  +Saisonspeicher_Ueberlappung_der_Speicherabdeckung_ueber_den_Rand__m\
  *2)**\
  2*(Saisonspeicher_Kosten_fuer_Abdeckung_mit_2_Folien_pro_m2___Euro__pro_m2\
  +Saisonspeicher_Kosten_fuer_Aushub_u_Erdbewegung___Euro__pro_m3\
  *Saisonspeicher_Hoehe_der_trockenen_Fuellbodenabdeckung__m\
  )
```

    408899.3

``` python
Investition_Saisonspeicher__Schlitzwand___Euro_=\
  \
  np.pi\
  *als_SpeicherDurchmesser_ergibt_sich_nach_der_Vorgabe_der_Tiefe_in_D105___m\
  *Moeglichkeit_zur_Eingabe_einer_anderen_Speichertiefe__m\
  *Saisonspeicher_Kosten_fuer_Dichtwand_pro_m2___Euro__pro_m2
```

    3435622.3

``` python
Unterverteilung_Gesamtlaenge_aller_Unterverteilungszweige__jeweils_3_Leitungen___km=\
  \
  Verteilung_mittlere_Laenge_eines_Unterverteilungszweiges__m\
  *Verteilung_Anzahl_der_Unterverteilungszweige__Zweige\
  /1000
```

    104.5

``` python
Auslegungsleistung__Maximal_noetige_Heizleistung_saniert___kW_pro_Kopf=\
  \
  (Endenergie_fuer_Heizung_u_WW__Wohn_uNichtwohngebaeude__nach_moderater_Sanierung__kWh_pro_a_pro_Kopf\
  -Endenergie_nur_fuer_Warmwasser_WW__fuer_alle_Gebaeude_pro_Kopf__kWh_pro_a_pro_Kopf\
  *6/12)/180/24*2
```

    2.4

``` python
erforderliche_Zusatzleistung_Blockheizkraftwerk__BHKW__thermisch__MW_thermisch=\
  \
  thermische_Auslegungsleistung_Blockheizkraftwerk__MW_thermisch
```

    14.4

``` python
Kollektorflaeche_brutto__optimal_orientiert__ohne_Aufstellungsumgebung__m2=\
  \
  Jahreswaermebedarf__Wohn_u_Nichtwohn_Heizg_u_WW___saniert__u_Verlustausgleich_JWBwnhwsv__kWh_pro_a\
  /((Jahresertrag_der_Roehrenkollektoren__Wuerzburg_bei_T_gleich_75_Grad_C__Ritter_CPC_XL_1921__kWh_pro_a_pro_m2\
  *Anteil_an_Roehrenkollektoren__Prozent\
  /100+Jahresertrag_Flachkollektoren__Wuerzburg_bei_T_gleich_50_Grad_C__SUNEX_SA_AMP_2__kWh_pro_a_pro_m2\
  *(1-Anteil_an_Roehrenkollektoren__Prozent\
  /100))*(Effizienznachlass_der_Kollektoren_im_langjaehrigen_Praxisbetrieb_auf__Prozent\
  /100)*(1-Transport__und_Verschattungsverluste_im_ausserstaedtischen_Kollektorfeld___Prozent\
  /100)*(Globalstrahlung_in_einem_Jahr__langjaehriges_Mittel__Berlin___kWh_pro_a_pro_m2\
  /Kollektoren_Globalstrahlung_Wuerzburg_langjaehriges_Mittel_Standort_fuer_Kollektorvergleich_Keymark__kWh_pro_m2\
  ))
```

    188544.7

``` python
Investition_Kollektoren___Euro_=\
  \
  Kollektorflaeche_brutto__optimal_orientiert__ohne_Aufstellungsumgebung__m2\
  *(Kollektoren_Bruttopreis_der_eingesetzten_Roehrenkollektoren__Ritter_CPC_XL_1921___Euro__pro_m2\
  *Anteil_an_Roehrenkollektoren__Prozent\
  /100+Kollektoren_Bruttopreis_der_eingesetzten_Flachkollektoren__SUNEX_SA_AMP_20___Euro__pro_m2\
  *(1-Anteil_an_Roehrenkollektoren__Prozent\
  /100))*(1-Kollektoren_Mengenrabatt_Kollektoren_und_Installation__Prozent\
  /100)
```

    29382799.2

``` python
Investition_Aufstellung__Installation_der_Kollektoren___Euro_=\
  \
  Kollektorflaeche_brutto__optimal_orientiert__ohne_Aufstellungsumgebung__m2\
  *Kollektoren_Brutto_Kosten_fuer_Montage_und_Installationsmaterial_Kollektorfeld___Euro__pro_m2\
  *(1-Kollektoren_Mengenrabatt_Kollektoren_und_Installation__Prozent\
  /100)
```

    28357116.3

``` python
Investition_Fernwaermeleitungen_fuer_Unterverteilung_und_Hausanschluesse___Euro_=\
  \
  (Verteilung_Kosten_Unterverteilung_Kanal_mit_Rohren___Euro__pro_m\
  *Unterverteilung_Gesamtlaenge_aller_Unterverteilungszweige__jeweils_3_Leitungen___km\
  *1000)+Verteilung_Kosten_Hausanschluss___Euro_\
  *Verteilung_Anzahl_der_Wohngebaeude_im_Plangebiet_dieser_Tabelle__Gebaeude
```

    27475141.3

``` python
Leistung_Waermetauscher_am_Saisonspeicher__kW=\
  \
  Auslegungsleistung__Maximal_noetige_Heizleistung_saniert___kW_pro_Kopf\
  *Bevoelkerung__Personen
```

    18051.1

``` python
BHKW_elektrische_Leistung__MW_elektrisch=\
  \
  erforderliche_Zusatzleistung_Blockheizkraftwerk__BHKW__thermisch__MW_thermisch\
  /(100-Wirkungsgrad_BHKW__Prozent\
  )*Wirkungsgrad_BHKW__Prozent
```

    9.2

``` python
Investitionskosten_Kollektoren___Euro__pro_a_pro_Kopf=\
  \
  Investition_Kollektoren___Euro_\
  /Abschreibungsjahre_fuer_Kollektoren_\
  /Bevoelkerung__Personen
```

    156.3

``` python
Investitionskosten_Aufstellung__Installation_der_Kollektoren___Euro__pro_a_pro_Kopf=\
  \
  Investition_Aufstellung__Installation_der_Kollektoren___Euro_\
  /Abschreibungsjahre_fuer_Aufstellung__Installation_der_Kollektoren_\
  /Bevoelkerung__Personen
```

    94.3

``` python
Investitionskosten_Fernwaermeleitungen_fuer_Unterverteilung_und_Hausanschluesse___Euro__pro_a_pro_Kopf=\
  \
  Investition_Fernwaermeleitungen_fuer_Unterverteilung_und_Hausanschluesse___Euro_\
  /Abschreibungsjahre_fuer_Fernwaermeleitungen_fuer_Unterverteilung_und_Hausanschluesse_\
  /Bevoelkerung__Personen
```

    146.2

``` python
laufende_Kosten_Waermetauscher_wechseln___Euro__pro_a=\
  \
  Leistung_Waermetauscher_am_Saisonspeicher__kW\
  *Verteilung_Kosten_Waermetauscher__DoppelnutzgSpeicher_Fernwaerme_Kollektoren_Speicher____Euro__pro_kW
```

    18051.1

``` python
Kosten_fuer_Blockheizkraftwerke_zur_Temperaturanhebung_in_der_dritten_Leitung__Millionen__Euro_=\
  \
  BHKW_elektrische_Leistung__MW_elektrisch\
  *1000*Verteilung_Investitionskosten_fuer_Heizkraftwerk___Euro__pro_kW\
  /1000000
```

    5.4

``` python
laufende_Kosten_Waermetauscher___Euro__pro_a_pro_Kopf=\
  \
  laufende_Kosten_Waermetauscher_wechseln___Euro__pro_a\
  /Bevoelkerung__Personen
```

    2.4

``` python
Investition_BHKW__ohne_Energiekosten____Euro_=\
  \
  Kosten_fuer_Blockheizkraftwerke_zur_Temperaturanhebung_in_der_dritten_Leitung__Millionen__Euro_\
  *1000000
```

    5399961.3

``` python
Investitionskosten_BHKW__ohne_Energiekosten____Euro__pro_a_pro_Kopf=\
  \
  Investition_BHKW__ohne_Energiekosten____Euro_\
  /Abschreibungsjahre_fuer_BHKW__ohne_Energiekosten__\
  /Bevoelkerung__Personen
```

    23.9

``` python
Saisonspeicherverluste_nach_oben__kWh_pro_a=\
  \
  Saisonspeicher_Waermeleitwert__trockener_sandiger_Fuellboden__W_pro_m_pro_K\
  /Saisonspeicher_Hoehe_der_trockenen_Fuellbodenabdeckung__m\
  *np.pi\
  /4*als_SpeicherDurchmesser_ergibt_sich_nach_der_Vorgabe_der_Tiefe_in_D105___m\
  **\
  2*(Saisonspeicher_Speichertemperatur_Mittel___Grad_C\
  -Saisonspeicher_mehrjaehrig_gemittelte_Lufttemperatur___Grad_C\
  )*24*365/1000
```

    960803.1

``` python
Saisonspeicherverluste_durch_Niederschlag_in_der_Umgebung__kWh_pro_a=\
  \
  np.pi\
  *((als_SpeicherDurchmesser_ergibt_sich_nach_der_Vorgabe_der_Tiefe_in_D105___m\
  /2+40)**\
  2-(als_SpeicherDurchmesser_ergibt_sich_nach_der_Vorgabe_der_Tiefe_in_D105___m\
  /2+Saisonspeicher_Ueberlappung_der_Speicherabdeckung_ueber_den_Rand__m\
  )**\
  2)*Saisonspeicher_mehrjaehrig_gemittelte_Niederschlagsmenge__m_pro_a\
  *1000*4.2*((Saisonspeicher_Speichertemperatur_Mittel___Grad_C\
  /2+Saisonspeicher_Bodentemperatur_in_50m_Tiefe____Grad_C\
  )/3-Saisonspeicher_mehrjaehrig_gemittelte_Lufttemperatur___Grad_C\
  )/3600
```

    45023.8

``` python
Saisonspeicherverluste_durch_regionalen_Grundwasserfluss_in_Speicherumgebung__kWh_pro_a=\
  \
  ((Moeglichkeit_zur_Eingabe_einer_anderen_Speichertiefe__m\
  +40)*(als_SpeicherDurchmesser_ergibt_sich_nach_der_Vorgabe_der_Tiefe_in_D105___m\
  +80)-(Moeglichkeit_zur_Eingabe_einer_anderen_Speichertiefe__m\
  *als_SpeicherDurchmesser_ergibt_sich_nach_der_Vorgabe_der_Tiefe_in_D105___m\
  ))*(Saisonspeicher_Grundwassergeschwindigkeit_an_Grundwasseroberflaeche__m_pro_d\
  +Saisonspeicher_Grundwassergeschwindigkeit_in_Speicherbodentiefe__m_pro_d\
  )/2*365*Saisonspeicher_stroemungsaktives_Porenvolumen_bzgl_Speichervolumen__Prozent\
  /100*1000*4.2*((Saisonspeicher_Speichertemperatur_Mittel___Grad_C\
  +Saisonspeicher_Bodentemperatur_in_50m_Tiefe____Grad_C\
  )/3-Saisonspeicher_Bodentemperatur_in_50m_Tiefe____Grad_C\
  )/3600
```

    362423.0

``` python
Saisonspeicherverluste_durch_Grundwasserkonvektion_in_der_Speicherumgebung__kWh_pro_a=\
  \
  -Saisonspeicher_hydraulische_Leitfaehigkeit_kf_SpeicheruUmgebung__m_pro_s\
  *Moeglichkeit_zur_Eingabe_einer_anderen_Speichertiefe__m\
  /1000/30*((-0.0040125*23**\
  2-0.028625*23+1000.3875)-(-0.0040125*Saisonspeicher_Bodentemperatur_in_50m_Tiefe____Grad_C\
  **\
  2-0.028625*Saisonspeicher_Bodentemperatur_in_50m_Tiefe____Grad_C\
  +1000.3875))*np.pi\
  *((als_SpeicherDurchmesser_ergibt_sich_nach_der_Vorgabe_der_Tiefe_in_D105___m\
  /2+30)**\
  2-(als_SpeicherDurchmesser_ergibt_sich_nach_der_Vorgabe_der_Tiefe_in_D105___m\
  /2)**\
  2)*1000*Saisonspeicher_stroemungsaktives_Porenvolumen_bzgl_Speichervolumen__Prozent\
  /100 *4.2 *(23-Saisonspeicher_Bodentemperatur_in_50m_Tiefe____Grad_C\
  ) *24*365
```

    608259.6

``` python
Gesamtverlust_Saisonspeicher__kWh_pro_a=\
  \
    Saisonspeicherverluste_nach_oben__kWh_pro_a\
    +Saisonspeicherverluste_durch_Waermeleitung_im_Boden__kWh_pro_a\
    +Saisonspeicherverluste_durch_Niederschlag_in_der_Umgebung__kWh_pro_a\
    +Saisonspeicherverluste_durch_regionalen_Grundwasserfluss_in_Speicherumgebung__kWh_pro_a\
    +Saisonspeicherverluste_durch_Grundwasserkonvektion_in_der_Speicherumgebung__kWh_pro_a
```

    6976509.5

``` python
Jahreswaermeverlust_durch_Speicherung__kWh_pro_a=\
  \
  Gesamtverlust_Saisonspeicher__kWh_pro_a
```

    6976509.5

``` python
Normalleistung_Leitung_1__kW=\
  \
  versorgte_Bewohner_Leitung_1_\
  *Auslegungsleistung__Maximal_noetige_Heizleistung_saniert___kW_pro_Kopf\
  /2/(1-Transportverluste_Fernheizung__Prozent\
  /2/100)
```

    6587.7

``` python
Normalleistung_Leitung_2__kW=\
  \
  versorgte_Bewohner_Leitung_2_\
  *Auslegungsleistung__Maximal_noetige_Heizleistung_saniert___kW_pro_Kopf\
  /2/(1-Transportverluste_Fernheizung__Prozent\
  /2/100)
```

    573.5

``` python
Normalleistung_Leitung_3__kW=\
  \
  versorgte_Bewohner_Leitung_3_\
  *Auslegungsleistung__Maximal_noetige_Heizleistung_saniert___kW_pro_Kopf\
  /2/(1-Transportverluste_Fernheizung__Prozent\
  /2/100)
```

    2004.7

``` python
Normalleistung_Leitung_4__kW=\
  \
  versorgte_Bewohner_Leitung_4_\
  *Auslegungsleistung__Maximal_noetige_Heizleistung_saniert___kW_pro_Kopf\
  /2/(1-Transportverluste_Fernheizung__Prozent\
  /2/100)
```

    500.8

``` python
Normalleistung_Leitung_5__kW=\
  \
  versorgte_Bewohner_Leitung_5_\
  *Auslegungsleistung__Maximal_noetige_Heizleistung_saniert___kW_pro_Kopf\
  /2/(1-Transportverluste_Fernheizung__Prozent\
  /2/100)
```

    378.0

``` python
Normalleistung_Leitung_6__kW=\
  \
  versorgte_Bewohner_Leitung_6_\
  *Auslegungsleistung__Maximal_noetige_Heizleistung_saniert___kW_pro_Kopf\
  /2/(1-Transportverluste_Fernheizung__Prozent\
  /2/100)
```

    122.8

``` python
Normalleistung_Leitung_7__kW=\
  \
  versorgte_Bewohner_Leitung_7_\
  *Auslegungsleistung__Maximal_noetige_Heizleistung_saniert___kW_pro_Kopf\
  /2/(1-Transportverluste_Fernheizung__Prozent\
  /2/100)
```

    425.7

``` python
Normalleistung_Leitung_8__kW=\
  \
  versorgte_Bewohner_Leitung_8_\
  *Auslegungsleistung__Maximal_noetige_Heizleistung_saniert___kW_pro_Kopf\
  /2/(1-Transportverluste_Fernheizung__Prozent\
  /2/100)
```

    572.3

``` python
Normalleistung_Leitung_9__kW=\
  \
  versorgte_Bewohner_Leitung_9_\
  *Auslegungsleistung__Maximal_noetige_Heizleistung_saniert___kW_pro_Kopf\
  /2/(1-Transportverluste_Fernheizung__Prozent\
  /2/100)
```

    213.4

``` python
Normalleistung_Leitung_10__kW=\
  \
  versorgte_Bewohner_Leitung_10_\
  *Auslegungsleistung__Maximal_noetige_Heizleistung_saniert___kW_pro_Kopf\
  /2/(1-Transportverluste_Fernheizung__Prozent\
  /2/100)
```

    1597.8

``` python
Normalleistung_Leitung_11__kW=\
  \
  versorgte_Bewohner_Leitung_11_\
  *Auslegungsleistung__Maximal_noetige_Heizleistung_saniert___kW_pro_Kopf\
  /2/(1-Transportverluste_Fernheizung__Prozent\
  /2/100)
```

    764.3

``` python
Auslegungsleistung_zu_Beginn_des_Abschnittes_Zweigabschnitt_1_bei_Auslegungsleistung__kW=\
  \
  Auslegungsleistung__Maximal_noetige_Heizleistung_saniert___kW_pro_Kopf\
  *Gebaeudeanzahl_bis_Abschnittende_Zweigabschnitt_1_bei_Auslegungsleistung_\
  *Bewohner_pro_Wohngebaeude\
  *2/(1-Transportverluste_Fernheizung__Prozent\
  /2/100)
```

    90.5

``` python
Auslegungsleistung_zu_Beginn_des_Abschnittes_Zweigabschnitt_2_bei_Auslegungsleistung__kW=\
  \
  Auslegungsleistung__Maximal_noetige_Heizleistung_saniert___kW_pro_Kopf\
  *Gebaeudeanzahl_bis_Abschnittende_Zweigabschnitt_1_bei_Auslegungsleistung_\
  *Bewohner_pro_Wohngebaeude\
  /(1-Transportverluste_Fernheizung__Prozent\
  /2/100)
```

    45.3

``` python
Auslegungsleistung_Leitung_1__kW=\
  \
  Normalleistung_Leitung_1__kW\
  *2
```

    13175.5

``` python
Auslegungsleistung_Leitung_2__kW=\
  \
  Normalleistung_Leitung_2__kW\
  *2
```

    1147.0

``` python
Auslegungsleistung_Leitung_3__kW=\
  \
  Normalleistung_Leitung_3__kW\
  *2
```

    4009.5

``` python
Auslegungsleistung_Leitung_4__kW=\
  \
  Normalleistung_Leitung_4__kW\
  *2
```

    1001.6

``` python
Auslegungsleistung_Leitung_5__kW=\
  \
  Normalleistung_Leitung_5__kW\
  *2
```

    756.0

``` python
Auslegungsleistung_Leitung_6__kW=\
  \
  Normalleistung_Leitung_6__kW\
  *2
```

    245.6

``` python
Auslegungsleistung_Leitung_7__kW=\
  \
  Normalleistung_Leitung_7__kW\
  *2
```

    851.3

``` python
Auslegungsleistung_Leitung_8__kW=\
  \
  Normalleistung_Leitung_8__kW\
  *2
```

    1144.7

``` python
Auslegungsleistung_Leitung_9__kW=\
  \
  Normalleistung_Leitung_9__kW\
  *2
```

    426.9

``` python
Auslegungsleistung_Leitung_10__kW=\
  \
  Normalleistung_Leitung_10__kW\
  *2
```

    3195.5

``` python
Auslegungsleistung_Leitung_11__kW=\
  \
  Normalleistung_Leitung_11__kW\
  *2
```

    1528.6

``` python
Leitungsinnendurchmesser_Zweigabschnitt_1_bei_Auslegungsleistung__m=\
  \
  (Auslegungsleistung_zu_Beginn_des_Abschnittes_Zweigabschnitt_1_bei_Auslegungsleistung__kW\
  *4/np.pi\
  /4.2/(60-30)/1000/Geschwindigkeit_des_Waermetraegers_bei_Auslegungsleistung_in_UV__m_pro_s\
  )**\
  0.5
```

    0.0

``` python
Leitungsinnendurchmesser_Zweigabschnitt_2_bei_Auslegungsleistung__m=\
  \
  (Auslegungsleistung_zu_Beginn_des_Abschnittes_Zweigabschnitt_2_bei_Auslegungsleistung__kW\
  *4/np.pi\
  /4.2/(60-30)/1000/Geschwindigkeit_des_Waermetraegers_bei_Auslegungsleistung_in_UV__m_pro_s\
  )**\
  0.5
```

    0.0

``` python
Leitungsdurchmesser_innen_Leitung_1__m=\
  \
  (Auslegungsleistung_Leitung_1__kW\
  /4200/(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )/(60-30)*4/np.pi\
  )**\
  0.5
```

    0.2

``` python
Leitungsdurchmesser_innen_Leitung_2__m=\
  \
  (Auslegungsleistung_Leitung_2__kW\
  /4200/(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )/(60-30)*4/np.pi\
  )**\
  0.5
```

    0.1

``` python
Leitungsdurchmesser_innen_Leitung_3__m=\
  \
  (Auslegungsleistung_Leitung_3__kW\
  /4200/(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )/(60-30)*4/np.pi\
  )**\
  0.5
```

    0.1

``` python
Leitungsdurchmesser_innen_Leitung_4__m=\
  \
  (Auslegungsleistung_Leitung_4__kW\
  /4200/(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )/(60-30)*4/np.pi\
  )**\
  0.5
```

    0.1

``` python
Leitungsdurchmesser_innen_Leitung_5__m=\
  \
  (Auslegungsleistung_Leitung_5__kW\
  /4200/(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )/(60-30)*4/np.pi\
  )**\
  0.5
```

    0.1

``` python
Leitungsdurchmesser_innen_Leitung_6__m=\
  \
  (Auslegungsleistung_Leitung_6__kW\
  /4200/(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )/(60-30)*4/np.pi\
  )**\
  0.5
```

    0.0

``` python
Leitungsdurchmesser_innen_Leitung_7__m=\
  \
  (Auslegungsleistung_Leitung_7__kW\
  /4200/(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )/(60-30)*4/np.pi\
  )**\
  0.5
```

    0.1

``` python
Leitungsdurchmesser_innen_Leitung_8__m=\
  \
  (Auslegungsleistung_Leitung_8__kW\
  /4200/(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )/(60-30)*4/np.pi\
  )**\
  0.5
```

    0.1

``` python
Leitungsdurchmesser_innen_Leitung_9__m=\
  \
  (Auslegungsleistung_Leitung_9__kW\
  /4200/(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )/(60-30)*4/np.pi\
  )**\
  0.5
```

    0.0

``` python
Leitungsdurchmesser_innen_Leitung_10__m=\
  \
  (Auslegungsleistung_Leitung_10__kW\
  /4200/(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )/(60-30)*4/np.pi\
  )**\
  0.5
```

    0.1

``` python
Leitungsdurchmesser_innen_Leitung_11__m=\
  \
  (Auslegungsleistung_Leitung_11__kW\
  /4200/(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )/(60-30)*4/np.pi\
  )**\
  0.5
```

    0.1

``` python
Kollektorflaeche_brutto_pro_Kopf__m2_pro_Kopf=\
  \
  Kollektorflaeche_brutto__optimal_orientiert__ohne_Aufstellungsumgebung__m2\
  /Bevoelkerung__Personen
```

    25.1

``` python
Endenergie_Direktbezug_aus_Kollektoren__am_Saisonspeicher_vorbei__kWh_pro_d_pro_Kopf=\
  \
    Endenergie__EE__Verbrauch_fuer_Heizung_u_Warmwasser__kWh_pro_d_pro_Kopf \
    if (beim_Verbraucher_verfuegbare_EE_aus_inneroertlichen_Kollektoren__kWh_pro_d_pro_Kopf \
    + beim_Verbraucher_verfuegbare_EE_aus_externen_Kollektoren__kWh_pro_d_pro_Kopf) \
    > Endenergie__EE__Verbrauch_fuer_Heizung_u_Warmwasser__kWh_pro_d_pro_Kopf \
    else (beim_Verbraucher_verfuegbare_EE_aus_inneroertlichen_Kollektoren__kWh_pro_d_pro_Kopf \
    + beim_Verbraucher_verfuegbare_EE_aus_externen_Kollektoren__kWh_pro_d_pro_Kopf)
```

    16.2

``` python
Kollektorflaeche_brutto__extern_noetig__m2_pro_Kopf=\
  \
  Kollektorflaeche_brutto_pro_Kopf__m2_pro_Kopf\
  -Kollektorflaeche_brutto__inneroertlich_moeglich__m2_pro_Kopf
```

    25.1

``` python
externe_Kollektorfeldflaeche__brutto_u__Aufstellungsumgebung___km2=\
  \
  Kollektorflaeche_brutto__extern_noetig__m2_pro_Kopf\
  *Bevoelkerung__Personen\
  *Kollektoren_Brutto_pro_netto_Faktor_externes_Kollektorfeld_\
  /1000000
```

    0.5

``` python
Investition_Bodenpreis_fuer_externes_Kollektorfeld___Euro_=\
  \
  Kollektoren_Bodenrichtwert_Kollektorfeld___Euro__pro_m2\
  *externe_Kollektorfeldflaeche__brutto_u__Aufstellungsumgebung___km2\
  *1000000
```

    259248.9

``` python
Investitionskosten_Bodenpreis_fuer_externes_Kollektorfeld___Euro__pro_a_pro_Kopf=\
  \
  Investition_Bodenpreis_fuer_externes_Kollektorfeld___Euro_\
  /Abschreibungsjahre_fuer_Bodenpreis_fuer_externes_Kollektorfeld_\
  /Bevoelkerung__Personen
```

    0.3

``` python
Leistungsverlust_Vor_u__Ruecklauf_Leitung_1__kW=\
  \
  (50+20)*2*np.pi\
  *Leitwert_Rohr_Daemmung__Hauptverteilung_erdverlegt__W_pro_m_pro_K\
  *Trassenlaenge_Leitung_1__m\
  /np.log(\
  1+Rohr_Daemmung_Staerke__Hauptverteilung_erdverlegt__m\
  *2/Leitungsdurchmesser_innen_Leitung_1__m\
  )/1000
```

    102.0

``` python
Leistungsverlust_Vor_u__Ruecklauf_Leitung_2__kW=\
  \
  (50+20)*2*np.pi\
  *Leitwert_Rohr_Daemmung__Hauptverteilung_erdverlegt__W_pro_m_pro_K\
  *Trassenlaenge_Leitung_2__m\
  /np.log(\
  1+Rohr_Daemmung_Staerke__Hauptverteilung_erdverlegt__m\
  *2/Leitungsdurchmesser_innen_Leitung_2__m\
  )/1000
```

    52.2

``` python
Leistungsverlust_Vor_u__Ruecklauf_Leitung_3__kW=\
  \
  (50+20)*2*np.pi\
  *Leitwert_Rohr_Daemmung__Hauptverteilung_erdverlegt__W_pro_m_pro_K\
  *Trassenlaenge_Leitung_3__m\
  /np.log(\
  1+Rohr_Daemmung_Staerke__Hauptverteilung_erdverlegt__m\
  *2/Leitungsdurchmesser_innen_Leitung_3__m\
  )/1000
```

    45.1

``` python
Leistungsverlust_Vor_u__Ruecklauf_Leitung_4__kW=\
  \
  (50+20)*2*np.pi\
  *Leitwert_Rohr_Daemmung__Hauptverteilung_erdverlegt__W_pro_m_pro_K\
  *Trassenlaenge_Leitung_4__m\
  /np.log(\
  1+Rohr_Daemmung_Staerke__Hauptverteilung_erdverlegt__m\
  *2/Leitungsdurchmesser_innen_Leitung_4__m\
  )/1000
```

    47.8

``` python
Leistungsverlust_Vor_u__Ruecklauf_Leitung_5__kW=\
  \
  (50+20)*2*np.pi\
  *Leitwert_Rohr_Daemmung__Hauptverteilung_erdverlegt__W_pro_m_pro_K\
  *Trassenlaenge_Leitung_5__m\
  /np.log(\
  1+Rohr_Daemmung_Staerke__Hauptverteilung_erdverlegt__m\
  *2/Leitungsdurchmesser_innen_Leitung_5__m\
  )/1000
```

    22.2

``` python
Leistungsverlust_Vor_u__Ruecklauf_Leitung_6__kW=\
  \
  (50+20)*2*np.pi\
  *Leitwert_Rohr_Daemmung__Hauptverteilung_erdverlegt__W_pro_m_pro_K\
  *Trassenlaenge_Leitung_6__m\
  /np.log(\
  1+Rohr_Daemmung_Staerke__Hauptverteilung_erdverlegt__m\
  *2/Leitungsdurchmesser_innen_Leitung_6__m\
  )/1000
```

    12.5

``` python
Leistungsverlust_Vor_u__Ruecklauf_Leitung_7__kW=\
  \
  (50+20)*2*np.pi\
  *Leitwert_Rohr_Daemmung__Hauptverteilung_erdverlegt__W_pro_m_pro_K\
  *Trassenlaenge_Leitung_7__m\
  /np.log(\
  1+Rohr_Daemmung_Staerke__Hauptverteilung_erdverlegt__m\
  *2/Leitungsdurchmesser_innen_Leitung_7__m\
  )/1000
```

    32.7

``` python
Leistungsverlust_Vor_u__Ruecklauf_Leitung_8__kW=\
  \
  (50+20)*2*np.pi\
  *Leitwert_Rohr_Daemmung__Hauptverteilung_erdverlegt__W_pro_m_pro_K\
  *Trassenlaenge_Leitung_8__m\
  /np.log(\
  1+Rohr_Daemmung_Staerke__Hauptverteilung_erdverlegt__m\
  *2/Leitungsdurchmesser_innen_Leitung_8__m\
  )/1000
```

    29.1

``` python
Leistungsverlust_Vor_u__Ruecklauf_Leitung_9__kW=\
  \
  (50+20)*2*np.pi\
  *Leitwert_Rohr_Daemmung__Hauptverteilung_erdverlegt__W_pro_m_pro_K\
  *Trassenlaenge_Leitung_9__m\
  /np.log(\
  1+Rohr_Daemmung_Staerke__Hauptverteilung_erdverlegt__m\
  *2/Leitungsdurchmesser_innen_Leitung_9__m\
  )/1000
```

    16.5

``` python
Leistungsverlust_Vor_u__Ruecklauf_Leitung_10__kW=\
  \
  (50+20)*2*np.pi\
  *Leitwert_Rohr_Daemmung__Hauptverteilung_erdverlegt__W_pro_m_pro_K\
  *Trassenlaenge_Leitung_10__m\
  /np.log(\
  1+Rohr_Daemmung_Staerke__Hauptverteilung_erdverlegt__m\
  *2/Leitungsdurchmesser_innen_Leitung_10__m\
  )/1000
```

    85.6

``` python
Leistungsverlust_Vor_u__Ruecklauf_Leitung_11__kW=\
  \
  (50+20)*2*np.pi\
  *Leitwert_Rohr_Daemmung__Hauptverteilung_erdverlegt__W_pro_m_pro_K\
  *Trassenlaenge_Leitung_11__m\
  /np.log(\
  1+Rohr_Daemmung_Staerke__Hauptverteilung_erdverlegt__m\
  *2/Leitungsdurchmesser_innen_Leitung_11__m\
  )/1000
```

    20.7

``` python
Waermeverluste_Leitung_1__kWh_pro_a=\
  \
  Leistungsverlust_Vor_u__Ruecklauf_Leitung_1__kW\
  *24*180
```

    440491.6

``` python
Waermeverluste_Leitung_2__kWh_pro_a=\
  \
  Leistungsverlust_Vor_u__Ruecklauf_Leitung_2__kW\
  *24*180
```

    225398.4

``` python
Waermeverluste_Leitung_3__kWh_pro_a=\
  \
  Leistungsverlust_Vor_u__Ruecklauf_Leitung_3__kW\
  *24*180
```

    194637.4

``` python
Waermeverluste_Leitung_4__kWh_pro_a=\
  \
  Leistungsverlust_Vor_u__Ruecklauf_Leitung_4__kW\
  *24*180
```

    206575.3

``` python
Waermeverluste_Leitung_5__kWh_pro_a=\
  \
  Leistungsverlust_Vor_u__Ruecklauf_Leitung_5__kW\
  *24*180
```

    95956.2

``` python
Waermeverluste_Leitung_6__kWh_pro_a=\
  \
  Leistungsverlust_Vor_u__Ruecklauf_Leitung_6__kW\
  *24*180
```

    53907.1

``` python
Waermeverluste_Leitung_7__kWh_pro_a=\
  \
  Leistungsverlust_Vor_u__Ruecklauf_Leitung_7__kW\
  *24*180
```

    141224.2

``` python
Waermeverluste_Leitung_8__kWh_pro_a=\
  \
  Leistungsverlust_Vor_u__Ruecklauf_Leitung_8__kW\
  *24*180
```

    125878.6

``` python
Waermeverluste_Leitung_9__kWh_pro_a=\
  \
  Leistungsverlust_Vor_u__Ruecklauf_Leitung_9__kW\
  *24*180
```

    71097.2

``` python
Waermeverluste_Leitung_10__kWh_pro_a=\
  \
  Leistungsverlust_Vor_u__Ruecklauf_Leitung_10__kW\
  *24*180
```

    369629.8

``` python
Waermeverluste_Leitung_11__kWh_pro_a=\
  \
  Leistungsverlust_Vor_u__Ruecklauf_Leitung_11__kW\
  *24*180
```

    89562.8

``` python
Waermeverluste_Leitung___kWh_pro_a=\
  \
    Waermeverluste_Leitung_1__kWh_pro_a\
    +Waermeverluste_Leitung_2__kWh_pro_a\
    +Waermeverluste_Leitung_3__kWh_pro_a\
    +Waermeverluste_Leitung_4__kWh_pro_a\
    +Waermeverluste_Leitung_5__kWh_pro_a\
    +Waermeverluste_Leitung_6__kWh_pro_a\
    +Waermeverluste_Leitung_7__kWh_pro_a\
    +Waermeverluste_Leitung_8__kWh_pro_a\
    +Waermeverluste_Leitung_9__kWh_pro_a\
    +Waermeverluste_Leitung_10__kWh_pro_a\
    +Waermeverluste_Leitung_11__kWh_pro_a
```

    2014358.6

``` python
Hauptverteilung_Jahreswaermeverluste_der_Hauptverteilung__kWh_pro_a=\
  \
  Waermeverluste_Leitung___kWh_pro_a
```

    2014358.6

``` python
Druckabfall_pro_m_Zweigabschnitt_2_bei_Normleistung__bar=\
  \
  0.216/((Geschwindigkeit_des_Waermetraegers_bei_Auslegungsleistung_in_UV__m_pro_s\
  /2)*Leitungsinnendurchmesser_Zweigabschnitt_2_bei_Auslegungsleistung__m\
  /((1.5556*np.exp(\
  -0.0318393*Temperatur_Vorlauf__Unterverteilung_erdverlegt___Grad_C\
  )+0.2374))/10**\
  (-6))**\
  0.2*1/(Leitungsinnendurchmesser_Zweigabschnitt_2_bei_Auslegungsleistung__m\
  )*(Geschwindigkeit_des_Waermetraegers_bei_Auslegungsleistung_in_UV__m_pro_s\
  /2)**\
  2*(-0.0040125*Temperatur_Vorlauf__Unterverteilung_erdverlegt___Grad_C\
  **\
  2-0.028625*Temperatur_Vorlauf__Unterverteilung_erdverlegt___Grad_C\
  +1000.3875)/2/100000
```

    0.0

``` python
Druckabfall_pro_m_Zweigabschnitt_1_bei_Normleistung__bar=\
  \
  0.216/((Geschwindigkeit_des_Waermetraegers_bei_Auslegungsleistung_in_UV__m_pro_s\
  /2)*Leitungsinnendurchmesser_Zweigabschnitt_1_bei_Auslegungsleistung__m\
  /((1.5556*np.exp(\
  -0.0318393*Temperatur_Vorlauf__Unterverteilung_erdverlegt___Grad_C\
  )+0.2374))/10**\
  (-6))**\
  0.2*1/(Leitungsinnendurchmesser_Zweigabschnitt_1_bei_Auslegungsleistung__m\
  )*(Geschwindigkeit_des_Waermetraegers_bei_Auslegungsleistung_in_UV__m_pro_s\
  /2)**\
  2*(-0.0040125*Temperatur_Vorlauf__Unterverteilung_erdverlegt___Grad_C\
  **\
  2-0.028625*Temperatur_Vorlauf__Unterverteilung_erdverlegt___Grad_C\
  +1000.3875)/2/100000
```

    0.0

``` python
Druckabfall_am_Abschnitt_Doppelleitung_Zweigabschnitt_2_bei_Normleistung__bar=\
  \
  Druckabfall_pro_m_Zweigabschnitt_2_bei_Normleistung__bar\
  *endet_bei_Meter_Zweigabschnitt_1_bei_Auslegungsleistung_\
  *2
```

    3.4

``` python
Druckabfall_am_Abschnitt_Doppelleitung_Zweigabschnitt_1_bei_Normleistung__bar=\
  \
  Druckabfall_pro_m_Zweigabschnitt_1_bei_Normleistung__bar\
  *endet_bei_Meter_Zweigabschnitt_1_bei_Auslegungsleistung_\
  *2
```

    2.3

``` python
Druckverlust_auf_Vorlaufleitung_bei_Normalleistung_Leitung_1__bar=\
  \
  (0.657/Leitungsdurchmesser_innen_Leitung_1__m\
  -0.058)*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  **\
  1.92/10000*Trassenlaenge_Leitung_1__m\
  *1.5
```

    1.8

``` python
Druckverlust_auf_Vorlaufleitung_bei_Normalleistung_Leitung_2__bar=\
  \
  (0.657/Leitungsdurchmesser_innen_Leitung_2__m\
  -0.058)*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  **\
  1.92/10000*Trassenlaenge_Leitung_2__m\
  *1.5
```

    7.5

``` python
Druckverlust_auf_Vorlaufleitung_bei_Normalleistung_Leitung_3__bar=\
  \
  (0.657/Leitungsdurchmesser_innen_Leitung_3__m\
  -0.058)*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  **\
  1.92/10000*Trassenlaenge_Leitung_3__m\
  *1.5
```

    2.3

``` python
Druckverlust_auf_Vorlaufleitung_bei_Normalleistung_Leitung_4__bar=\
  \
  (0.657/Leitungsdurchmesser_innen_Leitung_4__m\
  -0.058)*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  **\
  1.92/10000*Trassenlaenge_Leitung_4__m\
  *1.5
```

    7.6

``` python
Druckverlust_auf_Vorlaufleitung_bei_Normalleistung_Leitung_5__bar=\
  \
  (0.657/Leitungsdurchmesser_innen_Leitung_5__m\
  -0.058)*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  **\
  1.92/10000*Trassenlaenge_Leitung_5__m\
  *1.5
```

    4.4

``` python
Druckverlust_auf_Vorlaufleitung_bei_Normalleistung_Leitung_6__bar=\
  \
  (0.657/Leitungsdurchmesser_innen_Leitung_6__m\
  -0.058)*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  **\
  1.92/10000*Trassenlaenge_Leitung_6__m\
  *1.5
```

    5.9

``` python
Druckverlust_auf_Vorlaufleitung_bei_Normalleistung_Leitung_7__bar=\
  \
  (0.657/Leitungsdurchmesser_innen_Leitung_7__m\
  -0.058)*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  **\
  1.92/10000*Trassenlaenge_Leitung_7__m\
  *1.5
```

    5.9

``` python
Druckverlust_auf_Vorlaufleitung_bei_Normalleistung_Leitung_8__bar=\
  \
  (0.657/Leitungsdurchmesser_innen_Leitung_8__m\
  -0.058)*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  **\
  1.92/10000*Trassenlaenge_Leitung_8__m\
  *1.5
```

    4.2

``` python
Druckverlust_auf_Vorlaufleitung_bei_Normalleistung_Leitung_9__bar=\
  \
  (0.657/Leitungsdurchmesser_innen_Leitung_9__m\
  -0.058)*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  **\
  1.92/10000*Trassenlaenge_Leitung_9__m\
  *1.5
```

    5.1

``` python
Druckverlust_auf_Vorlaufleitung_bei_Normalleistung_Leitung_10__bar=\
  \
  (0.657/Leitungsdurchmesser_innen_Leitung_10__m\
  -0.058)*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  **\
  1.92/10000*Trassenlaenge_Leitung_10__m\
  *1.5
```

    5.3

``` python
Druckverlust_auf_Vorlaufleitung_bei_Normalleistung_Leitung_11__bar=\
  \
  (0.657/Leitungsdurchmesser_innen_Leitung_11__m\
  -0.058)*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  **\
  1.92/10000*Trassenlaenge_Leitung_11__m\
  *1.5
```

    2.4

``` python
Leitungsinnendurchmesser_Zweigabschnitt_2_bei_Normleistung__m=\
  \
  (Auslegungsleistung_zu_Beginn_des_Abschnittes_Zweigabschnitt_2_bei_Auslegungsleistung__kW\
  *4/np.pi\
  /4.2/(60-30)/1000/Geschwindigkeit_des_Waermetraegers_bei_Auslegungsleistung_in_UV__m_pro_s\
  )**\
  0.5
```

    0.0

``` python
Leitungsinnendurchmesser_Zweigabschnitt_1_bei_Normleistung__m=\
  \
  (Auslegungsleistung_zu_Beginn_des_Abschnittes_Zweigabschnitt_1_bei_Auslegungsleistung__kW\
  *4/np.pi\
  /4.2/(60-30)/1000/Geschwindigkeit_des_Waermetraegers_bei_Auslegungsleistung_in_UV__m_pro_s\
  )**\
  0.5
```

    0.0

``` python
Druckabfall_pro_m_Zweigabschnitt_1_bei_Auslegungsleistung__bar=\
  \
  0.216/(Geschwindigkeit_des_Waermetraegers_bei_Auslegungsleistung_in_UV__m_pro_s\
  *Leitungsinnendurchmesser_Zweigabschnitt_1_bei_Auslegungsleistung__m\
  /((1.5556*np.exp(\
  -0.0318393*Temperatur_Vorlauf__Unterverteilung_erdverlegt___Grad_C\
  )+0.2374))/10**\
  (-6))**\
  0.2*1/(Leitungsinnendurchmesser_Zweigabschnitt_1_bei_Auslegungsleistung__m\
  )*Geschwindigkeit_des_Waermetraegers_bei_Auslegungsleistung_in_UV__m_pro_s\
  **\
  2*(-0.0040125*Temperatur_Vorlauf__Unterverteilung_erdverlegt___Grad_C\
  **\
  2-0.028625*Temperatur_Vorlauf__Unterverteilung_erdverlegt___Grad_C\
  +1000.3875)/2/100000
```

    0.0

``` python
Druckabfall_pro_m_Zweigabschnitt_2_bei_Auslegungsleistung__bar=\
  \
  0.216/(Geschwindigkeit_des_Waermetraegers_bei_Auslegungsleistung_in_UV__m_pro_s\
  *Leitungsinnendurchmesser_Zweigabschnitt_2_bei_Auslegungsleistung__m\
  /((1.5556*np.exp(\
  -0.0318393*Temperatur_Vorlauf__Unterverteilung_erdverlegt___Grad_C\
  )+0.2374))/10**\
  (-6))**\
  0.2*1/(Leitungsinnendurchmesser_Zweigabschnitt_2_bei_Auslegungsleistung__m\
  )*Geschwindigkeit_des_Waermetraegers_bei_Auslegungsleistung_in_UV__m_pro_s\
  **\
  2*(-0.0040125*Temperatur_Vorlauf__Unterverteilung_erdverlegt___Grad_C\
  **\
  2-0.028625*Temperatur_Vorlauf__Unterverteilung_erdverlegt___Grad_C\
  +1000.3875)/2/100000
```

    0.0

``` python
Leistungsaufnahme_der_Pumpen__Vor__und_Ruecklauf_Zweigabschnitt_2_bei_Normleistung__kW=\
  \
  Druckabfall_am_Abschnitt_Doppelleitung_Zweigabschnitt_2_bei_Normleistung__bar\
  *10**\
  5*np.pi\
  /4*Leitungsinnendurchmesser_Zweigabschnitt_2_bei_Normleistung__m\
  **\
  2*Geschwindigkeit_des_Waermetraegers_bei_Auslegungsleistung_in_UV__m_pro_s\
  /1000/0.75
```

    0.2

``` python
Leistungsaufnahme_der_Pumpen__Vor__und_Ruecklauf_Zweigabschnitt_1_bei_Normleistung__kW=\
  \
  Druckabfall_am_Abschnitt_Doppelleitung_Zweigabschnitt_1_bei_Normleistung__bar\
  *10**\
  5*np.pi\
  /4*Leitungsinnendurchmesser_Zweigabschnitt_1_bei_Normleistung__m\
  **\
  2*Geschwindigkeit_des_Waermetraegers_bei_Auslegungsleistung_in_UV__m_pro_s\
  /1000/0.75
```

    0.2

``` python
Leistungsaufnahme_der_Pumpen_bei_Normalleistung__Vor__und_Ruecklauf_Leitung_1__kW=\
  \
  Druckverlust_auf_Vorlaufleitung_bei_Normalleistung_Leitung_1__bar\
  *10**\
  5*np.pi\
  /4*Leitungsdurchmesser_innen_Leitung_1__m\
  **\
  2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  /1000*2/0.75
```

    25.0

``` python
Leistungsaufnahme_der_Pumpen_bei_Normalleistung__Vor__und_Ruecklauf_Leitung_2__kW=\
  \
  Druckverlust_auf_Vorlaufleitung_bei_Normalleistung_Leitung_2__bar\
  *10**\
  5*np.pi\
  /4*Leitungsdurchmesser_innen_Leitung_2__m\
  **\
  2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  /1000*2/0.75
```

    9.1

``` python
Leistungsaufnahme_der_Pumpen_bei_Normalleistung__Vor__und_Ruecklauf_Leitung_3__kW=\
  \
  Druckverlust_auf_Vorlaufleitung_bei_Normalleistung_Leitung_3__bar\
  *10**\
  5*np.pi\
  /4*Leitungsdurchmesser_innen_Leitung_3__m\
  **\
  2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  /1000*2/0.75
```

    9.7

``` python
Leistungsaufnahme_der_Pumpen_bei_Normalleistung__Vor__und_Ruecklauf_Leitung_4__kW=\
  \
  Druckverlust_auf_Vorlaufleitung_bei_Normalleistung_Leitung_4__bar\
  *10**\
  5*np.pi\
  /4*Leitungsdurchmesser_innen_Leitung_4__m\
  **\
  2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  /1000*2/0.75
```

    8.1

``` python
Leistungsaufnahme_der_Pumpen_bei_Normalleistung__Vor__und_Ruecklauf_Leitung_5__kW=\
  \
  Druckverlust_auf_Vorlaufleitung_bei_Normalleistung_Leitung_5__bar\
  *10**\
  5*np.pi\
  /4*Leitungsdurchmesser_innen_Leitung_5__m\
  **\
  2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  /1000*2/0.75
```

    3.6

``` python
Leistungsaufnahme_der_Pumpen_bei_Normalleistung__Vor__und_Ruecklauf_Leitung_6__kW=\
  \
  Druckverlust_auf_Vorlaufleitung_bei_Normalleistung_Leitung_6__bar\
  *10**\
  5*np.pi\
  /4*Leitungsdurchmesser_innen_Leitung_6__m\
  **\
  2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  /1000*2/0.75
```

    1.5

``` python
Leistungsaufnahme_der_Pumpen_bei_Normalleistung__Vor__und_Ruecklauf_Leitung_7__kW=\
  \
  Druckverlust_auf_Vorlaufleitung_bei_Normalleistung_Leitung_7__bar\
  *10**\
  5*np.pi\
  /4*Leitungsdurchmesser_innen_Leitung_7__m\
  **\
  2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  /1000*2/0.75
```

    5.4

``` python
Leistungsaufnahme_der_Pumpen_bei_Normalleistung__Vor__und_Ruecklauf_Leitung_8__kW=\
  \
  Druckverlust_auf_Vorlaufleitung_bei_Normalleistung_Leitung_8__bar\
  *10**\
  5*np.pi\
  /4*Leitungsdurchmesser_innen_Leitung_8__m\
  **\
  2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  /1000*2/0.75
```

    5.1

``` python
Leistungsaufnahme_der_Pumpen_bei_Normalleistung__Vor__und_Ruecklauf_Leitung_9__kW=\
  \
  Druckverlust_auf_Vorlaufleitung_bei_Normalleistung_Leitung_9__bar\
  *10**\
  5*np.pi\
  /4*Leitungsdurchmesser_innen_Leitung_9__m\
  **\
  2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  /1000*2/0.75
```

    2.3

``` python
Leistungsaufnahme_der_Pumpen_bei_Normalleistung__Vor__und_Ruecklauf_Leitung_10__kW=\
  \
  Druckverlust_auf_Vorlaufleitung_bei_Normalleistung_Leitung_10__bar\
  *10**\
  5*np.pi\
  /4*Leitungsdurchmesser_innen_Leitung_10__m\
  **\
  2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  /1000*2/0.75
```

    17.8

``` python
Leistungsaufnahme_der_Pumpen_bei_Normalleistung__Vor__und_Ruecklauf_Leitung_11__kW=\
  \
  Druckverlust_auf_Vorlaufleitung_bei_Normalleistung_Leitung_11__bar\
  *10**\
  5*np.pi\
  /4*Leitungsdurchmesser_innen_Leitung_11__m\
  **\
  2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  /1000*2/0.75
```

    3.8

``` python
Druckabfall_am_Abschnitt__Doppelleitung_Zweigabschnitt_1_bei_Auslegungsleistung__bar=\
  \
  Druckabfall_pro_m_Zweigabschnitt_1_bei_Auslegungsleistung__bar\
  *endet_bei_Meter_Zweigabschnitt_1_bei_Auslegungsleistung_\
  *2
```

    7.9

``` python
Druckabfall_am_Abschnitt__Doppelleitung_Zweigabschnitt_2_bei_Auslegungsleistung__bar=\
  \
  Druckabfall_pro_m_Zweigabschnitt_2_bei_Auslegungsleistung__bar\
  *endet_bei_Meter_Zweigabschnitt_1_bei_Auslegungsleistung_\
  *2
```

    11.9

``` python
Druckverlust_auf_Vorlaufleitung_bei_Auslegungsleistung_Leitung_1__bar=\
  \
  (0.657/Leitungsdurchmesser_innen_Leitung_1__m\
  -0.058)*(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )**\
  1.92/10000*Trassenlaenge_Leitung_1__m\
  *1.5
```

    6.8

``` python
Druckverlust_auf_Vorlaufleitung_bei_Auslegungsleistung_Leitung_2__bar=\
  \
  (0.657/Leitungsdurchmesser_innen_Leitung_2__m\
  -0.058)*(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )**\
  1.92/10000*Trassenlaenge_Leitung_2__m\
  *1.5
```

    28.3

``` python
Druckverlust_auf_Vorlaufleitung_bei_Auslegungsleistung_Leitung_3__bar=\
  \
  (0.657/Leitungsdurchmesser_innen_Leitung_3__m\
  -0.058)*(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )**\
  1.92/10000*Trassenlaenge_Leitung_3__m\
  *1.5
```

    8.6

``` python
Druckverlust_auf_Vorlaufleitung_bei_Auslegungsleistung_Leitung_4__bar=\
  \
  (0.657/Leitungsdurchmesser_innen_Leitung_4__m\
  -0.058)*(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )**\
  1.92/10000*Trassenlaenge_Leitung_4__m\
  *1.5
```

    28.9

``` python
Druckverlust_auf_Vorlaufleitung_bei_Auslegungsleistung_Leitung_5__bar=\
  \
  (0.657/Leitungsdurchmesser_innen_Leitung_5__m\
  -0.058)*(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )**\
  1.92/10000*Trassenlaenge_Leitung_5__m\
  *1.5
```

    16.8

``` python
Druckverlust_auf_Vorlaufleitung_bei_Auslegungsleistung_Leitung_6__bar=\
  \
  (0.657/Leitungsdurchmesser_innen_Leitung_6__m\
  -0.058)*(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )**\
  1.92/10000*Trassenlaenge_Leitung_6__m\
  *1.5
```

    22.3

``` python
Druckverlust_auf_Vorlaufleitung_bei_Auslegungsleistung_Leitung_7__bar=\
  \
  (0.657/Leitungsdurchmesser_innen_Leitung_7__m\
  -0.058)*(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )**\
  1.92/10000*Trassenlaenge_Leitung_7__m\
  *1.5
```

    22.5

``` python
Druckverlust_auf_Vorlaufleitung_bei_Auslegungsleistung_Leitung_8__bar=\
  \
  (0.657/Leitungsdurchmesser_innen_Leitung_8__m\
  -0.058)*(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )**\
  1.92/10000*Trassenlaenge_Leitung_8__m\
  *1.5
```

    15.8

``` python
Druckverlust_auf_Vorlaufleitung_bei_Auslegungsleistung_Leitung_9__bar=\
  \
  (0.657/Leitungsdurchmesser_innen_Leitung_9__m\
  -0.058)*(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )**\
  1.92/10000*Trassenlaenge_Leitung_9__m\
  *1.5
```

    19.4

``` python
Druckverlust_auf_Vorlaufleitung_bei_Auslegungsleistung_Leitung_10__bar=\
  \
  (0.657/Leitungsdurchmesser_innen_Leitung_10__m\
  -0.058)*(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )**\
  1.92/10000*Trassenlaenge_Leitung_10__m\
  *1.5
```

    19.9

``` python
Druckverlust_auf_Vorlaufleitung_bei_Auslegungsleistung_Leitung_11__bar=\
  \
  (0.657/Leitungsdurchmesser_innen_Leitung_11__m\
  -0.058)*(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )**\
  1.92/10000*Trassenlaenge_Leitung_11__m\
  *1.5
```

    8.9

``` python
Leistungsaufnahme_der_Pumpen__Vor__und_Ruecklauf_Zweigabschnitt_gesamt_bei_Normleistung__kW=\
  \
    Leistungsaufnahme_der_Pumpen__Vor__und_Ruecklauf_Zweigabschnitt_1_bei_Normleistung__kW\
    +Leistungsaufnahme_der_Pumpen__Vor__und_Ruecklauf_Zweigabschnitt_2_bei_Normleistung__kW
```

    0.4

``` python
Leistungsaufnahme_der_Pumpen_bei_Normalleistung__Vor__und_Ruecklauf_Leitung___kW=\
  \
    Leistungsaufnahme_der_Pumpen_bei_Normalleistung__Vor__und_Ruecklauf_Leitung_1__kW\
    +Leistungsaufnahme_der_Pumpen_bei_Normalleistung__Vor__und_Ruecklauf_Leitung_2__kW\
    +Leistungsaufnahme_der_Pumpen_bei_Normalleistung__Vor__und_Ruecklauf_Leitung_3__kW\
    +Leistungsaufnahme_der_Pumpen_bei_Normalleistung__Vor__und_Ruecklauf_Leitung_4__kW\
    +Leistungsaufnahme_der_Pumpen_bei_Normalleistung__Vor__und_Ruecklauf_Leitung_5__kW\
    +Leistungsaufnahme_der_Pumpen_bei_Normalleistung__Vor__und_Ruecklauf_Leitung_6__kW\
    +Leistungsaufnahme_der_Pumpen_bei_Normalleistung__Vor__und_Ruecklauf_Leitung_7__kW\
    +Leistungsaufnahme_der_Pumpen_bei_Normalleistung__Vor__und_Ruecklauf_Leitung_8__kW\
    +Leistungsaufnahme_der_Pumpen_bei_Normalleistung__Vor__und_Ruecklauf_Leitung_9__kW\
    +Leistungsaufnahme_der_Pumpen_bei_Normalleistung__Vor__und_Ruecklauf_Leitung_10__kW\
    +Leistungsaufnahme_der_Pumpen_bei_Normalleistung__Vor__und_Ruecklauf_Leitung_11__kW
```

    91.3

``` python
Leistungsaufnahme_der_Pumpen__Vor__und_Ruecklauf_Zweigabschnitt_1_bei_Auslegungsleistung__kW=\
  \
  Druckabfall_am_Abschnitt__Doppelleitung_Zweigabschnitt_1_bei_Auslegungsleistung__bar\
  *10**\
  5*np.pi\
  /4*Leitungsinnendurchmesser_Zweigabschnitt_1_bei_Auslegungsleistung__m\
  **\
  2*Geschwindigkeit_des_Waermetraegers_bei_Auslegungsleistung_in_UV__m_pro_s\
  /1000/0.75
```

    0.8

``` python
Leistungsaufnahme_der_Pumpen__Vor__und_Ruecklauf_Zweigabschnitt_2_bei_Auslegungsleistung__kW=\
  \
  Druckabfall_am_Abschnitt__Doppelleitung_Zweigabschnitt_2_bei_Auslegungsleistung__bar\
  *10**\
  5*np.pi\
  /4*Leitungsinnendurchmesser_Zweigabschnitt_2_bei_Auslegungsleistung__m\
  **\
  2*Geschwindigkeit_des_Waermetraegers_bei_Auslegungsleistung_in_UV__m_pro_s\
  /1000/0.75
```

    0.6

``` python
Leistungsaufnahme_der_Pumpen_bei_Auslegungsleistung__Vor__und_Ruecklauf_Leitung_1__kW=\
  \
  Druckverlust_auf_Vorlaufleitung_bei_Auslegungsleistung_Leitung_1__bar\
  *10**\
  5*np.pi\
  /4*Leitungsdurchmesser_innen_Leitung_1__m\
  **\
  2*(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )/1000*2/0.75
```

    189.6

``` python
Leistungsaufnahme_der_Pumpen_bei_Auslegungsleistung__Vor__und_Ruecklauf_Leitung_2__kW=\
  \
  Druckverlust_auf_Vorlaufleitung_bei_Auslegungsleistung_Leitung_2__bar\
  *10**\
  5*np.pi\
  /4*Leitungsdurchmesser_innen_Leitung_2__m\
  **\
  2*(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )/1000*2/0.75
```

    68.7

``` python
Leistungsaufnahme_der_Pumpen_bei_Auslegungsleistung__Vor__und_Ruecklauf_Leitung_3__kW=\
  \
  Druckverlust_auf_Vorlaufleitung_bei_Auslegungsleistung_Leitung_3__bar\
  *10**\
  5*np.pi\
  /4*Leitungsdurchmesser_innen_Leitung_3__m\
  **\
  2*(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )/1000*2/0.75
```

    73.1

``` python
Leistungsaufnahme_der_Pumpen_bei_Auslegungsleistung__Vor__und_Ruecklauf_Leitung_4__kW=\
  \
  Druckverlust_auf_Vorlaufleitung_bei_Auslegungsleistung_Leitung_4__bar\
  *10**\
  5*np.pi\
  /4*Leitungsdurchmesser_innen_Leitung_4__m\
  **\
  2*(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )/1000*2/0.75
```

    61.3

``` python
Leistungsaufnahme_der_Pumpen_bei_Auslegungsleistung__Vor__und_Ruecklauf_Leitung_5__kW=\
  \
  Druckverlust_auf_Vorlaufleitung_bei_Auslegungsleistung_Leitung_5__bar\
  *10**\
  5*np.pi\
  /4*Leitungsdurchmesser_innen_Leitung_5__m\
  **\
  2*(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )/1000*2/0.75
```

    26.9

``` python
Leistungsaufnahme_der_Pumpen_bei_Auslegungsleistung__Vor__und_Ruecklauf_Leitung_6__kW=\
  \
  Druckverlust_auf_Vorlaufleitung_bei_Auslegungsleistung_Leitung_6__bar\
  *10**\
  5*np.pi\
  /4*Leitungsdurchmesser_innen_Leitung_6__m\
  **\
  2*(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )/1000*2/0.75
```

    11.6

``` python
Leistungsaufnahme_der_Pumpen_bei_Auslegungsleistung__Vor__und_Ruecklauf_Leitung_7__kW=\
  \
  Druckverlust_auf_Vorlaufleitung_bei_Auslegungsleistung_Leitung_7__bar\
  *10**\
  5*np.pi\
  /4*Leitungsdurchmesser_innen_Leitung_7__m\
  **\
  2*(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )/1000*2/0.75
```

    40.6

``` python
Leistungsaufnahme_der_Pumpen_bei_Auslegungsleistung__Vor__und_Ruecklauf_Leitung_8__kW=\
  \
  Druckverlust_auf_Vorlaufleitung_bei_Auslegungsleistung_Leitung_8__bar\
  *10**\
  5*np.pi\
  /4*Leitungsdurchmesser_innen_Leitung_8__m\
  **\
  2*(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )/1000*2/0.75
```

    38.4

``` python
Leistungsaufnahme_der_Pumpen_bei_Auslegungsleistung__Vor__und_Ruecklauf_Leitung_9__kW=\
  \
  Druckverlust_auf_Vorlaufleitung_bei_Auslegungsleistung_Leitung_9__bar\
  *10**\
  5*np.pi\
  /4*Leitungsdurchmesser_innen_Leitung_9__m\
  **\
  2*(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )/1000*2/0.75
```

    17.5

``` python
Leistungsaufnahme_der_Pumpen_bei_Auslegungsleistung__Vor__und_Ruecklauf_Leitung_10__kW=\
  \
  Druckverlust_auf_Vorlaufleitung_bei_Auslegungsleistung_Leitung_10__bar\
  *10**\
  5*np.pi\
  /4*Leitungsdurchmesser_innen_Leitung_10__m\
  **\
  2*(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )/1000*2/0.75
```

    134.4

``` python
Leistungsaufnahme_der_Pumpen_bei_Auslegungsleistung__Vor__und_Ruecklauf_Leitung_11__kW=\
  \
  Druckverlust_auf_Vorlaufleitung_bei_Auslegungsleistung_Leitung_11__bar\
  *10**\
  5*np.pi\
  /4*Leitungsdurchmesser_innen_Leitung_11__m\
  **\
  2*(2*Normgeschwindigkeit_in_Hauptverteilung__m_pro_s\
  )/1000*2/0.75
```

    28.8

``` python
Unterverteilung_mittlere_Leistungsaufnahme_aller_Pumpen_der_Unterverteilung__kW=\
  \
  Leistungsaufnahme_der_Pumpen__Vor__und_Ruecklauf_Zweigabschnitt_gesamt_bei_Normleistung__kW\
  *Verteilung_Anzahl_der_Unterverteilungszweige__Zweige
```

    79.4

``` python
Hauptverteilung_mittlere_Leistungsaufnahme_aller_Pumpen_der_Hauptverteilung__kW=\
  \
  Leistungsaufnahme_der_Pumpen_bei_Normalleistung__Vor__und_Ruecklauf_Leitung___kW
```

    91.3

``` python
Groesse_der_Pufferspeicher_je__m3=\
  \
  ((Kollektoren_Maximal_moegliche_taegliche_Globalstrahlung__kWh_pro_d_pro_m2\
  *(Jahresertrag_der_Roehrenkollektoren__Wuerzburg_bei_T_gleich_75_Grad_C__Ritter_CPC_XL_1921__kWh_pro_a_pro_m2\
  *Anteil_an_Roehrenkollektoren__Prozent\
  /100+Jahresertrag_Flachkollektoren__Wuerzburg_bei_T_gleich_50_Grad_C__SUNEX_SA_AMP_2__kWh_pro_a_pro_m2\
  *(1-Anteil_an_Roehrenkollektoren__Prozent\
  /100))/Kollektoren_Globalstrahlung_Wuerzburg_langjaehriges_Mittel_Standort_fuer_Kollektorvergleich_Keymark__kWh_pro_m2\
  *Kollektorflaeche_brutto__extern_noetig__m2_pro_Kopf\
  *Bevoelkerung__Personen\
  -Endenergie_nur_fuer_Warmwasser_WW__fuer_alle_Gebaeude_pro_Kopf__kWh_pro_a_pro_Kopf\
  /365*Bevoelkerung__Personen\
  )*18/24*3600/4.2/55/1000)
```

    5704.8

``` python
Leistungsaufnahme_der_Pumpen__Vor__und_Ruecklauf_Zweigabschnitt_gesamt_bei_Auslegungsleistung__kW=\
  \
    Leistungsaufnahme_der_Pumpen__Vor__und_Ruecklauf_Zweigabschnitt_1_bei_Auslegungsleistung__kW\
    +Leistungsaufnahme_der_Pumpen__Vor__und_Ruecklauf_Zweigabschnitt_2_bei_Auslegungsleistung__kW
```

    1.3

``` python
Leistungsaufnahme_der_Pumpen_bei_Auslegungsleistung__Vor__und_Ruecklauf_Leitung___kW=\
  \
    Leistungsaufnahme_der_Pumpen_bei_Auslegungsleistung__Vor__und_Ruecklauf_Leitung_1__kW\
    +Leistungsaufnahme_der_Pumpen_bei_Auslegungsleistung__Vor__und_Ruecklauf_Leitung_2__kW\
    +Leistungsaufnahme_der_Pumpen_bei_Auslegungsleistung__Vor__und_Ruecklauf_Leitung_3__kW\
    +Leistungsaufnahme_der_Pumpen_bei_Auslegungsleistung__Vor__und_Ruecklauf_Leitung_4__kW\
    +Leistungsaufnahme_der_Pumpen_bei_Auslegungsleistung__Vor__und_Ruecklauf_Leitung_5__kW\
    +Leistungsaufnahme_der_Pumpen_bei_Auslegungsleistung__Vor__und_Ruecklauf_Leitung_6__kW\
    +Leistungsaufnahme_der_Pumpen_bei_Auslegungsleistung__Vor__und_Ruecklauf_Leitung_7__kW\
    +Leistungsaufnahme_der_Pumpen_bei_Auslegungsleistung__Vor__und_Ruecklauf_Leitung_8__kW\
    +Leistungsaufnahme_der_Pumpen_bei_Auslegungsleistung__Vor__und_Ruecklauf_Leitung_9__kW\
    +Leistungsaufnahme_der_Pumpen_bei_Auslegungsleistung__Vor__und_Ruecklauf_Leitung_10__kW\
    +Leistungsaufnahme_der_Pumpen_bei_Auslegungsleistung__Vor__und_Ruecklauf_Leitung_11__kW
```

    690.9

``` python
Verteilung_gesamt_mittlere_Leistungsaufnahme_aller_Pumpen_der_gesamten_Verteilung__kW=\
  \
  Unterverteilung_mittlere_Leistungsaufnahme_aller_Pumpen_der_Unterverteilung__kW\
  +Hauptverteilung_mittlere_Leistungsaufnahme_aller_Pumpen_der_Hauptverteilung__kW
```

    170.7

``` python
Investition_Saisonspeicher__zwei_Pufferspeicher___Euro_=\
  \
  Saisonspeicher_Kosten_fuer_Pufferspeicher_am_Saisonspeicher_pro_m3___Euro__pro_m3\
  *Groesse_der_Pufferspeicher_je__m3\
  *2
```

    1140950.6

``` python
Unterverteilung_Auslegungsleistung_aller_Pumpen_der_Unterverteilung__kW=\
  \
  Leistungsaufnahme_der_Pumpen__Vor__und_Ruecklauf_Zweigabschnitt_gesamt_bei_Auslegungsleistung__kW\
  *Verteilung_Anzahl_der_Unterverteilungszweige__Zweige
```

    276.7

``` python
Hauptverteilung_Auslegungsleistung_aller_Pumpen_der_Hauptverteilung__kW=\
  \
  Leistungsaufnahme_der_Pumpen_bei_Auslegungsleistung__Vor__und_Ruecklauf_Leitung___kW
```

    690.9

``` python
Verteilung_gesamt_Jahresenergieverbrauch_der_Verteilerpumpen__kWh_pro_a=\
  \
  Verteilung_gesamt_mittlere_Leistungsaufnahme_aller_Pumpen_der_gesamten_Verteilung__kW\
  *24*180
```

    737563.4

``` python
Investition_Umwaelzpumpen_Unterverteilung___Euro_=\
  \
  Unterverteilung_Auslegungsleistung_aller_Pumpen_der_Unterverteilung__kW\
  *Verteilung_Kosten_der_Umwaelzpumpen___Euro__pro_kW
```

    59756.5

``` python
Investition_Umwaelzpumpen_Hauptverteilung___Euro_=\
  \
  Hauptverteilung_Auslegungsleistung_aller_Pumpen_der_Hauptverteilung__kW\
  *Verteilung_Kosten_der_Umwaelzpumpen___Euro__pro_kW
```

    149232.0

``` python
Verteilung_gesamt_Jahresverbrauch_der_Pumpen_fuer_Fernheizverteilung_und_Kollektorfeld__kWh_pro_a=\
  \
  Verteilung_gesamt_Jahresenergieverbrauch_der_Verteilerpumpen__kWh_pro_a\
  *1.3
```

    958832.4

``` python
Investitionskosten_Umwaelzpumpen_Unterverteilung___Euro__pro_a_pro_Kopf=\
  \
  Investition_Umwaelzpumpen_Unterverteilung___Euro_\
  /Abschreibungsjahre_fuer_Umwaelzpumpen_Unterverteilung_\
  /Bevoelkerung__Personen
```

    0.4

``` python
Investitionskosten_Umwaelzpumpen_Hauptverteilung___Euro__pro_a_pro_Kopf=\
  \
  Investition_Umwaelzpumpen_Hauptverteilung___Euro_\
  /Abschreibungsjahre_fuer_Umwaelzpumpen_Hauptverteilung_\
  /Bevoelkerung__Personen
```

    1.0

``` python
laufende_Kosten_E_Antrieb_der_Pumpen__Stromkosten___Euro__pro_a=\
  \
  Verteilung_gesamt_Jahresverbrauch_der_Pumpen_fuer_Fernheizverteilung_und_Kollektorfeld__kWh_pro_a\
  *Stromtarif__Bezug___Euro__pro_kWh
```

    210943.1

``` python
laufende_Kosten_E_Antrieb_der_Pumpen__Stromkosten___Euro__pro_a_pro_Kopf=\
  \
  laufende_Kosten_E_Antrieb_der_Pumpen__Stromkosten___Euro__pro_a\
  /Bevoelkerung__Personen
```

    28.1

``` python
laufende_Kosten___Euro__pro_a_pro_Kopf=\
  \
    laufende_Kosten_E_Antrieb_der_Pumpen__Stromkosten___Euro__pro_a_pro_Kopf\
    +laufende_Kosten_Energiekosten_BHKW___Euro__pro_a_pro_Kopf\
    +laufende_Kosten_Ertrag_BHKW__Elektroenergie___Euro__pro_a_pro_Kopf\
    +laufende_Kosten_Waermetauscher___Euro__pro_a_pro_Kopf\
    +laufende_Kosten_Betrieb__Wartung___Euro__pro_a_pro_Kopf
```

    319.1

``` python
Leistungsverlust_Vor_u__Ruecklauf_Zweigabschnitt_1_bei_Normleistung__kW=\
  \
  (50+20)*2*np.pi\
  *Leitwert_Rohr_Daemmung__Unterverteilung_erdverlegt__W_pro_m_pro_K\
  *endet_bei_Meter_Zweigabschnitt_1_bei_Auslegungsleistung_\
  /np.log(\
  1+Rohr_Daemmung_Staerke__Unterverteilung_erdverlegt__m\
  *2/Leitungsinnendurchmesser_Zweigabschnitt_1_bei_Normleistung__m\
  )/1000
```

    1.7

``` python
Leistungsverlust_Vor_u__Ruecklauf_Zweigabschnitt_2_bei_Normleistung__kW=\
  \
  (50+20)*2*np.pi\
  *Leitwert_Rohr_Daemmung__Unterverteilung_erdverlegt__W_pro_m_pro_K\
  *endet_bei_Meter_Zweigabschnitt_1_bei_Auslegungsleistung_\
  /np.log(\
  1+Rohr_Daemmung_Staerke__Unterverteilung_erdverlegt__m\
  *2/Leitungsinnendurchmesser_Zweigabschnitt_2_bei_Normleistung__m\
  )/1000
```

    1.5

``` python
Jahreswaermeverluste_Zweigabschnitt_1_bei_Normleistung__kWh_pro_a=\
  \
  Leistungsverlust_Vor_u__Ruecklauf_Zweigabschnitt_1_bei_Normleistung__kW\
  *24*180
```

    7271.1

``` python
Jahreswaermeverluste_Zweigabschnitt_2_bei_Normleistung__kWh_pro_a=\
  \
  Leistungsverlust_Vor_u__Ruecklauf_Zweigabschnitt_2_bei_Normleistung__kW\
  *24*180
```

    6388.1

``` python
Jahreswaermeverluste_Zweigabschnitt_gesamt_bei_Normleistung__kWh_pro_a=\
  \
    Jahreswaermeverluste_Zweigabschnitt_1_bei_Normleistung__kWh_pro_a\
    +Jahreswaermeverluste_Zweigabschnitt_2_bei_Normleistung__kWh_pro_a
```

    13659.2

``` python
Unterverteilung_Jahreswaermeverluste_der_Unterverteilung__kWh_pro_a=\
  \
  Jahreswaermeverluste_Zweigabschnitt_gesamt_bei_Normleistung__kWh_pro_a\
  *Verteilung_Anzahl_der_Unterverteilungszweige__Zweige
```

    2851493.3

``` python
Verteilung_gesamt_Jahreswaermeverlust_im_Fernwaermenetz__kWh_pro_a=\
  \
  Unterverteilung_Jahreswaermeverluste_der_Unterverteilung__kWh_pro_a\
  +Hauptverteilung_Jahreswaermeverluste_der_Hauptverteilung__kWh_pro_a
```

    4865851.9

``` python
Jahreswaermeverlust_im_Fernwaermenetz__kWh_pro_a=\
  \
  Verteilung_gesamt_Jahreswaermeverlust_im_Fernwaermenetz__kWh_pro_a
```

    4865851.9

``` python
Gesamtverluste_durch_Speicherung_und_Verteilung__kWh_pro_a=\
  \
    Jahreswaermeverlust_durch_Speicherung__kWh_pro_a\
    +Jahreswaermeverlust_im_Fernwaermenetz__kWh_pro_a
```

    11842361.3

``` python
Gesamtverluste_durch_Speicherung_und_Verteilung_bezueglich_bereitgestellter_Energie__Prozent=\
  \
  Gesamtverluste_durch_Speicherung_und_Verteilung__kWh_pro_a\
  /Jahreswaermebedarf__Wohn_u_Nichtwohn_Heizg_u_WW___saniert__u_Verlustausgleich_JWBwnhwsv__kWh_pro_a\
  *100
```

    20.9

``` python
Saisonspeicher_Anzahl_der_Bohrungen__zweimal__Stueck=\
  \
  Auslegungsleistung__Maximal_noetige_Heizleistung_saniert___kW_pro_Kopf\
  *Bevoelkerung__Personen\
  /(1-Gesamtverluste_durch_Speicherung_und_Verteilung_bezueglich_bereitgestellter_Energie__Prozent\
  /100)/4.2/(55-28)/1000*3600/Saisonspeicher_Foerderleistung_eines_Brunnens__m3_pro_h
```

    24.1

``` python
Saisonspeicher_Laenge_aller_Bohrungen__m=\
  \
  Saisonspeicher_Anzahl_der_Bohrungen__zweimal__Stueck\
  *(Moeglichkeit_zur_Eingabe_einer_anderen_Speichertiefe__m\
  *1.2)
```

    3360.5

``` python
Investition_Saisonspeicher__Bohrungen___Euro_=\
  \
  Saisonspeicher_Laenge_aller_Bohrungen__m\
  *Saisonspeicher_Kosten_fuer_Bohrungen_pro_m___Euro__pro_m\
  *(1-Saisonspeicher_Mengenrabatt_Bohren__Prozent\
  /100)
```

    604892.4

``` python
Investition_Saisonspeicher__gesamt___Euro_=\
  \
    Investition_Saisonspeicher__Abdeckung___Euro_\
    +Investition_Saisonspeicher__Bohrungen___Euro_\
    +Investition_Saisonspeicher__Schlitzwand___Euro_\
    +Investition_Saisonspeicher__zwei_Pufferspeicher___Euro_\
    +Investition_Technikgebaeude_am_Speicherrand__geschaetzt___Euro_
```

    5990364.6

``` python
Investitionskosten_Saisonspeicher__gesamt___Euro__pro_a_pro_Kopf=\
  \
  Investition_Saisonspeicher__gesamt___Euro_\
  /Abschreibungsjahre_fuer_Saisonspeicher__gesamt_\
  /Bevoelkerung__Personen
```

    15.9

``` python
Investition_fuer_die_gesamte_Anlage___Euro__pro_a_pro_Kopf=\
  \
    Investitionskosten_Saisonspeicher__gesamt___Euro__pro_a_pro_Kopf\
    +Investitionskosten_Umwaelzpumpen_Unterverteilung___Euro__pro_a_pro_Kopf\
    +Investitionskosten_Umwaelzpumpen_Hauptverteilung___Euro__pro_a_pro_Kopf\
    +Investitionskosten_Kollektoren___Euro__pro_a_pro_Kopf\
    +Investitionskosten_Aufstellung__Installation_der_Kollektoren___Euro__pro_a_pro_Kopf\
    +Investitionskosten_Waermespeicher_in_den_Gebaeuden___Euro__pro_a_pro_Kopf\
    +Investitionskosten_Bodenpreis_fuer_externes_Kollektorfeld___Euro__pro_a_pro_Kopf\
    +Investitionskosten_Fernwaermeleitungen_fuer_Unterverteilung_und_Hausanschluesse___Euro__pro_a_pro_Kopf\
    +Investitionskosten_Fernwaermeleitungen_fuer_Hauptverteilung___Euro__pro_a_pro_Kopf\
    +Investitionskosten_BHKW__ohne_Energiekosten____Euro__pro_a_pro_Kopf
```

    512.0

``` python
Investition_fuer_die_gesamte_Anlage_mit_Nebenkosten___Euro__pro_a_pro_Kopf=\
  \
  Investition_fuer_die_gesamte_Anlage___Euro__pro_a_pro_Kopf\
  /(1-Nebenkosten_der_gesamten_Anlage__Prozent\
  /100)
```

    640.0

Summe:

``` r
#r 
Gebaeudeenergiekosten_ohne_Kapitalkosten_und_Foerdermittel__Euro_pro_Kopf_pro_a <- 
  sum(c(
      py$Investition_fuer_die_gesamte_Anlage_mit_Nebenkosten___Euro__pro_a_pro_Kopf
    ,+py$laufende_Kosten___Euro__pro_a_pro_Kopf
    ,-py$Investitionskosten_BHKW__ohne_Energiekosten____Euro__pro_a_pro_Kopf
    ,-py$laufende_Kosten_Energiekosten_BHKW___Euro__pro_a_pro_Kopf
    ,-py$laufende_Kosten_Ertrag_BHKW__Elektroenergie___Euro__pro_a_pro_Kopf
  ))

# Gebaeudeenergiekosten_ohne_Kapitalkosten_und_Foerdermittel__Euro_pro_Kopf_pro_a =728
round(
  Gebaeudeenergiekosten_ohne_Kapitalkosten_und_Foerdermittel__Euro_pro_Kopf_pro_a
  ,1
)
```

    [1] 727.8

``` r
# mögliche Nebenrechnung:
# bei eingepreistem Fremdenergieeinsatz von nur noch    2.16%
```

Umrechnung auf monatlich

``` r
#Quelldatei: endrechnung.xlsx
#€/Monat/Kopf
Gebaeudeenergiekosten_proKopf_proMon_ohne_Kapitalkosten_und_Foerdermittel <-
  1/12 *
  Gebaeudeenergiekosten_ohne_Kapitalkosten_und_Foerdermittel__Euro_pro_Kopf_pro_a

round(
  Gebaeudeenergiekosten_proKopf_proMon_ohne_Kapitalkosten_und_Foerdermittel
  ,0
)
```

    [1] 61

### Endergebnis

``` r
min_Anschliesser_count <- 5000 #ToDo: calculate this

#km
max_Einzugsradius_km <- 6 #ToDo: calculate this

#€/Monat/Kopf
# Gebaeudeenergiekosten_proKopf_proMon_ohne_Kapitalkosten_und_Foerdermittel #61 #successfully calculated #ToDo add Zylindermodell and time series to Python
# nur Roebel

#m
max_Bohrtiefe <- '__ToDo__' # ToDo

#m/s
min_Wasserdurchlaessigkeit <- '__ToDo__' #ToDo

#€/Monat/Kopf
bisherige_Gebaeudeenergiekosten_pPpM <- 65 #external
```

Eine Kommunale Solarheizung mit saisonalem Erwärmespeicher, Solarthermie
und Wärmenetz lohnt sich überall dort, wo mindestens 5000 Anschließer
auf einem Radius von weniger als 6 Kilomentern teilnehmen und der Boden
bis in **ToDo** m Tiefe mindestens einen Wasserdurchlässigkeitswert von
**ToDo** m/s hat. ([Quelle](https://heliogaia.de/endergebnisse.html))

Hintergrund:

Für die Gemeinde Roebel wurden Solar-Heizkosten von 61 € pro Person und
Monat ohne Berücksichtigung von Kapitalkosten und Fördermitteln
errechnet.

Bisher wurden in Deutschland jährlich 65 Milliarden Euro für
Gebäudeenergie ausgegeben
[Dena](https://heliogaia.de/9254_Gebaeudereport_dena_kompakt_2018.pdf),
S.7, das sind monatlich ca. 65€ pro Kopf.
