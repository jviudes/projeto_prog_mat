using JuMP,Cbc

tsp = Model(with_optimizer(Cbc.Optimizer, logLevel=1))
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

dist = zeros(nCities,nCities)

@variable(tsp, visit[i=1:nCities, j=1:nCities; i!=j], Bin) #matriz de arestas visitadas (cidades)
@objective(tsp, Min, sum(dist[i,j] * visit[i,j] for i in 1:nCities, j in 1:nCities if i!=j) )
#objetivo = minimizacao da distancia total
