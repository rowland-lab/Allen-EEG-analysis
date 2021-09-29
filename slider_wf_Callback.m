function slider_wf_Callback(hObject, eventdata, handles)
persistent lineHandle 
if isempty(lineHandle) || ~isvalid(lineHandle)
    % Create line: 1st input is axis handle
    lineHandle = xline(handles.Axes, 0,'r-'); 
end
% Update line position
slider_value = int32(get(hObject,'Value'));
lineHandle.Value = slider_value/20; 
end