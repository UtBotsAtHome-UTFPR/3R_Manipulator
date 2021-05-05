function [w,w_dot] = manipulability(theta)

% Objetivo secundário... Maximizar a manipulabilidade.
w = (1/2)*(sin(theta(2))^2 + (sin(theta(3))^2));

w_dot = [0;
              cos(theta(2))*sin(theta(2));
              cos(theta(3))*sin(theta(3))];

end

