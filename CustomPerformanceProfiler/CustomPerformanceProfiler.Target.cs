using UnrealBuildTool;
using System.Collections.Generic;

public class CustomPerformanceProfilerTarget : TargetRules
{
    public CustomPerformanceProfilerTarget(TargetInfo Target) : base(Target)
    {
        Type = TargetType.Game;
        DefaultBuildSettings = BuildSettingsVersion.V2;
        IncludeOrderVersion = EngineIncludeOrderVersion.Unreal5_1;
        ExtraModuleNames.Add("CustomPerformanceProfiler");
    }
}