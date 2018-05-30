
// Functions to extract from the raw data structure, not sized to units
function key_pos(key) = key[0];
function key_size(key) = key[1];
function key_rot(key) = key[2];
function key_rot_angle(key) = key_rot(key)[0];
function key_rot_off(key) = key_rot(key)[1];

// Put a child shape at the appropriate position for a key, incorporating unit sizing
module position_key(key, unit = 19.05) {
    pos = (key_pos(key) + key_size(key) / 2) * unit;
    rot_off = key_rot_off(key) * unit;
    translate(rot_off) rotate([0, 0, key_rot_angle(key)]) translate(-rot_off)
        translate(pos)
        children();
}

key_layout = [
    [[3.5, 0], [1, 1], [0, [0, 0]]], /* # / 3 */
    [[15.0, 0], [1, 1], [0, [0, 0]]], /* * / 8 */
    [[2.5, 0.125], [1, 1], [0, [0, 0]]], /* @ / 2 */
    [[4.5, 0.125], [1, 1], [0, [0, 0]]], /* $ / 4 */
    [[14.0, 0.125], [1, 1], [0, [0, 0]]], /* & / 7 */
    [[16.0, 0.125], [1, 1], [0, [0, 0]]], /* ( / 9 */
    [[5.5, 0.25], [1, 1], [0, [0, 0]]], /* % / 5 */
    [[13.0, 0.25], [1, 1], [0, [0, 0]]], /* ^ / 6 */
    [[0.25, 0.375], [1.25, 1], [0, [0, 0]]], /* ~ / ` */
    [[1.5, 0.375], [1, 1], [0, [0, 0]]], /* ! / 1 */
    [[17.0, 0.375], [1, 1], [0, [0, 0]]], /* ) / 0 */
    [[18.0, 0.375], [1.25, 1], [0, [0, 0]]], /* BACKSPACE */
    [[6.5, 0.75], [1, 1], [0, [0, 0]]], /* Esc */
    [[12.0, 0.75], [1, 1], [0, [0, 0]]], /* _ / - */
    [[3.5, 1.0], [1, 1], [0, [0, 0]]], /* E */
    [[15.0, 1.0], [1, 1], [0, [0, 0]]], /* I */
    [[2.5, 1.125], [1, 1], [0, [0, 0]]], /* W */
    [[4.5, 1.125], [1, 1], [0, [0, 0]]], /* R */
    [[14.0, 1.125], [1, 1], [0, [0, 0]]], /* U */
    [[16.0, 1.125], [1, 1], [0, [0, 0]]], /* O */
    [[5.5, 1.25], [1, 1], [0, [0, 0]]], /* T */
    [[13.0, 1.25], [1, 1], [0, [0, 0]]], /* Y */
    [[0.25, 1.375], [1.25, 1], [0, [0, 0]]], /* Tab */
    [[1.5, 1.375], [1, 1], [0, [0, 0]]], /* Q */
    [[17.0, 1.375], [1, 1], [0, [0, 0]]], /* P */
    [[18.0, 1.375], [1.25, 1], [0, [0, 0]]], /* | / \ */
    [[6.5, 1.75], [1, 1.5], [0, [0, 0]]], /*  */
    [[12.0, 1.75], [1, 1.5], [0, [0, 0]]], /* + / = */
    [[3.5, 2.0], [1, 1], [0, [0, 0]]], /* D */
    [[15.0, 2.0], [1, 1], [0, [0, 0]]], /* K */
    [[2.5, 2.125], [1, 1], [0, [0, 0]]], /* S */
    [[4.5, 2.125], [1, 1], [0, [0, 0]]], /* F */
    [[14.0, 2.125], [1, 1], [0, [0, 0]]], /* J */
    [[16.0, 2.125], [1, 1], [0, [0, 0]]], /* L */
    [[5.5, 2.25], [1, 1], [0, [0, 0]]], /* G */
    [[13.0, 2.25], [1, 1], [0, [0, 0]]], /* H */
    [[0.25, 2.375], [1.25, 1], [0, [0, 0]]], /* Ctrl */
    [[1.5, 2.375], [1, 1], [0, [0, 0]]], /* A */
    [[17.0, 2.375], [1, 1], [0, [0, 0]]], /* : / ; */
    [[18.0, 2.375], [1.25, 1], [0, [0, 0]]], /* " / ' */
    [[3.5, 3.0], [1, 1], [0, [0, 0]]], /* C */
    [[15.0, 3.0], [1, 1], [0, [0, 0]]], /* < / , */
    [[2.5, 3.125], [1, 1], [0, [0, 0]]], /* X */
    [[4.5, 3.125], [1, 1], [0, [0, 0]]], /* V */
    [[14.0, 3.125], [1, 1], [0, [0, 0]]], /* M */
    [[16.0, 3.125], [1, 1], [0, [0, 0]]], /* > / . */
    [[5.5, 3.25], [1, 1], [0, [0, 0]]], /* B */
    [[13.0, 3.25], [1, 1], [0, [0, 0]]], /* N */
    [[0.25, 3.375], [1.25, 1], [0, [0, 0]]], /* Shift */
    [[1.5, 3.375], [1, 1], [0, [0, 0]]], /* Z */
    [[17.0, 3.375], [1, 1], [0, [0, 0]]], /* ? / / */
    [[18.0, 3.375], [1.25, 1], [0, [0, 0]]], /* Shift */
    [[3.5, 4.0], [1, 1], [0, [0, 0]]], /*  */
    [[15.0, 4.0], [1, 1], [0, [0, 0]]], /*  */
    [[2.5, 4.125], [1, 1], [0, [0, 0]]], /* Win */
    [[16.0, 4.125], [1, 1], [0, [0, 0]]], /*  */
    [[0.5, 4.375], [1, 1], [0, [0, 0]]], /*  */
    [[1.5, 4.375], [1, 1], [0, [0, 0]]], /*  */
    [[17.0, 4.375], [1, 1], [0, [0, 0]]], /*  */
    [[18.0, 4.375], [1, 1], [0, [0, 0]]], /*  */
    [[4.5, 4.45], [1.25, 1], [15, [5.75, 5.45]]], /* Alt */
    [[6.5, 3.25], [1, 1], [30, [6.5, 4.25]]], /* PgUp */
    [[7.5, 3.25], [1, 1], [30, [6.5, 4.25]]], /* PgDn */
    [[6.5, 4.25], [1, 1.5], [30, [6.5, 4.25]]], /* Enter */
    [[7.5, 4.25], [1, 1.5], [30, [6.5, 4.25]]], /* Lower */
    [[11, 3.25], [1, 1], [-30, [13, 4.25]]], /* { / [ */
    [[12, 3.25], [1, 1], [-30, [13, 4.25]]], /* } / ] */
    [[11, 4.25], [1, 1.5], [-30, [13, 4.25]]], /* Raise */
    [[12, 4.25], [1, 1.5], [-30, [13, 4.25]]], /*  */
    [[13.75, 4.45], [1.25, 1], [-15, [13.75, 5.45]]], /* Alt */
];
