package basisu_odin

Transcoder_Format :: enum u32 {
    ETC1_RGB            = 0,
    ETC2_RGBA           = 1,
    BC1_RGB             = 2,
    BC3_RGBA            = 3,
    BC4_R               = 4,
    BC5_RG              = 5,
    BC7_RGBA            = 6,
    PVRTC1_4_RGB        = 8,
    PVRTC1_4_RGBA       = 9,
    ASTC_LDR_4X4_RGBA   = 10,
    ATC_RGB             = 11,
    ATC_RGBA            = 12,
    FXT1_RGB            = 17,
    PVRTC2_4_RGB        = 18,
    PVRTC2_4_RGBA       = 19,
    ETC2_EAC_R11        = 20,
    ETC2_EAC_RG11       = 21,
    BC6H                = 22,
    ASTC_HDR_4X4_RGBA   = 23,
    RGBA32              = 13,
    RGB565              = 14,
    BGR565              = 15,
    RGBA4444            = 16,
    RGB_HALF            = 24,
    RGBA_HALF           = 25,
    RGB_9E5             = 26,
    ASTC_HDR_6X6_RGBA   = 27,
    ASTC_LDR_5X4_RGBA   = 28,
    ASTC_LDR_5X5_RGBA   = 29,
    ASTC_LDR_6X5_RGBA   = 30,
    ASTC_LDR_6X6_RGBA   = 31,
    ASTC_LDR_8X5_RGBA   = 32,
    ASTC_LDR_8X6_RGBA   = 33,
    ASTC_LDR_10X5_RGBA  = 34,
    ASTC_LDR_10X6_RGBA  = 35,
    ASTC_LDR_8X8_RGBA   = 36,
    ASTC_LDR_10X8_RGBA  = 37,
    ASTC_LDR_10X10_RGBA = 38,
    ASTC_LDR_12X10_RGBA = 39,
    ASTC_LDR_12X12_RGBA = 40,
}

Decode_Flag :: enum u32 {
    PVRTC_Decode_To_Next_Pow2               = 1,
    Transcode_Alpha_Data_To_Opaque_Formats  = 2,
    BC1_Forbid_Three_Color_Blocks           = 3,
    Output_Has_Alpha_Indices                = 4,
    High_Quality                            = 5,
    No_ETC1S_Chroma_Filtering               = 6,
    No_Deblock_Filtering                    = 7,
    Stronger_Deblock_Filtering              = 8,
    Force_Deblock_Filtering                 = 9,
    XUASTC_LDR_Disable_Fast_BC7_Transcoding = 10,
}
Decode_Flags :: bit_set[Decode_Flag;u32]

@(default_calling_convention = "c")
foreign lib {
    bt_enable_debug_printf :: proc(flag: u32) ---
    bt_alloc :: proc(size: u64) -> u64 ---
    bt_free :: proc(ofs: u64) ---
    bt_init :: proc() ---
    bt_get_version :: proc() -> u32 ---
}

