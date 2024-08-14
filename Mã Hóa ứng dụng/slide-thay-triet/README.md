# Giới thiệu
Security + Machine Learning (AI)
- DeepFake
- CheapFake
- Adversarial attack
- Malware
- GAN

Dữ liệu VS thông tin: Data->information->knowledge->wisdom. Information Leak: dễ leak hơn data do có thể suy diễn từ thông tin phụ (side channel).

Thuật ngữ:
- Cryptography (xây) + Cryptanalysis (phá) = Cryptology
- Security
- Steganography: ẩn dữ liệu
- Digital Forensic: pháp chứng số.

4 + 1 problems => security
- Confidentiality/secrecy
  - Giữ bí mật dữ liệu.
  - Lưu
- Integrity: Toàn vẹn dữ liệu
- Authentication: xác thức/chứng thực (Identity - login vào máy tính). VD: token, biometric,... Chứng thực cho nội dung bất kỳ (digital signature,..).
  - Kiểm tra nguồn gốc
  - Kiểm tra danh tính
  - Kiểm tra nội dung
  - Digital Signature + Hash
- Non-repudiation: 
  - Chống thoái thác trách nhiệm. 
  - Digital Signature
  - VD: đăng ký môn sau đó bị mất => chứng minh được lỗi do ai.
- Privacy: tính riêng tư (hướng tới thông tin). 2002: metric về anonimity (tính vô danh) trong hội nghị PETS (Privacy enhancing technology symposium). GDPR

Authorize (AuthZ) vs Authentication (AuthN)

# Mã hoá
Hai thao tác cơ bản cho mã hoá:

- Transposition: đổi vị trí, không đổi cách biểu diễn ký tự.
- Substitution: đổi cách biểu diễn ký tự

Symmetric Cryptosystem (mã hoá đối xứng) chỉ dùng hai phép transposition + substitution.
=> Abstract Algebra (the design of Rijndael)

**NGUYÊN LÝ QUAN TRỌNG NHẤT**: Không bao giờ cho phép có thể chắc chắn 100% là làm cùng 1 việc với cùng 1 tình huống bằng cùng 1 phương pháp với cùng 1 môi trường và bộ tham số trên cùng dữ liệu đầu vào mà kết quả chắc chắn 100% giống nhau.
=> Tránh replay attack. Bao giờ cũng có 1 lượng random/salt

Frequency attack: chữ e xuất hiện nhiều nhất trong tiếng anh => thế ký tự xuất hiện nhiều nhất.

Một hệ thống mã hoá có 5 thành phần:
- Tập ký hiệu đầu vào $P$ (plaintext).
- Tập ký hiệu đầu ra $C$ (ciphertext).
- Tập giá trị các khoá $K$ (key).
- Quy tắc mã hoá $E$.
- Quy tắc giải mã $D$.

## Mã hoá đối xứng (Symmetric Cryptosystem)
$Z_m$: cộng trừ nhân chia trên số nguyên nhưng có modulo $m$. Nếu muốn chia được thì số chia phải nguyên tố cùng nhau với $m$.
- Công thức $\phi(n)$ để tính số lượng các phần tử từ $1$ đến $n-1$ nguyên tố cùng nhau với $n$.

Secret: có thể chia sẻ được trong nhóm, private: chỉ mình mình biết.

Quy tắc mã hoá $e_k$ phải là **song ánh**.
- Mã hoá Atbash: `c[i] = c[n - i]`
- Mã hoá Caesar: `c[i] = c[(i + 3) %n]`
- Shift cipher: `c[i] = c[(i + k) %n]`
- Vigenere cipher: chia thành từng đoạn, mỗi đoạn có $k$ khác nhau.
- Mã hoá Hill: matrix multiplication. $e_k(x) = xk$, $d_k(y) = yk^{-1}$.
- Mã hoá hoán vị

Block cipher vs Stream cipher: Block gom theo từng khối, stream nhận nhiêu mã nhiêu.

Product cipher: kết hợp nhiều thuật toán (thường không bảo mật mạnh) để tạo ra một thuật toán mới bền vững.

