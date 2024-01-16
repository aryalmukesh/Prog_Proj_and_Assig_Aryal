# TIE-02106 Introduction to Programming
# Graphical User Inferface project, C-task
# MUKESH ARYAL, aryalm@student.tut.fi, student no: 268456

# The following program creates a graphical interface for unit conversion
# from kilograms to pound.
# The program asks for a single input and displays the result through an
# interactinve graphical interface.

from tkinter import *
from tkinter import ttk


# The following function converts the input value assumed to be in kilograms(kg)
# to equivalent numerical value of pound(lbs).
def calculate():
    try:
        value = float(Kilogram.get())
        Pound.set(format(value*2.20462,".4f"))
    except ValueError:
        pass

# defining main window of the program.
root = Tk()

# defining header of the interface.
root.title("Unit Converter")

# dividing the main windows into sub-sections.
mainframe = ttk.Frame(root, padding="3 3 12 12")
mainframe.grid(column=0, row=0, sticky=(N, W, E, S))
mainframe.columnconfigure(0, weight=1)
mainframe.rowconfigure(0, weight=1)

# variables to store the input values.
Kilogram = StringVar()
Pound = StringVar()

# assigning suitable position of the entries in the main interface.
kilogram_input = ttk.Entry(mainframe, width=7, textvariable=Kilogram)
kilogram_input.grid(column=1, row=1, sticky=E)
ttk.Label(mainframe, textvariable=Pound).grid(column=2, row=2, sticky=(E, W))
ttk.Button(mainframe, text="Calculate", command=calculate).grid(column=3,row=3,sticky=W)
ttk.Label(mainframe, text="kg").grid(column=2, row=1, sticky=(E,W))
ttk.Label(mainframe, text="is equivalent to").grid(column=1, row=2, sticky=E)
ttk.Label(mainframe, text="lbs.").grid(column=3, row=2, sticky=W)

for child in mainframe.winfo_children(): child.grid_configure(padx=5, pady=5)

root.mainloop()
