# Wirtschaftlichkeit Saisonaler Erdwärmespeicher


moin..

``` python
import numpy as np

# temporär gesetzt
endet_bei_Meter_Zweigabschnitt_1_bei_Auslegungsleistung_ = 1
Leitungsinnendurchmesser_Zweigabschnitt_2_bei_Normleistung__m = 1
Leitungsinnendurchmesser_Zweigabschnitt_1_bei_Normleistung__m = 1
Trassenlaenge_Leitung_1__m = 1
Leitungsdurchmesser_innen_Leitung_1__m = 1
Leitwert_Rohr_Daemmung__Unterverteilung_erdverlegt__W_pro_m_pro_K=\
  \
  0.035

round(Leitwert_Rohr_Daemmung__Unterverteilung_erdverlegt__W_pro_m_pro_K, 2)


Rohr_Daemmung_Staerke__Unterverteilung_erdverlegt__m=\
  \
  0.1

round(Rohr_Daemmung_Staerke__Unterverteilung_erdverlegt__m, 2)


Leitwert_Rohr_Daemmung__Hauptverteilung_erdverlegt__W_pro_m_pro_K=\
  \
  0.035

round(Leitwert_Rohr_Daemmung__Hauptverteilung_erdverlegt__W_pro_m_pro_K, 2)


Rohr_Daemmung_Staerke__Hauptverteilung_erdverlegt__m=\
  \
  0.07

round(Rohr_Daemmung_Staerke__Hauptverteilung_erdverlegt__m, 2)


Leistungsverlust_Vor_u__Ruecklauf_Zweigabschnitt_1_bei_Normleistung__kW=\
  \
  (50+20)*2*np.pi\
  *Leitwert_Rohr_Daemmung__Unterverteilung_erdverlegt__W_pro_m_pro_K\
  *endet_bei_Meter_Zweigabschnitt_1_bei_Auslegungsleistung_\
  /np.log(\
  1+Rohr_Daemmung_Staerke__Unterverteilung_erdverlegt__m\
  *2/Leitungsinnendurchmesser_Zweigabschnitt_1_bei_Normleistung__m\
  )/1000

round(Leistungsverlust_Vor_u__Ruecklauf_Zweigabschnitt_1_bei_Normleistung__kW, 2)


Leistungsverlust_Vor_u__Ruecklauf_Zweigabschnitt_2_bei_Normleistung__kW=\
  \
  (50+20)*2*np.pi\
  *Leitwert_Rohr_Daemmung__Unterverteilung_erdverlegt__W_pro_m_pro_K\
  *endet_bei_Meter_Zweigabschnitt_1_bei_Auslegungsleistung_\
  /np.log(\
  1+Rohr_Daemmung_Staerke__Unterverteilung_erdverlegt__m\
  *2/Leitungsinnendurchmesser_Zweigabschnitt_2_bei_Normleistung__m\
  )/1000

round(Leistungsverlust_Vor_u__Ruecklauf_Zweigabschnitt_2_bei_Normleistung__kW, 2)


Leistungsverlust_Vor_u__Ruecklauf_Leitung_1__kW=\
  \
  (50+20)*2*np.pi\
  *Leitwert_Rohr_Daemmung__Hauptverteilung_erdverlegt__W_pro_m_pro_K\
  *Trassenlaenge_Leitung_1__m\
  /np.log(\
  1+Rohr_Daemmung_Staerke__Hauptverteilung_erdverlegt__m\
  *2/Leitungsdurchmesser_innen_Leitung_1__m\
  )/1000

round(Leistungsverlust_Vor_u__Ruecklauf_Leitung_1__kW, 2)
```

    0.12