function [pos1, pos2, pos3] = solve_equations(cur_index) %solve_equations(dis1, dis2)

    global  cfg
    
%     chose1 = cfg.chose1(cur_index, :);
    chose1 = find(cfg.dis1(cur_index, :)~=-1);
%     whos chose1
    qos1 = cfg.Q(chose1, :)
%     whos qos1
    dis1 = cfg.dis1(cur_index, chose1)
%     whos dis1
%     dis1 = zeros(1, 3);
%     for i=1:1:3
%         dis1(i) = cfg.dis1(cur_index, )
%     chose2 = cfg.chose2(cur_index, :);
    chose2 = find(cfg.dis2(cur_index, :)~=-1);
    qos2 = cfg.Q(chose2, :);
    dis2 = cfg.dis2(cur_index, chose2);
    
    %% 计算坐标
    
    equations = tic;
    syms x1 y1 z1 x2 y2 z2
    
%     eq1 = (x1-cfg.A(1))^2+(y1-cfg.A(2))^2+(z1-cfg.A(3))^2==dis1(1)^2;
%     eq2 = (x1-cfg.B(1))^2+(y1-cfg.B(2))^2+(z1-cfg.B(3))^2==dis1(2)^2;
%     eq3 = (x1-cfg.C(1))^2+(y1-cfg.C(2))^2+(z1-cfg.C(3))^2==dis1(3)^2;
%     eq4 = (x2-cfg.A(1))^2+(y2-cfg.A(2))^2+(z2-cfg.A(3))^2==dis2(1)^2;
%     eq5 = (x2-cfg.B(1))^2+(y2-cfg.B(2))^2+(z2-cfg.B(3))^2==dis2(2)^2;
%     eq6 = (x2-cfg.C(1))^2+(y2-cfg.C(2))^2+(z2-cfg.C(3))^2==dis2(3)^2;
%     eq7 = (x1-x2)^2+(y1-y2)^2+(z1-z2)^2==0.1^2;

    eq1 = (x1-qos1(1, 1))^2+(y1-qos1(1, 2))^2+(z1-qos1(1, 3))^2==dis1(1)^2;
    eq2 = (x1-qos1(2, 1))^2+(y1-qos1(2, 2))^2+(z1-qos1(2, 3))^2==dis1(2)^2;
    eq3 = (x1-qos1(3, 1))^2+(y1-qos1(3, 2))^2+(z1-qos1(3, 3))^2==dis1(3)^2;
    eq4 = (x2-qos2(1, 1))^2+(y2-qos2(1, 2))^2+(z2-qos2(1, 3))^2==dis2(1)^2;
    eq5 = (x2-qos2(2, 1))^2+(y2-qos2(2, 2))^2+(z2-qos2(2, 3))^2==dis2(2)^2;
    eq6 = (x2-qos2(3, 1))^2+(y2-qos2(3, 2))^2+(z2-qos2(3, 3))^2==dis2(3)^2;
    eq7 = (x1-x2)^2+(y1-y2)^2+(z1-z2)^2==0.1^2;
    
    t = toc(equations);
    fprintf("列方程用时：%.4f\n", vpa(t));
    
    solve = tic;
    [x1, y1, z1] = vpasolve([eq1 eq2 eq3], [x1 y1 z1])
    [x2, y2, z2] = vpasolve([eq4 eq5 eq6], [x2 y2 z2]);
    t = toc(solve);
    fprintf("解方程用时：%.4f\n", vpa(t));
    
%     rem = 1;
%     pos1 = double(real([x1(rem), y1(rem), z1(rem)]));
%     pos2 = double(real([x2(rem), y2(rem), z2(rem)]));
    
    pos1 = double(real([x1, y1, z1]))
    pos2 = double(real([x2, y2, z2]));
    
    
    
    len = size(cfg.pos1, 1);
    if (len==0)
        pos3 = (pos1+pos2)/2 - [0 0 0.08];
    else
%         pos3 = (cfg.pos1(1, :)+cfg.pos2(1, :))/2 - [0 0 0.08];
%         pos3 = cfg.pos3(1, :);
        pos3 = cfg.O;
%         pos3 = (pos1+pos2)/2 - [0 0 0.08];
    end
    
    

