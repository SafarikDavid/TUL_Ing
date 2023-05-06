function ret = trainHMM (class_id, train_set, num_train, max_frames, max_iter)
% trenovani modelu jedne tridy na datech dane tridy z trenovaci sady

    % parametry slov
    global word_features   % 3-dim pole obsahujici priznaky vsech slov (slovo, frame, priznak]
    global word_frames     % 2-dim pole obsahujici pocty framu vsech slov (slovo, pocet_framu)
    global word_class      % 1-dim pole obsahujici informaci o tride slova (napr. 0 pro slovo "nula")
    
    % parametry slovnich modelu (HMM)
    global num_HMM_states  % pocet stavu - pro vsechny modely stejny
    global hmmTrans        % 3-dim pole obsahujici prechodove pravdepobnosti (model, stav, 2)
                           % v posledni dimezi: 1 - pravdepodobnost setrvani, 2 - pravd. prechodu do sous. stavu   
                           % pro urychleni vypoctu jsou tyto hodnoty uz zlogaritmovany
    global hmmMeans        % 3-dim pole obsahujici stredni hodnoty  (model, stav, priznak)
    global hmmVars         % 3-dim pole obsahujici rozptyly, tj. hodnoty sigma^2, (model, stav, priznak)
    global hmmConst        % 2-dim pole obsahujici predpocitane (zlogaritmovane) konstanty (model, stav)
    global hmmClass        % 1-dim pole obsahujici informace o tride modelu (napr. 0 pro slovo "nula")

    num_features = size (word_features,3);
    
    iter = 1;
        
    % z trenovaci sady vybereme nahravky slova z dane tridy 
    num_train_class = 0;
    for n = 1:num_train
        if (word_class(train_set(n)) == hmmClass(class_id))
            num_train_class = num_train_class + 1;
            train_class_set (num_train_class) = train_set(n);
        end
    end
    
    % alokace pro 2 dulezite pole promennych
    frame_to_state = zeros (num_train_class, max_frames); % namapovani framu na stavy
    % pro kazde trenovaci slovo a pro kazdy jeho frame udava cislo stavu, k nemuz je frame prirazen
    % napr. [1 1 1 2 2 3 3 3 3 4 4 ] rika, ze 11 framu slova je takto prirazeno ke 4-stavovemu modelu 
    
    num_frames_per_state = zeros (num_train_class, num_HMM_states); 
    % pro kazde tren. slovo je z pole frame_to_state spocitan pocet framu prirazenych ke kazdemu stavu
    % takze napø. pro vyse uvedene slovo by to bylo [3 2 4 2]
    
    % nejprve zacneme rovnomernym prirazenim framu ke stavum
    for n = 1:num_train_class
        [num_fps, fts] = splitFramesToStates (word_frames(train_class_set(n)), num_HMM_states);
        num_frames_per_state(n,:) = num_fps;
        frame_to_state (n,1:word_frames( train_class_set(n))) = fts;
    end
  
    % smycka pro jednotlive iterace
    while (iter <= max_iter)
        total_frames_per_state = sum (num_frames_per_state);  % celkovy pocet framu na stav
        max_frames_in_state = max (total_frames_per_state);   % max pocet framu ze vsech stavu

        % zapiseme priznakove vektory do pomocne matice podle stavu
        feature_vectors_in_state = zeros (num_HMM_states, max_frames_in_state, num_features);
        count (1:num_HMM_states) = 1;
        for n = 1:num_train_class
            for f = 1:word_frames(train_class_set(n))
                s = frame_to_state (n,f);
                feature_vectors_in_state(s, count(s),:) = word_features(train_class_set(n),f,:);
                count (s) = count (s) + 1;
            end
        end
        
        % vypocet parametru HMM pro vsechny stavy lze ted provest jednoduse standardnimi funkcemi
        for s = 1:num_HMM_states 
            hmmMeans(class_id,s,:) = mean (feature_vectors_in_state (s,1:total_frames_per_state(s),:));
            hmmVars(class_id,s,:) = var (feature_vectors_in_state (s,1:total_frames_per_state(s),:));
            hmmTrans(class_id,s,2) = num_train_class /total_frames_per_state(s);
            hmmTrans(class_id,s,1) = 1 - hmmTrans(class_id,s,2);
            temp = hmmVars(class_id,s,:) * 2 * pi;
            det = prod (temp);
            hmmConst(class_id,s) = log (1 / sqrt (det)); % predpocitan logaritmus konst. clenu
        end
        hmmTrans(class_id,:,:) = log (hmmTrans(class_id,:,:));  % zlogaritmovane vsechny prech. pravdepodobnosti
                        
        % zde provadime vypocet pravdepodobnosti trenovacich slov s aktualni iteraci modelu 
        % cilem je najit nove (verime ze lepsi) prirazeni framu ke stavum
        if (max_iter > 1)  % proved jen kdyz je pozadovano vice iteraci
            % se vsemi slovy z tren. sady provedeme rozpoznani s cilem najit nejlepsi cestu
            for n = 1:num_train_class
                nn = train_class_set (n);
                word_feat = reshape (word_features (nn,:,:),[max_frames,num_features]);
                [scr(n), path] = computeHMMViterbi_fast (word_feat, word_frames (nn), class_id);
                frame_to_state (n,1:word_frames(nn)) = path;  % mame prirazeni framu ke stavum
                for s = 1:num_HMM_states
                    num_frames_per_state(n,s) = sum(path==s); % urcime jeste pocet framu ve stavech
                end
            end
            total_score = sum(scr); % toto skore by melo s kazdou iteraci rust (nechte si vypisovat)
            fprintf("%e\n", total_score)
        end
        iter = iter + 1;
    end
    ret = iter;
end

   
 function [num_frames_per_state, frame_to_state] = splitFramesToStates (num_frames, num_HMM_states)
% rozdeli framy kvazirovnomerne do stavu (pokud nelze rozdelit stejne, tak nektere stavy budou mit 1 vice)   
    num_frames_per_state (1:num_HMM_states)=  floor (num_frames/num_HMM_states);
    for s = 1: rem (num_frames, num_HMM_states)
        num_frames_per_state(s) = num_frames_per_state(s) + 1;
    end
    % frame_to_state = ones(1,num_frames_per_state(1));
    % XXX - zde vlozte kratky kod (1 cyklus), kterym stanovite hodnoty  frame_to_state
    frame_to_state = [];
    for i = 1:length(num_frames_per_state)
        frame_to_state = [frame_to_state ones(1, num_frames_per_state(i))*i];
    end
    
end






