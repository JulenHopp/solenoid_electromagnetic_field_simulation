clear;
clc;

% ============CREANDO UNA MALLA DE PUNTOS============

N = 40;% Determinando cuantos intervalos van a haber en la malla

minX = -10;%determinando los valores del rango que vamos a usar
minY = -10;

maxX = 10;
maxY = 10;

x = linspace(minX, maxX,N);% Creando vector con los valores en x
y = linspace(minY,maxY,N);% Creando el vector con los valores en y

[xM,yM] = meshgrid(x,y);% Creando la malla de puntos

% ============CREANDO LOS CABLES CARGADOS============

%PRIMER CABLE
cargaP1 = -3;% carga de particula
longuitudP1 = 4;
xP1 = 2; % coordenada en x

% SEGUNDA PARTICULA
cargaP2 = 3;% carga de particula
longuitudP2 = 6;
xP2 = -2; % coordenada en x

% ============CALCULADO EL CAMPO============

% CONSTANTES

kC = 8.9876e9;% constante de coulum
dy = 0.1;% El cambio en posicion en y por iteracon

% FUERZA EJERCIDA POR LA PRIMERA CARGA LINEAL

exfinalP1 = 0;% Inicializando variables, que contendran los resultados
eyfinalP1 = 0;
vP1 = 0;
alturaP1 = -(longuitudP1/2);% Inicializando la posicion inicial para realilos calculos
while alturaP1 <= longuitudP1/2
    
    Rx1 = xM - xP1;% Calculando la distancia del punto en particular con la particula en cada coordenada
    Ry1 = yM - alturaP1;
    R1 = sqrt(Rx1.^2 + Ry1.^2);% calculando la magnitud de la distancia entre cada punto de la malla y la carga puntual.
        
    Ex1 = (kC .* cargaP1  ./ R1.^3) .* Rx1; %Usando la formula de carga puntual.
    Ey1 = (kC .* cargaP1  ./ R1.^3) .* Ry1;
        
    V1 = (kC.*cargaP1)./R1;% Calculando el campo potencial
    vP1 = vP1 + V1;% Sumando el los valores del campo potencial generados por la iteracion pasada
    
    
    exfinalP1 = exfinalP1 + Ex1;% Sumando el campo actual el resultado de la carga que se acaba de calular
    eyfinalP1 = eyfinalP1 + Ey1;

    alturaP1 = alturaP1 + dy;% Cambiando a la siguiente posicion en la cual se realizaran los calculos
end

% FUERZA EJERCIDA POR LA SEGUNDA CARGA LINEAL
exfinalP2 = 0;% Inicializando variables, que contendran los resultados
eyfinalP2 = 0;
vP2 = 0;
alturaP2 = -(longuitudP2/2);% Inicializando la posicion inicial para realilos calculos
while alturaP2 <= longuitudP2/2
    
    Rx2 = xM - xP2;% Calculando la distancia del punto en particular con la particula en cada coordenada
    Ry2 = yM - alturaP2;
    R2 = sqrt(Rx2.^2 + Ry2.^2);% calculando la magnitud de la distancia entre cada punto de la malla y la carga puntual.
        
    Ex2 = (kC .* cargaP2 ./ R2.^3) .* Rx2; %Usando la formula de carga puntual.
    Ey2 = (kC .* cargaP2 ./ R2.^3) .* Ry2;
        
    V2 = (kC.*cargaP2)./R2;% Calculando el campo potencia
    vP2 = vP2 + V2;% Sumando el los valores del campo potencial generados por la iteracion pasada
    
 
    exfinalP2 = exfinalP2 + Ex2;% Sumando el campo actual el resultado de la carga que se acaba de calular
    eyfinalP2 = eyfinalP2 + Ey2;

    alturaP2 = alturaP2 + dy% Cambiando a la siguiente posicion en la cual se realizaran los calculos
end

% ASIGNADO VALORES A LAS COMPONENTES
u = exfinalP1 + exfinalP2;% Asignadoles valores a las componentes de cada coordenada
v = eyfinalP1 + eyfinalP2;

Emfinal = sqrt(u.^2 + v.^2);% Calculando el modulo de las componenste

