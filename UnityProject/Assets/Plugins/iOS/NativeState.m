#import "NativeState.h"

id<SetsNativeState> nativeStateSetter;
id<EndGame> changeSceneSetter;

// Called from Swift. Can we hide this from the C# DllImport()?
void RegisterNativeStateSetter(id<SetsNativeState> setter) {
    nativeStateSetter = setter;
}

/* Called from Unity. Interop marshals argument from C# delegate to C function pointer.
   See section on marshalling delegates:
   learn.microsoft.com/en-us/dotnet/framework/interop/default-marshalling-behavior */
void OnSetNativeState(SetNativeStateCallback callback) {
    nativeStateSetter.setNativeState = callback;
}

void RegisterChangeSceneSetter(id<EndGame> setter) {
    changeSceneSetter = setter;
}

void OnSetChangeScene(SetChangeSceneCallback callback) {
    changeSceneSetter.changeScene = callback;
}
