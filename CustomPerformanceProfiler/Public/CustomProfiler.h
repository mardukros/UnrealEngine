#pragma once

#include "CoreMinimal.h"
#include "UObject/Object.h"
#include "CustomProfiler.generated.h"

USTRUCT(BlueprintType)
struct FPerformanceMetric
{
    GENERATED_BODY()

    UPROPERTY(BlueprintReadOnly, Category = "Performance")
    FString MetricName;

    UPROPERTY(BlueprintReadOnly, Category = "Performance")
    float Value;

    UPROPERTY(BlueprintReadOnly, Category = "Performance")
    FDateTime Timestamp;

    FPerformanceMetric()
        : Value(0.0f)
    {
        Timestamp = FDateTime::Now();
    }
};

UCLASS(BlueprintType, Blueprintable)
class CUSTOMPERFORMANCEPROFILER_API UCustomProfiler : public UObject
{
    GENERATED_BODY()

public:
    UCustomProfiler();

    UFUNCTION(BlueprintCallable, Category = "Performance Profiler")
    void StartProfiling(const FString& ProfilerName);

    UFUNCTION(BlueprintCallable, Category = "Performance Profiler")
    void EndProfiling(const FString& ProfilerName);

    UFUNCTION(BlueprintCallable, Category = "Performance Profiler")
    TArray<FPerformanceMetric> GetPerformanceMetrics() const;

    UFUNCTION(BlueprintCallable, Category = "Performance Profiler")
    void ClearMetrics();

protected:
    UPROPERTY()
    TMap<FString, double> StartTimes;

    UPROPERTY()
    TArray<FPerformanceMetric> Metrics;

    virtual void BeginDestroy() override;
};