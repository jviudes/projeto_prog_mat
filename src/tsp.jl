using JuMP,Cbc
# using GraphRecipes,Plots

tsp = Model(with_optimizer(Cbc.Optimizer, logLevel=1, threads=8))
cityPos = Dict{Int,Any}()
cityPos[1] = (523,418)
cityPos[2] = (527,566)
cityPos[3] = (435,603)
cityPos[4] = (386,660)
cityPos[5] = (346,692)
# cityPos[6] = (431,730)
#cityPos[7] = (419,818)
#cityPos[8] = (347,520)
#cityPos[9] = (332,330)
#cityPos[10] = (165,374)
#cityPos[11] = (196,198)
#cityPos[12] = (187,108)
#cityPos[13] = (210,63)

nCities = length(cityPos)

# pyplot() # plotagem do grafico
# VARIAVEIS
posX, posY = [], [] #posicao dos vertices para o grafico
dist = zeros(nCities,nCities)
for i in sort(collect(keys(cityPos))) #calcula distancia euclidiana
    posI = cityPos[i]
    for j in sort(collect(keys(cityPos)))
        posJ = cityPos[j]
        dist[i,j]=((posI[1]-posJ[1])^2+(posI[2]-posJ[2])^2)^0.5
    end
    #append!(posX,posI[1])
    #append!(posY,posI[2])
end
@variable(tsp, visit[i=1:nCities, j=1:nCities; i!=j], Bin) #matriz de arestas visitadas (cidades)
@variable(tsp, u[1:nCities], Int) #declaracao do vetor u

#definicao e plotagem do grafico
#graphplot(1:nCities, 1:nCities, names=1:nCities,x=posX,y=posY,fontsize=10,m=:white,l=:black)

#FUNCAO OBJETIVO
@objective(tsp, Min, sum(dist[i,j] * visit[i,j] for i in 1:nCities, j in 1:nCities if i!=j) )

#RESTRICOES
for i in 1:nCities # Garantir saida de todos os vertices
    @constraint(tsp, sum(visit[i,j] for j in 1:nCities if i!=j ) == 1)
end

for j in 2:nCities # Garantir entrada em todos os vertices
    @constraint(tsp, sum(visit[i,j] for i in 1:nCities if i!=j ) == 1)
end

# restricao MTZ
@constraint(tsp, u[1] == 0) 

for i in 1:nCities
    @constraint(tsp, u[i] >= 0) 
end

for i in 1:nCities
    for j in 2:nCities
        if i!=j
            @constraint(tsp, u[i]+visit[i,j]-nCities*(1-visit[i,j]) <= u[j])
        end
    end
end

optimize!(tsp)
if termination_status(tsp) == MOI.OPTIMAL
    println("Solucao otima encontrada \n\nVetor u : \n")
    for i in 1:nCities
        println(value(u[i]))
    end
    println("\nDistancia total: ")
    println(objective_value(tsp))
else println("Solucao otima nao encontrada")
end
