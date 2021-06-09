%% BER estimation with and without convoultional coding 
SymbolPoint=1000;
x = randi([0,1],1,SymbolPoint); %generate 1000 point 
x=[x 00];
 coded_bits=myconvEncoder(x);


ebno=(5:50);% vector of Eb/No we can set it any thin we want
signal_num=1003;% how many symbol for each signal
Est_ber=zeros(size(ebno));% Estimated bit error rate intialize
Est_ber_withoutconvDecoding=zeros(size(ebno));
bitsPerSym=1;

 for i=1:length(ebno)
        errors_num=0;
        bits_num=0;
        errors_num_withoutconvDecoding=0;
        bits_num_withoutconvDecoding=0;
        % second calculate snr value from ebno from the below equation 
        
        while errors_num < 200 && bits_num < 1e7
               
              awgn_data=awgn(coded_bits,ebno(i),'measured');
              awgn_data_withoutconvDecoding=awgn(x,ebno(i),'measured');
              retrived=[];
                for j=1:length(awgn_data)
                    if awgn_data(j)> 0 
                    retrived(j)=1;
                    else
                    retrived(j)=0;
                    end
                end
                 retrived2=[];
                for j=1:length(awgn_data_withoutconvDecoding)
                    if awgn_data_withoutconvDecoding(j)> 0 
                    retrived2(j)=1;
                    else
                    retrived2(j)=0;
                    end
                end
                
              
              decoded_bits=viterbi_Decoding(retrived);
              errors_num_temp=biterr(x,decoded_bits);%to calculate the number of different bits  and store errors_num_temp
            %increment the error number and bits number 
            errors_num_temp_withoutconvDecoding=biterr(x,retrived2);
            errors_num_withoutconvDecoding=errors_num_withoutconvDecoding+errors_num_temp_withoutconvDecoding;
            bits_num_withoutconvDecoding=bits_num_withoutconvDecoding+bitsPerSym*signal_num;
            errors_num=errors_num+errors_num_temp;
            bits_num=bits_num+bitsPerSym*signal_num;
        end
        Est_ber(i)=errors_num/bits_num;
        Est_ber_withoutconvDecoding(i)=errors_num_withoutconvDecoding/bits_num_withoutconvDecoding;
 end
 
semilogy(ebno,(Est_ber),'-ored') %estimated
hold on 
semilogy(ebno,(Est_ber_withoutconvDecoding),'--*blue')

legend('Estimated BER with convoutional encoding','Estimated BER without convoutional encoding ')
xlabel('snr (dB)')
ylabel('BER')
title('BER vs snr with and without channel correction');
hold off


