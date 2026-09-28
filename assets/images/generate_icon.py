import zlib
import struct

def make_png(width, height, color_bg, square_color):
    # color_bg: (R, G, B), square_color: (R, G, B)
    # 1024x1024 icon
    # Orange background: #FF7900 = (255, 121, 0)
    # In center: a neat square (Orange logo signature style)
    raw_data = bytearray()
    
    sq_size = int(width * 0.45) # 460px
    sq_start_x = (width - sq_size) // 2
    sq_start_y = (height - sq_size) // 2
    sq_end_x = sq_start_x + sq_size
    sq_end_y = sq_start_y + sq_size

    for y in range(height):
        raw_data.append(0) # filter type none
        for x in range(width):
            if sq_start_x <= x < sq_end_x and sq_start_y <= y < sq_end_y:
                # Square in center
                raw_data.extend(square_color)
            else:
                raw_data.extend(color_bg)

    def chunk(tag, data):
        c = tag + data
        crc = zlib.crc32(c) & 0xffffffff
        return struct.pack('>I', len(data)) + c + struct.pack('>I', crc)

    header = b'\x89PNG\r\n\x1a\n'
    ihdr_data = struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0) # 8-bit truecolor RGB
    ihdr = chunk(b'IHDR', ihdr_data)
    idat = chunk(b'IDAT', zlib.compress(bytes(raw_data), 9))
    iend = chunk(b'IEND', b'')

    return header + ihdr + idat + iend

if __name__ == '__main__':
    # Orange brand color #FF7900 = (255, 121, 0)
    # Center accent square: Solid White (255, 255, 255) or Core Black (0, 0, 0)
    png_bytes = make_png(1024, 1024, (255, 121, 0), (0, 0, 0))
    with open('assets/images/app_icon_1024.png', 'wb') as f:
        f.write(png_bytes)
    print("Successfully generated assets/images/app_icon_1024.png (1024x1024)")
