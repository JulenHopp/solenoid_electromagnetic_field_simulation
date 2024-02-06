clc;
clear;

%==========Definiendo atributos anillo magnetico==============

ElementosAnillo = 200;%Numero de elementos de anillo que vamos a usar para los calculos

radio = 10;%radio del anillo
corriente = 10;%Corriente del anillo

numeroEspigas = 20;
separacionEntreEspigas = 1;%Separacion entre espigas de la bobina

longuitudBobina = numeroEspigas * separacionEntreEspigas;%no  editar

% Estas son otras dormas de ingresar los datos del selenoide

% longuitudBobina = 20;%Que tan grande va a ser la bobina
% separacionEntreEspigas = 1;%Separacion entre espigas de la bobina

% longuitudBobina = 20;%Que tan grande va a ser la bobina
% numeroEspigas = 20;
% separacionEntreEspigas = longuitudBobina / numeroEspigas;

%================================================
%================================================
%=========== CALCULANDO CAMPO EN 3D =============
%================================================
%================================================

%=========GENERANDO MALLA DE PUNTOS============

numeroDePuntosEntreEjes = 8;%Numero de puentos entre los limites

dimensionesMalla = 20;% tamaño de la malla en xyz y -xyz

x = linspace(-dimensionesMalla,dimensionesMalla,numeroDePuntosEntreEjes);%Creandolosvalores
y = linspace(-dimensionesMalla,dimensionesMalla,numeroDePuntosEntreEjes);%en x,y,z
z = linspace(-dimensionesMalla,dimensionesMalla,numeroDePuntosEntreEjes);

[mX,mY,mZ] = meshgrid(x,y,z);%Creando la malla de puntos

%============Calculando el anillo==================

theta = linspace(0,2*pi,ElementosAnillo);%Definiendo el rango de tetha

%============Calulando el campo magnetico en 3d===========

Bx = zeros(numeroDePuntosEntreEjes, numeroDePuntosEntreEjes);%Inicializando las componentes del campo magnetico
By = zeros(numeroDePuntosEntreEjes, numeroDePuntosEntreEjes);
Bz = zeros(numeroDePuntosEntreEjes, numeroDePuntosEntreEjes);

altura = -longuitudBobina/2;
while altura <= longuitudBobina/2

    espaciado = altura;
    for i = theta
        
        rX = mX - radio*cos(i);%Calculando las distancias entre cada punto 
        rY = mY - radio*sin(i);%de la malla con el anillo
        rZ = mZ - espaciado;
        R = sqrt(rX.^2 + rY.^2 + rZ.^2);%Magnitud de la distancia
        
        dx = -radio * sin(i);%calculando los diferenciales de corriente
        dy = radio * cos(i);
    
        Bx = Bx + dy*rZ./R.^3;%Calulando las componenetes
        By = By + dx* rZ./ R.^3;
        Bz = Bz + ((dx.*rY) - (dy.*rX)) ./ R.^3;
        
        espaciado = altura + separacionEntreEspigas/ElementosAnillo;
    end

    altura = altura + separacionEntreEspigas;
end

Tau = ((4 * pi * (10^-7)) * corriente)/(4*pi);%Juntando parte de la formula
                                              %de bio savart
Bx = Tau .* Bx;%Multiplicando las componente por lo que faltaba 
By = -Tau .* By;
Bz = Tau .* Bz;
magnitudB = sqrt(Bx.^2 + By.^2 + Bz.^2);%Calculando magnitud del campo

% =============Graficando el cmapo magnetico==============

figure(1);
clf;

%Graficando el campo magnetico
quiver3(mX, mY,mZ, Bx./magnitudB, By./magnitudB, Bz./magnitudB,'LineWidth',0.7,'AutoScaleFactor',0.7);
hold on

%graficando el selenoide
altura = -longuitudBobina/2;
while altura < longuitudBobina/2
    plot3(radio*cos(theta),radio*sin(theta),linspace(altura,altura + separacionEntreEspigas,ElementosAnillo),'Color','red')

    altura = altura + separacionEntreEspigas;
end

%================================================
%================================================
%=========== CALCULANDO CAMPO EN 2D =============
%================================================
%================================================

%Se utilizo un proceso similar al 3d unicamente que se sustituyo el campo
%en x por 0

numeroDePuntosEntreEjes = 20;%Numero de puentos entre los limites
dimensionesMalla = 20;% tamaño de la malla en xyz y -xyz
y = linspace(-dimensionesMalla,dimensionesMalla,numeroDePuntosEntreEjes);
z = linspace(-dimensionesMalla,dimensionesMalla,numeroDePuntosEntreEjes);
[mY,mZ] = meshgrid(y,z);%Creando la malla de puntos

Bx = zeros(0,0);
By = zeros(numeroDePuntosEntreEjes, numeroDePuntosEntreEjes);
Bz = zeros(numeroDePuntosEntreEjes, numeroDePuntosEntreEjes);

altura = -longuitudBobina/2;
while altura <= longuitudBobina/2

    espaciado = altura;
    for i = theta
    
        rX = -radio*cos(i);
        rY = mY - radio*sin(i);
        rZ = mZ - espaciado;
        R = sqrt(rX.^2 + rY.^2 + rZ.^2); 
    
        dx = -radio * sin(i);
        dy = radio * cos(i);
    
        
        By = By + dx* rZ./ R.^3;
        Bz = Bz + ((dx*rY) - (dy*rX)) ./ R.^3;
    
        espaciado = altura + separacionEntreEspigas/ElementosAnillo;
    end

    altura = altura + separacionEntreEspigas;
end
Tau = ((4 * pi * (10^-7)) * corriente)/(4*pi);

By = -Tau .* By;
Bz = Tau .* Bz;
magnitudB = sqrt(By.^2 + Bz.^2);

figure(2)
clf;

[c,h] = contourf(mY,mZ,magnitudB,500,'LineStyle','none');
colormap("jet")
h.FaceAlpha = 0.67; 
colorbar
hold on

quiver(mY,mZ,By./magnitudB,Bz./magnitudB,'Color','black','AutoScaleFactor',0.9)

%graficando el selenoide
altura = -longuitudBobina/2;
while altura < longuitudBobina/2
    plot(radio*sin(theta),linspace(altura,altura + separacionEntreEspigas,ElementosAnillo),'Color','#0000FF','LineWidth',0.8)

    altura = altura + separacionEntreEspigas;
end

axis([-dimensionesMalla dimensionesMalla -dimensionesMalla....
    dimensionesMalla]);% Ajustando los limites del grafico
hold off
