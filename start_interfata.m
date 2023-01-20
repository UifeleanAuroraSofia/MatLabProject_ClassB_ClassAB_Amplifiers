clc;
close all;
clear all;

nr_index = [205, 7];
tipSemnal = 1; % indecsii semnalului
               % 1-SIN, 2-TR
tipCircuit = 2; % indecsii circuitului
                % 1-Clasa_B, 2-Clasa_AB
aSemnal = 5; % Volt
fSemnal = 1E+3; % Hz
valoriRezistente = readtable('Rezistentele_mele.xlsx', 'VariableNamingRule','preserve');
RL = 1; % Ohm
R = 1; % Ohm
Np = 2; % numar perioade semnal
Vcc = 7; % Volt

Id = 0; % Watt
Po = 0; % Watt
PT = 0; % Watt
Pd = 0; % Watt
PR = 0; % Watt
Ptot = 0; % Watt

valoriR = 1; % de la 1 la 7, ordini de masura pentru rezistentele nominale

% Scheme electrice
[x,map]=imread('amp_clasaB.jpg');
[y,pam]=imread('amp_clasaAB.jpg');

% Interfata grafica
Fig=figure('Name','Laborator Grafica',...
 'Units','normalized',...
 'Position',[0.2 0.2 0.6 0.4],...
 'NumberTitle','off','color','#FFE4BF');
f=uimenu('Label','Amplificatoare de putere. Clasa B si Clasa AB');

% Grupuri cu date
DateIntrareGroup=uibuttongroup('Visible','on',...
 'BackgroundColor','#FFE4BF',...
 'ForegroundColor','black',...
 'Title','Date intrare:',...
 'FontSize',10,...
 'TitlePosition','centertop',...
 'Tag','radiobutton',...
 'Position',[0.02 0.45 0.25 0.5]); 
DateIesireGroup=uibuttongroup('Visible','on',...
 'BackgroundColor','#FFE4BF',...
 'ForegroundColor','black',...
 'Title','Date iesire:',...
 'FontSize',10,...
 'TitlePosition','centertop',...
 'Tag','radiobutton',...
 'Position',[0.3 0.45 0.25 0.5]);

% Puterea de iesire
Po_text=uicontrol('Style','text',...
'Units','normalized',...
'Position',[0.2 0.85 0.1 0.1],...
'backgroundcolor','#FFE4BF',...
'String','Po = ',...
'Parent',DateIesireGroup);

Po_value=uicontrol('Style','text',...
'Units','normalized',...
'Position',[0.4 0.85 0.3 0.1],...
'backgroundcolor','#FFE4BF',...
'String',num2str(Po),...
'Callback','',...
'Parent',DateIesireGroup);

% Puterea de pe tranzistori
PT_text=uicontrol('Style','text',...
'Units','normalized',...
'Position',[0.2 0.7 0.1 0.1],...
'backgroundcolor','#FFE4BF',...
'String','PT = ',...
'Parent',DateIesireGroup);

PT_value=uicontrol('Style','text',...
'Units','normalized',...
'Position',[0.4 0.7 0.3 0.1],...
'backgroundcolor','#FFE4BF',...
'String',num2str(PT),...
'Callback','',...
'Parent',DateIesireGroup);

% Puterea de pe rezistenta
PR_text=uicontrol('Style','text',...
'Units','normalized',...
'Position',[0.2 0.4 0.1 0.1],...
'backgroundcolor','#FFE4BF',...
'String','PR = ',...
'Parent',DateIesireGroup);

PR_value=uicontrol('Style','text',...
'Units','normalized',...
'Position',[0.4 0.4 0.3 0.1],...
'backgroundcolor','#FFE4BF',...
'String',num2str(PR),...
'Callback','',...
'Parent',DateIesireGroup);

% Puterea totala disipata de circuit
Ptot_text=uicontrol('Style','text',...
'Units','normalized',...
'Position',[0.16 0.55 0.15 0.1],...
'backgroundcolor','#FFE4BF',...
'String','Ptot = ',...
'Parent',DateIesireGroup);

