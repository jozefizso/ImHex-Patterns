#include <type/types/win32.pat>

using ALG_ID = u32;

struct PUBLICKEYSTRUC {
    BYTE   bType;
    BYTE   bVersion;
    WORD   reserved;
    ALG_ID aiKeyAlg;
};

using BLOBHEADER = PUBLICKEYSTRUC;

struct RSAPUBKEY {
    DWORD magic;
    DWORD bitlen;
    DWORD pubexp;
};

struct PRIVATEKEYBLOB {
    PUBLICKEYSTRUC  publickeystruc;
    RSAPUBKEY rsapubkey;
    BYTE modulus[rsapubkey.bitlen/8];
    BYTE prime1[rsapubkey.bitlen/16];
    BYTE prime2[rsapubkey.bitlen/16];
    BYTE exponent1[rsapubkey.bitlen/16];
    BYTE exponent2[rsapubkey.bitlen/16];
    BYTE coefficient[rsapubkey.bitlen/16];
    BYTE privateExponent[rsapubkey.bitlen/8];
};

PRIVATEKEYBLOB StrongNamePrivateKey @ 0x00;

