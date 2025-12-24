library("readxl")
options(scipen = 999) #quitar notacion cientifica
dataset = read_excel("C:/Users/nerea/Downloads/Movies.xlsx")
dataset$Critics_Rating <- c(7.6, 7.4, 7.9, 7.7, 7.5, 7.6, 7.8, 8.1)

View(dataset)
#summary(dataset)

boxplot(dataset$Budget, main="Boxplot of Budget")
boxplot(dataset$Box_Office, main="Boxplot of Box_Office")

# Crear gráfico de dispersión con límites ajustados en el eje y
plot(dataset$Movie_ID, dataset$Budget, 
     col = "blue", pch = 16, 
     xlab = "Movie ID", ylab = "Amount", 
     main = "Budget vs Box Office for Each Movie",
     ylim = c(0, max(dataset$Budget, dataset$Box_Office) * 1.1))  # Ajustar los límites del eje y
points(dataset$Movie_ID, dataset$Box_Office, col = "red", pch = 16)
legend("topleft", legend = c("Budget", "Box Office"), 
       col = c("blue", "red"), pch = 16)

mean(dataset$Critics_Rating)
mean(dataset$Budget)
mean(dataset$Box_Office)



#NON-PARAMTERIC BOOTSRAP

#1) Mas profitable

dataset$ROI <- dataset$Box_Office / dataset$Budget

most_profitable_non_param <- function(data) {
  sample_indices <- sample(1:nrow(data), size = nrow(data), replace = TRUE)
  sample_data <- data[sample_indices, ]
  most_profitable <- sample_indices[which.max(sample_data$ROI)]
  return(most_profitable)
}

R <- 1000
set.seed(123)
bootstrap_results_profitable <- replicate(R, most_profitable_non_param(dataset))

freq_profitable <- table(bootstrap_results_profitable)
freq_profitable <- freq_profitable / sum(freq_profitable) * 100  # Convertir a porcentaje

print("Frecuencia de cada película como la más rentable (%):")
print(freq_profitable)

most_frequent_profitable_movie <- names(which.max(freq))
print(paste("Película más frecuentemente rentable:", most_frequent_profitable_movie))

hist(bootstrap_results_profitable)


#2) mas likeada

most_liked_non_param <- function(data) {
  sample_indices <- sample(1:nrow(data), size = nrow(data), replace = TRUE)
  sample_data <- data[sample_indices, ]
  most_liked <- sample_indices[which.max(sample_data$Critics_Rating)]
  return(most_liked)
}


R <- 1000
set.seed(123)
bootstrap_results_liked <- replicate(R, most_liked_non_param(dataset))

freq_liked <- table(bootstrap_results)
freq_liked <- freq_liked / sum(freq_liked) * 100  # Convertir a porcentaje

print("Frecuencia de cada película como la más gustada (%):")
print(freq_liked)

most_frequent_liked_movie <- names(which.max(freq))
print(paste("Película más frecuentemente gustada:", most_frequent_liked_movie))

hist(bootstrap_results_liked)





library(dplyr)

# Función para calcular el score combinado
calculate_combined_score <- function(data) {
  data <- data %>%
    mutate(Normalized_ROI = (ROI - min(ROI)) / (max(ROI) - min(ROI)),
           Normalized_Critics_Rating = (Critics_Rating - min(Critics_Rating)) / (max(Critics_Rating) - min(Critics_Rating)),
           Combined_Score = Normalized_ROI + Normalized_Critics_Rating)
  return(data)
}

# Función bootstrap no paramétrico
  most_profitable_and_liked_non_param <- function(data) {
  sample_indices <- sample(1:nrow(data), size = nrow(data), replace = TRUE)
  sample_data <- data[sample_indices, ]
  
  # Calcular el score combinado
  sample_data <- calculate_combined_score(sample_data)
  # Encontrar la película con el mejor score combinado
  best_movie <- which.max(sample_data$Combined_Score)
  
  return(sample_data$Movie_ID[best_movie])
}

# Realizar el bootstrap
R <- 10
set.seed(123)
bootstrap_results <- replicate(R, most_profitable_and_liked_non_param(dataset))

