import tkinter as tk
from tkinter import *
from tkinter import filedialog
from PIL import Image, ImageTk

def cierra_presentacion():
    presentacion.destroy()

presentacion=tk.Tk()

presentacion.overrideredirect(True)
presentacion.overrideredirect(False)

ancho_ventana = 900
alto_ventana = 500

x_ventana = presentacion.winfo_screenwidth() // 2 - ancho_ventana // 2
y_ventana = presentacion.winfo_screenheight() // 2 - alto_ventana // 2

posicion = str(ancho_ventana) + "x" + str(alto_ventana) + "+" + str(x_ventana) + "+" + str(y_ventana)
presentacion.geometry(posicion)

presentacion.resizable(0,0)

imagen_presentacion=Image.open("presentacion.png")
imagen_presentacion=imagen_presentacion.resize ((900, 500))
#,image.ANTIALIAS
img=ImageTk.PhotoImage(imagen_presentacion)

label_imagen=tk.Label(presentacion,image=(img))
label_imagen.place(x=0,y=0)



import pandas as pd
import matplotlib.pyplot as plt
from fpdf import FPDF
import time
import tkinter.ttk as ttk
import os
from datetime import date
from datetime import datetime

presentacion.after(5000,cierra_presentacion)

presentacion.mainloop()

def carga_csv_bigregions(ruta):
    #devuelve las bigregion como dataframe transpuesto
    df_bigregions=pd.read_csv(ruta + "/aseg_bigregions.csv",index_col="id")
    #df_etiquetado=df_bigregions.rename(columns={"id":"id","brainsegvol":"Volumen cerebral","brainsegvolnotvent":"Volumen cerebral sin ventriculos","brainsegvolnotventsurf":"Sin superficie ventricular","cerebralwhitemattervol":"Volumen de sustancia blanca","cortexvol":"Volumen cortical total","left_meanthickness":"Grosor cortical izquierdo","left_pialsurfarea":"Superficie pial izquierda","left_whitesurfarea":"Superficie de sust. blanda","lhcerebralwhitemattervol":"Volumen sustancia blanca HI","lhcortexvol":"Volumen cortical izquierdo","rhcerebralwhitemattervol":"Vol sust blanca izquierda","rhcortexvol":"Vol corteza derecha","right_meanthickness":"Grosor cortical derecho medio","right_pialsurfarea":"sup pial derecho","right_whitesurfarea":"superficie sust blanca izquierda","subcortgrayvol":"volumen subcortical","supratentorialvol":"volumen subcortical","supratentorialvolnotvent":"vol supratentorial sin ventriculos","supratentorialvolnotventvox":"no se que es esto","totalgrayvol":"sustancia gris total"})
    df_bigregions_trans=df_bigregions.transpose()
    df_bigregions_filtrado_seleccion=df_bigregions_trans.iloc[genera_lista_seleccionados_bigregion(),[0]]
    return df_bigregions_filtrado_seleccion

def carga_csv_aseg(ruta):
    #devuelve las aseg como dataframe transpuesto
    df_aseg=pd.read_csv(ruta + "/aseg.csv",index_col="id")
    df_aseg_trans=df_aseg.transpose()
    df_aseg_filtrado_seleccion=df_aseg_trans.iloc[genera_lista_seleccionados_aseg(),[0]]
    return df_aseg_filtrado_seleccion

def carga_csv_lh_aparc(ruta):
    #devuelve las lh_aparc_aseg como dataframe transpuesto
    df_lh_aparc=pd.read_csv(ruta + "/lh.aparc.csv",index_col="id")
    
    df_lh_aparc_trans=df_lh_aparc.transpose()
    df_lh_aparc_filtrado_seleccion=df_lh_aparc_trans.iloc[genera_lista_seleccionados_lh_aparc(),[0]]    
    return df_lh_aparc_filtrado_seleccion

def carga_csv_rh_aparc(ruta):
    #devuelve las rh_aparc_aseg como dataframe transpuesto
    df_rh_aparc=pd.read_csv(ruta + "/rh.aparc.csv",index_col="id")
    df_rh_aparc_trans=df_rh_aparc.transpose()
    df_rh_aparc_filtrado_seleccion=df_rh_aparc_trans.iloc[genera_lista_seleccionados_rh_aparc(),[0]]
    return df_rh_aparc_filtrado_seleccion

