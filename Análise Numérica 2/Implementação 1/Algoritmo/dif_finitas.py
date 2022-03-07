import numpy as np
import math



N=2**15
h = N**-1
a=0
b=0
x = np.zeros(N-1)
for j in np.arange(0,N-1):
    x[j]=(j+1)*h


A = np.zeros((N-1,N-1))
f = np.zeros(N-1)
U = np.zeros(N-1)


for i in np.arange(0,N-1):
    if i>0:
        A[i,i-1] = h**-2
    A[i,i] = -2*h**-2
    if i<N-2:
       A[i,i+1] = h**-2
    if i==0:
        f[i] = -(math.pi ** 2) * np.sin(math.pi * x[i])-a*h**-2
    elif i==N-2:
        f[i] = -(math.pi ** 2) * np.sin(math.pi * x[i])-b*h**-2
    else:
        f[i]=-(math.pi**2)*np.sin(math.pi*x[i])
    U[i]=np.sin(math.pi*x[i])


Uh = np.linalg.solve(A,f)
E=U-Uh
#print(f"Uh={Uh}")
erro = np.linalg.norm(math.sqrt(h)*E)
print("erro norma 2",erro)

erro1 = np.linalg.norm(h*E,1)
print("erro norma 1",erro1)

erroinf= np.linalg.norm(E,np.inf)
print("erro norma inf",erroinf)


