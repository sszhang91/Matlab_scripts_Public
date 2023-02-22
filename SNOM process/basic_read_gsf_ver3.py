# -*- coding: utf-8 -*-
"""
Created on Mon Nov 11 20:56:13 2019

@author: Sai
"""

import numpy as np

def basic_read_gsf_ver3(pathdir):
    flag_vect=0 # for nx,ny,Lx,Ly,x0,y0
    f_meta = open(pathdir, "r", encoding="ISO-8859-1")
    f_data = open(pathdir, "r", encoding="ISO-8859-1")

    new_line = f_meta.readline()
    while new_line[0].isalpha():
        rnan = new_line.find('=')
        if 'XRes' in new_line:
            nx = int(new_line[rnan+1:])
        if 'XRes' in new_line:
            ny = int(new_line[rnan+1:])
        if 'XReal' in new_line:
            Lx = float(new_line[rnan+1:])
        if 'YReal' in new_line:
            Ly = float(new_line[rnan+1:])
        if 'XOffset' in new_line:
            x0 = float(new_line[rnan+1:])
            flag_vect=1
        if 'YOffset' in new_line:
            y0 = float(new_line[rnan+1:])
        new_line = f_meta.readline()
        f_data.readline()
        
    if not flag_vect:
        x0=0
        y0=0

    count0 = 0
    flag = False
    while not flag:
        if count0 + 1 <= len(new_line):
            if new_line[count0+1] == ' ':
                count0 += 1
            else:
                flag = True
        else:
            flag = True
            count0=len(new_line)

    np.fromfile(f_data, dtype=np.int8, count=count0)
    N = nx*ny
    a = np.fromfile(f_data, dtype=np.float32, count=N)

    f_meta.close()
    f_data.close()

    xvect = np.linspace(-Lx/2,Lx/2,nx)
    yvect = np.linspace(-Ly/2,Ly/2,ny)

    M = np.reshape(a,(nx,ny))
    M = np.transpose(M)

    return xvect, yvect, M, x0, y0