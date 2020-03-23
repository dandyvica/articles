---
title: Understanding public/private RSA keys 
published: true
tags: #rsa #tutorial #cryptography
cover_image: https://thepracticaldev.s3.amazonaws.com/i/ow32pah6rljoifu2kyxs.jpg
---

I was often baffled by the concept of public/private key used in cryptosystems. There're lots of resources online explaining this feature, but I thought the best way to understand was to unravel its mathematical foundation to utterly understand its roots. 

This is why I wrote this article. Due to the non-support (yet) for Latex formulas here in dev.to markdown, I simply wrote some slides using _MarpIt_ and just converted them to jpegs using _Gimp_.

# Public key cryptography inception

In 1976, Whitfield Diffie and Martin Hellman wrote a seminal article (_New Directions in Cryptography_) where they first envisioned a public/private key for encryption and digital signature framework. But the didn't give the implementation details. It's only in 1977 that Ron Rivest, Adi Shamir, and Leonard Adleman (MIT scientists, hence the RSA acronym)  described a comprehensive algorithm to generate key pairs.

# Mathematical background

![Alt Text](https://thepracticaldev.s3.amazonaws.com/i/i2nsvnhv12czpzp552tm.jpg)
![Alt Text](https://thepracticaldev.s3.amazonaws.com/i/4nd42bpzj39a0tx6cizd.jpg)
![Alt Text](https://thepracticaldev.s3.amazonaws.com/i/2z679pqknwac6ktq9kz2.jpg)
![Alt Text](https://thepracticaldev.s3.amazonaws.com/i/apvk97fli40apcvxzhg4.jpg)

# Using *OpenSSL* to generate a key pair

_openssl_ can be used to generate a cryptographic ecosystem. The following examples use a minimum key size of 512 bits, which is the smallest key possible.

* generate 512-bit RSA keys (all above values like _n_, _p_, _q_, ...)

```command
$ openssl genrsa -out key512.pem 512
```

The _key512.pem_ PEM file is a standard for holding RSA keys, which is a Base64-encoded version of all the RSA keys:

```text                                   
-----BEGIN RSA PRIVATE KEY-----
MIIBOwIBAAJBAJ1qU1j/T9FjOsvLr9ZvHUft4D8oFzOaRUw0OKonvAEessaMEG/s
VlNTkkl3Im6ok9HMxOyLJdEXl8bctJV/Oi8CAwEAAQJAMJpir6js8R6tSb1TRmc6
aDoXMgjj2Qf5+4RoNolcMA/ZdgjjKc1ef1xgXIxIai6SYCrqdJcMyJiPbnBiOBjq
AQIhAMlz4jsRAS8sYqQadD+S9T/eAcQTvJr2hKap+93JqWMvAiEAyAnmrxd7ecgO
wM3g9KpZBzmmaGEOL8TCO3O+qNCt2QECIQCvw6fzGRcLbZJy05Hxlerc2np39TBt
lACQ2WajT7u2iQIhALPwdBm8Pc3mL58vktODCGJ/cTkjVOeTTkS8cRzZ2ggBAiBG
7C8uqc37EV7GgyOtLLH+aSW9HZBzKiCqbVdUE7a1EQ==
-----END RSA PRIVATE KEY-----
```

PEM files are base64 encoded versions of DER encoded data. A header and footer are inserted around the data to mark meaningful data in between.
DER is a pretty cryptic standard which is part of the ASN.1 one, which is itself a data description language. Following is the structure of the DER data found in a PEM file:

```
RSAPrivateKey ::= SEQUENCE {
  version           Version,
  modulus           INTEGER,  -- n
  publicExponent    INTEGER,  -- e
  privateExponent   INTEGER,  -- d
  prime1            INTEGER,  -- p
  prime2            INTEGER,  -- q
  exponent1         INTEGER,  -- d mod (p-1)
  exponent2         INTEGER,  -- d mod (q-1)
  coefficient       INTEGER,  -- (inverse of q) mod p
  otherPrimeInfos   OtherPrimeInfos OPTIONAL
}
```

To get DER data, using this simple command, you can get the whole Base64 data without header and footer lines:

```command
# remove first line, then last line, concatenate all lines and decode the Base64 data
tail -n +2 key512.pem | head -n -1 | tr -d '\n' | base64 -d >key.data
```

The _key512.pem_ file has all the RSA keys packed into a single file. We can view individual elements of the RSA keys:

```command
$ openssl rsa -text -in key512.pem
RSA Private-Key: (512 bit, 2 primes)
modulus:
    00:9d:6a:53:58:ff:4f:d1:63:3a:cb:cb:af:d6:6f:
    1d:47:ed:e0:3f:28:17:33:9a:45:4c:34:38:aa:27:
    bc:01:1e:b2:c6:8c:10:6f:ec:56:53:53:92:49:77:
    22:6e:a8:93:d1:cc:c4:ec:8b:25:d1:17:97:c6:dc:
    b4:95:7f:3a:2f
publicExponent: 65537 (0x10001)
privateExponent:
    30:9a:62:af:a8:ec:f1:1e:ad:49:bd:53:46:67:3a:
    68:3a:17:32:08:e3:d9:07:f9:fb:84:68:36:89:5c:
    30:0f:d9:76:08:e3:29:cd:5e:7f:5c:60:5c:8c:48:
    6a:2e:92:60:2a:ea:74:97:0c:c8:98:8f:6e:70:62:
    38:18:ea:01
prime1:
    00:c9:73:e2:3b:11:01:2f:2c:62:a4:1a:74:3f:92:
    f5:3f:de:01:c4:13:bc:9a:f6:84:a6:a9:fb:dd:c9:
    a9:63:2f
prime2:
    00:c8:09:e6:af:17:7b:79:c8:0e:c0:cd:e0:f4:aa:
    59:07:39:a6:68:61:0e:2f:c4:c2:3b:73:be:a8:d0:
    ad:d9:01
exponent1:
    00:af:c3:a7:f3:19:17:0b:6d:92:72:d3:91:f1:95:
    ea:dc:da:7a:77:f5:30:6d:94:00:90:d9:66:a3:4f:
    bb:b6:89
exponent2:
    00:b3:f0:74:19:bc:3d:cd:e6:2f:9f:2f:92:d3:83:
    08:62:7f:71:39:23:54:e7:93:4e:44:bc:71:1c:d9:
    da:08:01
coefficient:
    46:ec:2f:2e:a9:cd:fb:11:5e:c6:83:23:ad:2c:b1:
    fe:69:25:bd:1d:90:73:2a:20:aa:6d:57:54:13:b6:
    b5:11
writing RSA key
-----BEGIN RSA PRIVATE KEY-----
MIIBOwIBAAJBAJ1qU1j/T9FjOsvLr9ZvHUft4D8oFzOaRUw0OKonvAEessaMEG/s
VlNTkkl3Im6ok9HMxOyLJdEXl8bctJV/Oi8CAwEAAQJAMJpir6js8R6tSb1TRmc6
aDoXMgjj2Qf5+4RoNolcMA/ZdgjjKc1ef1xgXIxIai6SYCrqdJcMyJiPbnBiOBjq
AQIhAMlz4jsRAS8sYqQadD+S9T/eAcQTvJr2hKap+93JqWMvAiEAyAnmrxd7ecgO
wM3g9KpZBzmmaGEOL8TCO3O+qNCt2QECIQCvw6fzGRcLbZJy05Hxlerc2np39TBt
lACQ2WajT7u2iQIhALPwdBm8Pc3mL58vktODCGJ/cTkjVOeTTkS8cRzZ2ggBAiBG
7C8uqc37EV7GgyOtLLH+aSW9HZBzKiCqbVdUE7a1EQ==
```

This includes the modulus (also referred to as public key and _n_), public exponent (also referred to as _e_ , default value is 65537), private exponent (_d_), and primes used to create keys (_prime1_, also called _p_, and _prime2_, also called _q_).

The following Python3 snippet can be used to convert hex integer to int:

```python
""" convert hex string integer to int """
def convert(n: str) -> int:
    # get rid of ':', spaces and newlines
    hex = n.replace(":", '').replace('\n','').replace(' ','')
    return int(hex,16)
```

Then, we can extract integer values for the previous OpenSSL data:

* n = 8244510028552846134424811607219563842568185165403993284663167926323062664016599954791570992777758342053528270976182274842613932440401371500161580348160559
* p = 91119631364788082429447973540947485602743197897334544190979096251936625222447
* q = 90480063462359689383464046547151387793654963394705182576062449707683914045697
* d = 2545549238258797954286678713888152865623498585866759298032549597771444725977268190722532488574321463855938811396613702406984581214587037347197409962813953

Hope this helps !

> Photo by Mika Baumeister on Unsplash





