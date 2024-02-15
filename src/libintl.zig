const std = @import("std");
const mem = std.mem;

/// Raw C API.
pub const c = @import("c.zig");

pub const Category = Category: {
    var fields: [@typeInfo(c.LC).Enum.fields.len]std.builtin.Type.EnumField = undefined;
    for (&fields, @typeInfo(c.LC).Enum.fields) |*dest_field, src_field| {
        var dest_field_name: [src_field.name.len]u8 = undefined;
        _ = std.ascii.lowerString(&dest_field_name, src_field.name);
        dest_field.* = .{
            .name = &dest_field_name,
            .value = src_field.value,
        };
    }

    break :Category @Type(.{ .Enum = .{
        .tag_type = c_int,
        .fields = &fields,
        .decls = &.{},
        .is_exhaustive = false,
    } });
};

pub fn gettext(msgid: [:0]const u8) [:0]const u8 {
    return mem.span(c.gettext(msgid));
}

pub fn dgettext(domainname: [:0]const u8, msgid: [:0]const u8) [:0]const u8 {
    return mem.span(c.dgettext(domainname, msgid));
}

pub fn dcgettext(domainname: [:0]const u8, msgid: [:0]const u8, category: Category) [:0]const u8 {
    return mem.span(c.dcgettext(domainname, msgid, @enumFromInt(@intFromEnum(category))));
}

pub fn ngettext(msgid1: [:0]const u8, msgid2: [:0]const u8, n: c_ulong) [:0]const u8 {
    return mem.span(c.ngettext(msgid1, msgid2, n));
}

pub fn dngettext(domainname: [:0]const u8, msgid1: [:0]const u8, msgid2: [:0]const u8, n: c_ulong) [:0]const u8 {
    return mem.span(c.dngettext(domainname, msgid1, msgid2, n));
}

pub fn dcngettext(domainname: [:0]const u8, msgid1: [:0]const u8, msgid2: [:0]const u8, n: c_ulong, category: Category) [:0]const u8 {
    return mem.span(c.dngettext(domainname, msgid1, msgid2, n, @enumFromInt(@intFromEnum(category))));
}

// Reference for pgettext functions:
// https://git.savannah.gnu.org/gitweb/?p=gettext.git;a=blob;f=gnulib-local/lib/gettext.h;h=3d3840f9fcde4080ce3aff097ea73a23ce6e9417;hb=HEAD

const msgctxt_sep = "\x04"; // EOT

pub fn pgettext(comptime msgctxt: [:0]const u8, comptime msgid: [:0]const u8) [:0]const u8 {
    const ctxt_id = msgctxt ++ msgctxt_sep ++ msgid;
    const translation = gettext(ctxt_id);
    return if (translation.ptr == ctxt_id.ptr) msgid else translation;
}

pub fn dpgettext(comptime domainname: [:0]const u8, comptime msgctxt: [:0]const u8, comptime msgid: [:0]const u8) [:0]const u8 {
    const ctxt_id = msgctxt ++ msgctxt_sep ++ msgid;
    const translation = dgettext(domainname, ctxt_id);
    return if (translation.ptr == ctxt_id.ptr) msgid else translation;
}

pub fn dcpgettext(comptime domainname: [:0]const u8, comptime msgctxt: [:0]const u8, comptime msgid: [:0]const u8, comptime category: c_int) [:0]const u8 {
    const ctxt_id = msgctxt ++ msgctxt_sep ++ msgid;
    const translation = dcgettext(domainname, ctxt_id, category);
    return if (translation.ptr == ctxt_id.ptr) msgid else translation;
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

pub fn dnpgettext(comptime domainname: [:0]const u8, comptime msgctxt: [:0]const u8, comptime msgid1: [:0]const u8, comptime msgid2: [:0]const u8, n: c_ulong) [:0]const u8 {
    const ctxt_id = msgctxt ++ msgctxt_sep ++ msgid1;
    const translation = dngettext(domainname, ctxt_id, msgid2, n);
    if (translation.ptr == ctxt_id.ptr) {
        return if (n == 1) msgid1 else msgid2;
    } else {
        return translation;
    }
}

pub fn dcnpgettext(comptime domainname: [:0]const u8, comptime msgctxt: [:0]const u8, comptime msgid1: [:0]const u8, comptime msgid2: [:0]const u8, n: c_ulong, comptime category: c_int) [:0]const u8 {
    const ctxt_id = msgctxt ++ msgctxt_sep ++ msgid1;
    const translation = dcngettext(domainname, ctxt_id, msgid2, n, category);
    if (translation.ptr == ctxt_id.ptr) {
        return if (n == 1) msgid1 else msgid2;
    } else {
        return translation;
    }
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
