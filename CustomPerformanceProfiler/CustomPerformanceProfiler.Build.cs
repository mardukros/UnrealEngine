using UnrealBuildTool;

public class CustomPerformanceProfiler : ModuleRules
{
    public CustomPerformanceProfiler(ReadOnlyTargetRules Target) : base(Target)
    {
        PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;
        
        PublicDependencyModuleNames.AddRange(
            new string[]
            {
                "Core",
                "CoreUObject",
                "Engine",
                "RenderCore",
                "RHI"
            }
        );
        
        PrivateDependencyModuleNames.AddRange(
            new string[]
            {
                "Slate",
                "SlateCore"
            }
        );
    }
}