uUnitario = u./Emfinal;% Crenado vectores unitarios
vUnitario = v./Emfinal;

Vfinal = vP1 + vP2;% Juntando los valores de los campos potenciales generados por cada carga

% ============GRAFICANDO============

% GRAFICO REAL
figure(1);% Creando una ventana para desplegar el grafico
graficoReal = quiver(xM,yM,u,v,'autoscalefactor',1.2);% Generando el grafico vectorial
set(graficoReal,'Color','blue','linewidth',1.2)% Ajustando atributos del grafico
axis([minX maxX minY maxY]);% Ajustando los limites del grafico
    
    %Graficando las 2 cargas lineales, con un operador booleano el cual
    %cheque el signo de la carga y decida de que color va a graficar.
    if cargaP1 >= 0
        graficoReal = rectangle('position',[xP1-0.2, 0-longuitudP1/2,...
            0.4, longuitudP1],'FaceColor','red');
    else
        graficoReal = rectangle('position',[xP1-0.2, 0-longuitudP1/2,...
                    0.4,longuitudP1],'FaceColor','blue');
    end

    if cargaP2 >= 0
        graficoReal = rectangle('position',[xP2-0.2, 0-longuitudP2/2,...
        0.4, longuitudP2],'FaceColor','red');
    else
        graficoReal = rectangle('position',[xP2-0.2, 0-longuitudP2/2,...
                    0.4,longuitudP2],'FaceColor','blue');
    end

% GRAFICO UTILIZANDO VECTORES UNITARIOS
figure(2);% Creando una ventana para desplegar el grafico
graficoUnitario = quiver(xM,yM,uUnitario,vUnitario,'autoscalefactor',0.9);% Generando el grafico vectorial
set(graficoUnitario,'Color','blue','linewidth',1)%Ajustando atributos del grafico
axis([minX maxX minY maxY]);% Ajustando los limites del grafico

    %Graficando las 2 cargas lineales, con un operador booleano el cual
    %cheque el signo de la carga y decida de que color va a graficar.
    if cargaP1 >= 0
        graficoUnitario = rectangle('position',[xP1-0.2, 0-longuitudP1/2,...
            0.4, longuitudP1],'FaceColor','red');
    else
        graficoUnitario = rectangle('position',[xP1-0.2, 0-longuitudP1/2,...
                    0.4,longuitudP1],'FaceColor','blue');
    end

    if cargaP2 >= 0
        graficoUnitario = rectangle('position',[xP2-0.2, 0-longuitudP2/2,...
        0.4, longuitudP2],'FaceColor','red');
    else
        graficoUnitario = rectangle('position',[xP2-0.2, 0-longuitudP2/2,...
                    0.4,longuitudP2],'FaceColor','blue');
    end

% Grafico campo potencial
figure(3);% Creando una nueva ventana para generar el grafico
graficoCampo = surf(xM,yM,Vfinal);% Creando el grafico vectorial

% Grafico campo magnetico con su potencial
figure(4)
Vfinal = abs(vP1) + (vP2);% Juntando los valores de los campos potenciales generados por cada carga

[c,h] = contourf(xM,yM,Vfinal,50,'LineStyle','none');
colormap("turbo")
h.FaceAlpha = 0.6; 
colorbar
hold on
graficoReal = quiver(xM,yM,uUnitario,vUnitario, "color","blue",'LineWidth',0.4);% Generando el grafico vectorial
    if cargaP1 >= 0
        graficoUnitario = rectangle('position',[xP1-0.2, 0-longuitudP1/2,...
            0.4, longuitudP1],'FaceColor','red');
    else
        graficoUnitario = rectangle('position',[xP1-0.2, 0-longuitudP1/2,...
                    0.4,longuitudP1],'FaceColor','blue');
    end

    if cargaP2 >= 0
        graficoUnitario = rectangle('position',[xP2-0.2, 0-longuitudP2/2,...
        0.4, longuitudP2],'FaceColor','red');
    else
        graficoUnitario = rectangle('position',[xP2-0.2, 0-longuitudP2/2,...
                    0.4,longuitudP2],'FaceColor','blue');
    end