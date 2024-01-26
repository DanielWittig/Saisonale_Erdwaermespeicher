# Wirtschaftlichkeit Saisonaler Erdwärmespeicher


Hier entsteht gerade die Kette der Rechnungen in Python, als deren
Ergebnis die 61 EUR/a/Kopf Heizkosten erwartet werden.

``` python
import numpy as np
import pickle
import pprint

input_values = pickle.load(open('input_dict_roebel.p', 'rb'))
for key in input_values.keys():
  globals()[key] = input_values[key]


#Input values:
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
# Leistungsverlust_Vor_u__Ruecklauf_Zweigabschnitt_1_bei_Normleistung__kW=\
#   \
#   (50+20)*2*np.pi\
#   *Leitwert_Rohr_Daemmung__Unterverteilung_erdverlegt__W_pro_m_pro_K\
#   *endet_bei_Meter_Zweigabschnitt_1_bei_Auslegungsleistung_\
#   /np.log(\
#   1+Rohr_Daemmung_Staerke__Unterverteilung_erdverlegt__m\
#   *2/Leitungsinnendurchmesser_Zweigabschnitt_1_bei_Normleistung__m\
#   )/1000
```

## From here on we need the right order of excecution

…because one used variabele is not yet known:

    Traceback (most recent call last):
      File "<string>", line 5, in <module>
    NameError: name 'endet_bei_Meter_Zweigabschnitt_1_bei_Auslegungsleistung_' is not defined
