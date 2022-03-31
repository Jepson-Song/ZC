function cal_pos(cur_index)

    %% 计算坐标
    global  cfg
    
    pos_tim = tic;

    %% 先选出三个信号最好的
    % TODO
    
    
    %% 解方程
    [pos1, pos2] = solve_equations2(cur_index);%solve_equations(cfg.dis1(cur_index, :), cfg.dis2(cur_index, :));
    
    
    % 处理异常值
    if cur_index~=1 && 0
        last_pos1 = cfg.pos1(cur_index-1, :);
        last_pos2 = cfg.pos2(cur_index-1, :);
        
        threshold_pos = 0.05/cfg.rate;
        change_pos1 = get_distance(pos1, last_pos1)
        change_pos2 = get_distance(pos2, last_pos2)
        if change_pos1 > threshold_pos
            pos1 = last_pos1;
        end
            
        if change_pos2 > threshold_pos 
            pos2 = last_pos2;
        end
    end
    
    cfg.pos1 = [cfg.pos1; pos1];
    cfg.pos2 = [cfg.pos2; pos2];
%     cfg.pos3 = [cfg.pos3; pos3];

    t = toc(pos_tim);
    fprintf("计算位置用时：%.4f\n", vpa(t));
end



%% 求两点间距离
function res = get_distance(a, b)

    c = a-b;
    res = sqrt(sum(c.*c));

end


%% 手写牛顿迭代解方程
function [pos1, pos2] = solve_equations2(cur_index) 

    global  cfg
    
    chose1 = find(cfg.dis1(cur_index, :)~=0);
    chose1 = [1 2 3];
    qos1 = cfg.Q(chose1, :);
    dis1 = cfg.dis1(cur_index, chose1);
    
    chose2 = find(cfg.dis2(cur_index, :)~=0);
    chose2 = [4 5 6];
    qos2 = cfg.Q(chose2, :);
    dis2 = cfg.dis2(cur_index, chose2);
    
    
    if cur_index == 1
        last_pos1 = cfg.init_pos1;
        last_pos2 = cfg.init_pos2;
    else
        last_pos1 = cfg.pos1(cur_index-1, :);
        last_pos2 = cfg.pos2(cur_index-1, :);
    end
   
    
    solve = tic;
    
    pos1 = newton(last_pos1, qos1, dis1);
    pos2 = newton(last_pos2, qos2, dis2);
    
    t = toc(solve);
    fprintf("解方程用时：%.4f\n", vpa(t));
    
    
    

end

%% 牛顿迭代 new
function xyz = newton_new(ans, dis)
    x = pos(1);
    y = pos(2);
    z = pos(3);
    
    eps = 1e-6;
    
    %% 手写牛顿迭代
    cnt = 0;
    while(1)
        cnt = cnt + 1;

        % 雅克比矩阵
        J = 2*[ans(1)-pos(1), ans(2)-pos(2), ans(3)-pos(3), 0, 0, 0, 0, 0, 0, 0, 0, 0;
               ans(1)-pos(4), ans(2)-pos(5), ans(3)-pos(6), 0, 0, 0, 0, 0, 0, 0, 0, 0;
               0, 0, 0, ans(4)-pos(1), ans(5)-pos(2), ans(6)-pos(3), 0, 0, 0, 0, 0, 0;
               0, 0, 0, ans(4)-pos(4), ans(5)-pos(5), ans(6)-pos(6), 0, 0, 0, 0, 0, 0;
               0, 0, 0, 0, 0, 0, ans(7)-pos(1), ans(8)-pos(2), ans(9)-pos(3), 0, 0, 0;
               0, 0, 0, 0, 0, 0, ans(7)-pos(4), ans(8)-pos(5), ans(9)-pos(6), 0, 0, 0;
               0, 0, 0, 0, 0, 0, 0, 0, 0, ans(10)-pos(1), ans(11)-pos(2), ans(12)-pos(3);
               0, 0, 0, 0, 0, 0, 0, 0, 0, ans(10)-pos(4), ans(11)-pos(5), ans(12)-pos(6);
               ans(1)-ans(4), ans(2)-ans(5), ans(3)-ans(6), ans(4)-ans(1), ans(5)-ans(2), ans(6)-ans(3), 0, 0, 0, 0, 0, 0;
               ans(1)-ans(7), ans(2)-ans(8), ans(3)-ans(9), 0, 0, 0, ans(7)-ans(1), ans(8)-ans(2), ans(9)-ans(3), 0, 0, 0;
               0, 0, 0, 0, 0, 0, ans(7)-ans(10), ans(8)-ans(11), ans(9)-ans(12), ans(10)-ans(7), ans(11)-ans(8), ans(12)-ans(9);
               0, 0, 0, ans(4)-ans(10), ans(5)-ans(11), ans(6)-ans(12), 0, 0, 0, ans(10)-ans(4), ans(11)-ans(5), ans(12)-ans(6);];

        f = [(ans(1)-pos(1))^2+(ans(2)-pos(2))^2+(ans(3)-pos(3))^2-dis(1)^2;
             (ans(1)-pos(4))^2+(ans(2)-pos(5))^2+(ans(3)-pos(6))^2-dis(1)^2;
             (ans(4)-pos(1))^2+(ans(5)-pos(2))^2+(ans(6)-pos(3))^2-dis(1)^2;
             (ans(4)-pos(4))^2+(ans(5)-pos(5))^2+(ans(6)-pos(6))^2-dis(1)^2;
             (ans(7)-pos(1))^2+(ans(8)-pos(2))^2+(ans(9)-pos(3))^2-dis(1)^2;
             (ans(7)-pos(4))^2+(ans(8)-pos(5))^2+(ans(9)-pos(6))^2-dis(1)^2;
             (ans(10)-pos(1))^2+(ans(11)-pos(2))^2+(ans(12)-pos(3))^2-dis(1)^2;
             (ans(10)-pos(4))^2+(ans(11)-pos(5))^2+(ans(12)-pos(6))^2-dis(1)^2;
             (ans(1)-pos(4))^2+(ans(2)-pos(5))^2+(ans(3)-pos(6))^2-dis(1)^2;
             (ans(1)-pos(7))^2+(ans(2)-pos(8))^2+(ans(3)-pos(9))^2-dis(1)^2;
             (ans(7)-pos(10))^2+(ans(8)-pos(11))^2+(ans(9)-pos(12))^2-dis(1)^2;
             (ans(4)-pos(10))^2+(ans(5)-pos(11))^2+(ans(6)-pos(12))^2-dis(1)^2;];


        ans = ans - (inv(J)*f)';

        
        if( abs(xyz(1)-x)<eps && abs(xyz(2)-y)<eps && abs(xyz(3)-z)<eps)
            fprintf("牛顿迭代次数：%d\n", cnt);
            break;    
        end
        
        x = xyz(1);
        y = xyz(2);
        z = xyz(3);
        
        if cnt > 10
