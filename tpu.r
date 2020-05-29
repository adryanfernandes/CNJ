#scritp TPU

#Autor: Adryan Fernandes Rocha de Brito
#data : 29/05/2020

#Script utilizado para analisar arquivos das Tabelas Processuais Unificadas
#em outras palavras, tabular de forma simples.

#Script em construção


#antes de inciar consulta, deve-se sconverter arquivos em .csv

#Inicio
#Limpando área de trabalho
rm(list = ls())

#instalando e chamando bibliotecas usadas no script
if(!require(xlsxjars))install.packages("xlsxjars");require(xlsxjars)
if(!require(xlsx))install.packages("xlsx");require(xlsx)
if(!require(dplyr))install.packages("dplyr");require(dplyr)
if(!require(readxl))install.packages("readxl");require(readxl)
if(!require(sqldf))install.packages("sqldf");require(sqldf)


#declarando local dos arquivos
setwd("D:/MEGA/TPU - 2019/DADOS/ALTERADOS/")
#declaração para consulta de arquivos e nomeação de produto final
parte=c("Classe","Assuntos","Movimentos")


for(p in 1:3){
  #declarando variaveis 
  fim=NULL
  input <- dir(pattern=parte[p]);# numeral da versão 
  output=c("Juizados Especiais Fazenda Pública.csv","1º Grau.csv","2º Grau.csv","Juizado Especial.csv","Turmas Recursais.csv","Turma Estadual Uniformazação.csv")
  nomes=c("Juizados Especiais Fazenda Pública","1º Grau","2º Grau","Juizado Especial","Turmas Recursais","Turma Estadual Uniformazação")
  m=length(output)
  
  
  
  for(j in 1:m){
    
    dados <- read_excel(input[j],col_names = FALSE, skip = 5)
    dados<-data.frame(dados);tabela=dados[,1:7];tabela[is.na(tabela)]=0;n=dim(tabela)
    
    #retirando linhas vazias
    indice=0;for(i in 1:n[1]){if(tabela[i,6]=="0" && tabela[i,7]==0){indice=c(indice,i)}};indice=indice[-1];tabela=tabela[-indice,]
    n=dim(tabela)
    names(tabela)
    tabela=cbind("X__0"=rep("0",n[1]),tabela)
    tabela$X__0=as.character(tabela$X__0)
    tabela[tabela$X__7=="0",1]=tabela[tabela$X__7=="0",2]
    tabela[tabela$X__7=="0",2]="0"
    #fazendo o preenchimento da primeira coluna
    for(i in 1:n[1]){if(tabela[i,1]!="0"){x=tabela[i,1]}else{tabela[i,1]=x}}
    
    #fazendo o preenchimento da segunda coluna
    x="";for(i in 1:n[1]){if(tabela[i,2]!="0"){x=tabela[i,2]}else{tabela[i,2]=x}}
    for(i in 1:(n[1]-1)){if(tabela[i,1]!=tabela[i+1,1]){tabela[i+1,2]=""}}
    
    
    #fazendo o preenchimento da terceira coluna
    x=""
    for(i in 1:n[1]){if(tabela[i,3]!="0"){x=tabela[i,3]}else{tabela[i,3]=x}}
    for(i in 1:(n[1]-1)){if(tabela[i,2]!=tabela[i+1,2] || tabela[i,1]!=tabela[i+1,1]){tabela[i+1,3]=""}}
    
    
    #fazendo o preenchimento da quarta coluna
    x=""
    for(i in 1:n[1]){if(tabela[i,4]!="0"){x=tabela[i,4]}else{tabela[i,4]=x}}
    for(i in 1:(n[1]-1)){if(tabela[i,3]!=tabela[i+1,3]||tabela[i,2]!=tabela[i+1,2]||tabela[i,1]!=tabela[i+1,1]){tabela[i+1,4]=""}}
    
    
    #fazendo o preenchimento da quinta coluna
    x=""
    for(i in 1:n[1]){if(tabela[i,5]!="0"){x=tabela[i,5]}else{tabela[i,5]=x}}
    for(i in 1:(n[1]-1)){if(tabela[i,4]!=tabela[i+1,4]||tabela[i,3]!=tabela[i+1,3]||tabela[i,2]!=tabela[i+1,2]||tabela[i,1]!=tabela[i+1,1]){tabela[i+1,5]=""}}
    
    #fazendo o preenchimento da quinta coluna
    
    for(i in 1:n[1]){if(tabela[i,6]!="0"){x=tabela[i,6]}else{tabela[i,6]=""}}
    
    #juntando
    
    
    descrição=NULL;
    tabela1=tabela
    tabela1[tabela1[,]==tabela1[1,5]]="0"
    for(i in 1:n[1]){
      if(tabela1[i,2]=="0" && tabela1[i,3]=="0" && tabela1[i,4]=="0" && tabela1[i,5]=="0")
        descrição[i]=paste(tabela[i,1])
        else{
          if(tabela1[i,3]=="0" && tabela1[i,4]=="0" && tabela1[i,5]=="0"){
            descrição[i]=paste(tabela[i,1]," - ",tabela[i,2])
          }else{
            if(tabela1[i,4]=="0" && tabela1[i,5]=="0"){
              descrição[i]=paste(tabela[i,1]," - ",tabela[i,2]," - ",tabela[i,3])
            }else{
              if(tabela1[i,5]=="0"){
                descrição[i]=paste(tabela[i,1]," - ",tabela[i,2]," - ",tabela[i,3]," - ",tabela[i,4])
              }else{
                if(tabela1[i,6]=="0"){
                  descrição[i]=paste(tabela[i,1]," - ",tabela[i,2]," - ",tabela[i,3]," - ",tabela[i,4]," - ",tabela[i,5])
                }else{
                  descrição[i]=paste(tabela[i,1]," - ",tabela[i,2]," - ",tabela[i,3]," - ",tabela[i,4]," - ",tabela[i,5]," - ",tabela[i,6])
                }
              }
            }
          }
        }
    }
    COMPETENCIA=rep(nomes[j],dim(tabela)[1])
    fim[[j]]=cbind(tabela[,1:6],COMPETENCIA,descrição,tabela[,7:8])
    #write.table(fim[[j]],output[j],sep=";",row.names = F)
  }
  
  final=NULL
  for (i in 1:6) {
    final=rbind(final,fim[[i]])
  }
  final$descrição=as.character(final$descrição)
  final$COMPETENCIA=as.character(final$COMPETENCIA)
  names(final)=c("x1","x2","x3","x4","x5","x6","Compêtencia","Descrição","Código","Código Pai")
  write.table(final,paste0(parte[p],".csv"),sep=";",row.names = F)
}

#Fim
