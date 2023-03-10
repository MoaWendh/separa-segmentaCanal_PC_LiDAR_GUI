function [nameCanal numCanal angle]= fDetectaCanal(handles, nameFile)

switch nameFile
    case 'cn01.pcd'
        nameCanal= handles.lookUpTable{1};
        numCanal= 0;
        angle= -15;
    case 'cn02.pcd'
        nameCanal= handles.lookUpTable{2};
        numCanal= 2;
        angle= -13;
    case 'cn03.pcd'
        nameCanal= handles.lookUpTable{3}; 
        numCanal= 4;
        angle= -11;        
    case 'cn04.pcd'
        nameCanal= handles.lookUpTable{4}; 
        numCanal= 6;
        angle= -9;
    case 'cn05.pcd'
        nameCanal= handles.lookUpTable{5}; 
        numCanal= 8;
        angle= -7;
    case 'cn06.pcd'
        nameCanal= handles.lookUpTable{6}; 
        numCanal= 10;
        angle= -5;
    case 'cn07.pcd'
        nameCanal= handles.lookUpTable{7}; 
        numCanal= 12;
        angle= -3;
    case 'cn08.pcd'
        nameCanal= handles.lookUpTable{8}; 
        numCanal= 14;
        angle= -1;
    case 'cn09.pcd'
        nameCanal= handles.lookUpTable{9}; 
        numCanal= 1;
        angle= 1;
    case 'cn10.pcd'
        nameCanal= handles.lookUpTable{10}; 
        numCanal= 3;
        angle= 3;
    case 'cn11.pcd'
        nameCanal= handles.lookUpTable{11}; 
        numCanal= 5;
        angle= 5;
    case 'cn12.pcd'
        nameCanal= handles.lookUpTable{12}; 
        numCanal= 7;
        angle= 7;
    case 'cn13.pcd'
        nameCanal= handles.lookUpTable{13}; 
        numCanal= 9;
        angle= 9;
    case 'cn14.pcd'
        nameCanal= handles.lookUpTable{14}; 
        numCanal= 11;
        angle= 11;
    case 'cn15.pcd'
        nameCanal= handles.lookUpTable{15}; 
        numCanal= 13;
        angle= 13;
    case 'cn16.pcd'
        nameCanal= handles.lookUpTable{16};
        numCanal= 15;
        angle= 15;        
    otherwise
        nameCanal= "";
        numCanal= 99;
        angle= 0;
end      
end