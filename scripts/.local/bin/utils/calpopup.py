#!/usr/bin/env python3

import argparse
import re
import sys
from datetime import date, timedelta
from functools import lru_cache

try:
    import tkinter as tk
    import tkinter.font as tkfont
except ImportError:
    sys.stderr.write("calpopup: tkinter not found\n")
    sys.exit(2)

THEME = dict(
    bg="#111111",  # window background
    border="#2a2e36",  # window border + separator
    fg="#cdd6f4",  # normal day numbers
    dim="#4d535e",  # days from neighbouring months
    sub="#7d8594",  # secondary-calendar numbers
    sub_month="#569fc9",  # secondary-calendar month label
    head="#9aa5b8",  # weekday header
    accent="#8cb4ff",  # selected day
    on_accent="#14161a",  # text on selected day
    today="#e0af68",  # ring around today
    weekend="#e06c75",  # weekend days
)

MIN_DATE = date(1700, 1, 1)
MAX_DATE = date(2400, 12, 31)

PERSIAN_DIGITS = str.maketrans("0123456789", "۰۱۲۳۴۵۶۷۸۹")
DIGIT_NORM = str.maketrans("۰۱۲۳۴۵۶۷۸۹٠١٢٣٤٥٦٧٨٩", "01234567890123456789")


def j_leap(y):
    return (25 * y + 11) % 33 < 8


@lru_cache(maxsize=None)
def _days_before(y):
    return 365 * (y - 1) + sum(1 for k in range(1, y) if j_leap(k))


def in_range(d):
    return MIN_DATE <= d <= MAX_DATE


def shift_months(cal, d, n):
    y, m, dd = cal.ymd(d)
    t = y * 12 + (m - 1) + n
    y, m = divmod(t, 12)
    m += 1
    try:
        nd = cal.make(y, m, min(dd, cal.mlen(y, m)))
    except (ValueError, OverflowError):
        return d
    return nd if in_range(nd) else d


_J_CUM = (0, 31, 62, 93, 124, 155, 186, 216, 246, 276, 306, 336)
_J_ANCHOR = date(2021, 3, 21).toordinal() - _days_before(1400)


class Cal:
    name = ""
    persian = False
    week_start = 0
    weekend: tuple[int, ...] = ()
    months: tuple[str, ...] = ()
    shorts: tuple[str, ...] = ()
    wd_short: tuple[str, ...] = ()
    wd_full: tuple[str, ...] = ()

    def num(self, n):
        s = str(n)
        return s.translate(PERSIAN_DIGITS) if self.persian else s

    def month_name(self, m):
        return self.months[m - 1]

    def short_name(self, m) -> str:
        return self.shorts[m - 1]


class Gregorian(Cal):
    name = "Gregorian"
    week_start = 0
    weekend = (5, 6)
    months = (
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
    )
    shorts = (
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
    )
    wd_short = ("Mo", "Tu", "We", "Th", "Fr", "Sa", "Su")
    wd_full = (
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday",
    )

    def ymd(self, d):
        return d.year, d.month, d.day

    def mlen(self, y, m):
        if m == 2:
            return 29 if (y % 4 == 0 and (y % 100 != 0 or y % 400 == 0)) else 28
        return 30 if m in (4, 6, 9, 11) else 31

    def make(self, y, m, d):
        return date(y, m, d)


