" Vim syntax file
" Language:     Solidity
" Maintainer:   Illia Bobyr (illia dot bobyr at gmail.com)
" URL:          https://github.com/ilya-bobyr/vim-solidity

if exists("b:current_syntax")
  finish
endif

" Long comments may confuse the syntax parser.  And it does not seem that this
" syntax is too expensive to parse.
syn sync fromstart

" Common Groups
syn match     solComma            ','
syn keyword   solStorageType      contained skipempty skipwhite nextgroup=solStorageType,solStorageConst,solStorageImmutable
      \ public private internal
syn keyword   solStorageConst     contained skipempty skipwhite nextgroup=solStorageType
      \ constant
syn keyword   solStorageImmutable     contained skipempty skipwhite nextgroup=solStorageType
      \ immutable
syn keyword   solFuncStorageType  contained
      \ storage calldata memory
syn keyword   solPayableType  contained
      \ payable

hi def link   solStorageType      StorageClass
hi def link   solFuncStorageType  StorageClass
hi def link   solStorageConst     StorageClass
hi def link   solStorageImmutable StorageClass
hi def link   solPayableType      StorageClass

" Common Groups Highlighting
hi def link   solParens           Normal
hi def link   solComma            Normal

" Complex Types
syn keyword   solMapping          skipempty skipwhite nextgroup=solMappingParens
      \ mapping
syn region    solMappingParens    start='(' end=')' contained contains=solValueType,solMapping nextgroup=solStorageType skipempty skipwhite
syn keyword   solEnum             nextgroup=solEnumBody skipwhite skipempty
      \ enum
syn region    solEnumBody         start='(' end=')' contained contains=solComma,solValueType
syn keyword   solStruct           nextgroup=solStructBody skipempty skipwhite
      \ struct
syn region    solStructBody       start='{' end='}' contained contains=solComma,solValueType,solStruct,solEnum,solMapping

hi def link   solMapping          Define
hi def link   solEnum             Define
hi def link   solStruct           Define

" Numbers
syntax match  solNumber           '\v0x\x+>'
syntax match  solNumber           '\v\c<%(\d+%(e[+-]=\d+)=|0b[01]+|0o\o+|0x\x+)>'
syntax match  solNumber           '\v\c<%(\d+.\d+|\d+.|.\d+)%(e[+-]=\d+)=>'

" Strings
syntax region solString           start=/\v"/ skip=/\v\\./ end=/\v"/ contains=@Spell
syntax region solString           start="\v'" skip="\v\\." end="\v'" contains=@Spell

hi def link   solNumber           Number
hi def link   solString           String

" Operators
syn match     solOperator         '\v\!'
syn match     solOperator         '\v\|'
syn match     solOperator         '\v\&'
syn match     solOperator         '\v\%'
syn match     solOperator         '\v\~'
syn match     solOperator         '\v\^'
syn match     solOperator         '\v\*'
syn match     solOperator         '\v/'
syn match     solOperator         '\v\+'
syn match     solOperator         '\v-'
syn match     solOperator         '\v\?'
syn match     solOperator         '\v\:'
syn match     solOperator         '\v\;'
syn match     solOperator         '\v\>'
syn match     solOperator         '\v\<'
syn match     solOperator         '\v\>\='
syn match     solOperator         '\v\<\='
syn match     solOperator         '\v\='
syn match     solOperator         '\v\*\='
syn match     solOperator         '\v/\='
syn match     solOperator         '\v\+\='
syn match     solOperator         '\v-\='

hi def link   solOperator         Operator

" Functions
syn keyword   solConstructor      nextgroup=solFuncParam skipwhite skipempty
      \ constructor
syn keyword   solFunction         nextgroup=solFuncName,solFuncParam skipwhite skipempty
      \ function
syn keyword   solFallback         nextgroup=solFuncParam skipwhite skipempty
      \ fallback
syn keyword   solReceive          nextgroup=solFuncParam skipwhite skipempty
      \ receive
syn match     solFuncName         contained nextgroup=solFuncParam skipwhite skipempty
      \ '\v<[a-zA-Z_][0-9a-zA-Z_]*'
