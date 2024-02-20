# Saisonale Erdwärmespeicher - Solar district heating 

based on and supporting https://heliogaia.de

Our [calculations](https://github.com/DanielWittig/Saisonale_Erdwaermespeicher/blob/main/notebooks/Kalkulation.md) on using soil based seasonal heat storage for municipalities reveal the potential of replacing about one third of todays energy consuption in Germany at competitive cost. Therefore we encourage a timely pilot project.

At this stage, most of the variable names and descriptions are in German. 

Feel free to join us in tackling global warming by local seasonal warming!

# About this github project

The initial aim of this github project is to reformulate in python, what was calculated in spreadsheets on heliogaia.de - allowing for easier reading, collaborating and scaling.

So if you have a proposal, just open an issue and we'll talk!

The recalculations in Python are developed as follows:
* the coding is done in the Quarto document [Kalkulation.qmd](https://github.com/DanielWittig/Saisonale_Erdwaermespeicher/blob/main/notebooks/Kalkulation.qmd)
* the presentation output (github flavored markdown) is [Kalkulation.md](https://github.com/DanielWittig/Saisonale_Erdwaermespeicher/blob/main/notebooks/Kalkulation.md).

The following code facilitated the migration from spreadsheet to python - and took the main portion of the time so far (until ca. 2024-02-20): 
[Excel2Python_Migrator.qmd](https://github.com/DanielWittig/Saisonale_Erdwaermespeicher/blob/main/notebooks/Excel2Python_Migrator.qmd)

The migrator is mainly written in Python - an extract is given [here](https://github.com/DanielWittig/Saisonale_Erdwaermespeicher/blob/main/notebooks/Excel2Python_Migrator.py).


# Tools

* Quarto.org using Python and a bit of R in Rstudio
* one convenient way is to run this on https://posit.cloud

Started on: 2024-01-25