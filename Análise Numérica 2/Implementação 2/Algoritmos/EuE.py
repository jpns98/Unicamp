import numpy as np
import math
import matplotlib.pyplot as plt

t0=0
T=1
N=10
h=(T)*(N-1)**-1


U=np.zeros((N,2))
U[0,0]=math.pi/3
U[0,1]=0.0

for i in np.arange(1,N):
    U[i,0]=U[i-1,0]+h*U[i-1,1]
    U[i,1]=U[i-1,1]+h*(-2)*np.sin(U[i-1,0])


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
