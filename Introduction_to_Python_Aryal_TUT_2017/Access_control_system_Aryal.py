# TIE-02106 Introduction to Programming
# Solution of task Access Control System
# MUKESH ARYAL, aryalm@student.tut.fi, student no: 268456

# The following program creates a class 'Assesscard' which is later used
# to make distinct assesscard with corresponding assess code.
# The main program can process and print information obtained from a file.
# Processing of the information includes checking, adding and merging
# access rights.


DOORCODES = {'TC114': ['TIE'], 'TC203': ['TIE'], 'TC210': ['TIE', 'TST'],
             'TD201': ['TST'], 'TE111': [], 'TE113': [], 'TE115': [],
             'TE117': [], 'TE102': ['TIE'], 'TD203': ['TST'], 'TA666': ['X'],
             'TC103': ['TIE', 'OPET', 'SGN'], 'TC205': ['TIE', 'OPET', 'ELT'],
             'TB109': ['OPET', 'TST'], 'TB111': ['OPET', 'TST'],
             'TB103': ['OPET'], 'TB104': ['OPET'], 'TB205': ['G'],
             'SM111': [], 'SM112': [], 'SM113': [], 'SM114': [],
             'S1': ['OPET'], 'S2': ['OPET'], 'S3': ['OPET'], 'S4': ['OPET'],
             'K1705': ['OPET'], 'SB100': ['G'], 'SB202': ['G'],
             'SM220': ['ELT'], 'SM221': ['ELT'], 'SM222': ['ELT'],
             'secret_corridor_from_building_T_to_building_F': ['X', 'Y', 'Z'],
             'TA': ['G'], 'TB': ['G'], 'SA': ['G'], 'KA': ['G']}


class Accesscard:

    # initialization of the class includes one additional component which is
    # a list for storing access codes.

    def __init__(self, id, name):
        """
        Constructor, creates a new object that has no access rights.
        :param id: card holders personal id (str)
        :param name: card holders name (str)    
        """
        self.id=id
        self.name=name
        self.codes=[]


    def info(self):
        """
        The method has no return value. It prints the information related to
        the access card in the format:
        id, name, access: a1,a2,...,aN
        """
        redundants, sorted_list=get_redundants(self.codes)
        for x in range(len(redundants)):
            sorted_list.remove(redundants[x])
            self.codes.remove(redundants[x])
        if len(sorted_list)>0:
            print(self.id + ', ' + self.name + ', ' + 'access:', end=' ')
            for x in range(len(sorted_list)):
                if x == len(sorted_list) - 1:
                    print(sorted_list[x])
                else:
                    print(sorted_list[x], end=', ')
        else:
            print(self.id + ', ' + self.name + ', ' + 'access:')

    def get_name(self):
        """
        :return: Returns the name of the accesscard holder.
        """
        return self.name



    def add_access(self, new_access_code):
        """
        The method adds a new accesscode into the accesscard according to the
        rules defined in the task description.
        :param new_access_code: The accesscode to be added in the card.
        """
        if new_access_code not in self.codes:
            self.codes.append(new_access_code)



    def check_access(self, door):
        """
        Checks if the accesscard allows access to a certain door.
        
        :param door: the doorcode of the door that is being accessed.
        :return: True: The door opens for this accesscard.
                 False: The door does not open for this accesscard.
        """
        if door in self.codes:
            return True
        elif door not in self.codes and DOORCODES[door]==[]:
            return False
        else:
            for elements in DOORCODES[door]:
                if elements in self.codes and elements!='':
                    return True
                else:
                    return False


    def merge(self, card):
        """
        Merges the accesscodes from another accesscard to this accesscard.

        :param card: The accesscard whose access rights are added to this card.
        :return:
        """
        for access_codes in card.codes:
            self.codes.append(access_codes)

# The following function is used by the class 'Accesscard' to obtain the
# unnecessary and redundant access codes.
# The function returns two lists at the end.

def get_redundants(code_list):
    redundants = []
    sorted_list = sorted(code_list)
    for access_code in sorted_list:
        if access_code in DOORCODES:
            for code in sorted_list:
                if code in DOORCODES[access_code]:
                    redundants.append(access_code)
    index = 0
    while index < len(sorted_list) - 1:
        if sorted_list[index] == sorted_list[index + 1]:
            redundants.append(sorted_list[index])
            index += 1
        else:
            index += 1
    return redundants, sorted_list



def main():
    card_list=read_and_store_info()
    while True:
        line = input("command> ")

        if line == "":
            break

        strings = line.split()
        command = strings[0]

        if command == "list" and len(strings) == 1:
            ordered_id=sorted(card_list)
            for x in ordered_id:
                req_card=card_list[x]
                req_card.info()

        elif command == "info" and len(strings) == 2:
            card_id = strings[1]
            if card_id in card_list:
                req_card=card_list[card_id]
                req_card.info()
            else:
                print('Error: unknown id.')


        elif command == "access" and len(strings) == 3:
            card_id = strings[1]
            door_id = strings[2]
            print_access_info(card_id, door_id, card_list)

        elif command == "add" and len(strings) == 3:
            AREACODE=collect_Areacodes()
            card_id = strings[1]
            access_code = strings[2]
            if card_id in card_list:
                req_card=card_list[card_id]
                if access_code in DOORCODES or access_code in AREACODE:
                    req_card.add_access(access_code)
                else:
                    print('Error: unknown accesscode.')
            else:
                print('Error: unknown id.')

        elif command == "merge" and len(strings) == 3:
            card_id_to = strings[1]
            card_id_from = strings[2]
            if card_id_to in card_list and card_id_from in card_list:
                to_merge_card=card_list[card_id_from]
                req_card=card_list[card_id_to]
                req_card.merge(to_merge_card)
            else:
                print('Error: unknown id.')


        elif command == "quit":
            print("Bye!")
            return
        else:
            print("Error: unknown command.")

# The given function reads the information in the file and returns
# a list of objects. Here objects are individual access cards.
def read_and_store_info():
    file = open('accessinfo.txt', 'r')
    card_list = {}
    for line in file:
        stripped = line.rstrip('\n')
        id, name, codes = stripped.split(';')
        list_codes = codes.split(',')
        card = Accesscard(id, name)
        card_list[id] = card
        for x in list_codes:
            card.add_access(x)
    file.close()
    return card_list

# The given function checks and prints the information about access rights.
# The fuction is called when the command is 'access'.

def print_access_info(card_id,door_id,card_list):
    if card_id in card_list:
        req_card = card_list[card_id]
        name = req_card.get_name()
        if door_id in DOORCODES:
            if req_card.check_access(door_id) == True:
                print('Card ' + card_id + ' ( ' + name + ' )' +
                      ' has access to door ' + door_id)
            else:
                print('Card ' + card_id + '( ' + name + ' )' +
                      ' has no access to door ' + door_id)
        else:
            print('Error: unknown doorcode.')
    else:
        print('Error: unknown id.')

# The following function creates a list of Areacodes.
# The Areacodes are in random order and number. The function is used for
# the 'add' command.

def collect_Areacodes():
    AREACODE = []
    for doorcode, areacode in DOORCODES.items():
        for items in areacode:
            AREACODE.append(items)
    return AREACODE


main()