//--- Connection with the main file of the Expert Advisor
#include "..\UnlimitedParametersEA.mq5"
//--- Include custom libraries
#include "Auxiliary.mqh"
#include "InitializeArrays.mqh"
#include "Enums.mqh"
#include "Errors.mqh"
#include "ToString.mqh"
#include "TradeSignals.mqh"
#include "TradeFunctions.mqh"
//+----------------------------------------------------------------------------------+
//| Creating a folder for files of input parameters in case the folder does not exist|
//| and returns the path in case of success                                          |
//+----------------------------------------------------------------------------------+
string CreateInputParametersFolder()
  {
   long   search_handle       =INVALID_HANDLE;   // Folder/file search handle
   string EA_root_folder      =EXPERT_NAME+"\\"; // Root folder of the Expert Advisor
   string returned_filename   ="";               // Name of the found object (file/folder)
   string search_path         ="";               // Search path
   string folder_filter       ="*";              // Search filter (* - check all files/folders)
   bool   is_root_folder      =false;            // Flag of existence/absence of the root folder of the Expert Advisor

//--- Find the root folder of the Expert Advisor
   search_path=folder_filter;
//--- Set the search handle in the common folder of the terminal
   search_handle=FileFindFirst(search_path,returned_filename,FILE_COMMON);
//--- If the first folder is the root folder, flag it
   if(returned_filename==EA_root_folder)
      is_root_folder=true;
//--- If the search handle has been obtained
   if(search_handle!=INVALID_HANDLE)
     {
      //--- If the first folder is not the root folder
      if(!is_root_folder)
        {
         //--- Iterate over all files to find the root folder
         while(FileFindNext(search_handle,returned_filename))
           {
            //--- Process terminated by the user
            if(IsStopped())
               return("");
            //--- If it is found, flag it
            if(returned_filename==EA_root_folder)
              {
               is_root_folder=true;
               break;
              }
           }
        }
      //--- Close the root folder search handle
      FileFindClose(search_handle);
      //search_handle=INVALID_HANDLE;
     }
//--- Otherwise print an error message
   else
      Print("Error when getting the search handle or "
            "the folder '"+TerminalInfoString(TERMINAL_COMMONDATA_PATH)+"' is empty: ",ErrorDescription(GetLastError()));

//--- Based on the check results, create the necessary folder
   search_path=EXPERT_NAME+"\\";
//--- If the root folder of the Expert Advisor does not exist
   if(!is_root_folder)
     {
      //--- Create it. 
      if(FolderCreate(EXPERT_NAME,FILE_COMMON))
        {
         //--- If the folder has been created, flag it
         is_root_folder=true;
         Print("The root folder of the '..\\"+EXPERT_NAME+"\\' Expert Advisor has been created");
        }
      else
        {
         Print("Error when creating "
               "the root folder of the Expert Advisor: ",ErrorDescription(GetLastError()));
         return("");
        }
     }
//--- If the required folder exists
   if(is_root_folder)
      //--- Return the path to create a file for writing parameters of the Expert Advisor
      return(search_path+"\\");
//--- In case of errors, return an empty string
   return("");
  }
//+------------------------------------------------------------------+
//| Reading/writing input parameters from/to a file for a symbol     |
//+------------------------------------------------------------------+
void ReadWriteInputParameters(int symbol_number,string path)
  {
   string file_name=path+InputSymbols[symbol_number]+".ini"; // File name
//---
   Print("Find the file '"+file_name+"' ...");
//--- Open the file with input parameters of the symbol
   int file_handle_read=FileOpen(file_name,FILE_READ|FILE_ANSI|FILE_COMMON);
   
//--- Scenario #1: the file exists and parameter values do not need to be rewritten
   if(file_handle_read!=INVALID_HANDLE && !RewriteParameters)
     {
      Print("The file '"+InputSymbols[symbol_number]+".ini' exists, reading...");
      //--- Set the array size
      ArrayResize(tested_parameters_from_file,TESTED_PARAMETERS_COUNT);
      //--- Fill the array with file values
      ReadInputParametersValuesFromFile(file_handle_read,tested_parameters_from_file);
      //--- If the array size is correct
      if(ArraySize(tested_parameters_from_file)==TESTED_PARAMETERS_COUNT)
        {
         //--- Write parameter values to arrays
         InputIndicatorPeriod[symbol_number]    =(int)tested_parameters_from_file[0];
         Print("InputIndicatorPeriod[symbol_number] = "+(string)InputIndicatorPeriod[symbol_number]);
         InputTakeProfit[symbol_number]         =tested_parameters_from_file[1];
         InputStopLoss[symbol_number]           =tested_parameters_from_file[2];
         InputTrailingStop[symbol_number]       =tested_parameters_from_file[3];
         InputReverse[symbol_number]            =(bool)tested_parameters_from_file[4];
         InputLot[symbol_number]                =tested_parameters_from_file[5];
         InputVolumeIncrease[symbol_number]     =tested_parameters_from_file[6];
         InputVolumeIncreaseStep[symbol_number] =tested_parameters_from_file[7];
        }
      //--- Close the file and exit
      FileClose(file_handle_read);
      return;
     }
//--- Scenario #2: If the file does not exist or the parameters need to be rewritten
   if(file_handle_read==INVALID_HANDLE || RewriteParameters)
     {
      //--- Close the handle of the file for reading
      FileClose(file_handle_read);
      //--- Get the handle of the file for writing
      int file_handle_write=FileOpen(file_name,FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON,"");
      //--- If the handle has been obtained
      if(file_handle_write!=INVALID_HANDLE)
        {
         string delimiter="="; // Separator
         //--- Write the parameters
         for(int i=0; i<TESTED_PARAMETERS_COUNT; i++)
           {
            FileWrite(file_handle_write,input_parameters_names[i],delimiter,tested_parameters_values[i]);
            Print(input_parameters_names[i],delimiter,tested_parameters_values[i]);
           }
         //--- Write parameter values to arrays
         InputIndicatorPeriod[symbol_number]    =(int)tested_parameters_values[0];
         InputTakeProfit[symbol_number]         =tested_parameters_values[1];
         InputStopLoss[symbol_number]           =tested_parameters_values[2];
         InputTrailingStop[symbol_number]       =tested_parameters_values[3];
         InputReverse[symbol_number]            =(bool)tested_parameters_values[4];
         InputLot[symbol_number]                =tested_parameters_values[5];
         InputVolumeIncrease[symbol_number]     =tested_parameters_values[6];
         InputVolumeIncreaseStep[symbol_number] =tested_parameters_values[7];
         //--- Depending on the indication, print the relevant message
         if(RewriteParameters)
            Print("The file '"+InputSymbols[symbol_number]+".ini' with parameters of the '"+EXPERT_NAME+".ex5' Expert Advisor has been rewritten");
         else
            Print("The file '"+InputSymbols[symbol_number]+".ini' with parameters of the '"+EXPERT_NAME+".ex5' Expert Advisor has been created");
        }
      //--- Close the handle of the file for writing
      FileClose(file_handle_write);
     }
  }