" Function definition parameter list contents.
syn cluster   solFuncParamList
      \ contains=solComma,solValueType,solMapping,solFuncStorageType,solComment
syn region    solFuncParam
      \ contained
      \ contains=@solFuncParamList
      \ nextgroup=solFuncModCustom,solFuncModifier,solFuncReturn,solFuncBody
      \ skipempty
      \ skipwhite
      \ start='('
      \ end=')'

syn keyword   solFuncModifier     contained nextgroup=solFuncModifier,solFuncModCustom,solFuncReturn,solFuncBody skipwhite skipempty
      \ external internal payable public pure view private constant override virtual
syn match     solFuncModCustom    contained nextgroup=solFuncModifier,solFuncModCustom,solFuncReturn,solFuncBody,solFuncModParens  skipempty skipwhite
      \ '\v<[a-zA-Z_][0-9a-zA-Z_]*'
syn region    solFuncModParens    contained contains=solString,solFuncCall,solConstant,solNumber,solTypeCast,solComma nextgroup=solFuncReturn,solFuncModifier,solFuncModCustom,solFuncBody skipempty skipwhite transparent
      \ start='('
      \ end=')'
syn keyword   solFuncReturn       contained nextgroup=solFuncRetParens skipwhite skipempty returns
syn region    solFuncRetParens    contains=solValueType,solFuncStorageType nextgroup=solFuncBody skipempty skipwhite
      \ start='('
      \ end=')'
" Function body level constructs.
" Syntax elements that can be present inside of a function body.  Some of
" them need to reference back to this full list as a contained item.  For
" example, both branches of an "if" statement may contain any of the other
" syntax elements that can be preset in a function body.  Including, for
" example, nested "if" statements.
syn cluster solFuncBodyList
      \ contains=solDestructure,solComment,solAssemblyBlock,solEmitEvent,solTypeCast,solMethod,solValueType,solConstant,solKeyword,solRepeat,solLabel,solException,solStructure,solFuncStorageType,solOperator,solNumber,solString,solFuncCall,solIf,solElse,solLoop,solTry,solUnchecked
syn region    solFuncBody         contained  skipempty skipwhite
      \ contains=@solFuncBodyList
      \ start='{'
      \ end='}'
syn match     solFuncCall         contained skipempty skipwhite
      \ nextgroup=solCallOptions,solFuncCallArgs
      \ '\v<%(%(address|bool|bytes|catch|if|int|string|try|ufixed|uint)>)@![a-zA-Z_][0-9a-zA-Z_]*%(\s*[{)])@='
" Function call arguments.
" Syntax elements that can be part of a function call argument list.
syn cluster solFuncCallArgsList
      \ contains=solComment,solString,solFuncCall,solConstant,solNumber,solMethod,solTypeCast,solComma,solOperator
syn region    solFuncCallArgs     contained transparent
      \ contains=@solFuncCallArgsList
      \ start='('
      \ end=')'

hi def link   solFunction         Define
hi def link   solConstructor      Define
hi def link   solFallback         Function
hi def link   solReceive          Function
hi def link   solFuncName         Function
hi def link   solFuncModifier     Keyword
hi def link   solFuncModCustom    Keyword
hi def link   solFuncCall         Function
hi def link   solFuncReturn       Special

syn region    solCallOptions      start=/{/ end=/}/ contained
      \ contains=solString,solFuncCall,solConstant,solNumber,solMethod,solTypeCast,solComma,solOperator,solCallOptionKey
      \ transparent nextgroup=solFuncCallArgs
syn keyword   solCallOptionKey    gas value

hi def link   solCallOptionKey    Define

