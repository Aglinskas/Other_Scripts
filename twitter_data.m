%% Addpaths
addpath('/Users/aidasaglinskas/Documents/MATLAB/twitty_1.1.1/')
addpath('/Users/aidasaglinskas/Documents/MATLAB/parse_json/')
addpath('/Users/aidasaglinskas/Documents/MATLAB/jsonlab-1.5/')
creds = struct('ConsumerKey','I8v05f0hB3KwLpvGhqNpkU3L0',...
    'ConsumerSecret','7AuFb422XGm2HpvjEmYwXmW53CrTNC5UCGXhiQMdZEP0LF38z2',...
    'AccessToken','334002162-orP1Wi9E8cyk2k0TuNVsLDnVvOmwMuTRAx3q2vYm',...
    'AccessTokenSecret','B6f45CN1XD2o8iUNgYhCThmYkrt1gwOGtcTKfADvfdL4L');
tw = twitty(creds); 
tw.jsonParser = @loadjson;
%%
clc
slCharacterEncoding('UTF-8');
T = struct;
l = 0;
query = 'Julia Roberts';
disp('getting tweets');
source = tw.search(query,'count',100,'include_entities','true','lang','en');
tweets = source{1}.statuses;
disp('processing tweets')
for i = 1:length(tweets)
line = tweets{i};
l = l+1;
% Add text
T(l).text = line.text;
T(l).tweet_link = sprintf('https://twitter.com/%s/status/%s',line.user.screen_name,line.id_str);
T(l).raw_text = line.text;
T(l).time = line.created_at;
T(l).author = line.user.screen_name;
T(l).query = query;
T(l).mentions = [];

    % process text
% Remove retweet;
if strcmp(T(l).raw_text(1:2),'RT')
col = strfind(T(l).raw_text,':'); col = col(1);
T(l).isRT = 1;
T(l).text = T(l).raw_text(col+2:end);
else 
    T(l).isRT = 0;
end % ends RT if 
% % remove mentions 1 
% for um = 1:length(line.entities.user_mentions)
% T(l).text = strrep(T(l).text,['@' line.entities.user_mentions{um}.screen_name],'');
% T(l).mentions{um} = line.entities.user_mentions{um}.screen_name;
% end
% remove mentions
expr = '@\S*';
h = regexp(line.text,expr,'match');
if isempty(h)
    T(l).mentions = [];
else
    %T(l).ishashtag = 1;
for h_ind = 1:length(h)
    T(l).mentions{h_ind} = h{h_ind};
    T(l).text = strrep(T(l).text,h{h_ind},'');
end
end
%%

    % Find links
    expr = 'http\S*';
    lnks = regexp(line.text,expr,'match');
    if isempty(lnks)
        T(l).is_link = 0;
    else
        T(l).is_link = 1;
    for ll = 1:length(lnks)
        T(l).link{ll} = lnks{ll};
        T(l).text = strrep(T(l).text,lnks{ll},'');
    end
    end
    
% Remove unicode crap
expr = '\\u\S*';
uc = regexp(T(l).text,expr,'match');
for u = 1:length(uc)
    T(l).text = strrep(T(l).text,uc{u},'');
    T(l).unicode_chars{u} = uc{u};
end


%Hashtags 

expr = '#\S*';
h = regexp(line.text,expr,'match');
if isempty(h)
    T(l).ishashtag = 0;
else
    T(l).ishashtag = 1;
for h_ind = 1:length(h)
    T(l).hashtag{h_ind} = h{h_ind};
    T(l).text = strrep(T(l).text,h{h_ind},'');
end
end
%%
end % ends tweet loop
disp('all done')
TT = T(find(~[T.is_link] & ~[T.isRT] & ~[T.ishashtag]));
disp(sprintf('%d Unique tweets, %d opinions/posts',length(unique({T.text})),length(TT)))

