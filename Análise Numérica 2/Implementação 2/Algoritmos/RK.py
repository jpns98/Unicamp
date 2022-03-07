import numpy as np
import math
import matplotlib.pyplot as plt

t0=0
T=20
N=20*3+1
h=(T)*(N-1)**-1

l=4.9
g=9.8
b=3/4

U=np.zeros((N,2))
U[0,0]=math.pi/3
U[0,1]=0

for i in np.arange(1,N):
    U[i,0]=U[i-1,0]+h*((1-b)*U[i-1,1]+b*(U[i-1,1]-h/(2*b)*(g/l)*np.sin(U[i-1,0])))
    U[i,1]=U[i-1,1]+h*((-g/l)*(1-b)*np.sin(U[i-1,0])-b*(g/l)*np.sin(U[i-1,0]+h/(2*b)*U[i-1,1]))


print(U)



for i in np.arange(0,N):
    print("{", end="")
    print(h*i, end=",")
    if i < N-1:
        print(U[i,0], end="},")
    if i == N-1:
        print(U[i,0] , end="}")

print()
for i in np.arange(0,N):
    print("{", end="")
    print(h*i, end=",")
    if i < N-1:
        print(U[i,1], end="},")
    if i == N-1:
        print(U[i,1] , end="}")
print()

for i in np.arange(0,N):
    print("{", end="")
    print(U[i,0], end=",")
    if i < N-1:
        print(U[i,1], end="},")
    if i == N-1:
        print(U[i,1] , end="}")