Hệ thống mã hoá AN TOÀN TUYỆT ĐỐI (perfectly secure) khi quan sát kết quả mã hoá (cipher text) cũng không rút ra được điều gì thú vị về input (plaintext cũng như khoá đã dùng).
=> Information Gain = 0. $p(P = x) = p(P = x | C = y) \forall y$

- DES: data encryption standard
- AES: Advanced Encryption Standard

Cả hai đều là block cipher

Round key (sub key): khoá sinh ra từ khoá ban đầu, có quy luật

Kiến trúc chu kỳ mã hoá:
- Kiến trúc Feistel Network: DES, Blowfish
- Kiến trúc SPN (Substitution - Permutation - Network): AES

### DES
- Block cipher
- Key: 56 bit
- Block: 64 bit

### AES
- Block: 128 bit
- Key: > 128
- Rijndael: 9 biến thế
  - Block: 128/192/256 bit
  - Key: 128/192/256 bit
- AES: 3 cơ hội
  - Block: 128 bit
  - Key: 128/192/256 bit

S-box: Substitution box = Lookup table

Baud: số lần đổi trạng thái

- Vấn đề:
  - Làm lộ một số pattern trong kết quả sau khi mã hoá
  - Mất block/đảo 2 block/lặp block => nếu có thể cho phép phát hiện tình hình bất thường
  - Cô lập lỗi

Mode of operation:
- Electronic codebook (ECB): chia thành từng block, dùng 1 private key mã hoá độc lập từng block.
- Cipher-block chaining: giống ECB nhưng input không truyền thẳng plaintext vào mà xor plaintext với dữ liệu đã mã hoá ở block trước => block thứ $i$ phụ thuộc vào block $1,\ldots,i-1$. Block đầu tiên random vector để xor, vector này gọi là $IV$ (Initialization Vector).
  - Encode: $C_i = E_K(P_i \oplus C_{i-1})
  - Decode: $D_K(C_i) \oplus C_{i-1} = P_i$
  - Không song song hoá được do phải làm tuần tự (input trước phụ thuộc công thức sau) khi mã hoá, tuy nhiên khi giải mã thì có thể song song.
- Propagating cipher-block chaining (PCBC)
- Cipher feedback: không bảo vệ bằng cách bỏ vào encrytion mà xor với đại lượng ngẫu nhiên => stream cipher 
  - Encode: $C_0=IV$, $C_i = P_i\oplus E_K(C_{i-1})$
  - Decode: $P_i = E_K(C_{i-1}) \oplus C_i$
- Output feedback

Câu hỏi thường gặp: 
- Vẽ mô hình encode/decode
- Decode như thế nào?
- Encode hay decode có song song hoá được không?
- Phân tích quá trình lan truyền lỗi

Quy tắc:
1. Xor với gì khi mã hoá thì khi giải mã xor thêm một lần nữa.
2. Encrypt bằng gì thì decrypt bằng cái đó

Lan truyền lỗi:
- XOR: lỗi bit nào => lỗi bit tương ứng ở kết quả
- Encrypt/Decrypt => không dám tin bất kỳ bit nào trong kết quả.

Padding:
- Có thể cần ranh giới để phân biệt giữa dữ liệu padding và dữ liệu đang có.
- Luôn padding để luôn luôn gỡ khi giải mã

## Mã hoá bất đối xứng (Asymmetric Cryptosystem)
Mã hoá đối xứng:
- Nhanh: thao tác mã hoá đơn giản
- Khoá ngắn: (256 bit)
- Vấn đề: làm sao chia sẻ, phân phối khoá (key distribution)
- Secret key

Mã hoá bất đối xứng:
- Chậm (thao tác mã hoá phức tạp, x^a mod n)
- Khoá dài (vài nghìn bit)
- Dễ dàng trao đổi/phân phối khoá
- Key Pair = <Public Key, Private Key>

Idea chính: Diffie + Hellman
Hiện thực hoá: Rivest, Shamir, Adleman

