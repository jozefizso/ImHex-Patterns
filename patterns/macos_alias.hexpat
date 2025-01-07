#pragma endian big

import type.magic;

enum EXTRA_INFO_TAGS : u16 {
  TAG_CARBON_FOLDER_NAME = 0x00,
  TAG_CNID_PATH = 0x01,
  TAG_UNICODE_FILENAME = 0x14,
  TAG_UNICODE_VOLUME_NAME = 0x15,
  TAG_POSIX_PATH = 0x18,
  TAG_POSIX_PATH_TO_MOUNTPOINT = 0x19
};

struct TAG_CARBON_FOLDER_NAME {
  u16 folder_name_length;
  char folder_name[folder_name_length];
  
  if (folder_name_length % 2 == 1) {
    u8 _padding;
  }
};

struct TAG_CNID_PATH {
  u16 length;
  u32 cnid;
};


struct EXTRA_INFO {
  EXTRA_INFO_TAGS type;
  
  match (type) {
    (EXTRA_INFO_TAGS::TAG_CARBON_FOLDER_NAME): TAG_CARBON_FOLDER_NAME carbon_folder;
    (EXTRA_INFO_TAGS::TAG_CNID_PATH): TAG_CNID_PATH cnid_path;
//    (EXTRA_INFO_TAGS::TAG_UNICODE_FILENAME): TAG_UNICODE_FILENAME unicode_filename;
//    (EXTRA_INFO_TAGS::TAG_UNICODE_VOLUME_NAME): TAG_UNICODE_VOLUME_NAME unicode_volumen_name;
//    (EXTRA_INFO_TAGS::TAG_POSIX_PATH): TAG_POSIX_PATH posix_path;
//    (EXTRA_INFO_TAGS::TAG_POSIX_PATH_TO_MOUNTPOINT): TAG_POSIX_PATH_TO_MOUNTPOINT mountpoint;
  }
};

struct Alias {
  // header
  type::Magic<"\x00\x00\x00\x00"> appinfo;
  
  u16 length;
  u16 version;
  
  u16 target_type;
  
  u8 volume_name_length;
  char volume_name[27];
  
  u32 volume_created_at;
  
  u16 volume_fs_type; // file system signature
  u16 volume_disk_type;
  
  // parent
  u32 parent_folder_cnid; // CagalogNodeID
  u8 filename_length;
  char filename[63];
  u32 target_cnid;
  u32 target_created_at;
  
  u32 target_creator_code; // typeName
  u32 target_type_code; // createNode
  
  u16 target_levels_from;
  u16 target_levels_to;
  
  u32 volume_attribute_flags;
  u16 volume_fs_id;
  
  u8 reserved[10]; // 150-140
  
  EXTRA_INFO extra[2];
};

Alias alias @0x00;