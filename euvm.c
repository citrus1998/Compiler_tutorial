#include <stdio.h>
#include <stdlib.h>

/*** 各機械語のオペコード ***/
#define op_PRINT 10
#define op_NEG   11
#define op_ADD   20
#define op_SET   30

typedef double num_t;
#define print(reg) printf("%f\n", reg)

int main()
{
        int op;
        int x, y;
        num_t n;     /* 数値用作業変数 */
        num_t R[10]; /* レジスタ用配列 */

        while (op = getchar(), op != EOF) {
                switch (op) {
                case op_PRINT: /* レジスタの表示 */
                        x = getchar();
                        print(R[x]);
                        break;
                case op_NEG: /* 符号反転 */
                        x = getchar();
                        R[x] = -R[x];
                        break;
                case op_ADD: /* 加算 */
                        x = getchar(); y = getchar();
                        R[x] = R[x] + R[y];
                        break;
                case op_SET: /* レジスタへの数値代入 */
                        x = getchar();
                        fread(&n, sizeof(n), 1, stdin);
                                /* 数値の内部形式入力 */
                        R[x] = n;
                        break;
                default: /* 予定外のコードを読み込んだらエラー終了 */
                        fprintf(stderr, "error: bad op-code(%d)\n", op);
                        exit(1);
                }
        }
        return 0;
}
