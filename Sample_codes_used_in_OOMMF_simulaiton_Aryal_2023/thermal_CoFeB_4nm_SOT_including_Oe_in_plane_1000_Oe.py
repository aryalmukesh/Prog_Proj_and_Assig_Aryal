# Script to automatically feed the output of one OOMMF simulation into the
# input of another. 

import subprocess
import os
import glob

# A function to find the omf magnetisation vector files in a particular folder.
def get_omf(path):
    omf_path = '%s/*.omf' % (path)
    files = glob.glob(omf_path)
    file_no = len(files) - 1
    omf_file = files[file_no]
    omf_file = os.path.basename(omf_file)
    return omf_file

# A function to set the magnitude of current or field applied to the system. 
def set_driver_strength(start_val=-300, end_val=325, lower_val=80, higher_val=120, finer_step=5, coarse_step=50):
    up_flag = 1
    step = coarse_step
    x_list = []
    val = start_val
    num_of_cylces = 1
    offset = 25
    while (val <= end_val):
        if (val == end_val):
            up_flag = 0
        if (up_flag == 1):
            if (val >= lower_val and val < higher_val):
                step = finer_step
            else:
                step = coarse_step
        x_list.append(val)
        val = val + offset + step
    val = val-2*step
    if (num_of_cylces == 1):
        while (val >= start_val):
            if (val == start_val):
                up_flag = 1
            if (up_flag == 0):
                if (val > -higher_val and val <= -lower_val):
                    step = finer_step
                else:
                    step = coarse_step
            x_list.append(val)
            val = val - step

    driver_amp = [0]
    for ele in x_list:
        driver_amp.append(ele*1)

    print(driver_amp)

    return driver_amp


# Directory/path to the oommf install
path_oommf = '../oommf.tcl'

# MIF file name
mif_file = 'thermal_CoFeB_4nm_SOT_including_Oe_in_plane_1000_Oe.mif'

# Initial name of the magnetization vector file used in the simulation, later updated inside the main loop. 
initial_omf_file = '06_thermal_CoFeB_4nm_with_Oe_J0.omf'
in_omf = initial_omf_file

flag = 0
# Flag to control init_sim parameter of MIF file. 
file_order = 1
file_order_step = 1
driver = 'current'
driver_strength = set_driver_strength()
index = 0

while index<=len(driver_strength):
    ele = driver_strength[index]
    str_file_order = f'{file_order:.1f}'
    
    if (file_order < 10):
        str_file_order = '00'+str_file_order
    elif(file_order < 100):
        str_file_order = '0'+str_file_order
        
    # Set the output folder for this iteration
    out_folder = 'output/%s_%s_%s' % (str_file_order,driver,ele)
    file_order = file_order + file_order_step
    
    # If folder doesn't already exist, making the folder.
    if not os.path.exists(out_folder):
        os.makedirs(out_folder)

    # Preparing the oommf string to use boxsi.
    oommf_string = 'tclsh' + ' ' + path_oommf + \
        ' boxsi -parameters "init_sim %s in_omf %s total_current %s out_folder %s\" -- %s' % (
            flag, in_omf, ele, out_folder, mif_file)
    print(oommf_string)
    subprocess.call(oommf_string, shell=True)

    # Updating in_omf for next run. 
    in_omf = out_folder + '/' + get_omf(out_folder)
    flag = 0    
    index = index + 1

# Killing all apps at the end of the simulation (OPTIONAL)  
kill_all = 'tclsh %s killoommf all' % (path_oommf)
subprocess.call(kill_all, shell = True)
