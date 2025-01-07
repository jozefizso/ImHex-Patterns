#pragma endian big

import type.magic;

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
};

Alias alias @0x00;