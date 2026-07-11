package basisu_odin

Quality_Min :: 0
Quality_Max :: 1000

when ODIN_OS == .Windows {
    when ODIN_ARCH == .amd64 {
        LIB_PATH :: "windows_x64/basisu_c.lib"
        ENCODER_LIB_PATH :: "windows_x64/basisu_encoder.lib"
    } else when ODIN_ARCH == .arm64 {
        LIB_PATH :: "windows_arm64/basisu_c.lib"
        ENCODER_LIB_PATH :: "windows_arm64/basisu_encoder.lib"
    } else {
        #panic("vendor/basisu supports windows amd64/arm64 only")
    }
} else when ODIN_OS == .Darwin {
    when ODIN_ARCH == .amd64 {
        LIB_PATH :: "darwin_x64/basisu_c.darwin.a"
        ENCODER_LIB_PATH :: "darwin_x64/basisu_encoder.darwin.a"
    } else when ODIN_ARCH == .arm64 {
        LIB_PATH :: "darwin_arm64/basisu_c.darwin.a"
        ENCODER_LIB_PATH :: "darwin_arm64/basisu_encoder.darwin.a"
    } else {
        #panic("vendor/basisu supports Darwin amd64/arm64 only")
    }
} else when ODIN_OS == .Linux {
    when ODIN_ARCH == .amd64 {
        LIB_PATH :: "linux_x64/basisu_c.linux.a"
        ENCODER_LIB_PATH :: "linux_x64/basisu_encoder.linux.a"
    } else when ODIN_ARCH == .arm64 {
        LIB_PATH :: "linux_arm64/basisu_c.linux.a"
        ENCODER_LIB_PATH :: "linux_arm64/basisu_encoder.linux.a"
    } else {
        #panic("vendor/basisu supports Linux amd64/arm64 only")
    }
} else {
    #panic("vendor/basisu supports Windows, Darwin, and Linux only")
}

@(export)
foreign import lib {LIB_PATH, ENCODER_LIB_PATH}

Basis_Format :: enum u32 {
    ETC1S            = 0,
    UASTC_LDR_4X4    = 1,
    UASTC_HDR_4X4    = 2,
    ASTC_HDR_6X6     = 3,
    UASTC_HDR_6X6    = 4,
    XUASTC_LDR_4X4   = 5,
    XUASTC_LDR_5X4   = 6,
    XUASTC_LDR_5X5   = 7,
    XUASTC_LDR_6X5   = 8,
    XUASTC_LDR_6X6   = 9,
    XUASTC_LDR_8X5   = 10,
    XUASTC_LDR_8X6   = 11,
    XUASTC_LDR_10X5  = 12,
    XUASTC_LDR_10X6  = 13,
    XUASTC_LDR_8X8   = 14,
    XUASTC_LDR_10X8  = 15,
    XUASTC_LDR_10X10 = 16,
    XUASTC_LDR_12X10 = 17,
    XUASTC_LDR_12X12 = 18,
    ASTC_LDR_4X4     = 19,
    ASTC_LDR_5X4     = 20,
    ASTC_LDR_5X5     = 21,
    ASTC_LDR_6X5     = 22,
    ASTC_LDR_6X6     = 23,
    ASTC_LDR_8X5     = 24,
    ASTC_LDR_8X6     = 25,
    ASTC_LDR_10X5    = 26,
    ASTC_LDR_10X6    = 27,
    ASTC_LDR_8X8     = 28,
    ASTC_LDR_10X8    = 29,
    ASTC_LDR_10X10   = 30,
    ASTC_LDR_12X10   = 31,
    ASTC_LDR_12X12   = 32,
}

QUALITY_MIN :: 0
QUALITY_MAX :: 100

BU_EFFORT_MIN :: 0
BU_EFFORT_MAX :: 10
BU_EFFORT_SUPER_FAST :: 0
BU_EFFORT_FAST :: 2
BU_EFFORT_NORMAL :: 5
BU_EFFORT_DEFAULT :: 2
BU_EFFORT_SLOW :: 8
BU_EFFORT_VERY_SLOW :: 10

Comp_Flag :: enum u64 {
    Use_OpenCL                 = 8,
    Threaded                   = 9,
    Debug_Output               = 10,
    KTX2_Output                = 11,
    KTX2_UASTC_ZSTD            = 12,
    SRGB                       = 13,
    Gen_MIPS_Clamp             = 14,
    Gen_MIPS_Wrap              = 15,
    Y_Flip                     = 16,
    Print_Stats                = 18,
    Print_Status               = 19,
    Debug_Images               = 20,
    REC2020                    = 21,
    Validate_Output            = 22,
    XUASTC_LDR_Hybrid          = 23,
    XUASTC_LDR_Full_ZSTD       = 24,
    // Texture_Type_2D = 0 << 25
    Texture_Type_2D_Array      = 25,
    Texture_Type_Cubemap_Array = 26,
}
Comp_Flags :: bit_set[Comp_Flag;u64]

@(default_calling_convention = "c")
foreign lib {
    bu_get_version :: proc() -> u32 ---
    bu_init :: proc() ---
}

@(link_prefix = "bu_", default_calling_convention = "c")
foreign lib {
    enable_debug_printf :: proc(flag: u32) ---
    alloc :: proc(size: u64) -> u64 ---
    free :: proc(ofs: u64) ---
    new_comp_params :: proc() -> u64 ---
    delete_comp_params :: proc(params_ofs: u64) -> b32 ---
    comp_params_get_comp_data_size :: proc(params_ofs: u64) -> u64 ---
    comp_params_get_comp_data_ofs :: proc(params_ofs: u64) -> u64 ---
    comp_params_clear :: proc(params_ofs: u64) -> b32 ---

    comp_params_set_image_rgba32 :: proc(params_ofs: u64, image_index: u32, img_data_ofs: u64, width, height: u32, pitch_in_bytes: u32) -> b32 ---
    comp_params_set_image_float_rgba :: proc(params_ofs: u64, image_index: u32, img_data_ofs: u64, width, height: u32, pitch_in_bytes: u32) -> b32 ---
    compress_texture :: proc(params_ofs: u64, desired_basis_tex_format: Basis_Format, quality_level: i32, effort_level: i32, flags_and_quality: Comp_Flags, low_level_uastc_rdo_or_dct_quality: f32) -> b32 ---
}
