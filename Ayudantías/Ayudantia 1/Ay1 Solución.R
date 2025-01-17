###### AYUDANT�A 1 #######

library(openair)
library(lattice)
library(RColorBrewer)

PUD<-read.csv2("PUDAHUEL.csv",header=TRUE)

# Leemos las fechas y horas (incluyendo uso horario) de nuestra base de datos

PUD$Fecha<-PUD$Fecha+ 20000000
PUD$Hora<-PUD$Hora/100
PUD$date<-paste(PUD$Fecha, PUD$Hora,sep = " ", collapse = NULL)
PUD$date<-as.POSIXct(strptime(PUD$date, format = "%Y%m%d %H",tz="Etc/GMT+4"))


#FUNCIONES:
#as.POSIXct: convierte la fecha al formato adecuado para su manejo en R.
#strptime: le dice a R en qu� formato est� la fecha que se va a utilizar.

summary(PUD)

#Se pueden hacer c�lculos. Por ejemplo, aqu� se est�n sumando los valores de no y no2 para calcular los nox
PUD$nox<-PUD$no+PUD$no2


######## Graficos ####################

timeVariation(PUD, pollutant="pm25")
timeVariation(PUD, pollutant="pm25",  ylab="pm25 (ug/m3)", statistic = "mean")
timeVariation(PUD, pollutant="pm25",  ylab="pm25 (ug/m3)", statistic = "median", col="darkblue", main= "Material Particulado Fino (PM2.5)(ug/m3)")
timeVariation(PUD, pollutant=c("pm25","o3","no2"))


#FUNCIONES:
# Pollutant: es la(s) variable(s) que se va analizar, en este caso pedimos que tomara los datos del columna de PM2.5 de nuestra base de datos
#ylab y xlab, son los nombres que van a aparecen en cada eje del gr�fico
#statistic: qu� tipo de an�lisis estad�stico queremos que realice (promedio, mediana, 1er cuartil, etc.)
#col es el color del gr�ico
#main es para el encabezado del gr�fico 


timePlot(PUD, pollutant ="pm25", avg.time="year", lwd=4)
timePlot(selectByDate(PUD, year = 2015), pollutant = c("nox", "o3", "pm25", "pm10"))

#FUNCIONES:
#avg.time este comando hace un promedio de esa serie de tiempo
#lwd: es el grosor de las lineas


smoothTrend(PUD, pollutant ="pm25", lwd=2, col="orange")
smoothTrend(PUD, pollutant ="pm25", lwd=2, col="green", deseason=TRUE)

#FUNCIONES:
#deseason=TRUE Des-estacionalizar los datos del par�metro


#####Graficos windRose para el viento y contaminantes

windRose(PUD)
windRose(PUD, breaks=c(0, 1, 2.5, 3.5))


windRose(PUD, type="pm25", layout=c(2,2), breaks=c(0, 1, 2.5, 3.5))
windRose(PUD, type="o3", layout=c(2,2), breaks=c(0, 1, 2.5, 3.5))

windRose(PUD, type="season", breaks=c(0, 1, 2, 4, 5), cols="hue", paddle=FALSE, offset=5, key.header= "Velocidad del viento", key.footer="m/s", key.position="right", main="Estacion PUDAHUEL")

windRose(PUD, type= c("season", "daylight"), breaks=c(0, 1, 2, 4, 5), cols="hue", paddle=FALSE, offset=5, key.header= "Velocidad del viento", key.footer="m/s", key.position="right", main="Estacion PUDAHUEL")


#FUNCIONES
#breaks: modificar la escala con la que se representan los valores 
#type: el tipo de rosa que se desee ya sea para un contaminate, por estacion del a�o, d�a o noche
#cols: establecer el color del gr�fico: �default�, �increment�, �heat�, �jet�, "brewer1"
#se puede escoger color por color: cols = c("yellow", "green", "blue")
#paddle:False para desactivar paleta y que se vea como cu�a
#offset: para definir el tama�o del c�rculo del centro, por default es 10
#key.header: encabezado de la leyenda
#key.footer: pie de la leyenda
#key.position: ubicaci�n de la leyenda
#main: t�tulo del grafico



##### Graficos pollutionRose (por estaci�n y contaminante), mostrando aportes a concentraciones promedio 

pollutionRose(PUD, pollutant="pm25", statistic="prop.mean")
pollutionRose(PUD, pollutant="pm25", statistic="prop.mean", cols="jet", main="Estacion PUDAHUEL")

#FUNCIONES:
#prop.mean: (contribuci�n proporcional a la media), 
#se puede obtener una buena idea sobre qu� direcciones del viento contribuyen m�s a las concentraciones generales, adem�s de proporcionar informaci�n sobre los diferentes niveles de concentraci�n.



##### Graficos percentileRose (por estaci�n y contaminante)


percentileRose(PUD, type=c("season", "daylight"), pollutant="o3", col="Set3", hemisphere= "southern")
percentileRose(PUD, type="season", pollutant = "so2", percentile = c(25, 50, 75, 90, 95, 99.9), col = "brewer1", key.position = "right", smooth = TRUE)



##### Graficos polarPlot para cada contaminante, para las mayores concentraciones , y para los cuartiles de concentraciones.

polarPlot(PUD, pollutant="pm25")

polarPlot(PUD, pollutant="pm10",statistic="cpf", percentile=c(0,25), main="Distribuci�n del PM10 horario")

polarPlot(PUD, pollutant="pm25", x="temp")

#FUNCIONES:
#cpf: mostrar qu� direcciones del viento est�n dominadas por altas concentraciones y dar la probabilidad de que se experimenten en otras direcciones 



####### EJERCICIO 6
# Para el caso del PM2.5, calcule los promedios diarios (a partir de los valores
# horarios) y graf�quelos en funci�n del tiempo. (p�gina 25 del manual) 

# calcular los promedios diarios 
PROM <- aggregate(PUD["pm25"], format(PUD["date"],"%Y-%j"), mean, na.rm = TRUE)


#FUNCIONES:
#aggregate: funci�n que puede resumir datos 
#na.rm = TRUE: elimina los datos faltantes de los c�lculos

# PARA EL FORMATO DE FECHAS:
# %Y medias anuales
# %m medias mensuales
# %Y-%M promedios mensuales para series de tiempo completas
# %Y-%j promedios diarios para series de tiempo completas
# %Y-%W promedios semanales para series de tiempo completas
# %w-%H d�a de la semana - hora del d�a


# establecer la secuencia adecuada de fechas
PROM$date <- seq(min(PUD$date), max(PUD$date), length = nrow(PROM))

#FUNCIONES:
#seq: esta funci�n genera datos de la misma longitud que los promedios. 


#graficar los promedios
plot(PROM$date, PROM[, "pm25"], type = "l")
summary(PROM)

#type "l" significa que es una l�nea



###### EJERCICIO 7

# Repita el proceso de 6) pero ahora para las m�ximas diarias del ozono en Pudahuel.
# Analice si se ha excedido alguna vez el nivel 1 de episodio de ozono, el
# que considera concentraciones horarias entre 204 y 407 ppb. �Alguna vez se ha
# excedido el nivel 2 de episodio (408 � 509 ppb)?


# calcular las maximas diarias 
MAXI <- aggregate(PUD["o3"], format(PUD["date"],"%Y-%j"), max, na.rm = TRUE)

# establecer la secuencia adecuada de fechas
MAXI$date <- seq(min(PUD$date), max(PUD$date), length = nrow(MAXI))

#grafico
plot(MAXI$date, MAXI[, "o3"], type = "l")
summary(MAXI)






