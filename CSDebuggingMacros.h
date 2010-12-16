/*
 *  CSDebuggingMacros.h
 *  CreateSend
 *
 *  Created by Nathan de Vries on 16/12/10.
 *  Copyright 2010 Nathan de Vries. All rights reserved.
 *
 */


// Always log, regardless of whether CSDEBUG is set

# define CSALog(format, ...) NSLog((@"%s [L%d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


// Only log when CSDEBUG is set, otherwise no-op

# ifdef CSDEBUG
#  define CSDLog(format, ...) CSALog(format, ##__VA_ARGS__)
# else
#   define CSDLog(...)
# endif
