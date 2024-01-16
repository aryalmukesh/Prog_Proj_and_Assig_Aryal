# TIE-02106 Introduction to Programming
# Solution of task Polynome, C-task project.
# MUKESH ARYAL, aryalm@student.tut.fi, student no: 268456

# The following program uses a class 'Polynome' to perform calculations on
# polynomail. The main program can perform addition, substration and mulipli-
# cation. Any other command except these are treated as unknown operators.

# The following class Polynome has two initialization; factor and exponent,
# which are both list obtained after reading a file.
class Polynome:
    def __init__(self,factor,exponent):
        self.factor=factor
        self.exponent=exponent

# The following method removes terms with coefficient '0' from the
# polynomial.
    def remove_zero(self):
        if 0 in self.factor:
            while 0 in self.factor:
                ind=self.factor.index(0)
                self.factor.pop(0)
                self.exponent.pop(ind)
        else:
            pass

# The following method makes a printable polynmial.
    def make_polynomial(self):
        self.remove_zero()
        if self.factor.count(0) == len(self.factor):
            print('0')
        else:
            for p in range(len(self.factor)):
                if p==len(self.factor)-1:
                    print(str(self.factor[p])+'x^'+str(self.exponent[p]))
                elif p!=len(self.factor)-1:
                    print(str(self.factor[p]) + 'x^' + str(self.exponent[p]),end=' + ')

# Methods below, following consecutive three, do the operation addition, substraction,
# and multiplication respectively. They all use a second polynomial as
# as argument and perform corresponding operation to it using main polynomial.
    def addition(self,to_add):
        result_fac,result_exp=process_addition(self.factor,self.exponent,
                            to_add.factor,to_add.exponent)
        resultant=Polynome(result_fac,result_exp)
        print('The simplified result:')
        resultant.make_polynomial()

    def substraction(self,to_deduct):
        result_fac, result_exp = process_substration(self.factor, self.exponent,
                                to_deduct.factor,to_deduct.exponent)
        resultant = Polynome(result_fac, result_exp)
        print('The simplified result:')
        resultant.make_polynomial()

    def multiplication(self,to_multiply):
        result_fac, result_exp = process_multiplication(self.factor, self.exponent,
                                to_multiply.factor,to_multiply.exponent)
        resultant = Polynome(result_fac, result_exp)
        print('The simplified result:')
        resultant.make_polynomial()


# The main program reads a file, whose name is to be entered, and performs
# calculation based on the elements on the file. Operations are limited to
# addition, substraction and multiplication.
def main():
    file_name = input('Enter file name: ')
    try:
        file = open(file_name, 'r')
        all_polymials=make_ind_polynome(file)
        polynome_dict=assign_memory_location(all_polymials)
        command=input('> ')
        while command!= 'quit':
            try:
                splitted = command.split(' ')
                location_1, operator, location_2 = int(splitted[0]), \
                                                   splitted[1], int(splitted[2])
                if location_1>len(polynome_dict) or location_2>len(polynome_dict)-1:
                    print('Error: the given memory location does not exist.')
                else:
                    if operator == '+':
                        print_polynomials(location_1, location_2, polynome_dict)
                        polynome_dict[location_1].addition(polynome_dict[location_2])

                    elif operator == '-':
                        print_polynomials(location_1, location_2, polynome_dict)
                        polynome_dict[location_1].substraction(
                            polynome_dict[location_2])

                    elif operator == '*':
                        print_polynomials(location_1, location_2, polynome_dict)
                        polynome_dict[location_1].multiplication(
                            polynome_dict[location_2])
                    else:
                        print('Error: unknown operator.')
            except:
                print('Error: entry format is memory_location operation memory_location.')
            command=input('> ')

        if command == 'quit':
            print('Bye bye!')

    except FileNotFoundError:
        print('Error in reading the file.')