%             fprintf("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n**************超过最大牛顿迭代次数：%d**************\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", cnt);
            break;    
        end


%         x = xyz(1);
%         y = xyz(2);
%         z = xyz(3);
    
    end
end



%% 牛顿迭代
function xyz = newton(pos, qos, dis)
    x = pos(1);
    y = pos(2);
    z = pos(3);
    
    eps = 1e-6;
    
    %% 手写牛顿迭代
    cnt = 0;
    while(1)
        cnt = cnt + 1;

        % 雅克比矩阵
        J = 2*[x-qos(1, 1), y-qos(1, 2), z-qos(1, 3);
               x-qos(2, 1), y-qos(2, 2), z-qos(2, 3);
               x-qos(3, 1), y-qos(3, 2), z-qos(3, 3);];

        f = [ (x-qos(1, 1))^2+(y-qos(1, 2))^2+(z-qos(1, 3))^2-dis(1)^2;
              (x-qos(2, 1))^2+(y-qos(2, 2))^2+(z-qos(2, 3))^2-dis(2)^2;
              (x-qos(3, 1))^2+(y-qos(3, 2))^2+(z-qos(3, 3))^2-dis(3)^2; ];


        xyz = [x y z] - (inv(J)*f)';

        if( abs(xyz(1)-x)<eps && abs(xyz(2)-y)<eps && abs(xyz(3)-z)<eps)
            fprintf("牛顿迭代次数：%d\n", cnt);
            break;    
        end
        
        x = xyz(1);
        y = xyz(2);
        z = xyz(3);
        
        if cnt > 10
%             fprintf("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n**************超过最大牛顿迭代次数：%d**************\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", cnt);
            break;    
        end


%         x = xyz(1);
%         y = xyz(2);
%         z = xyz(3);
    
    end
end

%% 用matlab的solve函数解方程
function [pos1, pos2] = solve_equations(cur_index) %solve_equations(dis1, dis2)

    global  cfg
    
    chose1 = find(cfg.dis1(cur_index, :)~=0);
    qos1 = cfg.Q(chose1, :);
    dis1 = cfg.dis1(cur_index, chose1);
    
    chose2 = find(cfg.dis2(cur_index, :)~=0);
    qos2 = cfg.Q(chose2, :);
    dis2 = cfg.dis2(cur_index, chose2);
    
    %% 计算坐标
    
    % 列出方程组
    equations = tic;
    syms x1 y1 z1 x2 y2 z2

    eq1 = (x1-qos1(1, 1))^2+(y1-qos1(1, 2))^2+(z1-qos1(1, 3))^2==dis1(1)^2;
    eq2 = (x1-qos1(2, 1))^2+(y1-qos1(2, 2))^2+(z1-qos1(2, 3))^2==dis1(2)^2;
    eq3 = (x1-qos1(3, 1))^2+(y1-qos1(3, 2))^2+(z1-qos1(3, 3))^2==dis1(3)^2;
    
    eq4 = (x2-qos2(1, 1))^2+(y2-qos2(1, 2))^2+(z2-qos2(1, 3))^2==dis2(1)^2;
    eq5 = (x2-qos2(2, 1))^2+(y2-qos2(2, 2))^2+(z2-qos2(2, 3))^2==dis2(2)^2;
    eq6 = (x2-qos2(3, 1))^2+(y2-qos2(3, 2))^2+(z2-qos2(3, 3))^2==dis2(3)^2;
