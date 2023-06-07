# -*- coding: utf-8 -*-
"""
 Pede uma pasta, lê todas as pastas dentro da pasta pedida no primeiro nível.
 lê todos os arquivos .tif/.tiff,
 faz colocalização e intensidade integrada dos 3 primeiros canais,
 faz um único arquivo .csv para cada pasta.
 
 Criado: André
 Alterado: Gabriel
 
"""

from datetime import date
from skimage import io
import numpy as np
import os
import pandas as pd

# data de hoje
today = date.today()
d4 = today.strftime("%d-%b-%Y") # converte num formato que eu quero

# data frame vazio
full_data = pd.DataFrame(columns=['label', 'gammah2ax_fak', 'gammah2ax_ku80', 'fak_ku80', 'gammah2ax_rawintden', 'fak_rawintden', 'ku80_rawintden'])

# me pergunta onde estão os arquivos que vão ser processados
folder_with_cells = input("place the path to your cells here: ") #pedir qual pasta vai ser usado o código
os.chdir(folder_with_cells)



def correlacao():
    '''
    Open .tif in directory
    Returns .csv with pearson corr and integrated intensity
    '''
    full_data = pd.DataFrame(columns=['label', 'gammah2ax_fak', 'gammah2ax_ku80', 'fak_ku80', 'gammah2ax_rawintden', 'fak_rawintden', 'ku80_rawintden'])
    for file in os.listdir():
        if file.split('.')[-1] == 'tif' or 'tiff': # checar se o arquivo é um .tif
        
            img = io.imread(file) # abrir a imagem
            label = os.path.basename(file) # nome do arquivo
            print(label)
                
            
            
            # separa os canais em variáveis
            gammah2ax_stack = np.sum(np.array(img[:,:,:,0]), axis = 0)     #soma todos os z (axis=0) de todos os x e y no canal 0
            ku80_stack = np.sum(np.array(img[:,:,:,1]), axis = 0)          #soma todos os z (axis=0) de todos os x e y no canal 1
            fak_stack = np.sum(np.array(img[:,:,:,2]), axis = 0)           #soma todos os z (axis=0) de todos os x e y no canal 2
     
            # deixa a matriz reta
            gammah2ax_stack_flat = gammah2ax_stack.flatten() 
            fak_stack_flat = fak_stack.flatten()
            ku80_stack_flat = ku80_stack.flatten()
            
            # actin_array = np.array([]) #cria uma matriz vazia
            gammah2ax_array = np.array([])
            ku80_array = np.array([])
            fak_array = np.array([])
            
            # somar todas as intensidades de todos os pixels do mesmo canal
            gammah2ax_rawintden = sum(gammah2ax_stack_flat)  # Eu ainda n sei como fazer int_den no python, pq tem que puxar o tamanho do pixel em relação a realidade, ainda n sei
            fak_rawintden = sum(fak_stack_flat)
            ku80_rawintden = sum(ku80_stack_flat)
               
            gammah2ax_array = np.append(gammah2ax_array, gammah2ax_stack_flat) #coloca o flat nesse array
            fak_array = np.append(fak_array, fak_stack_flat)
            ku80_array = np.append(ku80_array, ku80_stack_flat)
            
            pearson_gammah2ax_fak = np.corrcoef(gammah2ax_array, fak_array)[0][1] #coef de pearson vem em 2x2 então o [0][1] pega o valor que eu quero e eu jogo isso pra uma variável
            pearson_gammah2ax_ku80 = np.corrcoef(gammah2ax_array, ku80_array)[0][1]
            pearson_fak_ku80 = np.corrcoef(fak_array, ku80_array)[0][1]
    
            df_rcorr = pd.DataFrame(np.transpose([[label], [pearson_gammah2ax_fak], [pearson_gammah2ax_ku80], [pearson_fak_ku80], [gammah2ax_rawintden], [fak_rawintden], [ku80_rawintden]]), 
                         columns=['label', 'gammah2ax_fak', 'gammah2ax_ku80', 'fak_ku80', 'gammah2ax_rawintden', 'fak_rawintden', 'ku80_rawintden'])
            # do .append pra colocar por ultimo, e ignore_index=True pq o programa é meio chato, ele se recusa a colocar se ele acha que tem um index, se ele ignora, ele só põe embaixo )
            full_data = full_data.append(df_rcorr, ignore_index=True)
            
    nome_cell = os.path.basename(os.getcwd())
    result_name = nome_cell + '-pbp_rcorr-int-' + d4 + '.csv' #como vai ser o nome do arquivo csv
    full_data.to_csv(result_name) #salva a data em csv com o nome que eu falei acima

for directory in os.listdir():
    
    
    if os.path.isdir(os.path.join(os.getcwd(), directory)) == True:
        os.chdir(os.path.join(os.getcwd(), directory))
        
        
        # cria um novo dataframe vazio para a próxima pasta
        full_data = pd.DataFrame(columns=['label', 'gammah2ax_fak', 'gammah2ax_ku80', 'fak_ku80', 'gammah2ax_rawintden', 'fak_rawintden', 'ku80_rawintden'])
        
        # Ação dentro da pasta
        correlacao()
        # sair da pasta
        os.chdir('..')


print("Fim!")