function varargout = kf_ui(varargin)
% KF_UI MATLAB code for kf_ui.fig
%      KF_UI, by itself, creates a new KF_UI or raises the existing
%      singleton*.
%
%      H = KF_UI returns the handle to a new KF_UI or the handle to
%      the existing singleton*.
%
%      KF_UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KF_UI.M with the given input arguments.
%
%      KF_UI('Property','Value',...) creates a new KF_UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before kf_ui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to kf_ui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help kf_ui

% Last Modified by GUIDE v2.5 23-Oct-2015 10:28:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @kf_ui_OpeningFcn, ...
                   'gui_OutputFcn',  @kf_ui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%% global var defination
global A H P Q R M Z Zr;

% --- Executes just before kf_ui is made visible.
function kf_ui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to kf_ui (see VARARGIN)

% Choose default command line output for kf_ui
handles.output = hObject;

%添加绘图工具栏
set(hObject,'toolbar','figure');

global A H P Q R M Z Zr;

[A, H, P, Q, R, M, Z, Zr] = kf_model(1); 

set(handles.table_P,'Data',P);
set(handles.table_Q,'Data',Q);
set(handles.table_R,'Data',R);
set(handles.combo_model,'string',{'随机变量','CWPA','CA(8字)'});

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes kf_ui wait for user response (see UIRESUME)
% uiwait(handles.figure1);




% --- Outputs from this function are returned to the command line.
function varargout = kf_ui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_calculate.
function btn_calculate_Callback(hObject, eventdata, handles)
% hObject    handle to btn_calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global A H P Q R M Z Zr;
Ak = A;
Hk = H;
Mk = M;
Zk = Z;
Pk = P;
Qk = get(handles.table_Q,'data');
Rk = get(handles.table_R,'data');
Mdim = int16(size(Mk,1));
Zdim = int16(size(Zk,1));
MXidx = 1;
MYidx = fix(Mdim/2+1);
ZXidx = 1;
ZYidx = fix(Zdim/2+1);
N = size(Zk,2);
xx = zeros(Mdim,N);
PP = zeros(Mdim,Mdim,N);
errCnt = 0;
for i = 1 : N
    [Xpre, Ppre] = kf_predict(Mk, Pk, Ak, Qk);
    if( abs(Xpre(MXidx)-Zk(ZXidx,i))> 4)
        errCnt = errCnt + 1;
    else
        [Mk, Pk] = kf_update(Xpre, Ppre, Zk(:,i),Hk, Rk);
    end
    if(errCnt > 4)
        errCnt = 0;
        Mk = Xpre;
    end
    xx(:,i) = Mk;
    PP(:,:,i) = Pk;
end

cla(handles.axes1,'reset');
cla(handles.axes2,'reset');
cla(handles.axes3,'reset');
cla(handles.axes4,'reset');
cla(handles.axes5,'reset');

%轨迹
axes(handles.axes1);
if(Zdim==1)
    plot(Zk(ZXidx,:),'b+','linewidth',1);
    hold on;
    plot(xx(MXidx,:),'r-','linewidth',2);
    if(~isempty(Zr))
        hold on;
        plot(Zr(ZXidx,:),'g-','linewidth',2);
    end
else
    plot(Zk(ZXidx,:),Zk(ZYidx,:),'b+','linewidth',1);
    hold on;
    plot(xx(MXidx,:),xx(MYidx,:),'r-','linewidth',2);
    if(~isempty(Zr))
        hold on;
        plot(Zr(ZXidx,:),Zr(ZYidx,:),'g-','linewidth',2);
    end   
end
legend('测量值','滤波值','理论值',4);
xlabel('x/m');
ylabel('y/m');
title('轨迹对比');
set(gca,'XGrid','on');
set(gca,'YGrid','on');


% x方向距离
axes(handles.axes2);
plot(Zk(ZXidx,:),'b-');
hold on;
plot(xx(MXidx,:),'r-', 'linewidth',2);
if(~isempty(Zr))
    hold on;
    plot(Zr(ZXidx,:),'g-','linewidth',2);
end
legend('测量值','滤波值','理论值',4);
title('x方向距离');
set(gca,'XGrid','on');
set(gca,'YGrid','on');
if(~isempty(Zr))
    % x方向误差
    axes(handles.axes3);
    plot(Zk(ZXidx,:)-Zr(ZXidx,:),'b-');
    hold on;
    plot(xx(MXidx,:)-Zr(ZXidx,:),'g-', 'linewidth', 2);
    hold on;
    legend('测量误差','滤波误差', 4);
    title('x方向误差');
    set(gca,'XGrid','on');
    set(gca,'YGrid','on');
end
    
if(Zdim>1)
    % y方向距离
    axes(handles.axes4);
    plot(Zk(ZYidx,:),'b-');
    hold on;
    plot(xx(MYidx,:),'r-', 'linewidth',2);
    if(~isempty(Zr))
        hold on;
        plot(Zr(ZYidx,:),'g-','linewidth',2);
    end
    legend('测量值','滤波值','理论值',4);
    title('y方向距离');
    set(gca,'XGrid','on');
    set(gca,'YGrid','on');
    if(~isempty(Zr))
        % y方向误差
        axes(handles.axes5);
        plot(Zk(ZYidx,:)-Zr(ZYidx,:),'b-');
        hold on;
        plot(xx(MYidx,:)-Zr(ZYidx,:),'g-', 'linewidth', 2);
        hold on;
        legend('测量误差','滤波误差', 4);
        xlabel('time/0.05sec');
        set(gca,'XGrid','on');
        set(gca,'YGrid','on');
    end
end
set(handles.table_P, 'data',Pk);
guidata(hObject, handles);


% --- Executes on selection change in combo_model.
function combo_model_Callback(hObject, eventdata, handles)
% hObject    handle to combo_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns combo_model contents as cell array
%        contents{get(hObject,'Value')} returns selected item from combo_model
global A H P Q R M Z Zr;
model = get(hObject,'value');
[A, H, P, Q, R, M, Z, Zr] = kf_model(model);
set(handles.table_P,'Data',P);
set(handles.table_Q,'Data',Q);
set(handles.table_R,'Data',R);


% --- Executes during object creation, after setting all properties.
function combo_model_CreateFcn(hObject, eventdata, handles)
% hObject    handle to combo_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
