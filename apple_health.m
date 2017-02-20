clear 
fn = '/Users/aidasaglinskas/Google Drive/apple_health_export/export.xml';
a = xml2struct(fn);
%%
b = {a.Children};
b = b{2}
records = find(cellfun(@(x) strcmp(x,'Record'),{b.Name}'));
b = b(records);

for i = 1:length(b)
   'HKQuantityTypeIdentifierHeartRate' 
end