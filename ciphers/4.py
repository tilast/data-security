def encrypt(file_in, message, out):
    byte_arr = bytearray(file_in.read())
    byte_message = bytearray(message.read())
    print(len(byte_message).to_bytes(2, byteorder='little'))
    curr_byte = 2000
    message_len_bytes = len(byte_message).to_bytes(2, byteorder='little')
    for i in range(len(message_len_bytes)):
        print("len", message_len_bytes[i])
        for j in range(8):
            mask = 1
            byte_arr[curr_byte] = (byte_arr[curr_byte] | mask) if (message_len_bytes[i] & (1 << j)) != 0 else (byte_arr[curr_byte] & ~mask)
            # print(byte_arr[curr_byte])
            curr_byte += 1

    for i in byte_message:
        for j in range(8):
            mask = 1
            byte_arr[curr_byte] = byte_arr[curr_byte] | mask if i & (1 << j) else byte_arr[curr_byte] & ~mask
            curr_byte += 1
    out.write(byte_arr)
    file_in.close()
    out.close()


def decrypt(out):
    out_file = open(out, "rb")
    out_bytes = bytearray(out_file.read())
    n = 0
    curr_byte = 2000
    for i in range(2):
        sum_i = 0
        for j in range(8):
            mask = 1
            byte0 = out_bytes[curr_byte] & mask
            sum_i += byte0 << j
            curr_byte += 1
        n += sum_i << i*8
    # print(n)
    out = bytearray()
    for i in range(n):
        sum_i = 0
        for j in range(8):
            mask = 1
            byte0 = out_bytes[curr_byte] & mask
            sum_i += byte0 << j
            curr_byte += 1
        out.append(sum_i)
    print(out)



def main():
    f = open("petuh.bmp", "rb")
    info = open("input.txt", "rb")
    out = open("petuh-out.bmp", "wb")
    encrypt(f, info, out)
    decrypt("petuh-out.bmp")


if __name__ == "__main__":
    main()
