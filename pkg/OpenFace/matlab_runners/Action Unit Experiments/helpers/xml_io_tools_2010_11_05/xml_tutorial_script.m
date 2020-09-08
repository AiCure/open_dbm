%% Tutorial for xml_io_tools Package
% *By Jarek Tuszynski*
%
% Package xml_io_tools can read XML files into MATLAB struct and writes 
% MATLAB data types to XML files with help of simple interface to 
% MATLAB's xmlwrite and xmlread functions.
% 
% Two function to simplify reading and writing XML files from MATLAB:
%
% * Function xml_read first calls MATLAB's xmlread function and than 
% converts its output ('Document Object Model' tree of Java objects) 
% to tree of MATLAB struct's. The output is in the format of nested 
% structs and cells. In the output data structure field names are based on
% XML tags.
%
% * Function xml_write first convert input tree of MATLAB structs and cells 
% and other types to tree of 'Document Object Model' nodes, and then writes 
% resulting object to XML file using MATLAB's xmlwrite function. .
%
%% This package can:
% * Read most XML files, created inside and outside of MATLAB environment, 
%   and convert them to MATLAB data structures.
% * Write any MATLAB's struct tree to XML file
% * Handle XML attributes and special XML nodes like comments, processing  
%   instructions and CDATA sections
% * Supports base64 encoding and decoding to allow handling embeded binary
%   data
% * Be studied, modified, customized, rewritten and used in other packages 
%   without any limitations. All code is included and documented. Software
%   is distributed under BSD Licence (included).   
%
%% This package does not:
% * Guarantee to recover the same Matlab objects that were saved. If you 
% need to be able to recover carbon copy of the structure that was saved 
% than you will have to use one of the packages that uses special set of 
% tags saved as xml attributes that help to guide the parsing of XML code. 
% This package does not use those tags.
% * Guarantee to work with older versions of MATLAB. Functions do not work
% with versions of MATLAB prior to 7.1 (26-Jul-2005). 
%
%% Change History
% * 2006-11-06 - original version
% * 2006-11-26 - corrected xml_write to handle writing Matlab's column
%   arrays to xml files. Bug discovered and diagnosed by Kalyan Dutta.
% * 2006-11-28 - made changes to handle special node types like: 
%   COMMENTS and CDATA sections 
% * 2007-03-12 - Writing CDATA sections still did not worked. The problem 
%   was diagnosed and fixed by Alberto Amaro. The fix involved rewriting
%   xmlwrite to use Apache Xerces java files directly instead of MATLAB's 
%   XMLUtils java class.
% * 2007-06-21 - Fixed problem reported by Anna Kelbert in Reviews about 
%   not writing attributes of ROOT node. Also: added support for Processing
%   Instructions, added support for global text nodes: Processing
%   Instructions and comments, allowed writing tag names with special
%   characters
% * 2007-07-20 - Added tutorial script file. Extended support for global
%   text nodes. Added more Preference fields.
% * 2008-01-23 - Fixed problem reported by Anna Krewet of converting dates 
%   in format '2007-01-01' to numbers. Improved and added warning messages.
%   Added detection of old Matlab versions incompatible with the library.
%   Expanded documentation.
% * 2008-06-23 - Fixed problem with writing 1D array reported by Mark Neil. 
%   Extended xml_read's Pref.Num2Str to 3 settings (never, smart and always) 
%   for better control. Added parameter Pref.KeepNS for keeping or ignoring 
%   namespace data when reading. Fixed a bug related to writing 2D cell
%   arrays brought up by Andrej's Mosat review. 
% * 2008-09-11 - Resubmitting last upload - zip file is still old
% * 2009-02-26 - Small changes. More error handling. More robust in case of
%   large binary objects. Added support for Base64 encoding/decoding of
%   binary objects (using functions by Peter J. Acklam).
% * 2009-06-26 - changes to xml_read: added CellItem parameter to allow
%   better control of reading files with 'item' notation (see comment by
%   Shlomi); changed try-catch statements so xml_read would work for mablab
%   versions prior to 7.5 (see Thomas Pilutti comment)
% * 2009-12-03 - added PreserveSpace parameter for contolling empty string
%   handling as suggested by Sebastiaan. Fix suggested by Michael Murphy.
%   Fixed number recognition code as suggested by Yuan Ren.  
% * 2010-05-04 - implemented fixes suggested by Dylan Reynolds from Airbus.  
% * 2010-07-28 - implemented support for 2D arrays of cells and structs 
%   suggested by Rodney Behn from MIT Lincoln Laboratory. Also attempted
%   large scale cleanup of xml_write function
% * 2010-08-18 - minor extension to allow better handling of logical
%   scalars and arrays and function handles suggested by Andreas Richter 
%   and others
% * 2010-09-20 - allow reading and writing of sparse matrices. Improve
%   reading of 1D boolean arrays.
% * 2010-11-05 - Fix problem with empty cells reported by Richard Cotton;
%   fixed issues with reading boolean arrays reported by Zohar Bar-Yehuda;
%   Improved speed of base64 coding and decoding by switching to java based 
%   code.
%% Licence
% The package is distributed under BSD License
format compact; % viewing preference
clear variables;
type('license.txt')