@(link_prefix = "bt_", default_calling_convention = "c")
foreign lib {
    basis_tex_format_is_xuastc_ldr :: proc(basis_tex_fmt: Basis_Format) -> b32 ---
    basis_tex_format_is_astc_ldr :: proc(basis_tex_fmt: Basis_Format) -> b32 ---
    basis_tex_format_get_block_width :: proc(basis_tex_fmt: Basis_Format) -> u32 ---
    basis_tex_format_get_block_height :: proc(basis_tex_fmt: Basis_Format) -> u32 ---
    basis_tex_format_is_hdr :: proc(basis_tex_fmt: Basis_Format) -> b32 ---
    basis_tex_format_is_ldr :: proc(basis_tex_fmt: Basis_Format) -> b32 ---

    // Transcoder Format helpers
    basis_get_bytes_per_block_or_pixel :: proc(fmt: Transcoder_Format) -> u32 ---
    basis_transcoder_format_has_alpha :: proc(fmt: Transcoder_Format) -> b32 ---
    basis_transcoder_format_is_hdr :: proc(fmt: Transcoder_Format) -> b32 ---
    basis_transcoder_format_is_ldr :: proc(fmt: Transcoder_Format) -> b32 ---
    basis_transcoder_texture_format_is_astc :: proc(fmt: Transcoder_Format) -> b32 ---
    basis_transcoder_format_is_uncompressed :: proc(fmt: Transcoder_Format) -> b32 ---
    basis_get_uncompressed_bytes_per_pixel :: proc(fmt: Transcoder_Format) -> u32 ---
    basis_get_block_width :: proc(fmt: Transcoder_Format) -> u32 ---
    basis_get_block_height :: proc(fmt: Transcoder_Format) -> u32 ---
    basis_get_transcoder_texture_format_from_basis_tex_format :: proc(fmt: Basis_Format) -> Transcoder_Format ---
    basis_is_format_supported :: proc(transcoder_fmt: Transcoder_Format, basis_fmt: Basis_Format) -> b32 ---
    basis_compute_transcoded_image_size_in_bytes :: proc(fmt: Transcoder_Format, width: u32, height: u32) -> u32 ---

    // Transcoding
    ktx2_open :: proc(data_ofs: u64, data_len: u32) -> u64 ---
    ktx2_close :: proc(handle: u64) ---
    ktx2_get_width :: proc(handle: u64) -> u32 ---
    ktx2_get_height :: proc(handle: u64) -> u32 ---
    ktx2_get_levels :: proc(handle: u64) -> u32 ---
    ktx2_get_faces :: proc(handle: u64) -> u32 ---
    ktx2_get_layers :: proc(handle: u64) -> u32 ---
    ktx2_get_basis_tex_format :: proc(handle: u64) -> Basis_Format ---
    ktx2_is_etc1s :: proc(handle: u64) -> b32 ---
    ktx2_is_uastc_ldr_4x4 :: proc(handle: u64) -> b32 ---
    ktx2_is_hdr :: proc(handle: u64) -> b32 ---
    ktx2_is_hdr_4x4 :: proc(handle: u64) -> b32 ---
    ktx2_is_hdr_6x6 :: proc(handle: u64) -> b32 ---
    ktx2_is_ldr :: proc(handle: u64) -> b32 ---
    ktx2_is_astc_ldr :: proc(handle: u64) -> b32 ---
    ktx2_is_xuastc_ldr :: proc(handle: u64) -> b32 ---
    ktx2_get_block_width :: proc(handle: u64) -> u32 ---
    ktx2_get_block_height :: proc(handle: u64) -> u32 ---
    ktx2_has_alpha :: proc(handle: u64) -> b32 ---
    ktx2_get_dfd_color_model :: proc(handle: u64) -> u32 ---
    ktx2_get_dfd_color_primaries :: proc(handle: u64) -> u32 ---
    ktx2_get_dfd_transfer_func :: proc(handle: u64) -> u32 ---
    ktx2_is_srgb :: proc(handle: u64) -> b32 ---
    ktx2_get_dfd_flags :: proc(handle: u64) -> u32 ---
    ktx2_get_dfd_total_samples :: proc(handle: u64) -> u32 ---
    ktx2_get_dfd_channel_id0 :: proc(handle: u64) -> u32 ---
    ktx2_get_dfd_channel_id1 :: proc(handle: u64) -> u32 ---
    ktx2_is_video :: proc(handle: u64) -> b32 ---
    ktx2_get_ldr_hdr_upconversion_nit_multiplier :: proc(handle: u64) -> f32 ---
    ktx2_get_level_orig_width :: proc(handle: u64, level_index: u32, layer_index: u32, face_index: u32) -> u32 ---
    ktx2_get_level_orig_height :: proc(handle: u64, level_index: u32, layer_index: u32, face_index: u32) -> u32 ---
    ktx2_get_level_actual_width :: proc(handle: u64, level_index: u32, layer_index: u32, face_index: u32) -> u32 ---
    ktx2_get_level_actual_height :: proc(handle: u64, level_index: u32, layer_index: u32, face_index: u32) -> u32 ---
    ktx2_get_level_num_blocks_x :: proc(handle: u64, level_index: u32, layer_index: u32, face_index: u32) -> u32 ---
    ktx2_get_level_num_blocks_y :: proc(handle: u64, level_index: u32, layer_index: u32, face_index: u32) -> u32 ---
    ktx2_get_level_total_blocks :: proc(handle: u64, level_index: u32, layer_index: u32, face_index: u32) -> u32 ---
    ktx2_get_level_alpha_flag :: proc(handle: u64, level_index: u32, layer_index: u32, face_index: u32) -> b32 ---
    ktx2_get_level_iframe_flag :: proc(handle: u64, level_index: u32, layer_index: u32, face_index: u32) -> b32 ---
    ktx2_start_transcoding :: proc(handle: u64) -> b32 ---
    ktx2_create_transcode_state :: proc() -> u64 ---
    ktx2_destroy_transcode_state :: proc(handle: u64) ---
    ktx2_transcode_image_level :: proc(ktx2_handle: u64, level_index: u32, layer_index: u32, face_index: u32, output_block_mem_ofs: u64, output_blocks_buf_size_in_blocks_or_pixels: u32, transcoder_texture_format_u32: Transcoder_Format, decode_flags: Decode_Flags, output_row_pitch_in_blocks_or_pixels: u32, output_rows_in_pixels: u32, channel0: i32, channel1: i32, state_handle: u64) -> b32 ---
}