def selecciona_directorio():


    #Borra todos los lstbox para que no se dupliquen
    bigregionslstbox.delete(0,END)
    aseglstbox.delete(0,END)
    lh_aparclstbox.delete(0,END)
    rh_aparclstbox.delete(0,END)

    # Carga el df y lo transpone(big regions)
    df_big_regions=pd.read_csv(muestra_seleccionado() + "/normative_z_scores/aseg_bigregions.csv")
    df_big_regions_trans=df_big_regions.transpose()
    # Carga el df y lo transpone(aseg)
    df_aseg=pd.read_csv(muestra_seleccionado() + "/normative_z_scores/aseg.csv")
    df_aseg_trans=df_aseg.transpose()
    # Carga el df y lo transpone(lh_aparc)
    df_lh_aparc=pd.read_csv(muestra_seleccionado() + "/normative_z_scores/lh.aparc.csv")
    df_lh_aparc_trans=df_lh_aparc.transpose()
    # Carga el df y lo transpone(rh_aparc)
    df_rh_aparc=pd.read_csv(muestra_seleccionado() + "/normative_z_scores/rh.aparc.csv")
    df_rh_aparc_trans=df_rh_aparc.transpose()
    # Genera una lista de estructuras a partir del df
    lista_estructuras_bigregions=list(df_big_regions_trans.index.values[:])
    lista_estructuras_aseg=list(df_aseg_trans.index.values[:])
    lista_estructuras_lh_aparc=list(df_lh_aparc_trans.index.values[:])
    lista_estructuras_rh_aparc=list(df_rh_aparc_trans.index.values[:])
    # Exporta la lista de estructuras a la listbox correspondiente
    bigregionslstbox.insert(0,*lista_estructuras_bigregions)
    aseglstbox.insert(0,*lista_estructuras_aseg)
    lh_aparclstbox.insert(0,*lista_estructuras_lh_aparc)
    rh_aparclstbox.insert(0,*lista_estructuras_rh_aparc)

    #return directorio

def genera_lista_seleccionados_bigregion():
    lista_seleccionados=[]
    for i in bigregionslstbox.curselection():
        lista_seleccionados.append(i-1)
    return lista_seleccionados

def genera_lista_seleccionados_aseg():
    lista_seleccionados=[]
    for i in aseglstbox.curselection():
        lista_seleccionados.append(i-1)
    return lista_seleccionados

def genera_lista_seleccionados_lh_aparc():
    lista_seleccionados=[]
    for i in lh_aparclstbox.curselection():
        lista_seleccionados.append(i-1)
    return lista_seleccionados

def genera_lista_seleccionados_rh_aparc():
    lista_seleccionados=[]
    for i in rh_aparclstbox.curselection():
        lista_seleccionados.append(i-1)
    return lista_seleccionados

def grafico(dataframe_trans,subject,name_file,titulo):
    #grafica el dataframe y los guarda en JPG en la carpeta de ejecucion
    dataframe_trans[subject].plot(kind="barh",width=0.8,figsize=(10,8),color="palegreen")
    plt.title(titulo)
    plt.yticks(fontsize=10,color='k')
    plt.tick_params(axis="y",direction="in", pad=-350)
    plt.savefig(name_file,format="jpg")
    plt.show()

def todos_los_graficos():
    
    grafico(carga_csv_bigregions(muestra_seleccionado() + "/normative_z_scores"),obtiene_subject_name(),"GENERAL.jpg","GENERAL")
    grafico(carga_csv_aseg(muestra_seleccionado() + "/normative_z_scores"),obtiene_subject_name(),"Subcorticales.jpg","Subcorticales")
    grafico(carga_csv_lh_aparc(muestra_seleccionado() + "/normative_z_scores"),obtiene_subject_name(),"Hemisferio izquierdo estructuras corticales.jpg","Corteza HI")
    grafico(carga_csv_rh_aparc(muestra_seleccionado() + "/normative_z_scores"),obtiene_subject_name(),"Hemisferio derecho estructuras corticales.jpg","Corteza HD")
    name=obtiene_nombre()
    surname=obtiene_apellido()
    age=obtiene_edad()
    sex=obtiene_sexo()
    now=datetime.now()
    date=str(now.day)+ "/" + str(now.month)+ "/" + str(now.year)
    genera_informe(name, surname, age, sex, date)