%% Write XML file based on a Struct using "xml_write"
% Any MATLAB data struct can be saved to XML file.
MyTree=[];
MyTree.MyNumber = 13;
MyTree.MyString = 'Hello World';
xml_write('test.xml', MyTree);
type('test.xml')

%% Read XML file producing a Struct using "xml_read"
[tree treeName] = xml_read ('test.xml');
disp([treeName{1} ' ='])
gen_object_display(tree)

%% "Pref.XmlEngine" flag in "xml_write"
% Occasionaly some operations are performed better by Apache Xerces XML 
% engine than default xmlread function. That is why xml_write provide an 
% option for choosing the underlaying xml engine. Code below performs the 
% same operation as the previous section but using Apache Xerces XML engine.
% Notice that in this case name of root element 
% was passed as variable and not extracted from the variable name.
Pref=[]; Pref.XmlEngine = 'Xerces';  % use Xerces xml generator directly
xml_write('test.xml', MyTree, 'TreeOfMine', Pref);
type('test.xml')

%% Writing Struct with different type MATLAB arrays
MyTree=[];
MyTree.Empty   = [];                   % Empty variable
MyTree.Num_1x1 = 13;                   % simple scalar
MyTree.Vec_1x3 = [1 2 3];              % horizontal vector
MyTree.Vec_4x1 = [1; 2; 3; 4];         % vertical vector
MyTree.Mat_2x2 = [1, 2; 3, 4];         % 2D matrix
MyTree.Cube_3D = reshape(1:8,[2 2 2]); % 3D array
MyTree.String1 = '[2003 10 30]';       % number string with    [] brackets
MyTree.String2 = ' 2003 10 30 ';       % number string without [] brackets
MyTree.Logical_1x1 = false;            % single logical
MyTree.Logical_2x2 = [false, true; true, false]; % 2D matrix of logicals
MyTree.Logical_Str = 'False False	True True';
MyTree.Int_2x2 = uint8([1 2;3 4]);     % 2D matrix of uint8 integers
MyTree.Complex_1x1 = complex(1, 7);    % complex scalar
MyTree.Complex_2x2 = complex([1 2;3 4],[2 2;7 7]); % 2D matrix of complex numbers
MyTree.Sparse_9x9 = sparse(1:9,1:9,1); % sparse 9x9 matrix
MyTree.Function = @sum;                % function handle
xml_write('test.xml', MyTree);
type('test.xml')

%% Read Struct with MATLAB arrays
% Notice that 'Cube_3D' did not preserve original dimentions 
[tree treeName] = xml_read ('test.xml');
disp([treeName{1} ' ='])
gen_object_display(tree)

%% "Pref.StructItem" flag in "xml_write" (controls 1D arrays of structs)
% *Create a simple structure with 1D array of struct's*
MyTree = [];
MyTree.a(1).b = 'jack';
MyTree.a(2).b = 'john';
gen_object_display(MyTree)
%%
% *Write XML with "StructItem = true" (default).  Notice single 'a' 
% section and multiple 'item' sub-sections. Those subsections are used 
% to store array elements*
wPref.StructItem = true;
xml_write('test.xml', MyTree, 'MyTree',wPref);
type('test.xml')
fprintf('\nxml_read output:\n')
gen_object_display(xml_read ('test.xml'))
%%
% *Write XML with "StructItem = false". Notice multiple 'a' sections*
wPref.StructItem = false;
xml_write('test.xml', MyTree, 'MyTree',wPref);
type('test.xml')
fprintf('\nxml_read output:\n')
gen_object_display(xml_read ('test.xml'))
%%
% *Notice that xml_read function produced the same struct when reading both files*
%%
% *Potential problems with "StructItem = true":*
wPref.StructItem = true;
MyTree1 = []; MyTree1.a.b    = 'jack';
MyTree2 = []; MyTree2.a(1).b = 'jack';
MyTree3 = []; MyTree3.a(2).b = 'jack';
xml_write('test.xml', MyTree1, [], wPref); type('test.xml');
xml_write('test.xml', MyTree2, [], wPref); type('test.xml');
xml_write('test.xml', MyTree3, [], wPref); type('test.xml');
%%
% *Notice that MyTree1 and MyTree2 produce identical files with no 'items',
% while MyTree2 and MyTree3 produce very different file structures. It was
% pointed out to me that files produced from MyTree2 and MyTree3 can not 
% belong to the same schema, which can be a problem. The solution is to use 
% cells.* 
wPref.CellItem = true;
wPref.NoCells  = true;
MyTree2 = []; MyTree2.a{1}.b = 'jack';
MyTree3 = []; MyTree3.a{2}.b = 'jack';
xml_write('test.xml', MyTree2, [], wPref); type('test.xml');
xml_write('test.xml', MyTree3, [], wPref); type('test.xml');


