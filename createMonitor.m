function mon = createMonitor
   MatlabProcess = system.Diagnostics.Process.GetCurrentProcess(); % "Matlab" process
   cpuIdleProcess = 'Idle' ;
   mon.NumOfCPU = double(system.Environment.ProcessorCount);
   mon.ProcPerfCounter.Matlab  = system.Diagnostics.PerformanceCounter('Process', '% Processor Time', MatlabProcess.ProcessName );
   mon.ProcPerfCounter.cpuIdle = system.Diagnostics.PerformanceCounter('Process', '% Processor Time', cpuIdleProcess );
end