// - all Dev:: (and related) calls for the plugin live here
// - this should make it easier for maintainers and reviewers
// - namespaced so source files can be grepped for "Danger::"

namespace Danger {
    uint16 GetMemberOffset(const string&in className, const string&in memberName) {
        return Reflection::GetType(className).GetMember(memberName).Offset;
    }

    uint64 GetPointer(CMwNod@ Nod) {
        return Dev::ForceCast<uint64>(Nod).Get();
    }
}