Ptot_value=uicontrol('Style','text',...
'Units','normalized',...
'Position',[0.4 0.55 0.3 0.1],...
'backgroundcolor','#FFE4BF',...
'String',num2str(Ptot),...
'Callback','',...
'Parent',DateIesireGroup);

% Curentul prin dioda
Id_text=uicontrol('Style','text',...
'Units','normalized',...
'Position',[0.2 0.25 0.1 0.1],...
'backgroundcolor','#FFE4BF',...
'String','Id = ',...
'Parent',DateIesireGroup);

Id_value=uicontrol('Style','text',...
'Units','normalized',...
'Position',[0.4 0.25 0.3 0.1],...
'backgroundcolor','#FFE4BF',...
'String',num2str(Id),...
'Callback','',...
'Parent',DateIesireGroup);

% Puterea de pe dioda
Pd_text=uicontrol('Style','text',...
'Units','normalized',...
'Position',[0.2 0.1 0.1 0.1],...
'backgroundcolor','#FFE4BF',...
'String','Pd = ',...
'Parent',DateIesireGroup);

Pd_value=uicontrol('Style','text',...
'Units','normalized',...
'Position',[0.4 0.1 0.3 0.1],...
'backgroundcolor','#FFE4BF',...
'String',num2str(Pd),...
'Callback','',...
'Parent',DateIesireGroup);

% Alegerea intervalului pentru rezistente
uicontrol('Style','PopupMenu',...
'Units','normalized',...
'Position',[0.05 0.4 0.3 0.07],...
'String', '1-10|10-100|100-1K|1K-10K|10K-100K|100K-1M|1M-10M',...
'Value', 1,...
'Callback','valoriR=(get(gco,''Value'')); alege_rezistente(valoriR, Rezistente);',...
'Parent',DateIntrareGroup);

% Alegerea intervalului pentru rezistente
Rezistente=uicontrol('Style','PopupMenu',...
'Units','normalized',...
'Position',[0.05 0.2 0.2 0.07],...
'String','1|1.01|1.02|1.04|1.05|1.06|1.07|1.09|1.10|1.11|1.13|1.14|1.15|1.17|1.18|1.20|1.21|1.23|1.24|1.26|1.27|1.29|1.30|1.32|1.33|1.35|1.37|1.38|1.40|1.42|1.43|1.45|1.47|1.49|1.50|1.52|1.54|1.56|1.58|1.60|1.62|1.64|1.65|1.67|1.69|1.72|1.74|1.76|1.78|1.80|1.82|1.84|1.87|1.89|1.91|1.93|1.96|1.98|2|2.03|2.05|2.08|2.10|2.13|2.15|2.18|2.20|2.21|2.23|2.26|2.29|2.32|2.34|2.37|2.40|2.43|2.46|2.49|2.52|2.55|2.58|2.61|2.64|2.67|2.70|2.71|2.74|2.77|2.80|2.84|2.87|2.91|2.94|2.98|3|3.01|3.05|3.09|3.12|3.16|3.20|3.24|3.28|3.30|3.32|3.36|3.40|3.44|3.48|3.52|3.57|3.60|3.61|3.65|3.70|3.74|3.79|3.83|3.88|3.90|3.92|3.97|4.02|4.07|4.12|4.17|4.22|4.27|4.30|4.32|4.37|4.42|4.48|4.53|4.59|4.64|4.70|4.75|4.81|4.87|4.93|4.99|5.05|5.10|5.11|5.17|5.23|5.30|5.36|5.42|5.49|5.56|5.60|5.62|5.69|5.76|5.83|5.90|5.97|6.04|6.12|6.19|6.20|6.26|6.34|6.42|6.49|6.57|6.65|6.73|6.80|6.81|6.90|6.98|7.06|7.15|7.23|7.32|7.41|7.50|7.59|7.68|7.77|7.87|7.96|8.06|8.16|8.20|8.25|8.35|8.45|8.56|8.66|8.76|8.87|8.98|9.09|9.10|9.20|9.31|9.42|9.53|9.65|9.76|9.88|',...
'Value', 1,...
'Callback','R=(get(gco,''Value'')); R = valoriRezistente{R, valoriR};',...
'Parent',DateIntrareGroup);