RSA:
- Chọn ra 2 số nguyên tố lẻ phân biệt
- Tính $n = p \times q$
- Tính $\texttt{phi}(n) = (p^1-p^0) \times (q^1-q^0)$ (số lượng các số tự nhiên < n  và nguyên tố cùng nhau với $n$).
- Chọn $a$ nguyên tố cùng nhau với $phi(n) = (p - 1)(q-1)$. Tính

Một số cách tấn công:

# Digital signature
Digital signature vs e-signature
- Digital: Tạo ra 1 dãy bit dùng để authorize (không giống)
- Electronic: Tạo ra chữ ký giống với chữ ký tay (phải qua các thao tác authorize)

Các mức độ phá vỡ:
- Total break: với mọi document người khác có khả năng giả chữ ký
- Selective forgery: với mọi document, người tấn công có khả năng > 0 tạo ra được chữ ký hợp lệ
- Existential forgery: tồn tại ít nhất một document để người khác có thể tạo ra chữ ký hợp lệ (chỉ ra cụ thể)

Phân loại cách tấn công:
- Key-only: chỉ biết key
- Message:
  - Known-message: đã biết tập văn bản có chữ ký, không được chọn document
  - Chosen-message: tập văn bản có chữ ký, được chọn document (non-adaptive)
  - Adaptive chosen-message attack: có thể sử dụng người ký như một oracle (có thể tương tác)

Chiến lược ký:
- Khôi phục dữ liệu: chỉ gửi dữ liệu, văn bản có thể restore lại
- Đính kèm: rút đặc trưng + ký + đinh kèm văn bản gốc.

Note: chỉ ký tổng thể, không ký từng phần để tránh mất tính an toàn tổng thể (mất đoạn, đảo đoạn, lặp doặn)

Kiểm tra chữ ký thật vs kiểm tra chữ ký phù hợp

Quy trình tạo chữ ký:
1. thông điệp M được hash -> m (digest message, thường có độ dài cố định)
2. Dùng private key của người gửi để ký trên m --> chữ ký s
3. gửi (m,s) cho người nhận

Quy trình kiểm tra chữ ký:
1. Dùng public key của người gửi để giải mã chữ ký s. Nếu giải mã thành công thì tin là chữ ký s do người gửi ký => chữ ký "thật"
2. Thông điệp m đã nhận sẽ được hash -> m*.
3. So sánh m* và nội dung sau khi giải mã s (so sánh m với m*) => chữ ký "phù hợp"

Digital indentity

Bài toán khó:
- Phân tích ra thừa số nguyên tố (RSA)
- Logarithm rời rạc trên trường hữu hạn (Diffie Hellman, ElGamal)
- Đường cong Eliptic (EDSA)

# Hàm băm và mật mã (Hash & MAC)
- H là hàm nén mất thông tin

Hàm băm có 3 tính chất:
- Oneway (một chiều): rất khó tìm nếu biết $H(x)$, thường có độ phức tạp $O(2^n)$
- Second-preimage (): cho $x$ rất khó tìm $x*$ khác x sao cho $H(x) == H(x*)$ (tránh nguy cơ tận dùng hai file cùng một signature). Thường dpt là $O(2^n)$
- Collision: rất khó tìm một cặp $x$ và $x*$ khác nhau sao cho $H(x) == H(x*)$ => birthday paradox

Kiến trúc Merkle-Damgard
Kiến trúc Matyas-Meyer-Oseas
Kiến trúc Davies-Meyer
Kiến trúc Miyaguchi-Preneel

MD4, MD5: output 128 bit
SHA1: output 160 bit
SHA2 (family): SHA224/256/384/512
SHA3: Keccak 512

MAC (message authentication code): chỉ giúp người nhận verify nguồn gốc, không giúp người nhận non-repudiation (bên kia chối thì không làm gì được).

Image hash: hai hình gần giống nhau sẽ có hash gần giống nhau

Vấn đề của Asymmetric key: kiểm tra khoá thực sự của ai

# Digital Certificate
Chứng chỉ số (digital certificate) => giải quyết được vấn đề MIM (man in the middle).