%% "Pref.CellItem" flag in "xml_write" (controls 1D arrays of cells)
% *Create a simple structure with cell arrays*
MyTree = [];
MyTree.a = {'jack', 'john'};
disp(MyTree)
%%
% *Write XML with "CellItem = true" (default).  Notice single 'a' 
% section and multiple 'item' sections*
Pref=[]; Pref.CellItem = true;
xml_write('test.xml', MyTree, 'MyTree',Pref);
type('test.xml')
fprintf('\nxml_read output:\n');
disp(xml_read ('test.xml'))
%%
% *Write XML with "CellItem = false". Notice multiple 'a' sections*
Pref=[]; Pref.CellItem = false;
xml_write('test.xml', MyTree, 'MyTree',Pref);
type('test.xml')
fprintf('\nxml_read output:\n');
disp(xml_read ('test.xml'))
%%
% *Notice that xml_read function produced the same struct when reading both files*

%% "Pref.NoCells" flag in "xml_read"
% *Create a cell/struct mixture object*
MyTree = [];
MyTree.a{1}.b = 'jack';
MyTree.a{2}.b = [];
MyTree.a{2}.c = 'john';
gen_object_display(MyTree);
%%
% *Save it to xml file*
Pref=[]; Pref.CellItem = false;
xml_write('test.xml', MyTree, 'MyTree',Pref);
type('test.xml')
%%
% *Read above file with "Pref.NoCells=true" (default) - output is quite different then input*
% By default program is trying to convert everything to struct's and arrays
% of structs. In case arrays of structs all the structs in array need to have the
% same fields, and if they are not than MATLAB creates empty fields.
Pref=[]; Pref.NoCells=true;
gen_object_display(xml_read('test.xml', Pref))
%%
% *Read above file with "Pref.NoCells=false" - now input and output are the same*
% Cell arrays of structs allow structs in array to have different fields.
Pref=[]; Pref.NoCells=false;
gen_object_display(xml_read('test.xml', Pref))

%% "Pref.ItemName" flag in "xml_write" (customize 1D arrays of structs and cells)
% *Create a cell/struct mixture object*
MyTree = [];
MyTree.a{1}.b = 'jack';
MyTree.a{2}.c = 'john';
gen_object_display(MyTree);
%%
% *Save it to xml file, using 'item' notation but with different name*
Pref=[]; 
Pref.CellItem = true;
Pref.ItemName = 'MyItem';
xml_write('test.xml', MyTree, 'MyTree',Pref);
type('test.xml')

%% "Pref.ItemName" flag in "xml_read"
% *Read above file with default settings ("Pref.ItemName = 'item'")*
% The results do not match the original structure
Pref=[]; Pref.NoCells  = false;
gen_object_display(xml_read('test.xml', Pref))
%%
% *Read above file with "Pref.ItemName = 'MyItem'" - now saved and read 
% MATLAB structures are the same*
Pref=[]; 
Pref.ItemName = 'MyItem';
Pref.NoCells  = false;
gen_object_display(xml_read('test.xml', Pref))

%% "Pref.CellItem" flag in "xml_read"
% "Pref.ItemName" is used to create xml files with clearly marked arrays
% "Pref.CellItem" flag in "xml_read" ensures that they are always read as
% arrays by forcing output to stay in cell format. In cell format s{1} is
% different than s, while s(1) is indistinguishable from s.
%%
% *Create a test file*
MyTree = [];
MyTree.a1{1}.b = 'jack'; % a1 - single struct
MyTree.a2{1}.b = 'jack'; % a2 - cell array of structs with the same fields
MyTree.a2{2}.b = 'john';
MyTree.a3{1}.b = 'jack'; % a3 - cell array of structs with the different fields
MyTree.a3{2}.c = 'john';
Pref=[]; 
Pref.CellItem = true;
Pref.Debug = true;
xml_write('test.xml', MyTree, 'MyTree',Pref);
type('test.xml')
%%
% *Read above file with "Pref.CellItem = true" (default)*
% All outputs are in cell format
Pref=[]; 
Pref.NoCells  = false;  % allow cell output
Pref.CellItem = true;   % keep 'item' arrays as cells 
gen_object_display(xml_read('test.xml', Pref))
%%
% *Read above file with "Pref.CellItem = false"*
% Outputs format is determined by content
Pref=[]; 
Pref.NoCells  = false; % allow cell output
Pref.CellItem = false; % allow 'item' arrays to beheave like other fields 
gen_object_display(xml_read('test.xml', Pref))
%%
% *Read above file with "Pref.CellItem = false" and "Pref.NoCells  = true"*
% All outputs are in struct format
Pref=[]; 
Pref.NoCells  = true;  % don't allow cell output 
Pref.CellItem = false; % allow 'item' arrays to beheave like other fields
gen_object_display(xml_read('test.xml', Pref))