def genera_informe(nombre,apellido,edad,sexo,fecha_informe):

    guarda_como=tk.filedialog.asksaveasfile(mode="w",defaultextension=".pdf")

    pdf=FPDF(orientation="p",unit="mm",format="A4")
    pdf.add_page()
    pdf.line(5, 15, 200, 15)
    pdf.image("logo.png",x=10,y=20,w=30,h=40)
    pdf.set_font("Arial","",16)
    pdf.text(x=50,y=23,txt="INFORME DE VOLUMETRIA CEREBRAL")
    pdf.text(x=50,y=30,txt="Nombre:"+ nombre + " " +  apellido)
    pdf.text(x=50,y=37,txt="Edad: " + edad)
    pdf.text(x=50,y=44,txt="Sexo: "+ sexo)
    pdf.text(x=50,y=51,txt="Fecha de informe: " + fecha_informe)
    pdf.line(5, 60, 200, 60)
    pdf.text(x=50,y=70,txt="Estadisticas generales")
    pdf.image("general.jpg",x=10,y=73,w=200,h=200)
    pdf.text(x=100,y=265,txt="Z-SCORE")
    pdf.line(5, 270, 200, 270)
    pdf.set_font("Arial","",10)
    pdf.text(x=4,y=280,txt="No aprobado para uso clinico.Basado en FreeSufer 6(https://surfer.nmr.mgh.harvard.edu/fswiki/FreeSurferMethodsCitation)")
    pdf.text(x=4,y=285,txt=" y NOMIS(NOrmative Morphometry Image Statistics) Potvin, Olivier et al. Normative morphometric data for cerebral cortical areas")
    pdf.text(x=4,y=290,txt="over the lifetime of the adult human brain. NeuroImage vol. 156 (2017): 315-339. doi:10.1016/j.neuroimage.2017.05.019")

    pdf.add_page()
    pdf.line(5, 15, 200, 15)
    pdf.image("logo.png",x=10,y=20,w=30,h=40)
    pdf.set_font("Arial","",16)
    pdf.text(x=50,y=30,txt="Nombre:"+ nombre + " " +  apellido)
    pdf.text(x=50,y=37,txt="Edad: " + edad)
    pdf.text(x=50,y=44,txt="Sexo: "+ sexo)
    pdf.text(x=50,y=51,txt="Fecha de informe: " + fecha_informe)
    pdf.line(5, 60, 200, 60)
    pdf.text(x=50,y=70,txt="Estructuras subcorticales")
    pdf.image("Subcorticales.jpg",x=10,y=73,w=200,h=200)
    pdf.text(x=100,y=265,txt="Z-SCORE")
    pdf.line(5, 270, 200, 270)
    pdf.set_font("Arial","",10)
    pdf.text(x=4,y=280,txt="No aprobado para uso clinico. Basado en FreeSufer (https://surfer.nmr.mgh.harvard.edu/fswiki/FreeSurferMethodsCitation)")
    pdf.text(x=4,y=285,txt=" y NOMIS(NOrmative Morphometry Image Statistics) Potvin, Olivier et al. Normative morphometric data for cerebral cortical areas")
    pdf.text(x=4,y=290,txt="over the lifetime of the adult human brain. NeuroImage vol. 156 (2017): 315-339. doi:10.1016/j.neuroimage.2017.05.019")

    pdf.add_page()
    pdf.line(5, 15, 200, 15)
    pdf.image("logo.png",x=10,y=20,w=30,h=40)
    pdf.set_font("Arial","",16)
    pdf.text(x=50,y=30,txt="Nombre:"+ nombre + " " +  apellido)
    pdf.text(x=50,y=37,txt="Edad: " + edad)
    pdf.text(x=50,y=44,txt="Sexo: "+ sexo)
    pdf.text(x=50,y=51,txt="Fecha de informe: " + fecha_informe)
    pdf.line(5, 60, 200, 60)
    pdf.text(x=50,y=70,txt="Estructuras corticales hemisferio izquierdo")
    pdf.image("Hemisferio izquierdo estructuras corticales.jpg",x=10,y=73,w=200,h=200)
    pdf.text(x=100,y=265,txt="Z-SCORE")
    pdf.line(5, 270, 200, 270)
    pdf.set_font("Arial","",10)
    pdf.text(x=4,y=280,txt="No aprobado para uso clinico. Basado en FreeSufer (https://surfer.nmr.mgh.harvard.edu/fswiki/FreeSurferMethodsCitation)")
    pdf.text(x=4,y=285,txt=" y NOMIS(NOrmative Morphometry Image Statistics) Potvin, Olivier et al. Normative morphometric data for cerebral cortical areas")
    pdf.text(x=4,y=290,txt="over the lifetime of the adult human brain. NeuroImage vol. 156 (2017): 315-339. doi:10.1016/j.neuroimage.2017.05.019")

    pdf.add_page()
    pdf.line(5, 15, 200, 15)
    pdf.image("logo.png",x=10,y=20,w=30,h=40)
    pdf.set_font("Arial","",16)
    pdf.text(x=50,y=30,txt="Nombre:"+ nombre + " " +  apellido)
    pdf.text(x=50,y=37,txt="Edad: " + edad)
    pdf.text(x=50,y=44,txt="Sexo: "+ sexo)
    pdf.text(x=50,y=51,txt="Fecha de informe: " + fecha_informe)
    pdf.line(5, 60, 200, 60)
    pdf.text(x=50,y=70,txt="Estructuras corticales hemisferio derecho")
    pdf.image("Hemisferio derecho estructuras corticales.jpg",x=10,y=73,w=200,h=200)
    pdf.text(x=100,y=265,txt="Z-SCORE")
    pdf.line(5, 270, 200, 270)
    pdf.set_font("Arial","",10)
    pdf.text(x=4,y=280,txt="No aprobado para uso clinico. Basado en FreeSufer (https://surfer.nmr.mgh.harvard.edu/fswiki/FreeSurferMethodsCitation)")
    pdf.text(x=4,y=285,txt=" y NOMIS(NOrmative Morphometry Image Statistics) Potvin, Olivier et al. Normative morphometric data for cerebral cortical areas")
    pdf.text(x=4,y=290,txt="over the lifetime of the adult human brain. NeuroImage vol. 156 (2017): 315-339. doi:10.1016/j.neuroimage.2017.05.019")

    pdf.output(guarda_como.name)

