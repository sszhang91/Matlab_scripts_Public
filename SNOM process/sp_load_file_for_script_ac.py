# -*- coding: utf-8 -*-
"""
Created on Mon Nov 11 21:42:19 2019

@author: Sai
"""

import numpy as np
#import struct

def sp_load_file_for_script_ac(folder, sc_num, prefix):
    filepath = folder + '\\' + 'SC_' + str(sc_num) + '-' + prefix + '.asc'
    with open(filepath, 'rb') as fid:
    
        # Skip the first three lines
        line1 = fid.readline()
        line2 = fid.readline()
        line3 = fid.readline()
        
        # Find xRes
        line4 = fid.readline()
        # print(line4)
        xidx = str(line4).find(':')
        xres = int(str(line4)[xidx+3:-5])
        
        # Find yRes
        line5 = fid.readline()
        # print(line5)
        yidx = str(line5).find(':')
        yres = int(str(line5)[xidx+3:-5])
        
        # Find xExt
        line6 = fid.readline()
        xeidx = str(line6).find(':')
        xext = float(str(line6)[xeidx+3:-5])
        
        # Find yExt
        line7 = fid.readline()
        yeidx = str(line7).find(':')
        yext = float(str(line7)[yeidx+3:-5])
        
        # Define x and y arrays
        dx=xext/xres
        dy=yext/yres
        
        x = np.linspace(dx/2, xext-dx/2, xres)
        y = np.linspace(dy/2, yext-dy/2, yres)
        
        # Read the rest of the header even though it's not useful
        line8 = fid.readline(); line9 = fid.readline(); line10 = fid.readline(); 
        line11 = fid.readline(); line12 = fid.readline(); line13 = fid.readline(); 
        line14 = fid.readline(); 
        
        data = []
        
        while True:
            line = fid.readline()
            if not line:
                break    
            data.append(float(line))
                
    data = np.reshape(data, [len(y), len(x)])
    
    return x, y, data
