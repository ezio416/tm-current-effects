/*
Shared namespace defining active effects on the viewed vehicle
When watching a replay, there must be only one vehicle active
*/
namespace CurrentEffects {
    /*
    Call this function to get access to variables in this plugin
    Use this instead of a new `CurrentEffects::State`
    */
    State@ GetState() {
        return state;
    }
}
