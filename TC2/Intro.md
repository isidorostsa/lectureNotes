In digital coms we turn bits into predefined signals called [[Symbol]] and we transmit those instead. There are many ways for this conversion: #TODO 

Some performance metrics:

- [[SNR]]  
- [[SINR]] 
- [[BER]]
- [[Power Efficiency]]
- [[Spectral Efficiency]]
- [[Bit Rate]]
- [[Outage Probability]]

Information is carried through a specific course, the general idea is:
```mermaid
flowchart TB;
A["Info source (x(t) or x_n)"];
B["source encoding"];
C["encryption (a_n)"];
D["Chanel encoding (y_n)"];
E["Modulation (s(t))"];
F["Chanel"];

A-->B-->C-->D-->E-->F;
_1["TimeDelay"] -->F;
_2["Change of phase/amplitude"]-->F;
_3["Noise (n(t))"]-->F;
_4["interference"]-->F;

interm["r(t) = s(t) + n(t)"];

E_prime["Demodulation"];
D_prime["Chanel Decoding (yhat_n)"];
C_prime["Decryption (ahat_n)"]
B_prime["source decoding"]
A_prime["Information regained"]

F---interm-->E_prime-->D_prime-->C_prime-->B_prime-->A_prime;
```

- Source: the output of a keyboard
- Source Encoding: compression
- Chanel Encoding: encode with an error correction pattern
- [[Modulation]]: turn a bitstream into [[Symbol]]

This subject is essentially a study of [[modulation]] and [[Symbol|symbol]] selection.