function [score, path] = computeHMMViterbi_fast (word_feat, word_frames, model_id)
% vypocita skore slova (z jeho priznaku ve word_feat) pro model s indexem model_id
% a zaroven vrati nejlepsi cestu - tj. prirazeni framu ke stavum
 
    global hmmMeans;
    global hmmVars;
    global hmmTrans;
    global hmmConst;
    global num_HMM_states;
    
    m = model_id;
    big = 1E38; 
    path = zeros(word_frames, 1, 'int32');
    cum_score = zeros (word_frames, num_HMM_states) - big;
    back_matrix = zeros (word_frames, num_HMM_states, 'int32');
    
    num_features = size (hmmMeans,3);
    % nasledujici prevod 3-dim matic na 2-dim matice vyrazne zrychli vypocet
    % z puvodnich 3-d matic vyclenime 2-d matice odpovidajici danemu modelu
    hmmM = reshape (hmmMeans (model_id,:,:),[num_HMM_states,num_features]);
    hmmV = reshape (hmmVars (model_id,:,:),[num_HMM_states,num_features]);
    hmmT = reshape (hmmTrans (model_id,:,:),[num_HMM_states,2]);
    hmmC = hmmConst (model_id,:);
    
    cum_score(1,1) = computeLogGauss (word_feat, hmmM, hmmV, hmmC, 1, 1);   
    back_matrix (1,1) = 1;
    for f = 2:word_frames
        cum_score(f,1) =  cum_score(f-1,1) + hmmT(1,1) + computeLogGauss (word_feat, hmmM, hmmV, hmmC, f, 1);
        back_matrix (f,1) = 1;
        smax = min (f,num_HMM_states);        
        for s = 2 : smax  % jaky vyznam ma smax?
            temp = cum_score(f-1,s-1) + hmmT(s-1,2);  % toto je skore pri prechodu z predchoziho stavu
            from = s-1;
            temp2 = cum_score(f-1,s) + hmmT(s,1);     % a toto skore pri setrvani ve stavu
            if (temp < temp2)                         % vybereme z nich to vyssi
                temp = temp2;                        
                from = s;
            end
            cum_score(f,s) = temp + computeLogGauss (word_feat, hmmM, hmmV, hmmC, f, s); % a pricteme vyst. pr.
            back_matrix (f,s) = from;
        end
    end
    score = cum_score(word_frames,num_HMM_states);       % vysledne skore
    
    path(word_frames) = num_HMM_states;                  % zpetne trasovani cesty
    if back_matrix(end, end) < 10
        % disp('pod deset')
    end
    % XXX ... zde bude vas kod pro sestaveni cesty
    for i = word_frames-1:-1:1
        try
            path(i) = back_matrix(i, path(i+1));
        catch
            disp(cum_score)
            disp(back_matrix)
            disp(path)
            disp(i)
            disp(path(i+1))
            disp(model_id)
            error('Eror in backtracking')
        end
    end
    % path(1) = 1;

end
        
   