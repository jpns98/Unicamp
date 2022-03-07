import numpy as np
import math
import matplotlib.pyplot as plt

def F(x,u):
    y = np.zeros(2)
    y[0] = x[0]-u[0]-h*x[1]
    y[1] = x[1]-u[1]+h*np.sin(x[0])
    return y

def JF(x):
    y = np.zeros((2,2))
    y[0,0] = 1
    y[0,1] = -h
    y[1,0] = h*2*np.cos(x[0])
    y[1,1] = 1
    return y

t0=0
T=20
N=20*8+1
h=(T)*(N-1)**-1
k=np.zeros((2))
U=np.zeros((N,2))
U[0,0]=math.pi/3
U[0,1]=0


for i in np.arange(1,N):
    for j in np.arange(1,6):
        if j>1:
            k[0]=U[i,0]
            k[1]=U[i,1]
        U[i] = U[i] - np.linalg.inv(JF(U[i])).dot(F(U[i],U[i-1]))
        if np.linalg.norm(k-U[i])>10**-5:
            k[0] = U[i, 0]
            k[1] = U[i, 1]
        else:
            break