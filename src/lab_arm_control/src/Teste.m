% Objetivo secundário... Maximizar a manipulabilidade.

syms theta1
syms theta2
syms theta3

w = (1/2)*(sin(theta2)^2 + (sin(theta3)^2));

w_dot = [0;
              cos(theta2)*sin(theta2);
              cos(theta3)*sin(theta3)]
          
w_dot2 = [diff(w,theta1);
          diff(w,theta2);
          diff(w,theta3)]

