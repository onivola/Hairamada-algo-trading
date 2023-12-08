//+------------------------------------------------------------------+
//| Input parameter reading modes                                    |
//+------------------------------------------------------------------+
enum ENUM_INPUTS_READING_MODE
  {
   FILE             = 0, // File
   INPUT_PARAMETERS = 1  // Input parameters
  };
//+------------------------------------------------------------------+
//| Enumeration of position properties                               |
//+------------------------------------------------------------------+
enum ENUM_POSITION_PROPERTIES
  {
   P_TOTAL_DEALS     = 0,
   P_SYMBOL          = 1,
   P_MAGIC           = 2,
   P_COMMENT         = 3,
   P_SWAP            = 4,
   P_COMMISSION      = 5,
   P_PRICE_FIRST_DEAL= 6,
   P_PRICE_OPEN      = 7,
   P_PRICE_CURRENT   = 8,
   P_PRICE_LAST_DEAL = 9,
   P_PROFIT          = 10,
   P_VOLUME          = 11,
   P_INITIAL_VOLUME  = 12,
   P_SL              = 13,
   P_TP              = 14,
   P_TIME            = 15,
   P_DURATION        = 16,
   P_ID              = 17,
   P_TYPE            = 18,
   P_ALL             = 19
  };
//+------------------------------------------------------------------+
//| Enumeration of symbol properties                                 |
//+------------------------------------------------------------------+
enum ENUM_SYMBOL_PROPERTIES
  {
   S_DIGITS          = 0,
   S_SPREAD          = 1,
   S_STOPSLEVEL      = 2,
   S_POINT           = 3,
   S_ASK             = 4,
   S_BID             = 5,
   S_VOLUME_MIN      = 6,
   S_VOLUME_MAX      = 7,
   S_VOLUME_LIMIT    = 8,
   S_VOLUME_STEP     = 9,
   S_FILTER          = 10,
   S_UP_LEVEL        = 11,
   S_DOWN_LEVEL      = 12,
   S_EXECUTION_MODE  = 13,
   S_ALL             = 14
  };
//+------------------------------------------------------------------+
//| Position duration                                                |
//+------------------------------------------------------------------+
enum ENUM_POSITION_DURATION
  {
   DAYS     = 0, // Days
   HOURS    = 1, // Hours
   MINUTES  = 2, // Minutes
   SECONDS  = 3  // Seconds
  };
//+------------------------------------------------------------------+
//| New bar and tick events from all symbols and time frames         |
//+------------------------------------------------------------------+
enum ENUM_CHART_EVENT_SYMBOL
  {
   CHARTEVENT_NO         = 0,          // Events are disabled - 0
   CHARTEVENT_INIT       = 0,          // Initialization event - 0
   //---
   CHARTEVENT_NEWBAR_M1  = 0x00000001, // New bar event on a minute chart (1)
   CHARTEVENT_NEWBAR_M2  = 0x00000002, // New bar event on a 2-minute chart (2)
   CHARTEVENT_NEWBAR_M3  = 0x00000004, // New bar event on a 3-minute chart (4)
   CHARTEVENT_NEWBAR_M4  = 0x00000008, // New bar event on a 4-minute chart (8)
   //---
   CHARTEVENT_NEWBAR_M5  = 0x00000010, // New bar event on a 5-minute chart (16)
   CHARTEVENT_NEWBAR_M6  = 0x00000020, // New bar event on a 6-minute chart (32)
   CHARTEVENT_NEWBAR_M10 = 0x00000040, // New bar event on a 10-minute chart (64)
   CHARTEVENT_NEWBAR_M12 = 0x00000080, // New bar event on a 12-minute chart (128)
   //---
   CHARTEVENT_NEWBAR_M15 = 0x00000100, // New bar event on a 15-minute chart (256)
   CHARTEVENT_NEWBAR_M20 = 0x00000200, // New bar event on a 20-minute chart (512)
   CHARTEVENT_NEWBAR_M30 = 0x00000400, // New bar event on a 30-minute chart (1024)
   CHARTEVENT_NEWBAR_H1  = 0x00000800, // New bar event on an hour chart (2048)
   //---
   CHARTEVENT_NEWBAR_H2  = 0x00001000, // New bar event on a 2-hour chart (4096)
   CHARTEVENT_NEWBAR_H3  = 0x00002000, // New bar event on a 3-hour chart (8192)
   CHARTEVENT_NEWBAR_H4  = 0x00004000, // New bar event on a 4-hour chart (16384)
   CHARTEVENT_NEWBAR_H6  = 0x00008000, // New bar event on a 6-hour chart (32768)
   //---
   CHARTEVENT_NEWBAR_H8  = 0x00010000, // New bar event on a 8-hour chart (65536)
   CHARTEVENT_NEWBAR_H12 = 0x00020000, // New bar event on a 12-hour chart (131072)
   CHARTEVENT_NEWBAR_D1  = 0x00040000, // New bar event on a daily chart (262144)
   CHARTEVENT_NEWBAR_W1  = 0x00080000, // New bar event on a weekly chart (524288)
   //---
   CHARTEVENT_NEWBAR_MN1 = 0x00100000, // New bar event on a monthly chart (1048576)
   CHARTEVENT_TICK       = 0x00200000, // New tick event (2097152)
   //---
   CHARTEVENT_ALL=0xFFFFFFFF  // All events are enabled (-1)
  };
//+------------------------------------------------------------------+
