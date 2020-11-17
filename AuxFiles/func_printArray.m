function [] = func_printArray(array,spec)
n = length(array);
for i=1:n-1
   fprintf(spec + "\t",array(i));
end

fprintf(spec + "\n",array(n));

end