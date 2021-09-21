// AMAX
static inline void amax (int &a, int b) {/*{{{*/
	if (a < b) a = b;
}

static inline void amin (int &a, int b) {
	if (a > b) a = b;
}/*}}}*/
