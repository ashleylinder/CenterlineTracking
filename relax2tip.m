function K = relax2tip(P, tips, kappa, Fline, gamma, B, nPoints, ConCrit, cd, mu)

Pdiff = 20;
while Pdiff > ConCrit
    Pold = P;
    P(1,:) = tips(1,:);
    P(100,:) = tips(2,:);
    
    Frepel = repel(P, cd, mu);
    
    Fext = zeros(100,2);
    %get image forces (line only) on the contour
    Fext(2:99,1) = kappa*(interp2(Fline(:,:,1),P(2:99,2),P(2:99,1)));                
    Fext(2:99,2) = kappa*(interp2(Fline(:,:,2),P(2:99,2),P(2:99,1)));
   
                    
     %Update contour with image forces
    ssx = gamma*P(:,1) - Fext(:,1) + Frepel(:,1);
    ssy = gamma*P(:,2) - Fext(:,2) + Frepel(:,2);
    %Semi-implicit relaxtion
    P(:,1) = B*ssx;
    P(:,2) = B*ssy;            
    dis=[0;cumsum(sqrt(sum((P(2:end,:)-P(1:end-1,:)).^2,2)))];
    % Resample to make uniform points
    J(:,1) = interp1(dis,P(:,1),linspace(0,dis(end),nPoints));
    J(:,2) = interp1(dis,P(:,2),linspace(0,dis(end),nPoints));
    P = J;
     Pdis = (Pold - J).^2;
    Pdiff = (sum(sqrt(Pdis(2:99,1)+Pdis(2:99,2))))/nPoints;
end

dis=[0;cumsum(sqrt(sum((P(2:end,:)-P(1:end-1,:)).^2,2)))];
% Resample to make uniform points
K(:,1) = interp1(dis,P(:,1),linspace(0,dis(end),nPoints));
K(:,2) = interp1(dis,P(:,2),linspace(0,dis(end),nPoints));

end