%% "Pref.CellTable" flag in "xml_write" (controls 2D arrays of cells)
% *Create a structure with 2D arrays of cells*
MyTree = [];
MyTree.M = {[1,2;3,4], 'M12'; struct('a','jack'), {11, 'N12'; 21, 'N22'}};
gen_object_display(MyTree)
%%
% *Write XML with "CellTable = 'Html" (default). This option mimics use of  
%  HTML "tr" and "td" tags to encode 2D tables. Tag names can  
%  be changed using TableName parameter (see below)*
wPref = [];
wPref.CellTable = 'Html';
xml_write('test.xml', MyTree, 'MyTree',wPref);
type('test.xml')
fprintf('\nxml_read output:\n')
rPref=[]; rPref.NoCells=false;
gen_object_display(xml_read('test.xml', rPref))
%%
% *Write XML with "CellTable = 'Vector'".*
%  Converts 2D arrays to 1D array and item or regular notation. This option 
%  is mostly provided for backward compatibility since this was the 
%  behavior in prior verions of the code
wPref = [];
wPref.CellTable = 'Vector';
xml_write('test.xml', MyTree, 'MyTree',wPref);
type('test.xml')
fprintf('\nxml_read output:\n')
rPref=[]; rPref.NoCells=false;
gen_object_display(xml_read('test.xml', rPref))
%%
% *Create a simpler structure without struct's*
MyTree = [];
MyTree.M = {[1,2;3,4], 'M12'; 'M21', {11, 'N12'; 21, 'N22'}};
gen_object_display(MyTree)
%%
% *Write XML with "CellTable = 'Matlab". This option encodes tables
% consisting of numbers, strings and other cell arrays as MATLAB command
% string. Unlike 'Html' option it does not work if one of the cells is 
% a struct*
wPref = [];
wPref.CellTable = 'Matlab';
xml_write('test.xml', MyTree, 'MyTree',wPref);
type('test.xml')
fprintf('\nxml_read output:\n')
rPref=[]; rPref.NoCells=false;
gen_object_display(xml_read('test.xml', rPref))

%% Write 2D cell array in HTML format
MyTree = [];
MyTree.table.ATTRIBUTE.border=1;
MyTree.table.CONTENT = {'Apples', '44%'; 'Bannanas', '23%'; 'Oranges', '13%'; 'Other', '10%'};
xml_write('html/test.html', MyTree);
type('html/test.html')
%%
% Click on <test.html> to opened this file with a web brouwser

%% "Pref.StructTable" flag in "xml_write" (controls 2D arrays of structs)
% *Create a simple structure with arrays of struct's*
MyTree = [];
MyTree.a(1,1).b = 'jack';
MyTree.a(1,2).b = 'john';
MyTree.a(2,1).b = 'jim';
MyTree.a(2,2).b = 'jill';
gen_object_display(MyTree)
%%
% *Write XML with "StructTable = 'Html" (default). This option mimics use of  
%  HTML "tr" and "td"  tags to encode 2D tables. Tag names can  
%  be changed using TableName parameter (see below)*
wPref = [];
wPref.StructTable = 'Html';
xml_write('test.xml', MyTree, 'MyTree',wPref);
type('test.xml')
fprintf('\nxml_read output:\n')
gen_object_display(xml_read ('test.xml'))
%%
% *Write XML with "CellTable = 'Vector'".*
%  Converts 2D arrays to 1D array and item or regular notation. This option 
%  is mostly provided for backward compatibility since this was the 
%  behavior in prior verions of the code
wPref = [];
wPref.StructTable = 'Vector';
xml_write('test.xml', MyTree, 'MyTree',wPref);
type('test.xml')
fprintf('\nxml_read output:\n')
gen_object_display(xml_read ('test.xml'))

%% "Pref.TableName" flag in "xml_write" (controls encoding tags used for 2D arrays)
% *Create a cell object*
MyTree = [];
MyTree.M = {[1,2;3,4], 'M12'; 21, {11, 'N12'; 21, 'N22'}};
gen_object_display(MyTree);
%%
% *Save it to xml file, using 'Html' notation but with different names for 
%  rows and cells*
Pref=[]; Pref.TableName = {'row','cell'};
xml_write('test.xml', MyTree, 'MyTree',Pref);
type('test.xml')

%% "Pref.TableName" flag in "xml_read"
% *Read above file with default settings ("Pref.TableName = {'tr','td'}")*
% The results do not match the original structure
Pref=[]; Pref.NoCells  = false;
gen_object_display(xml_read('test.xml', Pref))
%%
% *Read above file with "Pref.TableName = {'row','cell'}" - now saved and read 
% MATLAB structures are the same*
Pref=[]; 
Pref.TableName = {'row','cell'};
Pref.NoCells  = false;
gen_object_display(xml_read('test.xml', Pref))

