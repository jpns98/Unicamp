import numpy as np
import math

def F(x):
    y =np.sin(x)
    return y

t0=0
T=math.pi/2
N=21
h=(T-t0)*(N-1)**-1
k=np.zeros((N-2))

for i in np.arange(1,N-1):
   k[i-1]=F(h*(i))
   print(i)

print(k)

def IntTrapezio(t0,T,h):
   x=h*((F(t0)+F(T))/2+sum(k))
   return x


print(IntTrapezio(t0,T,h))

