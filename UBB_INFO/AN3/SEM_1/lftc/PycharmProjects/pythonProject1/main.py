import time
import socket
from _thread import *
from threading import Thread

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind(("0.0.0.0", 1025))
s.listen(5)

matrix = [[0 for x in range(6)] for y in range(6)]
walls = [(1, 2), (1, 1), (3, 4), (2, 5)]
for (x, y) in walls:
    matrix[x][y] = 1

location = [0, 0]
last_location = [0, 0]

Clients=[]

def mesaj():
    for client in Clients:
        client.sendall(str.encode(str(f"Current location: {location[0]}, {location[1]}")))


def f(cs, i):
    global matrix
    global walls
    global location
    global last_location
    cs.send(str.encode("game started! you are in 0,0"))
    while True:
        print(location[0], location[1])
        buffer = cs.recv(2000)
        #time.sleep(10)
        user_resp = buffer.decode('utf-8')
        last_location = location
        if user_resp == "up":
            location = [location[0]-1, location[1]]
        if user_resp == "down":
            location = [location[0]+1, location[1]]
        if user_resp == "left":
            location = [location[0], location[1]-1]
        if user_resp == "right":
            location = [location[0], location[1]+1]
        row = location[0]
        col = location[1]

        if (0 > row) or (6 < col):
            cs.sendall(str.encode("out of matrix"))
            location = last_location
        else:
            if matrix[row][col]==1:
                cs.sendall(str.encode("it's a wall"))
            else:
                if matrix[row][col]==5:
                    cs.sendall(str.encode("you won"))
                    exit()
                else:
                    cs.sendall(str.encode(str(f"you are at {row}, {col}")))

        for row in matrix:
            print(row)
        mesaj()
    cs.close()


thread_nr=0

while (1==1):

    cs, addr = s.accept()
    #print('Connected to: ' + address[0] + ':' + str(address[1]))
    start_new_thread(f, (cs, addr))
    thread_nr += 1
    print('Thread Number: ' + str(thread_nr))
    Clients.append(cs)


