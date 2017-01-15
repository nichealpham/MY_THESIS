function [vec lead sf] = readFDAECGXML(filename);
% [vec lead sf] = readFDAECGXML(filename);
% 
% Reads FDA XML ECG data. 
% vec is a matrix containing all the ECG leads
% lead is a set of strings describing the leads (same dim as vec)
% sf{1} is the sampling interval (1/sampling freq) - hopefully.
%
% Try plotting the data with:
% for(i=1:length(lead));plot(vec2a(:,i));title(['lead ' lead{i}]);pause;end
%
% Written by G. Clifford gari@ieee.org and made available under the 
% GNU general public license. If you have not received a copy of this 
% license, please download a copy from http://www.gnu.org/
%
% You may note that this license doesn't warrant this code for any
% reason whatsoever. This function is just a hack to allow you to
% read in FDA XML formatted data (I hope). Actually it's only been
% tested on one manufacturer's implementation of this format, so odds
% are it will fail on others. Please treat this code with extreme 
% caution
%
% Please distribute (and modify) freely, commenting
% where you have added modifications. 
% The author would appreciate correspondence regarding
% corrections, modifications, improvements etc.
%
% (C) G. D. Clifford 2005 gari at mit dot edu
% Last modified March 22 2008.

[data] = textread(filename,'%s');

j=0; k=1; read_flag=0;
for(i=2:length(data))
    tmp1=data{i-1}; % put last item in a temp var
    tmp=data{i}; % put latest item in a temp var
    %(we have to do this, because we are using white space
    % as the delimeter and hence some 'words' are not unique
    % - and we have to check word pairs)
    
    % check for lead type
    if(strcmp(tmp1(1:min(18,length(tmp1))),'code="MDC_ECG_LEAD')==1);
        lead{j+1}=tmp1(min(20,length(tmp1)-1):length(tmp1)-1);
    end
    
    % note that we used min(N,length(tmp1)) to deinfe the end 
    % index of the string - that's because we want to check N
    % characters into the word, but the word may be shorter than 
    % N, and hence throw an error
    
    % check for the word pair: '<increment value='
    if(strcmp(tmp(1:min(6,length(tmp))),'value=')==1);
        if(strcmp(tmp1(1:min(10,length(tmp1))),'<increment')==1);
            % the data we seek is between two double quotation marks
            a=find(tmp=='"');
            if(length(a)>1)
                sf{k}=tmp(a(1)+1:a(2)-1);
                k=k+1; % let's count how many times we find this
                % it's frequent, ... but all null except for the
                % first and last in my experience
            end
        end
    end
    
    if(strcmp(tmp1(1:min(8,length(tmp1))),'<digits>')==1);
       read_flag=1; 
       j=j+1; % increment ECG dimension
       k=1; % reset counter through the single lead
        if(length(tmp)>8) % catching when the <> abuts the data
         vec(j,k) = str2num(tmp(9:length(tmp1)));
         j=j+1;
        end
    end
    if(length(tmp)>8 & strcmp(tmp(length(tmp)-8:length(tmp)),'</digits>')==1);
        if(length(tmp)>9)
         vec(j,k) = str2num(tmp(1:length(tmp)-9));
        end
        read_flag=0; 
    end
    if read_flag==1 
       vec(j,k) = str2num(tmp);
       k=k+1;
    end
end

vec=vec';