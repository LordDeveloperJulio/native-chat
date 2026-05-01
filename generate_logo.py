#!/usr/bin/env python3
"""Generate LinguaAI logo assets for Flutter app."""

import math
from PIL import Image, ImageDraw

SIZE = 1024
HALF = SIZE // 2

# Brand colors
BG_TOP    = (26,  26,  46)   # #1A1A2E deep navy
BG_BOT    = (108, 99, 255)   # #6C63FF indigo/violet
BUBBLE    = (255, 255, 255)  # white
ACCENT    = (108, 99, 255)   # violet dots
SPARK     = (255, 214,  0)   # #FFD600 golden spark


def lerp_color(c1, c2, t):
    return tuple(int(c1[i] + (c2[i] - c1[i]) * t) for i in range(3))


def draw_gradient_bg(draw, size):
    for y in range(size):
        t = y / size
        color = lerp_color(BG_TOP, BG_BOT, t)
        draw.line([(0, y), (size, y)], fill=color)


def draw_rounded_rect(draw, xy, radius, fill):
    x0, y0, x1, y1 = xy
    draw.rectangle([x0 + radius, y0, x1 - radius, y1], fill=fill)
    draw.rectangle([x0, y0 + radius, x1, y1 - radius], fill=fill)
    draw.ellipse([x0, y0, x0 + radius * 2, y0 + radius * 2], fill=fill)
    draw.ellipse([x1 - radius * 2, y0, x1, y0 + radius * 2], fill=fill)
    draw.ellipse([x0, y1 - radius * 2, x0 + radius * 2, y1], fill=fill)
    draw.ellipse([x1 - radius * 2, y1 - radius * 2, x1, y1], fill=fill)


def draw_speech_bubble(draw, cx, cy, w, h, tail_h, radius):
    """Draw a speech bubble pointing bottom-left."""
    half_w = w // 2
    half_h = h // 2

    x0 = cx - half_w
    y0 = cy - half_h
    x1 = cx + half_w
    y1 = cy + half_h

    draw_rounded_rect(draw, (x0, y0, x1, y1), radius, BUBBLE)

    # Tail polygon (points bottom-left)
    tx = x0 + int(w * 0.18)
    tail_points = [
        (tx, y1),
        (tx + int(w * 0.14), y1),
        (tx - int(w * 0.06), y1 + tail_h),
    ]
    draw.polygon(tail_points, fill=BUBBLE)


def draw_sparkle(draw, cx, cy, r, color):
    """Draw a 4-point sparkle star."""
    points = []
    for i in range(8):
        angle = math.radians(i * 45 - 90)
        radius = r if i % 2 == 0 else r * 0.38
        points.append((cx + radius * math.cos(angle),
                        cy + radius * math.sin(angle)))
    draw.polygon(points, fill=color)


def draw_wave_lines(draw, bx, by, bubble_w, bubble_h, n=3, spacing=38):
    """Draw stacked rounded wave lines (like text lines) inside bubble."""
    line_h = 18
    line_r = 9
    start_y = by - int(bubble_h * 0.12)

    widths  = [int(bubble_w * 0.52), int(bubble_w * 0.38), int(bubble_w * 0.46)]
    offsets = [int(bubble_w * -0.12), int(bubble_w * -0.06), int(bubble_w * -0.10)]

    for i in range(n):
        lw = widths[i]
        lx = bx + offsets[i]
        ly = start_y + i * spacing
        draw_rounded_rect(draw, (lx, ly, lx + lw, ly + line_h), line_r, ACCENT)


# ── 1. APP ICON  (1024 × 1024, gradient background) ─────────────────────────
icon = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
draw_icon = ImageDraw.Draw(icon)

draw_gradient_bg(draw_icon, SIZE)

# Speech bubble
bw, bh = 540, 380
tail = 90
brad = 56
draw_speech_bubble(draw_icon, HALF, HALF - 30, bw, bh, tail, brad)

# "Text lines" inside bubble (violet rects)
draw_wave_lines(draw_icon, HALF, HALF - 30, bw, bh)

# Golden sparkle at top-right of bubble
spark_cx = HALF + bw // 2 - 68
spark_cy = HALF - 30 - bh // 2 + 60
draw_sparkle(draw_icon, spark_cx, spark_cy, 52, SPARK)
draw_sparkle(draw_icon, spark_cx, spark_cy, 28, (255, 235, 80))  # inner glow

icon.save("/Users/juliofurtado/StudioProjects/study_english/assets/images/logo.png")
print("✓ logo.png saved (1024×1024 icon)")


# ── 2. SPLASH IMAGE  (logo on white, 500 × 500 transparent PNG) ─────────────
SPLASH_SIZE = 500
S_HALF = SPLASH_SIZE // 2

splash = Image.new("RGBA", (SPLASH_SIZE, SPLASH_SIZE), (0, 0, 0, 0))
draw_sp = ImageDraw.Draw(splash)

# Gradient circle background
circle_r = 200
for r in range(circle_r, 0, -1):
    t = 1 - r / circle_r
    col = lerp_color(BG_TOP, BG_BOT, t) + (255,)
    draw_sp.ellipse(
        [S_HALF - r, S_HALF - r, S_HALF + r, S_HALF + r],
        fill=col
    )

# Speech bubble (scaled for splash)
sbw, sbh = 260, 184
stail = 44
sbrad = 28
draw_speech_bubble(draw_sp, S_HALF, S_HALF - 14, sbw, sbh, stail, sbrad)
draw_wave_lines(draw_sp, S_HALF, S_HALF - 14, sbw, sbh, n=3, spacing=28)

# Sparkle
ssx = S_HALF + sbw // 2 - 34
ssy = S_HALF - 14 - sbh // 2 + 30
draw_sparkle(draw_sp, ssx, ssy, 26, SPARK)
draw_sparkle(draw_sp, ssx, ssy, 14, (255, 235, 80))

splash.save("/Users/juliofurtado/StudioProjects/study_english/assets/images/splash_logo.png")
print("✓ splash_logo.png saved (500×500 transparent)")
print("\nDone! Assets generated successfully.")