def selecciona_grosor_lh():
    lista_x=[3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,78,81,84,87,90,93,96,99,102]
    for i in lista_x:
        lh_aparclstbox.select_set(i)
    bigregionslstbox.focus_set()

def selecciona_vol_lh():
    lista_x=[1,4,7,10,13,16,19,22,25,28,31,34,37,40,43,46,49,52,55,58,61,64,67,70,73,76,79,82,85,88,91,94,97,100]
    for i in lista_x:
        lh_aparclstbox.select_set(i)
    bigregionslstbox.focus_set()

def selecciona_superficie_lh():
    lista_x=[2,5,8,11,14,17,20,23,26,29,32,35,38,41,44,47,50,53,56,59,62,65,68,71,74,77,80,83,86,89,92,95,98,101]
    for i in lista_x:
        lh_aparclstbox.select_set(i)
    bigregionslstbox.focus_set()

def selecciona_grosor_rh():
    lista_x=[3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,78,81,84,87,90,93,96,99,102]
    for i in lista_x:
        rh_aparclstbox.select_set(i)
    bigregionslstbox.focus_set()

def selecciona_vol_rh():
    lista_x=[1,4,7,10,13,16,19,22,25,28,31,34,37,40,43,46,49,52,55,58,61,64,67,70,73,76,79,82,85,88,91,94,97,100]
    for i in lista_x:
        rh_aparclstbox.select_set(i)
    bigregionslstbox.focus_set()

