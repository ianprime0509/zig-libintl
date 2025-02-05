//! The raw C API.

const std = @import("std");

// Reference: https://sourceware.org/git/?p=glibc.git;a=blob;f=intl/libintl.h;h=5eee662ba80774b35ba0d7b6c1406b7fc51251fd;hb=HEAD
pub extern fn gettext(msgid: [*:0]const u8) [*:0]const u8;
pub extern fn dgettext(domainname: [*:0]const u8, msgid: [*:0]const u8) [*:0]const u8;
pub extern fn dcgettext(domainname: [*:0]const u8, msgid: [*:0]const u8, category: std.c.LC) [*:0]const u8;
pub extern fn ngettext(msgid1: [*:0]const u8, msgid2: [*:0]const u8, n: c_ulong) [*:0]const u8;
pub extern fn dngettext(domainname: [*:0]const u8, msgid1: [*:0]const u8, msgid2: [*:0]const u8, n: c_ulong) [*:0]const u8;
pub extern fn dcngettext(domainname: [*:0]const u8, msgid1: [*:0]const u8, msgid2: [*:0]const u8, n: c_ulong, category: std.c.LC) [*:0]const u8;
pub extern fn textdomain(domainname: ?[*:0]const u8) [*:0]const u8;
pub extern fn bindtextdomain(domainname: [*:0]const u8, dirname: [*:0]const u8) [*:0]const u8;
pub extern fn bind_textdomain_codeset(domainname: [*:0]const u8, codeset: [*:0]const u8) [*:0]const u8;
