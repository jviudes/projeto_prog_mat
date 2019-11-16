## Projeto da disciplina de Programação Matemática
##### ICMC – USP São Carlos


* ## Problema
  * O modelo observado em questão consiste no problema do caixeiro viajante, onde um vendedor precisa visitar seus clientes em *n* cidades.
  * Ele parte de uma cidade e deve retornar a essa cidade após visitar
todas as outras.
  * Cada cidade deve ser visitada uma única vez.

* ## Formulação
  * ### Objetivo
    > ![Função objetiva](imgs/objective.svg)

  * ### Restrições
    > ![Restriçoes](imgs/sa1.svg)

    > ![Restriçoes](imgs/sa2.svg)

    > ![Restriçoes](imgs/sa3.svg)
  
  * ### Variáveis
    * cityPos[ i ] -> posição (x,y) da cidade i
    * nCities -> numero total de cidades
    * dist[ i ][ j ]-> matriz de distancia euclidiana das cidades
    * visit[ i ][ j ]-> matriz binária indicando se uma cidade foi visitada ou não
    * u[ i ] -> numero de visitas realizadas até o nó i

  * ### Solução
    * O problema foi resolvido utilizando o solver Cbc da linguagem *julia*, para se reduzir a complexidade e por sua vez eliminar subrotas foi implementado o método Miller, Tucker e Zemlin (MTZ) O(n²). 
    * O método  MTZ garante que dados dois nós i e j:
      1. Se i precede j imediatamente: uj ≥ ui + 1
      2. Caso contrário, esta restrição é desligada
    * Dada as restrições anteriores obtivemos a seguinte formulação: 
      * ![Restriçoes](imgs/sa2.svg)
      * ![Restriçoes](imgs/sa3.svg)
    
     
    


* ## Setup

  #### install julia
      - sudo apt-get install julia

  #### run project 
      - julia src/app.jl
  