# This function is used by the method, addition, in the class. It
# adds two polynomial together. It uses the factor and exponent
# lists as a argument and returns two processed list at the end.
def process_addition(list1_fac, list1_exp, list2_fac, list2_exp):
    index=0
    new_fac=[]
    new_exp=[]
    while index!=len(list1_exp):
        ele_exp=list1_exp[index]
        ele_fac=list1_fac[index]
        if ele_exp in list2_exp:
            summed=list1_fac[index]+list2_fac[list2_exp.index(ele_exp)]
            new_fac.append(summed)
            new_exp.append(ele_exp)
        else:
            new_fac.append(ele_fac)
            new_exp.append(ele_exp)
        index+=1
    index=0
    while index!=len(list2_exp):
        ele_exp=list2_exp[index]
        ele_fac=list2_fac[index]
        if ele_exp in list1_exp:
            pass
        else:
            new_fac.append(ele_fac)
            new_exp.append(ele_exp)
        index+=1

    final_fac, final_exp = arrage_elements(new_fac, new_exp)
    return final_fac, final_exp

# This function is used by the method, substraction, in the class. It
# substracts two polynomial together. It uses the factor and exponent
# lists as a argument and returns two processed list at the end.
def process_substration(list1_fac, list1_exp, list2_fac, list2_exp):
    index = 0
    new_fac = []
    new_exp = []
    while index != len(list1_exp):
        ele_exp = list1_exp[index]
        ele_fac = list1_fac[index]
        if ele_exp in list2_exp:
            result = list1_fac[index] - list2_fac[list2_exp.index(ele_exp)]
            new_fac.append(result)
            new_exp.append(ele_exp)
        else:
            new_fac.append(ele_fac)
            new_exp.append(ele_exp)
        index += 1
    index = 0
    while index != len(list2_exp):
        ele_exp = list2_exp[index]
        ele_fac = list2_fac[index]
        if ele_exp in list1_exp:
            pass
        else:
            new_fac.append(-ele_fac)
            new_exp.append(ele_exp)
        index += 1

    final_fac, final_exp = arrage_elements(new_fac, new_exp)
    return final_fac, final_exp

# This function is used by the method, multiplication, in the class. It
# multiplies two polynomial together. It uses the factor and exponent
# lists as a argument and returns two processed list at the end.
# Further more it also uses the process_addition function to calculate
# the final product.
def process_multiplication(list1_fac, list1_exp, list2_fac, list2_exp):
    new_fac = []
    new_exp = []
    at_fac=[]
    at_exp=[]
    index = 0
    while index != len(list1_exp):
        for x in range(len(list2_fac)):
            factor = list1_fac[index] * list2_fac[x]
            exponent = list1_exp[index] + list2_exp[x]
            at_fac.append(factor)
            at_exp.append(exponent)
        new_fac,new_exp=process_addition(new_fac,new_exp,at_fac,at_exp)
        at_fac=[]
        at_exp=[]
        index += 1
    final_fac, final_exp = arrage_elements(new_fac, new_exp)
    return final_fac, final_exp

# The function arranges the elements in the list in descending order and
# returns it at the end.
def arrage_elements(list1, list2):
    terms = {}
    arr_list1 = []
    for x in range(len(list2)):
        terms[list2[x]] = list1[x]
    arr_list2 = sorted(terms, reverse=True)
    for x in range(len(arr_list2)):
        arr_list1.append(terms[arr_list2[x]])
    return arr_list1, arr_list2

# The function extracts the information on polynomials from the file and
# makes an individual polynomial object. It also stores the polynomial object in a
# list for further processing.
def make_ind_polynome(file):
    factors = []
    exponents = []
    polynomials = []
    for line in file:
        only_num = line.rstrip('\n')
        ind_term = only_num.split(';')
        for x in ind_term:
            digit_term = x.split(' ')
            factors.append(int(digit_term[0]))
            exponents.append(int(digit_term[1]))
        ordered_fac, ordered_exp = arrage_elements(factors, exponents)
        polynome = Polynome(ordered_fac, ordered_exp)
        polynomials.append(polynome)
        factors = []
        exponents = []
    return polynomials

# The following function assigns memory location and stores the object polynomials
# in a dictionary. The function returns the dictionary at the end.
def assign_memory_location(polynomials):
    memory = {}
    for location in range(len(polynomials)):
        memory[location] = polynomials[location]
    return memory

# The function prints polynomials in respective memory locations.
# The function is used by the main function.
def print_polynomials(loc_1, loc_2, dict):
    print('Memory location ' + str(loc_1) + ':', end=' ')
    dict[loc_1].make_polynomial()
    print('Memory location ' + str(loc_2) + ':', end=' ')
    dict[loc_2].make_polynomial()

main()
