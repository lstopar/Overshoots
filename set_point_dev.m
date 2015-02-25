function [X, y] = set_point_dev(fname,start_block,n_blocks)
    format long g
    n_lines = 280691306;
    block_size = 10000;
    total_blocks = ceil(n_lines / block_size);
    
    time_idx = 1;
    hl_idx = 2;
    mru_pos_idx = 3;
    mru_vel_idx = 4;
    pos_meas_idx = 5;
    pos_set_idx = 6;
    
%     window_size = 3;
    window = [];
    set_vel = 0;
%     prev_example = 0;
    speed = 400;
    dev = zeros(block_size*(n_blocks+1),1);
    B = zeros(block_size*(n_blocks+1),9);
    X = [];
    y = [];
    
    function [i] = get_B_idx(idx)
        i = idx - (start_block-1)*block_size;
    end


    function plot_graph(B)
        plot(u2mTime(B(:,1)), B(:,4), 'g'); %vel_set
        hold on
        plot(u2mTime(B(:,1)), B(:,5), 'b'); %vel_meas
        plot(u2mTime(B(:,1)), B(:,2), 'r'); %set
        plot(u2mTime(B(:,1)), B(:,3), 'k'); %meas
        datetick('x');
        hold off;
    end

    function process_example(example, parameters, idx)
        if mod(idx,1000) == 0
            disp(['Index: ',num2str(idx)]);
        end
        
        B_idx = get_B_idx(idx);
        B(B_idx, 1:5) = example;
        B(B_idx, 6:8) = parameters;
        B(B_idx, end) = idx;
        
        dev(B_idx) = B(B_idx,3)-B(B_idx,2); %deviation
        
        B(B_idx,10) = B(B_idx,4)>speed;
        B(B_idx,11) = (B(B_idx,4)<-60) && (B(B_idx,4)>-100);
        B(B_idx,12) = (B(B_idx,4)>0) && (B(B_idx,4)<300);
%         B(B_idx,11) = (B(B_idx,5) == 0);
        
        %upper overshoot
        if (B(B_idx,4)<5) && (sign(dev(B_idx)) ~= sign(dev(B_idx-1))) && (sign(dev(B_idx-1))~=0) 
            if sum(B(max(1,B_idx-200):B_idx,10))>40
                    
                find_U = zeros(100,2);
               
                for k=1:100
                    if (abs(B(B_idx-k,4)-B(B_idx,4))<3)
                        find_U(k,:) = [B_idx-k, dev(B_idx-k)];                        
                    end
                end
                find_U(~any(find_U,2),:) = [];
                
                if size(find_U,1)==0
                    return
                end
                ST = B(B_idx,1) - B(find_U(end,1));
                if (ST<4) || (B(B_idx,2)<B(find_U(end,1),2))
                    return
                end
                [M, ~] = max(find_U(:,2));
                a_s = 0;
                for a = (find_U(end,1)-150):find_U(end,1)
                    a_s = a_s + B(a,4);
                end
                average_speed = a_s/150;
                y = [y;M, ST];
                X = [X;B(find_U(end,1),6:8), average_speed];
                
%                 plot(u2mTime(B(B_idx,1)), B(B_idx,2), 'g*')
%                 hold on
%                 plot(u2mTime(B(B_idx,1)), B(B_idx,4), 'r*')
%                 plot(u2mTime(B(find_U(end,1),1)), B(find_U(end,1),2), 'b*')
            end
        end
        
        %lower overshoot
        if (B(B_idx,4)>=-5) && (B(B_idx,4)<=0) && (sign(dev(B_idx)) ~= sign(dev(B_idx-1)))
            if sum(B(max(1,B_idx-200):B_idx,11))>30

                find_L=zeros(100,2);
                    
                for l=1:100
                    if (abs(B(B_idx-l,4)-B(B_idx,4))<=3)
                        find_L(l,:) = [B_idx-l, dev(B_idx-l)];
                    end
                end
                find_L(~any(find_L,2),:) = [];
                
                if size(find_L,1) == 0
                    return
                end
                ST = B(B_idx,1) - B(find_L(end,1),1); %settling time
                if sum(B(max(1,find_L(1,1)-300):find_L(1,1),12))>10
                    return
                end
                
                if (B_idx-find_L(1,1)<15) || (B(B_idx,2)>B(find_L(end,1),2))
                    return
                end
                
                a_s = 0;
                for a = (find_L(end,1)-150):find_L(end,1)
                    a_s = a_s + B(a,4);
                end
                average_speed = a_s/150;
                [M, ~] = max(find_L(:,2));
                y = [y;M, ST];
                X = [X;B(find_L(end,1), 6:8), average_speed];
                
%                 plot(u2mTime(B(B_idx,1)), B(B_idx,2), 'm*')
%                 hold on
%                 plot(u2mTime(B(B_idx,1)), B(B_idx,4), 'r*')
%                 plot(u2mTime(B(find_L(end,1),1)), B(find_L(end,1),2), 'b*') 
            end    
        end
    end


    function preprocess_example(example, idx)
        window = [window; example];
        
        if size(window, 1) >= 3
            set_vel = ((window(3,pos_set_idx) - window(1,pos_set_idx)) / ((window(3,time_idx) - window(1,time_idx))));
            set_vel = set_vel * 10^3;
            meas_vel = ((window(3,pos_meas_idx) - window(1,pos_meas_idx)) / ((window(3,time_idx) - window(1,time_idx))))*1e3; 
            process_example([window(2,time_idx), window(2,pos_set_idx), window(2,pos_meas_idx), set_vel, meas_vel], [window(2,hl_idx),window(2,mru_pos_idx),window(2,mru_vel_idx)], idx-1);
        end
        
        if size(window, 1) > 2
            window(1,:) = [];
        end
    end


    % main loop
    for block_idx = start_block:start_block+n_blocks;
        disp(['Reading block: ',num2str(block_idx)]);
        block = csvread(fname, (block_idx-1)*block_size+1, 0, [(block_idx-1)*block_size+1, 0, block_idx*block_size, 7]);       
        disp('Processing ...');
        for example_idx = 1:size(block,1)
            preprocess_example(block(example_idx,:), (block_idx-1)*block_size + example_idx);
        end
    end
    save X
    %w = (X'*X)\(X'*y);
    
%     plot_graph(B(B(:,1) ~= 0,:)); 
end