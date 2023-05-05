function logGaussian = computeLogGauss(word_feat, hmmM, hmmV, hmmC, f, s)
% spocita log. vystupni pravdep. pro dany frame a dany stav daneho modelu
% odvozeni vztahu je v prednasce
%  misto XXX doplnte vypocet
    feat_vector = word_feat(f,:); % priznakovy vector v danem framu slova
    mean_vector = hmmM(s,:);   % vektor strednich hodnot vsech priznaku v danem stavu
    sigma_vector = hmmV(s,:);  % vektor rozptylu (sigma^2)vsech priznaku v danem stavu
    const_value = hmmC(s);     % log. hodnota konstanty v danem stavu
    logGaussian = XXX;
    
end