" Modifiers
syn keyword   solModifier         modifier nextgroup=solModifiername skipwhite
syn keyword   solModifierOverride contained nextgroup=solModifierBody skipwhite skipempty override virtual
syn match     solModifierName     /\<[a-zA-Z_][0-9a-zA-Z_]*/ contained nextgroup=solModifierParam skipwhite
syn region    solModifierParam    start='(' end=')' contained contains=solComma,solValueType,solFuncStorageType nextgroup=solModifierOverride,solModifierBody skipwhite skipempty
syn region    solModifierBody     start='{' end='}' contained contains=solDestructure,solComment,solAssemblyBlock,solEmitEvent,solTypeCast,solMethod,solValueType,solConstant,solKeyword,solRepeat,solLabel,solException,solStructure,solFuncStorageType,solOperator,solNumber,solString,solFuncCall,solIf,solElse,solLoop,solTry,solUnchecked,solModifierInsert skipempty skipwhite transparent
syn match     solModifierInsert   /\<_\>/ containedin=solModifierBody

hi def link   solModifier         Define
hi def link   solModifierOverride Keyword
hi def link   solModifierName     Function
hi def link   solModifierInsert   Function

" Contracts, Libraries, Interfaces
syn match     solAbstract         /\<abstract\>/ nextgroup=SolContract skipwhite
syn match     solContract         /\<\%(contract\|library\|interface\)\>/ nextgroup=solContractName skipwhite
syn match     solContractName     /\<[a-zA-Z_][0-9a-zA-Z_]*/ contained nextgroup=solContractParent skipwhite
syn region    solContractParent   start=/\<is\>/ end='{' contained contains=solContractName,solComma,solInheritor
syn match     solInheritor        /\<is\>/ contained
syn region    solLibUsing         start=/\<using\>/ end=/\<for\>/ contains=solLibName
syn match     solLibName          /[a-zA-Z_][0-9a-zA-Z_]*\s*\zefor/ contained

hi def link   solAbstract         Special
hi def link   solContract         Define
hi def link   solContractName     Type
hi def link   solInheritor        Keyword
hi def link   solLibUsing         Special
hi def link   solLibName          Type

" Events
syn match     solEvent            /\<event\>/ nextgroup=solEventName,solEventParams skipwhite
syn match     solEventName        /\<[a-zA-Z_][0-9a-zA-Z_]*/ nextgroup=solEventParam contained skipwhite
syn region    solEventParam       start='(' end=')' contains=solComma,solValueType,solEventParamMod,other contained skipwhite skipempty
syn match     solEventParamMod    /\<\%(indexed\|anonymous\)\>/ contained
syn keyword   solEmitEvent        emit

hi def link   solEvent            Define
hi def link   solEventName        Function
hi def link   solEventParamMod    Keyword
hi def link   solEmitEvent        Special

" Errors
syn match     solError            /\<error\>/ nextgroup=solErrorName,solFuncParams skipwhite
syn match     solErrorName        /\<[a-zA-Z_][0-9a-zA-Z_]*/ nextgroup=solFuncParam contained skipwhite

hi def link   solErrorName        Function

" Constants
syn keyword   solConstant         true false wei szabo finney ether seconds minutes hours days weeks years now super
syn keyword   solConstant         block msg now tx this abi

hi def link   solConstant         Constant

" Reserved keywords https://docs.soliditylang.org/en/v0.8.1/cheatsheet.html#reserved-keywords
syn keyword   solReserved         after alias apply auto case copyof default
syn keyword   solReserved         define final implements in inline let macro match
syn keyword   solReserved         mutable null of partial promise reference relocatable
syn keyword   solReserved         sealed sizeof static supports switch typedef typeof

hi def link   solReserved         Error

" Pragma
syn keyword   solPragma           pragma
syn match     solPragmaVersion    /\%(\<pragma\s\+\)\@<=solidity\>/
syn match     solPragmaExp        /\%(\<pragma\s\+\)\@<=experimental\s*\%(ABIEncoderV2\|SMTChecker\)\>/
syn match     solPragmaABICoder   /\%(\<pragma\s\+\)\@<=abicoder\s*v[12]\>/

hi def link   solPragma           PreProc
hi def link   solPragmaVersion    PreProc
hi def link   solPragmaExp        PreProc
hi def link   solPragmaABICoder   PreProc

