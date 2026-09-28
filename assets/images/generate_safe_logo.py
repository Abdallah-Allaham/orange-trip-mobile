import zlib
import struct
import math

def make_executive_logo(size=1024):
    width = size
    height = size
    raw_data = bytearray()

    bg_color = (255, 121, 0)      # Primary Orange #FF7900
    white = (255, 255, 255)       # Crisp White #FFFFFF
    dark_accent = (220, 95, 0)    # Soft subtle depth shading

    center_x = width / 2.0
    center_y = height / 2.0
    outer_radius = width * 0.38   # Outer ring radius
    inner_radius = width * 0.32   # Inner ring radius
    core_radius = width * 0.09    # Central compass core

    for y in range(height):
        raw_data.append(0) # filter type none
        dy = y - center_y
        for x in range(width):
            dx = x - center_x
            dist = math.sqrt(dx * dx + dy * dy)
            
            is_white = False

            # 1. Outer Sleek Circular Ring
            if inner_radius <= dist <= outer_radius:
                is_white = True

            # 2. Dynamic Ascending Modern Jet/Delta Emblem (Rotated ~45 deg pointing up-right)
            # Coordinates in rotated frame:
            # Rotate by -45 degrees (rad = -pi/4)
            angle = -math.pi / 4.0
            rx = dx * math.cos(angle) - dy * math.sin(angle)
            ry = dx * math.sin(angle) + dy * math.cos(angle)

            # Delta triangle shape in rotated frame:
            # Tip at ry = -width*0.28, rx = 0
            # Wings at ry = width*0.18, rx = +/- width*0.22
            # Notch at ry = width*0.08, rx = 0
            tip_y = -width * 0.26
            wing_y = width * 0.16
            notch_y = width * 0.08
            wing_x = width * 0.20

            if tip_y <= ry <= wing_y:
                # Progress from tip to base
                t = (ry - tip_y) / (wing_y - tip_y)
                half_w = t * wing_x
                if abs(rx) <= half_w:
                    # Check if inside notch cut at back
                    if ry > notch_y:
                        notch_t = (ry - notch_y) / (wing_y - notch_y)
                        notch_half_w = notch_t * (wing_x * 0.55)
                        if abs(rx) < notch_half_w:
                            pass # notch cut
                        else:
                            is_white = True
                    else:
                        is_white = True

            # 3. Central Dynamic Compass Star / Jet Core
            if dist <= core_radius:
                is_white = True

            if is_white:
                raw_data.extend(white)
            else:
                # Add subtle circular vignette on corners for premium depth
                if dist > outer_radius * 1.25:
                    vignette = min(1.0, (dist - outer_radius * 1.25) / (width * 0.4))
                    r = int(bg_color[0] * (1.0 - vignette * 0.12))
                    g = int(bg_color[1] * (1.0 - vignette * 0.12))
                    b = 0
                    raw_data.extend((r, g, b))
                else:
                    raw_data.extend(bg_color)

    def chunk(tag, data):
        c = tag + data
        crc = zlib.crc32(c) & 0xffffffff
        return struct.pack('>I', len(data)) + c + struct.pack('>I', crc)

    header = b'\x89PNG\r\n\x1a\n'
    ihdr_data = struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0)
    ihdr = chunk(b'IHDR', ihdr_data)
    idat = chunk(b'IDAT', zlib.compress(bytes(raw_data), 9))
    iend = chunk(b'IEND', b'')

    return header + ihdr + idat + iend

if __name__ == '__main__':
    print("Generating 1024x1024 safe executive icon...")
    data_1024 = make_executive_logo(1024)
    with open('assets/images/app_icon_1024.png', 'wb') as f:
        f.write(data_1024)
    print("app_icon_1024.png saved.")

    print("Generating 512x512 safe app logo...")
    data_512 = make_executive_logo(512)
    with open('assets/images/orange_logo.png', 'wb') as f:
        f.write(data_512)
    print("orange_logo.png saved.")