%     eq7 = (x1-x2)^2+(y1-y2)^2+(z1-z2)^2==0.1^2;
    t = toc(equations);
    fprintf("列方程用时：%.4f\n", vpa(t));
    
    % 解方程
    solve = tic;
    [x1, y1, z1] = vpasolve([eq1 eq2 eq3], [x1 y1 z1]);
    [x2, y2, z2] = vpasolve([eq4 eq5 eq6], [x2 y2 z2]);
    
    t = toc(solve);
    fprintf("解方程用时：%.4f\n", vpa(t));
    
    
%     ans1 = [x1, y1, z1];
%     ans2 = [x2, y2, z2]
    
    
    
%     solve = tic;
%     [x1, y1, z1] = fun(qos1, dis1)
%     [x2, y2, z2] = fun(qos2, dis2);
%     t = toc(solve);
%     fprintf("解方程用时：%.4f\n", vpa(t));


    
    if cur_index == 1
        last_pos1 = cfg.init_pos1;
        last_pos2 = cfg.init_pos2;
    else
        last_pos1 = cfg.pos1(cur_index-1, :);
        last_pos2 = cfg.pos2(cur_index-1, :);
    end
    
    pos1_1 = double(real([x1(1), y1(1), z1(1)]));
    pos1_2 = double(real([x1(2), y1(2), z1(2)]));
    
    pos2_1 = double(real([x2(1), y2(1), z2(1)]));
    pos2_2 = double(real([x2(2), y2(2), z2(2)]));
    
    % 从两个解里选择距离上一个位置更近的解作为新的位置
    if get_distance(last_pos1, pos1_1) < get_distance(last_pos1, pos1_2)
        pos1 = pos1_1;
    else
        pos1 = pos1_2;
    end
    
    if get_distance(last_pos2, pos2_1) < get_distance(last_pos2, pos2_2)
        pos2 = pos2_1;
    else
        pos2 = pos2_2;
    end
    
    % 如果新的位置与上一个位置距离过大，则用上一个位置作为新的位置（主要是为了避免错误解，解决不了接收端切换时跳变的问题）
    if cur_index ~= 1
        if get_distance(pos1, last_pos1) > 0.5
            pos1 = last_pos1;
        end
        if get_distance(pos2, last_pos2) > 0.5
            pos2 = last_pos2;
        end
    end
        
    

    
    

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

%% 雅可比矩阵
function J = get_jaccobi(qos)

%     x1 = qos(1, 1);    y1 = qos(1, 2);    z1 = qos(1, 2);
%     x2 = qos(2, 1);    y2 = qos(2, 2);    z2 = qos(2, 2);
%     x3 = qos(3, 1);    y3 = qos(3, 2);    z3 = qos(3, 2);

    J = 2*[x-qos(1, 1), y-qos(1, 2), z-qos(1, 3);
           x-qos(2, 1), y-qos(2, 2), z-qos(2, 3);
           x-qos(3, 1), y-qos(3, 2), z-qos(3, 3);];


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

%% 化简方程求解析解
function [rx, ry, rz] = fun(qos, d)

%     x1 = qos(1, 1);    y1 = qos(1, 2);    z1 = qos(1, 2);
%     x2 = qos(2, 1);    y2 = qos(2, 2);    z2 = qos(2, 2);
%     x3 = qos(3, 1);    y3 = qos(3, 2);    z3 = qos(3, 2);
    
    x = qos(:, 1)'
    y = qos(:, 2)';
    z = qos(:, 3)';
    
%     a = x.*x + y.*y + z.*z - d.*d;
%     X = zeros(3, 3);
%     A = zeors(3, 3);
%     for i=1:1:3
%         for j=1:1:13
%             X(i, j) = x(i) - x(j);
%             A(i, j) = 0.5*(a(i) - a(j));
%         end
%     end

    a = x.*x + y.*y + z.*z - d.*d
    X21 = x(2) - x(1);
    X31 = x(3) - x(1);
    Y21 = y(2) - y(1);
    Y31 = y(3) - y(1);
    Z21 = z(2) - z(1);
    Z31 = z(3) - z(1);
    A21 = 0.5*(a(2) - a(1));
    A31 = 0.5*(a(3) - a(1));
    D = X21*Y31 - Y21*X31;
    B0 = (A21*Y31 - A31*Y21)/D;
    B1 = (Y21*Z31 - Y31*Z21)/D;
    C0 = (A31*X21 - A21*X31)/D;
    C1 = (X31*Z21 - X21*Z31)/D;
    E = B1^2 + C1^2 + 1;
    F = B1*(B0-x(1))+C1*(C0-y(1))-z(1);
    G = (B0-x(1))^2+(C0-y(1))^2+z(1)^2-d(1)^2;
    delta = 4*F^2 - 4*E*G
    rz = (-F+sqrt(F^2-E*G))/E;
    rx = B0 + B1*rz;
    ry = C0 + C1*rz;
    
end
