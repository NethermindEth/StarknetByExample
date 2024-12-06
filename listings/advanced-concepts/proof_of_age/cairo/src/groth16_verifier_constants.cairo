use garaga::definitions::{G1Point, G2Point, E12D, G2Line, u384};
use garaga::definitions::u288;
use garaga::groth16::Groth16VerifyingKey;

pub const N_PUBLIC_INPUTS: usize = 4;

pub const vk: Groth16VerifyingKey =
    Groth16VerifyingKey {
        alpha_beta_miller_loop_result: E12D {
            w0: u288 {
                limb0: 0xe2b01b691aea6d3116d768c3,
                limb1: 0x591427a1ffc16051f47be930,
                limb2: 0x1095cff871ad8003
            },
            w1: u288 {
                limb0: 0xdbe9f6a029722c69016a7b5a,
                limb1: 0xb14864f3ab9948767081db72,
                limb2: 0x640837097f16b8c
            },
            w2: u288 {
                limb0: 0xb4be19a5e8f6478d6c6d3949,
                limb1: 0xd4be89377ea373557cada0ac,
                limb2: 0x8ea2212deab89ee
            },
            w3: u288 {
                limb0: 0xe24d14bb4287827260fc0538,
                limb1: 0xf0466897763dc451b92fff82,
                limb2: 0x18225745bb63364f
            },
            w4: u288 {
                limb0: 0xa31d739edce5d0279a638680,
                limb1: 0xd209490abd91b64d41b28bca,
                limb2: 0x2e08dd5cc1605873
            },
            w5: u288 {
                limb0: 0xf362113c5fe66c9c0a0359f6,
                limb1: 0xa3e78d3ffc079f1ffb7360c3,
                limb2: 0xe89181482a655ec
            },
            w6: u288 {
                limb0: 0x73c231a861cefeaa6e170e8a,
                limb1: 0x1fb05386bab0d215d553045c,
                limb2: 0x6234b8cda9a8663
            },
            w7: u288 {
                limb0: 0x975960624ec37235cc976ade,
                limb1: 0x8d14c827bd72917afb4c1bbe,
                limb2: 0x813e274e17ee987
            },
            w8: u288 {
                limb0: 0x8b52a870be253572493e8c09,
                limb1: 0x35dcee1615a054883e0a7102,
                limb2: 0x15c14dca38736733
            },
            w9: u288 {
                limb0: 0x7fa78a32e1f020bb1ae61da5,
                limb1: 0xe5a4b6a135df1ee19e9b1372,
                limb2: 0x19119ee5e8f63828
            },
            w10: u288 {
                limb0: 0xd36bd585ece6d7ae6351c5ed,
                limb1: 0xaf3579ee2ab7c77eecb732e,
                limb2: 0x2e45cb13ddb9236c
            },
            w11: u288 {
                limb0: 0xcd2b2e2015a19185cd4ff26b,
                limb1: 0x65777719520597d699168862,
                limb2: 0x69036e12743f8a3
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
                limb0: 0x700131d092f8e862e94b0f89,
                limb1: 0xe49b36b5af37e337c2830e7e,
                limb2: 0x177b9105477b25f8,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xfc0c771e9637660adb9203ec,
                limb1: 0xee6273ab3814ba068e88a506,
                limb2: 0x56996a10d8ae19c,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xe58db06f8bfede501f725173,
                limb1: 0xe231babe42e0675bb13a989a,
                limb2: 0x1da5a38e58db9dd3,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0xed30d3ca20abaa943c13cafa,
                limb1: 0xc292bc46a012b7834ea67a92,
                limb2: 0x43b39e372c6117b,
                limb3: 0x0
            }
        }
    };