def selecciona_superficie_rh():
    lista_x=[2,5,8,11,14,17,20,23,26,29,32,35,38,41,44,47,50,53,56,59,62,65,68,71,74,77,80,83,86,89,92,95,98,101]
    for i in lista_x:
        rh_aparclstbox.select_set(i)
    bigregionslstbox.focus_set()

def selecciona_estandar_subcortical():
    lista_x=[3,6,9,12,13,14,17,20,23,24,25,27]
    for i in lista_x:
        aseglstbox.select_set(i)
    bigregionslstbox.focus_set()

def selecciona_estandar_general():
    lista_x=[4,5,6,13,16,17,18]
    for i in lista_x:
        bigregionslstbox.select_set(i)
    bigregionslstbox.focus_set()

def muestra_seleccionado():
    # Obtiene la ruta NOMIS del paciente seleccionado y lo guarda en la variable ruta_nomis_sin_comillas
    seleccionado=arbol.set(arbol.selection())
    ruta_nomis=seleccionado.get("'directorio_nomis',")
    ruta_nomis_sin_comillas=ruta_nomis.replace("'","")

    return ruta_nomis_sin_comillas

def obtiene_subject_name():
    seleccionado=arbol.set(arbol.selection())
    subjet_name=seleccionado.get("'directorio_fs',")
    subjet_name_sin_comillas=subjet_name.replace("'","")
    
    subject_name_solo=os.path.basename(subjet_name_sin_comillas)
    
    return subject_name_solo

def obtiene_nombre():
    seleccionado=arbol.set(arbol.selection())
    name=seleccionado.get("'nombres',")
    name_sin_comillas=name.replace("'","")
    return name_sin_comillas

def obtiene_apellido():
    seleccionado=arbol.set(arbol.selection())
    apellido=seleccionado.get("'apellidos',")
    apellido_sin_comillas=apellido.replace("'","")
    return apellido_sin_comillas

def obtiene_edad():
    seleccionado=arbol.set(arbol.selection())
    edad=seleccionado.get("'edad',")
    edad_sin_comillas=edad.replace("'","")
    return edad_sin_comillas

def obtiene_sexo():
    seleccionado=arbol.set(arbol.selection())
    sexo=seleccionado.get("'sexo',")
    sexo_sin_comillas=sexo.replace("'","")
    return sexo_sin_comillas

def ingresar_paciente():
    os.system('python ingreso_paciente.py')

df_bbdd=pd.read_csv( os.getcwd() + "/bbdd/bbdd.csv",index_col=0)

def actualiza_base():
    arbol.delete(*arbol.get_children()) # Borra el treeview antes de actualizarlo para que no se duplique
    df_bbdd=pd.read_csv(os.getcwd() + "/bbdd/bbdd.csv",index_col=0)
    i=0
    for i in range(len(df_bbdd.index)):
        base=()
        base=df_bbdd.iloc[i].values
        base_tupla=tuple(base)
        arbol.insert("", END,values=base_tupla)
        i=i+1



ventana=tk.Tk()
ventana.wm_title("Green Hare Informe en Volumetria cerebral")
ventana.geometry("1070x800")

boton_directorio=Button(text="Seleccionar paciente",command=lambda: selecciona_directorio())
boton_directorio.place(x=30,y=550)

boton_grafico=Button(text="Generar Informe",command=lambda:todos_los_graficos())
boton_grafico.place(x=180,y=550)

boton_ingreso=Button(text="Ingresar paciente",command=ingresar_paciente)
boton_ingreso.place(x=300,y=550)

boton_ingreso=Button(text="Actualizar...",command=actualiza_base)
boton_ingreso.place(x=420,y=550)


boton=tk.Button(command=muestra_seleccionado,text="Seleccionar")
boton.place(x=80,y=520)
boton.place_forget()

boton2=tk.Button(command=obtiene_subject_name,text="Seleccionar(subject)")
boton2.place(x=80,y=550)
boton2.place_forget()

boton_grosor_lh=Button(text="Grosor cortical",command=lambda:selecciona_grosor_lh())
boton_grosor_lh.place(x=530,y=500)

