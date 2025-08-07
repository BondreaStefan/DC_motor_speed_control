% Date initiale motor si sarcina:
R = 10; %[ohm] - rezistenta rotorului
L = 1e-3; %[H] - inductivitatea rotorului
k = 0.05; %[Nm/A] - constanta de cuplu a motorului
J = 5e-7; %[kg*m^2] - momentul de inertie totala(motor + sarcina)

% Date initiale regulator PI analogic:
Ui = 10; %[V] - plaja tensiunii de referinta si feedback(+/-) 
Ue = 10; %[V] - plaja tensiunii de iesire/comanda(+/-)
Ueps = 10; %[V] - plaja tensiunii de eroare(+/-)

% Date initiale amplificator de putere:
Uin = Ue; %[V] - plaja tensiunii de intrare = iesirea din regulator
U = 24; %[V] - plaja tensiunii maxime aplicate pe motor(+/-)

% Date initiale tahogenerator:
K_TG = 4; %[V/1000rpm] - constanta tahogeneratorului

% Calcul parametrii:
tau_el = L / R; %[s] - constanta electrica a motorului
tau_em = J*R / k^2; %[s] - constanta electromecanica a motorului
omg_max = U / k; %[rad/s] - viteza(unghiulara) maxima a motorului
K_A = U / Uin; %[-] - constanta amplificatorului de tensiune
Ktg = K_TG*60 / (2*pi*1000); %[V/rad/s] - constanta tahogen. in SI
Komg = Ui / (omg_max*Ktg); %[-] - constanta de atenuare a vitezei masurate

% Functia de transfer reala a motorului de comanda la viteza(ord II)
num = 1 / k;
den = [tau_el*tau_em tau_em 1];

% Functia de transfer reala a motorului de comanda la viteza(ord I)
num1 = 1 / k;
den1 = [tau_em 1];

% Functia de transfer vazuta de regulator de forma: H(s) = b/s + a
Kech = K_A * 1/k * Ktg * Komg * Ueps/(Ui + Ue);
b = Kech / tau_em;
a = 1 / tau_em;

% Acordare regulator PI analogic:
w = 500; %[rad/s] - pulsatia naturala dorita w = 1/tau_em
tzeta = 0.707; %[-] - factorul de amortizare
Kp = (2*tzeta*w - a) / b;
Ki = w^2/b;

%copy