" Assembly
syn keyword   solAssemblyName     assembly  contained
syn region    solAssemblyBlock    start=/\<assembly\s*{/ end=/}/ contained contains=solAssemblyName,solAssemblyLet,solAssemblyOperator,solAssemblyConst,solAssemblyMethod,solComment,solNumber,solString,solOperator,solAssemblyCond,solAssmNestedBlock
syn match     solAssemblyOperator /:=/ contained
syn keyword   solAssemblyLet      let contained
syn keyword   solAssemblyMethod   stop add sub mul div sdiv mod smod exp not lt gt slt sgt eq iszero contained
syn keyword   solAssemblyMethod   and or xor byte shl shr sar addmod mulmod signextend keccak256 jump contained
syn keyword   solAssemblyMethod   jumpi pop mload mstore mstore8 sload sstore calldataload calldatacopy contained
syn keyword   solAssemblyMethod   codecopy extcodesize extcodecopy returndatacopy extcodehash create create2 contained
syn keyword   solAssemblyMethod   call callcode delegatecall staticcall return revert selfdestruct contained
syn keyword   solAssemblyMethod   log0 log1 log2 log3 log4 blockhash contained
syn match     solAssemblyMethod   /\<\%(swap\|dup\)\d\>/ contained
syn keyword   solAssemblyConst    pc msize gas address caller callvalue calldatasize codesize contained
syn keyword   solAssemblyConst    returndatasize origin gasprice coinbase timestamp number difficulty gaslimit contained
syn keyword   solAssemblyCond     if else contained
syn region    solAssmNestedBlock  start=/\%(assembly\s*\)\@<!{/ end=/}/ contained skipwhite skipempty transparent

hi def link   solAssemblyBlock    PreProc
hi def link   solAssemblyName     Special
hi def link   solAssemblyOperator Operator
hi def link   solAssemblyLet      Keyword
hi def link   solAssemblyMethod   Special
hi def link   solAssemblyConst    Constant
hi def link   solAssemblyCond     Conditional

" Builtin Methods
syn keyword   solMethod           delete new var return import
syn region    solMethodParens     start='(' end=')' contains=solString,solConstant,solNumber,solFuncCall,solTypeCast,solMethod,solComma,solOperator contained transparent
syn keyword   solMethod           nextgroup=solMethodParens skipwhite skipempty
      \ blockhash require revert assert keccak256 sha256
      \ ripemd160 ecrecover addmod mulmod selfdestruct

hi def link   solMethod           Special

" Miscellaneous
syn keyword   solRepeat           do
syn keyword   solLabel            break continue
syn keyword   solException        throw

hi def link   solRepeat           Repeat
hi def link   solLabel            Label
hi def link   solException        Exception

" Simple Types
syn match     solValueType        /\<uint\d*\>/ nextgroup=solStorageType,solStorageConst,solStorageImmutable skipwhite skipempty
syn match     solValueType        /\<int\d*\>/ nextgroup=solStorageType,solStorageConst,solStorageImmutable skipwhite skipempty
syn match     solValueType        /\<fixed\d*\>/ nextgroup=solStorageType,solStorageConst,solStorageImmutable skipwhite skipempty
syn match     solValueType        /\<ufixed\d*\>/ nextgroup=solStorageType,solStorageConst,solStorageImmutable skipwhite skipempty
syn match     solValueType        /\<bytes\d*\>/ nextgroup=solStorageType,solStorageConst,solStorageImmutable skipwhite skipempty
syn match     solValueType        /\<address\>/ nextgroup=solPayableType,solStorageType,solStorageConst,solStorageImmutable skipwhite skipempty
syn match     solValueType        /\<string\>/ nextgroup=solStorageType,solStorageConst,solStorageImmutable skipwhite skipempty
syn match     solValueType        /\<bool\>/ nextgroup=solStorageType,solStorageConst,solStorageImmutable skipwhite skipempty

