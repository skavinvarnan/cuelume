//
//  UISFXCueSets.swift
//  Cuelume
//
//  GENERATED from uisfx's recipes.ts — do not edit by hand.
//  https://github.com/romainsimon/uisfx/blob/main/packages/uisfx/src/recipes.ts
//
//  Which cues a pack treats specially when it arranges notes.
//

enum UISFXCueSets {
    static let studioDetentCues: Set<UISFXCue> = [
        .press, .release, .doubleClick, .longPress, .select, .deselect, .toggleOn, .toggleOff,
        .check, .uncheck, .open, .close, .copy, .paste, .delete, .cancel, .dragStart, .drop,
        .snap, .reorder, .play, .pause, .seek, .skipNext, .skipPrevious, .lock, .unlock,
        .addToCart, .removeFromCart, .checkout, .purchase,
    ]

    static let studioMilestoneCues: Set<UISFXCue> = [
        .success, .complete, .checkpoint, .reward, .levelUp, .achievement, .bonus,
    ]

    static let mechanicalDetentCues: Set<UISFXCue> = [
        .press, .release, .doubleClick, .longPress, .select, .deselect, .toggleOn, .toggleOff,
        .check, .uncheck, .open, .close, .copy, .paste, .delete, .cancel, .dragStart, .drop,
        .snap, .reorder, .play, .pause, .seek, .skipNext, .skipPrevious, .lock, .unlock,
        .addToCart, .removeFromCart, .checkout, .purchase, .blocked, .progressStep, .stop,
        .invalidDrop,
    ]

    static let organicBodyCues: Set<UISFXCue> = [
        .press, .release, .longPress, .delete, .paste, .dragStart, .drop, .reorder,
        .invalidDrop, .send, .receive, .notification, .success, .error, .warning, .blocked,
        .start, .stop, .complete, .connect, .disconnect, .lock, .reward, .levelUp,
        .achievement, .bonus, .purchase, .refund,
    ]

    static let shimmerCues: Set<UISFXCue> = [
        .open, .expand, .copy, .send, .receive, .notification, .mention, .reaction, .success,
        .info, .complete, .checkpoint, .connect, .unlock, .wake, .reward, .levelUp,
        .achievement, .streak, .badge, .bonus, .checkout, .purchase, .coupon,
    ]

    static let cinematicWeightCues: Set<UISFXCue> = [
        .longPress, .delete, .cancel, .drop, .invalidDrop, .send, .receive, .success, .error,
        .warning, .blocked, .start, .stop, .complete, .connect, .disconnect, .lock, .sleep,
        .reward, .levelUp, .achievement, .badge, .bonus, .purchase, .refund,
    ]

    static let rubberExpressiveCues: Set<UISFXCue> = [
        .press, .release, .doubleClick, .longPress, .toggleOn, .toggleOff, .check, .uncheck,
        .dragStart, .drop, .snap, .reorder, .invalidDrop, .reaction, .success, .blocked,
        .retry, .play, .pause, .lock, .unlock, .reward, .levelUp, .achievement, .streak,
        .badge, .bonus, .addToCart, .removeFromCart, .purchase,
    ]

    static let zenPaperCues: Set<UISFXCue> = [
        .copy, .paste, .open, .close, .expand, .collapse, .dragStart, .drop, .swipe, .reorder,
        .send, .receive, .addToCart, .removeFromCart, .checkout, .refund,
    ]

    static let zenBrushCues: Set<UISFXCue> = [
        .undo, .redo, .back, .forward, .swipe, .send, .receive, .wake, .sleep,
    ]

    static let zenWoodCues: Set<UISFXCue> = [
        .press, .release, .doubleClick, .longPress, .select, .deselect, .toggleOn, .toggleOff,
        .check, .uncheck, .delete, .paste, .drop, .snap, .invalidDrop, .notification, .mention,
        .success, .error, .warning, .blocked, .retry, .checkpoint, .connect, .disconnect,
        .lock, .unlock, .reward, .badge, .addToCart, .removeFromCart, .checkout, .purchase,
    ]

    static let zenChimeCues: Set<UISFXCue> = [
        .send, .receive, .notification, .mention, .reaction, .success, .error, .warning, .info,
        .retry, .complete, .checkpoint, .connect, .disconnect, .wake, .reward, .levelUp,
        .achievement, .streak, .badge, .bonus, .checkout, .purchase, .coupon, .refund,
    ]

    static let zenFrequentCues: Set<UISFXCue> = [
        .hover, .press, .release, .doubleClick, .focus, .select, .deselect, .toggleOn,
        .toggleOff, .check, .uncheck, .snap, .typing, .progressStep, .seek, .volumeChange,
    ]
}
