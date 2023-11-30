fn tuple() {
    // ANCHOR: sheet
    let address = "0x000";
    let age = 20;
    let active = true;

    // Create tuple
    let user_tuple = (address, age, active);

    // Access tuple
    let (address, age, active) = stored_tuple;
// ANCHOR_END: sheet
}
