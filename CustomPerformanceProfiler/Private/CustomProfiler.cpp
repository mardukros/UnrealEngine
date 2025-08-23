#include "CustomProfiler.h"
#include "HAL/PlatformTime.h"
#include "Engine/Engine.h"

UCustomProfiler::UCustomProfiler()
{
    // Initialize the profiler
}

void UCustomProfiler::StartProfiling(const FString& ProfilerName)
{
    double CurrentTime = FPlatformTime::Seconds();
    StartTimes.Add(ProfilerName, CurrentTime);
    
    UE_LOG(LogTemp, Log, TEXT("Started profiling: %s at %f"), *ProfilerName, CurrentTime);
}

void UCustomProfiler::EndProfiling(const FString& ProfilerName)
{
    if (StartTimes.Contains(ProfilerName))
    {
        double StartTime = StartTimes[ProfilerName];
        double EndTime = FPlatformTime::Seconds();
        double Duration = (EndTime - StartTime) * 1000.0; // Convert to milliseconds
        
        FPerformanceMetric Metric;
        Metric.MetricName = ProfilerName;
        Metric.Value = Duration;
        Metric.Timestamp = FDateTime::Now();
        
        Metrics.Add(Metric);
        StartTimes.Remove(ProfilerName);
        
        UE_LOG(LogTemp, Log, TEXT("Profiling %s completed: %f ms"), *ProfilerName, Duration);
    }
}

TArray<FPerformanceMetric> UCustomProfiler::GetPerformanceMetrics() const
{
    return Metrics;
}

void UCustomProfiler::ClearMetrics()
{
    Metrics.Empty();
    StartTimes.Empty();
}

void UCustomProfiler::BeginDestroy()
{
    ClearMetrics();
    Super::BeginDestroy();
}