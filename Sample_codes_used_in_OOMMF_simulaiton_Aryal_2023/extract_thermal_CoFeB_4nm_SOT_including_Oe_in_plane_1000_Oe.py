# Extracting and processing the outputs of automated OOMMF simulation.
import glob
import matplotlib.pyplot as plt
import numpy as np
import csv
import re
import subprocess

# Function to delete redundant files, useful during reruns. 
def delete_file(filename):
    delete_command = 'del '+filename
    subprocess.call(delete_command, shell=True)

# Function to clear existing png(image) files, useful during reruns.
def clear_existing_png():
    files = glob.glob('output/**/*.png', recursive=1)
    for file in files:
        delete_file(file)

# Function to obtain magnetization components from text(.odt) file. 
def get_mag_components(filename):
    mx = 404
    my = 404
    mz = 404
    try:
        f = open(filename, 'r')
        count = 0
        for line in f:
            if (count == 12):
                splitted = line.split()
                mx = float(splitted[0])
                my = float(splitted[1])
                mz = float(splitted[2])
            count += 1
        f.close()
    except:
        print("Error while getting mag components!")
    return mx, my, mz

# Function to extract the average components within a particular region of the simulation world. 
def extract_averaged_mag_over_region(filename):
    try:
        get_average_string = "tclsh ..\oommf.tcl avf2odt -average space -normalize 1 \
                -region 25e-9 35e-9 0 75e-9 65e-9 4e-9 infile "+filename
        subprocess.call(get_average_string, shell=True)
        filename = re.sub(".omf", ".odt", filename)
        mx, my, mz = get_mag_components(filename)
        delete_file(filename)
        return mx, my, mz
    except:
        print("Error while extracting averaged mag over region!")
    return 404, 404, 404

# Function to convert omf file to ppn file which can later be converted to image file. 
def convert_omf_to_ppn(filename):
    clear_existing_png()
    try:
        oommf_command = "tclsh ..\oommf.tcl avf2ppm -config ..\color_config_z.def -f infile " + filename
        subprocess.call(oommf_command, shell=True)
        return 1
    except:
        print("Error while converting omf to ppn!")
    return 0

# Function to extract the magnitude of driver(applied current) used in simulations.
def extract_driver_val(filename, quantity):
    field_float = 404
    try:
        if(quantity == "field"):
            x = re.search("(?<=_B).*\d", filename)
        elif(quantity == "current"):
            x = re.search("(?<=_J).*\d", filename)
        field_str = filename[x.start():x.end()]
        field_float = float(field_str)
    except:
        print("Error while extracting driver value!")
    return field_float

# Function to extract specific values from the origin output text(.odt) file.
def readfile(filename, col_no_1, col_no_2, col_no_3, col_no_4):
    list_1 = []
    list_2 = []
    list_3 = []
    list_4 = []
    try:
        f = open(filename, 'r')
        for line in f:
            splitted = line.split()
#            print('Number of splitted string in line: '+str(len(splitted)))

            if (len(splitted) == col_no_1):

                list_1.append(splitted[col_no_1-1])
                list_2.append(splitted[col_no_2-1])
                list_3.append(splitted[col_no_3-1])
                list_4.append(splitted[col_no_4-1])

        f.close()
    except:
        print("Error while reading odt file. Problem in readfile!")
    if (len(list_1) == 0):
        print("Adjust the length of splitted! No data was appended to the list!")
    return list_1, list_2, list_3, list_4

# Function to put all the required data into a single csv file that can be processed later. 
def write_data_to_file(name, quant, time, driver, mx, my, mz, mx_centre, my_centre, mz_centre):
    try:
        with open(name+'.csv', 'w', newline='') as f:
            writer = csv.writer(f)
            if (quant == "field"):
                attrib = ['Time[s]', 'Applied Field[Oe]', 'Mx', 'My',
                          'Mz', 'Mx_centre', 'My_centre', 'Mz_centre']
            else:
                attrib = ['Time[s]', 'Applied Current[uA]', 'Mx', 'My',
                          'Mz', 'Mx_centre', 'My_centre', 'Mz_centre']
            writer.writerow(attrib)

            for i in range(len(time)):
                writer.writerow([time[i], driver[i], mx[i], my[i],
                                mz[i], mx_centre[i], my_centre[i], mz_centre[i]])
    except:
        print("Error in write_data_to_file!")


def main():
    driver_strength = []
    time = []
    total_time = 0
    mx = []
    my = []
    mz = []
    mx_centre = []
    my_centre = []
    mz_centre = []

    # Processing omf files
    files = glob.glob('output\**\*.omf', recursive=1)
    for file in files:
        # Extracting average magnetization over the centre region
        mx_centre_val, my_centre_val, mz_centre_val = extract_averaged_mag_over_region(
            file)
        mx_centre.append(mx_centre_val)
        my_centre.append(my_centre_val)
        mz_centre.append(mz_centre_val)

        # Making ppn file to convert them to png later
        convert_omf_to_ppn(file)

    # Processing odt files
    files = glob.glob('output/**/*.odt', recursive=1)
    for file in files:
        # Extracting field value
        driver_strength.append(extract_driver_val(file, "current"))

        # Extracting time column(23) and magnetization components (mx:19,my:20,mz:21) from the entire region
        lis1, lis2, lis3, lis4 = readfile(file, 23, 19, 20, 21)
        index = 0
        while (index < len(lis1)):
            try:
                time_entry = lis1[index]
                total_time += float(time_entry)
                time.append(total_time)

                mx_entry = lis2[index]
                mx.append(float(mx_entry))

                my_entry = lis3[index]
                my.append(float(my_entry))

                mz_entry = lis4[index]
                mz.append(float(mz_entry))

                index += 1

            except:
                print('Error!')

    # Writing the appropriate data to the data file
    write_data_to_file(
        'CoFeB_4nm_SOT_including_Oe_in_plane_1000_Oe_hysteresis_data', "current", time, driver_strength, mx, my, mz, mx_centre, my_centre, mz_centre)


main()
