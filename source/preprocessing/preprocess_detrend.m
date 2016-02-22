function signalOut = preprocess_detrend(signalIn)
% Does a quadratic detrending on the input signal. 
% It handles automatically the multiple records case.

    m = size(signalIn,1);

    signalOut = zeros(size(signalIn));   
    for r = 1:size(signalIn,3)

        %M = [ones(size(signalIn,2),1) ((0:(size(signalIn,2)-1)))' (((0:(size(signalIn,2)-1))).^2)'];
        M = [ones(size(signalIn,2),1) ((0:(size(signalIn,2)-1)))'];
        y = signalIn(:,:,r)';
        a = M\y;

        for c = 1:m
            Y = a(1,c)*[ones(1,size(signalIn,2))]+a(2,c)*[0:(size(signalIn,2)-1)];
            signalOut(c,:,r) = signalIn(c,:,r) - Y;
        end

    end

end