%% "Pref.Str2Num" flag in xml_read (control conversion to numbers while reading)
% *Create a cell/struct mixture object*
MyTree = [];
MyTree.str     = 'sphere';
MyTree.num1    =  123;
MyTree.num2    = '123';
MyTree.num3    = '[Inf,NaN]';
MyTree.calc    = '1+2+3+4';
MyTree.func    = 'sin(pi)/2';
MyTree.String1 = '[2003 10 30]'; 
MyTree.String2 = '2003 10 30';   % array resembling date
MyTree.ISO8601 = '2003-10-30';   % date in ISO 8601 format
MyTree.US_date = '2003/10/30';   % US style date format
MyTree.complex = '2003i-10e-30'; % complex number resembling a date
gen_object_display(MyTree);
%%
% *Save it to xml file*
xml_write('test.xml', MyTree);
type('test.xml')
%%
% *Read above file with default settings*
% ("Pref.Str2Num = true" or "Pref.Str2Num = 'smart'"). Under this setting all
% strings that look like numbers are converted to numbers, except for 
% strings that are recognized by MATLAB 'datenum' function as dates
gen_object_display(xml_read('test.xml'))
%%
% *Note that all the fields of 'MyTree' can be converted to numbers (even 
% 'sphere') but by default the function is trying to 'judge' if a string  
% should be converted to a number or not*
MyCell = {'sphere','1+2+3+4','sin(pi)/2','2003 10 30','2003-10-30','2003/10/30','2003i-10e-30'};
cellfun(@str2num, MyCell, 'UniformOutput', false)
%%
% *Read above file with "Pref.Str2Num = false" or "Pref.Str2Num = 'never'" 
% to keep all the fields in string format*
Pref=[]; Pref.Str2Num = false;
gen_object_display(xml_read('test.xml', Pref))
%%
% *Read above file with "Pref.Str2Num = always"  
% to convert all strings that look like numbers to numbers* note the likelly 
% unintendet conversion of 'ISO8601'
Pref=[]; Pref.Str2Num   = 'always';
gen_object_display(xml_read('test.xml', Pref))
%%
% *Notice that all three settings will produce the same output for "num1" and
% "num2" and there is no way to reproduce the original "MyTree" structure.*

%% "Pref.PreserveSpace" flag in xml_write (control handling of strings with leading/trailing spaces)
% *Create a struct with strings*
MyTree=[];
MyTree.Empty     = '';
MyTree.OneSpace  = ' ';
MyTree.TwoSpaces = '  '; 
MyTree.String1   = ' Hello      World ';
%%
% *Write XML with "PreserveSpace = false" (default).*
Pref=[]; Pref.PreserveSpace = false; % (default setting)
xml_write('test.xml', MyTree, [], Pref);
type('test.xml')
%%
% *Write XML with "PreserveSpace = true".*
Pref=[]; Pref.PreserveSpace = true; 
xml_write('test.xml', MyTree, [], Pref);
type('test.xml')

%% "Pref.PreserveSpace" flag in xml_read
% *Read file while using "PreserveSpace = false" (default).*
Pref=[]; Pref.PreserveSpace = false; % (default setting)
gen_object_display(xml_read('test.xml',Pref))
%%
% *Read file while using "PreserveSpace = true".*
Pref=[]; Pref.PreserveSpace = true; 
gen_object_display(xml_read('test.xml',Pref))


%% Write XML files with ATTRIBUTEs 
% In order to add node attributes a special ATTRIBUTE field is used. 
% ATTRIBUTEs have to be of simple types like numbers or strings (not
% struct or cells). Attributes are easy to attach to structs nodes like 
% MyTree below. 
MyTree=[];
MyTree.MyNumber = 13;
MyTree.MyString = 'Hello World'; % simple case
MyTree.ATTRIBUTE.Num = 2;
xml_write('test.xml', MyTree);
type('test.xml')

%%  
% In case when one needs to attach attributes to nodes which are not
% structs (for example strings, numbers or calls) then special CONTENT 
% field needs to be used to make the node a struct node.
MyTree=[];
MyTree.MyNumber = 13;
MyTree.MyString.CONTENT = 'Hello World'; % simple case
MyTree.MyString.ATTRIBUTE.Num = 2;
xml_write('test.xml', MyTree);
type('test.xml')

%% "Pref.Str2Num" flag in file with ATTRIBUTEs
% *Create a cell/struct mixture object*
MyTree = [];
MyTree.X.ATTRIBUTE.str     = 'sphere';
MyTree.X.ATTRIBUTE.num1    =  123;
MyTree.X.ATTRIBUTE.num2    = '123';
MyTree.X.ATTRIBUTE.num3    = '[Inf,NaN]';
MyTree.X.ATTRIBUTE.calc    = '1+2+3+4';
MyTree.X.ATTRIBUTE.func    = 'sin(pi)/2';
MyTree.X.ATTRIBUTE.String1 = '[2003 10 30]'; 
MyTree.X.ATTRIBUTE.String2 = '2003 10 30';   % array resembling date
MyTree.X.ATTRIBUTE.ISO8601 = '2003-10-30';   % date in ISO 8601 format
MyTree.X.ATTRIBUTE.US_date = '2003/10/30';   % US style date format
MyTree.X.ATTRIBUTE.complex = '2003i-10e-30'; % complex number resembling a date
gen_object_display(MyTree);
%%
% *Save it to xml file*
xml_write('test.xml', MyTree);
type('test.xml')
%%
% *Read above file with default settings*
% ("Pref.Str2Num = true" or "Pref.Str2Num = 'smart'"). Under this setting all
% strings that look like numbers are converted to numbers, except for 
% strings that are recognized by MATLAB 'datenum' function as dates
gen_object_display(xml_read('test.xml'))

%%
% *Read above file with "Pref.Str2Num = false" or "Pref.Str2Num = 'never'" 
% to keep all the fields in string format*
Pref=[]; Pref.Str2Num = false;
gen_object_display(xml_read('test.xml', Pref))
%%
% *Read above file with "Pref.Str2Num = always"  
% to convert all strings that look like numbers to numbers* 
Pref=[]; Pref.Str2Num   = 'always';
gen_object_display(xml_read('test.xml', Pref))
%%
% *Notice that all three settings will produce the same output for "num1" and
% "num2" and there is no way to reproduce the original "MyTree" structure.*