pub const ic: [
    G1Point
    ; 5] = [
    G1Point {
        x: u384 {
            limb0: 0x961cebf63bab37f2009b00b2,
            limb1: 0x9f1d74473544bbfc7d7a08bf,
            limb2: 0x114c3c8be26e8f00,
            limb3: 0x0
        },
        y: u384 {
            limb0: 0x7007311005c8ae586ba45abc,
            limb1: 0x6407da1797bbb5f842cc8f9d,
            limb2: 0xb86103888233ead,
            limb3: 0x0
        }
    },
    G1Point {
        x: u384 {
            limb0: 0xf21e07c42946babb5b56266,
            limb1: 0x1d6805a9ba8c82099214899c,
            limb2: 0x18446a61e8b3f4ad,
            limb3: 0x0
        },
        y: u384 {
            limb0: 0x42000219bfb9cea4b8a9d6b8,
            limb1: 0x96022fe5d7cf9960d17ce7ec,
            limb2: 0x86ff246c06fdc80,
            limb3: 0x0
        }
    },
    G1Point {
        x: u384 {
            limb0: 0x7d19a3bbacdc2c2fa4486d47,
            limb1: 0x2bbde73793defee4cd2fe378,
            limb2: 0x2cbd6db34034a4b2,
            limb3: 0x0
        },
        y: u384 {
            limb0: 0xcde7c280b7103e72065c92eb,
            limb1: 0x906a407a274967e7b5716c70,
            limb2: 0x2d93e439338c2313,
            limb3: 0x0
        }
    },
    G1Point {
        x: u384 {
            limb0: 0x947a56a50f516fbfe5f5edad,
            limb1: 0xe7df316ebee128589978015,
            limb2: 0x8987bffdbc6cd6e,
            limb3: 0x0
        },
        y: u384 {
            limb0: 0x54b3bc7c69230940e930c091,
            limb1: 0xa8951340021dbacabcf0ab2b,
            limb2: 0x29f7c21d6fc9ff7f,
            limb3: 0x0
        }
    },
    G1Point {
        x: u384 {
            limb0: 0x6449b875c7766a2ef06735bf,
            limb1: 0x149764dea478838484eb2860,
            limb2: 0x283f147fd22d837f,
            limb3: 0x0
        },
        y: u384 {
            limb0: 0xf1ae3d067321fc84e0ebad3d,
            limb1: 0xb4963849d383c3a97d8c07d1,
            limb2: 0x2d8027819aa3eea3,
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
            limb0: 0xdf4ee88a680d7403e20e5709,
            limb1: 0x42b1327b115ae9c1551ac738,
            limb2: 0x60bc1dc663dd22b
        },
        r0a1: u288 {
            limb0: 0x614eba8d9f46f389b30ca1b6,
            limb1: 0x809fca651a44ba2502ee9340,
            limb2: 0x1414d7861de431c9
        },
        r1a0: u288 {
            limb0: 0x1934dede6cc9957d848a35d5,
            limb1: 0x82234039a48f05b0f563e56a,
            limb2: 0x227ed3b40f22d43b
        },
        r1a1: u288 {
            limb0: 0x362e11f0396cdce9d4376bb,
            limb1: 0xa931b64eae1c3e123bcb8fa6,
            limb2: 0x37600d406480b10
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
            limb0: 0x8922e202d4131812f66ea63e,
            limb1: 0x759f133b70266e9c4266a358,
            limb2: 0x2a588c967af3cdfe
        },
        r0a1: u288 {
            limb0: 0x7230fff9cd9988d25705b91,
            limb1: 0x37b07b51673c9e389492d751,
            limb2: 0x1c4f76ecc34d6e60
        },
        r1a0: u288 {
            limb0: 0x4f3cebaecf56f69953f2c772,
            limb1: 0x362d057cdcf252aca21d8527,
            limb2: 0xde57abed20ecbee
        },
        r1a1: u288 {
            limb0: 0x650ee96e3889be483b39868c,
            limb1: 0xf1e8f67d3651a4b5bb5daeb,
            limb2: 0x2cee4d9edae99519
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x4534e4083e81daacd6baecf8,
            limb1: 0x8eb9b3d65e75580a971f2646,
            limb2: 0x22d67f19ef6ffc80
        },
        r0a1: u288 {
            limb0: 0x42cd940dbfd22a9ab07946ef,
            limb1: 0xf72a41611f932f1625cc11e6,
            limb2: 0x193ec5e432be1810
        },
        r1a0: u288 {
            limb0: 0xd5339bbe25c653129812aa7e,
            limb1: 0x265c200fa6ab332e63b85c42,
            limb2: 0x1d1de2e80d7efe5a
        },
        r1a1: u288 {
            limb0: 0x46275e84fed190cae1f83de5,
            limb1: 0xf8b997c8654185b1fe669045,
            limb2: 0x1e1ee61726d4b652
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
            limb0: 0x8e6446286a9bb23eea9199a2,
            limb1: 0x4d482fd34f7c8f642157db0e,
            limb2: 0x16063b25429ce3be
        },
        r0a1: u288 {
            limb0: 0x2e55228b310c3f47c715a9b5,
            limb1: 0x3f9537b7d42588f80f0d1f7f,
            limb2: 0xc4932bf686fc39a
        },
        r1a0: u288 {
            limb0: 0x65f0514eaf9a16f3a81cbb07,
            limb1: 0xa1793445a0dff065bfb40cde,
            limb2: 0x59cdf2da6d9dcbd
        },
        r1a1: u288 {
            limb0: 0x1e40bf027def30f5c47d4dd1,
            limb1: 0xd35128b261d1399f20ad5984,
            limb2: 0x336bdc155e8761f
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
            limb0: 0x33f90797ae589ba8a4184d43,
            limb1: 0x157e6ce95526a661103554d8,
            limb2: 0x119958f142e9bec6
        },
        r0a1: u288 {
            limb0: 0x34a3e551bc07c3d849d50dbc,
            limb1: 0xc68cd9b01606c7f7757f7df6,
            limb2: 0x21dfb456c006b0b7
        },
        r1a0: u288 {
            limb0: 0x784ebbf5505722d6fa2cab32,
            limb1: 0xe6312157274f640371c3fc6e,
            limb2: 0x13dcc6d9bd8a6656
        },
        r1a1: u288 {
            limb0: 0x53d6c52e47053d91dd94f453,
            limb1: 0x79d9703d887309ef5fd8e082,
            limb2: 0xb71005ff944acb1
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xda38b6c48f327ed7b751252d,
            limb1: 0xaf37e5b741bfb5e326b82d6b,
            limb2: 0x231e11178d239e50
        },
        r0a1: u288 {
            limb0: 0x5bfec1f47b23d6984a2ae814,
            limb1: 0xff3ca7b90e423a837713f068,
            limb2: 0x258e74d6802a5a47
        },
        r1a0: u288 {
            limb0: 0x3dde8eb554c0c1869afd5037,
            limb1: 0xb4d2a9750307c18b44c93c32,
            limb2: 0x15db76bee02c53e8
        },
        r1a1: u288 {
            limb0: 0xa177e8eaa8abfbc165a26225,
            limb1: 0x6d6d04bc8ef40a3e270da3cc,
            limb2: 0x1b702747e6c8dd9a
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
            limb0: 0xe4a9c15f558ab3c57caee24,
            limb1: 0x74435c3c6c74f94daefc0c7e,
            limb2: 0x1a77db920dc5ba47
        },
        r0a1: u288 {
            limb0: 0xd004d4b2b6d039caba1b4bea,
            limb1: 0x77dc80e0fb65a0ae1cc9a77c,
            limb2: 0x25b15219e82aa700
        },
        r1a0: u288 {
            limb0: 0xf4dfcd7df2b333e7a6f4c36f,
            limb1: 0x1e1311d53a293c24bfbd9187,
            limb2: 0x1522a33b4eafd6f1
        },
        r1a1: u288 {
            limb0: 0xbe5d46f19b1328cbea261d73,
            limb1: 0x30e480571fc5207bed9d41ae,
            limb2: 0x211271571026a4b2
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
            limb0: 0xc262c89cd351f4c996c58f4a,
            limb1: 0xb834d091ef520ff572230c17,
            limb2: 0x23dee79a4ee4289e
        },
        r0a1: u288 {
            limb0: 0x1d7219f23c291ad6c63e23ea,
            limb1: 0xacf0c5d58001ee3faa6c9f5f,
            limb2: 0x29b556247931db62
        },
        r1a0: u288 {
            limb0: 0x1d07e99fd6f4e2978e00fb36,
            limb1: 0xc4140e42f103639a0b7f3d1,
            limb2: 0x2dfda567494d426b
        },
        r1a1: u288 {
            limb0: 0x80ac4a8e57361265a5ba9916,
            limb1: 0xeef5f50002304048a8da3321,
            limb2: 0x2630fc58dfddb146
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
            limb0: 0x15ad27c140ce63336c664f0c,
            limb1: 0x75f3761fb6e8ff8a13839bb6,
            limb2: 0x24b7ea80cae3bd26
        },
        r0a1: u288 {
            limb0: 0xa51cff0205e8c40d92298406,
            limb1: 0x6671625bb7e981b654c5ea89,
            limb2: 0x2bdd1d6c957a3432
        },
        r1a0: u288 {
            limb0: 0xc841a4378a3c099b1e857d61,
            limb1: 0x1b02429d810af57d4dd21b6f,
            limb2: 0x9a8d9ad26cffc
        },
        r1a1: u288 {
            limb0: 0x70c19469ad1661adb0d00201,
            limb1: 0x222f93c2bed94b1ed6efc794,
            limb2: 0x1582c8d0b2d0952c
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
            limb0: 0xb2adee370a0cbf9f9c3a1489,
            limb1: 0x501a805d58dcb2b9d73408ed,
            limb2: 0x29c659fdf8459a0
        },
        r0a1: u288 {
            limb0: 0x15ee906f9ca4902669b27cc4,
            limb1: 0xc243f62ce3d2166eaf820dd4,
            limb2: 0x2da53489186197e2
        },
        r1a0: u288 {
            limb0: 0x1298cabec73996ebc605bcf3,
            limb1: 0x7fc115a5b73c61a968d9ce9,
            limb2: 0x236239925cd4c307
        },
        r1a1: u288 {
            limb0: 0xb343ebf3ddea8dd743a556c3,
            limb1: 0x73918f1c5a7545ba1e130456,
            limb2: 0x9b9a0195b53da5e
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xeb73cbc5d0cad17dbf4ff60a,
            limb1: 0x8b99fd9712859d6f7d94e357,
            limb2: 0x5acb1e344536958
        },
        r0a1: u288 {
            limb0: 0xcb2f171eec97b258b23e8d81,
            limb1: 0x28a4fd55a2e5b3fb5a750868,
            limb2: 0x2fdec6dbba3f734c
        },
        r1a0: u288 {
            limb0: 0xff7361f65d137b8a263742c6,
            limb1: 0x28cb32a8233e260cea4ece68,
            limb2: 0x244537f2cd69fdd5
        },
        r1a1: u288 {
            limb0: 0xadff6696981e65d27d96880d,
            limb1: 0x30d314e1cbc97a11d2e702dd,
            limb2: 0xf42fc0b149b4914
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
            limb0: 0x4a11da43bb7a136d0d6ec3e9,
            limb1: 0xc2e51bea946a859acb412c6,
            limb2: 0x1b1fce40c74001fc
        },
        r0a1: u288 {
            limb0: 0x5bffd3a1256c4ec924b0eef1,
            limb1: 0x4f1ec236eb0da9a1f1de483e,
            limb2: 0x21e06de1c0079500
        },
        r1a0: u288 {
            limb0: 0x1bcf4aa38c6cdbb3b4407314,
            limb1: 0x4c4547f174358cf200b12419,
            limb2: 0xb08321fc0ee053f
        },
        r1a1: u288 {
            limb0: 0x2a0024e8ab58556096bde237,
            limb1: 0x13b9b2d918e1570288377e78,
            limb2: 0x175193b97fdf04c8
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
            limb0: 0xc6cec23194284af809d3c98,
            limb1: 0x543eb1a30cd5c34fe1a850a,
            limb2: 0x214e29857c0c6424
        },
        r0a1: u288 {
            limb0: 0xc040ca79d2ca87bf6a9f85c,
            limb1: 0x1e0a22dc378b4c5c410612f9,
            limb2: 0x1d6021be2e347797
        },
        r1a0: u288 {
            limb0: 0x6b6e534f569b0167383c9748,
            limb1: 0x3f3e16a8732f8128c6d7ca22,
            limb2: 0x630ffb1ca935324
        },
        r1a1: u288 {
            limb0: 0x20c80958390d46bc39e69320,
            limb1: 0x23eab380defd907fa952924c,
            limb2: 0x24e28ad4582bf78
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xcef58e7d35671d065a5c0521,
            limb1: 0x2ff4b056feb6d22093cb9aa2,
            limb2: 0xa73d23429a2af7f
        },
        r0a1: u288 {
            limb0: 0x8a92dfc79fa3518f620fd58f,
            limb1: 0x5ce16bf186104595f1356b05,
            limb2: 0xd89b740f23fce3d
        },
        r1a0: u288 {
            limb0: 0xcae49699a3f48cf449611c23,
            limb1: 0x96ce84917f0869166327b107,
            limb2: 0x3b265972dc5e821
        },
        r1a1: u288 {
            limb0: 0x5eb9448cc267a5cd60c13065,
            limb1: 0xa47f4479d92ecc2b83eb55c5,
            limb2: 0x152ef12d121bdc56
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
            limb0: 0x318deeba4e5812b1e34b11e4,
            limb1: 0x58df2e0555ce8f7727703018,
            limb2: 0x2ef6b716051fcaf
        },
        r0a1: u288 {
            limb0: 0xa4533c43dd3cb27683e236d0,
            limb1: 0xc3b66708697bd60bd1ebcd,
            limb2: 0x2cf652a780528d3e
        },
        r1a0: u288 {
            limb0: 0xf0d62d338e1bc4695b83389b,
            limb1: 0xd14019543efb70d1f7751226,
            limb2: 0x1e9c9904d1ad060
        },
        r1a1: u288 {
            limb0: 0x38b348fe49e3a296f6a7a9bc,
            limb1: 0x8bfc69bfc28dd75c87af86c1,
            limb2: 0x19abc0c00e290bd0
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
            limb0: 0xa61b4b5b6401f32d9cde93e,
            limb1: 0xae233c86bddf0c7d028efd56,
            limb2: 0x4c7b224787b1d0a
        },
        r0a1: u288 {
            limb0: 0x7bee17bc00edcf0d81883016,
            limb1: 0xda9026d9ff824754ccde5e3d,
            limb2: 0x9b93b593d9b9155
        },
        r1a0: u288 {
            limb0: 0x998ff0ed493c42eb0988369f,
            limb1: 0x98a3c502f9bbed4197c1e75,
            limb2: 0x19f0fd04da264937
        },
        r1a1: u288 {
            limb0: 0x34783b5450f17952f3260651,
            limb1: 0x1f86438bcae16991a527769,
            limb2: 0x1246b32a7859638c
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
            limb0: 0x75d5d3262fd3ddfb6a2d63c1,
            limb1: 0x72fe35f2fdb1b27e0e360117,
            limb2: 0x2c3188b06def5860
        },
        r0a1: u288 {
            limb0: 0xde1abdd0d6b0706da28dc26c,
            limb1: 0xf2c9312c0088390430ed03fb,
            limb2: 0x2b4a093dc5d9db72
        },
        r1a0: u288 {
            limb0: 0x69a690bc4e13ddb124a84dad,
            limb1: 0x91c7922ffa940bd01bbf68e7,
            limb2: 0x1db51c5d7c8e1653
        },
        r1a1: u288 {
            limb0: 0xb6911e8294f80c48ff7fdfa6,
            limb1: 0x4835838a990659efe3120fa2,
            limb2: 0x22ab73d7046f4a88
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
            limb0: 0x3b710b2ad8b618971a7a08a4,
            limb1: 0xd71ad0b6c512e88e542b602,
            limb2: 0x210adbed4fb173af
        },
        r0a1: u288 {
            limb0: 0x987ec4774a4b44c39b2fad05,
            limb1: 0x3d4633342621c4f36b7fb506,
            limb2: 0x130238767cc031e3
        },
        r1a0: u288 {
            limb0: 0x395de2cbb585dd8479fd582f,
            limb1: 0x21900f88d4062226c0c650b1,
            limb2: 0x2ea30bf04affddaf
        },
        r1a1: u288 {
            limb0: 0xf619308ddff5f5b5f37845d4,
            limb1: 0xe8bed5a662cb32314fe67aa2,
            limb2: 0x262e934d25709b80
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x7220a1be4e4c51da391e5c67,
            limb1: 0x12ea4b7efb4f72c4dd7ef40,
            limb2: 0x248a8643c618bccc
        },
        r0a1: u288 {
            limb0: 0x655cfc8175773c7e179eeb64,
            limb1: 0xd95d2681401139aa0b869765,
            limb2: 0x3fd2f9a8cccfca0
        },
        r1a0: u288 {
            limb0: 0xc6f75b6d8efccf692f9f8307,
            limb1: 0x63daf58ccdf32ffee3e1bd60,
            limb2: 0x261c4e4b00ae2367
        },
        r1a1: u288 {
            limb0: 0x840daa17026fbec19a8bcc1a,
            limb1: 0xe2590490472c28bd792658f6,
            limb2: 0x1ba1ec676e1bdce5
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
            limb0: 0xd8fab378c422f0253af9fa89,
            limb1: 0xa5ca5bcf3e55329bcd4b2cc6,
            limb2: 0x263726140328ef7
        },
        r0a1: u288 {
            limb0: 0xfccd5186c1ff470df67547a8,
            limb1: 0x3beef13f074f16c30ff86736,
            limb2: 0x27cb2c3a345dbb74
        },
        r1a0: u288 {
            limb0: 0xd51ad9e595235d6c74de55e9,
            limb1: 0xceca8150aeadefabb4865c3b,
            limb2: 0x2de6118d414a4e2c
        },
        r1a1: u288 {
            limb0: 0x103e8111403127720914fb41,
            limb1: 0x611f1dfd1d7168e8e13affa7,
            limb2: 0x176ceea7a5782ed6
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
            limb0: 0x982d0f158b1fe5a21f989858,
            limb1: 0xf7001b678dc9e75963cdceb,
            limb2: 0xe24f5142a43929c
        },
        r0a1: u288 {
            limb0: 0xc5ed31884e5d938203a3b853,
            limb1: 0x4d10d55082681e677ef39c8c,
            limb2: 0xeae1f9f7e883a51
        },
        r1a0: u288 {
            limb0: 0x8e1acc4739964b8b107475d6,
            limb1: 0x14357cdd47afa7826040d702,
            limb2: 0x2932ad98782dba83
        },
        r1a1: u288 {
            limb0: 0x3bad921b36e9daf486e6d322,
            limb1: 0xa05571503e0000d171f086ac,
            limb2: 0x202122c60aaa1086
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
            limb0: 0x492f6d5bab953d73d4520fa1,
            limb1: 0x3d4519fabee1532723b4c4f4,
            limb2: 0x1b7fb18cb5ce9f45
        },
        r0a1: u288 {
            limb0: 0xe959cab6944f1e48c55ea85a,
            limb1: 0xb85b1c8b76297d34f40b195b,
            limb2: 0x2d67a710f5767612
        },
        r1a0: u288 {
            limb0: 0xc2e6f72d4200b92c4b7bfd1,
            limb1: 0xf46c768fd567ecea407f94b,
            limb2: 0x14c9efbf901a2c61
        },
        r1a1: u288 {
            limb0: 0x9b559d42f8f642eda17c02a7,
            limb1: 0xd4cc6c37dcdb7fd46d664491,
            limb2: 0xf86ec5805a460ca
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xe54d2a9fffa9efff45b7d1eb,
            limb1: 0xa741071b35a74371e0ed84b0,
            limb2: 0x445b54c93dce2f7
        },
        r0a1: u288 {
            limb0: 0x2a87261c850da09192c0915b,
            limb1: 0xe450520262e00f318abe4629,
            limb2: 0x20b76336f628584a
        },
        r1a0: u288 {
            limb0: 0xcbec65027df7ec07130e4ebd,
            limb1: 0xf3f21d0e8f0946043bb6bb01,
            limb2: 0x125514799ee5f3f0
        },
        r1a1: u288 {
            limb0: 0x813d223e2ac6debbf55d78e5,
            limb1: 0xeacb1f86bb9e9a6bc4fd0e6f,
            limb2: 0x28903b13f8d55cd9
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
            limb0: 0x802a649d9c8518a7a04b0521,
            limb1: 0x90ce363cb27299216d3e683e,
            limb2: 0x9ffeced3a2f9ee7
        },
        r0a1: u288 {
            limb0: 0xe6aa390897dfeed6cc93d9c8,
            limb1: 0x77595af5550387062befc2ef,
            limb2: 0x6bc7d3438a9a5dd
        },
        r1a0: u288 {
            limb0: 0x7b908c837618a9888ef8a9fe,
            limb1: 0x83403ecdb71d8047f5eec599,
            limb2: 0xf5ebc7d0aeac093
        },
        r1a1: u288 {
            limb0: 0xaabf9d57b1c840d5d194bc06,
            limb1: 0x7f2d234b501902d5945e2913,
            limb2: 0x27098d72f030519e
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x224ab4953f2646e38e57f3e,
            limb1: 0x8203b7a3090d9a38cda4f871,
            limb2: 0x2738c207365de78b
        },
        r0a1: u288 {
            limb0: 0x3bc2a8530667e8918dcbfccf,
            limb1: 0x6fd807007a36a1e42b194ccd,
            limb2: 0x10870a9dd76cad9f
        },
        r1a0: u288 {
            limb0: 0xeef0c91780d8854fdc98a89d,
            limb1: 0xb855dafa680e95f963ab248e,
            limb2: 0x163bba881033e73b
        },
        r1a1: u288 {
            limb0: 0x3e6d506d108d40276da8a,
            limb1: 0x804eb3155ef353f2fb0ea048,
            limb2: 0x25cb908edbdfc9bd
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
            limb0: 0x7764cb88f3ee620e14f7c6d8,
            limb1: 0x8263b6fa1a0aae1076d9a9f4,
            limb2: 0x8b532557c530e53
        },
        r0a1: u288 {
            limb0: 0xf46094ec834d972f739290c3,
            limb1: 0xb9819ee7d5e70977188f2242,
            limb2: 0x11cda7856edd2cfb
        },
        r1a0: u288 {
            limb0: 0xaf7aba46330b8af6868abde3,
            limb1: 0x9ae01e3ba10b7f9ace5d9c9b,
            limb2: 0x23dea570ce5f8e6
        },
        r1a1: u288 {
            limb0: 0xb28a5fafc69a56ea825c7a42,
            limb1: 0x49470a2928f86b8302c0f839,
            limb2: 0x26e7b8dfcf6938c3
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
            limb0: 0x80124579d7c3a859d18d1bf2,
            limb1: 0x5e927816726de240351745f7,
            limb2: 0x274e2c5ef562faa0
        },
        r0a1: u288 {
            limb0: 0xb2cc5c124be0e041c0fa01a5,
            limb1: 0x3472acad3f46ae7e6b734c68,
            limb2: 0x1eca38fd15aaf441
        },
        r1a0: u288 {
            limb0: 0xb3646b0a774e7fbf39ed35a1,
            limb1: 0xaf462bc241df5d346ad6399c,
            limb2: 0x2ffad3206f34525f
        },
        r1a1: u288 {
            limb0: 0x7534531427aa54732993f45a,
            limb1: 0x82bf084674446a2037febf00,
            limb2: 0x15441a0eee297ca6
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
            limb0: 0xba0a8d0a61c2ac2a5b6e5bd4,
            limb1: 0x2a17e9c20b6178e4f24672fd,
            limb2: 0x19c4699ac4a4772e
        },
        r0a1: u288 {
            limb0: 0xb40c41392a2bb992b432902,
            limb1: 0x97b9e496ff3fd44f87e6b7f1,
            limb2: 0xaf7d8ac5695aa9e
        },
        r1a0: u288 {
            limb0: 0xe2ee57c15ccc06c09f615159,
            limb1: 0x3c2893f8acca85cabcc9a1b7,
            limb2: 0x74c98693d6f1a8c
        },
        r1a1: u288 {
            limb0: 0x43627b736632bf161dcc663d,
            limb1: 0x51acdd2fa5ee07b7aa5d3065,
            limb2: 0x529f3b687e303ad
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x473710b04518693477c57b0,
            limb1: 0x7abfdfc076e97e7c753a25d5,
            limb2: 0x2109c6519ab93931
        },
        r0a1: u288 {
            limb0: 0xf5c1988f1de3e9b6396b6914,
            limb1: 0x2fb3c1086f639d1420f49930,
            limb2: 0x2d2f46730c01a8cb
        },
        r1a0: u288 {
            limb0: 0x2a9b876e9fa84c99b201a273,
            limb1: 0xed079938efc914ef224cd42,
            limb2: 0x1981077194a5f179
        },
        r1a1: u288 {
            limb0: 0x8c71dec2a2a13c84bf282f52,
            limb1: 0x756371343a757dfbf084731f,
            limb2: 0x1b7432195a112d3
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
            limb0: 0xca53ab8c5090f1c64b4a20cd,
            limb1: 0x31c19e57180d90c128ac2e08,
            limb2: 0x1c519249b6051e33
        },
        r0a1: u288 {
            limb0: 0x1e6fe6b590ef69ff3339f56f,
            limb1: 0x78518634570cd806734a239b,
            limb2: 0x294f2b4a53675ac4
        },
        r1a0: u288 {
            limb0: 0x52e5e23b833a05fc847f9659,
            limb1: 0xeb16adfa16fa8e04e03191a7,
            limb2: 0x7fabcc9351168a6
        },
        r1a1: u288 {
            limb0: 0x898e9b616ed15f21d8942f66,
            limb1: 0xc7b92c1a3033951b47d49ae9,
            limb2: 0xc68ef3058cb4ebb
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
            limb0: 0xe94723dc500590e6006fa801,
            limb1: 0x6baa153917d44ea0c023aa22,
            limb2: 0xfe628d6b3a2fe9f
        },
        r0a1: u288 {
            limb0: 0x9bf94b168311c477726732e9,
            limb1: 0x95499fa3b3dd52a4e23d8d20,
            limb2: 0xb5881c8ec3ea542
        },
        r1a0: u288 {
            limb0: 0x51d079bb55ae8ccfd2a6af4d,
            limb1: 0x321e413e7ec83041ec5e028d,
            limb2: 0x269c24e6b2a2e781
        },
        r1a1: u288 {
            limb0: 0xbf151a3078a1af110417ba4f,
            limb1: 0xf1be90c773ec596bb29c882a,
            limb2: 0x19153326121f7a35
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
            limb0: 0x171394446f12735150f3df,
            limb1: 0xb273280dcc57f82ab98d4c53,
            limb2: 0x9b14cfdc31045f1
        },
        r0a1: u288 {
            limb0: 0xe98a6a58180d243618f45739,
            limb1: 0xda644710342bbaf63c784ee7,
            limb2: 0x68d533d20356ee7
        },
        r1a0: u288 {
            limb0: 0xcfc2dceb1cb7e92eb0967495,
            limb1: 0xfc17df9731ff5665c90b2901,
            limb2: 0xf62315a2130276
        },
        r1a1: u288 {
            limb0: 0x62ead3bce5b7baf7a74a2c2f,
            limb1: 0xf450e9e5cbb9e0fa3764b81e,
            limb2: 0x16afbaece2fd7ef6
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
            limb0: 0x6a2db02a84cdbf234562b0d1,
            limb1: 0x668e75c102f07dc846ed7bce,
            limb2: 0xef6e2160e49719d
        },
        r0a1: u288 {
            limb0: 0x5ef8f6f25907b6e8ada8fe3,
            limb1: 0x6bcec6bb022828cc0e3baf4,
            limb2: 0x24e52a22186bf34c
        },
        r1a0: u288 {
            limb0: 0xb65dcd2fe03fd4aa43ca78ef,
            limb1: 0xa69d21bc7947cf89b2f4497,
            limb2: 0x27e490e841c856c9
        },
        r1a1: u288 {
            limb0: 0xd0bb96672aec82b40b410f4f,
            limb1: 0x12878e98d3d99b0adb3b4895,
            limb2: 0x27c8c939135da4c7
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
            limb0: 0x8500495b1228fe60cff20d10,
            limb1: 0x375affe8b4d0f2cb26961c26,
            limb2: 0x108d29bd4c863eac
        },
        r0a1: u288 {
            limb0: 0xedb7ece5cddb858981e1d861,
            limb1: 0x1cce41c2e7ca099384ef33df,
            limb2: 0x20ab92cf2be28858
        },
        r1a0: u288 {
            limb0: 0x867de7319f8401459ae4b487,
            limb1: 0x963f57451e36c7a1b4566536,
            limb2: 0x19b885e209f3cc66
        },
        r1a1: u288 {
            limb0: 0xfc9b1f02e9fab19d002e070b,
            limb1: 0x8cd006083ca15cc774f8dec2,
            limb2: 0x26e15b182768b905
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
            limb0: 0x8dfc65dc49b08a4295453351,
            limb1: 0xbc0e44d09041a65691fd3f1,
            limb2: 0x94c3dcd2860e5e
        },
        r0a1: u288 {
            limb0: 0xe4edb2b3ca113d63abc0180,
            limb1: 0xe20dd948aa99c593677ce0ac,
            limb2: 0x130e675bf4ac4ebf
        },
        r1a0: u288 {
            limb0: 0x4ac95f0e797a98f9d3b1c55a,
            limb1: 0x6dd3b9872d225b5d6952c722,
            limb2: 0x93c0ef5b106cd5f
        },
        r1a1: u288 {
            limb0: 0x4079462a7551ebd82a5e589c,
            limb1: 0xf0ee82da0debf3c06421af69,
            limb2: 0x20ee24a8572e97d5
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x4a88ec2fba7e2d856c2292bc,
            limb1: 0x65681ba58fe1eae03686ff4,
            limb2: 0x48ded3b00ea6cfc
        },
        r0a1: u288 {
            limb0: 0x33c2ab9320758b87254eafd4,
            limb1: 0x737e29e45d546a32ef5ad807,
            limb2: 0x286f8580a84ff00a
        },
        r1a0: u288 {
            limb0: 0x8d5432244496c4aa70226fc2,
            limb1: 0x879175d504ce3c3910a2fb2,
            limb2: 0xf4cb85513a40ed0
        },
        r1a1: u288 {
            limb0: 0x65f6d7571961ad9ba68ba874,
            limb1: 0x56574031222d1b58c5eb6be2,
            limb2: 0x9be9eedba11ac6c
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
            limb0: 0x86aa5a4a8c2c878191ed732b,
            limb1: 0xd53b46cb1abd532b504db0f1,
            limb2: 0x471e2a10baaede6
        },
        r0a1: u288 {
            limb0: 0x9dd04e3d79004e7b2227962d,
            limb1: 0x7c13ab7806c6b186eca889c1,
            limb2: 0x14b8e4e59a39cde
        },
        r1a0: u288 {
            limb0: 0x877b30aea11025d98b2b54b5,
            limb1: 0x33609024d3ec2b172c5ef98d,
            limb2: 0x11826d832e77fceb
        },
        r1a1: u288 {
            limb0: 0xa673ef25fded042a658074a3,
            limb1: 0xe4fd050a8055003081711e71,
            limb2: 0x17a37b332ac4af7e
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
            limb0: 0x4a4af755799757a30f6b7d6c,
            limb1: 0xdcf25913fbb0f8f31bfe2d,
            limb2: 0x17be59b49543e1ad
        },
        r0a1: u288 {
            limb0: 0x9c81f0bbb3d6086aee43d620,
            limb1: 0xb49c7c65b8d3a488dc719f3a,
            limb2: 0x217f0c06af9571b4
        },
        r1a0: u288 {
            limb0: 0x795a144be384c81df58a45b5,
            limb1: 0xfda8c3dbe36bd1804c7b1a7a,
            limb2: 0x1a06798a99d78d93
        },
        r1a1: u288 {
            limb0: 0xd7b8d1c74cda58b9660ba0d5,
            limb1: 0xa8e66770f785c63d9ce67939,
            limb2: 0x2721608bbfd33ebd
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
            limb0: 0xc317a438f5b1d848c15dbcd0,
            limb1: 0xd877fe453eacde164f0b0a2d,
            limb2: 0x51736e0b2faa2f
        },
        r0a1: u288 {
            limb0: 0x41149f2f6db90fdd4ccb2d6b,
            limb1: 0x9e1c5a0c99ef8a5ade5ec05c,
            limb2: 0x1e2a78efa3228ae0
        },
        r1a0: u288 {
            limb0: 0x5250e17e4a49488afe0f616e,
            limb1: 0x87621bba729c2ee93d755809,
            limb2: 0x1591b50534ebee8f
        },
        r1a1: u288 {
            limb0: 0x69bba70d975348f0c173415,
            limb1: 0xe6cf9250b08081e96a09e45b,
            limb2: 0x6e93e9791dde09f
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x49eebe6dae9ef423b8919228,
            limb1: 0x5c7ca248459f73492fd23670,
            limb2: 0x1396ca67c4268305
        },
        r0a1: u288 {
            limb0: 0x6379c428ed239da74fbf38a9,
            limb1: 0x6295cbc671b41ba1bce7cbd1,
            limb2: 0x2fc31743ff2fdaac
        },
        r1a0: u288 {
            limb0: 0xeddbcf8ca38643aa2c28e7a4,
            limb1: 0x5e16185c9e67ddbbcdb465ba,
            limb2: 0x200ac3ea5eb415ad
        },
        r1a1: u288 {
            limb0: 0xe82b4eab2675f0088ad7909b,
            limb1: 0x20352d78712e9ff33c867767,
            limb2: 0x1291ff09fa992008
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
            limb0: 0x28a63b421d56a212c7da5ac2,
            limb1: 0x9c6a32af22763c9a5656ed10,
            limb2: 0x1a720fcc365e3979
        },
        r0a1: u288 {
            limb0: 0x3cf517481f3aa8e07092bbcd,
            limb1: 0xc88b2010bdb5fe51a7b4ae76,
            limb2: 0x23060d22c0703e1e
        },
        r1a0: u288 {
            limb0: 0x828304eae18c62cbc0c14369,
            limb1: 0x73980f8f73287409534a83ed,
            limb2: 0x4a082381875152e
        },
        r1a1: u288 {
            limb0: 0x30c2f43c5430edbc9476f65f,
            limb1: 0xae6a9c9afc50a59aae2f3c45,
            limb2: 0x14e7b37bf038248b
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
            limb0: 0xaebddeb50edf89ce96b4b6c9,
            limb1: 0x295d0a904ee74bcb4f8ed43d,
            limb2: 0xfc3a07a220f2364
        },
        r0a1: u288 {
            limb0: 0xb26ba5bd08dd690cf69ee8e6,
            limb1: 0x7f7db78ea9d5858eb1be6903,
            limb2: 0xcf3515e051ee4e2
        },
        r1a0: u288 {
            limb0: 0x686f59443b25cdea8b9262a2,
            limb1: 0x9f8ea9d2fb0bf78f36136f4e,
            limb2: 0xfd9d439aae7387d
        },
        r1a1: u288 {
            limb0: 0xe1f23ae0cd610ad08b443958,
            limb1: 0x7c58d92e596509e6b8ab94a2,
            limb2: 0x27906162eb404f2c
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x7586a96ddacfe71d48f29194,
            limb1: 0xc6844486cf57693250ba1ad1,
            limb2: 0x38be47da6188878
        },
        r0a1: u288 {
            limb0: 0x5490510317837c88f2fb459c,
            limb1: 0x650658cdb6c210908f97fd9b,
            limb2: 0x17e7ed7c30051231
        },
        r1a0: u288 {
            limb0: 0xd797457e260e442d7f56ed99,
            limb1: 0xd6a9c8c2e7fafbc0df57b949,
            limb2: 0x16f4cd22117af4f9
        },
        r1a1: u288 {
            limb0: 0xef07c68b824f0303f1d84826,
            limb1: 0xecd1d48805ab41ca007acf48,
            limb2: 0x1caeaa32344cad89
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
            limb0: 0x9cba5ebb46b6d42db2c8fa1f,
            limb1: 0xd11908f9f5a09dff94ca6df5,
            limb2: 0x9b5022d11d053a8
        },
        r0a1: u288 {
            limb0: 0xbaa425e72acfa889bb2daee2,
            limb1: 0x98e93b11813ee09c7f2c2012,
            limb2: 0x1eb8e2e2e26519ad
        },
        r1a0: u288 {
            limb0: 0x991bdd59c4988b52f9fc9bc1,
            limb1: 0xc9d0ffd2d71c2fbcbf8894dc,
            limb2: 0x2917b618eb35abd5
        },
        r1a1: u288 {
            limb0: 0xfe7844b1f1a92fa8f192166c,
            limb1: 0xc5c8258e177681f90de8b514,
            limb2: 0xdb78c3fdf7ea04c
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
            limb0: 0xa9c289bbc27a4ec5b883274f,
            limb1: 0xe858499671212341d703c647,
            limb2: 0x9860dfbede83fc5
        },
        r0a1: u288 {
            limb0: 0xcd1acb689d4fdd14b67c9bc9,
            limb1: 0xaab9e880a57faa2ec089d4e9,
            limb2: 0x2aafd7d7d1eb1e52
        },
        r1a0: u288 {
            limb0: 0x8cb8f93d3bdd38096b3cbc6,
            limb1: 0xfd5df90372794a8f9afcab0a,
            limb2: 0x218f28d843a7c49b
        },
        r1a1: u288 {
            limb0: 0xd229e68128c866a479d4465,
            limb1: 0xe623ef49cec4fba39fec710c,
            limb2: 0x338a4e13605fe
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
            limb0: 0x94128d704e886f3eed8f3286,
            limb1: 0xdb88bcf80cddf0abc50258de,
            limb2: 0x21b24ce8d30179ec
        },
        r0a1: u288 {
            limb0: 0xa78f911590f28455277526a5,
            limb1: 0x38446af838034147d6fab9a5,
            limb2: 0x845af60736d9ca4
        },
        r1a0: u288 {
            limb0: 0x3f23e0e5013f7b94763e68e9,
            limb1: 0x6e2948d1f70610ecc8f13dbc,
            limb2: 0x13cb4fe247706c0e
        },
        r1a1: u288 {
            limb0: 0x11a8c539b43f457bc66c4d28,
            limb1: 0xed46b2eed06d81884c09e534,
            limb2: 0xeaa4adeafca216e
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x7cf5278f4a1a92e54d40314d,
            limb1: 0x7ecbc0f44c729d11624c63d7,
            limb2: 0x1b94d89a108deb6f
        },
        r0a1: u288 {
            limb0: 0xf018b389f1315055243d58ea,
            limb1: 0x58c8f086073c0aaa7205467f,
            limb2: 0x19e46bfde36a3caa
        },
        r1a0: u288 {
            limb0: 0xfe9616a91e8bf5ecaa98ddec,
            limb1: 0x161d243805022b187f69af1f,
            limb2: 0x19e22c760300b9e6
        },
        r1a1: u288 {
            limb0: 0xf2bbf9da177a8feb51e60de6,
            limb1: 0x480d9288d654775458bcabf8,
            limb2: 0x9d6f531ed47462b
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
            limb0: 0x33c9aeb7de2b848f8d960b96,
            limb1: 0x6d61f900f28da9c5741a4202,
            limb2: 0x11485e08a14086b1
        },
        r0a1: u288 {
            limb0: 0xc9e41823fe4f171d73d8c13e,
            limb1: 0x2d2a4ab6466538ac9a4e1548,
            limb2: 0xbb05b10df478161
        },
        r1a0: u288 {
            limb0: 0x8f15508219c40554ae3c0778,
            limb1: 0x95d8ff4115b7e6aad16e2f56,
            limb2: 0x19c40d185d1df900
        },
        r1a1: u288 {
            limb0: 0x5cfa590960cbfba991b68e75,
            limb1: 0xcf823ee7056f2c34b4d88bb5,
            limb2: 0x42b46d7578ee4d9
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
            limb0: 0x50b044c139310c96ee472c06,
            limb1: 0x7afed97cbe5ec6023884c5ca,
            limb2: 0x10b392f356e54411
        },
        r0a1: u288 {
            limb0: 0x3dbc01321e8790ff3ab79d2b,
            limb1: 0x4b06e03cedccde13626ae66e,
            limb2: 0x1efeef6d6fe55bd0
        },
        r1a0: u288 {
            limb0: 0xbb55b7106eabd8b7e1b37b9a,
            limb1: 0x4a5cb2c715bb896988f5fb4a,
            limb2: 0x19762a2d64f046b3
        },
        r1a1: u288 {
            limb0: 0x69c261da8469e24276b7e937,
            limb1: 0xa367c51891bf480a30388337,
            limb2: 0x2d79597dacaaea22
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
            limb0: 0xd6b0345fcc24da16b2556b3f,
            limb1: 0x74747cd33b9e55963fa99be6,
            limb2: 0x23f415a9844dad77
        },
        r0a1: u288 {
            limb0: 0xafa426da1ee58e9e15df397f,
            limb1: 0x5735826fa678f865636f908d,
            limb2: 0x1db8a15bda0eead6
        },
        r1a0: u288 {
            limb0: 0x70f4886de93d9419eea6a1ac,
            limb1: 0xbecffd22558ecdea837b2a82,
            limb2: 0x22d0527f206cc88d
        },
        r1a1: u288 {
            limb0: 0x78d36564ecb3c818d2d999cb,
            limb1: 0x29acef21424900b4d3c5d08a,
            limb2: 0x14727746494e2a16
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
            limb0: 0xd4f704f0796250435b8ecc1d,
            limb1: 0xb381777e2af2ded5221f59e2,
            limb2: 0x2de36a19dac3037c
        },
        r0a1: u288 {
            limb0: 0x2000bb8b2f2a224c1103e201,
            limb1: 0x5e21516de14d4f6cbf4d3fc2,
            limb2: 0x12e9a7336089afa9
        },
        r1a0: u288 {
            limb0: 0x977a5d9595e8603a04ba1d68,
            limb1: 0xf4263db24a06db8d605b2be,
            limb2: 0x1b20735fb01aee63
        },
        r1a1: u288 {
            limb0: 0xf07bc8b527f26193fe34ba5f,
            limb1: 0x8d0b1119a3ed9a3abb97fe43,
            limb2: 0x28008a6eaee0878c
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
            limb0: 0xad3abe69b7df50b434eb0ed8,
            limb1: 0xfc1cf226a12ce3d14e246513,
            limb2: 0x77bc7b76128c0ca
        },
        r0a1: u288 {
            limb0: 0x546b9e9caf9dc685feebd769,
            limb1: 0x79ecb939a480d99c882d2d7d,
            limb2: 0x372c097c62b7397
        },
        r1a0: u288 {
            limb0: 0xfd899b9c403b5f593147a016,
            limb1: 0xee0bdab86940cefa2ba772f9,
            limb2: 0x299d8340a4a92a19
        },
        r1a1: u288 {
            limb0: 0xe0e8e21f55e8bdb29c18bb22,
            limb1: 0xdbe075bf253cc99b1386e124,
            limb2: 0x1146e024fbae8c23
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xd24443975cea860bc32f90f1,
            limb1: 0x8091a5974d3adf59c30407c3,
            limb2: 0x132e369b50097c2b
        },
        r0a1: u288 {
            limb0: 0xa169a9481830bf42dadc894a,
            limb1: 0xbbb6d6560ce12edeedba7d2c,
            limb2: 0x11ab94fb3a816f6a
        },
        r1a0: u288 {
            limb0: 0x48a6fa19bc142a446ba4bccb,
            limb1: 0xfd4770503882738ba0f03789,
            limb2: 0x1ee4b587d6903ad2
        },
        r1a1: u288 {
            limb0: 0xd4256b5aa517c6f7fa8329f4,
            limb1: 0xdaf6e8786061c96003c1bbdb,
            limb2: 0x7d3847223507260
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
            limb0: 0x508840d954cbaab012a74ce0,
            limb1: 0x23852b7a64ec1a49293dce92,
            limb2: 0x1eda1261b52b4bb0
        },
        r0a1: u288 {
            limb0: 0xf027bf12eed3e90aec671421,
            limb1: 0x66333c7554f1bad652c6a722,
            limb2: 0x26471c0799282a55
        },
        r1a0: u288 {
            limb0: 0x30e107484e8c7f6ebe8908be,
            limb1: 0xfe91cf7248c917cff5b8beb3,
            limb2: 0x1b30c5439be781b0
        },
        r1a1: u288 {
            limb0: 0xe8df032a3f0002bee1acd675,
            limb1: 0xb138f7e64f01d9b9cb838eef,
            limb2: 0x21a1e43588f282fa
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
            limb0: 0x3196747f1d2166fdc0249a8c,
            limb1: 0xc1827e8fe00f9437c257120a,
            limb2: 0x26e324325d537b22
        },
        r0a1: u288 {
            limb0: 0x6203cf9e018e1910f0d7d627,
            limb1: 0xa487615d91f9ff77d1ca6a3b,
            limb2: 0x263ddac55f827902
        },
        r1a0: u288 {
            limb0: 0x9b31859cbc5569410a1f19eb,
            limb1: 0x7bbfa1147512d4d7b553c4b7,
            limb2: 0x2012f2f5659c4b03
        },
        r1a1: u288 {
            limb0: 0x9746e8904bfd89479a198afd,
            limb1: 0x9f3f145597a5a88d7d9167fb,
            limb2: 0x2a0b88d7e9a623b7
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x68c8d1779691d81d90edf072,
            limb1: 0x6b236d9fd153f55dbf58e98c,
            limb2: 0x7993f04c1d206ec
        },
        r0a1: u288 {
            limb0: 0xc906d2af946d1f6b519b7e8,
            limb1: 0x903edaa368d4ef23ac38a0c6,
            limb2: 0x24cda8efde8faf4c
        },
        r1a0: u288 {
            limb0: 0xc567df0450603205f0e17c32,
            limb1: 0xd9ca17113e965c606079a5d,
            limb2: 0x23f042d66de8cc7c
        },
        r1a1: u288 {
            limb0: 0x7b21fb5fd041caeda8bf4e73,
            limb1: 0x73fa4b942398498ad3db3b31,
            limb2: 0x2e194767bbec3c2d
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
            limb0: 0x7842e2a3d65b7dffa1148646,
            limb1: 0x12314d8646b3d8f921b4c0e7,
            limb2: 0x20b216b7409a07e0
        },
        r0a1: u288 {
            limb0: 0xca02870496012566e26a5747,
            limb1: 0x88ce9ea8fd1952b9a0d8bb22,
            limb2: 0x16591e4baf0da497
        },
        r1a0: u288 {
            limb0: 0x432cdd2f11fb741bd3c3b86c,
            limb1: 0xb071c3811340cbad704615c0,
            limb2: 0x1d5880bd6637258
        },
        r1a1: u288 {
            limb0: 0x186a9fb0f581994be4dd0436,
            limb1: 0x6001acf7f423d976b952c00a,
            limb2: 0x22c0d51b43ce9f63
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
            limb0: 0xd188aa2c400a27f11ee554a,
            limb1: 0x89900f98788142c4cda2d918,
            limb2: 0x356a51558524e54
        },
        r0a1: u288 {
            limb0: 0xb7d11d2f0197b28a5aec4aae,
            limb1: 0x14bfa2cdf931f95303f5859e,
            limb2: 0x3029d5e04f62a38d
        },
        r1a0: u288 {
            limb0: 0x74fedecf304071c8964c2c4b,
            limb1: 0x9a2143cdc042c00b0a1943b6,
            limb2: 0x9cf5d5c29185dc6
        },
        r1a1: u288 {
            limb0: 0x9c6ae90c4a3c307344defb5e,
            limb1: 0xd458d57371947d25cbf3a9ee,
            limb2: 0x838c0156b77fa4f
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
            limb0: 0x35c94449fc6fa2297f316efb,
            limb1: 0x26f1e7b267460a3cf83fee04,
            limb2: 0x17c29d4ea4731213
        },
        r0a1: u288 {
            limb0: 0x78141504ff2e2183292bd5d7,
            limb1: 0x369949b906d7dc1e8a16ba9c,
            limb2: 0xaf44fbbb20f00c0
        },
        r1a0: u288 {
            limb0: 0x81ea6e47e6fc2a6be53925a1,
            limb1: 0x91350b81ded12d9ec50de9bf,
            limb2: 0x1788f72af3132d33
        },
        r1a1: u288 {
            limb0: 0x775b3969548e262b1b3fbeda,
            limb1: 0x7bf1274c71232fa504ca2153,
            limb2: 0x2e277349340c0d66
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
            limb0: 0x7be58a2296687ca9a39c70db,
            limb1: 0x29091c1c23ee94f27c99f457,
            limb2: 0x27cbf87046510d4c
        },
        r0a1: u288 {
            limb0: 0x19fddf905189bdfc381df073,
            limb1: 0x8cba459db370ea0dfc958d96,
            limb2: 0x271c0a489046e37d
        },
        r1a0: u288 {
            limb0: 0x1d7bf83a32a537a8ca836a9f,
            limb1: 0xc84f09d243c1e83451856daf,
            limb2: 0x1741e32bd2ab4450
        },
        r1a1: u288 {
            limb0: 0x732052bb01efb8c222d89609,
            limb1: 0xa6f2ed3e3defe77d856dae96,
            limb2: 0x2e1f2fdc0432445d
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x722a0184fe1f3fe76a4a1b7f,
            limb1: 0x364ba4826c5234e20d4295f8,
            limb2: 0xb486b30ab7754b7
        },
        r0a1: u288 {
            limb0: 0x43b8d68690e28ad4929f7c0f,
            limb1: 0xde578e1f70449c21fa367ce,
            limb2: 0x73e1862323ec00a
        },
        r1a0: u288 {
            limb0: 0x56ce5d6acd3e7ab9665017a7,
            limb1: 0xd91547606ff7e85c01bfafe8,
            limb2: 0x1c12757520446575
        },
        r1a1: u288 {
            limb0: 0xbc0a87a8f679a66a02ea5fa9,
            limb1: 0xbdd6307d46127d3fdbcda52,
            limb2: 0x18ce038b95bb275b
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
            limb0: 0xf26a77af2185bf79657b72a1,
            limb1: 0xdfd68fc20f6ef47ff166f471,
            limb2: 0x1973161850f03eb
        },
        r0a1: u288 {
            limb0: 0x377c01b140cf00117c7df42a,
            limb1: 0x7c1a2328301b8fbecf12f0b9,
            limb2: 0x57edba79ca1bf35
        },
        r1a0: u288 {
            limb0: 0x3c2a2f6d4a7a52782550b41d,
            limb1: 0x41b871464081f4f0fe7c5d1d,
            limb2: 0x2e042760a988fe05
        },
        r1a1: u288 {
            limb0: 0x35565adca038204a85883ee3,
            limb1: 0xcf9e95d94ea841050111f50e,
            limb2: 0xd9eb7f81fc539ba
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
            limb0: 0x42060deddc53cb200c2d24ac,
            limb1: 0x1bb5d617b51364d0076b109a,
            limb2: 0x27643482387e571b
        },
        r0a1: u288 {
            limb0: 0xd62cec2b851f75fab84b1b35,
            limb1: 0x857353a308f12fbd09387c80,
            limb2: 0x778192eba099a40
        },
        r1a0: u288 {
            limb0: 0x7bf495417790944ffeaf760e,
            limb1: 0xe8eae4deef52be422a949265,
            limb2: 0x14f72630e4e2d06f
        },
        r1a1: u288 {
            limb0: 0xda4a96b6983e76eb9f90648,
            limb1: 0x3ac50c68359821a2549fefab,
            limb2: 0xe8e22c017be82d
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x3cc7d8733250449a999af2ea,
            limb1: 0xdd2be26b817cb96c00db44e0,
            limb2: 0x1e2bf06af162a6c
        },
        r0a1: u288 {
            limb0: 0x4de552ea13ea5305297d83b9,
            limb1: 0xc1906cc0a8409b06ed88f07c,
            limb2: 0x2195f8155e959690
        },
        r1a0: u288 {
            limb0: 0x2222b808e4ac523416c40a6b,
            limb1: 0xb2ebf8c6f855aca8dcae1fa6,
            limb2: 0x29940e5002cd527
        },
        r1a1: u288 {
            limb0: 0x869d56598aaf163ba49def79,
            limb1: 0x59ce38489f816ec891b50e1b,
            limb2: 0x2d4e75c4404e6a31
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
            limb0: 0x93ef6c63e6ffd1625fac9ab2,
            limb1: 0xcf082f2f6c5b6943ef702fc8,
            limb2: 0x2163b4081745cd22
        },
        r0a1: u288 {
            limb0: 0x2f0989d336373873bedb731f,
            limb1: 0x20e235ca152932689de1f4ed,
            limb2: 0x1ddb7090cb76b19e
        },
        r1a0: u288 {
            limb0: 0xc851b1a9c982254d1c21730a,
            limb1: 0x65930fa25d618c910f84224f,
            limb2: 0x1d25095273f63fbc
        },
        r1a1: u288 {
            limb0: 0x779683a90ebaaba40a311ac8,
            limb1: 0xf281946c5e567ab5944bde,
            limb2: 0x17a1e3f0d7ce30b5
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
            limb0: 0x49e1b5616620afbda27dad6f,
            limb1: 0x1ba3c961e774b287dc5d771,
            limb2: 0x1bfdb3ec069034fa
        },
        r0a1: u288 {
            limb0: 0x30bb58d68497f9f947385a56,
            limb1: 0x3df4d6fa4231f19be9d9e826,
            limb2: 0x1b57421c9a9d8049
        },
        r1a0: u288 {
            limb0: 0xc55ae0613902a60e739975e2,
            limb1: 0xbccf60cdc86977b6542f116b,
            limb2: 0x1ce01351533774ee
        },
        r1a1: u288 {
            limb0: 0xd58fe9218210f661572ff101,
            limb1: 0xc4fb219c2403f34123e064b9,
            limb2: 0xdb5e22f3f9412e3
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
            limb0: 0xfc1a0ab02f118ce5e4b21f29,
            limb1: 0x911c4c10ee7eeb0199254267,
            limb2: 0x3bad108558e625b
        },
        r0a1: u288 {
            limb0: 0x346d0f1aaedd57e3603cecce,
            limb1: 0xb8f75d695dca475a328b802f,
            limb2: 0x1424d688a96572ee
        },
        r1a0: u288 {
            limb0: 0xb6967b622abb909c04560b97,
            limb1: 0xb236cfc350683d8b19c9147d,
            limb2: 0x113fe7cafbeb7a26
        },
        r1a1: u288 {
            limb0: 0x15df9f3a6565c226520e06b9,
            limb1: 0x2882f61a70808e28a28b8786,
            limb2: 0x25e06843ac19eeee
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x9c8c5bcd4d37b60f5dac3212,
            limb1: 0xdae38915f6f46a4f3f2900fc,
            limb2: 0x18cdda0985704146
        },
        r0a1: u288 {
            limb0: 0x9deab7f474bca6248e2af086,
            limb1: 0x42977681b778bff8338eee2b,
            limb2: 0x44f7bc7852eb17a
        },
        r1a0: u288 {
            limb0: 0x2cc31df356c3b343954f5c8e,
            limb1: 0xaec84c25697677db3abef5ff,
            limb2: 0x1f64b0f086ddf31a
        },
        r1a1: u288 {
            limb0: 0xbe459e65786b7b8efcd02811,
            limb1: 0xb79cfeca8276f348108b1f7f,
            limb2: 0x20ba586f34f0f0e2
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
            limb0: 0x16074fd6c2cbae6b8e6fa8d0,
            limb1: 0xfa538baf6865e0037c92e9c4,
            limb2: 0x1212149ccf5b1f37
        },
        r0a1: u288 {
            limb0: 0x814044c1f6af14f062dc3e14,
            limb1: 0x7858f637b45c0a6741b9a93b,
            limb2: 0x95cdb1c11394208
        },
        r1a0: u288 {
            limb0: 0x1a31afb52d0ab7fd8a367526,
            limb1: 0xfffa319b4e2c65b501760e88,
            limb2: 0x12dd6a5d924c76
        },
        r1a1: u288 {
            limb0: 0xf60ae63d69b3246816aebbdd,
            limb1: 0xea7746a91cc58558fe4a801b,
            limb2: 0x23b83ddbffa5e604
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
            limb0: 0x7953494129cce6d98950c944,
            limb1: 0xfe8b5b510f04db8efb972db,
            limb2: 0x2d668c480e27f865
        },
        r0a1: u288 {
            limb0: 0x22ecf57ae6fca5d51b5d6818,
            limb1: 0x533ee2c541001c624d4a5a6,
            limb2: 0x1ce918576a316b3f
        },
        r1a0: u288 {
            limb0: 0x1521ea3d64accd3fe15ef0e6,
            limb1: 0x12dcfffb16fb8abf2347f654,
            limb2: 0x9d476d424173994
        },
        r1a1: u288 {
            limb0: 0x2782a75c26620b2136f6412,
            limb1: 0xdb6c9c5e04cf490a765da648,
            limb2: 0x107bc41b8caf8c21
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
            limb0: 0xa89194e02d6d1c355d2ce9d9,
            limb1: 0x86874a56036cd5e3148ff5f5,
            limb2: 0x25d7d4f070d2e21b
        },
        r0a1: u288 {
            limb0: 0x61cf484b3b66c1fc4d364a37,
            limb1: 0x40700689890930a3e372981,
            limb2: 0x178c267f8ed6c59a
        },
        r1a0: u288 {
            limb0: 0x63b511b365923f2eedaeaac4,
            limb1: 0x3b99fd69343418e79f3824fb,
            limb2: 0x16dbde57e862aeb1
        },
        r1a1: u288 {
            limb0: 0xdbb1c767a556b87a1bf9bd6d,
            limb1: 0xabc71a4066913c884501694,
            limb2: 0x16a58ac3e3b9c13f
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
            limb0: 0x728923e060a7ad0300bfca62,
            limb1: 0xdc63d4f8db179953dd59de1c,
            limb2: 0xcd227a7cffbed43
        },
        r0a1: u288 {
            limb0: 0x971fcdd1660f0e8a98c0b64d,
            limb1: 0xc127f19b779745e406ece89b,
            limb2: 0xfb67567300fce9f
        },
        r1a0: u288 {
            limb0: 0x88833b724971ca99866559af,
            limb1: 0xa4f58a08fac619031bd19fc6,
            limb2: 0x3bdb6d75f2f90c7
        },
        r1a1: u288 {
            limb0: 0x4584b6136829aee5173ef41d,
            limb1: 0x9446bc2aa1dd52288c7dff15,
            limb2: 0x2ae1593c2563f2da
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x3c40a8f6b4ba18064fde357d,
            limb1: 0x9243f417137bd5055fbc8a4b,
            limb2: 0x2bb962e163504b8a
        },
        r0a1: u288 {
            limb0: 0x8168bd0a991d7b4e56d6d7b1,
            limb1: 0x1c67490f41da325b3d16b1de,
            limb2: 0x2946c6207d9190f
        },
        r1a0: u288 {
            limb0: 0x899a60e816cfc2a631a95bcc,
            limb1: 0xffa5c93cbffce2ebe09e1f94,
            limb2: 0x1345a29b6d3c03d6
        },
        r1a1: u288 {
            limb0: 0x89283250277d76f6e1f0d3d3,
            limb1: 0x909a016dc76667a787ded26b,
            limb2: 0x2fa9b0af60be4698
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
            limb0: 0xc6c7063ee6fbfa7bed06915d,
            limb1: 0xc22cc9e879eb25d4cd0ae871,
            limb2: 0x12ec97d09e9aeeaf
        },
        r0a1: u288 {
            limb0: 0xe5edf28f9225ee919947329c,
            limb1: 0x3f1a47f50ca078c1cf68c430,
            limb2: 0x2b68ce0173635e85
        },
        r1a0: u288 {
            limb0: 0x423a8ac93ce2160a551eb90e,
            limb1: 0xf9dcc5db9e53942a7c428915,
            limb2: 0x7fcf0f734f0727b
        },
        r1a1: u288 {
            limb0: 0xb04209002ef6082d97e03161,
            limb1: 0x990b682aca1a4ca35f6b7e4d,
            limb2: 0x2e1c4145a6d08146
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
            limb0: 0x4a3d69eb0ff2154318a887aa,
            limb1: 0x5bcd204b5811f63fbdd1345f,
            limb2: 0x1bb34c247fd77a16
        },
        r0a1: u288 {
            limb0: 0x1c80056c05c48828a3dbc2eb,
            limb1: 0x7809062cfe29b431b00d4ba2,
            limb2: 0x2a0cb00e9cbd6e1
        },
        r1a0: u288 {
            limb0: 0xe668c6e3d31594dfc1dff4fb,
            limb1: 0x8ea501862ecaa53320441c06,
            limb2: 0x17aa46c29da21804
        },
        r1a1: u288 {
            limb0: 0xa72e088da5b10cf0be86ddcd,
            limb1: 0x217e7f186d5d1cba613cc038,
            limb2: 0x210a5d69eefd3f21
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
            limb0: 0x5740b255a5ce1496d7788b37,
            limb1: 0xbcc4d6ecbb36cf9678183f70,
            limb2: 0x183bdb9df578ffb9
        },
        r0a1: u288 {
            limb0: 0xd0874d4c05db94a02635cc0c,
            limb1: 0xb2cbc5892a3187765f814f6d,
            limb2: 0x1e78de896d3e58b1
        },
        r1a0: u288 {
            limb0: 0xf02a723436d8efa8f04f40a,
            limb1: 0x4bf09c07f10fc2415fe68979,
            limb2: 0x11947265aa2e321f
        },
        r1a1: u288 {
            limb0: 0x586699a6b6227e578efacbb6,
            limb1: 0x9fb741e84a50491406c4c623,
            limb2: 0x11a3dd4f723fdbd1
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
            limb0: 0x178decd4d06cd1ba6b98537c,
            limb1: 0x44460bbb92b6bdc7622fd773,
            limb2: 0x134af41ec972b137
        },
        r0a1: u288 {
            limb0: 0xebdd4f2648e20259a377ba40,
            limb1: 0x274254efe5463cc3d92ddac2,
            limb2: 0x168b82096387274c
        },
        r1a0: u288 {
            limb0: 0x3f47aaac7a3a3af2576e637a,
            limb1: 0x997422e6b0ee49b519d5dd3f,
            limb2: 0x12695e223311ca39
        },
        r1a1: u288 {
            limb0: 0xe99328a919e993a6f8b774c7,
            limb1: 0xfdf3f793e2401082bd1b1100,
            limb2: 0x30112233fa51c057
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x7a5132fa5e5db1c601be6950,
            limb1: 0x2c22b9a1a17eef462d700e19,
            limb2: 0x12f97ccdf15b4093
        },
        r0a1: u288 {
            limb0: 0x302b71c73a8fc339dcf3171e,
            limb1: 0x770580cc79babb2fc62c8af9,
            limb2: 0x29e720ebd35456c
        },
        r1a0: u288 {
            limb0: 0xbd2fa7bde427766a1c1610e0,
            limb1: 0x1b03f0c2cd417d2078c31c02,
            limb2: 0xd3eda6cb2d67b14
        },
        r1a1: u288 {
            limb0: 0x5619d21f29267cc7a376029e,
            limb1: 0xa78e98e5d9597df6d1313d85,
            limb2: 0x10c4b2989fdb6661
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
            limb0: 0x85caf8b37faff5df755e1405,
            limb1: 0x880900bf233c4576e5822dde,
            limb2: 0x2babb7c611cab860
        },
        r0a1: u288 {
            limb0: 0x4efec15ee346cc4127842c93,
            limb1: 0x4d6461a2daedc16c8e48e027,
            limb2: 0x9f8867ed0117f53
        },
        r1a0: u288 {
            limb0: 0xe17146d42471aff94946a141,
            limb1: 0x986f7aacfd6a7faa7dc5d2b8,
            limb2: 0xa79e3d4bc1ef268
        },
        r1a1: u288 {
            limb0: 0xd214f26f88ccb18e3db6990a,
            limb1: 0xab7410e11f5c679071e9b1,
            limb2: 0x26202bc356500d1d
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
            limb0: 0xc256052898901d163e8c6aba,
            limb1: 0xc1ba67428923e3b672b47fc2,
            limb2: 0x1f3a260389bd3bab
        },
        r0a1: u288 {
            limb0: 0x467de0690d8d9631b2c19a16,
            limb1: 0xa9d4b5c4e3f539b74b94a431,
            limb2: 0x2c54678a3e9100d1
        },
        r1a0: u288 {
            limb0: 0x95e78ef9b3f66815359fe784,
            limb1: 0xe72241d429a70727e3ad66d0,
            limb2: 0x1eac593385852ae4
        },
        r1a1: u288 {
            limb0: 0xada7bc8265dd8478cc01a463,
            limb1: 0x6470f00b3132c08179c547c7,
            limb2: 0x28597b7592e1365
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x3a90038fa82347423068f6b2,
            limb1: 0xdda37e7f7ac99d1e1d77c213,
            limb2: 0x10fea31cf8c98018
        },
        r0a1: u288 {
            limb0: 0x97e15a3123e4ec8b6a3f2f37,
            limb1: 0x419ecb811afc68d2d36671c0,
            limb2: 0x196fa09f8d98eb70
        },
        r1a0: u288 {
            limb0: 0x5d0c1c9ecd8f5d26e43acc6c,
            limb1: 0x4d95763a3398aec21f071292,
            limb2: 0x19bd35da3a1b2f4d
        },
        r1a1: u288 {
            limb0: 0xf31736a4c413475d1cfeebbc,
            limb1: 0x818abcfe86fea276d5a5132b,
            limb2: 0x1fa88b5132bfb1b4
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
            limb0: 0x70f562b6894e309fe56cd5fa,
            limb1: 0x45cd081ee5ec1368b2cdfc6a,
            limb2: 0x2b96a5cdff3082ab
        },
        r0a1: u288 {
            limb0: 0x3bc2871086d5a4545fe5c3ab,
            limb1: 0x34e76623a7410ae817fc8f35,
            limb2: 0xce7997dd752f97f
        },
        r1a0: u288 {
            limb0: 0x5fc7618f2d597d1d43792f0a,
            limb1: 0x4a440cff7b4dccc71b39461d,
            limb2: 0x2e1ce3d58dd7110a
        },
        r1a1: u288 {
            limb0: 0x36e27cdd3d19279d16f1bcb8,
            limb1: 0x5981d71f9a29a7d9cdbf380f,
            limb2: 0x303bf9573e9dd754
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb48a43f6f257290828a195df,
            limb1: 0xb99590b4492f805e33d88252,
            limb2: 0x1fbdd126bcffed0c
        },
        r0a1: u288 {
            limb0: 0xc9203df68aaeb52bdb9c4b7f,
            limb1: 0x6e926f9c4df94861d9313633,
            limb2: 0xb23b6e0d605215a
        },
        r1a0: u288 {
            limb0: 0x92b10ab0f06f691fbde2498a,
            limb1: 0x4d6b0dada0b7ecdf0c89e371,
            limb2: 0x15b3fafaa8dd22e6
        },
        r1a1: u288 {
            limb0: 0x5ec43c67810cde45443ef043,
            limb1: 0xd63fe9114abf78c116428261,
            limb2: 0x1edfe8a8c2cff6bb
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
            limb0: 0xfd7f94932b8eabf1c38e51c6,
            limb1: 0xb04fa9980a9ed898f3b64d2f,
            limb2: 0x4dd35280a7f3ecf
        },
        r0a1: u288 {
            limb0: 0xe9507c6d03850128ea01fade,
            limb1: 0xb97096cd0079958af8ddef82,
            limb2: 0x1817f9d7a63fb08f
        },
        r1a0: u288 {
            limb0: 0x8d96e78ab7211617411050de,
            limb1: 0x4646b6dd7c1c9189160c2949,
            limb2: 0x28a972571f7c0491
        },
        r1a1: u288 {
            limb0: 0x1991fde4b5448ccc63d5189f,
            limb1: 0x1840bc84ab3c3b57172bdea7,
            limb2: 0xea3a0545793b36d
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
            limb0: 0x69a604f6f5feeb01885047f0,
            limb1: 0xae5c83107b72805ecd601320,
            limb2: 0x5e411ca1d29613
        },
        r0a1: u288 {
            limb0: 0xfcebede5d97c07791407392f,
            limb1: 0xb650d30df4b01b1a9359930f,
            limb2: 0x1eef79a7e278a9ab
        },
        r1a0: u288 {
            limb0: 0xc4d26ee5295d0fa5d71534d7,
            limb1: 0x773152c0dbadabc4b267f987,
            limb2: 0x1e38547b33126d5c
        },
        r1a1: u288 {
            limb0: 0x58d8a1cee5ad1587d8cdad3e,
            limb1: 0xeaffbe007e169d4dc77dcea9,
            limb2: 0x2e6c0b74c2156f59
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
            limb0: 0x77640c39c876d85e5757bd54,
            limb1: 0x351f266e86c0662d26d27b73,
            limb2: 0x2c249f00af70e785
        },
        r0a1: u288 {
            limb0: 0x385ec6b9525cefe9fe487895,
            limb1: 0x1699cc6367004907ac86c5b6,
            limb2: 0x1181a326905e281c
        },
        r1a0: u288 {
            limb0: 0x1930b9f39baacaed7d7f4a5c,
            limb1: 0x7b518a7bf7ed4e9bcb82b201,
            limb2: 0x3ff44d3449c19be
        },
        r1a1: u288 {
            limb0: 0xb0f2438c9a824fc0ec18b011,
            limb1: 0xae11c3d5beb665f877f0971c,
            limb2: 0xbf80a45a27ea49c
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
            limb0: 0xe8c203479d7310a6ce8d83bc,
            limb1: 0xc1b08b685dbb27a29c51e587,
            limb2: 0x1c12fbafdb388e4d
        },
        r0a1: u288 {
            limb0: 0x8e09492f9924feba30e49ed4,
            limb1: 0xf7850dae8ef199b49eb8906c,
            limb2: 0x26ed37eab2c764bc
        },
        r1a0: u288 {
            limb0: 0x27a7468ca9f846bc8ff4b109,
            limb1: 0x4fa6701b4e81f196a60259a5,
            limb2: 0x121bf8faab01d88a
        },
        r1a1: u288 {
            limb0: 0xc2d0c08ba58ea5c2ca232a6a,
            limb1: 0x90c1eb798e2fee0c816467db,
            limb2: 0x7bb740f11b5e411
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x2a939d4a8f44ff37bad2ceab,
            limb1: 0x1e808d92247cc1e1eb891018,
            limb2: 0x49f043ba6eee0d4
        },
        r0a1: u288 {
            limb0: 0x9e8bab86212ebb8039f6ec4b,
            limb1: 0xc8c8e40580a740394cf8d9a0,
            limb2: 0x10675de2a9de6704
        },
        r1a0: u288 {
            limb0: 0x4f1afa95ccf33692d5e11631,
            limb1: 0x27748a717595e22313d7b087,
            limb2: 0x1eb4a27bac408a7c
        },
        r1a1: u288 {
            limb0: 0x6d8243d638490f2acd0056e0,
            limb1: 0x4b64383710406edfd9c0d68e,
            limb2: 0x3d4a896605a135
        }
    },
];

