using Godot.Bridge;
using HarmonyLib;
using MegaCrit.Sts2.Core.Logging;
using MegaCrit.Sts2.Core.Modding;

namespace Spy2Mod.Scripts;

[ModInitializer(nameof(Init))]
public static class Entry
{
    public static void Init()
    {
        var harmony = new Harmony("io.github.Lyz30919235.spy2mod");
        harmony.PatchAll(typeof(Entry).Assembly);
        ScriptManagerBridge.LookupScriptsInAssembly(typeof(Entry).Assembly);
        var version = typeof(Entry).Assembly.GetName().Version;
        Log.Info($"[Spy2Mod] initialized; version={version}; gameplay changes=none.");
    }
}
