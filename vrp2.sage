# Vehicle Routing Problem
# Implementation of the classic VRP  with the multicommodity flow formulation

import sage.all

N=14
M=4
clients=[1..N]
places=[0..N]
vehicle = [0..(M-1)]
q = [1,1,3,1,9,2,6,2,1,3,2,2,1,5] # Demand
Q=15 # Vehicles capacity

p=MixedIntegerLinearProgram(maximization=False,solver="GLPK")

# Two-index variables
psi=p.new_variable()
p.set_binary(psi)

# Flow variables
y=p.new_variable(integer=True)

# Costs of paths
c=[[1 for k1 in places] for k1 in places]

# Objective Function

# Locals costs

sumL=0
for i in places:
   for j in places:
      if i!=j:
         sumL=sumL + c[i][j] * psi[(i,j)]

# Individual route contribution to the cost

sumR = 0
for i in vehicles:
   sumR = sumR + routeCost(i,c,psi)

# Global contribution to the cost

sumG = 0
sumG = globalCost(c,psi)

# Objective is weighted sum of considered costs.

p.set_objective(alpha_local*sumL+alpha_route*sumR+alpha_global*sumG)

for j in clients:
    sum=0
    for i in places:
        if i!=j:
            sum = sum + psi[(i,j)]
    p.add_constraint(sum,max=1,min=1)

for i in clients:
    sum=0
    for j in places:
        if i!=j:
            sum= sum + psi[(i,j)]
    p.add_constraint(sum, max=1,min=1)


sum=0
for j in clients:
    sum+=psi[(0,j)]
p.add_constraint(sum,max=M,min=M)

sum=0
for j in clients:
    sum+=psi[(j,0)]
p.add_constraint(sum,max=M,min=M)

# Flow equations

#Netflow in each client for each connector

for l in clients:
    for j in places:
        if j==0:
            netflow = -q[l-1]
        elif j==l:
            netflow = q[l-1]
        else:
            netflow = 0
        sum=0
        for i in places:
           if i!=j:
            sum+=y[(l,(i,j))]-y[(l,(j,i))]
        p.add_constraint(sum,max=netflow,min=netflow)

# Flows are smaller than demands

for i in places:
   for j in places:
      for l in clients:
         if i!=j:
            p.add_constraint(y[(l,(i,j))]<= q[l-1] * psi[(i,j)])


# Capacity of vehicles is larger than total attended demand

for i in clients:
   sum=0
   for j in clients:
      for l in clients:
         if i!=j:
            sum+=y[(l,(i,j))]
   p.add_constraint(sum<=Q-q[i-1])

# Flows are positive

for i in places:
   for j in places:
      if i!=j:
         for l in clients:
            p.add_constraint(y[(l,(i,j))],min=0)

print "Summary:"
print "Number of constraints:"
print p.number_of_constraints()
print "Number of variables:"
print p.number_of_variables()
p.show()
print "Solving:"
obj=p.solve()
print "Objective value="+str(obj)
print "Psi variables:"
for i in places:
   for j in places:
      print "psi"+str((i,j))+"="+str(p.get_values(psi[(i,j)]))



