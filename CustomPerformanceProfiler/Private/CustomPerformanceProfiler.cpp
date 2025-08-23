#include "CustomPerformanceProfiler.h"
#include "Modules/ModuleManager.h"
#include "CustomProfiler.h"

IMPLEMENT_MODULE(FDefaultModuleImpl, CustomPerformanceProfiler);

void FCustomPerformanceProfilerModule::StartupModule()
{
    UE_LOG(LogTemp, Log, TEXT("Custom Performance Profiler Module Started - Advanced Profiling System Ready"));
}

void FCustomPerformanceProfilerModule::ShutdownModule()
{
    UE_LOG(LogTemp, Log, TEXT("Custom Performance Profiler Module Shutdown"));
}