Subs_to_run = [ 1 2 5 6 7 8 9 10 13 14 15 16 17 19 20 22 23 24 26 27 28 29 30 31] % WORD EXP
for subID = Subs_to_run(2:end)
   individual_faces_multicond(subID)
   disp(['done: ' 'Sub:' num2str(subID) ' individual_faces_multicond'])
   func_SPM_LVL1(subID)
   disp(['done: ' 'Sub:' num2str(subID) ' func_SPM_LVL1'])
   func_individualContrasts(subID)
   disp(['done: ' 'Sub:' num2str(subID) ' func_individualContrasts'])
end
%%
