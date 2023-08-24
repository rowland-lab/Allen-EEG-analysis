classdef PynapseMetrics < handle
    %PynapseMetrics  Class for interfacing with Pynapse gizmo in Snapse.
    %   obj = PynapseMetrics() connects to Pynapse running on local PC.
    %
    %   obj                 reference to TDTUDP object
    %   obj.read            get next packet
    %
    %   obj.metrics         string containing the metrics data
    %
    %   'parameter', value pairs
    %      'HOSTNAME'   string, PC's IP address or NetBIOS name. Default is
    %                       'localhost'.
    
    properties
        HOSTNAME = 'localhost';
        
        % Important: the Pynapse UDP interface port is fixed at 24416
        UDP_PORT = 24416;
        
        INPUT_BUFFER_SIZE  = 4096;
        OUTPUT_BUFFER_SIZE = 4096;
        VERBOSE = 0;
        
        USE_TOOLBOX = 0;
        REORDER = [];
        
        SOCK = [];
        U = [];
        data = [];
        
    end
    
    methods
        function obj = PynapseMetrics(varargin)
            
            % parse varargin
            for i = 1:2:length(varargin)
                eval(['obj.' upper(varargin{i}) '=varargin{i+1};']);
            end
            
            % create a UDP socket object, connect the PC to the target UDP interface
            
            xxx = ver;
            for i = 1:numel(xxx)
                if strcmpi(xxx(i).Name, 'Instrument Control Toolbox')
                    obj.USE_TOOLBOX = 1;
                end
            end
            try
                if obj.USE_TOOLBOX
                    obj.U = udp(HOSTNAME, ...
                        obj.UDP_PORT, ...
                        'InputBufferSize', obj.INPUT_BUFFER_SIZE, ...
                        'OutputBufferSize', obj.OUTPUT_BUFFER_SIZE);
                else
                    try
                        obj.SOCK = pnet('udpsocket', obj.UDP_PORT);
                        pnet(obj.SOCK, 'setwritetimeout', 1);
                        pnet(obj.SOCK, 'setreadtimeout', 1);
                        pnet(obj.SOCK, 'udpconnect', 'hostname', obj.HOSTNAME);
                    catch
                        error('problem creating UDP socket')
                    end
                end
            catch
                error('problem creating UDP socket')
            end
            
            % bind preliminary IP address and port number to the PC
            if obj.USE_TOOLBOX
                fopen(obj.U);
                if ~strcmp(get(obj.U, 'Status'), 'open')
                    error('problem opening UDP socket')
                end
            end
        end
        
        function delete(obj)
            if obj.USE_TOOLBOX
                fclose(obj.U);
                delete(obj.U);
            else
                %fclose(obj.SOCK);
                %delete(obj.SOCK);
            end
        end
        
        function obj = read(obj)
            % read a single packet in as uint32
            if obj.USE_TOOLBOX
                A = fread(obj.U, 1, 'char');
            else
                % read a single packet in
                len = pnet(obj.SOCK, 'readpacket');
                if len > 0
                    % if packet larger then 1 byte then read maximum of 1000 doubles in network byte order
                    A = pnet(obj.SOCK, 'read', obj.INPUT_BUFFER_SIZE, 'char', 'network')';
                end
            end
            
            if ~exist('A','var')
                obj.data = [];
                return
            end
            
            obj.data = strcat(A');
            obj.process();
        end

        function obj = process(obj)
            if isempty(obj.data)
                return
            end
            pat_value = "\[(?<session>.+)\.(?<block>.+)\.(?<trial>.+)\] (?<name>.+)\=(?<value>.+)";
            tokenNames = regexp(obj.data, pat_value, 'names');
            dtype = '';
            if isempty(tokenNames)
                pat_session = "\[(?<session>.+)\.(?<block>.+)\.(?<trial>.+)\] (?<entry>.+)";
                tokenNames = regexp(obj.data, pat_session, 'names');
                if isempty(tokenNames)
                    pat_raw_time = "(?<time_str>[^\s]+)[\s]{4}(?<entry>.+)";
                    tokenNames = regexp(obj.data, pat_raw_time, 'names');
                    if isempty(tokenNames)
                        tokenNames = struct('entry', obj.data);
                        dtype = 'RawEntry';
                    else
                        dtype = 'RawEntryTimestamp';
                    end
                else
                    dtype = 'SessionEntry';
                end
            else
                dtype = 'Value';
            end

            if isempty(tokenNames)
                return
            end

            if isstruct(tokenNames)
                if isfield(tokenNames, 'session')
                    tokenNames.session = str2double(tokenNames.session);
                    tokenNames.block = str2double(tokenNames.block);
                    tokenNames.trial = str2double(tokenNames.trial);
                end
                if isfield(tokenNames, 'value')
                    tokenNames.value = str2double(tokenNames.value);
                end
                if isfield(tokenNames, 'time_str')
                    try
                        [Y,MO,D,H,MI,S] = datevec([tokenNames.time_str '0'], 'HH:MM:SS.FFF');
                    catch
                        [Y,MO,D,H,MI,S] = datevec([tokenNames.time_str '0'], 'MM:SS.FFF');
                    end
                    tokenNames.time = (((D-1)*24 + H)*60 + MI) * 60 + S;
                end
            end

            obj.data = tokenNames;
            obj.data.type = dtype;
        end
    end
end
