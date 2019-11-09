using JuMP,Cbc
#using GraphRecipes,Plots

tsp = Model(with_optimizer(Cbc.Optimizer, logLevel=1, threads= 4))
n = 10 # numero de cidades , >= 2
# cidade 1 = cidade de partida
cityPos = Dict{Int,Any}()
cityPos[1] = (523,418)
cityPos[2] = (527,566)
cityPos[3] = (435,603)
cityPos[4] = (386,660)
cityPos[5] = (346,692)
cityPos[6] = (431,730)
cityPos[7] = (419,818)
cityPos[8] = (347,520)
cityPos[9] = (332,330)
cityPos[10] = (165,374)
cityPos[11] = (196,198)
cityPos[12] = (187,108)
cityPos[13] = (210,63)

nCities = length(cityPos)

#pyplot() # plotagem do grafico

dist = zeros(nCities,nCities)
posX, posY = [], [] #posicao dos vertices para o grafico

#algoritmo que calcula as distancias entre os pontos e plota no grafico
for i in sort(collect(keys(cityPos)))
    posI = cityPos[i]
    for j in sort(collect(keys(cityPos)))
        posJ = cityPos[j]
        dist[i,j]=((posI[1]-posJ[1])^2+(posI[2]-posJ[2])^2)^0.5
    end
    #append!(posX,posI[1])
    #append!(posY,posI[2])
end

#definicao e plotagem do grafico
#graphplot(1:nCities, 1:nCities, names=1:nCities,x=posX,y=posY,fontsize=10,m=:white,l=:black)

@variable(tsp, visit[i=1:nCities, j=1:nCities; i!=j], Bin) #matriz de arestas visitadas (cidades)
@objective(tsp, Min, sum(dist[i,j] * visit[i,j] for i in 1:nCities, j in 1:nCities if i!=j) )
#objetivo = minimizacao da distancia total

#Restricoes
for i in 1:nCities
    @constraint(tsp, sum(visit[i,j] for j in 1:nCities if i!=j ) == 1)
end
# Garantir saida de todos os vertices

for j in 1:nCities
    @constraint(tsp, sum(visit[i,j] for i in 1:nCities if i!=j ) == 1)
end
# Garantir entrada em todos os vertices

# u = zeros(Int64, nCities)
@variable(tsp, u[1:nCities], Int) #declaracao do vetor u

@constraint(tsp, u[1] == 0) # U[1] tem que ser igual a 0

for i in 1:nCities
    @constraint(tsp, u[i] >= 0) # Ui deve ser >= 0
end
# restricao MTZ
for i in 1:nCities
    for j in 2:nCities
        if i!=j
            @constraint(tsp, u[i]+visit[i,j]-n*(1-visit[i,j]) <= u[j])
        end
    end
end

status = optimize!(tsp)
if status == :Optimal
    println("Solucao otima encontrada")
else println("Solucao otima nao encontrada")
end
