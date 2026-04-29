#!/usr/bin/env python3
from pathlib import Path
import subprocess

from PIL import Image, ImageDraw, ImageFilter, ImageFont


ROOT = Path(__file__).resolve().parents[1]
RESOURCES = ROOT / "Resources"
ICONSET = RESOURCES / "AppIcon.iconset"
SOURCE = RESOURCES / "AppIcon.png"
ICNS = RESOURCES / "AppIcon.icns"


def draw_icon(size: int = 1024) -> Image.Image:
    image = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)
    scale = size / 1024

    def box(x0, y0, x1, y1):
        return [int(x0 * scale), int(y0 * scale), int(x1 * scale), int(y1 * scale)]

    shadow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    shadow_draw = ImageDraw.Draw(shadow)
    shadow_draw.rounded_rectangle(box(112, 112, 912, 912), radius=int(190 * scale), fill=(0, 0, 0, 128))
    shadow = shadow.filter(ImageFilter.GaussianBlur(int(34 * scale)))
    image.alpha_composite(shadow)

    draw.rounded_rectangle(box(96, 88, 928, 920), radius=int(198 * scale), fill=(7, 12, 25, 255))
    draw.rounded_rectangle(box(96, 88, 928, 920), radius=int(198 * scale), outline=(38, 235, 255, 150), width=int(8 * scale))

    grid = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    grid_draw = ImageDraw.Draw(grid)
    for offset in range(176, 856, 96):
        grid_draw.line(box(offset, 174, offset, 850), fill=(26, 232, 255, 38), width=max(1, int(2 * scale)))
        grid_draw.line(box(174, offset, 850, offset), fill=(129, 82, 255, 34), width=max(1, int(2 * scale)))
    image.alpha_composite(grid)

    glow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow)
    glow_draw.ellipse(box(160, 162, 864, 866), fill=(12, 210, 255, 82))
    glow_draw.ellipse(box(300, 214, 932, 846), fill=(126, 58, 255, 64))
    glow = glow.filter(ImageFilter.GaussianBlur(int(64 * scale)))
    image.alpha_composite(glow)

    panel = box(204, 212, 820, 804)
    draw.rounded_rectangle(panel, radius=int(100 * scale), fill=(13, 22, 43, 232), outline=(72, 246, 255, 190), width=int(7 * scale))

    orbit_width = int(8 * scale)
    draw.ellipse(box(284, 290, 740, 746), outline=(36, 230, 255, 150), width=orbit_width)
    draw.ellipse(box(330, 336, 694, 700), outline=(122, 84, 255, 145), width=int(6 * scale))
    draw.arc(box(252, 258, 772, 778), start=24, end=154, fill=(68, 255, 179, 190), width=int(10 * scale))
    draw.arc(box(252, 258, 772, 778), start=205, end=338, fill=(49, 121, 255, 210), width=int(10 * scale))

    center = (512, 518)
    nodes = [
        (316, 392, (28, 170, 255, 255)),
        (710, 400, (142, 94, 255, 255)),
        (372, 676, (44, 224, 139, 255)),
        (676, 664, (255, 204, 76, 255)),
    ]
    for x, y, color in nodes:
        draw.line([center, (int(x * scale), int(y * scale))], fill=(76, 230, 255, 118), width=int(5 * scale))
        draw.ellipse(box(x - 34, y - 34, x + 34, y + 34), fill=color)
        draw.ellipse(box(x - 18, y - 18, x + 18, y + 18), fill=(245, 250, 255, 235))

    draw.ellipse(box(404, 410, 620, 626), fill=(8, 18, 36, 255), outline=(50, 242, 255, 220), width=int(8 * scale))
    draw.ellipse(box(434, 440, 590, 596), fill=(20, 41, 80, 255), outline=(125, 98, 255, 200), width=int(5 * scale))

    font = load_font(int(132 * scale))
    text = "AI"
    bbox = draw.textbbox((0, 0), text, font=font)
    text_w = bbox[2] - bbox[0]
    text_h = bbox[3] - bbox[1]
    text_pos = (int(512 - text_w / 2), int(516 - text_h / 2 - 12 * scale))
    draw.text((text_pos[0] + int(3 * scale), text_pos[1] + int(4 * scale)), text, font=font, fill=(0, 0, 0, 120))
    draw.text(text_pos, text, font=font, fill=(236, 252, 255, 255))

    draw.rounded_rectangle(box(352, 768, 672, 812), radius=int(22 * scale), fill=(36, 232, 255, 190))
    draw.rounded_rectangle(box(424, 810, 600, 866), radius=int(18 * scale), fill=(63, 92, 145, 255))

    return image


def load_font(size: int) -> ImageFont.ImageFont:
    candidates = [
        "/System/Library/Fonts/SFNS.ttf",
        "/System/Library/Fonts/Supplemental/Arial Bold.ttf",
        "/Library/Fonts/Arial Bold.ttf",
    ]
    for path in candidates:
        try:
            return ImageFont.truetype(path, size=size)
        except OSError:
            continue
    return ImageFont.load_default()


def save_iconset(source: Image.Image) -> None:
    ICONSET.mkdir(parents=True, exist_ok=True)
    sizes = {
        "icon_16x16.png": 16,
        "icon_16x16@2x.png": 32,
        "icon_32x32.png": 32,
        "icon_32x32@2x.png": 64,
        "icon_128x128.png": 128,
        "icon_128x128@2x.png": 256,
        "icon_256x256.png": 256,
        "icon_256x256@2x.png": 512,
        "icon_512x512.png": 512,
        "icon_512x512@2x.png": 1024,
    }
    for name, side in sizes.items():
        source.resize((side, side), Image.Resampling.LANCZOS).save(ICONSET / name)


def main() -> None:
    RESOURCES.mkdir(exist_ok=True)
    source = draw_icon()
    source.save(SOURCE)
    save_iconset(source)
    subprocess.run(["iconutil", "-c", "icns", str(ICONSET), "-o", str(ICNS)], check=True)
    print(ICNS)


if __name__ == "__main__":
    main()
