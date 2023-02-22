# -*- coding: utf-8 -*-
"""
Created on Sat Nov  9 06:44:27 2019

@author: Sai
"""

import numpy as np
import struct

def sp_load_file_for_script(folder, filebasename, prefix):
    filepath = folder + '\\' + filebasename + ' ' + prefix + ' raw.gsf'
    with open(filepath, 'rb') as fid:
    
        line1 = fid.readline()
        
        # Find xRes
        line2 = fid.readline()
        xidx = str(line2).find('=')
        xres = int(str(line2)[xidx+1:-3])
        
        # Find yRes
        line3 = fid.readline()
        yidx = str(line3).find('=')
        yres = int(str(line3)[yidx+1:-3])
        
        #  lines 4, 5, 6, 7 and 8 give Neaspec info and x and y offsets, which we will not use.
        line4 = fid.readline(); line5 = fid.readline(); line6 = fid.readline(); 
        line7 = fid.readline(); line8 = fid.readline();
        
        # Find xExt
        line9 = fid.readline()
        xeidx = str(line9).find('=')
        xext = float(str(line9)[xeidx+1:-3])
        
        # Find yExt
        line10 = fid.readline()
        yeidx = str(line10).find('=')
        yext = float(str(line10)[yeidx+1:-3])
        
        # Define x and y arrays
        dx=xext/xres
        dy=yext/yres
        
        x = np.arange(dx, xext+dx, dx)
        y = np.arange(dy, yext+dy, dy)
        
        # Read the rest of the header even though it's not useful
        line11 = fid.readline(); line12 = fid.readline();
        line13 = fid.readline(); line14 = fid.readline();
        
        header_end = fid.tell()
    #    print(header_end)
        
        # Not sure why the '+2' and '+3' are necessary but otherwise it does not work
        if header_end%2 == 0:
            if header_end < 245:
                header_end = header_end + 4
            elif header_end == 248:
                    # do nothing - 248 is perfect (maybe?)
                    header_end += 4
            else:
                header_end = header_end + 2
        else:
            if header_end == 235:
                header_end = header_end + 1
            else:
                header_end = header_end + 1
        
    #    print(header_end)
        fid.seek(header_end)
        
        # print(fid.read())
        # print(fid.read(4))
        
        blocksize = 4   # We want to read floats of size 4 bytes
        data = []
        
        while True:
            buf = fid.read(blocksize)
            if not buf:
                break
            data.append(struct.unpack('<f', buf)[0])    # '<' is for little-endian, 'f' for float
    
    data = np.reshape(data, [len(y), len(x)])
    
    return x, y, data

# ASC files from Attocube
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

# ASC files from Gwyddion
def sp_load_file_for_script_ac_gwy(folder, sc_num, prefix):
    filepath = folder + '\\' + 'SC_' + str(sc_num) + '-' + prefix + '.asc'
    with open(filepath, 'rb') as fid:
    
        # Skip the first three lines
        line1 = fid.readline()
        line2 = fid.readline()
        line3 = fid.readline()
        
        # Find xRes
        line4 = fid.readline()
        # print(line4)
        xidx = str(line4).find('=')
        xres = int(str(line4)[xidx+2:-5])
        
        # Find yRes
        line5 = fid.readline()
        # print(line5)
        yidx = str(line5).find('=')
        yres = int(str(line5)[xidx+2:-5])
        
        # Find xExt
        line6 = fid.readline()
        # print(line6)
        xeidx = str(line6).find('=')
        # print(str(line6)[xeidx+2:-5])
        xext = float(str(line6)[xeidx+2:-5])
        
        # Find yExt
        line7 = fid.readline()
        # print(line7)
        yeidx = str(line7).find('=')
        # print(str(line7)[yeidx+2:-5])
        yext = float(str(line7)[yeidx+2:-5])
        
        # Define x and y arrays
        dx=xext/xres
        dy=yext/yres
        
        x = np.linspace(dx/2, xext-dx/2, xres)
        y = np.linspace(dy/2, yext-dy/2, yres)
        
        # Read the rest of the header even though it's not useful
        line8 = fid.readline(); line9 = fid.readline(); line10 = fid.readline(); 
        line11 = fid.readline();
        
        data = []
        
        while True:
            line = fid.readline()
            if not line:
                break    
            line_list = str(line).split(r'\t')
            for idx, string in enumerate(line_list):
                if idx == 0:
                    data.append(float(string[2:]))
                elif idx == len(line_list)-1:
                    data.append(float(string[:-5]))
                else:
                    data.append(float(string))
                
    data = np.reshape(data, [len(y), len(x)])
    
    return x, y, data