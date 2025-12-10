/* vuln_examples.c
 * Intentionally vulnerable examples for educational purposes only.
 * Contains:
 *  - buffer overflow (unsafe strcpy / scanf)
 *  - format-string vulnerability
 *  - integer overflow leading to undersized allocation
 *  - use-after-free (simple illustration)
 *
 * Do NOT run this on production systems. Compile with: gcc -Wall -Wextra -o vuln_examples vuln_examples.c
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void vuln_buffer_overflow() {
    char small[16];
    printf("Enter a short string: ");
    /* Vulnerable: scanf("%s", ...) has no width limit -> can overflow `small`. */
    scanf("%s", small);
    printf("You entered: %s\n", small);
}

void vuln_strcpy_style() {
    char src[256];
    char dst[32];
    printf("Enter another string: ");
    /* Vulnerable: gets is removed from modern standards but some code still uses unsafe copy patterns.
       Here we simulate an unsafe copy using strcpy without bounds checking. */
    if (fgets(src, sizeof(src), stdin) == NULL) return;
    /* Remove newline if present */
    src[strcspn(src, "\n")] = '\0';
    /* Vulnerable: no length check before strcpy */
    strcpy(dst, src);
    printf("Copied string: %s\n", dst);
}

void vuln_format_string() {
    char buf[200];
    printf("Enter a format-like string: ");
    if (fgets(buf, sizeof(buf), stdin) == NULL) return;
    buf[strcspn(buf, "\n")] = '\0';
    /* Vulnerable: passing user-supplied string directly as format to printf */
    printf("%s", buf); /* BAD: format-string vulnerability */
    printf("\n");
}

void vuln_integer_overflow() {
    unsigned int count;
    char *p;
    printf("How many items? ");
    if (scanf("%u", &count) != 1) return;
    /* Vulnerable: multiplication can overflow and produce small allocation */
    unsigned int size = count * sizeof(int); /* may overflow */
    p = malloc(size); /* if overflow occurred, allocation too small */
    if (!p) {
        printf("malloc failed\n");
        return;
    }
    printf("Allocated %u bytes for %u items\n", size, count);
    free(p);
}

void vuln_use_after_free() {
    char *data = malloc(64);
    if (!data) return;
    strcpy(data, "sensitive info");
    printf("Before free: %s\n", data);
    free(data);
    /* Vulnerable: using pointer after free */
    printf("After free (use-after-free): %s\n", data);
}

int main(void) {
    printf("Vulnerable demo program\n\n");
    vuln_buffer_overflow();
    /* consume leftover newline after previous scanf to keep fgets working */
    int c; while ((c = getchar()) != '\n' && c != EOF) {}
    vuln_strcpy_style();
    vuln_format_string();
    vuln_integer_overflow();
    vuln_use_after_free();
    return 0;
}
