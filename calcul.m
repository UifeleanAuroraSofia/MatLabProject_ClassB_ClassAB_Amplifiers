function calcul(tipSemnal, tipCircuit, aSemnal, fSemnal, valoriRezistente, RL, R, R_AB_value, Np, Vcc, Id, Id_text, Id_value, Po, Po_text, Po_value, PT, PT_text, PT_value, Pd, Pd_text, Pd_value, PR, PR_text, PR_value, Ptot, Ptot_text, Ptot_value)

T = 1/fSemnal %calculam perioada semnalelor
t=0:T/50:Np*T; %alegem un interval de timp de reprezentare

switch tipSemnal
    case 1
        vSemnal = aSemnal * sin(2*pi*fSemnal*t);
    case 2
        vSemnal = aSemnal * sawtooth(2*pi*fSemnal*t, 0.5); %generare de semnal triunghiular
    case 3
        vSemnal = aSemnal * sawtooth(2*pi*fSemnal*t, 0); %generare de semnal dinte de fierastrau
end % avem end nu ca si in C

subplot(333);
semmalIntrare = plot(t, vSemnal,'b','DisplayName','Vin');
hold on;
grid on;
voutSemnal = vSemnal;


if tipCircuit == 1
    if aSemnal >= Vcc
        for index = 1: length(t)
            if voutSemnal(index) >= 0 && voutSemnal(index) >= Vcc
                voutSemnal(index) = Vcc;
            elseif voutSemnal(index) <= -Vcc
                voutSemnal(index) = -Vcc;
            end
        end
    end
    for index = 1: length(t)
        if voutSemnal(index) >= 0 && voutSemnal(index) >= 0.7
            voutSemnal(index) = voutSemnal(index) - 0.7;
        elseif voutSemnal(index) <= -0.7
            voutSemnal(index) = voutSemnal(index) + 0.7;
        elseif voutSemnal(index) >= -0.7 && voutSemnal(index) <= 0.7
            voutSemnal(index) = 0;
        end
    end
else
    for index = 1: length(t)
        if voutSemnal(index) >= 0 && voutSemnal(index) > Vcc - 1.4
            voutSemnal(index) = Vcc - 1.4;
        elseif voutSemnal(index) < -Vcc + 1.4
            voutSemnal(index) = -Vcc + 1.4;
        end
    end
end

ioutSemnal = voutSemnal;
for index = 1: length(t)
    ioutSemnal(index) = voutSemnal(index) / RL;
end

semnalIesire = plot(t, voutSemnal,'r','DisplayName','Vout');
title('Vin/Vout');
hold off

subplot(336);
CSTV = plot(vSemnal, voutSemnal,'g','DisplayName','CSTV');
title('CSTV');
hold on;
grid on;
hold off;
subplot(339);
CSTV = plot(t, ioutSemnal,'m','DisplayName','Iout');
title('Iout');
hold on;
grid on;
hold off;


% curentul prin dioda
Id = (Vcc - 0.7) / R;
set(Id_value, 'String', Id);

% putere de iesire
Po = (aSemnal * aSemnal) / (2 * RL)
set(Po_value, 'String', Po);

% putere de pe tranzistor
PT = ((Vcc * aSemnal) / (pi * RL)) - ((aSemnal * aSemnal) / (4 * RL));
set(PT_value, 'String', PT);

% putere de pe dioda
Pd = 0.7 * Id;
set(Pd_value, 'String', Pd);

% putere de pe rezistenta
PR = R * Id;
set(PR_value, 'String', PR);

% putere totala
if (tipCircuit == 2)
    Ptot = Po + PT + Pd + PR;
else
    Ptot = Po + PT;
end
set(Ptot_value, 'String', Ptot);

end