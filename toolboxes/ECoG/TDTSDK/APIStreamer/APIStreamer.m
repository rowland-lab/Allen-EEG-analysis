classdef APIStreamer < handle
    %APIStreamer  TDT class to stream data from Synapse.
    %   obj = APIStreamer(varargin) reads data from an APIStreamer gizmo in
    %   Synapse, using the SynapseAPI. It handles the details of keeping
    %   track of buffer indicies and makes the data available as a Matlab
    %   array. Optional arguments are listed below
    %
    %   obj              reference to APIStreamer object
    %   obj.start()      start buffering data
    %   obj.stop()       stop buffering data
    %   obj.get_data()   get timestamp and data array, where each channel
    %                      is a row. If 'DO_FFT' is enabled, FFT data is
    %                      returned where the first dimension is FFT in
    %                      each frequency bin (see FREQ and RESOLUTION
    %                      parameters), and second dimension is the time
    %                      window (see HISTORY and WINSIZE parameters).
    %                      If more than 1 channel is streamed, the FFT data
    %                      has a third dimension for channel number.
    %                      data(channel, FFT, time bin)
    %   obj.running()    check if Synapse is in run mode
    %   obj.fs           get sampling rate of the streaming store
    %   
    %   'parameter', value pairs
    %      'SERVER'     string, Synapse computer IP address
    %                      (default = 'localhost')
    %      'GIZMO'      string, name of the APIStreamer gizmo in Synapse
    %                      that this will connect to
    %                      (default = 'APIStreamer1')
    %      'HISTORY'    scalar, amount of data (in seconds) to keep in its
    %                       memory (default = 1 second)
    %      'PERIOD'     scalar, time between attempts to poll data, in
    %                       seconds. (default = 0.1 seconds)
    %      'USE_TDEV'   boolean, use TDevAccX ActiveX control for faster
    %                       polling. Requires Windows and OpenDeveloper.
    %                       (default = false)
    %      'CALLBACK'   function handle, this function gets called whenever
    %                       new data comes in
    %      'DO_FFT'     boolean, perform FFT on the incoming data. This
    %                       setting also activates the parameters below
    %                       (default = false)
    %      'RESOLUTION' scalar, frequency resolution of FFT, in Hz
    %                       (default = 0.25 Hz)
    %      'WINSIZE'    scalar, window size for FFT, in seconds
    %                       (default = 5 seconds)
    %      'OVERLAP'    scalar, amount of overlap between FFT windows
    %                       (default = 0.1, or 10% overlap)
    %      'SMOOTHING'  scalar, power spectrum simple moving average
    %                       smoothing on range [0,1] (default = 0)
    %      'FREQ'       vector, frequency range to plot, inclusive.
    %                       (default = [1 30])
    %
    %   Example:
    %      s = APIStreamer('HISTORY', 5);
    %      h = figure;
    %      while ~isempty(findobj(h)) % run while the figure is open
    %          % while s.running() % run while Synapse is recording
    %          [data, ts] = s.get_data();
    %          plot(s.ts, s.data)
    %          drawnow
    %      end
    %      s.stop()
    %
    
    properties
        USE_TDEV    = 0;
        SERVER      = 'localhost';
        GIZMO       = 'APIStreamer';
        HISTORY     = 1; % seconds; total amount of data
        SYN         = []; % extra connection to SynapseAPI
        PERIOD      = 0.1; % timer period, in seconds
        CALLBACK    = [];
        t           = [];
        
        % FFT properties
        DO_FFT      = 0;
        RESOLUTION  = .25; % frequency resolution, in Hz
        WINSIZE     = 5; % window size for FFT, in seconds
        OVERLAP     = .1; % amount of overlap between windows: 0.2 = 20%
        SMOOTHING   = 0; % power spectrum simple moving average smoothing ([0,1])
        FREQ        = [1 30]; % frequency range to plot, inclusive
    end
    
    methods
        function obj = APIStreamer(varargin)
            
            % parse varargin
            ttt = 0;
            for ii = 1:2:length(varargin)
                if strcmpi(varargin{ii}, 'DO_FFT')
                    ttt = 1;
                end
            end
            if ttt
                VALID_PARS = {'SERVER','GIZMO','HISTORY','PERIOD','CALLBACK','USE_TDEV','DO_FFT','RESOLUTION','WINSIZE','OVERLAP','SMOOTHING','FREQ'};
            else
                VALID_PARS = {'SERVER','GIZMO','HISTORY','PERIOD','CALLBACK','USE_TDEV'};
            end
            for ii = 1:2:length(varargin)
                if ~ismember(upper(varargin{ii}), VALID_PARS)
                    error('%s is not a valid parameter. See help SynStreamer.', upper(varargin{ii}));
                end
                eval(['obj.' upper(varargin{ii}) '=varargin{ii+1};']);
            end
            
            % enforce ranges
            obj.OVERLAP = min(obj.OVERLAP, 1);
            obj.OVERLAP = max(obj.OVERLAP, 0);
            obj.SMOOTHING = min(obj.SMOOTHING, 1);
            obj.SMOOTHING = max(obj.SMOOTHING, 0);
            obj.WINSIZE = min(obj.WINSIZE, obj.HISTORY);
            obj.WINSIZE = max(obj.WINSIZE, 0.1);
            
            obj.SYN = SynapseAPI(obj.SERVER);
            
            if obj.SYN.getMode < 2
                fprintf('Waiting for Synapse to enter run mode before continuing.\n\n');
                while obj.SYN.getMode < 2
                    pause(.5)
                end
            end
            
            obj.t = timer('BusyMode', 'queue', ...
                          'ExecutionMode', 'fixedSpacing', ...
                          'Period', obj.PERIOD);
            data_obj = struct();
            data_obj.data = [];
            data_obj.ts = [];
            data_obj.fs = 0;
            data_obj.buff_size = 0;
            data_obj.curr_index = 0;
            data_obj.curr_looptime = 0;
            data_obj.curr_loop = 0;
            data_obj.prev_index = 0;
            data_obj.decimation = 1;
            data_obj.nchan = 1;
            data_obj.syn = SynapseAPI(obj.SERVER);
            data_obj.gizmo = obj.GIZMO;
            data_obj.history = obj.HISTORY;
            data_obj.do_reset = 1;
            data_obj.waiting = 1;

            data_obj.do_fft = obj.DO_FFT;
            data_obj.overlap = obj.OVERLAP;            
            data_obj.smoothing = obj.SMOOTHING;
            data_obj.winsize = obj.WINSIZE;
            data_obj.resolution = obj.RESOLUTION;
            data_obj.fft_freq = obj.FREQ;
            data_obj.fft_data = [];
            data_obj.fft_time = [];
            data_obj.fft_index = 0;
            data_obj.block_reserve = 0;
            data_obj.fft_window = 0;
            if obj.USE_TDEV
                data_obj.TD = actxserver('TDevAcc.X');
                data_obj.TD.ConnectServer('Local');
            end
            data_obj.use_tdev = obj.USE_TDEV;
            data_obj.callback = obj.CALLBACK;
            
            obj.t.UserData = data_obj;
            obj.t.TimerFcn = {@timer_callback, 'Nothing'};
            obj.start();
            pause(.2)
        end
        
        function delete(obj)
            obj.stop();
            delete(obj.t);
        end

        function start(obj)
            start(obj.t);
            fprintf('APIStreamer %s\n', obj.t.Running);
        end
        
        function stop(obj)
            stop(obj.t);
            fprintf('APIStreamer %s\n', obj.t.Running);
        end
        
        function result = get_params(obj)
            s = obj.t.UserData;
            result = fields(s);
        end
        
        function result = fs(obj)
            s = obj.t.UserData;
            result = s.fs;
        end
        
        function result = running(obj)
            result = obj.SYN.getMode() > 1;
        end
        
        function result = set_state(obj, new_state)
            if obj.USE_TDEV
                s = obj.t.UserData;
                if check_server(s.TD)
                    result = s.TD.SetTargetVal([s.tag_prefix 'Feedback'], new_state);
                else
                    result = obj.SYN.setParameterValue(obj.GIZMO, 'Feedback', new_state);
                end
            else
                result = obj.SYN.setParameterValue(obj.GIZMO, 'Feedback', new_state);
            end
        end
        
        function param = get(obj, param)
            s = obj.t.UserData;
            param = s.(param);
        end
        
        function [data, ts, varargout] = get_data(obj)
            nout = max(nargout,1)-1;
            %fprintf('get_data1\n');
            s = obj.t.UserData;
            if s.do_fft
                data = s.fft_data;
                if nout > 0 
                    if ~isempty(data)
                        varargout(1) = {s.freq_bins};
                    else
                        varargout(1) = {0};
                    end
                end
            else
                data = s.data;
            end
            ts = s.ts;
            %fprintf('get_data2\n');
        end
    end
