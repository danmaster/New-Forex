/**
 * @file
 * Defines conditional compilation directives.
 *
 * Uncomment a line to activate the feature.
 */

#ifdef __MQL4__
#define STG_AC_INDI_FILE "\\Indicators\\Accelerator.ex4"
#else
#define STG_AC_INDI_FILE "\\Indicators\\Examples\\Accelerator.ex5"
#endif

//#define __config__  // Loads params from the config files.
//#define __debug__        // Enables debugging.
#define __input__  // Enables input parameters.
//#define __optimize__     // Enables optimization mode.
//#define __resource__  // Enables resources.