checkR=uicontrol('Style','Checkbox',...
 'Units','normalized',...
 'String','R',...
 'BackgroundColor','#FFE4BF',...
 'Position', [0.05 0.05 0.2 0.07],...
 'Callback','set_value_rezistenta_R(get(gco,''Value''), R, R_AB_value);calcul(tipSemnal, tipCircuit, aSemnal, fSemnal, valoriRezistente, RL, R, R_AB_value, Np, Vcc, Id, Id_text, Id_value, Po, Po_text, Po_value, PT, PT_text, PT_value, Pd, Pd_text, Pd_value, PR, PR_text, PR_value, Ptot, Ptot_text, Ptot_value);',...
 'Parent',DateIntrareGroup);
checkRL= uicontrol('Style','Checkbox',...
 'Units','normalized',...
 'String','RL',...
 'BackgroundColor','#FFE4BF',...
 'Position', [0.3 0.05 0.2 0.07],...
 'Callback', 'set_value_rezistenta_RL(get(gco,''Value''), R, RL_value);calcul(tipSemnal, tipCircuit, aSemnal, fSemnal, valoriRezistente, RL, R, R_AB_value, Np, Vcc, Id, Id_text, Id_value, Po, Po_text, Po_value, PT, PT_text, PT_value, Pd, Pd_text, Pd_value, PR, PR_text, PR_value, Ptot, Ptot_text, Ptot_value);',...
 'Parent',DateIntrareGroup);


% Rezistenta de sarcina
RL_text=uicontrol('Style','text',...
'Units','normalized',...
'Position',[0.55 0.3 0.1 0.07],...
'backgroundcolor','#FFE4BF',...
'String','RL =',...
'Parent',DateIntrareGroup);
RL_value=uicontrol('Style','edit',...
'Units','normalized',...
'Position',[0.65 0.3 0.2 0.1],...
'foregroundcolor','black',...
'String',num2str(RL),...
'Callback','RL=str2num(get(gco,''String''));calcul(tipSemnal, tipCircuit, aSemnal, fSemnal, valoriRezistente, RL, R, R_AB_value, Np, Vcc, Id, Id_text, Id_value, Po, Po_text, Po_value, PT, PT_text, PT_value, Pd, Pd_text, Pd_value, PR, PR_text, PR_value, Ptot, Ptot_text, Ptot_value);',...
'Parent',DateIntrareGroup);


% Rezistenta pentru circuitul de amplificare in clasa AB
R_AB_text=uicontrol('Style','text',...
'Units','normalized',...
'Position',[0.55 0.1 0.1 0.07],...
'backgroundcolor','#FFE4BF',...
'Visible','on',...
'String','R =',...
'Parent',DateIntrareGroup);
R_AB_value=uicontrol('Style','edit',...
'Units','normalized',...
'Position',[0.65 0.1 0.2 0.1],...
'foregroundcolor','black',...
'String',num2str(R),...
'Visible','on',...
'Callback','R=str2num(get(gco,''String''));calcul(tipSemnal, tipCircuit, aSemnal, fSemnal, valoriRezistente, RL, R, R_AB_value, Np, Vcc, Id, Id_text, Id_value, Po, Po_text, Po_value, PT, PT_text, PT_value, Pd, Pd_text, Pd_value, PR, PR_text, PR_value, Ptot, Ptot_text, Ptot_value);',...
'Parent',DateIntrareGroup);

 uimenu(f,'Label','Ecuatii','Separator','on', 'Callback', 'open(''ecuatii.htm'');');
 uimenu(f,'Label','Documentatie','Callback','open(''documentatie.htm'');',...
 'Separator','on');
 uimenu(f,'Label','Bibliografie','Callback','open(''bibliografie.htm'');');
 uimenu(f,'Label','Close','Callback','close',...
 'Separator','on','Accelerator','Q');

 interfata(tipSemnal, tipCircuit, aSemnal, fSemnal, valoriRezistente, RL, R, R_AB_text, R_AB_value, Np, Vcc, x, y, DateIntrareGroup, DateIesireGroup, Id, Id_text, Id_value, Po, Po_text, Po_value, PT, PT_text, PT_value, Pd, Pd_text, Pd_value, PR, PR_text, PR_value, Ptot, Ptot_text, Ptot_value);