end

function timer_callback(obj, event, text_arg)

s = obj.UserData;

if s.waiting
    s.waiting = s.syn.getMode() < 2;
    obj.UserData = s;
    return
end
    
if s.do_reset
    s = timer_reset(s);
    obj.UserData = s;
    return
end

% debug statements
if 0
    txt1 = ' event occurred at ';
    txt2 = text_arg;

    event_type = event.Type;
    event_time = datestr(event.Data.time);

    msg = [event_type txt1 event_time];
    disp(msg)
    disp(txt2)
end

try
    % Look for new data
    s = obj.UserData;
    s = timer_update_values(s);
    %disp('update done')
    %fprintf('curr: %d prev: %d\n', s.curr_index, s.prev_index);
    
    if s.curr_index ~= s.prev_index
        if s.curr_index > s.prev_index
            s.npts = s.curr_index - s.prev_index;
        elseif s.prev_index > s.curr_index
            % buffer wrapped back to the beginning
            % just read up until the end of the buffer this time around
            s.npts = s.buff_size - s.prev_index;
        end
        
        % Read the new data and rotate the Matlab memory buffer
        if s.nchan > 3
            s.npts = s.npts - mod(s.npts, s.nchan); % make sure we read a multiple of nchan
            s.npts = round(min(s.npts, s.nchan * s.sample_limit)); % read no more than NCHAN*SAMPLE_LIMIT points
        else
            s.npts = round(min(s.npts, s.sample_limit)); % read no more than SAMPLE_LIMIT points
        end
        
        if s.nchan < 4
            s.new_data = zeros(s.nchan, s.npts);
            for ch = 1:s.nchan
                if s.use_tdev && check_server(s.TD)
                    s.new_data(ch,:) = s.TD.ReadTargetVEX([s.tag_prefix 'data' num2str(ch)], s.prev_index, s.npts, 'F32', 'F64');
                else
                    s.new_data(ch,:) = s.syn.getParameterValues(s.gizmo, ['data' num2str(ch)], s.npts, s.prev_index)';
                end
            end
            s.curr_time = (s.curr_looptime + s.curr_loop * s.buff_size) / s.device_fs;
        else
            if s.use_tdev && check_server(s.TD)
                s.new_data = s.TD.ReadTargetVEX([s.tag_prefix 'data'], s.prev_index, s.npts, 'F32', 'F64');
            else
                s.new_data = s.syn.getParameterValues(s.gizmo, 'data', s.npts, s.prev_index)';
            end
            s.new_data = reshape(s.new_data, s.nchan, []);
            s.curr_time = (s.curr_looptime + s.curr_loop * s.buff_size / s.nchan) / s.device_fs;
        end

        %fprintf('new_data: %.2f %.2f\n', s.new_data(1), s.new_data(end))
        %fprintf('data: %.2f %.2f\n', s.data(1), s.data(end))
        
        if s.do_fft
            
            % append data
            if isempty(s.data)
                s.data = s.new_data;
            else
                s.data = cat(2, s.data, s.new_data);
            end
            
            % see if 1 window has passed
            if size(s.data, 2) > s.fft_window
                ddd.data = s.data(:,1:s.fft_window);
                ddd.fs = s.fs;
                if ~isempty(s.fft_data)
                    % rotate the existing data
                    s.fft_data = circshift(s.fft_data, [0 -1]);
                end
                for ch = 1:s.nchan
                    [fft_data, s.freq_bins] = TDTfft(ddd, ch, ...
                        'PLOT', 0, ...
                        'NUMAVG', round(s.fft_window/(s.fs * 0.5)), ...
                        'RESOLUTION', s.resolution, ...
                        'FREQ', s.fft_freq);
                    
                    % convn performs moving average to smooth out spectrum
                    if s.smoothing > 0
                        smooth = floor(numel(fft_data) * s.smoothing);
                        if smooth > 0
                            fft_data = convn(fft_data, ones(smooth,1)/smooth, 'same');
                        end
                    end
                    
                    % create fft array during the first run
                    if isempty(s.fft_data)
                        if s.nchan > 1
                            s.fft_data = zeros(s.nchan, length(fft_data), s.block_reserve);
                        else
                            s.fft_data = zeros(length(fft_data), s.block_reserve);
                        end
                    end
                    
                    % insert the new data at the end of our array
                    if s.nchan > 1
                        s.fft_data(ch, :, end) = fft_data;
                    else
                        s.fft_data(:, end) = fft_data;
                    end
                end
                
                s.ts = linspace(s.curr_time - s.history, s.curr_time, s.block_reserve);
                %fprintf('Wav Length = %d, T = %g seconds\n', length(s.data), s.ts(end));
        
                % remove data from beginning of big buffer
                s.data = s.data(:, floor(s.fft_window*(1-s.overlap))+1:end);
                s.fft_index = s.fft_index - s.fft_window;
            end
        else
            if ~isempty(s.new_data)
                if s.nchan > 3
                    test_pts = s.npts / s.nchan;
                else
                    test_pts = s.npts;
                end
                if test_pts > size(s.data, 2)
                    fprintf('polling too slow, removing points\n')
                    s.data = s.new_data(:, end-size(s.data, 2)+1:end);
                else
                    s.data = circshift(s.data, [0 -test_pts]);
                    s.data(:, (end-test_pts+1):end) = s.new_data;
                end
                s.ts = s.curr_time - s.history + (1:size(s.data,2)) / s.fs;
            end
        end

        % DO PROCESSING HERE
        if ~isempty(s.new_data) && ~isempty(s.callback)
            result = s.callback(s);
        end
        
        %s.ts = s.ts(1:size(s.data,2));
        %disp(size(s.ts));
        %disp(size(s.data));
        
        % Update TDT buffer index variable for next loop
        if ~isempty(s.new_data)
            s.prev_index = s.prev_index + s.npts;
            if s.prev_index >= s.buff_size
                s.prev_index = s.prev_index - s.buff_size;
            end
        end
    end
    obj.UserData = s;
    
