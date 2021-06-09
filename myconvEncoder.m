function coded=myconvEncoder(bits)
g1=[1 1 1];
g2=[1 0 1];
g3=[1 1 0];
statee=[1 1];
coded=[];
for i=1:length(bits)
    
    selectfromBits=bits(i);
    up1=g1(1)*selectfromBits; 
    up2=xor(up1,g1(2)*statee(1));
    p1=xor(up2,g1(3)*statee(2));
    down1=selectfromBits*g2(1);
    p2=xor(down1,g2(3)*statee(2));
    p3=xor(selectfromBits*g3(1),statee(1)*g3(2));
    statee(1)=selectfromBits;
    if i>=2
        statee(2)= bits(i-1);
    end
    coded=[coded p1 p2 p3];
    
end
end