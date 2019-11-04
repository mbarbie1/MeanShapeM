% ------------------------------------------------------------------------
% MEANSHAPE GUI SCRIPT
% ------------------------------------------------------------------------
% ...
%
% ------------------------------------------------------------------------

%% Clean and start the clock
close all;
clear all;
tic;

%% Add lib path
addpath(genpath('./lib') );
addpath(genpath('../lib_external') );

%% Constants
C = Constants;

%% variables

current_curve_index = 1;

curve_list = {};
q_list = {};
q_inter_list = {};
r_inter_list = {};
energy_reparametrization = {};
energy_reconstruction = [];

%% Make the UI
f = figure;
ui = struct();
ui.curve_path_list = {};
ui.curve_list = {};
ui.current_curve_index = 1;
ui.initiated = 0;
ui.status_changed = 0;
ui.curve_plot_list = {};
ui.curve_color_list = {'b-','r-'};
ui.curve_dot_color = 'black';
ui.plot_skip_ratio = 0.1;
ui.LABEL_CURVE_LIST = C.LABEL_CURVE_LIST;
guidata( f, ui );

% Enlarge figure to full screen.
set( f, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.1, 0.8, 0.8]);
panel_ratio = 0.2;
panel_margin = 0.03;
button_height = 0.15;

p_curves = uipanel(f,'Title','Curves',...
             'Position',[panel_margin 0.5+panel_margin panel_ratio 0.5-panel_margin]);

p_algo = uipanel(f,'Title','Mean shape',...
             'Position',[panel_margin panel_margin panel_ratio 0.5-panel_margin]);

ax = axes('Parent',f,'Position',[panel_ratio + 0.1 .1 1.-panel_ratio-0.15 .85]);

rb_curve_selection = uibuttongroup(p_curves,...
                  'Units','normalized',...
                  'Position',[0 0.8 1 0.2],...
                  'SelectionChangedFcn',{@curve_selection_callback, ax, f});
% Create three radio buttons in the button group.
r1 = uicontrol(rb_curve_selection,...
                  'Style','radiobutton',...
                  'String',C.LABEL_CURVE_REFERENCE,...
                  'Units','normalized',...
                  'Position',[0.1 0.45 0.4 button_height],...
                  'HandleVisibility','off');
r2 = uicontrol(rb_curve_selection,'Style','radiobutton',...
                  'String',C.LABEL_CURVE_OTHER,...
                  'Units','normalized',...
                  'Position',[0.5 0.45 0.4 button_height],...
                  'HandleVisibility','off');

pb_load = uicontrol(p_curves,'Style','pushbutton','String','Load curve',...
'Units','normalized',...
'Position',[0.1 0.5 0.8 button_height],...
'Callback',{@pb_load_callback, ax, f });
pb_set_curve = uicontrol(p_curves,'Style','pushbutton','String','Set curve',...
'Units','normalized',...
'Position',[0.1 0.3 0.8 button_height],...
'Callback',@pb_set_callback);
pb_remove_curve = uicontrol(p_curves,'Style','pushbutton','String','Remove curve',...
'Units','normalized',...
'Position',[0.1 0.1 0.8 button_height],...
'Callback',{@pb_remove_callback, ax, f});


pb_init = uicontrol(p_algo,'Style','pushbutton','String','Initialize',...
'Units','normalized',...
'Position',[0.1 0.7 0.8 0.2],...
'Callback',@pb_init_callback);
pb_continu = uicontrol(p_algo,'Style','pushbutton','String','Continu',...
'Units','normalized',...
'Position',[0.1 0.4 0.8 0.2],...
'Callback',@pb_continu_callback);


%% ui helper functions

function h = plot_curve_single( f, ax, rr, skip_ratio, color, dot_color )
    ui = guidata( f );
    dot_size = 12;
    skip = floor(1/skip_ratio);
    h = plot( rr(1,:), rr(2,:), color, 'Parent', ax );
    hold on;
    scatter( rr(1,1:skip:end), rr(2,1:skip:end), dot_size, dot_color, 'Parent', ax );
    axis(ax,'equal');
    hold on;
end

function update_curves( f, ax )
    ui = guidata( f );
    hs = findobj('type','line');
    for ih = 1:length(hs)
        delete(hs(ih));
    end
    for j = 1:length(ui.curve_list)
        rr = ui.curve_list{j};
        if numel( rr ) > 0
            %delete(ui.curve_plot_list{j});
            ui.curve_plot_list{j} = plot_curve_single( f, ax, rr, ui.plot_skip_ratio, ui.curve_color_list{j}, ui.curve_dot_color );
        end
    end
    guidata( f, ui );
end


%% Callbacks
function curve_selection_callback( rb_curve_selection, eventdata, ax, f )
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    display(['Current selected curve = ' eventdata.NewValue.String]);
    ui = guidata( f );
    switch eventdata.NewValue.String
        case ui.LABEL_CURVE_LIST{1}
            %assignin( 'base', 'current_curve_index', 1 );
            ui.current_curve_index = 1;
            guidata( f, ui );
        case ui.LABEL_CURVE_LIST{2}
            %assignin( 'base', 'current_curve_index', 2 );
            ui.current_curve_index = 2;
            guidata( f, ui );
    end
end

function pb_load_callback( pb_load, eventdata, ax, f )
    
    display('Load curve');
    ui = guidata( f );
    [ file_name, folder_path ] = uigetfile({'*.*','All Files'},...
        'Select curve file');
    file_path = fullfile( folder_path, file_name );
    display( file_path );
    rr = csvread( file_path )';
    rr(2,:) = -rr(2,:);
    ui.curve_path_list{ ui.current_curve_index } = file_path;
    ui.curve_list{ ui.current_curve_index } = rr;
    guidata( f, ui );
    update_curves( f, ax );
end

function pb_set_callback( pb_set, eventdata, handles)
   
    display('Button pressed');
end
function pb_remove_callback( pb_remove, eventdata, ax, f )

    ui = guidata( f );
    display(['Remove curve: ' ui.LABEL_CURVE_LIST{ ui.current_curve_index } ]);
    ui.curve_list{ ui.current_curve_index } = [];
    ui.curve_path_list{ ui.current_curve_index } = '';
    guidata( f, ui );
    update_curves( f, ax );
end
function pb_init_callback( pb_init, eventdata, ax, f )
    
    display('Initialize mean shape calculation');
    load_curves
    
end
function pb_continu_callback( pb_continu, eventdata, ax, f )
    
    display('Continue iterations');
end
