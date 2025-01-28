use garaga::definitions::{G1Point, G2Point, E12D, G2Line, u384};
use garaga::definitions::u288;
use garaga::groth16::Groth16VerifyingKey;

pub const N_PUBLIC_INPUTS: usize = 4;

pub const vk: Groth16VerifyingKey =
    Groth16VerifyingKey {
        alpha_beta_miller_loop_result: E12D {
            w0: u288 {
                limb0: 0x38febe9f87f730fa3e5bd174,
                limb1: 0xf763950637a776ef9e248435,
                limb2: 0x29dc2d37c63acbda
            },
            w1: u288 {
                limb0: 0xa31610a97aa4e4539be919ff,
                limb1: 0xfa4d4bfb72b6a3c002018e97,
                limb2: 0x1968ab971e610fce
            },
            w2: u288 {
                limb0: 0xee6c1ce3a15313c6f9d57f7e,
                limb1: 0xd37e28396640fcfe5f122aae,
                limb2: 0x210d3763f7a27517
            },
            w3: u288 {
                limb0: 0x7746ddac185562e756b1b92f,
                limb1: 0x44f8b75638ef5a373f319cd8,
                limb2: 0x51e9605db4edac6
            },
            w4: u288 {
                limb0: 0xc29e0c2ac434301d671ffa56,
                limb1: 0xa06f1db2d4ca4dd88f979102,
                limb2: 0x1d0126fb7d721e02
            },
            w5: u288 {
                limb0: 0xed2e022e10acbeb35084dc1,
                limb1: 0xf9de514baee870f114669060,
                limb2: 0x10889a0f300ce96c
            },
            w6: u288 {
                limb0: 0xeec23aadde92d2dd00e4568e,
                limb1: 0x6d5b4b63667db8f10bd851ab,
                limb2: 0x18f1dd15d2e64c69
            },
            w7: u288 {
                limb0: 0x2131bad24ea07a033d0bf397,
                limb1: 0xb6312a7f2622146be93b5950,
                limb2: 0x227e61ca055f0ac3
            },
            w8: u288 {
                limb0: 0xb896f30b06350f012274ebcd,
                limb1: 0xd14298f13a76183170aafe08,
                limb2: 0x302bfd90358d23a0
            },
            w9: u288 {
                limb0: 0x679d91263798da428fa5ea62,
                limb1: 0x806797d163f4df8b55ec774c,
                limb2: 0x29b72d4ec063face
            },
            w10: u288 {
                limb0: 0x4dbef45fe0c5a14bef7c4a90,
                limb1: 0xd4ae215c443d0f0768198bc6,
                limb2: 0x2fcc02633e427272
            },
            w11: u288 {
                limb0: 0x7308cad65773475443cfbd80,
                limb1: 0x972f90a77f1a8aeece6571ff,
                limb2: 0x2d3a570362a9fd7f
            }
        },
        gamma_g2: G2Point {
            x0: u384 {
                limb0: 0xf75edadd46debd5cd992f6ed,
                limb1: 0x426a00665e5c4479674322d4,
                limb2: 0x1800deef121f1e76,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x35a9e71297e485b7aef312c2,
                limb1: 0x7260bfb731fb5d25f1aa4933,
                limb2: 0x198e9393920d483a,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xc43d37b4ce6cc0166fa7daa,
                limb1: 0x4aab71808dcb408fe3d1e769,
                limb2: 0x12c85ea5db8c6deb,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x70b38ef355acdadcd122975b,
                limb1: 0xec9e99ad690c3395bc4b3133,
                limb2: 0x90689d0585ff075,
                limb3: 0x0
            }
        },
        delta_g2: G2Point {
            x0: u384 {
                limb0: 0xa0951fb9110682341f97ca9c,
                limb1: 0x8d78a9700e87b5e1c3fc2381,
                limb2: 0x11bc2aba0fe210c,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0x2b2f25bfddb5cbc467290cb2,
                limb1: 0x3d8cf4289eec4e680237201f,
                limb2: 0x1ffbc3c5cef19d2c,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xcb9a86a9e843219b6935cbdf,
                limb1: 0xd2b719d806f6e0859ca23490,
                limb2: 0x2c3903250b072875,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x5192dd2541b6119366513442,
                limb1: 0xe71f44a07aae3cc8a85812b8,
                limb2: 0x298f30ba1dd48fde,
                limb3: 0x0
            }
        }
    };

pub const ic: [
    G1Point
    ; 5] = [
    G1Point {
        x: u384 {
            limb0: 0x14220647ec2e657103b52894,
            limb1: 0x4d009e1cf469eb58d1845a32,
            limb2: 0x20cb58557691ca3d,
            limb3: 0x0
        },
        y: u384 {
            limb0: 0xd75d7ca7c27383a7b7791531,
            limb1: 0x2f12455705c71153f6d79021,
            limb2: 0x2318e7f5a7366fc1,
            limb3: 0x0
        }
    },
    G1Point {
        x: u384 {
            limb0: 0x64221816db7a0e45f06fcea3,
            limb1: 0xa44e6380a55f722592f02f9,
            limb2: 0x18d1986ff281019f,
            limb3: 0x0
        },
        y: u384 {
            limb0: 0xe6d6874955dd583dd3f88d32,
            limb1: 0x40151c9bf1f150d590b08283,
            limb2: 0x21a50a0d90a3253,
            limb3: 0x0
        }
    },
    G1Point {
        x: u384 {
            limb0: 0x70d4fd3b6e473ffe49167391,
            limb1: 0x9b80e204f5898718142e1287,
            limb2: 0x678b668f7222d78,
            limb3: 0x0
        },
        y: u384 {
            limb0: 0x2529d3613d1304fb59e0023e,
            limb1: 0xb5e14cd8cb4dcb63a169c8d2,
            limb2: 0x15fd55ee79369bb0,
            limb3: 0x0
        }
    },
    G1Point {
        x: u384 {
            limb0: 0x84bc35139843ec800835d34e,
            limb1: 0xc6a519245253912166cf6408,
            limb2: 0x27890e97b9ea79ff,
            limb3: 0x0
        },
        y: u384 {
            limb0: 0xd21177df21d2989d2544839,
            limb1: 0xfc1bdca01449d6a010d97364,
            limb2: 0x2ebcdb234040ad9d,
            limb3: 0x0
        }
    },
    G1Point {
        x: u384 {
            limb0: 0xca4815f021c56a749eab6806,
            limb1: 0x5d559d538487677175ad5,
            limb2: 0xd9d2fc7c086b7ba,
            limb3: 0x0
        },
        y: u384 {
            limb0: 0x1c44831ca24176aa349bfe5,
            limb1: 0x67a9b45196f113f564983d41,
            limb2: 0xafd96c81bc01fbe,
            limb3: 0x0
        }
    },
];