class Jalali(Cal):
    name = "Jalali"
    week_start = 5
    weekend = (4,)
    months = (
        "Farvardin",
        "Ordibehesht",
        "Khordad",
        "Tir",
        "Mordad",
        "Shahrivar",
        "Mehr",
        "Aban",
        "Azar",
        "Dey",
        "Bahman",
        "Esfand",
    )
    shorts = (
        "Far",
        "Ord",
        "Kho",
        "Tir",
        "Mor",
        "Sha",
        "Meh",
        "Aba",
        "Aza",
        "Dey",
        "Bah",
        "Esf",
    )
    wd_short = ("Do", "Se", "Ch", "Pa", "Jo", "Sh", "Ye")
    wd_full = (
        "Doshanbe",
        "Seshanbe",
        "Chaharshanbe",
        "Panjshanbe",
        "Jomeh",
        "Shanbe",
        "Yekshanbe",
    )

    def mlen(self, y, m):
        if m <= 6:
            return 31
        if m <= 11:
            return 30
        return 30 if j_leap(y) else 29

    def ymd(self, d):
        n = d.toordinal() - _J_ANCHOR
        y = int(n // 365.2425) + 1
        while _days_before(y + 1) <= n:
            y += 1
        while _days_before(y) > n:
            y -= 1
        r = n - _days_before(y)
        m = 12
        while _J_CUM[m - 1] > r:
            m -= 1
        return y, m, r - _J_CUM[m - 1] + 1

    def make(self, y, m, d):
        if y < 1 or not 1 <= m <= 12 or not 1 <= d <= self.mlen(y, m):
            raise ValueError("invalid jalali date")
        return date.fromordinal(_J_ANCHOR + _days_before(y) + _J_CUM[m - 1] + d - 1)


GREG = Gregorian()
JAL = Jalali()


HELP = (
    "arrows / hjkl          day / week",
    "n p  PgDn PgUp         month",
    "N P  Shift+PgDn/Up     year",
    "t  Home                today",
    "Tab / s                swap calendars",
    "g                      go to date (Y-M-D)",
    "Enter                  print date, quit",
    "Esc q                  quit",
    "",
    "mouse: click select, dbl-click print",
    "wheel month, < > month, title today",
    "subtitle = swap calendars",
)


class App:
    def __init__(self, a):
        self.a = a
        GREG.week_start = {"mon": 0, "sat": 5, "sun": 6}[a.week_start]
        JAL.persian = a.persian_digits
        self.primary = "j" if a.jalali else "g"
        self.sel = a.date if a.date else date.today()
        self.sel = min(max(self.sel, MIN_DATE), MAX_DATE)
        self.prompt = None
        self.msg = ""
        self.show_help = False
        self.armed = False
        self.code = 1
        self.grid_start = self.sel

        u = a.size
        self.pad = round(u * 0.9)
        self.cw = round(u * 3.3)
        self.ch = round(u * 2.5)
        self.head_h = round(u * 3.6)
        self.wd_h = round(u * 1.9)
        self.foot_h = round(u * 3.8)
        self.W = 2 * self.pad + 7 * self.cw
        self.H = self.head_h + self.wd_h + 6 * self.ch + self.foot_h

        root = self.root = tk.Tk(className="calpopup")
        root.title("calpopup")
        root.configure(bg=THEME["bg"])
        root.resizable(False, False)
        try:
            root.attributes("-type", "dialog")
        except tk.TclError:
            pass

        fam = a.font
        self.f_main = tkfont.Font(root=root, family=fam, size=-u)
        self.f_big = tkfont.Font(
            root=root, family=fam, size=-round(u * 1.25), weight="bold"
        )
        self.f_sub = tkfont.Font(root=root, family=fam, size=-round(u * 0.8))
        self.f_small = tkfont.Font(root=root, family=fam, size=-round(u * 0.66))
        self.f_foot = tkfont.Font(root=root, family=fam, size=-round(u * 0.85))

        self.c = tk.Canvas(
            root,
            width=self.W,
            height=self.H,
            bg=THEME["bg"],
            highlightthickness=0,
            bd=0,
        )
        self.c.pack()

        self.place_window()

        root.bind("<Key>", self.on_key)
        root.bind("<FocusIn>", lambda _: setattr(self, "armed", True))
        if not a.keep:
            root.bind("<FocusOut>", lambda _: root.after(150, self.maybe_close))
        self.c.bind("<Button-1>", self.on_click)
        self.c.bind("<Double-Button-1>", self.on_dclick)
        self.c.bind("<Button-4>", lambda _: self.nav_months(-1))
        self.c.bind("<Button-5>", lambda _: self.nav_months(1))
        self.c.bind("<MouseWheel>", lambda e: self.nav_months(-1 if e.delta > 0 else 1))

        self.redraw()
        root.after(20, root.focus_force)
        root.after(40, self.c.focus_set)

    def place_window(self):
        r = self.root
        r.update_idletasks()
        sw, sh = r.winfo_screenwidth(), r.winfo_screenheight()
        x, y = (sw - self.W) // 2, (sh - self.H) // 2
        x = max(0, min(x, sw - self.W))
        y = max(0, min(y, sh - self.H))
        r.geometry("%dx%d+%d+%d" % (self.W, self.H, x, y))

    def maybe_close(self):
        if self.armed and self.root.focus_displayof() is None:
            self.quit(1)

    def quit(self, code):
        self.code = code
        self.root.destroy()

    @property
    def P(self):
        return GREG if self.primary == "g" else JAL

    @property
    def S(self):
        return JAL if self.primary == "g" else GREG

    def long_fmt(self, cal, d):
        y, m, dd = cal.ymd(d)
        return "%s, %s %s %s" % (
            cal.wd_full[d.weekday()],
            cal.num(dd),
            cal.month_name(m),
            cal.num(y),
        )

    def rrect(self, x0, y0, x1, y1, r, **kw):
        pts = [
            x0 + r,
            y0,
            x1 - r,
            y0,
            x1,
            y0,
            x1,
            y0 + r,
            x1,
            y1 - r,
            x1,
            y1,
            x1 - r,
            y1,
            x0 + r,
            y1,
            x0,
            y1,
            x0,
            y1 - r,
            x0,
            y0 + r,
            x0,
            y0,
        ]
        return self.c.create_polygon(pts, smooth=True, **kw)

    def redraw(self):
        c, T = self.c, THEME
        P, S = self.P, self.S
        W, pad, cw, ch = self.W, self.pad, self.cw, self.ch
        today = date.today()
        c.delete("all")
        c.create_rectangle(0, 0, W - 1, self.H - 1, outline=T["border"])

        sy, sm, _ = P.ymd(self.sel)
        first = P.make(sy, sm, 1)
        last = P.make(sy, sm, P.mlen(sy, sm))
        start = first - timedelta(days=(first.weekday() - P.week_start) % 7)
        self.grid_start = start

        hy = self.head_h * 0.38
        c.create_text(
            W / 2,
            hy,
            text="%s %s" % (P.month_name(sm), P.num(sy)),
            font=self.f_big,
            fill=T["fg"],
        )
        c.create_text(pad + cw / 2, hy, text="‹", font=self.f_big, fill=T["head"])
        c.create_text(W - pad - cw / 2, hy, text="›", font=self.f_big, fill=T["head"])
        a, b = S.ymd(first), S.ymd(last)
        if a[:2] == b[:2]:
            sub = "%s %s" % (S.month_name(a[1]), S.num(a[0]))
        elif a[0] == b[0]:
            sub = "%s – %s %s" % (S.month_name(a[1]), S.month_name(b[1]), S.num(a[0]))
        else:
            sub = "%s %s – %s %s" % (
                S.month_name(a[1]),
                S.num(a[0]),
                S.month_name(b[1]),
                S.num(b[0]),
            )
        c.create_text(
            W / 2, self.head_h * 0.76, text=sub, font=self.f_sub, fill=T["sub"]
        )

        for i in range(7):
            wd = (P.week_start + i) % 7
            col = T["weekend"] if wd in P.weekend else T["head"]
            c.create_text(
                pad + cw * (i + 0.5),
                self.head_h + self.wd_h / 2,
                text=P.wd_short[wd],
                font=self.f_small,
                fill=col,
            )

        top = self.head_h + self.wd_h
        for i in range(42):
            d = start + timedelta(days=i)
            r, k = divmod(i, 7)
            x0, y0 = pad + k * cw, top + r * ch
            _, pm, pd = P.ymd(d)
            py_ = P.ymd(d)[0]
            _, sm_, sd = S.ymd(d)
            in_month = (py_, pm) == (sy, sm)
            is_sel, is_today = d == self.sel, d == today

            if is_sel or is_today:
                self.rrect(
                    x0 + 2,
                    y0 + 2,
                    x0 + cw - 2,
                    y0 + ch - 2,
                    6,
                    fill=T["accent"] if is_sel else "",
                    outline=T["today"] if is_today else "",
                    width=1.5,
                )

            if is_sel:
                c1 = c2 = c3 = T["on_accent"]
            elif in_month:
                c1 = T["weekend"] if d.weekday() in P.weekend else T["fg"]
                c2, c3 = T["sub"], T["sub_month"]
            else:
                c1 = c2 = c3 = T["dim"]

            cx = x0 + cw / 2
            c.create_text(cx, y0 + ch * 0.40, text=P.num(pd), font=self.f_main, fill=c1)
            if sd == 1:
                c.create_text(
                    cx,
                    y0 + ch * 0.77,
                    text=S.short_name(sm_),
                    font=self.f_small,
                    fill=c3,
                )
            else:
                c.create_text(
                    cx, y0 + ch * 0.77, text=S.num(sd), font=self.f_small, fill=c2
                )

        fy = top + 6 * ch
        c.create_line(pad, fy + 2, W - pad, fy + 2, fill=T["border"])
        c.create_text(
            pad,
            fy + self.foot_h * 0.30,
            anchor="w",
            font=self.f_foot,
            fill=T["fg"],
            text=self.long_fmt(P, self.sel),
        )
        if self.prompt is not None:
            if self.msg:
                txt, col = (
                    "%s: %s▏  (%s)" % ("go to", self.prompt, self.msg),
                    T["weekend"],
                )
            else:
                txt, col = "go to %s Y-M-D: %s▏" % (P.name, self.prompt), T["accent"]
        else:
            txt, col = self.long_fmt(S, self.sel), T["sub"]
        c.create_text(
            pad,
            fy + self.foot_h * 0.68,
            anchor="w",
            font=self.f_foot,
            fill=col,
            text=txt,
        )
        c.create_text(
            W - pad,
            fy + self.foot_h * 0.30,
            anchor="e",
            font=self.f_small,
            fill=T["dim"],
            text="? help",
        )

        if self.show_help:
            c.create_rectangle(
                1, 1, W - 2, self.H - 2, fill=T["bg"], outline=T["border"]
            )
            lh = self.a.size * 1.45
            for n, line in enumerate(HELP):
                c.create_text(
                    pad * 2,
                    pad * 2 + n * lh,
                    anchor="nw",
                    font=self.f_small,
                    fill=T["fg"],
                    text=line,
                )

    def set_sel(self, d):
        if in_range(d):
            self.sel = d
        self.redraw()

    def move_days(self, n):
        self.set_sel(self.sel + timedelta(days=n))

    def nav_months(self, n):
        self.set_sel(shift_months(self.P, self.sel, n))

    def go_today(self):
        self.set_sel(date.today())

    def swap(self):
        self.primary = "j" if self.primary == "g" else "g"
        self.redraw()

    def accept(self):
        y, m, d = JAL.ymd(self.sel)
        g = self.sel.isoformat()
        j = "%04d-%02d-%02d" % (y, m, d)
        out = self.a.output
        if out == "primary":
            out = self.primary
        text = {"g": g, "j": j}.get(out, "%s %s" % (g, j))
        sys.stdout.write(text + "\n")
        sys.stdout.flush()
        self.quit(0)

    def goto(self, text):
        t = text.strip().lower().translate(DIGIT_NORM)
        if t in ("", "t", "today"):
            return date.today()
        try:
            nums = [int(x) for x in re.split(r"[-/.\s]+", t) if x]
        except ValueError:
            return None
        y0, m0, _ = self.P.ymd(self.sel)
        if len(nums) == 3:
            y, m, d = nums
        elif len(nums) == 2:
            y, (m, d) = y0, nums
        elif len(nums) == 1:
            y, m, d = y0, m0, nums[0]
        else:
            return None
        try:
            nd = self.P.make(y, m, d)
        except (ValueError, OverflowError):
            return None
        return nd if in_range(nd) else None

    def on_key(self, e):
        ks = e.keysym
        if self.show_help:
            self.show_help = False
            self.redraw()
            return "break"
        if self.prompt is not None:
            return self.prompt_key(e)

        shift = bool(e.state & 0x1)
        if ks in ("Escape", "q"):
            self.quit(1)
        elif ks in ("Return", "KP_Enter"):
            self.accept()
        elif ks in ("Left", "h"):
            self.move_days(-1)
        elif ks in ("Right", "l"):
            self.move_days(1)
        elif ks in ("Up", "k"):
            self.move_days(-7)
        elif ks in ("Down", "j"):
            self.move_days(7)
        elif ks in ("Next", "Prior") and shift:
            self.set_sel(shift_months(self.P, self.sel, 12 if ks == "Next" else -12))
        elif ks in ("n", "Next", "bracketright"):
            self.nav_months(1)
        elif ks in ("p", "Prior", "bracketleft"):
            self.nav_months(-1)
        elif ks in ("N", "braceright"):
            self.set_sel(shift_months(self.P, self.sel, 12))
        elif ks in ("P", "braceleft"):
            self.set_sel(shift_months(self.P, self.sel, -12))
        elif ks in ("t", "Home"):
            self.go_today()
        elif ks in ("Tab", "ISO_Left_Tab", "s"):
            self.swap()
        elif ks == "g":
            self.prompt, self.msg = "", ""
            self.redraw()
        elif ks in ("question", "F1"):
            self.show_help = True
            self.redraw()
        return "break"

    def prompt_key(self, e):
        ks = e.keysym
        buf = self.prompt or ""
        if ks == "Escape":
            self.prompt, self.msg = None, ""
        elif ks in ("Return", "KP_Enter"):
            d = self.goto(self.prompt)
            if d is None:
                self.msg = "invalid date"
            else:
                self.prompt, self.msg = None, ""
                self.sel = d
        elif ks == "BackSpace":
            self.prompt, self.msg = buf[:-1], ""
        elif e.char and e.char.isprintable() and len(buf) < 16:
            self.prompt, self.msg = self.prompt + e.char, ""
        self.redraw()
        return "break"

    def grid_hit(self, e):
        col = (e.x - self.pad) // self.cw
        row = (e.y - self.head_h - self.wd_h) // self.ch
        if e.x >= self.pad and 0 <= col < 7 and 0 <= row < 6:
            return self.grid_start + timedelta(days=row * 7 + col)
        return None

    def on_click(self, e):
        self.c.focus_set()
        if self.show_help:
            self.show_help = False
            self.redraw()
            return
        if e.y < self.head_h:
            if e.x < self.pad + self.cw:
                self.nav_months(-1)
            elif e.x > self.W - self.pad - self.cw:
                self.nav_months(1)
            elif e.y < self.head_h * 0.62:
                self.go_today()
            else:
                self.swap()
            return
        d = self.grid_hit(e)
        if d:
            self.set_sel(d)

    def on_dclick(self, e):
        if self.grid_hit(e):
            self.accept()


def parse_date(s):
    try:
        return date.fromisoformat(s)
    except ValueError:
        raise argparse.ArgumentTypeError("expected YYYY-MM-DD (Gregorian)")


def main():
    ap = argparse.ArgumentParser(description="Gregorian + Jalali calendar popup.")
    ap.add_argument(
        "-j",
        "--jalali",
        action="store_true",
        help="start with Jalali as the main calendar (Tab swaps)",
    )
    ap.add_argument(
        "-d", "--date", type=parse_date, help="initial date, Gregorian YYYY-MM-DD"
    )
    ap.add_argument(
        "--week-start",
        choices=("mon", "sun", "sat"),
        default="mon",
        help="first weekday of the Gregorian grid (Jalali always starts Saturday)",
    )
    ap.add_argument(
        "--size", type=int, default=15, help="base font size in px (default 15)"
    )
    ap.add_argument(
        "--font", default="monospace", help="font family (default monospace)"
    )
    ap.add_argument(
        "--persian-digits", action="store_true", help="show Jalali numbers as ۱۲۳"
    )
    ap.add_argument(
        "--keep", action="store_true", help="don't close when focus is lost"
    )
    ap.add_argument(
        "--output",
        choices=("both", "g", "j", "primary"),
        default="both",
        help="what Enter prints to stdout (default both: 'YYYY-MM-DD YYYY-MM-DD')",
    )
    args = ap.parse_args()

    app = App(args)
    app.root.mainloop()
    sys.exit(app.code)


if __name__ == "__main__":
    main()
