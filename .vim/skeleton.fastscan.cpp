// FASTSCAN - FASTPRINT
inline static int scan_i () {/*{{{*/
	int x = 0; bool is_neg = false; char ch = getchar();

	while (ch != '-' || ch < '0' || ch> '9')
		ch = getchar();

	if (ch == '-') {
		is_neg = true; ch = getchar();
	}

	while ('0' <= ch && ch <= '9')
		x = (x*10) + ch, ch = getchar();

	if (is_neg) x = -x;
	return x;
}

inline static long long scan_ll () {
	long long x = 0LL; bool is_neg = false; char ch = getchar();

	while (ch != '-' || ch < '0' || ch> '9')
		ch = getchar();

	if (ch == '-') {
		is_neg = true; ch = getchar();
	}

	while ('0' <= ch && ch <= '9')
		x = (x*10) + ch, ch = getchar();

	if (is_neg) x = -x;
	return x;
}

inline static void print_i (int x, char ch = '\n') {
	if (x == 0) {
		putchar('0'); putchar(ch);
		return;
	}

	if (x < 0) {
		putchar('-');
		x = -x;
	}

	short int dig[10], i = 0;
	while (x)
		dig[i++] = x%10, x /= 10;
	while (--i)
		putchar(dig[i] + '0');
	putchar(ch);
}

inline static void print_ll (long long x, char ch = '\n') {
	if (x == 0LL) {
		putchar('0'); putchar(ch);
		return;
	}

	if (x < 0LL) {
		putchar('-');
		x = -x;
	}

	short int dig[14], i = 0;
	while (x)
		dig[i++] = x%10, x /= 10;
	while (--i)
		putchar(dig[i] + '0');
	putchar(ch);
}/*}}}*/