syn match     solValueType        /\<uint\d*\s*\[\]/ nextgroup=solStorageType,solStorageConst,solStorageImmutable skipwhite skipempty
syn match     solValueType        /\<int\d*\s*\[\]/ nextgroup=solStorageType,solStorageConst,solStorageImmutable skipwhite skipempty
syn match     solValueType        /\<fixed\d*\s*\[\]/ nextgroup=solStorageType,solStorageConst,solStorageImmutable skipwhite skipempty
syn match     solValueType        /\<ufixed\d*\s*\[\]/ nextgroup=solStorageType,solStorageConst,solStorageImmutable skipwhite skipempty
syn match     solValueType        /\<bytes\d*\s*\[\]/ nextgroup=solStorageType,solStorageConst,solStorageImmutable skipwhite skipempty
syn match     solValueType        /\<address\%(\s\+payable\)\?\s*\[\]/ contains=solPayableType nextgroup=solStorageType,solStorageConst,solStorageImmutable skipwhite skipempty
syn match     solValueType        /\<string\s*\[\]/ nextgroup=solStorageType,solStorageConst,solStorageImmutable skipwhite skipempty
syn match     solValueType        /bool\s*\[\]/ nextgroup=solStorageType,solStorageConst,solStorageImmutable skipwhite skipempty

