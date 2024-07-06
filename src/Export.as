// c 2024-03-12
// m 2024-06-04

/*
Shared namespace defining active effects on the viewed vehicle
When watching a replay, there must be only one vehicle active
*/
namespace CurrentEffects {
    /*
    Call this function to get access to variables in this plugin
    Use this instead of a new `CurrentEffects::State`
    */
    import State@ GetState() from "CurrentEffects";
}