Gồm ba phần:
- Chủ của key
- Public key của chủ
- Chữ ký tổ chức thứ 3 được tin tưởng

Chuẩn X.509: chuẩn format của chứng chỉ

Certificate Authority System (CA): một tổ chức thứ ba đáng tin cậy. Độc lập, không chịu sự tác động. Các chức năng cơ bản: tạo mới, cấp phát, tìm kiếm, kiểm tra, huỷ chứng nhận.

Vấn đề: làm sao tin certificate của CAS => để sẵn trong hệ điều hành, đến trực tiếp để lấy

Zero knowledge proof: cố gắng chứng minh cho người khác tin nhưng không làm rò rỉ thông tin cho người khác biết
- Challenge: A kiểm tra B thật sự là chủ sở hữu của public key K tương ứng private key k
  1. A phát sinh ngẫu nhiên R, A gửi cho B, yêu cầu ký lên R và gửi lại chữ ký cho A. A dùng public key K để kiểm tra chữ ký. Nếu chữ ký thật và phù hợp thì A tin B sở hữu K và k
  2. A phát sinh ngẫu nhiên R, A mã hoá bằng public key K và gửi cho B. B dùng private k để giải mã và trả lời các câu hỏi của A liên quan đến R

Khi huỷ chứng nhận: đánh dấu tình trạng là huỷ và phải ghi nhận phiếu huỷ (CRL = Certificate Revocation List)

Verify theo mô hình phân cấp: duyệt cây, không biết => hỏi cha => cha không biết => hỏi con

# SSL
Authentication vs Authorization:
- Authentication: WHO (xác định đây là ai)
- Authorization: RIGHT (phân quyền)

Nhu cầu:
- Data protection: mã hoá dữ liệu truyền từ A đến B ==> khoá trong pp mã hoá đối xứng => làm sao chia sẻ khoá (session key/secret key)
- Authentication: gửi cho ai

TLS xây dựng gần giống SSL, nguyên tắc thiết kế giống nhau nhưng cài đặt chi tiết sẽ có khác.

Công bằng: A kiểm tra được B là ai thì B cũng có thể kiểm tra A là ai

Trước khi gửi khoá cần giai đoạn handshake (quan trọng nhất)

```
1. Client hello: những option mà client có hỗ trợ để server có thể chọn lựa và quyết định hình thức. Các field chú ý (timestamp, client version, random, session id, cipher suites (những bộ thuật toán hỗ trự), compression method (những thuật toán nén hỗ trợ)). Random chiếm 32 bytes ngẫu nhiên, dùng để kiểm tra server có là thật và đang còn sống không hay bị replace.
- Vấn đề: man in the middle giảm phiên bản protocol xuống để thuật toán yếu hơn.
2. Server hello: random server, version và thuật toán mà server chọn để client và server cùng dùng (theo danh sách server nhận được từ client). 
3. Serverkey exchange: Do giả định client và server chưa biết gì nhau nên phải gửi định danh. Server có thể gửi publickey của server hoặc certificate của server (có thể định danh so với public key). Lấy tất cả thông số server key params, kết hợp với random client và random server, sau đó hash cả ba, cuối cùng dùng server private key kí và gửi cho client.
- Câu hỏi: tại sao cần kí trên random server. Có thể client bị compromise và random client không còn ngẫu nhiên nữa, do đó nên kèm theo lượng ngẫu nhiên do chính mình tạo ra.
4. Server hellodone: kết thúc công việc server
5. Client key exchange: client tự phát sinh khoá (session key/secret key) cho lần làm việc này. Client gửi cho server, mã hoá cho public key của server.
(6). Certificate verify: nếu server yêu cầu certificate request (ở sau bước 3) thì client gửi certificate cho server.
7. Client finish: Hash tất cả thông tin random vừa nãy gửi cho server. master secret = hash premaster secret + client random + server random lại rồi gửi
```

Chứng thực trong quá trình record: nếu client k có certificate thì sau khi handshake sẽ nhập username + password để authenticate. 

