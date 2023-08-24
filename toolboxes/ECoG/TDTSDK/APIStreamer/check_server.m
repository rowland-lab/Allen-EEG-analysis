function result = check_server(td)
%CHECK_SERVER Ensures a valid connection to WorkEngine using TDevAccX
%     returns 1 when connection is valid, otherwise 0
%     will also timeout after 0.5 seconds of not making a valid connection

    check_server_tic = tic;
    result = 1;
    check_server_toc = 0;
    if ~td.CheckServerConnection
        fprintf('Bad Connection\n')
        while 1
             td.ConnectServer('Local');
             if ~td.CheckServerConnection
                 check_server_toc = toc(check_server_tic);
                 if check_server_toc > 0.5
                     result = 0;
                     break
                 end
             else
                 break
             end
         end
    end
    
    if 1e3*check_server_toc > 1
        fprintf('server delay: %.3f ms\n', 1e3*check_server_toc);
    end
    
    if result == 0
        warning('TDevAccX fallback to SynapseAPI - try restarting Matlab if this continues')
    end
end