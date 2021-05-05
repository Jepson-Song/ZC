function [pos1, pos2] = solve_equations(dis1, dis2)
    %% 计算坐标
    global  cfg
    
    syms x1 y1 z1 x2 y2 z2
    
    eq1 = (x1-cfg.A(1))^2+(y1-cfg.A(2))^2+(z1-cfg.A(3))^2==dis1(1)^2;
    eq2 = (x1-cfg.B(1))^2+(y1-cfg.B(2))^2+(z1-cfg.B(3))^2==dis1(2)^2;
    eq3 = (x1-cfg.C(1))^2+(y1-cfg.C(2))^2+(z1-cfg.C(3))^2==dis1(3)^2;
    eq4 = (x2-cfg.A(1))^2+(y2-cfg.A(2))^2+(z2-cfg.A(3))^2==dis2(1)^2;
    eq5 = (x2-cfg.B(1))^2+(y2-cfg.B(2))^2+(z2-cfg.B(3))^2==dis2(2)^2;
    eq6 = (x2-cfg.C(1))^2+(y2-cfg.C(2))^2+(z2-cfg.C(3))^2==dis2(3)^2;
    eq7 = (x1-x2)^2+(y1-y2)^2+(z1-z2)^2==0.1^2;
    
%     [x1, y1, z1, x2, y2, z2] = vpasolve([eq1 eq2 eq3 eq4 eq5 eq6], [x1 y1 z1 x2 y2 z2]);
    [x1, y1, z1] = vpasolve([eq1 eq2 eq3], [x1 y1 z1]);
    [x2, y2, z2] = vpasolve([eq4 eq5 eq6], [x2 y2 z2]);
    
    rem = 1;
    pos1 = abs(double(real([x1(rem); y1(rem); z1(rem)])));
    pos2 = abs(double(real([x2(rem); y2(rem); z2(rem)])));

end