Điều chỉnh SSL: gửi luôn version và secret (mã hoá bằng public key của server) cho server, server dùng private key mở ra để verifyy lại version có giống với version ở clienthello không, nếu không thì ngắt kết nối vì lúc đó đã bị tấn công. Note: không mã hoá riêng version với secret vì attacker có thể thay mã hoá của version độc lập.

Tại sao master secret cần hash 2 lần?

Đề thi cuối kỳ chắc chắn có SSL

# Anonymity và Privacy
Anonimity: làm hành động nhưng không muốn mọi người biết mình thực hiện hành động đó
- Thuật toán của giáo sư David Chaum:
  - A muốn gửi tới B lá thư M
  - A gửi cho C, C gửi cho B
  - A gửi cho C `E_KC(Address = B, E_KB(M))`
  - C decrypt ra biết được adddress là B, C gửi B nội dung, B dùng khoá mở
  - Nguyên tắc onion (củ hành): bóc từng lớp ra tới khi có nội dung.
- Mixed network:
  - Nhiều object cần chờ (relay) để được chuyển đi
  - KHÓ có thể liên kết object đi ra tương ứng với object đi vào nào
  - Threshold Mix: đến đúng số lượng cần thì giao hàng => không ai gửi thì không gửi đi được 
  - Timed Mix: đủ thời gian thì giao hàng =>
  - Pool Mix: Đến thời gian/số lượng cần, thì chỉ chọn ra $p\%$ thông điệp để gửi
  - Tấn công: Flooding (N - 1 attack), kiểm soát các lá thư, dồn thư rác vào rất nhiều để biết khi nào thư mình được gửi ra => biết được $N-1$ lá, lá còn lại là của nạn nhân.
  - Binomial Mix: đến thời gian/số lượng cần, mỗi thông điệp được chọn với xác suất $p\%$ được gửi đi
- TOR:
  - Nhiều người dùng => nhanh hơn
- Nguyên tắc: lẩn trong đám đông
- k-anonimity: mọi item đều bị nghi ngờ chung với ít nhất k - 1 item khác. VD:

Privacy: cao hơn anonimity, bảo vệ mọi thứ, kể cả thông tin và hành động

# Ôn tập
Đề đóng, 90 phút
## Mode of operation
- Cho 1 mode of operation khi mã hoá => vẽ/viết công thức mã hoá (0.5đ)
  - XOR: ưu tiên cao hơn
  - Encrypt => Decrypt
- Có thể xử lý song song trong mã hoá/giải mã không? (0.5đ)
- Error propagating (0.5đ):
  - XOR: sai bit nào trong input => sai cùng bit đó trong output
  - Encrypt/Decrypt: sai bit trong input => không tin tưởng được giá trị nào trong output (bit nào cũng có nguy cơ bị sai)
- Tính $a^{-1} mod n$ (1đ)
## Authentication protocol
Kerberous, SSL (1.5-2đ)
- Kiểm tra người nào đó có phải chủ sở hữu public key $K$ (tương ứng private key $k$) hay không => challenge 
  - Phát sinh random $X$, mã hoá thành $C$ và yêu cầu người đó giải mã $C$.
  - Phát sinh ra random X, yêu cầu người đó ký lên X.
  - Chỉ nói lên là người đó sở hữu public key.
- Muốn biết B tên gì:
  - Người đó sở hữu public key K
  - Theo certificate hợp lệ thì K là public key của người đó
- Random là mọi thứ được 1 party phát sinh ngẫu nhiên

Kerberos:
- Nguyên tắc giới thiệu:
- Nguyên tắc không cần kiểm tra, đúng thì hiểu, không thì thôi
- B quen cả A và C => 
- B và A dùng khoá KAB => 
- B và C dùng khoá KBC => 
- B giới thiệu để A và C nói chuyện với nhau => 
- B phát sinh KAC
- B gởi cho A hai gói tin:
  - M1: mã hoá bằng KAB (vì B muốn A đọc được), chứa KAC
  - M2: mã hoá bằng KBC (vì B muốn C đọc được), A sẽ gửi cho C, chứa KAC và lời giới thiệu về A cho C
## Câu cuối: câu hỏi ngoài

