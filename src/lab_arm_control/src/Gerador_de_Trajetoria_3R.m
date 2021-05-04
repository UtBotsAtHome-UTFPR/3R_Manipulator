clear all;
close all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% CONFIGURAÇÃO - AQUI É ONDE PODE EDITAR VALORES %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Parâmetros D-H do manipulador.
    theta = [pi; -pi/2; -pi/2];
    a     = [0.25; 0.25; 0.07];

    %Centro da trajetória [x0 ;y0];
    centro = [0.2; 0.2];

    %Raio da trajetória [rx ;ry];
    raio = [0.10; 0.10];

    %Tempo total da trajetória, em segundos.
    t_max = 2;
    
    %Quantas voltas vai dar, dentro do tempo máximo.
    voltas = 1;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GERAÇÃO DA TRAJETÓRIA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    syms t;
    loop_time = voltas/t_max;

    %Monta a trajetória de posição (modo simbólico) circular com base no que forneceu.
    pd = [centro(1) + raio(1)*cos(2*pi*t*loop_time);
          centro(2) + raio(2)*sin(2*pi*t*loop_time)];

    %Monta a trajetória de velocidade (modo simbólico), derivando a trajetória de posição.
    pd_dot = diff(pd,t);

    %Monta o intervalo de valores do tempo.
    interval = 0.001;
    t = 0:interval:t_max;

    %Monta a trajetória de posição e velocidade (modo vetor numérico), com base nos valores de t gerados.
    desired = eval(pd);
    desired_dot = eval(pd_dot);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GERAÇÃO DA TRAJETÓRIA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    erro = zeros(2,1);

    for k=1:length(t)

        p0 = [0;0;0];
        p1 = [a(1)*cos(theta(1));a(1)*sin(theta(1));0];
        p2 = [p1(1)+a(2)*cos(theta(1)+theta(2));p1(2)+a(2)*sin(theta(1)+theta(2));0];
        p3 = [p2(1)+a(3)*cos(theta(1)+theta(2)+theta(3));p2(2)+a(3)*sin(theta(1)+theta(2)+theta(3));0];

        J1_2(:,k) = p0(1:2);
        J2_2(:,k) = p1(1:2);
        J3_2(:,k) = p2(1:2);
        eff_2(:,k) = p3(1:2);

        euler = rotm2eul([cos(theta(1)+theta(2)+theta(3)) -sin(theta(1)+theta(2)+theta(3)) 0;
                        sin(theta(1)+theta(2)+theta(3)) cos(theta(1)+theta(2)+theta(3)) 0;
                        0 0 1],'ZYZ');

        ori(k) = euler(3);       
        erro_pos(k) = norm(desired(:,k)-eff_2(:,k));

        erro = desired(:,k)-eff_2(:,k);

        J = [(-a(1)*sin(theta(1)) -a(2)*sin(theta(1)+theta(2)) -a(3)*sin(theta(1)+theta(2)+theta(3))) (-a(2)*sin(theta(1)+theta(2)) -a(3)*sin(theta(1)+theta(2)+theta(3))) (-a(3)*sin(theta(1)+theta(2)+theta(3)));
              (a(1)*cos(theta(1)) +a(2)*cos(theta(1)+theta(2)) +a(3)*cos(theta(1)+theta(2)+theta(3))) (a(2)*cos(theta(1)+theta(2))  +a(3)*cos(theta(1)+theta(2)+theta(3))) (a(3)*cos(theta(1)+theta(2)+theta(3)))];

        K = diag([500;500]);

        k_zero = 100;

        [~,w_dot] = manipulability(theta);

        q_zero(:,k) = k_zero*w_dot;

        pseudo = J'*(inv(J*J'));

        q_dot = pseudo*(desired_dot(:,k) + K*erro) + (eye(3) - pseudo*J)*q_zero(:,k);
        
        q_plot(:,k) = theta;
        q_dot_plot(:,k) = double(q_dot);

        theta = [theta(1) + q_dot(1)*interval;
                 theta(2) + q_dot(2)*interval;
                 theta(3) + q_dot(3)*interval];
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT DA TRAJETÓRIA PLANEJADA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%     for k=1:length(q_plot)
%         [manip(k),~] = manipulability(q_plot(:,k));
%     end
%     figure;
%     hold on;
%     plot(manip,'k');
%     axis ([0 t_max*1000 0.6 1]);
%     title('Manipulabilidade');
% 
%     for k = 1:30:length(eff_2')
%         x = [J1_2(1,k), J2_2(1,k), J3_2(1,k), eff_2(1,k)];
%         y = [J1_2(2,k), J2_2(2,k), J3_2(2,k), eff_2(2,k)];
% 
%         figure(2)
%         plot(x,y,'-o','Linewidth',3,'Color','k');hold on;
%         plot(desired(1,:),desired(2,:),'Color','r');hold on;
%         title('Trajetória Gerada');
%         hold off;
% 
%         axis ([-0.3 0.5 -0.2 0.6]);
% 
%         pause(interval)
%     end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONFIGURAÇÃO DO ROS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    
    %Cria a mensagem e inicia o publicador.
    rosinit;
    msg = rosmessage('custom_msg/set_angles');
    pub = rospublisher('/cmd_3R')
    
    %Converte todo o vetor de ângulos da trajetória para radianos
    joints = deg2rad(q_plot);
    
    %Mandar a mensagem cada vez que o timeout dela chegar.
    msg.set_OMB = joints(1,1);
    msg.set_COT = joints(2,1);
    msg.set_PUN = joints(3,1);
    
    send(pub,msg);
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    