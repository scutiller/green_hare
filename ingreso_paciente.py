import pandas as pd
import tkinter as tk
from tkinter import *
from tkinter import filedialog
import os
import subprocess
from tkinter import ttk
from datetime import datetime


def selecciona_directorio_fs():
    directorio_fs=tk.filedialog.askdirectory()
    subjectentry.delete(0,"end")
    subjectentry.insert(0, directorio_fs)
   

def go():
    
    #guarda en la variable sexo el resultado de la seleccion del boton de sexo
    if femvalue.get()==1:
        sexo="F"
    else:
        sexo="M"
    # saca el ID como nombre del directorio dentro del directorio subjects de FreeSurfer
    id=os.path.basename(subjectentry.get())
    
    # genera DF con columnas del CSV NOMIS
    df_csv_nomis=pd.DataFrame(columns=["id","sex","age"])
    # agrega al DF los valores introducidos por el usuario
    df_csv_nomis=df_csv_nomis.append({"id":id,"sex":sexo,"age":edad_paciente.get()},ignore_index=True)
    # crea directorio donde guarda el CSV para NOMIS
    ruta_csv_nomis="nomisstat/" + id + dni_paciente.get()
    os.makedirs(ruta_csv_nomis)
    #guarda df como csv en el directorio correspondiente
    df_csv_nomis.to_csv(ruta_csv_nomis + "/" + "csv.csv",index=False)
    
    #ejecuta NOMIS
    
    ruta=os.getcwd()+"/NOMIS/NOMIS.py"
    ruta_sujeto= subjectentry.get()
    #obtiene el directorio subjects
    separador = os.path.sep
    dir_FS = separador.join(ruta_sujeto.split(separador)[:-1])  
    
    os.system("python NOMIS/nomis.py -csv " + ruta_csv_nomis + "/csv.csv" " -s " + dir_FS + " -o " + ruta_csv_nomis)
    
    #Agrega paciente a base de datos
    
    #carga el csv con los pacientes ingresados en df_paciente
    df_paciente=pd.read_csv(os.getcwd() + "/bbdd/bbdd.csv",index_col=0)
    #agrega el paciente nuevo al df
    now=datetime.now()
    df_paciente= df_paciente.append({"Id":id + dni_paciente.get(),"dni":dni_paciente.get(),"nombres":nombre_paciente.get(),"apellidos":apellido_paciente.get(),"edad":edad_paciente.get(),"sexo":sexo,"directorio_fs":subjectentry.get(),"directorio_nomis":ruta_csv_nomis,"fecha_informe":now.date()},ignore_index=True)
    #actualiza el csv
    df_paciente.to_csv(os.getcwd() + "/bbdd/bbdd.csv")

    
ventana_ingreso=tk.Tk()

ventana_ingreso.wm_title("Ingreso de paciente...")
ventana_ingreso.geometry("210x430")

nombre_label=tk.Label(ventana_ingreso,text="Nombres del paciente: ")
nombre_label.place(x=10,y=10)

nombre_paciente=tk.Entry(ventana_ingreso)
nombre_paciente.place(x=10,y=40)

apellido_label=tk.Label(ventana_ingreso,text="Apellidos del paciente: ")
apellido_label.place(x=10,y=70)

apellido_paciente=tk.Entry(ventana_ingreso)
apellido_paciente.place(x=10,y=100)

sexo_label=tk.Label(ventana_ingreso,text="Sexo biologico del paciente: ")
sexo_label.place(x=10,y=130)

femvalue=tk.IntVar()
botonfem=tk.Radiobutton(ventana_ingreso,text="Femenino",variable=femvalue,value=1).place(x=10,y=155)
botonmasc=Radiobutton(ventana_ingreso,text="Masculino",value=2).place(x=10,y=175)

edad_label=tk.Label(ventana_ingreso,text="Edad del paciente: ")
edad_label.place(x=10,y=200)

edad_paciente=tk.Entry(ventana_ingreso)
edad_paciente.place(x=10,y=220)


dni_label=tk.Label(ventana_ingreso,text="DNI del paciente: ")
dni_label.place(x=10,y=260)

dni_paciente=tk.Entry(ventana_ingreso)
dni_paciente.place(x=10,y=280)

directorio_freesurfe_label=tk.Label(ventana_ingreso,text="Directorio FreeSurfer: ")
directorio_freesurfe_label.place(x=10,y=310)

subjectentry=tk.Entry(ventana_ingreso)
subjectentry.place(x=10,y=340)

boton_dir_freesurfer=tk.Button(ventana_ingreso,text="Seleccion la ruta FS",command=selecciona_directorio_fs)
boton_dir_freesurfer.place(x=10,y=375)


boton_go=tk.Button(ventana_ingreso,text="Ingresar...", command=go).place(x=10,y=400)


ventana_ingreso.mainloop()

