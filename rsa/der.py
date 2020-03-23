import sys
import asn1

def pretty_print(input_stream, output_stream, indent=0):
     """Pretty print ASN.1 data."""
     while not input_stream.eof():
         tag = input_stream.peek()
         if tag.typ == asn1.Types.Primitive:
             tag, value = input_stream.read()
             print('>', tag, value)
         elif tag.typ == asn1.Types.Constructed:
             print(tag)

             input_stream.enter()
             pretty_print(input_stream, output_stream, indent + 2)
             input_stream.leave()

encoded_bytes = open("key.dat", "rb").read()
print(encoded_bytes)

decoder=asn1.Decoder()
decoder.start(encoded_bytes)

pretty_print(decoder, sys.__stdout__)

print(decoder.read())
print(decoder.read())
print(decoder.read())
print(decoder.read())
print(decoder.read())


