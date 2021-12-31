function res = get_extreme(data, type)
        
        resp = data;
        
        s = std(resp);
        
        fprintf("\n标准差：%d\n",s);
        
        % 列出所有候选极值
        extreme_candidate = [];
        for k=2:1:length(resp)-1
            % 相等点只取第一个
            if resp(k) == resp(k-1)
                continue;
            end
            
            if resp(k)>=resp(k-1)&&resp(k)>=resp(k+1)
                extreme_candidate = [extreme_candidate, k];
            elseif resp(k)<=resp(k-1)&&resp(k)<=resp(k+1)
                extreme_candidate = [extreme_candidate, k];
            end
        end
        
        last_index = -1;
        local_extreme = [];
        thr = 0;
        if type == 1
            thr = s/2;
        end
        for k = 1:1:length(extreme_candidate)
            index = extreme_candidate(k);
            
%             % 以二分之一标准差为阈值
%             if resp(index)<thr && resp(index)>-thr
%                 continue;
%             end
            
            % 跟上一个极值点的差值与阈值比较
            if k~=1
                last_index = extreme_candidate(k-1);
                if abs(resp(index)-resp(last_index))<thr
                    continue;
                end
            end

            if last_index==-1
                last_index = index;
                local_extreme = [local_extreme, index];
            else
                % 异号，一个极大值一个极小值
                if resp(index)*resp(last_index)<0 
                    last_index = index;
                    local_extreme = [local_extreme, index];
                else % 同号，如果绝对值更大则更新上一个极值
                    if abs(resp(index))>abs(resp(last_index))
                        local_extreme(end) = index;
                        last_index = index;
                    end
                end
            end
        end
        
        fprintf("\n极值点个数：%d\n",length(local_extreme));
        
        
            
    res = local_extreme;
end