# Calcular la frecuencia de cada película
freq <- table(bootstrap_results)
freq <- freq / sum(freq) * 100  # Convertir a porcentaje

print("Frecuencia de cada película como la más rentable y gustada (%):")
print(freq)

most_frequent_profitable_and_liked_movie <- names(which.max(freq))
print(paste("Película más frecuentemente rentable y gustada:", most_frequent_profitable_and_liked_movie))

# Visualización de los resultados del bootstrap
hist(bootstrap_results,  col = "lightblue")




#3) Media de rentabilidad de las pelis

# Definir la función de bootstrap para la rentabilidad media
non_param_roi <- function(x) {
  x <- mean(sample(x, size = length(x), replace = TRUE))
  return(x)
}

# Realizar el bootstrap
stats_roi <- replicate(1000, non_param_roi(dataset$ROI))
stats_roi

# Calcular la rentabilidad media final, desviación estándar y el intervalo de confianza
final_roi <- mean(stats_roi)
sd_roi <- sd(stats_roi)
CIroi <- quantile(stats_roi, probs = c(0.025, 0.975))

# Mostrar los resultados
print(paste("Rentabilidad media:", final_roi))
print(paste("Desviación estándar:", sd_roi))
print(paste("Intervalo de confianza 95%:", CIroi[1], "-", CIroi[2]))

# Graficar los resultados
boxplot(stats_roi, main = "Boxplot ROI mean", ylab = "ROI")
hist(stats_roi, main = "Histogram ROI mean", xlab = "ROI", breaks = 30)


#OTROS
# relacion entre criticas i boxoffice

cor(dataset$Critics_Rating, dataset$Box_Office)
cor(dataset$Budget, dataset$Box_Office)
cor(dataset$Release_Year, dataset$Critics_Rating)




#PARAMTRIC


model <- lm(ROI ~ Budget + Release_Year + Runtime, data = dataset)
summary_model <- summary(model)
summary_model

#comprobem normalitat dels residus del model:
residuals <- residuals(model)
qqnorm(residuals)
qqline(residuals)


nsim <- 1000 # Número de simulaciones
n <- nrow(dataset) # Número de observaciones

# Inicializar vectores para almacenar los coeficientes
intercepts <- numeric(nsim)
slopes_budget <- numeric(nsim)
slopes_release_year <- numeric(nsim)
slopes_runtime <- numeric(nsim)

# Inicializar matriz para almacenar los ingresos de taquilla simulados
rROI <- numeric(n)

for (i in 1:nsim) {
  # Generar errores aleatorios a partir de una distribución normal
  error <- rnorm(n, 0, summary_model$sigma)
  
  # Generar datos bootstrap usando los coeficientes del modelo original y los errores
  rROI <- model$coefficients[1] +
    model$coefficients[2] * dataset$Budget +
    model$coefficients[3] * dataset$Release_Year +
    model$coefficients[4] * dataset$Runtime +
    error
  
  # Ajustar el modelo de regresión a los datos bootstrap
  bootstrap_model <- lm(rROI ~ Budget + Release_Year + Runtime, data = dataset)
  
  # Almacenar los coeficientes del modelo ajustado
  intercepts[i] <- bootstrap_model$coefficients[1]
  slopes_budget[i] <- bootstrap_model$coefficients[2]
  slopes_release_year[i] <- bootstrap_model$coefficients[3]
  slopes_runtime[i] <- bootstrap_model$coefficients[4]
}

# Visualización de los coeficientes bootstrap
par(mfrow = c(2, 2))
hist(intercepts, main = "Intercept", xlab = "Intercept Coefficient")
hist(slopes_budget, main = "Budget", xlab = "Budget Coefficient")
hist(slopes_release_year, main = "Release Year", xlab = "Release Year Coefficient")
hist(slopes_runtime, main = "Runtime", xlab = "Runtime Coefficient")


mean_bootstrap_ROI <- mean(rROI)
mean_bootstrap_ROI


roi <- model$coefficients[1] +
  model$coefficients[2] * 150000000 +
  model$coefficients[3] * 2007 +
  model$coefficients[4] * 138
roi