boton_vol_lh=Button(text="Volumen cortical",command=lambda:selecciona_vol_lh())
boton_vol_lh.place(x=530,y=530)

boton_superficie_lh=Button(text="Superficie cortical",command=lambda:selecciona_superficie_lh())
boton_superficie_lh.place(x=530,y=560)

boton_grosor_rh=Button(text="Grosor cortical",command=lambda:selecciona_grosor_rh())
boton_grosor_rh.place(x=800,y=500)

boton_vol_rh=Button(text="Volumen cortical",command=lambda:selecciona_vol_rh())
boton_vol_rh.place(x=800,y=530)

boton_superficie_rh=Button(text="Superficie cortical",command=lambda:selecciona_superficie_rh())
boton_superficie_rh.place(x=800,y=560)

boton_estandar_subcortical=Button(text="Seleccion estandar",command=lambda:selecciona_estandar_subcortical())
boton_estandar_subcortical.place(x=270,y=500)

boton_estandar_general=Button(text="Seleccion estandar",command=lambda:selecciona_estandar_general())
boton_estandar_general.place(x=10,y=500)

estructuras_generales_label=tk.Label(text="Estructuras generales ")
estructuras_generales_label.place(x=10,y=10)

bigregionslstbox=tk.Listbox(ventana,selectmode="multiple",exportselection=False)
bigregionslstbox.place(width=250,height=450)
bigregionslstbox.place(x=10,y=40)

estructuras_subcorticales_label=tk.Label(text="Estructuras subcorticales ")
estructuras_subcorticales_label.place(x=270,y=10)

aseglstbox=tk.Listbox(ventana,selectmode="multiple",exportselection=False)
aseglstbox.place(width=250,height=450)
aseglstbox.place(x=270,y=40)
barra_aseg=Scrollbar(command=aseglstbox.yview)
barra_aseg.place(x=510,y=40,height=450)
aseglstbox.config(yscrollcommand=barra_aseg.set)

estructuras_corticales_HI_label=tk.Label(text="Estructuras corticales H izq ")
estructuras_corticales_HI_label.place(x=530,y=10)

lh_aparclstbox=tk.Listbox(ventana,selectmode="multiple",exportselection=False)
lh_aparclstbox.place(width=250,height=450)
lh_aparclstbox.place(x=530,y=40)
barra_lh=Scrollbar(command=lh_aparclstbox.yview)
barra_lh.place(x=780,y=40,height=450)
lh_aparclstbox.config(yscrollcommand=barra_lh.set)

estructuras_corticales_HI_label=tk.Label(text="Estructuras corticales H der ")
estructuras_corticales_HI_label.place(x=800,y=10)

rh_aparclstbox=tk.Listbox(ventana,selectmode="multiple",exportselection=False)
rh_aparclstbox.place(width=250,height=450)
rh_aparclstbox.place(x=800,y=40)
barra_rh=Scrollbar(command=rh_aparclstbox.yview)
barra_rh.place(x=1035,y=40,height=450)
rh_aparclstbox.config(yscrollcommand=barra_rh.set)

# En esta parte viene la tabla para elegir el paciente

arbol=ttk.Treeview(ventana,columns=df_bbdd.columns)
arbol.place(x=10,y=600,width=1020,height=180)
arbol.heading("#1", text='ID')
arbol.heading("#2", text='DNI')
arbol.heading("#3", text='Nombre')
arbol.heading("#4", text='Apellido')
arbol.heading("#5", text='Edad')
arbol.heading("#6", text='Sexo')
arbol.heading("#7", text='Directorio FreeSurfer')
arbol.heading("#8", text='Directorio Nomis')
arbol.heading("#9", text='Fecha')


barra_arbol=Scrollbar(command=arbol.yview)
barra_arbol.place(x=1040,y=600,height=180)
arbol.config(yscrollcommand=barra_arbol.set)

barra_arbol_horizontal=Scrollbar(command=arbol.xview,orient="horizontal")
barra_arbol_horizontal.place(x=10,y=770,width=1030)
arbol.config(xscrollcommand=barra_arbol_horizontal.set)

ventana.mainloop()