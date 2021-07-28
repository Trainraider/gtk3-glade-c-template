#include "version.h"
/*Display version information and exit */
void version()
{
#ifdef DEBUG
        printf(NAME " " VERSION "-Debug Build\n\n");
#else
        printf(NAME " " VERSION "\n\n");
#endif
        printf(COPYRIGHT "\n\n");
        printf(AUTHOR "\n");
        printf(EMAIL "\n");
        exit(EXIT_SUCCESS);
}
