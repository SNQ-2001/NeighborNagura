/* Support init only setters. See section on record
   support: docs.unity3d.com/Manual/CSharpCompiler.html */

using UnityEditor;
using UnityEngine;

namespace System.Runtime.CompilerServices
{
    internal class IsExternalInit{}
}

// Should match NativeState struct in Assets/Plugins/iOS/NativeState.h
public readonly struct NativeState
{
    public double x { get; init; }
    public double y { get; init; }
    public double z { get; init; }
    public int userRole { get; init; }
}

public static class NativeStateManager
{
    public static NativeState State { get; private set; }

    // Should match SetNativeStateCallback typedef in Assets/Plugins/iOS/NativeState.h
    private delegate void SetNativeStateCallback(NativeState nextState);

    /* Imported from Plugins/iOS/NativeState.m to pass instance of
       SetNativeStateCallback to C. See section on using delegates: docs.unity3d.com/Manual/PluginsForIOS.html */
    [System.Runtime.InteropServices.DllImport("__Internal")]
    private static extern void OnSetNativeState(SetNativeStateCallback callback);
    
    [System.Runtime.InteropServices.DllImport("__Internal")]
    private static extern void EndGame();

    /* Reverse P/Invoke wrapped method to set state value. iOS is an AOT platform hence the decorator.
       See section on calling managed methods from native code: docs.unity3d.com/Manual/ScriptingRestrictions.html */
    [AOT.MonoPInvokeCallback(typeof(SetNativeStateCallback))]
    private static void SetState(NativeState nextState) { State = nextState; }

    static NativeStateManager()
    {
        #if !UNITY_EDITOR
            OnSetNativeState(SetState);
        #endif
    }

    public static void EndGameScene()
    {
        Debug.Log("EndGameScene");
        //Swiftのコールバック
        EndGame();
    }
}
