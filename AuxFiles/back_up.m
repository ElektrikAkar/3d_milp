function [] = back_up(file)
% This function renames the save file to create a back-up. Because
% sometimes when simulation is stopped during the saving, the save-file may
% be corrupted. Therefore, we copy the save file before creating a new one.
% 
% Author: VK
% Date  : 2020.07.31

[filepath,name,ext] = fileparts(file);

old_file = fullfile(filepath, name+"_old"+ext);

if(exist(file,'file')==2)
  %  delete(old_file);
   if(movefile(file, old_file))
      fprintf('Save file back-up is successfully completed.\n'); 
   else
      fprintf('There is a problem with the back-up.\n');
   end
end

end