%% Write XML files with COMMENTs
% Insertion of Comments is done with help of special COMMENT field.
% Note that MATLAB's xmlwrite is less readable due to lack of end-of-line 
% characters around comment section. 
MyTree=[];
MyTree.COMMENT = 'This is a comment';
MyTree.MyNumber = 13;
MyTree.MyString.CONTENT = 'Hello World';
xml_write('test.xml', MyTree);
type('test.xml')

%%
% *Same operation using Apache Xerces XML engine*
% gives the same result
Pref=[]; Pref.XmlEngine = 'Xerces';  % use Xerces xml generator directly
xml_write('test.xml', MyTree, 'MyTree', Pref);
type('test.xml')

%%
% *Comments in XML top level (method #1)*
% This method uses cell array 
MyTree=[];
MyTree.MyNumber = 13;
MyTree.MyString = 'Hello World';
xml_write('test.xml', MyTree, {'MyTree', [], 'This is a global comment'});
type('test.xml')
%%
% *Same operation using Apache Xerces XML engine* 
% gives even nicer results.
Pref=[]; Pref.XmlEngine = 'Xerces';  % use Xerces xml generator directly
xml_write('test.xml', MyTree, {'MyTree', [], 'This is a global comment'}, Pref);
type('test.xml')

%%
% *Comments in XML top level (method #2)*
% This method adds an extra top layer to the struct 'tree' and sets
% "Pref.RootOnly = false", which informs the function about the extra 
% layer. Notice that RootName is also saved as a part of
% the 'tree', and does not have to be passed in separately.
MyTree=[];
MyTree.COMMENT = 'This is a global comment';
MyTree.MyTest.MyNumber = 13;
MyTree.MyTest.MyString = 'Hello World';
Pref=[]; Pref.RootOnly = false;
xml_write('test.xml', MyTree, [], Pref);
type('test.xml')
%%
% *Same operation using Apache Xerces XML engine*
Pref=[]; Pref.XmlEngine = 'Xerces';  % use Xerces xml generator directly
Pref.RootOnly  = false;
xml_write('test.xml', MyTree, [], Pref);
type('test.xml')

%% Write XML files with PROCESSING_INSTRUCTIONs 
% Insertion of Processing Instructions is done through use of special 
% PROCESSING_INSTRUCTION field, which stores the instruction string. The
% string has to be in 'target data' format separated by space.
MyTree=[];
MyTree.PROCESSING_INSTRUCTION = 'xml-stylesheet type="a" href="foo"';
MyTree.MyNumber = 13;
MyTree.MyString = 'Hello World';
xml_write('test.xml', MyTree);
type('test.xml')

%%
% *Same operation using Apache Xerces XML engine*
Pref=[]; Pref.XmlEngine = 'Xerces';  % use Xerces xml generator directly
xml_write('test.xml', MyTree, 'MyTree', Pref);
type('test.xml')

%%
% *PROCESSING_INSTRUCTIONs in XML top level (method #1)*
% This method uses cell array 
MyTree=[];
MyTree.MyNumber = 13;
MyTree.MyString = 'Hello World';
xml_write('test.xml', MyTree, {'MyTree', 'xml-stylesheet type="a" href="foo"'});
type('test.xml')
%%
% *Same operation using Apache Xerces XML engine*
Pref=[]; Pref.XmlEngine = 'Xerces';  % use Xerces xml generator directly
xml_write('test.xml', MyTree, {'MyTree', 'xml-stylesheet type="a" href="foo"'}, Pref);
type('test.xml')

%%
% *PROCESSING_INSTRUCTIONs in XML top level (method #2)*
% This method adds an extra top layer to the struct 'tree' and sets
% pref.RootOnly=false, which informs the function about the extra 
% layer. Notice that RootName is also saved as a part of
% the 'tree', and does not have to be passed in separately.
MyTree=[];
MyTree.PROCESSING_INSTRUCTION =  'xml-stylesheet type="a" href="foo"';
MyTree.MyTest.MyNumber = 13;
MyTree.MyTest.MyString = 'Hello World';
Pref=[]; Pref.RootOnly = false;
xml_write('test.xml', MyTree, [], Pref);
type('test.xml')
%%
% *Same operation using Apache Xerces XML engine*
Pref=[]; Pref.XmlEngine = 'Xerces';  % use Xerces xml generator directly
Pref.RootOnly  = false;
xml_write('test.xml', MyTree, 'MyTree', Pref);
type('test.xml')

%% Write XML files with CDATA Sections 
% "In an XML document a CDATA (Character DATA) section is a section of 
%  element content that is marked for the parser to interpret as only 
%  character data, not markup." (from Wikipedia) 
% To insert CDATA Sections one use special CDATA_SECTION field,
%  which stores the instruction string. Note that MATLAB's xmlwrite created
%  wrong xml code for CDATA section
MyTree=[];
MyTree.CDATA_SECTION = '<A>txt</A>';
MyTree.MyNumber = 13;
MyTree.MyString = 'Hello World';
xml_write('test.xml', MyTree);
type('test.xml')
%%
% *Same operation using Apache Xerces XML engine produces correct results*
Pref=[]; Pref.XmlEngine = 'Xerces';  % use Xerces xml generator directly
xml_write('test.xml', MyTree, 'MyTree', Pref);
type('test.xml')

%% Write XML files with special characters in TAG names
% The input to xml_write requires that all tags one wants in XML document 
% have to be encoded as field names of MATLAB's struct's. Matlab has a lot
% of restrictions on variable names. This section is about XML tags with
% names not allowed as MATLAB variables, or more specifically with
% characters allowed as xml tag names but not allowed as MATLAB variable
% names. Characters like that can be replaced by their hexadecimal
% representation just as it is done by genvarname function. Alternative way
% of writing the first example is:
MyTree=[];
MyTree.('MyNumber') = 13;               % same as MyTree.MyNumber = 13;
MyTree.MyString.CONTENT = 'Hello World';
MyTree.MyString.ATTRIBUTE.('Num') = 2;  % same as MyTree.MyString.ATTRIBUTE.Num = 2;
xml_write('test.xml', MyTree);
type('test.xml')

%%
% *This approach fails for some characters like dash '-', colon ':', and
% international characters.*
MyTree=[];
try
  MyTree.('My-Number') = 13;
  MyTree.MyString.CONTENT = 'Hello World';
  MyTree.MyString.ATTRIBUTE.('Num_ö') = 2;
catch  %#ok<CTCH>
  err = lasterror; %#ok<LERR>
  disp(err.message);
end

%%
% It can be overcome by replacing offending characters with their 
% hexadecimal representation. That can be done manually or with use of 
% genvarname function. Note that MATLAB 'type' function does not show
% correctly 'ö' letter in xml file, but opening the file in editor shows 
% that it is correct.
MyTree=[];
MyTree.(genvarname('My-Number')) = 13;
MyTree.MyString.CONTENT = 'Hello World';
MyTree.MyString.ATTRIBUTE.Num_0xF6 = 2;
gen_object_display(MyTree);
xml_write('test.xml', MyTree);
type('test.xml')

%%
% *Also two of the characters '-' and ':' can be encoded by a special strings:
% '_DASH_' and '_COLON_' respectively*
MyTree=[];
MyTree.My_DASH_Number = 13;
MyTree.MyString.CONTENT = 'Hello World';
MyTree.MyString.ATTRIBUTE.Num0xF6 = 2;
xml_write('test.xml', MyTree);
type('test.xml')

%% Write XML files with Namespaces
% No extra special fields are needed to define XML namespaces, only colon 
% character written using '0x3A' or '_COLON_'. Below is an
% example of a namespace definition
MyTree=[];
MyTree.f_COLON_child.ATTRIBUTE.xmlns_COLON_f = 'http://www.foo.com';
MyTree.f_COLON_child.f_COLON_MyNumber = 13;
MyTree.f_COLON_child.f_COLON_MyString = 'Hello World';
xml_write('test.xml', MyTree, 'MyTree');
type('test.xml')
%%
% *Same operation using Apache Xerces XML engine*
Pref=[]; Pref.XmlEngine = 'Xerces';  % use Xerces xml generator directly
xml_write('test.xml', MyTree, 'f_COLON_MyTree', Pref);
type('test.xml')

%% "Pref.KeepNS" flag in "xml_read"
% Thise option allow keeping  or exclusion of namespaces in tag names. 
% By default the namespace data is kept but it produces much longer field
% names in the output structure. Ignoring namespace will produce more
% readible output.
% Perform default read of file with namespace
tree = xml_read('test.xml');
gen_object_display(tree);

%%
% Now the same operation with KeepNS = false. 
Pref=[]; Pref.KeepNS = false; % do not read attributes
tree = xml_read('test.xml', Pref);
gen_object_display(tree);

%% Read XML files with special node types
% Display and read the file, then show the data structure. Note that 
% MATLAB 'type' function shows 'ö' letter incorrectly as 'A¶' in xml file, 
% but opening the file in editor shows that it is correct.
fprintf('Test xml file:\n');
type('test_file.xml')
%%
% Read only the Root Element (default) 
[tree GlobalTextNodes] = xml_read('test_file.xml');
fprintf('Global Data (Root name, Global Processing Instructions and Global Comments):\n');
disp(GlobalTextNodes')
fprintf('\nStructure read from the file (uncludes COMMENT and CDATA sections):\n');
gen_object_display(tree);
%%
% Read the whole tree including global Comments and Processing Instructions
Pref=[]; Pref.RootOnly = false;
[tree GlobalTextNodes] = xml_read('test_file.xml', Pref);
fprintf('Global Data (Root name, Global Processing Instructions and Global Comments):\n');
disp(GlobalTextNodes')
fprintf('\nStructure read from the file (uncludes COMMENT and CDATA sections):\n');
gen_object_display(tree);

%% "Pref.ReadAttr" flag in "xml_read" (control handling of nodes with attributes)
% Those option allow exclusion of attributes 
Pref=[]; Pref.ReadAttr = false; % do not read attributes
tree = xml_read('test_file.xml', Pref);
gen_object_display(tree);

%% "Pref.ReadSpec" flag in "xml_read"
% Those option allow exclusion of special nodes, like
% comments, processing instructions, CData sections, etc.
Pref=[]; Pref.ReadSpec = false; % do not read special node types
tree = xml_read('test_file.xml', Pref);
gen_object_display(tree);

%% "Pref.RootOnly" flag in "xml_read"
% As it was shown in previous examples RootOnly parameter can be used to
% capture global (top level) special nodes (like COMMENTs and
% PROCESSING_INSTRUCTIONs) which are ignored by default
Pref=[]; Pref.RootOnly = false; % do not read special node types
tree = xml_read('test_file.xml', Pref);
gen_object_display(tree);

%% "Pref.RootOnly" flag in "xml_write"
% Writing previously read tree with default "Pref.RootOnly = true" gives
% wrong output file
Pref=[]; Pref.RootOnly = true; % do not read special node types
xml_write('test.xml', tree, [], Pref);
fprintf('Test xml file:\n');
type('test.xml')
%%
% Writing the same tree with "Pref.RootOnly = false" gives correct output
Pref=[]; Pref.RootOnly = false; % do not read special node types
xml_write('test.xml', tree, [], Pref);
fprintf('Test xml file:\n');
type('test.xml')

%% "Pref.NumLevels" flag in "xml_read"
% This parameter allows user to skip parts of the tree in order to save
% time and memory. Usefull only in a rare case when a small portion of
% large XML file is needed.
%
% Create test tile
MyTree = [];
MyTree.Level1 = 1;
MyTree.Level1_.Level2 = 2;
MyTree.Level1_.Level2_.Level3 = 3;
MyTree.Level1_.Level2_.Level3_.Level4 = 4;
xml_write('test.xml', MyTree);
fprintf('Test xml file:\n');
type('test.xml')
%%
% *Use Default ("Pref.NumLevels = infinity") setting*
tree = xml_read('test.xml');
gen_object_display(tree);
%%
% *Limit the read to only 2 levels*
Pref=[]; Pref.NumLevels = 2; 
tree = xml_read('test.xml', Pref);
gen_object_display(tree);




%% Create DOM object based on a Struct using "xml_write"
% *Create Struct tree*
MyTree=[];
MyTree.MyNumber = 13;
MyTree.MyString = 'Hello World';
%%
% *Convert Struct to DOM object using xml_write*
DOM = xml_write([], MyTree); 
xmlwrite('test.xml', DOM);   % Save DOM object using MATLAB function 
type('test.xml')

%% Convert DOM object to Struct using "xml_read"
DOM = xmlread('test.xml');       % Read DOM object using MATLAB function
[tree treeName] = xml_read(DOM); % Convert DOM object to Struct
disp([treeName{1} ' ='])
gen_object_display(tree)

%% Write XML file based on a DOM using "xml_write_xerces"
xmlwrite_xerces('test.xml', DOM); % Save DOM object using Xerces library 
type('test.xml')

%% Write XML to string instead of a file
DOM = xml_write([], MyTree);
str = xmlwrite(DOM);
disp(str)

%% Write XML file with embedded binary data encoded as Base64 (using java version)
fid = fopen('football.jpg', 'rb');       
raw1 = uint8(fread(fid, 'uint8'));                % read image file as a raw binary
fclose(fid);

MyTree=[];
MyTree.Size = 13;
MyTree.MyString = 'Hello World'; % simple case
MyTree.MyImage.ATTRIBUTE.EncodingMIMEType = 'base64';
MyTree.MyImage.CONTENT = base64encode(raw1,'java');% perform base64 encoding of the binary data
xml_write('test.xml', MyTree);             % write xml file

%% Read XML file with embedded binary data encoded as Base64 (using java version)
tree = xml_read('test.xml', Pref);         % read xml file
raw  = base64decode(tree.MyImage.CONTENT, '', 'java');   % convert xml image to raw binary
fid = fopen('MyFootball.jpg', 'wb');  
fwrite(fid, raw, 'uint8');                 % dumb the raw binary to the hard disk 
fclose(fid);
I = imread('MyFootball.jpg');              % read it as an image
imshow(I);

%% Write XML file with embedded binary data encoded as Base64 (simpler version using only matlab code
% Notice that process of writing to xml stripped all end-of-lie characters
% from base64 code.
isChunked = true; % break into chunks 76 characters long
url_safe  = true; % 'base64url' encoding
code = base64encode('license.txt', 'matlab', isChunked, url_safe);
disp(code)
MyTree=[];
MyTree.Size = 13;
MyTree.MyString = 'Hello World'; 
MyTree.MyImage.ATTRIBUTE.EncodingMIMEType = 'base64';
MyTree.MyImage.CONTENT = code;   % perform base64 encoding of the binary data
xml_write('test.xml', MyTree);   % write xml file
type('test.xml')

%% Read XML file with embedded binary data encoded as Base64 (simpler version using only matlab code
tree = xml_read('test.xml', Pref);         % read xml file
base64decode(tree.MyImage.CONTENT, 'license2.txt', 'matlab'); % save xml image as raw binary
type('license2.txt')