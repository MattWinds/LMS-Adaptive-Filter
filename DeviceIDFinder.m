inputs = audiodevinfo().input;

for i = 1:length(inputs)
    fprintf('Device %d:\n', i);
    fprintf('  ID: %d\n', inputs(i).ID);
    fprintf('  Name: %s\n', inputs(i).Name);
    fprintf('  Driver: %s\n\n', inputs(i).DriverVersion);
end