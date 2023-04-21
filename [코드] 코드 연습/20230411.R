#링크 접속 https://rpubs.com/doris/729711

#scale 평균 0, 분산 1 일때 처리해주기 
iris.pca <- prcomp(iris[,1:4], 
       center = T, 
       scale. = T)

summary(iris.pca)

iris.pca$rotation

plot(iris.pca, 
     type='l', 
     main = 'scree plot')
head(iris.pca$x[,1:2], 10)

#autoplot 실행을 위한 라이브러리 설치
library(ggfortify)

autoplot(iris.pca, 
         data=iris,
         colour= 'Species')

#개발자가 작성한 패키지를 설치하기 위한 도구
library("devtools")

#factoxtra 패키지 설치
install_github("kassambara/factoextra")

#factoxtra 라이브러리 불러오기
library("factoextra")


#iris 데이터를 PCA로 그리기
fviz_pca_biplot(iris.pca, 
                # Individuals
                geom.ind = "point",
                fill.ind = iris$Species, col.ind = "black",
                pointshape = 21, pointsize = 2,
                palette = "jco",
                addEllipses = TRUE,
                # Variables
                alpha.var ="contrib", col.var = "contrib",
                gradient.cols = "RdYlBu",
                
                legend.title = list(fill = "Species", color = "Contrib",
                                    alpha = "Contrib"))


fviz_pca_biplot(iris.pca, 
                # Fill individuals by groups
                geom.ind = "point",
                pointshape = 21,
                pointsize = 2.5,
                fill.ind = iris$Species,
                col.ind = "black",
                # Color variable by groups
                col.var = factor(c("sepal", "sepal", "petal", "petal")),
                
                legend.title = list(fill = "Species", color = "Clusters"),
                repel = TRUE) +
    ggpubr::fill_palette("jco")