//+----------------------------------------------------------------------+
//| Reading parameters from the file and storing them in the passed array|
//| Text file format: key=value
//+----------------------------------------------------------------------+
bool ReadInputParametersValuesFromFile(int handle,double &array[])
  {
   int    delimiter_position  =0;  // Number of the symbol position "=" in the string
   int    strings_count       =0;  // String counter
   string read_string         =""; // The read string
   ulong  offset              =0;  // Position of the pointer (offset in bytes)
//--- Move the file pointer to the beginning of the file
   FileSeek(handle,0,SEEK_SET);
//--- Read until the current position of the file pointer reaches the end of the file
   while(!FileIsEnding(handle))
     {
      //--- If the user deleted the program
      if(IsStopped())
         return(false);
      //--- Read until the end of the string
      while(!FileIsLineEnding(handle))
        {
         //--- If the user deleted the program
         if(IsStopped())
            return(false);
         //--- Read the string
         read_string=FileReadString(handle);
         //--- Get the index of the separator ("=") in the read string
         delimiter_position=StringFind(read_string,"=",0);
         //--- Get everything that follows the separator ("=") until the end of the string
         read_string=StringSubstr(read_string,delimiter_position+1);
         //--- Place the obtained value converted to the double type in the output array
         array[strings_count]=StringToDouble(read_string);
         //--- Get the current position of the file pointer
         offset=FileTell(handle);
         //--- If it's the end of the string
         if(FileIsLineEnding(handle))
           {
            //--- Go to the next string if it's not the end of the file
            if(!FileIsEnding(handle))
               //--- Increase the offset of the file pointer by 1 to go to the next string
               offset++;
            //--- Move the file pointer relative to the beginning of the file
            FileSeek(handle,offset,SEEK_SET);
            //--- Increase the string counter
            strings_count++;
            //---Exit the nested loop for reading the string
            break;
           }
        }
      //--- If it's the end of the file, exit the main loop
      if(FileIsEnding(handle))
         break;
     }
//--- Return the fact of successful completion
   return(true);
  }
//+------------------------------------------------------------------+
//| Returning the number of strings (symbols) in the file and        |
//| filling the temporary array of symbols temporary_symbols[]       |
//+------------------------------------------------------------------+
//--- When preparing the file, symbols in the list should be separated with a line break
int ReadSymbolsFromFile(string file_name)
  {
   int strings_count=0; // String counter
//--- Open the file for reading from the common folder of the terminal
   int file_handle=FileOpen(file_name,FILE_READ|FILE_ANSI|FILE_COMMON);
//--- If the file handle has been obtained
   if(file_handle!=INVALID_HANDLE)
     {
      ulong  offset =0; // Offset for determining the position of the file pointer
      string text ="";  // The read string will be written to this variable
      //--- Read until the current position of the file pointer reaches the end of the file or until the program is deleted
      while(!FileIsEnding(file_handle) || !IsStopped())
        {
         //--- Read until the end of the string or until the program is deleted
         while(!FileIsLineEnding(file_handle) || !IsStopped())
           {
            //--- Read the whole string
            text=FileReadString(file_handle);
            //--- Get the position of the pointer
            offset=FileTell(file_handle);
            //--- Go to the next string if this is not the end of the file
            //    For this purpose, increase the offset of the file pointer
            if(!FileIsEnding(file_handle))
               offset++;
            //--- Move it to the next string
            FileSeek(file_handle,offset,SEEK_SET);
            //--- If the string is not empty
            if(text!="")
              {
               //--- Increase the string counter
               strings_count++;
               //--- Increase the size of the array of strings,
               ArrayResize(temporary_symbols,strings_count);
               //--- Write the read string to the current index
               temporary_symbols[strings_count-1]=text;
              }
            //--- Exit the nested loop
            break;
           }
         //--- If this is the end of the file, terminate the main loop
         if(FileIsEnding(file_handle))
            break;
        }
      //--- Close the file
      FileClose(file_handle);
     }
//--- Return the number of strings in the file
   return(strings_count);
  }
//+------------------------------------------------------------------+