pub const precomputed_lines: [
    G2Line
    ; 176] = [
    G2Line {
        r0a0: u288 {
            limb0: 0x4d347301094edcbfa224d3d5,
            limb1: 0x98005e68cacde68a193b54e6,
            limb2: 0x237db2935c4432bc
        },
        r0a1: u288 {
            limb0: 0x6b4ba735fba44e801d415637,
            limb1: 0x707c3ec1809ae9bafafa05dd,
            limb2: 0x124077e14a7d826a
        },
        r1a0: u288 {
            limb0: 0x49a8dc1dd6e067932b6a7e0d,
            limb1: 0x7676d0000961488f8fbce033,
            limb2: 0x3b7178c857630da
        },
        r1a1: u288 {
            limb0: 0x98c81278efe1e96b86397652,
            limb1: 0xe3520b9dfa601ead6f0bf9cd,
            limb2: 0x2b17c2b12c26fdd0
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xee6660f4202559f041af958f,
            limb1: 0x531534a7ad359a819cfd658c,
            limb2: 0x13125cf91210a527
        },
        r0a1: u288 {
            limb0: 0xb7c8ab1afd9d421c494b1a0,
            limb1: 0x9721dce95c32a9cd8cc904dd,
            limb2: 0x25a185d03ece75fe
        },
        r1a0: u288 {
            limb0: 0x71b2a9f2b4245c33fbbc8f73,
            limb1: 0x3ae9ae0d6999f9f8d4ac37fa,
            limb2: 0x238e574f6353103
        },
        r1a1: u288 {
            limb0: 0xa6d8b08f25b5546a97f32415,
            limb1: 0x15283dae2db7ad66b4b8d02e,
            limb2: 0xc61969dd28ac3c9
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x1b3d578c32d1af5736582972,
            limb1: 0x204fe74db6b371d37e4615ab,
            limb2: 0xce69bdf84ed6d6d
        },
        r0a1: u288 {
            limb0: 0xfd262357407c3d96bb3ba710,
            limb1: 0x47d406f500e66ea29c8764b3,
            limb2: 0x1e23d69196b41dbf
        },
        r1a0: u288 {
            limb0: 0x1ec8ee6f65402483ad127f3a,
            limb1: 0x41d975b678200fce07c48a5e,
            limb2: 0x2cad36e65bbb6f4f
        },
        r1a1: u288 {
            limb0: 0xcfa9b8144c3ea2ab524386f5,
            limb1: 0xd4fe3a18872139b0287570c3,
            limb2: 0x54c8bc1b50aa258
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb5ee22ba52a7ed0c533b7173,
            limb1: 0xbfa13123614ecf9c4853249b,
            limb2: 0x6567a7f6972b7bb
        },
        r0a1: u288 {
            limb0: 0xcf422f26ac76a450359f819e,
            limb1: 0xc42d7517ae6f59453eaf32c7,
            limb2: 0x899cb1e339f7582
        },
        r1a0: u288 {
            limb0: 0x9f287f4842d688d7afd9cd67,
            limb1: 0x30af75417670de33dfa95eda,
            limb2: 0x1121d4ca1c2cab36
        },
        r1a1: u288 {
            limb0: 0x7c4c55c27110f2c9a228f7d8,
            limb1: 0x8f14f6c3a2e2c9d74b347bfe,
            limb2: 0x83ef274ba7913a5
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x7a0b69991bfb322696cd67b8,
            limb1: 0x653b110ed44bbddbfa840504,
            limb2: 0x1d51f179cf20fb02
        },
        r0a1: u288 {
            limb0: 0x5cf53fdb8c46b7f513e84ba7,
            limb1: 0x212e68cd254eae900ab865b4,
            limb2: 0xac2c8a2a2632a2b
        },
        r1a0: u288 {
            limb0: 0xf6bf209a87fc2fe2dcc06dd4,
            limb1: 0x7d6697a917e75e64c2d53296,
            limb2: 0x2e2b68fdeafc6f26
        },
        r1a1: u288 {
            limb0: 0xc19919fe166b37ac4089d932,
            limb1: 0xa328080853c9aaf6e2c89a62,
            limb2: 0x2402b7d50ea6dc60
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x286672851c2871424ea76bcb,
            limb1: 0x426645db8c7a50bb66491ae,
            limb2: 0x1d6fad72cec4fca3
        },
        r0a1: u288 {
            limb0: 0x654531ed85bbb264d445940b,
            limb1: 0x4b076dfe149d9b29edda86f8,
            limb2: 0x2938d5110d4b2bc8
        },
        r1a0: u288 {
            limb0: 0xb80c32439562c70e73981f33,
            limb1: 0xfccfad4f7f409bb31826eb8f,
            limb2: 0x1707f55e1a30e5f9
        },
        r1a1: u288 {
            limb0: 0xaf1a2ee37b640643b3ebb9d7,
            limb1: 0xb8c72776b7907fa4ded86e89,
            limb2: 0x291757182558f3ea
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xfc23a674d089e9cfdefb1db8,
            limb1: 0x9ddfd61d289b65a9b4254476,
            limb2: 0x1e2f561324ef4447
        },
        r0a1: u288 {
            limb0: 0xf67a6a9e31f6975b220642ea,
            limb1: 0xccd852893796296e4d1ed330,
            limb2: 0x94ff1987d19b62
        },
        r1a0: u288 {
            limb0: 0x360c2a5aca59996d24cc1947,
            limb1: 0x66c2d7d0d176a3bc53f386e8,
            limb2: 0x2cfcc62a17fbeecb
        },
        r1a1: u288 {
            limb0: 0x2ddc73389dd9a9e34168d8a9,
            limb1: 0xae9afc57944748b835cbda0f,
            limb2: 0x12f0a1f8cf564067
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xcd00c101147785fc365b9b07,
            limb1: 0xba83d310c35d2aa4a10b28fd,
            limb2: 0x2430ba65fc7d0108
        },
        r0a1: u288 {
            limb0: 0x571f3ae9393653f3c9d3a511,
            limb1: 0x543ed4ec1e7d95928459fd58,
            limb2: 0x19a789576919a4b8
        },
        r1a0: u288 {
            limb0: 0xe2ac69f623d0eb908c804fb7,
            limb1: 0x704d039558ea6cdee205a04c,
            limb2: 0xcc4ce8d7b45bea4
        },
        r1a1: u288 {
            limb0: 0xda44e452defc0496924b2c31,
            limb1: 0x8255b5fd1d55c047d0c23254,
            limb2: 0x29762ac9ad5beee1
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x9c963c4bdade6ce3d460b077,
            limb1: 0x1738311feefc76f565e34e8a,
            limb2: 0x1aae0d6c9e9888ad
        },
        r0a1: u288 {
            limb0: 0x9272581fdf80b045c9c3f0a,
            limb1: 0x3946807b0756e87666798edb,
            limb2: 0x2bf6eeda2d8be192
        },
        r1a0: u288 {
            limb0: 0x3e957661b35995552fb475de,
            limb1: 0xd8076fa48f93f09d8128a2a8,
            limb2: 0xb6f87c3f00a6fcf
        },
        r1a1: u288 {
            limb0: 0xcf17d6cd2101301246a8f264,
            limb1: 0x514d04ad989b91e697aa5a0e,
            limb2: 0x175f17bbd0ad1219
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x894bc18cc70ca1987e3b8f9f,
            limb1: 0xd4bfa535181f0f8659b063e3,
            limb2: 0x19168d524164f463
        },
        r0a1: u288 {
            limb0: 0x850ee8d0e9b58b82719a6e92,
            limb1: 0x9fc4eb75cbb027c137d48341,
            limb2: 0x2b2f8a383d944fa0
        },
        r1a0: u288 {
            limb0: 0x5451c8974a709483c2b07fbd,
            limb1: 0xd7e09837b8a2a3b78e7fe525,
            limb2: 0x347d96be5e7fa31
        },
        r1a1: u288 {
            limb0: 0x823f2ba2743ee254e4c18a1e,
            limb1: 0x6a61af5db035c443ed0f8172,
            limb2: 0x1e840eee275d1063
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x5135d6cfcc304bc23dffa029,
            limb1: 0xe5052de34f42ac2bcc27b9ef,
            limb2: 0x1569ebfb40d8f98b
        },
        r0a1: u288 {
            limb0: 0x5a3596e66000fb756ddedef8,
            limb1: 0x554cbc09da5d697029734705,
            limb2: 0x1b69bc00f8572eed
        },
        r1a0: u288 {
            limb0: 0xf315d36159433b1e565ea146,
            limb1: 0xa2ce5697de1d6f5527369e16,
            limb2: 0x6ec7d84e693d814
        },
        r1a1: u288 {
            limb0: 0xb550488b4eee241c932f6266,
            limb1: 0xd8116d9f861d299494d63785,
            limb2: 0x11f2f56f0cb7433d
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x5a712d5ffa948450403ebc58,
            limb1: 0xa7c6a1e316259fb9ef37e77e,
            limb2: 0x14e25bc3cf05d60b
        },
        r0a1: u288 {
            limb0: 0x85f98b23b580d8042702d5c7,
            limb1: 0x5c4aca080bb612df677eec1c,
            limb2: 0x22008edc09592771
        },
        r1a0: u288 {
            limb0: 0xbd63f3bfce82e6d8d9b62b50,
            limb1: 0xc7227d4e8118c91797be3aef,
            limb2: 0x2e321710c77c9791
        },
        r1a1: u288 {
            limb0: 0x871fb34e090f209d5772dcf4,
            limb1: 0x598a47d5f91ec4bd307d7879,
            limb2: 0x16ccd2516d287d1c
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x18d630598e58bb5d0102b30e,
            limb1: 0x9767e27b02a8da37411a2787,
            limb2: 0x100a541662b9cd7c
        },
        r0a1: u288 {
            limb0: 0x4ca7313df2e168e7e5ea70,
            limb1: 0xd49cce6abd50b574f31c2d72,
            limb2: 0x78a2afbf72317e7
        },
        r1a0: u288 {
            limb0: 0x6d99388b0a1a67d6b48d87e0,
            limb1: 0x1d8711d321a193be3333bc68,
            limb2: 0x27e76de53a010ce1
        },
        r1a1: u288 {
            limb0: 0x77341bf4e1605e982fa50abd,
            limb1: 0xc5cf10db170b4feaaf5f8f1b,
            limb2: 0x762adef02274807
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xba114f806b589de0b25bdc24,
            limb1: 0xe7fc6c919a5fb60a50a5715,
            limb2: 0x2381e0be929591d0
        },
        r0a1: u288 {
            limb0: 0x2d000c6eeeacb4057603d0ea,
            limb1: 0x19e7ddde8e77b48a70aee640,
            limb2: 0x165242133e417d11
        },
        r1a0: u288 {
            limb0: 0xc44d45744a11e7043597c8bc,
            limb1: 0x4b2d337d702b396ae48ee7e3,
            limb2: 0x60567c82a0f6f2f
        },
        r1a1: u288 {
            limb0: 0x4d18262e449ac3711a2ca39,
            limb1: 0xad0e1c6dfc4379d3de3eaa3d,
            limb2: 0x8bf73aeda4a11a0
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xa137b991ba9048aee9fa0bc7,
            limb1: 0xf5433785c186cd1100ab6b80,
            limb2: 0xab519fd7cf8e7f9
        },
        r0a1: u288 {
            limb0: 0x90832f45d3398c60aa1a74e2,
            limb1: 0x17f7ac209532723f22a344b,
            limb2: 0x23db979f8481c5f
        },
        r1a0: u288 {
            limb0: 0x723b0e23c2808a5d1ea6b11d,
            limb1: 0x3030030d26411f84235c3af5,
            limb2: 0x122e78da5509eddb
        },
        r1a1: u288 {
            limb0: 0xf1718c1e21a9bc3ec822f319,
            limb1: 0xf5ee6dfa3bd3272b2f09f0c7,
            limb2: 0x5a29c1e27616b34
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x88a64ed7345f434970c500f7,
            limb1: 0xb02b897215b26a533692c262,
            limb2: 0x2fd98e56e8e6a81a
        },
        r0a1: u288 {
            limb0: 0x9491151d37eb0dc7f6c3ddb2,
            limb1: 0xbb87425ed1f6f9efbfa65d10,
            limb2: 0x1cf96a292deb93c0
        },
        r1a0: u288 {
            limb0: 0xc8243433a8874b042caedb59,
            limb1: 0x7714380b8cfd4a4e91915f91,
            limb2: 0xb79eea506c81dc7
        },
        r1a1: u288 {
            limb0: 0x81edaf43a027faff11197571,
            limb1: 0xf503b71a0307fa36ed57013e,
            limb2: 0x107455ed52956e68
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xbc1ede480873fceb8739511e,
            limb1: 0xd5a60533bd0ce7869efbc15,
            limb2: 0x182c17d793eba74d
        },
        r0a1: u288 {
            limb0: 0x83bf38d91876ad8999516bc2,
            limb1: 0x7756322ea3dc079289d51f2d,
            limb2: 0x1d0f6156a89a4244
        },
        r1a0: u288 {
            limb0: 0x6aba652f197be8f99707b88c,
            limb1: 0xbf94286c245794ea0f562f32,
            limb2: 0x25a358967a2ca81d
        },
        r1a1: u288 {
            limb0: 0xc028cbff48c01433e8b23568,
            limb1: 0xd2e791f5772ed43b056beba1,
            limb2: 0x83eb38dff4960e
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x3fd78974280d663b671f2c16,
            limb1: 0xa76b2a86513c397c5bb4fccc,
            limb2: 0x1d7730213780c0dc
        },
        r0a1: u288 {
            limb0: 0x2153ba5754a197595510ec98,
            limb1: 0x49494c4c03f50583f3ae35c1,
            limb2: 0x160615903ec5e53d
        },
        r1a0: u288 {
            limb0: 0x5ab3e89d8023b701ef539570,
            limb1: 0x8e6a43ef6bd3da19872c3b8b,
            limb2: 0x8fffb0e4098cf29
        },
        r1a1: u288 {
            limb0: 0xb7e1487f9a98e24e2bfb2a0,
            limb1: 0x466037077ed054b7a240e86b,
            limb2: 0x2a324b779ae4eafc
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xc2a2b787d8e718e81970db80,
            limb1: 0x5372abeaf56844dee60d6198,
            limb2: 0x131210153a2217d6
        },
        r0a1: u288 {
            limb0: 0x70421980313e09a8a0e5a82d,
            limb1: 0xf75ca1f68f4b8deafb1d3b48,
            limb2: 0x102113c9b6feb035
        },
        r1a0: u288 {
            limb0: 0x4654c11d73bda84873de9b86,
            limb1: 0xa67601bca2e595339833191a,
            limb2: 0x1c2b76e439adc8cc
        },
        r1a1: u288 {
            limb0: 0x9c53a48cc66c1f4d644105f2,
            limb1: 0xa17a18867557d96fb7c2f849,
            limb2: 0x1deb99799bd8b63a
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xc32026c56341297fa080790c,
            limb1: 0xe23ad2ff283399133533b31f,
            limb2: 0xa6860f5c968f7ad
        },
        r0a1: u288 {
            limb0: 0x2966cf259dc612c6a4d8957d,
            limb1: 0xfba87ea86054f3db5774a08f,
            limb2: 0xc73408b6a646780
        },
        r1a0: u288 {
            limb0: 0x6272ce5976d8eeba08f66b48,
            limb1: 0x7dfbd78fa06509604c0cec8d,
            limb2: 0x181ec0eaa6660e45
        },
        r1a1: u288 {
            limb0: 0x48af37c1a2343555fbf8a357,
            limb1: 0xa7b5e1e20e64d6a9a9ce8e61,
            limb2: 0x1147dcea39a47abd
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xe33dafb9a46651f7c67fbe93,
            limb1: 0x39c7c4a194c61b0d7fcb4977,
            limb2: 0x2e95a9c6e047fc59
        },
        r0a1: u288 {
            limb0: 0xb499320965047045f668e24,
            limb1: 0x96b426e9c957c44fce775add,
            limb2: 0x6120b0a03c71536
        },
        r1a0: u288 {
            limb0: 0xb965b67c690f047f80e6ac37,
            limb1: 0x4f006cd37601e26589dce379,
            limb2: 0xe752916787996b9
        },
        r1a1: u288 {
            limb0: 0xc065a4aec4c1851544d98083,
            limb1: 0x3e22c10874afddfb156d642d,
            limb2: 0x645083c24ce9e8e
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x7eaba622ce4bc4b3dd39f52c,
            limb1: 0xf5f0b49504bc7f2fa8ad1cb4,
            limb2: 0x18a21f49d8c885ea
        },
        r0a1: u288 {
            limb0: 0xc7fde1514b185425812b8a81,
            limb1: 0xa9013889115f5cb89c534244,
            limb2: 0x23acfb26b1b920f7
        },
        r1a0: u288 {
            limb0: 0xb7055c4ba7676831454b1033,
            limb1: 0xdb8aba722e419640af80d918,
            limb2: 0x4af2b991f4a5a31
        },
        r1a1: u288 {
            limb0: 0x6536c61d17ba346f4548d962,
            limb1: 0x71d86eb7a8b9fb558ad6faec,
            limb2: 0x11138df20dd07eeb
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x4033c51e6e469818521cd2ae,
            limb1: 0xb71a4629a4696b2759f8e19e,
            limb2: 0x4f5744e29c1eb30
        },
        r0a1: u288 {
            limb0: 0xa4f47bbc60cb0649dca1c772,
            limb1: 0x835f427106f4a6b897c6cf23,
            limb2: 0x17ca6ea4855756bb
        },
        r1a0: u288 {
            limb0: 0x7f844a35c7eeadf511e67e57,
            limb1: 0x8bb54fb0b3688cac8860f10,
            limb2: 0x1c7258499a6bbebf
        },
        r1a1: u288 {
            limb0: 0x10d269c1779f96946e518246,
            limb1: 0xce6fcef6676d0dacd395dc1a,
            limb2: 0x2cf4c6ae1b55d87d
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xfc08ba65b3ed6225bbea1889,
            limb1: 0x3f95f82316c9b05b3410741e,
            limb2: 0x1471a8f749f6c512
        },
        r0a1: u288 {
            limb0: 0x47852f0cc9a489c9f09f3bf0,
            limb1: 0xb93621aa7be855100e8bcbc3,
            limb2: 0xda9e63e5dde9abd
        },
        r1a0: u288 {
            limb0: 0x92ec8f6bc784552d8ba39ce1,
            limb1: 0xb6cfe5bb6cc40eb2f577ec29,
            limb2: 0xb8d5254cc6668c
        },
        r1a1: u288 {
            limb0: 0xebbe4390c2e9390c3f3bd4f1,
            limb1: 0xcbf0d1a0325df3515e29011c,
            limb2: 0xb555c2bb0cc0c7c
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xab74a6bae36b17b1d2cc1081,
            limb1: 0x904cf03d9d30b1fe9dc71374,
            limb2: 0x14ffdd55685b7d82
        },
        r0a1: u288 {
            limb0: 0x277f7180b7cf33feded1583c,
            limb1: 0xc029c3968a75b612303c4298,
            limb2: 0x20ef4ba03605cdc6
        },
        r1a0: u288 {
            limb0: 0xd5a7a27c1baba3791ab18957,
            limb1: 0x973730213d5d70d3e62d6db,
            limb2: 0x24ca121c566eb857
        },
        r1a1: u288 {
            limb0: 0x9f4c2dea0492f548ae7d9e93,
            limb1: 0xe584b6b251a5227c70c5188,
            limb2: 0x22bcecac2bd5e51b
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x340c82974f7221a53fc2f3ac,
            limb1: 0x7146f18cd591d423874996e7,
            limb2: 0xa6d154791056f46
        },
        r0a1: u288 {
            limb0: 0x70894ea6418890d53b5ee12a,
            limb1: 0x882290cb53b795b0e7c8c208,
            limb2: 0x1b5777dc18b2899b
        },
        r1a0: u288 {
            limb0: 0x99a0e528d582006a626206b6,
            limb1: 0xb1cf825d80e199c5c9c795b5,
            limb2: 0x2a97495b032f0542
        },
        r1a1: u288 {
            limb0: 0xc7cf5b455d6f3ba73debeba5,
            limb1: 0xbb0a01235687223b7b71d0e5,
            limb2: 0x250024ac44c35e3f
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xbf4eb0cb537772ecd82ab6b1,
            limb1: 0x53fd7d4bda88dfdbadccb13a,
            limb2: 0xff78f245e18206f
        },
        r0a1: u288 {
            limb0: 0x53f582f177b2ce39d23e7ec0,
            limb1: 0xc05b48f29bfb50641e853f2,
            limb2: 0xa97382ae092dfdd
        },
        r1a0: u288 {
            limb0: 0x8b59cd2a7112d68e872badb3,
            limb1: 0x8d4028d820e1d48e94889c9,
            limb2: 0x103bb2bbd471c10f
        },
        r1a1: u288 {
            limb0: 0x333733bd3a36ba7e4d149cd5,
            limb1: 0xc30535ee0305917f3337ae3d,
            limb2: 0x25ed4a4aa651f153
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x5d876816949c4e972fbdd705,
            limb1: 0x71868f008d1ca9c67fdfbf2d,
            limb2: 0x1de5661f4b9104a6
        },
        r0a1: u288 {
            limb0: 0xe994ba5081a6722649dce771,
            limb1: 0x48eb71e2905c78a121ed717b,
            limb2: 0x27638aac37e41863
        },
        r1a0: u288 {
            limb0: 0xd5850c37651e93d78f8ab709,
            limb1: 0xb2ce989a19b00e8aeb3ddf5b,
            limb2: 0x2b9a70f854949f4e
        },
        r1a1: u288 {
            limb0: 0x89521b08861ab4f62514b67f,
            limb1: 0x4bada475d1cb2e7f0b1195ba,
            limb2: 0xf88cd55b75bdec8
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xccf841cf5c1cf8f4a0485e28,
            limb1: 0xb5077662d0ce9d755af1446b,
            limb2: 0x2b08658e9d5ba5cb
        },
        r0a1: u288 {
            limb0: 0x6ce62184a15685babd77f27f,
            limb1: 0x5ff9bb7d74505b0542578299,
            limb2: 0x7244563488bab2
        },
        r1a0: u288 {
            limb0: 0xec778048d344ac71275d961d,
            limb1: 0x1273984019753000ad890d33,
            limb2: 0x27c2855e60d361bd
        },
        r1a1: u288 {
            limb0: 0xa7a0071e22af2f3a79a12da,
            limb1: 0xc84a6fd41c20759ff6ff169a,
            limb2: 0x23e7ef2a308e49d1
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x798df800291b8f7622aa5be1,
            limb1: 0x4124d390b7558ab431d73566,
            limb2: 0x2cf19481e3045f85
        },
        r0a1: u288 {
            limb0: 0xe10c0161dc472cc8824adfdc,
            limb1: 0x611e1575221bdc55b6883361,
            limb2: 0x2f7e4bc45c5d0f68
        },
        r1a0: u288 {
            limb0: 0xee1754fbdcd43f0ea49fa2e4,
            limb1: 0xf8b4890115b657ce8d8e52f7,
            limb2: 0x1222a1ddaff4f0d0
        },
        r1a1: u288 {
            limb0: 0x55a945b6689e9ea0e6a1282d,
            limb1: 0x7ee39d618955dd2324c2b600,
            limb2: 0x1eaadcbbe9d0d631
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x7105024c431a33683d9d0b9d,
            limb1: 0x12e23637b641ab0e5b322ad8,
            limb2: 0x2918e9e08c764c28
        },
        r0a1: u288 {
            limb0: 0x26384979d1f5417e451aeabf,
            limb1: 0xacfb499e362291d0b053bbf6,
            limb2: 0x2a6ad1a1f7b04ef6
        },
        r1a0: u288 {
            limb0: 0xba4db515be70c384080fc9f9,
            limb1: 0x5a983a6afa9cb830fa5b66e6,
            limb2: 0x8cc1fa494726a0c
        },
        r1a1: u288 {
            limb0: 0x59c9af9399ed004284eb6105,
            limb1: 0xef37f66b058b4c971d9c96b0,
            limb2: 0x2c1839afde65bafa
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xaab11eed72c8fafd575eb190,
            limb1: 0xa758e6a289db5b493637f3cf,
            limb2: 0x1d582c81088e7ddf
        },
        r0a1: u288 {
            limb0: 0x109a9d2b04ee68ab3f060627,
            limb1: 0x7a3efea26f0deae07a932c53,
            limb2: 0x2d850e4b8c57871a
        },
        r1a0: u288 {
            limb0: 0x1e828ce609855811e156d899,
            limb1: 0xec4637cd3657f8a234aec95e,
            limb2: 0xbdb740f8d32f5fe
        },
        r1a1: u288 {
            limb0: 0x8e43583c7c158ee4df952a72,
            limb1: 0x2f63de0a058787e1fed17677,
            limb2: 0x213193366428cd94
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x6bf13a27b0f4eb6657abc4b,
            limb1: 0xf78d57f089bffdf07c676bb3,
            limb2: 0x228e4aefbdd738df
        },
        r0a1: u288 {
            limb0: 0x4f41a40b04ec964619823053,
            limb1: 0xfa3fb44f4a80641a9bb3bc09,
            limb2: 0x29bf29a3d071ec4b
        },
        r1a0: u288 {
            limb0: 0x83823dcdff02bdc8a0e6aa03,
            limb1: 0x79ac92f113de29251cd73a98,
            limb2: 0x1ccdb791718d144
        },
        r1a1: u288 {
            limb0: 0xa074add9d066db9a2a6046b6,
            limb1: 0xef3a70034497456c7d001a5,
            limb2: 0x27d09562d815b4a6
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x28d244eca8702c88d94757f8,
            limb1: 0x70ca1733f01bf9da874b956e,
            limb2: 0x5c3b466ac4b970
        },
        r0a1: u288 {
            limb0: 0x917cbd006c7cc56fd2bbc086,
            limb1: 0x54b08080adb086216c18c34e,
            limb2: 0x14d23740b2356071
        },
        r1a0: u288 {
            limb0: 0x14351fccb63df8958ee081ab,
            limb1: 0xccd40304531a4904d7859fc5,
            limb2: 0x1b33294b4e818be3
        },
        r1a1: u288 {
            limb0: 0xab185423fe07f19b391384f4,
            limb1: 0x33348243760f41f86931eb51,
            limb2: 0xf9c3c66d9604d84
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x87a44d343cc761056f4f2eae,
            limb1: 0x18016f16818253360d2c8adf,
            limb2: 0x1bcd5c6e597d735e
        },
        r0a1: u288 {
            limb0: 0x593d7444c376f6d69289660b,
            limb1: 0x1d6d97020b59cf2e4b38be4f,
            limb2: 0x17133b62617f63a7
        },
        r1a0: u288 {
            limb0: 0x88cac99869bb335ec9553a70,
            limb1: 0x95bcfa7f7c0b708b4d737afc,
            limb2: 0x1eec79b9db274c09
        },
        r1a1: u288 {
            limb0: 0xe465a53e9fe085eb58a6be75,
            limb1: 0x868e45cc13e7fd9d34e11839,
            limb2: 0x2b401ce0f05ee6bb
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x83f48fbac5c1b94486c2d037,
            limb1: 0xf95d9333449543de78c69e75,
            limb2: 0x7bca8163e842be7
        },
        r0a1: u288 {
            limb0: 0x60157b2ff6e4d737e2dac26b,
            limb1: 0x30ab91893fcf39d9dcf1b89,
            limb2: 0x29a58a02490d7f53
        },
        r1a0: u288 {
            limb0: 0x520f9cb580066bcf2ce872db,
            limb1: 0x24a6e42c185fd36abb66c4ba,
            limb2: 0x309b07583317a13
        },
        r1a1: u288 {
            limb0: 0x5a4c61efaa3d09a652c72471,
            limb1: 0xfcb2676d6aa28ca318519d2,
            limb2: 0x1405483699afa209
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xdb8123baa9bb4f68c26333d1,
            limb1: 0x1b7fd8fa5ff1faf8a49b454f,
            limb2: 0x1ae2ef7e6945c2e5
        },
        r0a1: u288 {
            limb0: 0x763d60450d39205f3b4edf9c,
            limb1: 0xad17e5b1a95b9e65463b1271,
            limb2: 0x2d7bb2a18d36d7d9
        },
        r1a0: u288 {
            limb0: 0xe9875ef6eb2246f7ae1b5483,
            limb1: 0x377c2506f0c5515153e33594,
            limb2: 0x1f5f87ab0b8d8245
        },
        r1a1: u288 {
            limb0: 0x7b1432be97076f2160337314,
            limb1: 0x9fbede9b5e89e5f0220db138,
            limb2: 0x1746cebffcaea678
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x68009ee6f072dd8ef1f58f95,
            limb1: 0xb13aabe2ccbcc69e3cefb3f4,
            limb2: 0x1dabfb32a110e68e
        },
        r0a1: u288 {
            limb0: 0xdc36aa3c91687deef5ca35ed,
            limb1: 0xc6b2a664ccec8018a7d9b347,
            limb2: 0x1a93c83c87c81343
        },
        r1a0: u288 {
            limb0: 0x50f6eb305f6340af3ccfd0a4,
            limb1: 0x2ff9356d9b1636c1bb50a45c,
            limb2: 0x901c2294a84b01c
        },
        r1a1: u288 {
            limb0: 0x1f9aad2e25e896f2e5eab789,
            limb1: 0xd34a2d011df04ae9c1c399d6,
            limb2: 0x23d7a45dc9f4f664
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xbfdfdae86101e29da3e869b8,
            limb1: 0xf969a9b961a28b872e56aac2,
            limb2: 0x1afdc719440d90f0
        },
        r0a1: u288 {
            limb0: 0xee43c995686f13baa9b07266,
            limb1: 0xbfa387a694c641cceee4443a,
            limb2: 0x104d8c02eb7f60c8
        },
        r1a0: u288 {
            limb0: 0x8d451602b3593e798aecd7fb,
            limb1: 0x69ffbefe7c5ac2cf68e8691e,
            limb2: 0x2ea064a1bc373d28
        },
        r1a1: u288 {
            limb0: 0x6e7a663073bfe88a2b02326f,
            limb1: 0x5faadb36847ca0103793fa4a,
            limb2: 0x26c09a8ec9303836
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xcdccd0a02200554f401b18ed,
            limb1: 0x4b1caa978cf390713bc3900b,
            limb2: 0x2124d61d6f393e75
        },
        r0a1: u288 {
            limb0: 0x2796253fa8a0f79fdb132e8b,
            limb1: 0xb49b3b94dd5a28189f36d01,
            limb2: 0x1097ae6d48007add
        },
        r1a0: u288 {
            limb0: 0x2c442eb88b29032ce33a6787,
            limb1: 0xa300fc63811d1853d0b40dd5,
            limb2: 0x1231a426a934e20f
        },
        r1a1: u288 {
            limb0: 0x6a8832de23b5fbfca7c9d1e,
            limb1: 0xde76ab63507b89713d668bd2,
            limb2: 0x97055ef70130a51
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x3d038747ebac16adc1c50bdd,
            limb1: 0xe3706a783e99f73ac742aa1a,
            limb2: 0x17eac23b00b545ff
        },
        r0a1: u288 {
            limb0: 0xdc25ff0bd02abcbe502c4e37,
            limb1: 0x39b92e6ebb65e5f2d8504f90,
            limb2: 0x2415b5f61301dff6
        },
        r1a0: u288 {
            limb0: 0x9cdcb2146d15f37900db82ac,
            limb1: 0x96c3940e2f5c5f8198fadee3,
            limb2: 0x2f662ea79b473fc2
        },
        r1a1: u288 {
            limb0: 0xc0fb95686de65e504ed4c57a,
            limb1: 0xec396c7c4275d4e493b00713,
            limb2: 0x106d2aab8d90d517
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x6c2b5e190bbf3be192a0803d,
            limb1: 0x98b06d0812f6b9af12bd6b1c,
            limb2: 0xa3550ed3dca5670
        },
        r0a1: u288 {
            limb0: 0x78288c48cefb2145085a1749,
            limb1: 0x877d3e12b1faf58979f0fa05,
            limb2: 0x1b8f9e17dcfc5022
        },
        r1a0: u288 {
            limb0: 0x28395dfb858e7c20c021c684,
            limb1: 0xe856e836aa5451ab62dc1b4d,
            limb2: 0xb8ee333058e1ab7
        },
        r1a1: u288 {
            limb0: 0xf9e445b26343bae565a6cad3,
            limb1: 0xa5c11e8d1cfcccbc28877ac6,
            limb2: 0x14b19e21d586ca6b
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x49bbb4d856921e3177c0b5bf,
            limb1: 0x76d84d273694e662bdd5d364,
            limb2: 0xea5dc611bdd369d
        },
        r0a1: u288 {
            limb0: 0x9e9fc3adc530fa3c5c6fd7fe,
            limb1: 0x114bb0c0e8bd247da41b3883,
            limb2: 0x6044124f85d2ce
        },
        r1a0: u288 {
            limb0: 0xa6e604cdb4e40982a97c084,
            limb1: 0xef485caa56c7820be2f6b11d,
            limb2: 0x280de6387dcbabe1
        },
        r1a1: u288 {
            limb0: 0xcaceaf6df5ca9f8a18bf2e1e,
            limb1: 0xc5cce932cc6818b53136c142,
            limb2: 0x12f1cd688682030c
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x37497c23dcf629df58a5fa12,
            limb1: 0x4fcd5534ae47bded76245ac9,
            limb2: 0x1715ab081e32ac95
        },
        r0a1: u288 {
            limb0: 0x856275471989e2c288e3c83,
            limb1: 0xb42d81a575b89b127a7821a,
            limb2: 0x5fa75a0e4ae3118
        },
        r1a0: u288 {
            limb0: 0xeb22351e8cd345c23c0a3fef,
            limb1: 0x271feb16d4b47d2267ac9d57,
            limb2: 0x258f9950b9a2dee5
        },
        r1a1: u288 {
            limb0: 0xb5f75468922dc025ba7916fa,
            limb1: 0x7e24515de90edf1bde4edd9,
            limb2: 0x289145b3512d4d81
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x21d06066b15b74b9e4a6e535,
            limb1: 0x611a10bc44c1ef3fe4d58a59,
            limb2: 0x417b0466ce2748e
        },
        r0a1: u288 {
            limb0: 0x6c4c864690ab64936f3a7bb7,
            limb1: 0x60dca8f2777f77f9278dca4b,
            limb2: 0x55cf5f22768c1d6
        },
        r1a0: u288 {
            limb0: 0x9fccccde15ddb34b13e8edcd,
            limb1: 0xd9f33da18a6dcc7d9899e863,
            limb2: 0x17055cee5d42289c
        },
        r1a1: u288 {
            limb0: 0xaf9150b2dda6a7a9265a1415,
            limb1: 0x5d9a317c5e568be1e88522a9,
            limb2: 0x23a94c296f55fe5f
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x3679f4002f4c95ab9e64091,
            limb1: 0xf84f89221282c20d58ddad20,
            limb2: 0x2199184fa51db7c4
        },
        r0a1: u288 {
            limb0: 0x74d41363a2bcf82fc065e787,
            limb1: 0xb2c7da88c9bca39dc9d104dd,
            limb2: 0x3fd9358aa5f6efa
        },
        r1a0: u288 {
            limb0: 0x2d0c1378ae74af2363fff869,
            limb1: 0x7184b89214b206579dc6123c,
            limb2: 0xa75da536b6a601b
        },
        r1a1: u288 {
            limb0: 0xd1a65434f96a5b49390cabdf,
            limb1: 0xf168a1c1a3ddbe031518068d,
            limb2: 0x19076159802f4
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x95b7b32bcc3119c64a62a8de,
            limb1: 0xe07184496f17bbd59a4b7bbd,
            limb2: 0x1708c536fd78b531
        },
        r0a1: u288 {
            limb0: 0xfa85b5778c77166c1523a75e,
            limb1: 0x89a00c53309a9e525bef171a,
            limb2: 0x2d2287dd024e421
        },
        r1a0: u288 {
            limb0: 0x31fd0884eaf2208bf8831e72,
            limb1: 0x537e04ea344beb57ee645026,
            limb2: 0x23c7f99715257261
        },
        r1a1: u288 {
            limb0: 0x8c38b3aeea525f3c2d2fdc22,
            limb1: 0xf838a99d9ec8ed6dcec6a2a8,
            limb2: 0x2973d5159ddc479a
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x3f058d8c63fd905d3ca29b42,
            limb1: 0x1f0a90982cc68e4ddcd83e57,
            limb2: 0x240aeaae0783fbfa
        },
        r0a1: u288 {
            limb0: 0xedfee81d80da310fdf0d0d8,
            limb1: 0xc2208e6de8806cf491bd74d4,
            limb2: 0xb7318be62a476af
        },
        r1a0: u288 {
            limb0: 0x3c6920c8a24454c634f388fe,
            limb1: 0x23328a006312a722ae09548b,
            limb2: 0x1d2f1c58b80432e2
        },
        r1a1: u288 {
            limb0: 0xb72980574f7a877586de3a63,
            limb1: 0xcd773b87ef4a29c16784c5ae,
            limb2: 0x1f812c7e22f339c5
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x21ed735de418113991a8ec7b,
            limb1: 0xf914ffaaba320a954ae6af62,
            limb2: 0x27f2fe60fcbcedb3
        },
        r0a1: u288 {
            limb0: 0xd609c77d636a6a7cdce28846,
            limb1: 0xab3acdce8fb13a1b36162fd8,
            limb2: 0x2c6122ef98df666a
        },
        r1a0: u288 {
            limb0: 0x1e5aa3a8be9c96fad73e0d87,
            limb1: 0x733562fe02b0edf81aee0c42,
            limb2: 0x2332c12f52bbb1fd
        },
        r1a1: u288 {
            limb0: 0xe1061be29297e0cada56dcae,
            limb1: 0x9e1e2de042937f6debeac85d,
            limb2: 0x13c3d6ac7a04f9b2
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xc62501fb90f8ce324cb00b57,
            limb1: 0x3c4433528df38678e867119c,
            limb2: 0x1b0785b7205d9463
        },
        r0a1: u288 {
            limb0: 0x5506e14fd976b5b2937df0c9,
            limb1: 0x2bdf19cb14f1b863de792982,
            limb2: 0x15522135392cd53
        },
        r1a0: u288 {
            limb0: 0x8f4b7321de6168e9eab09609,
            limb1: 0x5d57f18a759524e89e7e26fa,
            limb2: 0x8e80731784e45fb
        },
        r1a1: u288 {
            limb0: 0x5c2704460eb63ce59d1a3663,
            limb1: 0xabdc61c0a7f7710e5fc22d3d,
            limb2: 0x27d5e0e9d837bdec
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xfeebe92941f95b6ea1d095bb,
            limb1: 0x9c7962eb8bbeb95a9ca7cf50,
            limb2: 0x290bdaf3b9a08dc3
        },
        r0a1: u288 {
            limb0: 0x686cfa11c9d4b93675495599,
            limb1: 0xb1d69e17b4b5ebf64f0d51e1,
            limb2: 0x2c18bb4bdc2e9567
        },
        r1a0: u288 {
            limb0: 0x17419b0f6a04bfc98d71527,
            limb1: 0x80eba6ff02787e3de964a4d1,
            limb2: 0x26087bb100e7ff9f
        },
        r1a1: u288 {
            limb0: 0x17c4ee42c3f612c43a08f689,
            limb1: 0x7276bdda2df6d51a291dba69,
            limb2: 0x40a7220ddb393e1
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x555bf641ecbcc6a4e2f88c7a,
            limb1: 0x50d6a8d1b5b85808be8388c3,
            limb2: 0x24996316b0d3d3fd
        },
        r0a1: u288 {
            limb0: 0xc8270dd8045cb61c219724a,
            limb1: 0x362b2d22570c28d20a7e5e06,
            limb2: 0x2c2adafdac42785f
        },
        r1a0: u288 {
            limb0: 0xb55f0bb924cff35fd65b51c6,
            limb1: 0xa64e6aa74f52e983e89fec78,
            limb2: 0x27ebc75dfd46acbb
        },
        r1a1: u288 {
            limb0: 0xe066a30635b82113bdfd666a,
            limb1: 0xa1e5ecf6346ae3f2aa74e10d,
            limb2: 0xd4d9f545ae7227
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x830d777c19040571a1d72fd0,
            limb1: 0x651b2c6b8c292020817a633f,
            limb2: 0x268af1e285bc59ff
        },
        r0a1: u288 {
            limb0: 0xede78baa381c5bce077f443d,
            limb1: 0x540ff96bae21cd8b9ae5438b,
            limb2: 0x12a1fa7e3b369242
        },
        r1a0: u288 {
            limb0: 0x797c0608e5a535d8736d4bc5,
            limb1: 0x375faf00f1147656b7c1075f,
            limb2: 0xda60fab2dc5a639
        },
        r1a1: u288 {
            limb0: 0x610d26085cfbebdb30ce476e,
            limb1: 0x5bc55890ff076827a09e8444,
            limb2: 0x14272ee2d25f20b7
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xc39562a51eb3bd964484892f,
            limb1: 0xd722eb5595b04fb5489e54ba,
            limb2: 0x445afe67aed6bb
        },
        r0a1: u288 {
            limb0: 0x909928d9d567cea72fbe45fc,
            limb1: 0x8802a729d6f56caa33e49981,
            limb2: 0x22c470062cfc0647
        },
        r1a0: u288 {
            limb0: 0x509425b12c854421ebb2a3aa,
            limb1: 0x9a30740f592454ff375dcab4,
            limb2: 0x19d34eb7d54ce404
        },
        r1a1: u288 {
            limb0: 0xf8f635d8095e16865586fd71,
            limb1: 0x405c76b8b1925f6e8776eda7,
            limb2: 0x11ad47712e16df36
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xd6862e1a4ca3b2baf6f8d8aa,
            limb1: 0x96f9066dded3a3d899025af4,
            limb2: 0x1a98af9f0d48fd3
        },
        r0a1: u288 {
            limb0: 0x276b417cc61ea259c114314e,
            limb1: 0x464399e5e0037b159866b246,
            limb2: 0x12cc97dcf32896b5
        },
        r1a0: u288 {
            limb0: 0xef72647f4c2d08fc038c4377,
            limb1: 0x34883cea19be9a490a93cf2b,
            limb2: 0x10d01394daa61ed0
        },
        r1a1: u288 {
            limb0: 0xdf345239ece3acaa62919643,
            limb1: 0x914780908ece64e763cca062,
            limb2: 0xee2a80dbd2012a3
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x1d5a31f4d08a0ebf7e071e00,
            limb1: 0xcd1244dd95dd30005f531f81,
            limb2: 0xb4cb469a2dcf4f1
        },
        r0a1: u288 {
            limb0: 0x7c5938adaf38b355092de1f1,
            limb1: 0x292ab08995b293abfcba14b,
            limb2: 0x1fd126a2b9f37c67
        },
        r1a0: u288 {
            limb0: 0x6e9d352b02a7cb771fcc33f9,
            limb1: 0x7754d8536eefda2025a07340,
            limb2: 0x1840289291c35a72
        },
        r1a1: u288 {
            limb0: 0xe85f465417b7bd758c547b2e,
            limb1: 0xf7f703c3bc55ff8a01fa9365,
            limb2: 0xfa301227880a841
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x4303107cff18c9d46463101e,
            limb1: 0x359a8e0a8ca289f01f55d9fe,
            limb2: 0x26b9c2a0a594179e
        },
        r0a1: u288 {
            limb0: 0xba3bbf69f2d534068e694bb9,
            limb1: 0x4c4e04b543cfbfb295273db4,
            limb2: 0x213e37a6036a3162
        },
        r1a0: u288 {
            limb0: 0x3a74e5b70dda1693f864c9c2,
            limb1: 0x1e23dcf44323706cb20bf7cc,
            limb2: 0x12df5e2ce80c77ba
        },
        r1a1: u288 {
            limb0: 0x7cf25bae05a8dbed2f7327ec,
            limb1: 0xd25d10081862515f162a25c,
            limb2: 0xbe42c4b1c729f66
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xae1f6f307b07551649ec9d59,
            limb1: 0xb32e3ff84184f118199d6ab9,
            limb2: 0xbb8e5db3cac03e0
        },
        r0a1: u288 {
            limb0: 0xc4ee8c588aeb16188a17fa3b,
            limb1: 0xedf2b0092523395fc8b472c9,
            limb2: 0x18a3b3fa98dd5dcb
        },
        r1a0: u288 {
            limb0: 0xc58545ba6047ad77f3dfb4e7,
            limb1: 0xbd6c312fa9dc09d4bbaccc50,
            limb2: 0x272ab4f320619c44
        },
        r1a1: u288 {
            limb0: 0x9cec16cd9a80a8b7199a6c37,
            limb1: 0xf7921039dcd85c228374f694,
            limb2: 0x88bfb87521f3650
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xa4058149e82ea51362b79be4,
            limb1: 0x734eba2621918a820ae44684,
            limb2: 0x110a314a02272b1
        },
        r0a1: u288 {
            limb0: 0xe2b43963ef5055df3c249613,
            limb1: 0x409c246f762c0126a1b3b7b7,
            limb2: 0x19aa27f34ab03585
        },
        r1a0: u288 {
            limb0: 0x179aad5f620193f228031d62,
            limb1: 0x6ba32299b05f31b099a3ef0d,
            limb2: 0x157724be2a0a651f
        },
        r1a1: u288 {
            limb0: 0xa33b28d9a50300e4bbc99137,
            limb1: 0x262a51847049d9b4d8cea297,
            limb2: 0x189acb4571d50692
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x4612e94321843880e085cda7,
            limb1: 0x505eef6d435c16ce6855a6f4,
            limb2: 0x3a658c6d55329c3
        },
        r0a1: u288 {
            limb0: 0xb80a12acfaaedeada32f64ef,
            limb1: 0x8825120a23e028edf0611d7a,
            limb2: 0x20c7ed4a880ac0dd
        },
        r1a0: u288 {
            limb0: 0xd754daa27a3f4a2d8d4923f7,
            limb1: 0x2eef7b94d4e5d6c230bb8780,
            limb2: 0x5d1948dc8104e4c
        },
        r1a1: u288 {
            limb0: 0x25636d4dbbd7f35d6d3d5a73,
            limb1: 0x58d3ad864c8fbc0a222943fb,
            limb2: 0x2663acb47465084f
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x29bd4381ae4afc677ee37ed6,
            limb1: 0x29ed43453f9a008d9176f004,
            limb2: 0x24134eb915104f43
        },
        r0a1: u288 {
            limb0: 0x81597f82bb67e90a3e72bdd2,
            limb1: 0xab3bbde5f7bbb4df6a6b5c19,
            limb2: 0x19ac61eea40a367c
        },
        r1a0: u288 {
            limb0: 0xe30a79342fb3199651aee2fa,
            limb1: 0xf500f028a73ab7b7db0104a3,
            limb2: 0x808b50e0ecb5e4d
        },
        r1a1: u288 {
            limb0: 0x55f2818453c31d942444d9d6,
            limb1: 0xf6dd80c71ab6e893f2cf48db,
            limb2: 0x13c3ac4488abd138
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xf3366cfa2a7a003ae24db2e4,
            limb1: 0xb6b6e0e19a08cd4d7b0bb465,
            limb2: 0x741c1c2a3c4ce9c
        },
        r0a1: u288 {
            limb0: 0x5bf94b02c6987c8ea7625358,
            limb1: 0x4caae27cd5a8261500fffcb,
            limb2: 0x287ff31604277332
        },
        r1a0: u288 {
            limb0: 0x7b29c5234e289255145a25d5,
            limb1: 0xcbe504357d3589f4274c689f,
            limb2: 0x264b74cdbd33e268
        },
        r1a1: u288 {
            limb0: 0x994bf91ab0d60c8acf90681e,
            limb1: 0x33a0d80e0a80b3ad09d986f2,
            limb2: 0x3e5668b54b8b7a7
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xd1464269bbeafa546f559b8f,
            limb1: 0xab7f7dcd1ac32b86979471cf,
            limb2: 0x6a38256ee96f113
        },
        r0a1: u288 {
            limb0: 0xf14d50984e65f9bc41df4e7e,
            limb1: 0x350aff9be6f9652ad441a3ad,
            limb2: 0x1b1e60534b0a6aba
        },
        r1a0: u288 {
            limb0: 0x9e98507da6cc50a56f023849,
            limb1: 0xcf8925e03f2bb5c1ba0962dd,
            limb2: 0x2b18961810a62f87
        },
        r1a1: u288 {
            limb0: 0x3a4c61b937d4573e3f2da299,
            limb1: 0x6f4c6c13fd90f4edc322796f,
            limb2: 0x13f4e99b6a2f025e
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xd3b32b18c13e22448608a0b9,
            limb1: 0xeeb609cbb3ed209a91b776ed,
            limb2: 0x14209ed376b1fdb1
        },
        r0a1: u288 {
            limb0: 0x20e9ab26bb97a4c1b213712e,
            limb1: 0xf65ee21ea68f9c07d17c248,
            limb2: 0x2de92bcfa64e78f5
        },
        r1a0: u288 {
            limb0: 0x404d172cbf68be03701ab28f,
            limb1: 0xc8a9019026ae150737a1e289,
            limb2: 0x1ff4c4a0b464be9a
        },
        r1a1: u288 {
            limb0: 0x45c0a655ea3f1796ab29b933,
            limb1: 0x6e42b30290a78ec97a143d3e,
            limb2: 0x2c2769288c68c8b3
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xe0115a79120ae892a72f3dcb,
            limb1: 0xec67b5fc9ea414a4020135f,
            limb2: 0x1ee364e12321904a
        },
        r0a1: u288 {
            limb0: 0xa74d09666f9429c1f2041cd9,
            limb1: 0x57ffe0951f863dd0c1c2e97a,
            limb2: 0x154877b2d1908995
        },
        r1a0: u288 {
            limb0: 0xcbe5e4d2d2c91cdd4ccca0,
            limb1: 0xe6acea145563a04b2821d120,
            limb2: 0x18213221f2937afb
        },
        r1a1: u288 {
            limb0: 0xfe20afa6f6ddeb2cb768a5ae,
            limb1: 0x1a3b509131945337c3568fcf,
            limb2: 0x127b5788263a927e
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x21c68bf9e232ed71704da1fd,
            limb1: 0xcb73775b7565dd7720bd4b00,
            limb2: 0x14b07bd95b465f99
        },
        r0a1: u288 {
            limb0: 0x31880e630f58fe8177068606,
            limb1: 0xb68832e4a7b57c36e94449e7,
            limb2: 0x22b5eb28ae8d621a
        },
        r1a0: u288 {
            limb0: 0xa606256cf6a06880eeec0253,
            limb1: 0xc28b699c8c499bcab3ae2aa5,
            limb2: 0x3f1f123149a5674
        },
        r1a1: u288 {
            limb0: 0xd9b5af1282e8cf56e97eee4,
            limb1: 0x12abef8eb87a32dc846646c2,
            limb2: 0xf0faef50849790b
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xe7c658aecdab4db3c83f7927,
            limb1: 0xfbf162264ca04ee50c70bde8,
            limb2: 0x2a20f4565b7ff885
        },
        r0a1: u288 {
            limb0: 0x45b1c2f0a1226361f42683c0,
            limb1: 0x9acdd892c48c08de047296bc,
            limb2: 0x27836373108925d4
        },
        r1a0: u288 {
            limb0: 0xc0ea9294b345e6d4892676a7,
            limb1: 0xcba74eca77086af245d1606e,
            limb2: 0xf20edac89053e72
        },
        r1a1: u288 {
            limb0: 0x4c92a28f2779a527a68a938c,
            limb1: 0x3a1c3c55ff9d20eac109fab3,
            limb2: 0x21c4a8c524b1ee7d
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xc6d8b16a81a9b9dfd5c11b79,
            limb1: 0xcda6d1022117d7d98fba53dc,
            limb2: 0xdb7150247bcc35b
        },
        r0a1: u288 {
            limb0: 0x1ddd8d84489ff6e55917da2e,
            limb1: 0xb5b0597fd15688494e306165,
            limb2: 0xfe771109a3ede2d
        },
        r1a0: u288 {
            limb0: 0xbfc33a537cbf530f5270602b,
            limb1: 0xa2f4de9964cfd6146e46fafe,
            limb2: 0x1cb45674ed949113
        },
        r1a1: u288 {
            limb0: 0x48ea935251d8f2cf8ca9d417,
            limb1: 0x9c41b8947331dddaa6f6023d,
            limb2: 0x1ec2d88ca2e1fd1d
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xa68021d593c46246af22559e,
            limb1: 0x5c2cfc5bc4cd1b48f4704134,
            limb2: 0x296066ede1298f8c
        },
        r0a1: u288 {
            limb0: 0xfe17dd6765eb9b9625eb6a84,
            limb1: 0x4e35dd8e8f6088bb14299f8d,
            limb2: 0x1a380ab2689106e4
        },
        r1a0: u288 {
            limb0: 0x82bacf337ca09853df42bc59,
            limb1: 0xa15de4ef34a30014c5a2e9ae,
            limb2: 0x243cc0cec53c778b
        },
        r1a1: u288 {
            limb0: 0xcb2a1bf18e3ba9349b0a8bf2,
            limb1: 0x35134b2505cbb5a4c91f0ac4,
            limb2: 0x25e45206b13f43c4
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x8e97b007ffd9891bd0e77650,
            limb1: 0x77671278ac33f17df6b1db88,
            limb2: 0x243daddc47f5d5c2
        },
        r0a1: u288 {
            limb0: 0x655fe4c8bbe5ee06aaa0054b,
            limb1: 0xf751450b02c93c7ddea95938,
            limb2: 0x21aa988e950d563f
        },
        r1a0: u288 {
            limb0: 0xb51b3b6b8582de3eb0549518,
            limb1: 0x84a1031766b7e465f5bbf40c,
            limb2: 0xd46c2d5b95e5532
        },
        r1a1: u288 {
            limb0: 0x50b6ddd8a5eef0067652191e,
            limb1: 0x298832a0bc46ebed8bff6190,
            limb2: 0xb568b4fe8311f93
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xf8b028fb611a486224297d5d,
            limb1: 0x914d8a4dc9a8985d419bba04,
            limb2: 0xbd047125acefc5a
        },
        r0a1: u288 {
            limb0: 0x43bbc749bc01802242c60f5b,
            limb1: 0x763d7432fee0354a135631a7,
            limb2: 0x17eb787c9478f010
        },
        r1a0: u288 {
            limb0: 0x8499c9551bf5364101430720,
            limb1: 0xf58fa595f9edbc2e165df6fe,
            limb2: 0xd064c4b17aa5143
        },
        r1a1: u288 {
            limb0: 0xff04ae60817a79dcf13f2382,
            limb1: 0x158eae24627d569ba7866924,
            limb2: 0x11ed9e2d27ad5d6d
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x3e4edd338c7d6044c0dcff65,
            limb1: 0x42b22ec00fd6ec26b60c13a0,
            limb2: 0x62f454a7ee11ae4
        },
        r0a1: u288 {
            limb0: 0xfaa8a48c050d50a424cefd5e,
            limb1: 0x76b63ed50d7e1830d5832d72,
            limb2: 0x27e936324aefdec5
        },
        r1a0: u288 {
            limb0: 0x828820fec30661526d42e8ef,
            limb1: 0x6f849cfb9b4b05ca5da691e4,
            limb2: 0x2e8c2614b6bf1f4
        },
        r1a1: u288 {
            limb0: 0x9973591e6421b0bf1cb9ff07,
            limb1: 0x7ba033d912d7c6169eb8c3e9,
            limb2: 0x24613e199f460f7c
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xddb4db99db681d35f71a159c,
            limb1: 0xf71a330019414e6fdee75700,
            limb2: 0x14d9838e7d1918bb
        },
        r0a1: u288 {
            limb0: 0x203c8bac71951a5f2c653710,
            limb1: 0x9fc93f8da38ecc2957313982,
            limb2: 0x7b6d981259cabd9
        },
        r1a0: u288 {
            limb0: 0xa7297cdb5be0cc45d48ca6af,
            limb1: 0xa07b4b025ebe6c960eddfc56,
            limb2: 0xef2a5c30ef00652
        },
        r1a1: u288 {
            limb0: 0xb7f05c76d860e9122b36ecd7,
            limb1: 0x407d6522e1f9ce2bcbf80eda,
            limb2: 0x197625a558f32c36
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x40586b92c0c2db417c9d9db3,
            limb1: 0xa5582dcb03c84177fc471c72,
            limb2: 0x39af766f215897e
        },
        r0a1: u288 {
            limb0: 0xb0f5b2b5f5edcc9461d8a036,
            limb1: 0x605f0ed2ac8db5cb83ea1248,
            limb2: 0x7e91338bc5c7677
        },
        r1a0: u288 {
            limb0: 0xb1c340efb3ca8686191e7e7b,
            limb1: 0xe53f284170ac3de9bc7ded41,
            limb2: 0x1c81b2e97c9370
        },
        r1a1: u288 {
            limb0: 0x29a22b236eb253981769f539,
            limb1: 0x288a2efffabff6bbdeb4362c,
            limb2: 0x300d953d3bdd5623
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb0f04df9dec94801e48a6ff7,
            limb1: 0xdc59d087c627d38334e5b969,
            limb2: 0x3d36e11420be053
        },
        r0a1: u288 {
            limb0: 0xc80f070001aa1586189e0215,
            limb1: 0xff849fcbbbe7c00c83ab5282,
            limb2: 0x2a2354b2882706a6
        },
        r1a0: u288 {
            limb0: 0x48cf70c80f08b6c7dc78adb2,
            limb1: 0xc6632efa77b36a4a1551d003,
            limb2: 0xc2d3533ece75879
        },
        r1a1: u288 {
            limb0: 0x63e82ba26617416a0b76ddaa,
            limb1: 0xdaceb24adda5a049bed29a50,
            limb2: 0x1a82061a3344043b
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x1121a1c80c1ed3f9bce737f8,
            limb1: 0x17253153daa911c7ce5b0487,
            limb2: 0x1edea91b31c81fc5
        },
        r0a1: u288 {
            limb0: 0xa655246ee8b2b44c9fb4e16f,
            limb1: 0xc3a90c83ae1384bed85fa73a,
            limb2: 0x1d0952748eaefe6a
        },
        r1a0: u288 {
            limb0: 0xd1aa17fcc358863eb684d021,
            limb1: 0x920281f398af8c48340c81,
            limb2: 0x2a7b4bdb931a10
        },
        r1a1: u288 {
            limb0: 0x3ade2878d2bf53dc747f37d5,
            limb1: 0x2aefe645d549a359499324c,
            limb2: 0x2f0db89f182d10b
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x9152fecf0f523415acc7c7be,
            limb1: 0xd9632cbfccc4ea5d7bf31177,
            limb2: 0x2d7288c5f8c83ab1
        },
        r0a1: u288 {
            limb0: 0x53144bfe4030f3f9f5efda8,
            limb1: 0xfeec394fbf392b11c66bae27,
            limb2: 0x28840813ab8a200b
        },
        r1a0: u288 {
            limb0: 0xdec3b11fbc28b305d9996ec7,
            limb1: 0x5b5f8d9d17199e149c9def6e,
            limb2: 0x10c1a149b6751bae
        },
        r1a1: u288 {
            limb0: 0x665e8eb7e7d376a2d921c889,
            limb1: 0xfdd76d06e46ee1a943b8788d,
            limb2: 0x8bb21d9960e837b
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x3a67c28a175200e631aa506a,
            limb1: 0x7397303a34968ff17c06e801,
            limb2: 0x1b81e0c63123688b
        },
        r0a1: u288 {
            limb0: 0x3490cfd4f076c621dac4a12c,
            limb1: 0xec183578c91b90b72e5887b7,
            limb2: 0x179fb354f608da00
        },
        r1a0: u288 {
            limb0: 0x9322bde2044dde580a78ba33,
            limb1: 0xfc74821b668d3570cad38f8b,
            limb2: 0x8cec54a291f5e57
        },
        r1a1: u288 {
            limb0: 0xc2818b6a9530ee85d4b2ae49,
            limb1: 0x8d7b651ad167f2a43d7a2d0a,
            limb2: 0x7c9ca9bab0ffc7f
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xc5dd5c8613490c51a50ddc6c,
            limb1: 0xd781c57bcda9d7f2da38ef01,
            limb2: 0x2dfea46808533a99
        },
        r0a1: u288 {
            limb0: 0x36c94137e438c1ea3c9b1881,
            limb1: 0x37f58f69db41461439561ae0,
            limb2: 0x4d27774b9cef6ef
        },
        r1a0: u288 {
            limb0: 0x25770338d6e1fac95e73e8c6,
            limb1: 0x305cc001d10511aad4e639d,
            limb2: 0x1881f83c61dfcdb1
        },
        r1a1: u288 {
            limb0: 0xc73c8ce11aa651206da51cb6,
            limb1: 0x6e0a3c694511a868bb98d9c6,
            limb2: 0x27826f465fb74f4e
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x505fe120b6212ac50bc26670,
            limb1: 0xd73cbc9eca013354ca1e4f06,
            limb2: 0x2515e42d6583d8f1
        },
        r0a1: u288 {
            limb0: 0x5ac0f20e1aae15dbc5e2553c,
            limb1: 0x38f4bb356e3a04f62fd36f3d,
            limb2: 0x1ad1d02cc800b0a9
        },
        r1a0: u288 {
            limb0: 0x1818a19ced3310e41c8d700f,
            limb1: 0xf655e71e9e31ae9b78aa4fd6,
            limb2: 0x2cad082b0e91c47a
        },
        r1a1: u288 {
            limb0: 0x95c4ad066e8b4a68a518e8c,
            limb1: 0x7592b7f7a78fc1a4d0111ecd,
            limb2: 0x20eddc5da9d53075
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xa576408f8300de3a7714e6ae,
            limb1: 0xe1072c9a16f202ecf37fbc34,
            limb2: 0x1b0cb1e2b5871263
        },
        r0a1: u288 {
            limb0: 0x2128e2314694b663286e231e,
            limb1: 0x54bea71957426f002508f715,
            limb2: 0x36ecc5dbe069dca
        },
        r1a0: u288 {
            limb0: 0x17c77cd88f9d5870957850ce,
            limb1: 0xb7f4ec2bc270ce30538fe9b8,
            limb2: 0x766279e588592bf
        },
        r1a1: u288 {
            limb0: 0x1b6caddf18de2f30fa650122,
            limb1: 0x40b77237a29cada253c126c6,
            limb2: 0x74ff1349b1866c8
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb8991bf73bee55ceed1cf88e,
            limb1: 0x71cd750c9f8e878170c61eaf,
            limb2: 0x15d6b6b9cb16a398
        },
        r0a1: u288 {
            limb0: 0xc5176103c2ea8e92c442a4bf,
            limb1: 0x75505076e2fe79540af579bd,
            limb2: 0x1170823cf4eec31c
        },
        r1a0: u288 {
            limb0: 0x5fe093f12703fcf58a5c29fa,
            limb1: 0x53920069c1eef809784df4f4,
            limb2: 0x11c8d29a7a47eab2
        },
        r1a1: u288 {
            limb0: 0x43ea0cf366e73c5e0db0579c,
            limb1: 0xef0c4537383ab32de95fff42,
            limb2: 0x113e5c84f617aa56
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x3603266e05560becab36faef,
            limb1: 0x8c3b88c9390278873dd4b048,
            limb2: 0x24a715a5d9880f38
        },
        r0a1: u288 {
            limb0: 0xe9f595b111cfd00d1dd28891,
            limb1: 0x75c6a392ab4a627f642303e1,
            limb2: 0x17b34a30def82ab6
        },
        r1a0: u288 {
            limb0: 0xe706de8f35ac8372669fc8d3,
            limb1: 0x16cc7f4032b3f3ebcecd997d,
            limb2: 0x166eba592eb1fc78
        },
        r1a1: u288 {
            limb0: 0x7d584f102b8e64dcbbd1be9,
            limb1: 0x2ead4092f009a9c0577f7d3,
            limb2: 0x2fe2c31ee6b1d41e
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x72253d939632f8c28fb5763,
            limb1: 0x9b943ab13cad451aed1b08a2,
            limb2: 0xdb9b2068e450f10
        },
        r0a1: u288 {
            limb0: 0x80f025dcbce32f6449fa7719,
            limb1: 0x8a0791d4d1ed60b86e4fe813,
            limb2: 0x1b1bd5dbce0ea966
        },
        r1a0: u288 {
            limb0: 0xaa72a31de7d815ae717165d4,
            limb1: 0x501c29c7b6aebc4a1b44407f,
            limb2: 0x464aa89f8631b3a
        },
        r1a1: u288 {
            limb0: 0x6b8d137e1ea43cd4b1f616b1,
            limb1: 0xdd526a510cc84f150cc4d55a,
            limb2: 0x1da2ed980ebd3f29
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x8b46e3e2b70847df35c5b618,
            limb1: 0x24fdec69097eb3594d075f2f,
            limb2: 0x1981797f29d6240a
        },
        r0a1: u288 {
            limb0: 0x7991f7a73cb8b5082c29a178,
            limb1: 0x7f9db8a444911b45edba81ae,
            limb2: 0x1234aa5fc652f6fe
        },
        r1a0: u288 {
            limb0: 0x385c6e2d5961104b5891122e,
            limb1: 0xf96b5d81a71b748f153147ca,
            limb2: 0x2e5f49b90321dd0a
        },
        r1a1: u288 {
            limb0: 0x2b78c9f106907790c9d7dabf,
            limb1: 0x875bcbde805e282af6f01100,
            limb2: 0x282fd96c2b1854e2
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xc4a251af423434a4d42bb5fb,
            limb1: 0x615a840a6bd64b7f39b554da,
            limb2: 0x26bd3213dfeb2109
        },
        r0a1: u288 {
            limb0: 0x66780fa659edec8278aa2e16,
            limb1: 0xf8a2543f3e743805e5b37a40,
            limb2: 0x1eb3e6144893e464
        },
        r1a0: u288 {
            limb0: 0xcc7be4de537eb7094776c0a1,
            limb1: 0x571f33de746a37beffc1df86,
            limb2: 0x7655f6ae64908b0
        },
        r1a1: u288 {
            limb0: 0x34a68c71c0dcc490e9266162,
            limb1: 0x64ee700b0f584bbfecc08d99,
            limb2: 0xa1bbe13c9a50fa2
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x867cced8a010850958f41ff5,
            limb1: 0x6a37fdb2b8993eed18bafe8e,
            limb2: 0x21b9f782109e5a7
        },
        r0a1: u288 {
            limb0: 0x7307477d650618e66de38d0f,
            limb1: 0xacb622ce92a7e393dbe10ba1,
            limb2: 0x236e70838cee0ed5
        },
        r1a0: u288 {
            limb0: 0xb564a308aaf5dda0f4af0f0d,
            limb1: 0x55fc71e2f13d8cb12bd51e74,
            limb2: 0x294cf115a234a9e9
        },
        r1a1: u288 {
            limb0: 0xbd166057df55c135b87f35f3,
            limb1: 0xf9f29b6c50f1cce9b85ec9b,
            limb2: 0x2e8448d167f20f96
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x311331e507c29e8dfc32e455,
            limb1: 0xd2630b7706a6876a55874ce5,
            limb2: 0x250b6aae008ba8b0
        },
        r0a1: u288 {
            limb0: 0xc39654879b4a287a1ec86a3e,
            limb1: 0xcf37bd4a1e7f7b88840fdba7,
            limb2: 0x2152aee022263aca
        },
        r1a0: u288 {
            limb0: 0x93e416b36576a6ae58d67b26,
            limb1: 0xc279a85a2a6f2d91deb1f0dc,
            limb2: 0x187151b5d5fdd3aa
        },
        r1a1: u288 {
            limb0: 0x945652c21cb67ad51a3e64e1,
            limb1: 0x6b015d27cd462a9cdf4ac04f,
            limb2: 0xfed1779b55deb0c
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xdedaff3205bb953b2c390b8a,
            limb1: 0xe1a899da21c1dafb485c707e,
            limb2: 0x1ec897e7a041493e
        },
        r0a1: u288 {
            limb0: 0xf52c3c30cd4d3202b34089e0,
            limb1: 0xc652aa1ff533e1aad7532305,
            limb2: 0x2a1df766e5e3aa2e
        },
        r1a0: u288 {
            limb0: 0x7ac695d3e19d79b234daaf3d,
            limb1: 0x5ce2f92666aec92a650feee1,
            limb2: 0x21ab4fe20d978e77
        },
        r1a1: u288 {
            limb0: 0xa64a913a29a1aed4e0798664,
            limb1: 0x66bc208b511503d127ff5ede,
            limb2: 0x2389ba056de56a8d
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x805f0ecf43fb375cf4961415,
            limb1: 0x214b015446d550c9406a235b,
            limb2: 0xfc0da325d088105
        },
        r0a1: u288 {
            limb0: 0xd651edbe15caea56dfc32b95,
            limb1: 0xe2c8e30429145ad4e1edd4df,
            limb2: 0xa3e6d7ee744091b
        },
        r1a0: u288 {
            limb0: 0x3638291e183471055141668c,
            limb1: 0x27dbbe2359ce3b0b3fb60458,
            limb2: 0x15338a057891ea53
        },
        r1a1: u288 {
            limb0: 0xf89dbfa589d27758b8bf94e,
            limb1: 0x4b9a9f14310fd6118471d9bd,
            limb2: 0x29ee37e3158ac38b
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xd88b16e68600a12e6c1f6006,
            limb1: 0x333243b43d3b7ff18d0cc671,
            limb2: 0x2b84b2a9b0f03ed8
        },
        r0a1: u288 {
            limb0: 0xf3e2b57ddaac822c4da09991,
            limb1: 0xd7c894b3fe515296bb054d2f,
            limb2: 0x10a75e4c6dddb441
        },
        r1a0: u288 {
            limb0: 0x73c65fbbb06a7b21b865ac56,
            limb1: 0x21f4ecd1403bb78729c7e99b,
            limb2: 0xaf88a160a6b35d4
        },
        r1a1: u288 {
            limb0: 0xade61ce10b8492d659ff68d0,
            limb1: 0x1476e76cf3a8e0df086ad9eb,
            limb2: 0x2e28cfc65d61e946
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xdf8b54b244108008e7f93350,
            limb1: 0x2ae9a68b9d6b96f392decd6b,
            limb2: 0x160b19eed152271c
        },
        r0a1: u288 {
            limb0: 0xc18a8994cfbb2e8df446e449,
            limb1: 0x408d51e7e4adedd8f4f94d06,
            limb2: 0x27661b404fe90162
        },
        r1a0: u288 {
            limb0: 0x1390b2a3b27f43f7ac73832c,
            limb1: 0x14d57301f6002fd328f2d64d,
            limb2: 0x17f3fa337367dddc
        },
        r1a1: u288 {
            limb0: 0x79cab8ff5bf2f762c5372f80,
            limb1: 0xc979d6f385fae4b5e4785acf,
            limb2: 0x60c5307a735b00f
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xf3707144582128ddba7af579,
            limb1: 0x30432a359f16b0c45d6bd8fc,
            limb2: 0x18a32a8f220ee67b
        },
        r0a1: u288 {
            limb0: 0x668b0cac5b39367b0ba55724,
            limb1: 0x4857e4919a99f8c34b610174,
            limb2: 0x14711590e4958a63
        },
        r1a0: u288 {
            limb0: 0x47a74f074ae66e7f61ccd4c3,
            limb1: 0xabed84c062664fec3cd2f3fd,
            limb2: 0x17a5d112ba2bd401
        },
        r1a1: u288 {
            limb0: 0xd1290b5509e62ca1a116f10,
            limb1: 0xe4b9eb1df92fe5313709f26,
            limb2: 0x20dc2dd42a3b757
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x9061359dca9cda43ccfa13f3,
            limb1: 0xf9910e083c29dd652d8e4a41,
            limb2: 0x2fc36b25eb520ec0
        },
        r0a1: u288 {
            limb0: 0xe0e94b7eb578b74286290687,
            limb1: 0x2974a0e50a880dcb7d2faf3b,
            limb2: 0xef49b11041c375f
        },
        r1a0: u288 {
            limb0: 0x883ec12f88a5d0216a2bc4e,
            limb1: 0xc631a9459497ae66c19692e9,
            limb2: 0x15d25aeef0fda74d
        },
        r1a1: u288 {
            limb0: 0x31311b492c5a71f5218db274,
            limb1: 0xaff342f9eaa8600ff0217dd0,
            limb2: 0x2eb775bd89cb48f6
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x386d7b23c6dccb87637018c9,
            limb1: 0xfed2ea478e9a2210289079e2,
            limb2: 0x100aa83cb843353e
        },
        r0a1: u288 {
            limb0: 0x229c5c285f049d04c3dc5ce7,
            limb1: 0x28110670fe1d38c53ffcc6f7,
            limb2: 0x1778918279578f50
        },
        r1a0: u288 {
            limb0: 0xe9ad2c7b8a17a1f1627ff09d,
            limb1: 0xedff5563c3c3e7d2dcc402ec,
            limb2: 0xa8bd6770b6d5aa8
        },
        r1a1: u288 {
            limb0: 0x66c5c1aeed5c04470b4e8a3d,
            limb1: 0x846e73d11f2d18fe7e1e1aa2,
            limb2: 0x10a60eabe0ec3d78
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xbc73fc450c5287d436bb6acf,
            limb1: 0x89e240b3ea4f4f807c4b7d78,
            limb2: 0x5c8dca6d4735481
        },
        r0a1: u288 {
            limb0: 0x2b6acc77839653375faaddfa,
            limb1: 0xbe831b6c58f089a8dddd3159,
            limb2: 0x1517e1adcf5e12da
        },
        r1a0: u288 {
            limb0: 0x6fa01a7449831dd58ff76ee,
            limb1: 0x962303aacec45780e9ac8342,
            limb2: 0x280938b2d687aaf
        },
        r1a1: u288 {
            limb0: 0x11c65719c2cef5cc2c31a773,
            limb1: 0x663453810d54f22dc01c2533,
            limb2: 0x1c67952d407732ef
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x88ca191d85be1f6c205257ef,
            limb1: 0xd0cecf5c5f80926c77fd4870,
            limb2: 0x16ec42b5cae83200
        },
        r0a1: u288 {
            limb0: 0x154cba82460752b94916186d,
            limb1: 0x564f6bebac05a4f3fb1353ac,
            limb2: 0x2d47a47da836d1a7
        },
        r1a0: u288 {
            limb0: 0xb39c4d6150bd64b4674f42ba,
            limb1: 0x93c967a38fe86f0779bf4163,
            limb2: 0x1a51995a49d50f26
        },
        r1a1: u288 {
            limb0: 0xeb7bdec4b7e304bbb0450608,
            limb1: 0x11fc9a124b8c74b3d5560ea4,
            limb2: 0xbfa9bd7f55ad8ac
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x95266841d85589dc8fb481b,
            limb1: 0xd21fb02e276c2ba8a94d6448,
            limb2: 0x149648d7da0fa723
        },
        r0a1: u288 {
            limb0: 0x815020a8316a4b0f99e5ad4c,
            limb1: 0x5d34e6a0fc1bb89de7bfc5b7,
            limb2: 0x205527838e51390c
        },
        r1a0: u288 {
            limb0: 0xca80050e063b29176939b23e,
            limb1: 0xa9ee8c46672970c34f71c9ca,
            limb2: 0x1433cd30b97b0e10
        },
        r1a1: u288 {
            limb0: 0x304bc512b196a17da46bf6b9,
            limb1: 0x474b148956a8445406a6b715,
            limb2: 0xfeded05187e0674
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x2fdc574c85cf0c0ce5e07a51,
            limb1: 0xd2439bf7b00bddc4cfb01b0c,
            limb2: 0x125c3bbdeb0bd2da
        },
        r0a1: u288 {
            limb0: 0x9d664714bae53cafcb5ef55d,
            limb1: 0x495c01724790853548f5e4de,
            limb2: 0x2ce5e2e263725941
        },
        r1a0: u288 {
            limb0: 0x98071eb7fe88c9124aee3774,
            limb1: 0xc3f66947a52bd2f6d520579f,
            limb2: 0x2eaf775dbd52f7d3
        },
        r1a1: u288 {
            limb0: 0x23e5594948e21db2061dca92,
            limb1: 0xd0ffa6f6c77290531c185431,
            limb2: 0x604c085de03afb1
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xf7b33f6a4ca02ad702bb4fa,
            limb1: 0x28d1a52a2483ba7876a289ba,
            limb2: 0x15561e9de6366c91
        },
        r0a1: u288 {
            limb0: 0xb0857235a1714e6f6318b9a8,
            limb1: 0x867802f6e5c0a0d200d9b87a,
            limb2: 0x49ef94e7005edde
        },
        r1a0: u288 {
            limb0: 0x1ad3c5205f0b17bdd43407a0,
            limb1: 0x2c984812e4be3f269e8d94f8,
            limb2: 0x7f64c3da2f79ec
        },
        r1a1: u288 {
            limb0: 0xb2ee5861f5005a43940b0602,
            limb1: 0x75f7b7931557a6426cdbca66,
            limb2: 0xb95de70968d4bac
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xeec2912e15f6bda39d4e005e,
            limb1: 0x2b8610c44d27bdbc6ba2aac5,
            limb2: 0x78ddc4573fc1fed
        },
        r0a1: u288 {
            limb0: 0x48099a0da11ea21de015229d,
            limb1: 0x5fe937100967d5cc544f4af1,
            limb2: 0x2c9ffe6d7d7e9631
        },
        r1a0: u288 {
            limb0: 0xa70d251296ef1ae37ceb7d03,
            limb1: 0x2adadcb7d219bb1580e6e9c,
            limb2: 0x180481a57f22fd03
        },
        r1a1: u288 {
            limb0: 0xacf46db9631037dd933eb72a,
            limb1: 0x8a58491815c7656292a77d29,
            limb2: 0x261e3516c348ae12
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x2ab4e1c90bdbc3f4d184f195,
            limb1: 0x341a0baf0845fc78b9bee23f,
            limb2: 0x21718b38e868ede6
        },
        r0a1: u288 {
            limb0: 0xf686446c336a4da3c6eec85e,
            limb1: 0xe38d40b98f6fbda0af83289f,
            limb2: 0x232d95bb4eb8faa2
        },
        r1a0: u288 {
            limb0: 0x72b5a0a7e10e67e9d2e9b64d,
            limb1: 0x9427d596f8c7f13b816989c2,
            limb2: 0x2a9b7254c23c1bee
        },
        r1a1: u288 {
            limb0: 0x8e0410ea9af35e7e0294b6f0,
            limb1: 0x7f00cc4496d4f6520c8502d8,
            limb2: 0xe6d3d25ce3b67ab
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x2bfa32f0a09c3e2cfb8f6a38,
            limb1: 0x7a24df3ff3c7119a59d49318,
            limb2: 0x10e42281d64907ba
        },
        r0a1: u288 {
            limb0: 0xce42177a66cdeb4207d11e0c,
            limb1: 0x3322aa425a9ca270152372ad,
            limb2: 0x2f7fa83db407600c
        },
        r1a0: u288 {
            limb0: 0x62a8ff94fd1c7b9035af4446,
            limb1: 0x3ad500601bbb6e7ed1301377,
            limb2: 0x254d253ca06928f
        },
        r1a1: u288 {
            limb0: 0xf8f1787cd8e730c904b4386d,
            limb1: 0x7fd3744349918d62c42d24cc,
            limb2: 0x28a05e105d652eb8
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x6ef31e059d602897fa8e80a8,
            limb1: 0x66a0710847b6609ceda5140,
            limb2: 0x228c0e568f1eb9c0
        },
        r0a1: u288 {
            limb0: 0x7b47b1b133c1297b45cdd79b,
            limb1: 0x6b4f04ed71b58dafd06b527b,
            limb2: 0x13ae6db5254df01a
        },
        r1a0: u288 {
            limb0: 0xbeca2fccf7d0754dcf23ddda,
            limb1: 0xe3d0bcd7d9496d1e5afb0a59,
            limb2: 0x305a0afb142cf442
        },
        r1a1: u288 {
            limb0: 0x2d299847431477c899560ecf,
            limb1: 0xbcd9e6c30bedee116b043d8d,
            limb2: 0x79473a2a7438353
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x8f2f98aa49d3a82c06b5f06a,
            limb1: 0x7552c4b82c1f9c6f726567e4,
            limb2: 0x46ea61259d07df2
        },
        r0a1: u288 {
            limb0: 0xc4ce7cf0857a7f7f1f6b293a,
            limb1: 0x5447d8ff0696a1835b679491,
            limb2: 0x263886ddc71f474b
        },
        r1a0: u288 {
            limb0: 0x7517554481b2eadb83f82bc8,
            limb1: 0x414c32124b6c2b73826d90d8,
            limb2: 0xa04590876a0be19
        },
        r1a1: u288 {
            limb0: 0x935427e3a9d60836da10a409,
            limb1: 0x758f4ffd0616e0ccd4f081d9,
            limb2: 0x1082d469d3912b0
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x504c4e2647344dc4c91d7c87,
            limb1: 0xc6eb49157317a7cf602c0693,
            limb2: 0x649223cda84ba2a
        },
        r0a1: u288 {
            limb0: 0xb73cfd0d7ac305ed35027cf0,
            limb1: 0x18f1c4e3586c6e79b3d6a3ed,
            limb2: 0x27b07e97b7b802e5
        },
        r1a0: u288 {
            limb0: 0xe41e440b719f2f3c663bcd52,
            limb1: 0x850e57746df9ab3155d5a49c,
            limb2: 0x1f200a2126852faa
        },
        r1a1: u288 {
            limb0: 0x9baf67b309e5bdb1c23d3cce,
            limb1: 0xe10d04ac0a9e1d41442033f1,
            limb2: 0x302490deb5470799
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x65b71fe695e7ccd4b460dace,
            limb1: 0xa6ceba62ef334e6fe91301d5,
            limb2: 0x299f578d0f3554e6
        },
        r0a1: u288 {
            limb0: 0xaf781dd030a274e7ecf0cfa4,
            limb1: 0x2095020d373a14d7967797aa,
            limb2: 0x6a7f9df6f185bf8
        },
        r1a0: u288 {
            limb0: 0x8e91e2dba67d130a0b274df3,
            limb1: 0xe192a19fce285c12c6770089,
            limb2: 0x6e9acf4205c2e22
        },
        r1a1: u288 {
            limb0: 0xbcd5c206b5f9c77d667189bf,
            limb1: 0x656a7e2ebc78255d5242ca9,
            limb2: 0x25f43fec41d2b245
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x30d76ecaae1f147df5170478,
            limb1: 0x5aa2f487baec87a40f498aa,
            limb2: 0x17614a6f686d9b07
        },
        r0a1: u288 {
            limb0: 0xbb10058505050fbf37767848,
            limb1: 0x3cd7104561ce9c65e45618a9,
            limb2: 0x2d97c4a72b794b
        },
        r1a0: u288 {
            limb0: 0xf1821e829209347cb9c13292,
            limb1: 0x31d45b7a02c7e98493ab5ab9,
            limb2: 0x53a7568e17cda23
        },
        r1a1: u288 {
            limb0: 0x868026120d6cd5fc8f3f0e4f,
            limb1: 0x104986f8c34f6782cee8ca32,
            limb2: 0x9c6f82270e87ce9
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x4e56e6733cce20d9c5b16d96,
            limb1: 0xc7ef260535fb75b9d3e089f,
            limb2: 0x292dd4aa636e7729
        },
        r0a1: u288 {
            limb0: 0x6e7e1038b336f36519c9faaf,
            limb1: 0x3c66bd609510309485e225c7,
            limb2: 0x10cacac137411eb
        },
        r1a0: u288 {
            limb0: 0x4a3e8b96278ac092fe4f3b15,
            limb1: 0xba47e583e2750b42f93c9631,
            limb2: 0x125da6bd69495bb9
        },
        r1a1: u288 {
            limb0: 0xae7a56ab4b959a5f6060d529,
            limb1: 0xc3c263bfd58c0030c063a48e,
            limb2: 0x2f4d15f13fae788c
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x301e0885c84d273b6d323124,
            limb1: 0x11fd5c75e269f7a30fa4154f,
            limb2: 0x19afdcfdcce2fc0d
        },
        r0a1: u288 {
            limb0: 0x3d13519f934526be815c38b0,
            limb1: 0xd43735909547da73838874fc,
            limb2: 0x255d8aca30f4e0f6
        },
        r1a0: u288 {
            limb0: 0x90a505b76f25a3396e2cea79,
            limb1: 0x3957a2d0848c54b9079fc114,
            limb2: 0x1ba0cd3a9fe6d4bb
        },
        r1a1: u288 {
            limb0: 0xc47930fba77a46ebb1db30a9,
            limb1: 0x993a1cb166e9d40bebab02b2,
            limb2: 0x1deb16166d48118b
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x3d4a4c15cbd3cdf38f3393c3,
            limb1: 0x7fd0a59ad4033bc6df8dc124,
            limb2: 0x17a672f7fa2b3362
        },
        r0a1: u288 {
            limb0: 0xebfe2ae500215bc91752d707,
            limb1: 0xe5f4a2a2ecd76b39480ebcfe,
            limb2: 0x2a30595a6587a947
        },
        r1a0: u288 {
            limb0: 0xdad67c20323bd1781b4ebc1c,
            limb1: 0x434e06115a86066d796b05a1,
            limb2: 0x1fe4e4526c10e63c
        },
        r1a1: u288 {
            limb0: 0x82b8e1a60ed838fb91012b88,
            limb1: 0x4f8ece50d3cd38bd569bc0fb,
            limb2: 0x3055beab94fbd43
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x1b95315f2ab404202e7ae3ad,
            limb1: 0x2be977cd53e89ead6b3429db,
            limb2: 0x2a43376d5d6d5276
        },
        r0a1: u288 {
            limb0: 0x4ed3c054021a0a1dc3ef973a,
            limb1: 0x15293a9e8fa8f72dca6b0959,
            limb2: 0x14ca007f84084012
        },
        r1a0: u288 {
            limb0: 0x6c05ecaf575f0d12af31bed1,
            limb1: 0xa8c758ea07de00a8d8c0520d,
            limb2: 0x172a03bdc0939b9a
        },
        r1a1: u288 {
            limb0: 0x25776f1efde04ce66e0ab8c6,
            limb1: 0x577135f37bec324ceecb91ac,
            limb2: 0x1645e9e388148994
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb15bbaec50ff49d30e49f74a,
            limb1: 0xc90a8c79fb045c5468f14151,
            limb2: 0x25e47927e92df0e3
        },
        r0a1: u288 {
            limb0: 0x57f66909d5d40dfb8c7b4d5c,
            limb1: 0xea5265282e2139c48c1953f2,
            limb2: 0x2d7f5e6aff2381f6
        },
        r1a0: u288 {
            limb0: 0x2a2f573b189a3c8832231394,
            limb1: 0x738abc15844895ffd4733587,
            limb2: 0x20aa11739c4b9bb4
        },
        r1a1: u288 {
            limb0: 0x51695ec614f1ff4cce2f65d1,
            limb1: 0x6765aae6cb895a2406a6dd7e,
            limb2: 0x1126ee431c522da0
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x7c27593c4b03f1c378f42c9,
            limb1: 0x5ec86418bd2e116399a88ebd,
            limb2: 0x1d10e068259c02ad
        },
        r0a1: u288 {
            limb0: 0x2b387701a8a978a35f5f6d5,
            limb1: 0x4edf48149123c499918f9067,
            limb2: 0x23d84b855433ceac
        },
        r1a0: u288 {
            limb0: 0x296f404ae74e974e9ee3e26d,
            limb1: 0x978463ee0c9f3828fc94acac,
            limb2: 0x2e0ccf8427d73b4d
        },
        r1a1: u288 {
            limb0: 0x3cff510f0791623d8a7403b7,
            limb1: 0x830f2729c93e9d85231b0ab9,
            limb2: 0x18e1327025740989
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x9214fc3209f1518b05fd21c6,
            limb1: 0x9bc8ce4f56423009710770e8,
            limb2: 0x32445cc6972799c
        },
        r0a1: u288 {
            limb0: 0x93ef401ecd9cfae3644d22e6,
            limb1: 0xce5a741a9847a144cfaf8c96,
            limb2: 0xf7a814d5726da4a
        },
        r1a0: u288 {
            limb0: 0xd19264d986f163b133a91c0c,
            limb1: 0x529dc5ce4b193c0f672c6a32,
            limb2: 0x2e9a118959353374
        },
        r1a1: u288 {
            limb0: 0x3d97d6e8f45072cc9e85e412,
            limb1: 0x4dafecb04c3bb23c374f0486,
            limb2: 0xa174dd4ac8ee628
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x410ff02014cf0c500be4c790,
            limb1: 0x1e8d3a6b643d75c693695c5b,
            limb2: 0x25081ba754068a47
        },
        r0a1: u288 {
            limb0: 0xd5946e1768b76555197653cd,
            limb1: 0xbaf0637b753c91ee8417f80f,
            limb2: 0xee2eef13425e87e
        },
        r1a0: u288 {
            limb0: 0x7ade83454a99afe7c4caf88d,
            limb1: 0xea2dccc9310908fd89e667ad,
            limb2: 0x29774454f651a934
        },
        r1a1: u288 {
            limb0: 0xd2369f9458531e652205080b,
            limb1: 0x771b2284c880fe85019aa83,
            limb2: 0x2e0547c67fd86297
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x98d8b0c4adcf27bceb305c2c,
            limb1: 0x859afa9c7668ed6152d8cba3,
            limb2: 0x29e7694f46e3a272
        },
        r0a1: u288 {
            limb0: 0x1d970845365594307ba97556,
            limb1: 0xd002d93ad793e154afe5b49b,
            limb2: 0x12ca77d3fb8eee63
        },
        r1a0: u288 {
            limb0: 0x9f2934faefb8268e20d0e337,
            limb1: 0xbc4b5e1ec056881319f08766,
            limb2: 0x2e103461759a9ee4
        },
        r1a1: u288 {
            limb0: 0x7adc6cb87d6b43000e2466b6,
            limb1: 0x65e5cefa42b25a7ee8925fa6,
            limb2: 0x2560115898d7362a
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x5305b17c572c769c02dc8df0,
            limb1: 0x50cc269690333da334148fbd,
            limb2: 0x2153bbe5a2e5215e
        },
        r0a1: u288 {
            limb0: 0x3355756398ba6057c90c91f4,
            limb1: 0xd8e2748839b46fb7bf39b35,
            limb2: 0x27a594a61cda730e
        },
        r1a0: u288 {
            limb0: 0x2dfa0e2be7417d60f1428632,
            limb1: 0x85431dcbd44275a606673bb2,
            limb2: 0x573213f5e050ab2
        },
        r1a1: u288 {
            limb0: 0x955cb93b2853f37b11cda57f,
            limb1: 0xf5c7b84428b8a45da88d0121,
            limb2: 0x24e2f7d2023cdd9a
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x64d864643668392c0e357cc4,
            limb1: 0x4c9bf66853f1b287015ab84c,
            limb2: 0x2f5f1b92ad7ee4d4
        },
        r0a1: u288 {
            limb0: 0xdc33c8da5c575eef6987a0e1,
            limb1: 0x51cc07c7ef28e1b8d934bc32,
            limb2: 0x2358d94a17ec2a44
        },
        r1a0: u288 {
            limb0: 0xf659845b829bbba363a2497b,
            limb1: 0x440f348e4e7bed1fb1eb47b2,
            limb2: 0x1ad0eaab0fb0bdab
        },
        r1a1: u288 {
            limb0: 0x1944bb6901a1af6ea9afa6fc,
            limb1: 0x132319df135dedddf5baae67,
            limb2: 0x52598294643a4aa
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x76fd94c5e6f17fa6741bd7de,
            limb1: 0xc2e0831024f67d21013e0bdd,
            limb2: 0x21e2af6a43119665
        },
        r0a1: u288 {
            limb0: 0xad290eab38c64c0d8b13879b,
            limb1: 0xdd67f881be32b09d9a6c76a0,
            limb2: 0x8000712ce0392f2
        },
        r1a0: u288 {
            limb0: 0xd30a46f4ba2dee3c7ace0a37,
            limb1: 0x3914314f4ec56ff61e2c29e,
            limb2: 0x22ae1ba6cd84d822
        },
        r1a1: u288 {
            limb0: 0x5d888a78f6dfce9e7544f142,
            limb1: 0x9439156de974d3fb6d6bda6e,
            limb2: 0x106c8f9a27d41a4f
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x2739deb44cc6e38ba713fb46,
            limb1: 0x5ca5a3a606bb90f461101eb4,
            limb2: 0x13450221ef6d26cc
        },
        r0a1: u288 {
            limb0: 0xbd8f86b9fb5a4fb0a479cda1,
            limb1: 0x1f652c09877baf800fad74a9,
            limb2: 0x70dd332b34ee188
        },
        r1a0: u288 {
            limb0: 0x64a0839f4ce439ae4dc62274,
            limb1: 0x71727719b01324d612e23acd,
            limb2: 0x17eb42296c28ae0b
        },
        r1a1: u288 {
            limb0: 0x1850881c5e9b8ea228f481b4,
            limb1: 0x6e16c017e2c235d3e855e2d6,
            limb2: 0x16830222bab88b2d
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb34e3753e94e5216b26e41c2,
            limb1: 0x80a5ef3cdf706c91d1beeffe,
            limb2: 0x1ddf6ca60bd4e5e7
        },
        r0a1: u288 {
            limb0: 0xe3a76d22f7117291d77860f0,
            limb1: 0x6ee2367a8ff55c81a9d13f8e,
            limb2: 0x150acee60e463876
        },
        r1a0: u288 {
            limb0: 0x2f3c7ab55a10609e87411cc7,
            limb1: 0x90ec6472134240b3942aed29,
            limb2: 0x1baa87f2a78f04e
        },
        r1a1: u288 {
            limb0: 0x4b7f523546b19b684045eb42,
            limb1: 0x3eca881799e431b08ff4488b,
            limb2: 0x247b39bc424e608f
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x92c09e4796207b802168341b,
            limb1: 0xd2d9d6acffd7829066cc49ce,
            limb2: 0xc89c2d0a7b2c81e
        },
        r0a1: u288 {
            limb0: 0x47e3c1cf6cdb6f3efe778c7f,
            limb1: 0x66b347099b6436794cf062eb,
            limb2: 0x18b4ccc64ae0a857
        },
        r1a0: u288 {
            limb0: 0x7d5793606a73b2740c71484a,
            limb1: 0xa0070135ca2dc571b28e3c9c,
            limb2: 0x1bc03576e04b94cf
        },
        r1a1: u288 {
            limb0: 0x1ba85b29875e638c10f16c99,
            limb1: 0x158f2f2acc3c2300bb9f9225,
            limb2: 0x42d8a8c36ea97c6
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x9ea072c313823ff0d4186fb2,
            limb1: 0x9dcda77d40805d38ac623c7a,
            limb2: 0x8b874d3219138da
        },
        r0a1: u288 {
            limb0: 0x3e425ff6459ed99fc42cb09d,
            limb1: 0x47c51614bcca6806414e2723,
            limb2: 0x27ab3bbd4f0fd10d
        },
        r1a0: u288 {
            limb0: 0x50b934873cb6ddd7baf73088,
            limb1: 0x8237023800632c6b10e32eb6,
            limb2: 0x928abc4331aac0b
        },
        r1a1: u288 {
            limb0: 0xddf0d00effbc4155e6f345a2,
            limb1: 0x489d4f030f6da2215f88314c,
            limb2: 0x1b1785e97a4bb0ab
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x9440ad13408319cecb07087b,
            limb1: 0x537afc0c0cfe8ff761c24e08,
            limb2: 0x48e4ac10081048d
        },
        r0a1: u288 {
            limb0: 0xa37fb82b03a2c0bb2aa50c4f,
            limb1: 0xd3797f05c8fb84f6b630dfb,
            limb2: 0x2dffde2d6c7e43ff
        },
        r1a0: u288 {
            limb0: 0xc55d2eb1ea953275e780e65b,
            limb1: 0xe141cf680cab57483c02e4c7,
            limb2: 0x1b71395ce5ce20ae
        },
        r1a1: u288 {
            limb0: 0xe4fab521f1212a1d301065de,
            limb1: 0x4f8d31c78df3dbe4ab721ef2,
            limb2: 0x2828f21554706a0e
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x8cefc2f2af2a3082b790784e,
            limb1: 0x97ac13b37c6fbfc736a3d456,
            limb2: 0x683b1cdffd60acd
        },
        r0a1: u288 {
            limb0: 0xa266a8188a8c933dcffe2d02,
            limb1: 0x18d3934c1838d7bce81b2eeb,
            limb2: 0x206ac5cdda42377
        },
        r1a0: u288 {
            limb0: 0x90332652437f6e177dc3b28c,
            limb1: 0x75bd8199433d607735414ee8,
            limb2: 0x29d6842d8298cf7e
        },
        r1a1: u288 {
            limb0: 0xadedf46d8ea11932db0018e1,
            limb1: 0xbc7239ae9d1453258037befb,
            limb2: 0x22e7ebdd72c6f7a1
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xd7acee141988338855262111,
            limb1: 0x920e12eb8f0bacda7823a2a3,
            limb2: 0xf86f49955238f2a
        },
        r0a1: u288 {
            limb0: 0xd59e1b0826e2c54de988e071,
            limb1: 0xbcf30ad303fb42f630406dc1,
            limb2: 0x275297037ae93f99
        },
        r1a0: u288 {
            limb0: 0x70aadaf97e55c83c97a5d09d,
            limb1: 0x670924f037f2805f1e53d158,
            limb2: 0x303926eb660dc930
        },
        r1a1: u288 {
            limb0: 0x6f474e4a7c3376e8bbb12caa,
            limb1: 0xfa84fc1e7b904894696fa553,
            limb2: 0x120cdc88fd5113dc
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x806e24a45d157b9bd130e1a3,
            limb1: 0x41c84e8c1b11d5d517c5924f,
            limb2: 0x9faf1c2cd772e00
        },
        r0a1: u288 {
            limb0: 0x8da66446ddb33d6d6ca267f9,
            limb1: 0xc59a8b2f2b6756c82ec7f4e8,
            limb2: 0x212f1f5811908101
        },
        r1a0: u288 {
            limb0: 0xe3a931f19e7d0f2ecff38a00,
            limb1: 0x322e9e75fc1e3189f4626312,
            limb2: 0x26f2723d85ab7b54
        },
        r1a1: u288 {
            limb0: 0xc8ffddd16405c5f744213303,
            limb1: 0x53e430c2d73406fd2d323f6b,
            limb2: 0x55108119e1afae4
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x348e15357d9299e582033136,
            limb1: 0x53578c46b15abb39da35a56e,
            limb2: 0x1043b711f86bb33f
        },
        r0a1: u288 {
            limb0: 0x9fa230a629b75217f0518e7c,
            limb1: 0x77012a4bb8751322a406024d,
            limb2: 0x121e2d845d972695
        },
        r1a0: u288 {
            limb0: 0x5600f2d51f21d9dfac35eb10,
            limb1: 0x6fde61f876fb76611fb86c1a,
            limb2: 0x2bf4fbaf5bd0d0df
        },
        r1a1: u288 {
            limb0: 0xd732aa0b6161aaffdae95324,
            limb1: 0xb3c4f8c3770402d245692464,
            limb2: 0x2a0f1740a293e6f0
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xcee1af8b688fb7f082b28f2c,
            limb1: 0x204ef76e3a3b1e0d7e07ebe,
            limb2: 0x1eba5e7e4c8bdd50
        },
        r0a1: u288 {
            limb0: 0x6d0901e0c498e0e70fcf9089,
            limb1: 0x5c62292eb69f6b84e256c623,
            limb2: 0x9a7852250ff4f35
        },
        r1a0: u288 {
            limb0: 0x4d798fc1c43855fbfdaa2480,
            limb1: 0x1e0a1c22a2a88247e601b95e,
            limb2: 0x7fedc52df1ab20a
        },
        r1a1: u288 {
            limb0: 0x2f8d00b290203f342fb2015a,
            limb1: 0xb892c1bd2f4a927181fd50b,
            limb2: 0x1d5b1611b2758a22
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xa9e2efa41aaa98ab59728940,
            limb1: 0x163c0425f66ce72daef2f53e,
            limb2: 0x2feaf1b1770aa7d8
        },
        r0a1: u288 {
            limb0: 0x3bb7afd3c0a79b6ac2c4c063,
            limb1: 0xee5cb42e8b2bc999e312e032,
            limb2: 0x1af2071ae77151c3
        },
        r1a0: u288 {
            limb0: 0x1cef1c0d8956d7ceb2b162e7,
            limb1: 0x202b4af9e51edfc81a943ded,
            limb2: 0xc9e943ffbdcfdcb
        },
        r1a1: u288 {
            limb0: 0xe18b1b34798b0a18d5ad43dd,
            limb1: 0x55e8237731941007099af6b8,
            limb2: 0x1472c0290db54042
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x8dc7c2fbe7744df39ae2e084,
            limb1: 0x8637c2464c3f5b21a8b7f268,
            limb2: 0x24efcc5eb2b7b82d
        },
        r0a1: u288 {
            limb0: 0xf3dff389155fd958de233d0,
            limb1: 0xb7744b391800497fb8b50195,
            limb2: 0x29d7fbea269e78c2
        },
        r1a0: u288 {
            limb0: 0x116e55cd01ffa34aedb20e9e,
            limb1: 0xa60312adc7c5a5ac37a13baf,
            limb2: 0xa02b6b8ead37fe8
        },
        r1a1: u288 {
            limb0: 0x3023a1350087258349cfeaba,
            limb1: 0x6abc83f96ffbe97257c34958,
            limb2: 0x14b3a18abab9d00
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb4c7963e0d1dc082de0725e,
            limb1: 0x375a7a3d765918de24804223,
            limb2: 0xf177b77b031596d
        },
        r0a1: u288 {
            limb0: 0x87a7b9c5f10500b0b40d7a1e,
            limb1: 0x6f234d1dc7f1394b55858810,
            limb2: 0x26288146660a3914
        },
        r1a0: u288 {
            limb0: 0xa6308c89cebe40447abf4a9a,
            limb1: 0x657f0fdda13b1f8ee314c22,
            limb2: 0x1701aabc250a9cc7
        },
        r1a1: u288 {
            limb0: 0x9db9bf660dc77cbe2788a755,
            limb1: 0xbdf9c1c15a4bd502a119fb98,
            limb2: 0x14b4de3d26bd66e1
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x53c49c62ca96007e14435295,
            limb1: 0x85aeb885e4123ca8d3232fdf,
            limb2: 0x750017ce108abf3
        },
        r0a1: u288 {
            limb0: 0xba6bf3e25d370182e4821239,
            limb1: 0x39de83bf370bd2ba116e8405,
            limb2: 0x2b8417a72ba6d940
        },
        r1a0: u288 {
            limb0: 0xa922f50550d349849b14307b,
            limb1: 0x569766b6feca6143a5ddde9d,
            limb2: 0x2c3c6765b25a01d
        },
        r1a1: u288 {
            limb0: 0x6016011bdc3b506563b0f117,
            limb1: 0xbab4932beab93dde9b5b8a5c,
            limb2: 0x1bf3f698de0ace60
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x1df910e941537108abdc6266,
            limb1: 0x3cf67b790d7d5e78bf95488,
            limb2: 0x227a0944187c6ce9
        },
        r0a1: u288 {
            limb0: 0x8ff75828214984eeb2f40b87,
            limb1: 0x803306bd17a832f17e235878,
            limb2: 0x853442ae54079e4
        },
        r1a0: u288 {
            limb0: 0x7d3fe8411e3441eed074c2ab,
            limb1: 0x3547f6d645c1de4f549d405c,
            limb2: 0x2e7f210b54b0d2e6
        },
        r1a1: u288 {
            limb0: 0x6dc865431bd5116cb79ff2bb,
            limb1: 0x45fb77ce3a5a42f51df2b8a5,
            limb2: 0x264a8d8165f95ee0
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xf31eb38f23dbab5a1804c203,
            limb1: 0x1f207a8ddd59d0e5bc6b9c9e,
            limb2: 0x1141be56af96e575
        },
        r0a1: u288 {
            limb0: 0x9839a71e7edbdbe0a9b81de4,
            limb1: 0x2bd2f744ead4ce873a98c616,
            limb2: 0x90d55fda52e7d9d
        },
        r1a0: u288 {
            limb0: 0x9f79105bea9ad3ea95a83839,
            limb1: 0xa09b505f11601458ede73961,
            limb2: 0x2426ff554e7ca261
        },
        r1a1: u288 {
            limb0: 0x15cfc5e4dd45078d24327bce,
            limb1: 0x851cbac937d3280bd360e030,
            limb2: 0xcfaf36200bb9e49
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb9f05ffda3ee208f990ff3a8,
            limb1: 0x6201d08440b28ea672b9ea93,
            limb2: 0x1ed60e5a5e778b42
        },
        r0a1: u288 {
            limb0: 0x8e8468b937854c9c00582d36,
            limb1: 0x7888fa8b2850a0c555adb743,
            limb2: 0xd1342bd01402f29
        },
        r1a0: u288 {
            limb0: 0xf5c4c66a974d45ec754b3873,
            limb1: 0x34322544ed59f01c835dd28b,
            limb2: 0x10fe4487a871a419
        },
        r1a1: u288 {
            limb0: 0xedf4af2df7c13d6340069716,
            limb1: 0x8592eea593ece446e8b2c83b,
            limb2: 0x12f9280ce8248724
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x344b4e4ff8653902575c139b,
            limb1: 0xc726d83a8331694e453e6c72,
            limb2: 0x20c3a9b96f164614
        },
        r0a1: u288 {
            limb0: 0xd227cfba3d23f3fe1aefe92,
            limb1: 0x76e8f5e2fed31c0c3d8d4d8a,
            limb2: 0x77ca535ffaac936
        },
        r1a0: u288 {
            limb0: 0xc44f467143b5b25661040bb6,
            limb1: 0xc7df62f7d1f30a5bfea5d638,
            limb2: 0x1642f87ddd233bdc
        },
        r1a1: u288 {
            limb0: 0xc91e164cc21f252ac7674739,
            limb1: 0x670bffce5705a34b747646f2,
            limb2: 0xaa6bbf8bd839779
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xe67f72c6d45f1bb04403139f,
            limb1: 0x9233e2a95d3f3c3ff2f7e5b8,
            limb2: 0x1f931e8e4343b028
        },
        r0a1: u288 {
            limb0: 0x20ef53907af71803ce3ca5ca,
            limb1: 0xd99b6637ee9c73150b503ea4,
            limb2: 0x1c9759def8a98ea8
        },
        r1a0: u288 {
            limb0: 0xa0a3b24c9089d224822fad53,
            limb1: 0xdfa2081342a7a895062f3e50,
            limb2: 0x185e8cf6b3e494e6
        },
        r1a1: u288 {
            limb0: 0x8752a12394b29d0ba799e476,
            limb1: 0x1493421da067a42e7f3d0f8f,
            limb2: 0x67e7fa3e3035edf
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xe393730be8e34fba4a5c723e,
            limb1: 0x556fc9961c6e1d5a324a4184,
            limb2: 0x187fb5e3832e9fcb
        },
        r0a1: u288 {
            limb0: 0xb5a0efe1c16e18adf149a620,
            limb1: 0xb1879281784c7d6f7a3fb01,
            limb2: 0xe39711e87e56414
        },
        r1a0: u288 {
            limb0: 0xf84ef328539e1eba440ac498,
            limb1: 0x7f6d229e03990a0f5460b023,
            limb2: 0x19478a268134dd37
        },
        r1a1: u288 {
            limb0: 0xaceda0b2beb643fd67a59321,
            limb1: 0x5fb7046810a4387ecf4c8c2d,
            limb2: 0x184c3581661b7bef
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x6d6138c95464e5e774ae7ba0,
            limb1: 0xe6ca73a5498e4ccd4bb68fc7,
            limb2: 0x15bf8aa8ed1beff6
        },
        r0a1: u288 {
            limb0: 0xabd7c55a134ed405b4966d3c,
            limb1: 0xe69dd725ccc4f9dd537fe558,
            limb2: 0x2df4a03e2588a8f1
        },
        r1a0: u288 {
            limb0: 0x7cf42890de0355ffc2480d46,
            limb1: 0xe33c2ad9627bcb4b028c2358,
            limb2: 0x2a18767b40de20bd
        },
        r1a1: u288 {
            limb0: 0x79737d4a87fab560f3d811c6,
            limb1: 0xa88fee5629b91721f2ccdcf7,
            limb2: 0x2b51c831d3404d5e
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xbe10ac5f513a7e023d87d142,
            limb1: 0x52b041e549ad9236dc088ab7,
            limb2: 0xb909fc99fbecbc4
        },
        r0a1: u288 {
            limb0: 0xfa45fa3426b394c8778b6ad1,
            limb1: 0xf8bdfc9bba162de917683bde,
            limb2: 0xe709a801289b50
        },
        r1a0: u288 {
            limb0: 0xae01eb28f054acbd75858689,
            limb1: 0xfc571e4915b6af860982114e,
            limb2: 0x86ef068ca3d7e8d
        },
        r1a1: u288 {
            limb0: 0x5924a58c4ccf658f886fdcbc,
            limb1: 0x78489db7bad238159278d1e3,
            limb2: 0x2ff8cd6a452c5209
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x9812f6145cf7e949fa207f20,
            limb1: 0x4061c36b08d5bcd408b14f19,
            limb2: 0x8332e08b2eb51ed
        },
        r0a1: u288 {
            limb0: 0xa4a7ae8f65ba180c523cb33,
            limb1: 0xb71fabbdc78b1128712d32a5,
            limb2: 0x2acd1052fd0fefa7
        },
        r1a0: u288 {
            limb0: 0x6ea5598e221f25bf27efc618,
            limb1: 0xa2c2521a6dd8f306f86d6db7,
            limb2: 0x13af144288655944
        },
        r1a1: u288 {
            limb0: 0xea469c4b390716a6810fff5d,
            limb1: 0xf8052694d0fdd3f40b596c20,
            limb2: 0x24d0ea6c86e48c5c
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x2e39be614d904bafea58a8cd,
            limb1: 0xf53f0a6a20a1f1783b0ea2d0,
            limb2: 0x99c451b7bb726d7
        },
        r0a1: u288 {
            limb0: 0x28ec54a4ca8da838800c573d,
            limb1: 0xb78365fa47b5e192307b7b87,
            limb2: 0x2df87aa88e012fec
        },
        r1a0: u288 {
            limb0: 0xfb7022881c6a6fdfb18de4aa,
            limb1: 0xb9bd30f0e93c5b93ad333bab,
            limb2: 0x1dd20cbccdeb9924
        },
        r1a1: u288 {
            limb0: 0x16d8dfdf790a6be16a0e55ba,
            limb1: 0x90ab884395509b9a264472d4,
            limb2: 0xeaec571657b6e9d
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x716f33c8ea4f9f97e5fe522a,
            limb1: 0xf482e7ea845ea2d0e5e66e12,
            limb2: 0x2c5dd88b5da833cc
        },
        r0a1: u288 {
            limb0: 0x9f37e0fb826c88a9a2baba09,
            limb1: 0x472d1f843509a409c0b71ee,
            limb2: 0x18cb844296ef5e12
        },
        r1a0: u288 {
            limb0: 0x105455cc96dfccafe1b83519,
            limb1: 0x54002c756e893c27cf98473,
            limb2: 0xc32dedde38f520c
        },
        r1a1: u288 {
            limb0: 0x58c05e9825803f9a76b1242a,
            limb1: 0xe5bfa25e5f975bb4d18465ec,
            limb2: 0x1fdadb994d183244
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xe1bef5d29c154fbed79f9374,
            limb1: 0x6fc91ea0efeaf098090e69e3,
            limb2: 0x2b38d48f9c55e881
        },
        r0a1: u288 {
            limb0: 0xbb17e0c83b450816302c33d3,
            limb1: 0x4130d6a32a01466f0c58a5,
            limb2: 0x2347cdd69081c579
        },
        r1a0: u288 {
            limb0: 0x64087c1616b503b217e5fa53,
            limb1: 0x1a31685ef9622ce67173514f,
            limb2: 0x1691e2252ac83827
        },
        r1a1: u288 {
            limb0: 0x2a2585cd64c95b83044afcd6,
            limb1: 0x308ab58303678899cf790122,
            limb2: 0x108bc00c2c38db93
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xce78fc6505db036c10fac771,
            limb1: 0x61f8c0bc7f60ad6415d5e419,
            limb2: 0x59009c5cf9ea663
        },
        r0a1: u288 {
            limb0: 0xb3b3f697fc34d64ba053b914,
            limb1: 0x317af5815ce5bfffc5a6bc97,
            limb2: 0x23f97fee4deda847
        },
        r1a0: u288 {
            limb0: 0xf559e09cf7a02674ac2fa642,
            limb1: 0x4fa7548b79cdd054e203689c,
            limb2: 0x2173b379d546fb47
        },
        r1a1: u288 {
            limb0: 0x758feb5b51caccff9da0f78f,
            limb1: 0xd7f37a1008233b74c4894f55,
            limb2: 0x917c640b4b9627e
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xbbc21b9304dad11043058762,
            limb1: 0xcbd755de6f76dfb306baf4e6,
            limb2: 0x1f71c685a98f82c3
        },
        r0a1: u288 {
            limb0: 0xf53b940e0e28e0d854b531b3,
            limb1: 0x71584abf8364cf2d2ce1ac07,
            limb2: 0x22852b743b1a12e4
        },
        r1a0: u288 {
            limb0: 0xd56a47be0d45315e4a3e6517,
            limb1: 0xf1944147332689ff6a95d16d,
            limb2: 0x1d01ff19b03a0f69
        },
        r1a1: u288 {
            limb0: 0xad2fe47455ed607758a6e4c4,
            limb1: 0xfe6e5e985ca54b99955ed33e,
            limb2: 0x26e9550aee6fc3ae
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x72548e0d946b796842cfecd8,
            limb1: 0x78b54b355e3c26476b0fab82,
            limb2: 0x2dc9f32c90b6ba31
        },
        r0a1: u288 {
            limb0: 0xa943be83a6fc90414320753b,
            limb1: 0xd708fde97241095833ce5a08,
            limb2: 0x142111e6a73d2e82
        },
        r1a0: u288 {
            limb0: 0xc79e8d5465ec5f28781e30a2,
            limb1: 0x697fb9430b9ad050ced6cce,
            limb2: 0x1a9d647149842c53
        },
        r1a1: u288 {
            limb0: 0x9bab496952559362586725cd,
            limb1: 0xbe78e5a416d9665be64806de,
            limb2: 0x147b550afb4b8b84
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x3b7f337e1a6013b1a169856b,
            limb1: 0x9ebdfab6b9c1e8848525d1ff,
            limb2: 0x262721bd15fa8956
        },
        r0a1: u288 {
            limb0: 0x3886b6a96dc8791f45dc4db2,
            limb1: 0xc07937b324c852bc1803d5ff,
            limb2: 0x2472e9ace529fb21
        },
        r1a0: u288 {
            limb0: 0x92900a6f5eee63dd8edca48b,
            limb1: 0xaa2e5a3658eaa33bc13ee1f,
            limb2: 0x20a3f5dd8ba373c
        },
        r1a1: u288 {
            limb0: 0x6558cd0eb93ecf24d97c02a0,
            limb1: 0xe62d9fe8435701de624c9eee,
            limb2: 0x23cb9b33777e7fe7
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x1422e11013fe6cdd7f843391,
            limb1: 0xfb96092ab69fc530e27d8d8e,
            limb2: 0xe39e04564fedd0
        },
        r0a1: u288 {
            limb0: 0xbd4e81e3b4db192e11192788,
            limb1: 0x805257d3c2bdbc344a15ce0d,
            limb2: 0x10ddd4f47445106b
        },
        r1a0: u288 {
            limb0: 0x87ab7f750b693ec75bce04e1,
            limb1: 0x128ba38ebed26d74d26e4d69,
            limb2: 0x2f1d22a64c983ab8
        },
        r1a1: u288 {
            limb0: 0x74207c17f5c8335183649f77,
            limb1: 0x7144cd3520ac2e1be3204133,
            limb2: 0xb38d0645ab3499d
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x64d105095fe48bcdc755a88d,
            limb1: 0x49ca4ba8b1ff7ab7ad2198b5,
            limb2: 0x935ebfaf5014356
        },
        r0a1: u288 {
            limb0: 0xc446b0377c7971710cb7838f,
            limb1: 0x77a57e0ce1bab68161035b74,
            limb2: 0x16703864d1aa89ec
        },
        r1a0: u288 {
            limb0: 0x8f7437235dd6970c9695edb,
            limb1: 0xb6e0a72fd0f6b2f21d32b2f9,
            limb2: 0x1a84f1c3ea104580
        },
        r1a1: u288 {
            limb0: 0xc663d1864722a4829e192c3,
            limb1: 0x2ab3c313a4596881c2fbe254,
            limb2: 0x14fa1328d23c59dc
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x49173a889c697b0ab07f35bc,
            limb1: 0xdcffb65f4b4c21ced6b623af,
            limb2: 0x1366d12ee6022f7b
        },
        r0a1: u288 {
            limb0: 0x285fdce362f7a79b89c49b5c,
            limb1: 0xae9358c8eaf26e2fed7353f5,
            limb2: 0x21c91fefaf522b5f
        },
        r1a0: u288 {
            limb0: 0x748798f96436e3b18c64964a,
            limb1: 0xfc3bb221103d3966d0510599,
            limb2: 0x167859ae2ebc5e27
        },
        r1a1: u288 {
            limb0: 0xe3b55b05bb30e23fa7eba05b,
            limb1: 0xa5fc8b7f7bc6abe91c90ddd5,
            limb2: 0xe0da83c6cdebb5a
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x30a4abff5957209783681bfb,
            limb1: 0x82d868d5ca421e4f1a0daf79,
            limb2: 0x1ba96ef98093d510
        },
        r0a1: u288 {
            limb0: 0xd9132c7f206a6c036a39e432,
            limb1: 0x8a2dfb94aba29a87046110b8,
            limb2: 0x1fad2fd5e5e37395
        },
        r1a0: u288 {
            limb0: 0x76b136dc82b82e411b2c44f6,
            limb1: 0xe405f12052823a54abb9ea95,
            limb2: 0xf125ba508c26ddc
        },
        r1a1: u288 {
            limb0: 0x1bae07f5f0cc48e5f7aac169,
            limb1: 0x47d1288d741496a960e1a979,
            limb2: 0xa0911f6cc5eb84e
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x3f1f476f260960546b8b2748,
            limb1: 0x3a093749a79abdf88b4270fc,
            limb2: 0xceaea8e33fb19f2
        },
        r0a1: u288 {
            limb0: 0xf9c60a4d3e0354b248644faf,
            limb1: 0x71564c1a6ab5776ab6627c23,
            limb2: 0x28d3c46454bc98c0
        },
        r1a0: u288 {
            limb0: 0xa55511bbabbc5bec3ca48f44,
            limb1: 0xb06fd45b690f3fb81edf5e8a,
            limb2: 0x2c36e92a380a07ab
        },
        r1a1: u288 {
            limb0: 0xa3ccea63010a2fd6d5d3fb62,
            limb1: 0x246aa55d586c22d1a30f638a,
            limb2: 0x16b45af3b702bfda
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x33b7b77df2a3acfbd2d7123a,
            limb1: 0x6fcc52bedf5fd4933530a3d0,
            limb2: 0x1ab2f51cbe064338
        },
        r0a1: u288 {
            limb0: 0xb56c53abb4d4b518a249f718,
            limb1: 0xd040a853d1be2ca9e561372a,
            limb2: 0x576c5b39f0eb295
        },
        r1a0: u288 {
            limb0: 0x4a4450755c56e0c8274c739b,
            limb1: 0xf5f4a2a26217bd90f7b034b6,
            limb2: 0xca3be3415a936d4
        },
        r1a1: u288 {
            limb0: 0xb181c1dab9b414434b929bcb,
            limb1: 0x7416a6669f5253cfd2b6810b,
            limb2: 0x1e38a8c607545e0c
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x2e7b3a5a35456f42e87968e6,
            limb1: 0xb4303f5093c3a460674a2fcd,
            limb2: 0x2b5331f03b8fa15f
        },
        r0a1: u288 {
            limb0: 0x7cea371d64d8bd0fc5b9427e,
            limb1: 0x76208e15fc175e352c274fbe,
            limb2: 0x5ceb46647d41234
        },
        r1a0: u288 {
            limb0: 0x6cdac06bfcf041a30435a560,
            limb1: 0x15a7ab7ed1df6d7ed12616a6,
            limb2: 0x2520b0f462ad4724
        },
        r1a1: u288 {
            limb0: 0xe8b65c5fff04e6a19310802f,
            limb1: 0xc96324a563d5dab3cd304c64,
            limb2: 0x230de25606159b1e
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x7bbccba4d769a649d8c86138,
            limb1: 0xfbc3bfa0bd7133f373b5fbf3,
            limb2: 0x13a7a1920bd77f0b
        },
        r0a1: u288 {
            limb0: 0x30369accebb31e7437470d47,
            limb1: 0x11db84e1f93a21e52088d49,
            limb2: 0x10a8d64dc1c2cf2f
        },
        r1a0: u288 {
            limb0: 0xfc0db67d06836664567f6caa,
            limb1: 0x1cdf7ab8069ad7a685fed5de,
            limb2: 0x39591544dfcdf2a
        },
        r1a1: u288 {
            limb0: 0xfc845737a7eba91840b2530e,
            limb1: 0x7174483439b596e270cb6e67,
            limb2: 0xfa1f364a078d294
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb2236e5462d1e11842039bb5,
            limb1: 0x8d746dd0bb8bb2a455d505c1,
            limb2: 0x2fd3f4a905e027ce
        },
        r0a1: u288 {
            limb0: 0x3d6d9836d71ddf8e3b741b09,
            limb1: 0x443f16e368feb4cb20a5a1ab,
            limb2: 0xb5f19dda13bdfad
        },
        r1a0: u288 {
            limb0: 0x4e5612c2b64a1045a590a938,
            limb1: 0xbca215d075ce5769db2a29d7,
            limb2: 0x161e651ebdfb5065
        },
        r1a1: u288 {
            limb0: 0xc02a55b6685351f24e4bf9c7,
            limb1: 0x4134240119050f22bc4991c8,
            limb2: 0x300bd9f8d76bbc11
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xe9296a3a3aed4c4143d2e0ba,
            limb1: 0x7de973514b499b2da739b3e6,
            limb2: 0x1b4b807986fcdee0
        },
        r0a1: u288 {
            limb0: 0xb9295fecce961afe0c5e6dad,
            limb1: 0xc4e30c322bcae6d526c4de95,
            limb2: 0x1fee592f513ed6b2
        },
        r1a0: u288 {
            limb0: 0x7245f5e5e803d0d448fafe21,
            limb1: 0xcbdc032ecb3b7a63899c53d0,
            limb2: 0x1fde9ffc17accfc3
        },
        r1a1: u288 {
            limb0: 0x8edcc1b2fdd35c87a7814a87,
            limb1: 0x99d54b5c2fe171c49aa9cb08,
            limb2: 0x130ef740e416a6fe
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xe6c6b0071995b99d3c5e985b,
            limb1: 0xdb2de0c6749b92f366e4a97,
            limb2: 0x1c3a1d1601f79696
        },
        r0a1: u288 {
            limb0: 0xb0ef17e897a3e39e24e57d75,
            limb1: 0xbd110422178884da05c2c4d6,
            limb2: 0x10815d171885def
        },
        r1a0: u288 {
            limb0: 0x26a448dd9f7330882c8d2fb6,
            limb1: 0xb3228619e337a53da6809a5b,
            limb2: 0x7264780310de0f0
        },
        r1a1: u288 {
            limb0: 0x874abdae62534247e4e1eb62,
            limb1: 0xc232831cf791d5f9a1154cfe,
            limb2: 0x22a9626e0cb3f25a
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x7c957e767c0dfd09eac44566,
            limb1: 0x1ddf799730d01408eecb96c7,
            limb2: 0x13be45045475737d
        },
        r0a1: u288 {
            limb0: 0x1b93212d7497a9a85fd90a6d,
            limb1: 0xfe257a577a66ef190cce7af4,
            limb2: 0x40277293644e730
        },
        r1a0: u288 {
            limb0: 0x81de4a99ecd4852f2eeb5b9d,
            limb1: 0x45b54d5962fabf2b6a3d8bd1,
            limb2: 0x51e2388ce25f327
        },
        r1a1: u288 {
            limb0: 0x6fda38aea55bf82bb2763c,
            limb1: 0x3ed11f3a4f2014eb0af36ed8,
            limb2: 0xe3e386202ff2f66
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x537ecf0916b38aeea21d4e47,
            limb1: 0x181a00de27ba4be1b380d6c8,
            limb2: 0x8c2fe2799316543
        },
        r0a1: u288 {
            limb0: 0xe68fff5ee73364fff3fe403b,
            limb1: 0x7b8685c8a725ae79cfac8f99,
            limb2: 0x7b4be349766aba4
        },
        r1a0: u288 {
            limb0: 0xdf7c93c0095545ad5e5361ea,
            limb1: 0xce316c76191f1e7cd7d03f3,
            limb2: 0x22ea21f18ddec947
        },
        r1a1: u288 {
            limb0: 0xa19620b4c32db68cc1c2ef0c,
            limb1: 0xffa1e4be3bed5faba2ccbbf4,
            limb2: 0x16fc78a64c45f518
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x2b6af476f520b4bf804415bc,
            limb1: 0xd949ee7f9e8874698b090fca,
            limb2: 0x34db5e5ec2180cf
        },
        r0a1: u288 {
            limb0: 0x3e06a324f038ac8abcfb28d7,
            limb1: 0xc2e6375b7a83c0a0145f8942,
            limb2: 0x2247e79161483763
        },
        r1a0: u288 {
            limb0: 0x708773d8ae3a13918382fb9d,
            limb1: 0xaf83f409556e32aa85ae92bf,
            limb2: 0x9af0a924ae43ba
        },
        r1a1: u288 {
            limb0: 0xa6fded212ff5b2ce79755af7,
            limb1: 0x55a2adfb2699ef5de6581b21,
            limb2: 0x2476e83cfe8daa5c
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xcc0cff80eb51c2158ac8292d,
            limb1: 0x304970911754e3b929096235,
            limb2: 0x143f39c90df8746d
        },
        r0a1: u288 {
            limb0: 0xd10c16e58378dbc4cdabd369,
            limb1: 0x98345ef72e62cfb4b6c24a07,
            limb2: 0x154af7a987e03d1c
        },
        r1a0: u288 {
            limb0: 0x6422e2690ba9ad289dd44196,
            limb1: 0xc15eca4d2ddc0f2cf4f743af,
            limb2: 0x628f84f6bc37bee
        },
        r1a1: u288 {
            limb0: 0xdbf2c2088e391773d1262058,
            limb1: 0xe2951c4bbd01fb32716a2b6b,
            limb2: 0x2464cf0d0f7386b7
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xe4945fd48f4e39ab486042c,
            limb1: 0xa6cb02fa95051354a6844bbf,
            limb2: 0x28f174678f24d386
        },
        r0a1: u288 {
            limb0: 0x7de9e5e6286e693f5a86028c,
            limb1: 0x4dfc524ae8fb11e01135614f,
            limb2: 0x2229d71de6ca6510
        },
        r1a0: u288 {
            limb0: 0xb0b03b11f6d859a06196ca24,
            limb1: 0x3441972bd543cf73c21cebf1,
            limb2: 0x2716b75a61b65c43
        },
        r1a1: u288 {
            limb0: 0x44bac27ce3b6b47b84ef5f57,
            limb1: 0x58f4aa17e2c199772e87cf0e,
            limb2: 0xa5a76723704613e
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x1c4759bcf7c607fe3f839d4d,
            limb1: 0xea91f311da73327e2ed40785,
            limb2: 0x2017052c72360f42
        },
        r0a1: u288 {
            limb0: 0x38cf8a4368c0709980199fc3,
            limb1: 0xfc9047885996c19e84d7d4ea,
            limb2: 0x1795549eb0b97783
        },
        r1a0: u288 {
            limb0: 0xb70f7ecfbec0eaf46845e8cc,
            limb1: 0x9ddf274c2a9f89ea3bc4d66f,
            limb2: 0xcc6f106abfcf377
        },
        r1a1: u288 {
            limb0: 0xf6ff11ce29186237468c2698,
            limb1: 0x5c629ad27bb61e4826bb1313,
            limb2: 0x2014c6623f1fb55e
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xdec7541c035d36158aac3d19,
            limb1: 0x7fcb82f2764fba6f2fd4ef31,
            limb2: 0x14a697ac11c3f917
        },
        r0a1: u288 {
            limb0: 0xba1aa55b87dba7098731537c,
            limb1: 0x60cc70500aa83bd13ec65c36,
            limb2: 0x2c5c6b5943df2be6
        },
        r1a0: u288 {
            limb0: 0x33db92b3b382296b8759f2b4,
            limb1: 0xb14787d7e23ebb46fa4d3eaf,
            limb2: 0x194d3ee8eb80b699
        },
        r1a1: u288 {
            limb0: 0x6cf305bd1068f01542474871,
            limb1: 0x6c015586efd187273d522964,
            limb2: 0x2e8a475269f6fb70
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xc648054e4b6134bbfd68487f,
            limb1: 0xdf0506dad3f3d098c13a6386,
            limb2: 0x26bebeb6f46c2e8c
        },
        r0a1: u288 {
            limb0: 0x9d0cdb28a94204776c6e6ba6,
            limb1: 0x303f02dfe619752b1607951d,
            limb2: 0x1127d8b17ef2c064
        },
        r1a0: u288 {
            limb0: 0xe34ca1188b8db4e4694a696c,
            limb1: 0x243553602481d9b88ca1211,
            limb2: 0x1f8ef034831d0132
        },
        r1a1: u288 {
            limb0: 0xe3a5dfb1785690dad89ad10c,
            limb1: 0xd690b583ace24ba033dd23e0,
            limb2: 0x405d0709e110c03
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x7ba828cd96eb0bfe41d71ec7,
            limb1: 0x7ebc5615054c2f861d872638,
            limb2: 0x1a36f79f6bef0b0b
        },
        r0a1: u288 {
            limb0: 0x21495ea6fbb93c2c659281ce,
            limb1: 0xd7351ee96f078d33f34e40b2,
            limb2: 0x303a9d53d9a2ce20
        },
        r1a0: u288 {
            limb0: 0xb36e483da93799a15777024a,
            limb1: 0x55700639ad6b6a5bf7344549,
            limb2: 0xc8576a95c14f7fb
        },
        r1a1: u288 {
            limb0: 0xf0865a886c2bd6862970d513,
            limb1: 0x24d922419ae8c23cc98297ed,
            limb2: 0x2ee8df165681be72
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x72cc2cef2785ce4ff4e9b7af,
            limb1: 0x60ed5b9c207d7f31fb6234ab,
            limb2: 0x1bb17a4bc7b643ed
        },
        r0a1: u288 {
            limb0: 0x9424eb15b502cde7927c7530,
            limb1: 0xa0e33edbbaa9de8e9c206059,
            limb2: 0x2b9a3a63bbf4af99
        },
        r1a0: u288 {
            limb0: 0x423811cb6386e606cf274a3c,
            limb1: 0x8adcc0e471ecfe526f56dc39,
            limb2: 0x9169a8660d14368
        },
        r1a1: u288 {
            limb0: 0xf616c863890c3c8e33127931,
            limb1: 0xcc9414078a6da6989dae6b91,
            limb2: 0x594d6a7e6b34ab2
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x6a54338f6736806c5dd94c32,
            limb1: 0x932497ddc5557e828c9eb3bb,
            limb2: 0x1f9f9cf32ea24b75
        },
        r0a1: u288 {
            limb0: 0x18ef2b6cb698d91959334fcb,
            limb1: 0xdaee2917ac2962d396f97634,
            limb2: 0xcc1dcbe7e6d52d7
        },
        r1a0: u288 {
            limb0: 0x954ea07f4d4b663a76056a9f,
            limb1: 0xafd0f3e35f5ea578027de17e,
            limb2: 0x21055a7f086c307a
        },
        r1a1: u288 {
            limb0: 0xfda5304d3810a551deb46218,
            limb1: 0x16442d03bf6eb5606c02e892,
            limb2: 0x2a46fcec80ef070b
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xf2d619ae78049bf9141c35cf,
            limb1: 0x717f8b10d469a1ee2d91f191,
            limb2: 0x2c72c82fa8afe345
        },
        r0a1: u288 {
            limb0: 0xb89321223b82a2dc793c0185,
            limb1: 0x71506a0cf4adb8e51bb7b759,
            limb2: 0x2c13b92a98651492
        },
        r1a0: u288 {
            limb0: 0x4947ef2c89276f77f9d20942,
            limb1: 0xb454d68685ab6b6976e71ec5,
            limb2: 0x19a938d0e78a3593
        },
        r1a1: u288 {
            limb0: 0xbe883eb119609b489c01c905,
            limb1: 0xaa06779922047f52feac5ce6,
            limb2: 0x76977a3015dc164
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x43a96a588005043a46aadf2c,
            limb1: 0xa37b89d8a1784582f0c52126,
            limb2: 0x22e9ef3f5d4b2297
        },
        r0a1: u288 {
            limb0: 0x8c6f6d8474cf6e5a58468a31,
            limb1: 0xeb1ce6ac75930ef1c79b07e5,
            limb2: 0xf49839a756c7230
        },
        r1a0: u288 {
            limb0: 0x82b84693a656c8e8c1f962fd,
            limb1: 0x2c1c8918ae80282208b6b23d,
            limb2: 0x14d3504b5c8d428f
        },
        r1a1: u288 {
            limb0: 0x60ef4f4324d5619b60a3bb84,
            limb1: 0x6d3090caefeedbc33638c77a,
            limb2: 0x159264c370c89fec
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xd5057e471bee6b2b3415ac4c,
            limb1: 0xa68f86fe60f1bd61808a487,
            limb2: 0xac9e18c62b5e2e1
        },
        r0a1: u288 {
            limb0: 0x43216a953eeecccc6c6a0d7d,
            limb1: 0xa3c250ee62e8ff0b7df99a89,
            limb2: 0x1eded0de9c3ace53
        },
        r1a0: u288 {
            limb0: 0x329930b00a7c19fc55689a1e,
            limb1: 0x8b50904c5fc0870e798adb6b,
            limb2: 0x2c483a3df6932e42
        },
        r1a1: u288 {
            limb0: 0x36ed8814966d616104bc83f3,
            limb1: 0xb252e796953986212e0a85e0,
            limb2: 0xa9ef4814f3202f4
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xd92abcebe3c5e68bfab21e55,
            limb1: 0x40c1d7888c794a0c690b4592,
            limb2: 0x11de1a24bcf44e42
        },
        r0a1: u288 {
            limb0: 0xa7594de9a9613895864aa924,
            limb1: 0x96acdab4137c5ac9f0b76b35,
            limb2: 0x1e150577f10f11f8
        },
        r1a0: u288 {
            limb0: 0xc964bdba2734f7c2e94a7fbc,
            limb1: 0xedfa53061b50cf32c71a48d9,
            limb2: 0x10aee577c4eeb2ad
        },
        r1a1: u288 {
            limb0: 0xc2bd69b882d42fb995b14045,
            limb1: 0x5b358f7ee2308a8e569e0b89,
            limb2: 0x25b4396e96601850
        }
    },
];

