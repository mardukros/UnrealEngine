#pragma once

#include "CoreMinimal.h"
#include "Kismet/BlueprintFunctionLibrary.h"
#include "CustomProfiler.h"
#include "CustomProfilerLibrary.generated.h"

UCLASS()
class CUSTOMPERFORMANCEPROFILER_API UCustomProfilerLibrary : public UBlueprintFunctionLibrary
{
    GENERATED_BODY()

public:
    UFUNCTION(BlueprintCallable, Category = "Performance Profiler", CallInEditor = true)
    static UCustomProfiler* GetCustomProfiler();

    UFUNCTION(BlueprintCallable, Category = "Performance Profiler", CallInEditor = true)
    static void ProfileFunction(const FString& FunctionName, const FString& ProfilerName);

    UFUNCTION(BlueprintCallable, Category = "Performance Profiler", CallInEditor = true)
    static void EndProfileFunction(const FString& ProfilerName);
};