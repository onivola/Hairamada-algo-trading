# i n c l u d e   < T r a d e \ T r a d e . m q h >  
 # i n c l u d e   < H a i r a b o t \ U t i l s . m q 5 >  
 C T r a d e   t r a d e ;  
 i n t   t e m p   =   2 ;  
 d o u b l e   I n t e r v a l = 5 0 0 ;  
 d o u b l e   o p e n = 0 ;  
 d o u b l e   b u y = 0 ;  
 d o u b l e   s e l l = 0 ;  
 d o u b l e   L o t = 0 . 0 0 1 ;  
 i n t   s t o p = 2 ;  
 i n t   d i r e c t i o n   =   2 ;  
 i n t   M i n P r o f i t ( d o u b l e   m i n ) {  
       f o r ( i n t   i   =   0 ;   i   <   P o s i t i o n s T o t a l ( ) ;   i   + =   1 ) {  
              
             i f ( P o s i t i o n G e t S y m b o l ( i )   = =   _ S y m b o l ) {  
                      
                     i f ( P o s i t i o n S e l e c t B y T i c k e t ( P o s i t i o n G e t T i c k e t ( i ) ) ) {  
                                
                         d o u b l e   p r o f i t   = P o s i t i o n G e t D o u b l e ( P O S I T I O N _ P R O F I T ) ;  
                         P r i n t ( " p r o f i t " + i + " = " + p r o f i t ) ;  
                               i f ( p r o f i t < = m i n )   {  
                               P r i n t ( " * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * " ) ;  
                               c l o s e ( _ S y m b o l ) ;  
                                     r e t u r n   0 ;  
                               }  
                         }  
                   }  
             }  
       r e t u r n   2 ;  
 }  
 i n t   M a x P r o f i t ( d o u b l e   m a x ) {  
       f o r ( i n t   i   =   0 ;   i   <   P o s i t i o n s T o t a l ( ) ;   i   + =   1 ) {  
              
             i f ( P o s i t i o n G e t S y m b o l ( i )   = =   _ S y m b o l ) {  
                      
                     i f ( P o s i t i o n S e l e c t B y T i c k e t ( P o s i t i o n G e t T i c k e t ( i ) ) ) {  
                                
                         d o u b l e   p r o f i t   = P o s i t i o n G e t D o u b l e ( P O S I T I O N _ P R O F I T ) ;  
                         P r i n t ( " p r o f i t " + i + " = " + p r o f i t ) ;  
                               i f ( p r o f i t > = m a x )   {  
                                     r e t u r n   1 ;  
                               }  
                         }  
                   }  
             }  
       r e t u r n   2 ;  
 }  
  
  
  
 v o i d   I n c r e m e n t a t i o n ( d o u b l e   t e m p s , d o u b l e   p r i x , d o u b l e   i n t e r v a l )  
 {  
       i n t   p o s T o t a l   =   g e t S y m b o l P o s i t i o n T o t a l ( _ S y m b o l ) ;  
       i f ( t e m p s = = 0 ) {  
                 / / c l o s e ( _ S y m b o l ) ;  
                 o p e n = p r i x ;  
                 b u y = o p e n   +   i n t e r v a l ;  
                 s e l l = o p e n   -   i n t e r v a l ;  
                 / / d i r e c t i o n = 2 ;  
       }  
       i f ( t e m p s > 0 ) {  
             i f ( p r i x < = s e l l ) {  
                     i f ( g e t S y m b o l P o s i t i o n T o t a l ( _ S y m b o l ) = = 0   & &   P r o f i t ( ) = = 0 ) {  
                         S e l l P o s i t i o n ( L o t ) ;  
                         d i r e c t i o n = 0 ;  
                     }  
                     i f ( d i r e c t i o n = = 0   & &   P r o f i t ( ) > = 0 . 2 ) {  
                         S e l l P o s i t i o n ( L o t ) ;  
                     }  
                     i f ( M i n P r o f i t ( - 0 . 2 ) = = 0 ) {  
                         c l o s e ( _ S y m b o l ) ;  
                         / / d i r e c t i o n = =   3 ;  
                     }  
                      
             }  
             e l s e   i f ( p r i x > = b u y ) {  
                       i f ( g e t S y m b o l P o s i t i o n T o t a l ( _ S y m b o l ) = = 0   & &   P r o f i t ( ) = = 0 ) {  
                         B u y P o s i t i o n ( L o t ) ;  
                         d i r e c t i o n = 1 ;  
                     }  
                       i f ( g e t S y m b o l P o s i t i o n T o t a l ( _ S y m b o l ) > = 0   & &   P r o f i t ( ) > = 0 . 2 ) {  
                         B u y P o s i t i o n ( L o t ) ;  
                     }  
                     i f ( M i n P r o f i t ( - 0 . 2 ) = = 0 ) {  
                         c l o s e ( _ S y m b o l ) ;  
                         / / d i r e c t i o n = =   3 ;  
                     }  
             }  
       }    
 }  
 v o i d   O n T i c k ( )  
     {        
      
       d o u b l e   c u r r e n t   =   G e t T m p P r i c e ( ) ;  
       i n t   p o s T o t a l   =   g e t S y m b o l P o s i t i o n T o t a l ( _ S y m b o l ) ;  
       i n t   t i m e   =   S e c o n d s ( ) ;  
       / / P r i n t ( M i n P r o f i t ( - 0 . 1 ) ) ;  
       I n c r e m e n t a t i o n ( t i m e , c u r r e n t , I n t e r v a l ) ;  
       d o u b l e   p r o f i t   =   A c c o u n t I n f o D o u b l e ( A C C O U N T _ P R O F I T ) ;  
     i f ( P r o f i t ( ) > = 5 ) {  
             c l o s e ( _ S y m b o l ) ;  
           / / d i r e c t i o n = =   3 ;  
         }  
  
        
 }  
  
 b o o l   B u y P o s i t i o n ( d o u b l e   l o t )   {  
       C T r a d e   t r a d e ;  
       i f ( t r a d e . B u y ( l o t , _ S y m b o l , 0 , 0 , 0 ) ) {  
             i n t   c o d e   =   ( i n t ) t r a d e . R e s u l t R e t c o d e ( ) ;  
             u l o n g   t i c k e t   =   t r a d e . R e s u l t O r d e r ( ) ;  
             P r i n t ( " C o d e : " + ( s t r i n g ) c o d e ) ;  
             P r i n t ( " T i c k e t : " + ( s t r i n g ) t i c k e t ) ;      
             r e t u r n   t r u e   ;  
       }  
     r e t u r n   f a l s e   ;  
   }  
    
 b o o l   S e l l P o s i t i o n ( d o u b l e   l o t )   {  
       C T r a d e   t r a d e ;    
       i f ( t r a d e . S e l l ( l o t , _ S y m b o l , 0 , 0 , 0 ) ) {  
             i n t   c o d e   =   ( i n t ) t r a d e . R e s u l t R e t c o d e ( ) ;  
             u l o n g   t i c k e t   =   t r a d e . R e s u l t O r d e r ( ) ;  
             P r i n t ( " C o d e : " + ( s t r i n g ) c o d e ) ;  
             P r i n t ( " T i c k e t : " + ( s t r i n g ) t i c k e t ) ;      
             r e t u r n   t r u e   ;  
       }  
       r e t u r n   f a l s e ;  
  
 }  
  
 v o i d   c l o s e ( s t r i n g   s y m b o l N a m e ) {        
  
       C T r a d e   t r a d e ;  
  
       i f ( P o s i t i o n S e l e c t B y T i c k e t ( g e t L a s t T i c k e t ( s y m b o l N a m e ) ) ) {  
  
             t r a d e . P o s i t i o n C l o s e ( P o s i t i o n G e t I n t e g e r ( P O S I T I O N _ T I C K E T ) ) ;  
  
       }  
 }  
   d o u b l e   P r o f i t ( ) {        
         i f ( P o s i t i o n s T o t a l ( ) > = 1 )   {  
             d o u b l e   p r o f i t   =   P o s i t i o n G e t D o u b l e ( P O S I T I O N _ P R O F I T ) ;  
             r e t u r n   p r o f i t ;  
         }  
         r e t u r n   0 ;  
    
 }  
 i n t   S e c o n d s ( )  
 {  
     d a t e t i m e   t i m e   =   ( u i n t ) T i m e C u r r e n t ( ) ;  
     r e t u r n ( ( i n t ) t i m e   %   3 0 0 ) ;  
    
 }  
 v o i d   c l o s e 2 ( s t r i n g   s y m b o l N a m e ) {        
  
       C T r a d e   t r a d e ;  
  
       i f ( P o s i t i o n S e l e c t B y T i c k e t ( g e t L a s t T i c k e t ( s y m b o l N a m e ) ) ) {  
  
             t r a d e . P o s i t i o n C l o s e ( P o s i t i o n G e t I n t e g e r ( P O S I T I O N _ T I C K E T ) ) ;  
  
       }  
 }  
  
 d o u b l e   G e t T m p P r i c e ( )   {  
       M q l T i c k   L a t e s t _ P r i c e ;   / /   S t r u c t u r e   t o   g e t   t h e   l a t e s t   p r i c e s              
       S y m b o l I n f o T i c k ( S y m b o l ( )   , L a t e s t _ P r i c e ) ;   / /   A s s i g n   c u r r e n t   p r i c e s   t o   s t r u c t u r e    
  
 / /   T h e   B I D   p r i c e .  
       s t a t i c   d o u b l e   d B i d _ P r i c e ;    
  
 / /   T h e   A S K   p r i c e .  
       s t a t i c   d o u b l e   d A s k _ P r i c e ;    
  
       d B i d _ P r i c e   =   L a t e s t _ P r i c e . b i d ;     / /   C u r r e n t   B i d   p r i c e .  
       d A s k _ P r i c e   =   L a t e s t _ P r i c e . a s k ;     / /   C u r r e n t   A s k   p r i c e .  
        
        
       / / P r i n t ( " d B i d _ P r i c e = " + ( s t r i n g ) d B i d _ P r i c e ) ;  
       / / P r i n t ( " d A s k _ P r i c e = " + ( s t r i n g ) d A s k _ P r i c e ) ;  
        
       r e t u r n   d B i d _ P r i c e ;  
 }  
  
  
 