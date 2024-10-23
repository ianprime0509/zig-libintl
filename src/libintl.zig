//! Zig bindings for libintl, the library providing the `gettext` function and
//! friends used for internationalization.

const std = @import("std");
const mem = std.mem;

pub const c = @import("c.zig");

pub const Category = enum(c_int) {
    messages = @intFromEnum(c.LC.MESSAGES),
    collate = @intFromEnum(c.LC.COLLATE),
    ctype = @intFromEnum(c.LC.CTYPE),
    monetary = @intFromEnum(c.LC.MONETARY),
    numeric = @intFromEnum(c.LC.NUMERIC),
    time = @intFromEnum(c.LC.TIME),
    _,
};

pub fn gettext(msgid: [:0]const u8) [:0]const u8 {
    return mem.span(c.gettext(msgid));
}

test gettext {
    try std.testing.expectEqualStrings("message", gettext("message"));
}

pub fn dgettext(domainname: [:0]const u8, msgid: [:0]const u8) [:0]const u8 {
    return mem.span(c.dgettext(domainname, msgid));
}

test dgettext {
    try std.testing.expectEqualStrings("message", dgettext("com.example.Application", "message"));
}

pub fn dcgettext(domainname: [:0]const u8, msgid: [:0]const u8, category: Category) [:0]const u8 {
    return mem.span(c.dcgettext(domainname, msgid, @enumFromInt(@intFromEnum(category))));
}

test dcgettext {
    try std.testing.expectEqualStrings("message", dcgettext("com.example.Application", "message", .messages));
}

pub fn ngettext(msgid1: [:0]const u8, msgid2: [:0]const u8, n: c_ulong) [:0]const u8 {
    return mem.span(c.ngettext(msgid1, msgid2, n));
}

test ngettext {
    try std.testing.expectEqualStrings("message", ngettext("message", "messages", 1));
    try std.testing.expectEqualStrings("messages", ngettext("message", "messages", 2));
}

pub fn dngettext(domainname: [:0]const u8, msgid1: [:0]const u8, msgid2: [:0]const u8, n: c_ulong) [:0]const u8 {
    return mem.span(c.dngettext(domainname, msgid1, msgid2, n));
}

test dngettext {
    try std.testing.expectEqualStrings("message", dngettext("com.example.Application", "message", "messages", 1));
    try std.testing.expectEqualStrings("messages", dngettext("com.example.Application", "message", "messages", 2));
}

pub fn dcngettext(domainname: [:0]const u8, msgid1: [:0]const u8, msgid2: [:0]const u8, n: c_ulong, category: Category) [:0]const u8 {
    return mem.span(c.dcngettext(domainname, msgid1, msgid2, n, @enumFromInt(@intFromEnum(category))));
}

test dcngettext {
    try std.testing.expectEqualStrings("message", dcngettext("com.example.Application", "message", "messages", 1, .messages));
    try std.testing.expectEqualStrings("messages", dcngettext("com.example.Application", "message", "messages", 2, .messages));
}

// Reference for pgettext functions:
// https://git.savannah.gnu.org/gitweb/?p=gettext.git;a=blob;f=gnulib-local/lib/gettext.h;h=3d3840f9fcde4080ce3aff097ea73a23ce6e9417;hb=HEAD

const msgctxt_sep = "\x04"; // EOT

pub fn pgettext(comptime msgctxt: [:0]const u8, comptime msgid: [:0]const u8) [:0]const u8 {
    const ctxt_id = msgctxt ++ msgctxt_sep ++ msgid;
    const translation = gettext(ctxt_id);
    return if (translation.ptr == ctxt_id.ptr) msgid else translation;
}

test pgettext {
    try std.testing.expectEqualStrings("message", pgettext("context", "message"));
}

pub fn dpgettext(domainname: [:0]const u8, comptime msgctxt: [:0]const u8, comptime msgid: [:0]const u8) [:0]const u8 {
    const ctxt_id = msgctxt ++ msgctxt_sep ++ msgid;
    const translation = dgettext(domainname, ctxt_id);
    return if (translation.ptr == ctxt_id.ptr) msgid else translation;
}

test dpgettext {
    try std.testing.expectEqualStrings("message", dpgettext("com.example.Application", "context", "message"));
}

pub fn dcpgettext(domainname: [:0]const u8, comptime msgctxt: [:0]const u8, comptime msgid: [:0]const u8, category: Category) [:0]const u8 {
    const ctxt_id = msgctxt ++ msgctxt_sep ++ msgid;
    const translation = dcgettext(domainname, ctxt_id, category);
    return if (translation.ptr == ctxt_id.ptr) msgid else translation;
}

test dcpgettext {
    try std.testing.expectEqualStrings("message", dcpgettext("com.example.Application", "context", "message", .messages));
}

pub fn npgettext(comptime msgctxt: [:0]const u8, comptime msgid1: [:0]const u8, comptime msgid2: [:0]const u8, n: c_ulong) [:0]const u8 {
    const ctxt_id = msgctxt ++ msgctxt_sep ++ msgid1;
    const translation = ngettext(ctxt_id, msgid2, n);
    if (translation.ptr == ctxt_id.ptr) {
        return if (n == 1) msgid1 else msgid2;
    } else {
        return translation;
    }
}

test npgettext {
    try std.testing.expectEqualStrings("message", npgettext("context", "message", "messages", 1));
    try std.testing.expectEqualStrings("messages", npgettext("context", "message", "messages", 2));
}

pub fn dnpgettext(domainname: [:0]const u8, comptime msgctxt: [:0]const u8, comptime msgid1: [:0]const u8, comptime msgid2: [:0]const u8, n: c_ulong) [:0]const u8 {
    const ctxt_id = msgctxt ++ msgctxt_sep ++ msgid1;
    const translation = dngettext(domainname, ctxt_id, msgid2, n);
    if (translation.ptr == ctxt_id.ptr) {
        return if (n == 1) msgid1 else msgid2;
    } else {
        return translation;
    }
}

test dnpgettext {
    try std.testing.expectEqualStrings("message", dnpgettext("com.example.Application", "context", "message", "messages", 1));
    try std.testing.expectEqualStrings("messages", dnpgettext("com.example.Application", "context", "message", "messages", 2));
}

pub fn dcnpgettext(domainname: [:0]const u8, comptime msgctxt: [:0]const u8, comptime msgid1: [:0]const u8, comptime msgid2: [:0]const u8, n: c_ulong, category: Category) [:0]const u8 {
    const ctxt_id = msgctxt ++ msgctxt_sep ++ msgid1;
    const translation = dcngettext(domainname, ctxt_id, msgid2, n, category);
    if (translation.ptr == ctxt_id.ptr) {
        return if (n == 1) msgid1 else msgid2;
    } else {
        return translation;
    }
}

test dcnpgettext {
    try std.testing.expectEqualStrings("message", dcnpgettext("com.example.Application", "context", "message", "messages", 1, .messages));
    try std.testing.expectEqualStrings("messages", dcnpgettext("com.example.Application", "context", "message", "messages", 2, .messages));
}

pub fn getTextDomain() [:0]const u8 {
    return mem.span(c.textdomain(null));
}

pub fn setTextDomain(domainname: [:0]const u8) void {
    _ = c.textdomain(domainname);
}

pub fn bindTextDomain(domainname: [:0]const u8, dirname: [:0]const u8) void {
    _ = c.bindtextdomain(domainname, dirname);
}

pub fn bindTextDomainCodeset(domainname: [:0]const u8, codeset: [:0]const u8) void {
    _ = c.bind_textdomain_codeset(domainname, codeset);
}