%     equations = tic;
%     syms x1 y1 z1 x2 y2 z2 x3 y3 z3
%     
%     eq1 = (x1-cfg.P1(1))^2+(y1-cfg.P1(2))^2+(z1-cfg.P1(3))^2==dis1(1)^2;
%     eq2 = (x2-cfg.P1(1))^2+(y2-cfg.P1(2))^2+(z2-cfg.P1(3))^2==dis1(2)^2;
%     eq3 = (x3-cfg.P1(1))^2+(y3-cfg.P1(2))^2+(z3-cfg.P1(3))^2==dis1(3)^2;
%     
%     eq4 = (x1-cfg.P2(1))^2+(y1-cfg.P2(2))^2+(z1-cfg.P2(3))^2==dis2(1)^2;
%     eq5 = (x2-cfg.P2(1))^2+(y2-cfg.P2(2))^2+(z2-cfg.P2(3))^2==dis2(2)^2;
%     eq6 = (x3-cfg.P2(1))^2+(y3-cfg.P2(2))^2+(z3-cfg.P2(3))^2==dis2(3)^2;
%     
%     eq7 = (x1-x2)^2+(y1-y2)^2+(z1-z2)^2==(cfg.AB)^2;
%     eq8 = (x2-x3)^2+(y2-y3)^2+(z2-z3)^2==(cfg.BC)^2;
%     eq9 = (x1-x3)^2+(y1-y3)^2+(z1-z3)^2==(cfg.AC)^2;
%     
%     t = toc(equations);
%     fprintf("列方程用时：%.4f\n", vpa(t));
%     
%     solve = tic;
%     
%     [x1, y1, z1, x2, y2, z2, x3, y3, z3] = vpasolve([eq1 eq2 eq3 eq4 eq5 eq6 eq7], [x1 y1 z1 x2 y2 z2 x3 y3 z3]);
%     pos1 = [x1 y1 z1]
%     pos2 = [x2 y2 z2]
%     pos3 = [x3 y3 z3]
%     
%     t = toc(solve);
%     fprintf("解方程用时：%.4f\n", vpa(t));

%     %% 最小二乘法 两个发射端追踪三个接收端
%     solve = tic;
%     len = size(cfg.pos1, 1)
%     if (len==0)
%         x0 = [0, 0, 0, 0, 0, 0, 0, 0, 0];  % Make a starting guess at the solution
%     else
%         x0 = [cfg.pos1(len,:),cfg.pos2(len,:),cfg.pos3(len,:)];
%     end
%     options = optimoptions('fsolve','Display','iter'); % Option to display output
%     [x,fval] = fsolve(@(x)myfun(x,dis1,dis2),x0); % Call solver
%     
%     pos1 = [x(1), x(2), x(3)];
%     pos2 = [x(4), x(5), x(6)];
%     pos3 = [x(7), x(8), x(9)];
%     t = toc(solve);
%     fprintf("解方程用时：%.4f\n", vpa(t));
    
end

function F = myfun(x, dis1, dis2)
%     eq1 = (x1-cfg.P1(1))^2+(y1-cfg.P1(2))^2+(z1-cfg.P1(3))^2==dis1(1)^2;
%     eq2 = (x2-cfg.P1(1))^2+(y2-cfg.P1(2))^2+(z2-cfg.P1(3))^2==dis1(2)^2;
%     eq3 = (x3-cfg.P1(1))^2+(y3-cfg.P1(2))^2+(z3-cfg.P1(3))^2==dis1(3)^2;
%     
%     eq4 = (x1-cfg.P2(1))^2+(y1-cfg.P2(2))^2+(z1-cfg.P2(3))^2==dis2(1)^2;
%     eq5 = (x2-cfg.P2(1))^2+(y2-cfg.P2(2))^2+(z2-cfg.P2(3))^2==dis2(2)^2;
%     eq6 = (x3-cfg.P2(1))^2+(y3-cfg.P2(2))^2+(z3-cfg.P2(3))^2==dis2(3)^2;
%     
%     eq7 = (x1-x2)^2+(y1-y2)^2+(z1-z2)^2==(cfg.AB)^2;
%     eq8 = (x2-x3)^2+(y2-y3)^2+(z2-z3)^2==(cfg.BC)^2;
%     eq9 = (x1-x3)^2+(y1-y3)^2+(z1-z3)^2==(cfg.AC)^2;

    global  cfg
   F = [(x(1)-cfg.P1(1))^2+(x(4)-cfg.P1(2))^2+(x(7)-cfg.P1(3))^2 - dis1(1)^2;
      (x(2)-cfg.P1(1))^2+(x(5)-cfg.P1(2))^2+(x(8)-cfg.P1(3))^2 - dis1(2)^2;
      (x(3)-cfg.P1(1))^2+(x(6)-cfg.P1(2))^2+(x(9)-cfg.P1(3))^2 - dis1(3)^2;
      (x(1)-cfg.P2(1))^2+(x(4)-cfg.P2(2))^2+(x(7)-cfg.P2(3))^2 - dis2(1)^2;
      (x(2)-cfg.P2(1))^2+(x(5)-cfg.P2(2))^2+(x(8)-cfg.P2(3))^2 - dis2(2)^2;
      (x(3)-cfg.P2(1))^2+(x(6)-cfg.P2(2))^2+(x(9)-cfg.P2(3))^2 - dis2(3)^2;
      (x(1)-x(2))^2+(x(4)-x(5))^2+(x(7)-x(8))^2 - (cfg.AB)^2;
      (x(2)-x(3))^2+(x(5)-x(6))^2+(x(8)-x(9))^2 - (cfg.BC)^2;
      (x(1)-x(3))^2+(x(4)-x(6))^2+(x(7)-x(9))^2 - (cfg.AC)^2];
end