catch
    s = obj.UserData;
    if s.syn.getMode() < 2
        fprintf('Waiting for Synapse to enter run mode before continuing.\n')
        s.waiting = 1;
        s.do_reset = 1;
        obj.UserData = s;
    end
end
end

function s = timer_update_values(s)
    %disp('update');
    if s.use_tdev
        if check_server(s.TD)
            vals = s.TD.ReadTargetVEX([s.tag_prefix 'mon'], 0, 4, 'I32', 'F64');
        else
            vals = s.syn.getParameterValues(s.gizmo, 'mon', 4);
        end
    else
        vals = s.syn.getParameterValues(s.gizmo, 'mon', 4);
    end
    s.curr_index = vals(1);
    s.curr_looptime = vals(2);
    s.curr_loop = vals(3);
    s.decimation = vals(4);
end
                
function s = timer_reset(s)
    disp('Resetting APIStreamer')
    
    info = s.syn.getGizmoInfo(s.gizmo);
    if ~isstruct(info)
        error(['Couldn''t find gizmo ''' s.gizmo '''']);
    end
    
    % Set up variables, determine sampling rate
    samp_rates = s.syn.getSamplingRates();
    s.parent = s.syn.getGizmoParent(s.gizmo);

    dev_index = s.parent(end);
    dev = s.parent(1:strfind(s.parent, '_')-1);
    s.tag_prefix = [dev '(' dev_index ').' s.gizmo '_'];
    
    vals = s.syn.getParameterValues(s.gizmo, 'mon', 6);
    
    if numel(vals) < 6
        error('Problem reading data using SynapseAPI, restart and try again')
    end
    
    s.nchan = vals(5);
    s.buff_size = vals(6);
    
    %s.buff_size = s.syn.getParameterSize(s.gizmo, 'data');
    s = timer_update_values(s);
    
    s.device_fs = samp_rates.(s.parent);
    s.fs = s.device_fs / s.decimation;
    
    fprintf('%d channels in %d sample buffer at %2f Hz\n', ...
        s.nchan, s.buff_size, s.fs);

    s.sample_limit = floor(s.fs / 4);
    s.sample_limit = max(1000, s.sample_limit -mod(s.sample_limit, 1000));

    % Fetch the first data points and set up memory buffer
    s.prev_index = s.curr_index;
    %with self.data_lock:
    
    % set up variables
    if s.do_fft
        s.fft_window = floor(s.fs * s.winsize);
        s.block_reserve = round((s.history)/((1-s.overlap)*s.winsize) + 1);
        s.data = [];
        s.ts = 0;
        s.freq_bins = [];
    else
        s.data = zeros(s.nchan, round(s.history * s.fs));
        s.ts = zeros(1, size(s.data,2));
    end
       
    s.result = 0;
    s.do_reset = 0;
    s.waiting = 0;
end