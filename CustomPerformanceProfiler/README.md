# Custom Performance Profiler Module

A custom Unreal Engine 5 module that provides advanced performance profiling capabilities with Blueprint support.

## Features

- **Performance Metrics Tracking**: Measure execution time of functions and code blocks
- **Blueprint Integration**: Easy-to-use Blueprint nodes for profiling
- **Timestamp Support**: Track when metrics were recorded
- **Memory Management**: Automatic cleanup and lifecycle management
- **Logging System**: Debug output for profiling data

## Usage

### C++ Usage

```cpp
// Get the profiler instance
UCustomProfiler* Profiler = UCustomProfilerLibrary::GetCustomProfiler();

// Start profiling
Profiler->StartProfiling("MyFunction");

// ... your code here ...

// End profiling
Profiler->EndProfiling("MyFunction");

// Get all metrics
TArray<FPerformanceMetric> Metrics = Profiler->GetPerformanceMetrics();
```

### Blueprint Usage

1. **Start Profiling**: Use "Profile Function" node
2. **End Profiling**: Use "End Profile Function" node
3. **Get Metrics**: Use "Get Custom Profiler" → "Get Performance Metrics"

## Module Structure

```
CustomPerformanceProfiler/
├── Public/
│   ├── CustomPerformanceProfiler.h
│   ├── CustomProfiler.h
│   └── CustomProfilerLibrary.h
├── Private/
│   ├── CustomPerformanceProfiler.cpp
│   ├── CustomProfiler.cpp
│   └── CustomProfilerLibrary.cpp
├── CustomPerformanceProfiler.Build.cs
├── CustomPerformanceProfiler.Target.cs
└── CustomPerformanceProfilerEditor.Target.cs
```

## Integration

To integrate this module into your UE5 project:

1. Copy the module to `YourProject/Source/`
2. Add "CustomPerformanceProfiler" to your project's Build.cs dependencies
3. Rebuild your project

## Dependencies

- Core
- CoreUObject
- Engine
- RenderCore
- RHI
- Slate (Private)
- SlateCore (Private)

## License

This module is part of the Unreal Engine 5 source code and follows Epic's licensing terms.