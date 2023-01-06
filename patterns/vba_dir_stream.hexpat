#include <std/mem.pat>

enum SysKind : u32 {
	Win16 = 0x00,
	Win32 = 0x01,
	Mac = 0x02,
	Win64 = 0x03
};

struct PROJECTSYSKIND {
    u16 Id;
    u32 Size;
    SysKind SysKind;
};

struct PROJECTCOMPATVERSION {
	u16 Id;
	u32 Size;
	u32 CompatVersion;
};

struct PROJECTLCID {
	u16 Id;
	u32 Size;
	u32 Lcid;
};

struct PROJECTCODEPAGE {
	u16 Id;
	u32 Size;
	u16 CodePage;
};

struct PROJECTNAME {
	u16 Id;
	u32 Size;
	char ProjectName[Size];
};

struct PROJECTDOCSTRING {
	u16 Id;
	u32 Size;
	char DocString[Size];
	u16 Reserved;
	u32 SizeUnicode;
	char16 DocStringUnicode[SizeUnicode/2];
};

struct PROJECTHELPFILEPATH {
	u16 Id;
	u32 Size1;
	char HelpFile1[Size1];
	u16 Reserved;
	u32 Size2;
	char16 HelpFile2[Size2/2];
};

struct PROJECTHELPCONTEXT {
	u16 Id;
	u32 Size;
	u32 HelpContext;
};

struct PROJECTLIBFLAGS {
	u16 Id;
	u32 Size;
	u32 ProjectLibFlags;
};

struct PROJECTVERSION {
	u16 Id;
	u32 Reserved;
	u32 VersionMajor;
	u16 VersionMinor;
};

struct PROJECTCONSTANTS {
	u16 Id;
	u32 Size;
	char Constants[Size];
	u16 Reserved;
	u32 SizeUnicode;
	char16 ConstantsUnicode[SizeUnicode/2];
};

struct REFERENCENAME {
	u16 Id;
	u32 Size;
	char Name[Size];
	u16 Reserved;
	u32 SizeUnicode;
	char16 NameUnicode[SizeUnicode/2];
};

enum ReferenceRecordType : u16 {
	Control = 0x002F,
	Original = 0x0033,
	Registered = 0x000D,
	Project = 0x000E
};

struct REFERENCEREGISTERED {
    ReferenceRecordType Id;
	u32 Size;
	u32 SizeOfLibid;
	char Libid[SizeOfLibid];
	u32 Reserved1;
	u16 Reserved2;
};

struct REFERENCEPROJECT {
    ReferenceRecordType Id;
	u32 Size;
	u32 SizeOfLibidAbsolute;
	char LibidAbsolute[SizeOfLibidAbsolute];
	u32 SizeOfLibidRelative;
	char LibidRelative[SizeOfLibidRelative];
	u32 MajorVersion;
	u16 MinorVersion;
};

struct REFERENCE {
	REFERENCENAME NameRecord;
	if (std::mem::read_unsigned($, 1) == ReferenceRecordType::Control) {
	    REFERENCEREGISTERED ReferenceControlRecord;
	}
	if (std::mem::read_unsigned($, 1) == ReferenceRecordType::Original) {
	    REFERENCEREGISTERED ReferenceOriginalRecord;
	}
	if (std::mem::read_unsigned($, 1) == ReferenceRecordType::Registered) {
	    REFERENCEREGISTERED ReferenceRegisteredRecord;
	}
	if (std::mem::read_unsigned($, 1) == ReferenceRecordType::Project) {
	    REFERENCEPROJECT ReferenceProjectRecord;
	}

	if (std::mem::read_unsigned($, 2) == 0x000F) {
	    break;
	}
};

struct PROJECTREFERENCES {
	REFERENCE References[100];
};


struct PROJECTCOOKIE {
	u16 Id;
	u32 Size;
	u16 Cookie;
};

struct MODULENAME {
	u16 Id;
	u32 Size;
	char Name[Size];
};

struct MODULENAMEUNICODE {
	u16 Id;
	u32 Size;
	char16 NameUnicode[Size/2];
};

struct MODULESTREAMNAME {
	u16 Id;
	u32 Size;
	char StreamName[Size];
	u16 Reserved;
	u32 SizeUnicode;
	char16 StreamNameUnicode[SizeUnicode/2];
};

struct MODULEDOCSTRING {
	u16 Id;
	u32 Size;
	char DocString[Size];
	u16 Reserved;
	u32 SizeUnicode;
	char16 DocStringUnicode[SizeUnicode/2];
};

struct MODULEOFFSET {
	u16 Id;
	u32 Size;
	u32 TextOffset;
};

struct MODULEHELPCONTEXT {
	u16 Id;
	u32 Size;
	u32 HelpContext;
};

struct MODULECOOKIE {
	u16 Id;
	u32 Size;
	u16 Cookie;
};

struct MODULETYPE {
	u16 Id;
	u32 Reserved;
};

struct MODULEREADONLY {
	u16 Id;
	u32 Reserved;
};

struct MODULEPRIVATE {
	u16 Id;
	u32 Reserved;
};

enum RecordType : u8 {
	ReadOnly = 0x25,
	Private = 0x28
};

struct MODULE {
	MODULENAME NameRecord;
	MODULENAMEUNICODE NameUnicodeRecord;
	MODULESTREAMNAME StreamNameRecord;
	MODULEDOCSTRING DocStringRecord;
	MODULEOFFSET OffsetRecord;
	MODULEHELPCONTEXT HelpContextRecord;
	MODULECOOKIE CookieRecord;
	MODULETYPE TypeRecord;
	if (std::mem::read_unsigned($, 1) == RecordType::ReadOnly) {
		MODULEREADONLY ReadOnlyRecord;
	}
	if (std::mem::read_unsigned($, 1) == RecordType::Private) {
		MODULEPRIVATE PrivateRecord;
	}
	u16 Terminator;
	u32 Reserved;
};

struct PROJECTMODULES {
	u16 Id;
	u32 Size;
	u16 Count;
	PROJECTCOOKIE CookieRecord;
	MODULE Modules[Count];
};

struct PROJECTINFORMATION {
	PROJECTSYSKIND SysKindRecord;
	if (std::mem::read_unsigned($, 1) == 0x4A) {
		PROJECTCOMPATVERSION CompatVersionRecord;
	}
	PROJECTLCID LcidRecord;
	PROJECTLCID LcidInvokedRecord;
	PROJECTCODEPAGE CodePageRecord;
	PROJECTNAME NameRecord;
	PROJECTDOCSTRING DocStringRecord;
	PROJECTHELPFILEPATH HelpFilePathRecord;
	PROJECTHELPCONTEXT HelpContextRecord;
	PROJECTLIBFLAGS LibFlagsRecord;
	PROJECTVERSION VersionRecord;
	PROJECTCONSTANTS ConstantsRecord;
};

struct DirStream {
	PROJECTINFORMATION InformationRecord;
	PROJECTREFERENCES ReferencesRecord;
	//char reserved[0xB7];
	PROJECTMODULES ModulesRecord;
};

DirStream dir @ 0x00;
