# TIE-02106 Introduction to Programming
# Solution of task Router Simulator, C-task project.
# MUKESH ARYAL, aryalm@student.tut.fi, student no: 268456

# The following program uses a class 'Router' to simulate a virtual
# router that can be used to study about networking.

# The following class 'Router' has three initialization; name, neigh and
# address. 'name' is passed as an argument. 'neigh' is a list that stores
# information on neighbouring router. 'address' is a dictionary with
# network names as keys and distance between connections as elements.
class Router:
    def __init__(self,name):
        self.name=name
        self.neigh=[]
        self.address={}

# The following method prints the neighbours and network with connection
# distance in an ordered format.
    def print_info(self):
        list=sorted(self.neigh)
        print('  '+self.name)
        print_neighbours(list)
        print_address(self.address)

# The following method adds neighbour to the given router. It uses
# an object as an argument which is to be added as neighbour.
    def add_neighbour(self,other):
        self.neigh.append(other.name)

# The following method adds network name and distance to the router.
# 'address' and 'distance' are both given as an argument.
    def add_network(self,address,distance):
        self.address[str(address)]=int(distance)

# The following method transfers the routing table of an object, given as
# an argument, to the router itself.
    def receive_routing_table(self,other):
        for network in other.address.keys():
            if network not in self.address.keys():
                self.address[network]=other.address[network]+1

# The following method checks if an argument object is a neighbour to the
# router itself.
    def check_neighbour(self,other):
        if other.name in self.neigh:
            return True
        else:
            return False

# The following method prints information on how far a network is from the
# router. 'net_name' is passed as argument.
    def has_route(self,net_name):
        if net_name in self.address.keys():
            val=self.address[net_name]
            if val==0:
                print('Router is an edge router for the network.')
            elif val>0:
                print('Network '+net_name+' is '+str(val)+' hops away')
        else:
             print('Route to the network is unknown.')

# The following sub-function is used by the class method 'print_info'.
# It formats the information in proper order.
def print_address(dict):
    ordered=sorted(dict)
    if ordered==[]:
        print('    R: ')
    elif len(ordered) > 0:
        print('    R: ', end='')
        for x in ordered:
            if x!=ordered[len(ordered)-1]:
                print(x+':'+str(dict[x]),end=', ')
            else:
                print(x + ':' + str(dict[x]))

# The following sub-function is used by the class method 'print-info'.
# It prints the neighbouring routers in a proper order.
def print_neighbours(list):
    if list != []:
        print('    N: ', end='')
        for x in list:
            if x == list[len(list) - 1]:
                print(x)
            else:
                print(x, end=', ')
    else:
        print('    N: ')

# The main program asks for a network file to create router objects.
# It then performs respective functions in accordance with the command.
# Commands and their function are:
# 'P' = prints information of one particular router.
# 'PA'= prints information of all routers.
# 'S' = sends the routing table to other routers.
# 'C' = connects one router to another.
# 'NR'= creates a new router.
# 'NN'= stores information about network name and connection distance.
# 'Q' = exits the program.
def main():
    routerfile = input("Network file: ")
    router_dict={}
    go_on=False
    if routerfile=='':
        go_on=True
    else:
        try:
            file_1=open(routerfile,'r')
            make_router(file_1,router_dict)
            file_1.close()
            file_2=open(routerfile,'r')
            get_info(file_2,router_dict)
            file_2.close()
            go_on=True
        except:
            print('Error: the file could not be read or'
                ' there is something wrong with it.')
    if go_on==True:
        while True:
            command = input("> ")
            command = command.upper()

            if command == "P":
                router_name=input('Enter router name: ')
                if router_name in router_dict.keys():
                    router_dict[router_name].print_info()
                else:
                    print('Router was not found.')

            elif command == "PA":
                for x in sorted(router_dict):
                    router_dict[x].print_info()

            elif command == "S":
                s_router=input('Sending router: ')
                for name in router_dict.keys():
                    state=router_dict[name].check_neighbour(router_dict[s_router])
                    if state==True:
                        router_dict[name].receive_routing_table(router_dict[s_router])

            elif command == "C":
                    first_rout=input('Enter 1st router: ')
                    second_rout=input('Enter 2nd router: ')
                    router_dict[first_rout].add_neighbour(router_dict[second_rout])
                    router_dict[second_rout].add_neighbour(router_dict[first_rout])

            elif command == "RR":
                rout_name=input('Enter router name: ')
                net_name=input('Enter network name: ')
                router_dict[rout_name].has_route(net_name)

            elif command == "NR":
                name=input('Enter a new name: ')
                if name in router_dict.keys():
                    print('Name is taken.')
                else:
                    router=Router(name)
                    router_dict[name]=router

            elif command == "NN":
                router_name=input('Enter router name: ')
                network=input('Enter network: ')
                distance=input('Enter distance: ')
                router_dict[router_name].add_network(network,distance)

            elif command == "Q":
                print("Simulator closes.")
                return

            else:
                print("Erroneous command!")
                print("Enter one of these commands:")
                print("NR (new router)")
                print("P (print)")
                print("C (connect)")
                print("NN (new network)")
                print("PA (print all)")
                print("S (send routing tables)")
                print("RR (route request)")
                print("Q (quit)")

# The following function is used to read a file. Then it creates objects and
# stores them on a dictionary for later use.
def make_router(file,dict):
    for line in file:
        stripped=line.strip('\n')
        splitted=stripped.split('!')
        name = splitted[0]
        router=Router(name)
        dict[name]=router

# The following function is used to add full information on previously created
# router objects.
def get_info(file,dict):
    for line in file:
        stripped=line.strip('\n')
        splitted=stripped.split('!')
        name=splitted[0]
        N=splitted[1]
        R = splitted[2]
        N_list=N.split(';')
        if len(N_list)>1:
            for x in N_list:
                dict[name].add_neighbour(dict[x])
        elif N_list[0]!='':
            dict[name].add_neighbour(dict[N_list[0]])
        R_list=R.split(';')
        if len(R_list)>1:
            for y in R_list:
                add_dis_list=y.split(':')
                addr,dis=add_dis_list[0],add_dis_list[1]
                dict[name].add_network(addr,dis)
        elif R_list[0]!='':
            add_dis_list = R_list[0].split(':')
            addr, dis = add_dis_list[0], add_dis_list[1]
            dict[name].add_network(addr, dis)

main()