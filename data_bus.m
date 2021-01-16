c=input('enter the name of data file: ','s');
a=fopen(c,'rt');
while 1
    dataofline=fgetl(a);
    if dataofline(1:16)=='BUS DATA FOLLOWS'
        break
    end
end
x=0;
while 1
    dataofline=fgetl(a);
    if dataofline(1:4)=='-999'
        break
    end
    x=x+1;
    shuntconductance(x)=str2num(dataofline(107:114));%shunt conductance per unit
    shuntsusceptance(x)=str2num(dataofline(115:122));%shunt susceptance per unit
end
while 1
    dataofline=fgetl(a);
    if dataofline(1:19)=='BRANCH DATA FOLLOWS'
        break
    end
end
y=0;
while 1
    dataofline=fgetl(a);
    if dataofline(1:4)=='-999'
        break
    end
    y=y+1;
    Resistance(y)=str2num(dataofline(20:29));%resistance
    Reactance(y)=str2num(dataofline(30:40));%reactance
    LineCharging(y)=str2num(dataofline(41:50));%line charging current
    FromBus(y)=str2num(dataofline(1:5));
    ToBus(y)=str2num(dataofline(5:10));
end
 
for a=1:y
    Impedance(a)=Resistance(a)+i*Reactance(a);
    Admittance(a)=1./Impedance(a);
end
Ybus=zeros(x,x);
for a=1:x
    Ybus(a,a)=shuntconductance(a)+i*shuntsusceptance(a);
end
for p=1:y
    Ybus(FromBus(p),ToBus(p))=Ybus(FromBus(p),ToBus(p))-Admittance(p);
    Ybus(ToBus(p),FromBus(p))=Ybus(ToBus(p),FromBus(p))-Admittance(p);
    Ybus(FromBus(p),FromBus(p))=Ybus(FromBus(p),FromBus(p))+Admittance(p)+i*LineCharging(p)/2;
    Ybus(ToBus(p),ToBus(p))=Ybus(ToBus(p),ToBus(p))+Admittance(p)+i*LineCharging(p)/2;
end
sparse(Ybus)