syn match     solTypeCast         /\<uint\d*\ze\s*(/ nextgroup=solTypeCastParens skipwhite skipempty
syn match     solTypeCast         /\<int\d*\ze\s*(/ nextgroup=solTypeCastParens skipwhite skipempty
syn match     solTypeCast         /\<ufixed\d*\ze\s*(/ nextgroup=solTypeCastParens skipwhite skipempty
syn match     solTypeCast         /\<bytes\d*\ze\s*(/ nextgroup=solTypeCastParens skipwhite skipempty
syn match     solTypeCast         /\<address\ze\s*(/ nextgroup=solTypeCastParens skipwhite skipempty
syn match     solTypeCast         /\<string\ze\s*(/ nextgroup=solTypeCastParens skipwhite skipempty
syn match     solTypeCast         /\<bool\ze\s*(/ nextgroup=solTypeCastParens skipwhite skipempty
syn region    solTypeCastParens   start=/(/ end=/)/ contained contains=solMethod,solFuncCall,solString,solConstant,solNumber,solTypeCast,solComma transparent

hi def link   solValueType        Type
hi def link   solTypeCast         Type

" Conditionals
syn match     solIf               /\<if\>/ contained skipwhite skipempty nextgroup=solIfParens
syn match     solElse             /\<else\>/ contained skipwhite skipempty nextgroup=solIf,solIfBlock
syn region    solIfParens         start=/(/ end=/)/ contained nextgroup=solIfBlock skipwhite skipempty transparent
syn region    solIfBlock          start=/{/ end=/}/ contained
      \ contains=@solFuncBodyList
      \ nextgroup=solElse skipwhite skipempty transparent

hi def link   solIf               Keyword
hi def link   solElse             Keyword

" Loops
syn match     solLoop             /\<\%(for\|while\)\>/ contained skipwhite skipempty nextgroup=solLoopParens
syn region    solLoopParens       start=/(/ end=/)/ contained nextgroup=solLoopBlock skipwhite skipempty transparent
syn region    solLoopBlock        start=/{/ end=/}/ contained
      \ contains=@solFuncBodyList
      \ skipwhite skipempty transparent

hi def link   solLoop             Keyword

" Try/catch
syn match solTry                  /\<try\>/ contained
      \ skipwhite skipempty nextgroup=solTryCallExpr
syn region solTryCallExpr         contained
      \ contains=@solFuncCallArgsList
      \ start='[^({]*('
      \ end=')'
      \ skipwhite skipempty nextgroup=solTryReturns,@solTryCatchList
" TODO: 'he' does not seem to have any effect here :(
" Would probably need to rewrite is a set of rules, in order to avoid
" "(" being highlighted.
syn region solTryReturns          contained
      \ contains=@solFuncParamList
      \ matchgroup=solCatchKeyword start='returns\_s\+('he=s+6
      \ matchgroup=NONE
      \ end=')'
      \ skipwhite skipempty nextgroup=solTrySuccessBlock
syn region solTrySuccessBlock     contained
      \ contains=@solFuncBodyList
      \ start='{'
      \ end='}'
      \ skipwhite skipempty nextgroup=@solTryCatchList
syn cluster solTryCatchList
      \ contains=solTryCatchError,solTryCatchPanic,solTryCatchLowLevel,solTryCatchAny
" TODO: 'he' does not seem to have any effect here :(
" Would probably need to rewrite is a set of rules, in order to avoid
" everything after "catch" to be highlighted.  Might not be such a
" bad idea, as currently this rule matches only if the error pattern
" is fully matched.  And matching in the error pattern is
" non-standard, thus has no highlight.
syn region solTryCatchError      contained
      \ contains=@solFuncBodyList
      \ matchgroup=solCatchKeyword
      \ start='catch\_s\+Error\_s*(\_s*string\_s\+memory\_s\+\k\+\_s*)\_s*{'he=s+5
      \ matchgroup=NONE
      \ end='}'
      \ skipwhite skipempty nextgroup=@solTryCatchList
" TODO: 'he' does not seem to have any effect here :(
" See "solTryCatchError" above.
syn region solTryCatchPanic      contained
      \ contains=@solFuncBodyList
      \ matchgroup=solCatchKeyword
      \ start='catch\_s\+Panic\_s*(\_s*uint\_s\+\k\+\_s*)\_s*{'he=s+5
      \ matchgroup=NONE
      \ end='}'
      \ skipwhite skipempty nextgroup=@solTryCatchList
" TODO: 'he' does not seem to have any effect here :(
" See "solTryCatchError" above.
syn region solTryCatchLowLevel   contained
      \ contains=@solFuncBodyList
      \ matchgroup=solCatchKeyword
      \ start='catch\_s*(\_s*bytes\_s\+memory\_s\+\k\+\_s*)\_s*{'he=s+5
      \ matchgroup=NONE
      \ end='}'
      \ skipwhite skipempty nextgroup=@solTryCatchList
" TODO: 'he' does not seem to have any effect here :(
" See "solTryCatchError" above.
syn region solTryCatchAny        contained
      \ contains=@solFuncBodyList
      \ matchgroup=solCatchKeyword
      \ start='catch\_s*{'he=s+5
      \ matchgroup=NONE
      \ end='}'
      \ skipwhite skipempty nextgroup=@solTryCatchList

hi def link solTry                Keyword
hi def link solCatchKeyword       Keyword

" unchecked
syn match   solUnchecked          /\<unchecked\>/ contained
      \ skipwhite skipempty nextgroup=solUncheckedBlock
syn region  solUncheckedBlock     start=/{/ end=/}/ contained
      \ contains=@solFuncBodyList
      \ skipwhite skipempty transparent

hi def link solUnchecked          Keyword


" Comments
syn keyword   solTodo             TODO FIXME XXX TBD contained
syn region    solComment          start=/\/\// end=/$/ contains=solTodo,@Spell
syn region    solComment          start=/\/\*/ end=/\*\// contains=solTodo,@Spell

hi def link   solTodo             Todo
hi def link   solComment          Comment

" Natspec
syn match     solNatspecTag       /@title\>/ contained
syn match     solNatspecTag       /@author\>/ contained
syn match     solNatspecTag       /@notice\>/ contained
syn match     solNatspecTag       /@dev\>/ contained
syn match     solNatspecTag       /@param\>/ contained
syn match     solNatspecParam     /\%(@param\s\+\)\@<=[a-zA-Z_][0-9a-zA-Z_]*/
syn match     solNatspecTag       /@return\>/ contained
syn match     solNatspecTag       /@inheritdoc\>/ contained
syn match     solNatspecTag       /@custom:\k*\>/ contained
syn region    solNatspecBlock     start=/\/\/\// end=/$/ contains=solTodo,solNatspecTag,solNatspecParam,@Spell
syn region    solNatspecBlock     start=/\/\*\{2}/ end=/\*\// contains=solTodo,solNatspecTag,solNatspecParam,@Spell

hi def link   solNatspecTag       SpecialComment
hi def link   solNatspecBlock     Comment
hi def link   solNatspecParam     Define

let b:current_syntax = "solidity"
