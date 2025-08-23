#include "CustomProfilerLibrary.h"
#include "Engine/Engine.h"

UCustomProfiler* UCustomProfilerLibrary::GetCustomProfiler()
{
    static UCustomProfiler* Profiler = nullptr;
    if (!Profiler)
    {
        Profiler = NewObject<UCustomProfiler>();
        Profiler->AddToRoot(); // Keep it alive
    }
    return Profiler;
}

void UCustomProfilerLibrary::ProfileFunction(const FString& FunctionName, const FString& ProfilerName)
{
    if (UCustomProfiler* Profiler = GetCustomProfiler())
    {
        Profiler->StartProfiling(ProfilerName);
    }
}

void UCustomProfilerLibrary::EndProfileFunction(const FString& ProfilerName)
{
    if (UCustomProfiler* Profiler = GetCustomProfiler())
    {
        Profiler->EndProfiling(ProfilerName);
    }
}