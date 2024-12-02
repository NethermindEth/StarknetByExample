use garaga::definitions::{G1Point, G2Point, E12D, G2Line, u384};
use garaga::definitions::u288;
use garaga::groth16::Groth16VerifyingKey;

pub const N_PUBLIC_INPUTS: usize = 3;

pub const vk: Groth16VerifyingKey =
    Groth16VerifyingKey {
        alpha_beta_miller_loop_result: E12D {
            w0: u288 {
                limb0: 0xbb6a14eff7b94c7d18a67757,
                limb1: 0x809d11a62e5242409f285357,
                limb2: 0x2e0be4737241dcbb
            },
            w1: u288 {
                limb0: 0x409d8c734ef3114169ab1ca0,
                limb1: 0xf684b44f7c9167a2a8c1eec,
                limb2: 0x173367b73aea6762
            },
            w2: u288 {
                limb0: 0x5b7ef2cc3e5921ec2a7c52a4,
                limb1: 0xfd85d4ab6c91d879b530c187,
                limb2: 0x28a1627a502b31c8
            },
            w3: u288 {
                limb0: 0x1cf26c7738d9d3a25ceb744c,
                limb1: 0x9e8c954263e58d0d5d07f0e1,
                limb2: 0xf9abb369dc85082
            },
            w4: u288 {
                limb0: 0xd1826c8381bdd20bf91100b4,
                limb1: 0x1f01f6608fe2143361633ae7,
                limb2: 0xbeff9ead522b034
            },
            w5: u288 {
                limb0: 0xe15bed8187195492880f1ce6,
                limb1: 0xf96cd8700c16d64942a35f03,
                limb2: 0x2b5069166290f41d
            },
            w6: u288 {
                limb0: 0xe5faf5ce0706a4e06168da76,
                limb1: 0x44128a9e782565ff148abf75,
                limb2: 0x1a624dc5d579312a
            },
            w7: u288 {
                limb0: 0xbabff42325e04f82d4e003ea,
                limb1: 0x57b123809485f97f404f81eb,
                limb2: 0x2182affb6d095182
            },
            w8: u288 {
                limb0: 0xe951951cdde78d1b03af8668,
                limb1: 0xe1fa0cf679e8358201d48cd3,
                limb2: 0xc0e42fd22cf3350
            },
            w9: u288 {
                limb0: 0xc2a801cd8c4b30af3c429d39,
                limb1: 0x45a42730f1ec7d277db83394,
                limb2: 0xb42dafcfe633d2c
            },
            w10: u288 {
                limb0: 0x8b947b187d45e37dcbb8822e,
                limb1: 0xae9ffa682439dfd3fe91a056,
                limb2: 0x20d574ccc83cac1e
            },
            w11: u288 {
                limb0: 0x665b2a26a7fb3b5924b02180,
                limb1: 0x8225736549435c43b38d9cf1,
                limb2: 0x776eb391f9b74bc
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
                limb0: 0x3cb76b49b79f75550055b29a,
                limb1: 0xeab78b98ca2a657e613279a6,
                limb2: 0x1b0ce5ee63c33810,
                limb3: 0x0
            },
            x1: u384 {
                limb0: 0xf1cf0963ee3de55a673f7695,
                limb1: 0x5a936dc526c555b0556342e0,
                limb2: 0x1f1a1666909d7e7d,
                limb3: 0x0
            },
            y0: u384 {
                limb0: 0xb13ebd52c6669a3f415ca6cc,
                limb1: 0xfc9cb04a1080740ac75a5424,
                limb2: 0x1bbb7836aff7d864,
                limb3: 0x0
            },
            y1: u384 {
                limb0: 0x5a1dcb23e8b2333f1bc5d7fd,
                limb1: 0x62dfb028e390dc7cf01306b9,
                limb2: 0x84763d222cac45c,
                limb3: 0x0
            }
        }
    };

pub const ic: [
    G1Point
    ; 4] = [
    G1Point {
        x: u384 {
            limb0: 0x9dfe97ff52015cb094d2cbb3,
            limb1: 0x60f5c2293710cd24f7c6301b,
            limb2: 0x1e5619dead60107,
            limb3: 0x0
        },
        y: u384 {
            limb0: 0x71c5c279d91c6dc257161fbe,
            limb1: 0xc5be92c8ac466cc36d42f984,
            limb2: 0x1f7344e99acbe929,
            limb3: 0x0
        }
    },
    G1Point {
        x: u384 {
            limb0: 0xc095f55b39e4065e26ac981c,
            limb1: 0xa032e37cd98941b1d74d67b4,
            limb2: 0x18a573f5c530fc96,
            limb3: 0x0
        },
        y: u384 {
            limb0: 0x9da7366d00a0c54924f23e07,
            limb1: 0x3204d066463f79551ad64a53,
            limb2: 0x202e790bf02c130a,
            limb3: 0x0
        }
    },
    G1Point {
        x: u384 {
            limb0: 0x6bec2f03058b74bd18c3c6a0,
            limb1: 0x25459b6c006369ae17001465,
            limb2: 0x1b28e7a8d351cffe,
            limb3: 0x0
        },
        y: u384 {
            limb0: 0xb9ee2434cdec947ee79d5b6a,
            limb1: 0xa61bfc8c4775385428ad8e1,
            limb2: 0x61fd08c83e448c1,
            limb3: 0x0
        }
    },
    G1Point {
        x: u384 {
            limb0: 0xd9412ac84befc2f0aaf6ac2d,
            limb1: 0x303a23ed142c6e340e2bc48d,
            limb2: 0x25f2c3bf73f575de,
            limb3: 0x0
        },
        y: u384 {
            limb0: 0xb748eea14f1ce910e64e20d1,
            limb1: 0x38979a7485c008ea5020daac,
            limb2: 0x2044a243c117888b,
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
            limb0: 0xce28f4d57ea797754077a18e,
            limb1: 0xc8d75919a407b6e3f7e04523,
            limb2: 0x1468ce02f483e11
        },
        r0a1: u288 {
            limb0: 0x321a96b11fb0d2b3b9495df3,
            limb1: 0x110400c59f6bc791a6e46ffd,
            limb2: 0x2eab8505c0db7081
        },
        r1a0: u288 {
            limb0: 0xbeb1476114af5cc141f4b35b,
            limb1: 0x71151753b85411ccc59ec716,
            limb2: 0x2a86a27bda970086
        },
        r1a1: u288 {
            limb0: 0x88c48341b55c6a85880cb942,
            limb1: 0x46dd110d018d7363f13c79f0,
            limb2: 0x29773758f9cdeb0c
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
            limb0: 0x9a48d5b7bd78f4a198055bb9,
            limb1: 0xef78ec9cdd79a1799fa1256d,
            limb2: 0x2f1dc192b1e96217
        },
        r0a1: u288 {
            limb0: 0x365733dc1c6fb9631f339f54,
            limb1: 0xa74c44f0e21590cbf09cfa94,
            limb2: 0x1b8c96d20562fa8
        },
        r1a0: u288 {
            limb0: 0xa9c0832c27712f55968849ec,
            limb1: 0x473b2e62c92d4690d1e2a37a,
            limb2: 0x5ddabf7069a9fa3
        },
        r1a1: u288 {
            limb0: 0xdfad474b86c4219150704405,
            limb1: 0x717334a97ff3e4f9a644f0a0,
            limb2: 0x6ed1719e763b51d
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xe67ebb229887f21827e058bf,
            limb1: 0x298c9d217b5bde7a7ab17820,
            limb2: 0x15288ce92f5ce4f5
        },
        r0a1: u288 {
            limb0: 0xe69e32fe0d4bf59d28999358,
            limb1: 0x415422e6e7d805185357c260,
            limb2: 0x2e4a0631873cc9cd
        },
        r1a0: u288 {
            limb0: 0x49552461bd6c6f9d67147315,
            limb1: 0x90eead7198d68eaa11a3acc2,
            limb2: 0x296c36208011de7e
        },
        r1a1: u288 {
            limb0: 0x5675a002a09fea51320be764,
            limb1: 0x169d8177a887e85cc2ad3226,
            limb2: 0x15265d2dc094cb86
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
            limb0: 0xef2c151c4fd3a2305337577b,
            limb1: 0x367fb79f5349a4fb5dc3c8d2,
            limb2: 0x148b2329b4441fd3
        },
        r0a1: u288 {
            limb0: 0x27c2eba82772f0d779782f2a,
            limb1: 0x448df0d81f769564220905eb,
            limb2: 0x60f864783c416d3
        },
        r1a0: u288 {
            limb0: 0x1430db2ef244271d61797fa1,
            limb1: 0x322592e7ac45bc74fe490383,
            limb2: 0x76ded824e73aa50
        },
        r1a1: u288 {
            limb0: 0x42f9cda5b1ad155ee24449ad,
            limb1: 0xbcaf6b37338f90e693993798,
            limb2: 0x792da08b4dfb248
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
            limb0: 0xbb1748b249608330d404c01f,
            limb1: 0xdbd0f55d9d1b69be100e5b0e,
            limb2: 0x1d0ffd6cbc7579ab
        },
        r0a1: u288 {
            limb0: 0xf68427ce7a38a1bdc968c26b,
            limb1: 0xbea53b91499ebf882ac25df2,
            limb2: 0x276719a7cb343623
        },
        r1a0: u288 {
            limb0: 0xd740a35c7441e4866eed5423,
            limb1: 0x8528fc4147b99f695c1fe811,
            limb2: 0x253b42b2ae94d0c9
        },
        r1a1: u288 {
            limb0: 0x123002c32d06f942040c0728,
            limb1: 0x4dae430c8c23ab31e6a901e2,
            limb2: 0x14ff5d03513147e6
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x61f14ebadf8977c1c45575ad,
            limb1: 0x1b1e6ddb84bd2092eab0054b,
            limb2: 0x1fbda389b74e36fc
        },
        r0a1: u288 {
            limb0: 0x97a72db5c81fcd734c7b7da0,
            limb1: 0x30ccec4e18ffb90869bf57f8,
            limb2: 0x177ced5beda3a26
        },
        r1a0: u288 {
            limb0: 0x5cc4eeb2dcffa9bbc187e82,
            limb1: 0xfc3caa7e00bfa79f78a7f5db,
            limb2: 0x2d93e85fcf47e800
        },
        r1a1: u288 {
            limb0: 0x48b07aff3fd8376d91ba7fff,
            limb1: 0xba435c45d56282eeb48081b,
            limb2: 0x2f7f38eb1e497aa2
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
            limb0: 0x32f4028f7c51632a438946d3,
            limb1: 0x85070ee9c0fcfc8f00b3e72a,
            limb2: 0x17d95ab75d6213a9
        },
        r0a1: u288 {
            limb0: 0xc261589c82737f994e14b411,
            limb1: 0x6c8d1a0a3351380de0ac2192,
            limb2: 0x2857a38209708997
        },
        r1a0: u288 {
            limb0: 0x27897fdd9c59989c30a28f4f,
            limb1: 0x899137033fcbf30815774654,
            limb2: 0x15abe39db8165274
        },
        r1a1: u288 {
            limb0: 0x94de8d377a52a8d20a250747,
            limb1: 0xec9b03495f513aee9929423c,
            limb2: 0x2f16899e54e3e4a0
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
            limb0: 0x8d0a522184208475e923819,
            limb1: 0x63c1fbdb7104bdae42f0234,
            limb2: 0x1396d19979fc0840
        },
        r0a1: u288 {
            limb0: 0xee7b0c31ae9423ab31de7c35,
            limb1: 0x90126ed5a1f0e785e6c8d098,
            limb2: 0x27dfe08885400e08
        },
        r1a0: u288 {
            limb0: 0x71ec5934a1a8b2c81b8095d4,
            limb1: 0x75ddfe032e1a2039adf95129,
            limb2: 0x21a7eac9d30a80fa
        },
        r1a1: u288 {
            limb0: 0xc35a4fd3c090a58f0de9f295,
            limb1: 0x6225a4d013c25e0fb16f1edf,
            limb2: 0x208457731085e13
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
            limb0: 0x3cca293bed1b73fc989ba655,
            limb1: 0x4dbd71ca4d988f79e5241426,
            limb2: 0x1abc1ff5ba07261d
        },
        r0a1: u288 {
            limb0: 0xc57716666bd4147d80cb54f8,
            limb1: 0xce00cb82a3a5e400353b2515,
            limb2: 0x113264207b5b8bf9
        },
        r1a0: u288 {
            limb0: 0xf9078f95509ebfad9b75d0e5,
            limb1: 0x49b5a085e26693da24d4bc99,
            limb2: 0x24381f4badc8ecbc
        },
        r1a1: u288 {
            limb0: 0xc043d117fd761fb542cf5355,
            limb1: 0x4caacda320a8d2e308fc0858,
            limb2: 0x1404db948ff2a5cc
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
            limb0: 0x20fb1a7678fdf3720a18d44e,
            limb1: 0x6e032e35823095b15639818b,
            limb2: 0x2ea15c6644190c5c
        },
        r0a1: u288 {
            limb0: 0x61d8c4ff0ab956a6dfafbb00,
            limb1: 0xe381e9b6617f3b1d12f71fc5,
            limb2: 0x3d136388bd6e857
        },
        r1a0: u288 {
            limb0: 0x1fb4f5b3622d22b27ef4f9ff,
            limb1: 0xafb69cbc78c1e5c0eaa4f412,
            limb2: 0x2a58aad040d563b6
        },
        r1a1: u288 {
            limb0: 0x28d80260efbc1de9592e9ef6,
            limb1: 0xd4d9865fc76566e67e8d08d,
            limb2: 0x20da9b64e26e4975
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x6b76f2660ed33305c52bfa85,
            limb1: 0xb82ed8cabdc9f13f4057c13f,
            limb2: 0x8360771cd9f066b
        },
        r0a1: u288 {
            limb0: 0x32f39c3f21c11c4e18e9a42b,
            limb1: 0x3f44609424826ed1fc28419f,
            limb2: 0x7b3e0c3a02a9f2a
        },
        r1a0: u288 {
            limb0: 0x407bd72a898d818aaab3ab57,
            limb1: 0xaf8f9529827f0831b6333abc,
            limb2: 0x348a60c6e815ba9
        },
        r1a1: u288 {
            limb0: 0x2fb109d2a4055405c95e4164,
            limb1: 0xe2ca5ab547915a2f41db1153,
            limb2: 0x9643a05cbd7535b
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
            limb0: 0xd46219d4f1920668d4648d,
            limb1: 0x60ab0246a7984b4a86617d42,
            limb2: 0x2211429e31e3aee1
        },
        r0a1: u288 {
            limb0: 0x562ae60f9be24b166e4a51c0,
            limb1: 0x66c12661e908e6ffcdf6c9a6,
            limb2: 0x18eb8eb91968ec5c
        },
        r1a0: u288 {
            limb0: 0xe5779cbb90b14ed20da4ff1c,
            limb1: 0xdbac9f096c6f354a9ed15d89,
            limb2: 0x2e0dad49f47f0f7b
        },
        r1a1: u288 {
            limb0: 0xd0041b13bbf056a8b7507344,
            limb1: 0x1c7fabe1e2c1af8665ac6bbf,
            limb2: 0x28c6f89e2a9eaf34
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
            limb0: 0x5ecba41911cc331f5fec7159,
            limb1: 0xd360214dce768281d00ac302,
            limb2: 0x995e561dcf07446
        },
        r0a1: u288 {
            limb0: 0xdfc1869eeb667558ef17a75b,
            limb1: 0x55c516efe4bc6ca746b48507,
            limb2: 0x247e8692cefbbfb
        },
        r1a0: u288 {
            limb0: 0x4b5b6e204988d81555660d2c,
            limb1: 0xb4d57c158f372a6a81595261,
            limb2: 0x275135c5d44b6855
        },
        r1a1: u288 {
            limb0: 0x2bf4f0700e8c599beda11eb9,
            limb1: 0xd441ad9dde6285e9d16167f5,
            limb2: 0x297ab47b7bfce803
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x90a6c2e704cbe85e5cfb1b3e,
            limb1: 0x77038b933137400f92e6b5c5,
            limb2: 0x1664bd7838f9dbdd
        },
        r0a1: u288 {
            limb0: 0x953f8889281c03ab518dbfb0,
            limb1: 0xef2df916f7067727241d481d,
            limb2: 0x27a97b2d8bf1b0ab
        },
        r1a0: u288 {
            limb0: 0x7812798d434ebeccac6f3e26,
            limb1: 0xe1da0a817b7839dd0cf90a31,
            limb2: 0xcf4a6e267bec71e
        },
        r1a1: u288 {
            limb0: 0x784fc8913e439e198dae2d1b,
            limb1: 0xdc2e20678813b2fde6715297,
            limb2: 0xabeef423660997f
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
            limb0: 0x6427df108c9f7a771f099bdc,
            limb1: 0x3fed542cdf3c90bdcac915ec,
            limb2: 0xc7d2ded1ffd52cd
        },
        r0a1: u288 {
            limb0: 0xe59a9202bc39f4afb405b0a9,
            limb1: 0xb6df7b4d586dca6b423a17b3,
            limb2: 0x1b3854e0b8a3bf25
        },
        r1a0: u288 {
            limb0: 0x2ba42f565e98dfb1b4618b1e,
            limb1: 0xa3aa71dfebd66b5d232b41e0,
            limb2: 0x11aa508fe171061d
        },
        r1a1: u288 {
            limb0: 0x4839960fe9ff66b1d5016aba,
            limb1: 0xdcd13d886eae5df12c85f203,
            limb2: 0x304b0ad6270778c8
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
            limb0: 0x2ca7511d6b02d1fe59ddde74,
            limb1: 0x912a26aa77cdd474f9ccaf3e,
            limb2: 0xb058df64af6e38b
        },
        r0a1: u288 {
            limb0: 0x1809d6e215613be496c85ef7,
            limb1: 0xa7b9f2b98d36bfdb4390d0d6,
            limb2: 0x188f99977915074a
        },
        r1a0: u288 {
            limb0: 0x7d1b0a1fed47f0d3a08e2ae3,
            limb1: 0x1bd6749d670a58b6a4b68820,
            limb2: 0x615cce4bd555b2a
        },
        r1a1: u288 {
            limb0: 0x1cf4be34cfc74893e4468998,
            limb1: 0x7969091e330b66c81b5bff1e,
            limb2: 0x8d7f2f642118492
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
            limb0: 0xf59f652dc2eb7169fb217935,
            limb1: 0x1e11aa11e9c54cc13d817c6a,
            limb2: 0xcecddaac0e9c8a2
        },
        r0a1: u288 {
            limb0: 0x84f8059d9d12f9a858120caf,
            limb1: 0x42f0a499e64e6ac0fe397147,
            limb2: 0xc3e88be66bcb55d
        },
        r1a0: u288 {
            limb0: 0x74dc06ff1165e6890aed63e8,
            limb1: 0x3cc601055420f5faa6448f48,
            limb2: 0xac57e2a06acfb0c
        },
        r1a1: u288 {
            limb0: 0xb5cf3a37c778985cdaf61855,
            limb1: 0x619e78dd031d07f89aa4e865,
            limb2: 0x114b94da842f23f8
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
            limb0: 0x1136ca6dcd8d59ac614a74e3,
            limb1: 0xf53d3824ea9c1a970574758d,
            limb2: 0x644bf473dbb1964
        },
        r0a1: u288 {
            limb0: 0x2d4191ce9195711296772f47,
            limb1: 0xa4f34504e77778b8103fb2fa,
            limb2: 0x2dd5580311bdfbd0
        },
        r1a0: u288 {
            limb0: 0x91d254617468612380b157a,
            limb1: 0xaaa4ca4544a042f9d5065a0c,
            limb2: 0x237faae47ef7a1dc
        },
        r1a1: u288 {
            limb0: 0x8dfe105d750ddf34eca3ed0e,
            limb1: 0xb056e91261fe56167020c3a2,
            limb2: 0x1039d86a4a71e04a
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x4d4a62ad7229feb40ac6b869,
            limb1: 0x58397c3a984582003e754709,
            limb2: 0x2c8f6a00a0523415
        },
        r0a1: u288 {
            limb0: 0xa915bbeedf7cbdb87e0b1625,
            limb1: 0x94ea80f500c294c3342a9c89,
            limb2: 0x188fc2bf79770d86
        },
        r1a0: u288 {
            limb0: 0x847188d4aafc49a6a1eb0a54,
            limb1: 0xf7d2f621dd1565be025119c,
            limb2: 0x196a7d8fa639a0d8
        },
        r1a1: u288 {
            limb0: 0xe7df0651d760013c01e9bddc,
            limb1: 0x4ddb8783c684acebae25fe21,
            limb2: 0xd0b73dc494672fb
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
            limb0: 0x7aafc81cda24649b37b7238f,
            limb1: 0x5e852726d308285db7fe0b48,
            limb2: 0x2e8bac4ba8e47eae
        },
        r0a1: u288 {
            limb0: 0x9d628d6c1a7c4460fb614f50,
            limb1: 0x9c2e0ed607ef0ea0574ab4e2,
            limb2: 0xc0908b55799684f
        },
        r1a0: u288 {
            limb0: 0xcdd81a9b8f5d987210e20ba1,
            limb1: 0xe38e3b4ffe30ba723784627c,
            limb2: 0x39ccfbf3cef8aa7
        },
        r1a1: u288 {
            limb0: 0x109bea799f34d6eca0310f9b,
            limb1: 0x6f88c63b6296e021ae9ef688,
            limb2: 0x252e254b2815810b
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
            limb0: 0xc585a9eeef6a4c7b053ece5a,
            limb1: 0x5c473a72c7bbded3c59755de,
            limb2: 0x2c472d8c6c2c86f5
        },
        r0a1: u288 {
            limb0: 0x2a1d44899674c9710b947fe8,
            limb1: 0x2af782a8d28772d20e2fcaaf,
            limb2: 0x1db66da72660dd8a
        },
        r1a0: u288 {
            limb0: 0xa180ee928b3d3a783e1ff0fc,
            limb1: 0xd4432704a562d30e73259ffe,
            limb2: 0x1ad7932d11e3ffe9
        },
        r1a1: u288 {
            limb0: 0x48bcafb43b3996ff198e6a9,
            limb1: 0xed08257e84712d1f36a3f857,
            limb2: 0x2255ca475ba1b41a
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
            limb0: 0xb2240c443039995156f05a7e,
            limb1: 0x1a7a2856f05f6f4b21a9440d,
            limb2: 0x456a03e88a1d27
        },
        r0a1: u288 {
            limb0: 0xbc8e87975cb1349c37fd1529,
            limb1: 0x6a66e76cddfe36ff2c61ef7,
            limb2: 0xe09fa1c94a40802
        },
        r1a0: u288 {
            limb0: 0xb892b462b8d3f4671a09c888,
            limb1: 0x96d3556759d5b2a4cd772d20,
            limb2: 0x29e317c4963bd25c
        },
        r1a1: u288 {
            limb0: 0xd653b3425a189bc0296467ea,
            limb1: 0xa8618f36b68f4c0a139a3172,
            limb2: 0xcafa764f259545a
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xaaf66031942007df81789ef3,
            limb1: 0x284dbeafd92edc90fff00f34,
            limb2: 0x179146f96013e080
        },
        r0a1: u288 {
            limb0: 0xf8a2bbceeb7c6d7f7fce8253,
            limb1: 0x232d55f0b370e3ded6b977f4,
            limb2: 0x1efdf3c8dde597e5
        },
        r1a0: u288 {
            limb0: 0xe87d3351cd00af84cde9d3ae,
            limb1: 0x60da1c99191def4086bfcd42,
            limb2: 0x161cbbca6a0c2758
        },
        r1a1: u288 {
            limb0: 0xf94d2e772ea078fb11dc1f58,
            limb1: 0xb9ee31bd06fe8eba0719bbd0,
            limb2: 0x2236496aed8ee98b
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
            limb0: 0x6c03044127eb7aaf0864bd4b,
            limb1: 0xa1011f06da5c53ebcc707a98,
            limb2: 0x1adbd12079de79bf
        },
        r0a1: u288 {
            limb0: 0x42bd64c8eed5c0b20accb2b6,
            limb1: 0x17fa9e9e1db83f823ce1e1b5,
            limb2: 0x1c96827876a15f00
        },
        r1a0: u288 {
            limb0: 0xe643057da84b275b845396d,
            limb1: 0x4625c8c6a4704e21eda37dc5,
            limb2: 0xa88abd4f0134939
        },
        r1a1: u288 {
            limb0: 0xb93121c80cd97554b4dce883,
            limb1: 0x56770f28a711a018dc9104fd,
            limb2: 0x1e8e212fe6d635d5
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xd61e9281099fdd1538c1f70d,
            limb1: 0x46d42361dffa02de24103f72,
            limb2: 0x12504bea0e36f4ba
        },
        r0a1: u288 {
            limb0: 0xbd189eb1adf3c83c351af627,
            limb1: 0xd80129e7c35b62a4f6312dd6,
            limb2: 0x2c878d31aa0ae7dd
        },
        r1a0: u288 {
            limb0: 0x4fbd86f376f6a3344e80d623,
            limb1: 0x6827eebccd4638a69a579308,
            limb2: 0x2ece0f127a797557
        },
        r1a1: u288 {
            limb0: 0x6cd2b83b08c641891b55cb03,
            limb1: 0x833651e0127fc094e4138336,
            limb2: 0x2424114d7cc3e2c6
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
            limb0: 0xa9a15fa095c094f4fc343966,
            limb1: 0xdd8ecea32897b2f7a6723513,
            limb2: 0x1b448d0f8a344a34
        },
        r0a1: u288 {
            limb0: 0x2c73b437a76c87552c0616b1,
            limb1: 0xf6246934354f179cf2dfd56a,
            limb2: 0x1586dd6611c792b5
        },
        r1a0: u288 {
            limb0: 0x303e165e45ad2a4f424e5cc6,
            limb1: 0xe90db04436b8939e4081e821,
            limb2: 0xf9313c21fa16c73
        },
        r1a1: u288 {
            limb0: 0xa6582d41429cb842ac961eb4,
            limb1: 0x265cc8092ba2d9b001137ea0,
            limb2: 0x11e549984cabdcd2
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
            limb0: 0x1889e7ab6a1b5cf70929fd15,
            limb1: 0xa14b259fcf01974565b261bb,
            limb2: 0x176e4e35e85e6508
        },
        r0a1: u288 {
            limb0: 0xd21f118244d354f0e5ba62a1,
            limb1: 0x81d6654cb9f02b1147e85552,
            limb2: 0x10862fedd37813b1
        },
        r1a0: u288 {
            limb0: 0xdc3d46a577adfaf4751c3ce8,
            limb1: 0xe24a21f32ae041d2c4b6ae2,
            limb2: 0x1a8fddf95a091121
        },
        r1a1: u288 {
            limb0: 0x3d7ac3d3d546e584c2af2c45,
            limb1: 0x39b06a2aca9db7da127ccc3,
            limb2: 0x167e95d3b59fdc81
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
            limb0: 0x5494e9620ae5877e85d2da99,
            limb1: 0xceb24c9ee07a7f39c9cca8e2,
            limb2: 0x2aa29af5e4f48b5
        },
        r0a1: u288 {
            limb0: 0xc06f86983fc2360d0d4a80ed,
            limb1: 0x75036f25548c61f03f75f17e,
            limb2: 0x27cd0a2991e26e99
        },
        r1a0: u288 {
            limb0: 0x13c2744a6d24430e7fa736ca,
            limb1: 0xc3a29c2784a3f1f12036a8d3,
            limb2: 0x2384edc936fa6ad7
        },
        r1a1: u288 {
            limb0: 0x7861b211be9ae53889efc127,
            limb1: 0x31c28385bd5e5190e657e217,
            limb2: 0x1d349acd515a66d6
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xce46d8d0198dc7b0dfc9d359,
            limb1: 0xc0a48e7f46041c3b37e997ef,
            limb2: 0x1432b5bbca84e869
        },
        r0a1: u288 {
            limb0: 0x5f2200c8665762b0511f8e7a,
            limb1: 0xee1ecbac6265900c832934db,
            limb2: 0x2abe7ca47b45d975
        },
        r1a0: u288 {
            limb0: 0x11e90f9a8e7e1461702b04a6,
            limb1: 0x9fc2b130f1e6d264b77a0120,
            limb2: 0x238a537c70d3dfa8
        },
        r1a1: u288 {
            limb0: 0xbc89c1bbe1e495c667417edd,
            limb1: 0xbe5181ca3e5f57bf906079c6,
            limb2: 0x2bab8bcaaf8af4e9
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
            limb0: 0x21301a629d662cc0f528c780,
            limb1: 0x5c95c990e1d7983fa4d15aba,
            limb2: 0x1fc3687f23f6dcf2
        },
        r0a1: u288 {
            limb0: 0xa8cdf4e0d48dba4109b411fb,
            limb1: 0x5a62cb6fda8007b379c8b7e9,
            limb2: 0x6121edc03584eec
        },
        r1a0: u288 {
            limb0: 0x9f7182d678d7b40a329b59ba,
            limb1: 0xa90c99e873489d98b4133454,
            limb2: 0x233c0a42d5b05c83
        },
        r1a1: u288 {
            limb0: 0x326e3aa6d978edcfe1279419,
            limb1: 0xeba09bb9e5c1972f769e184b,
            limb2: 0x2116e67edf7d3a43
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
            limb0: 0x9b7f9fb6511b2166b34f6332,
            limb1: 0xbf3ea96c8b2177792b44c794,
            limb2: 0x1b7a630a57de899d
        },
        r0a1: u288 {
            limb0: 0x5ed462d11dfa9945202763d,
            limb1: 0x157a1dd6d2025ae8a4a88392,
            limb2: 0x14d557177caf0040
        },
        r1a0: u288 {
            limb0: 0x493e42beb40818f7d8851097,
            limb1: 0x450dde989a0f7de97e582e76,
            limb2: 0x23b6868355d774a4
        },
        r1a1: u288 {
            limb0: 0x3f13c0245fb355df0b5fbda7,
            limb1: 0x77698e827db9b725421dafd5,
            limb2: 0x1165217f5b877092
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
            limb0: 0xa75ab40685f77e1627bb1558,
            limb1: 0x6edef8c7b11f14fa3b4946fe,
            limb2: 0x279c35d367cec8b2
        },
        r0a1: u288 {
            limb0: 0xeda15644528a0efa8693c208,
            limb1: 0x8d0be1e218c9c305ccdba510,
            limb2: 0x189a59a7f19e2de0
        },
        r1a0: u288 {
            limb0: 0x8a782fcb159d7e88b0db3b88,
            limb1: 0x20b5dce369d90ed8a9fe0275,
            limb2: 0xd27b54a59adff67
        },
        r1a1: u288 {
            limb0: 0xa1ce0e7bae52142978f9fb7c,
            limb1: 0x925fb8044bb2b2aed4060b94,
            limb2: 0x1fb9496dced20966
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
            limb0: 0x30d7fafce4d113463d844e61,
            limb1: 0xb61960397a51ac64da0a85be,
            limb2: 0x11bd4fad19e4259f
        },
        r0a1: u288 {
            limb0: 0x91c9a9ed3b5a24fcc03f1daf,
            limb1: 0x9187d515917f4c6965aada0d,
            limb2: 0x35f7c8a4bdeca9c
        },
        r1a0: u288 {
            limb0: 0xbe9e0fe8f29ba2f4332106d6,
            limb1: 0x3b83023e2dca3a2c9a42868c,
            limb2: 0x28aa896168d2e21c
        },
        r1a1: u288 {
            limb0: 0xac541bf6406bc208b34f40bb,
            limb1: 0xd829ee922886d8edb600c126,
            limb2: 0xc9f161e3c466e
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
            limb0: 0xe9e72c807fa173565ee17deb,
            limb1: 0xdbbb5329b17c3976c1212051,
            limb2: 0x1ffc046e9838cdbf
        },
        r0a1: u288 {
            limb0: 0x4e065bb0d00fd8dca73ae803,
            limb1: 0xd04b9768ef4b353fcda6cd96,
            limb2: 0x171accf658ede91b
        },
        r1a0: u288 {
            limb0: 0xb8f2811a91ae5cdba03ca59b,
            limb1: 0x463d2e3fff5258920f807c1f,
            limb2: 0x1a9f22af34d8b6af
        },
        r1a1: u288 {
            limb0: 0x14a8f16743481b4166ed31d0,
            limb1: 0x9d84c93b20c633280c5d1ac,
            limb2: 0x2d86a4f542c91972
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
            limb0: 0xdbc7003d924d815b20c18b74,
            limb1: 0x6bd437b54b87b577fe8162e8,
            limb2: 0x1085b69362c1a972
        },
        r0a1: u288 {
            limb0: 0x84f147d912f32cf3a2c5df61,
            limb1: 0xcb2bd564e13763f6e87e8b5d,
            limb2: 0x1c805d0a1e50ffa7
        },
        r1a0: u288 {
            limb0: 0xe867a5834160372a14c1fe6a,
            limb1: 0x7960f07c2a5314a52c6f9bb3,
            limb2: 0x153bbdc429cc9ec1
        },
        r1a1: u288 {
            limb0: 0x5e436df753132b6226a593b8,
            limb1: 0x518abc98503f277057be9848,
            limb2: 0x22a14caa2f74d004
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x9fa60f8b081405edc0da79a5,
            limb1: 0x9048d993557ee9c66d4908b2,
            limb2: 0xf05e897077208a7
        },
        r0a1: u288 {
            limb0: 0xbc65d25f058e49a86998cfa2,
            limb1: 0x54bdcd637b0c291cbf11c4b7,
            limb2: 0x9d5d2c5623e066
        },
        r1a0: u288 {
            limb0: 0xafd558a275aef91b7dfa6024,
            limb1: 0x5418c757fd949558c4262ec4,
            limb2: 0x1bb20804241ac34c
        },
        r1a1: u288 {
            limb0: 0x8f856680573a39fff30df189,
            limb1: 0xea0fa15c8f212dd3bdd90664,
            limb2: 0x21222314f4ab5734
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
            limb0: 0x7a465977a3fb842e4306b687,
            limb1: 0xd371d003e2e8f6e1808933fb,
            limb2: 0x137117f8e2685e07
        },
        r0a1: u288 {
            limb0: 0xe5778f374788d1db755d0d19,
            limb1: 0xef7a55455dde0626fcba5e98,
            limb2: 0x2b93d583cb24aa57
        },
        r1a0: u288 {
            limb0: 0x4ab0852c2ba83bbe84841659,
            limb1: 0x942fb96b7aa673b10d529d91,
            limb2: 0x28933119437d149e
        },
        r1a1: u288 {
            limb0: 0x8d9d2724bdff3733546155d7,
            limb1: 0xf206d72a77ca6c28c78c0f87,
            limb2: 0xb640f595887b68d
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
            limb0: 0xb263a524e001185ca0817467,
            limb1: 0x56469555f121158f49021ab7,
            limb2: 0x735ec23ad6e1f72
        },
        r0a1: u288 {
            limb0: 0xacc67a9a1172970fad48b010,
            limb1: 0xea4a348da6e6368a804b1acb,
            limb2: 0x27e47b4390dcc49c
        },
        r1a0: u288 {
            limb0: 0xce51deb08f265cd1717a5503,
            limb1: 0x10ebace983ee06d5685bac74,
            limb2: 0x22847c60a65ebeb2
        },
        r1a1: u288 {
            limb0: 0x88758820c8dcfc6caf3df769,
            limb1: 0x92f30e5df84762a183f27aa1,
            limb2: 0x273d169e6fde7649
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
            limb0: 0xe756fbea97deb2e805f73239,
            limb1: 0xf1210d06b760dd8c7a2bc8a,
            limb2: 0x1bbb1003fea48374
        },
        r0a1: u288 {
            limb0: 0xcc86cc7ccac45e6735cd9c9d,
            limb1: 0xa7d767999424a944e638c2ac,
            limb2: 0x54e20bbbb02af8b
        },
        r1a0: u288 {
            limb0: 0x7ffcaa5e0df7543bc0a5ebe3,
            limb1: 0x3aa9a570e80ab1be9b6c33bb,
            limb2: 0x2b72ad6abe771e1a
        },
        r1a1: u288 {
            limb0: 0xe944d433529e6b6ad5a5abd2,
            limb1: 0x395ff9776c48f034b9bb084e,
            limb2: 0x13da921afe7ad364
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x8eaae3a73a8e0e841b6ca719,
            limb1: 0x2e518461c736f5323c9e93fb,
            limb2: 0x2d06b41393cd3034
        },
        r0a1: u288 {
            limb0: 0x57a2db79c988f46187bdf954,
            limb1: 0xa746422707921667d923796c,
            limb2: 0x90dbb00259c68e4
        },
        r1a0: u288 {
            limb0: 0xb1ccae5fcdd91ae2e13c241a,
            limb1: 0xc99f093c9a5d7757e670f186,
            limb2: 0x303e7f789eb577c9
        },
        r1a1: u288 {
            limb0: 0x11e26c83b6dd82934fffa279,
            limb1: 0x2ddcd438fcf15b5ce107de60,
            limb2: 0x105d5d6f4b7c1bec
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
            limb0: 0x39bf157ae0d6700defb07ffd,
            limb1: 0x905c1b7b7c0289a94c0320cf,
            limb2: 0x2febad5f47a01f83
        },
        r0a1: u288 {
            limb0: 0xcf46aebef5e6500e26f221b1,
            limb1: 0x1123c719e71d8fae83d8d672,
            limb2: 0x1f54e5dad97ec36c
        },
        r1a0: u288 {
            limb0: 0x8caaa9428451812d46d1431e,
            limb1: 0x3a909d52fcef598bca23b57e,
            limb2: 0x84a1c86ce818f81
        },
        r1a1: u288 {
            limb0: 0xe000d526e361e33aa5ce81c4,
            limb1: 0xa5723c15161e7774bb84657c,
            limb2: 0xddf8f2267119afc
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
            limb0: 0xb73a6ff39b55d182fdefaa86,
            limb1: 0x29cea4ce35d4b13091ecaea,
            limb2: 0xa420eb477f1d48c
        },
        r0a1: u288 {
            limb0: 0x93efb7be95030424cf229876,
            limb1: 0x6896ff6678cef13b1c56b7db,
            limb2: 0x301621aaae94c0ca
        },
        r1a0: u288 {
            limb0: 0x405d1cdb806118834eee9850,
            limb1: 0xe83fbb4f0436c5acdb564447,
            limb2: 0xf62853ed83c9a9e
        },
        r1a1: u288 {
            limb0: 0xbde62b8677e5624bd847fcd4,
            limb1: 0x8757d297c022d8cac466fd7f,
            limb2: 0x1a6305768cd5767d
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x29e7e39929b7cdffb42f8350,
            limb1: 0x8fe000c765fc21a5011b58f3,
            limb2: 0x2f68592756a9e5f5
        },
        r0a1: u288 {
            limb0: 0x1ce400db55cd22cc0764ea1c,
            limb1: 0xcb8c75dcf006ee31bdfc9b47,
            limb2: 0x1b556228de718a60
        },
        r1a0: u288 {
            limb0: 0x82ba5aef9885114f150a3bdf,
            limb1: 0x54c1e4a3dc487f6c981efc2e,
            limb2: 0x272e70a529b210f1
        },
        r1a1: u288 {
            limb0: 0x1d6f67f53e2fdcbdc8ddc6ed,
            limb1: 0x49e80b20e27716a9bc01e39b,
            limb2: 0x26e8e1f808939c7d
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
            limb0: 0xa5a7b489453b512324ccf312,
            limb1: 0x188c3a58e6ae5e6f1a1ad779,
            limb2: 0xb07a7a0bcde6f1
        },
        r0a1: u288 {
            limb0: 0x82945c95a7dbc5d399204387,
            limb1: 0x9f538d2c7a779ea06998f8f7,
            limb2: 0xa310ba6ee8f5dd8
        },
        r1a0: u288 {
            limb0: 0xa6ad406ff32c38300ac1c205,
            limb1: 0x86406a6ec5e685eed7be94f5,
            limb2: 0x505412527279461
        },
        r1a1: u288 {
            limb0: 0x7406d5faa26ab6ac18460b82,
            limb1: 0xda5cbc27fbde06de94120d9,
            limb2: 0x20c7c7b56b9df4a7
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
            limb0: 0x49dd2d00f570fc22f6789c29,
            limb1: 0xd12cd465a227a5e96ddd9e0e,
            limb2: 0x17e8fc970690079c
        },
        r0a1: u288 {
            limb0: 0x16bf7b64f1e6f2207c215f5e,
            limb1: 0xc523d813e58aa869702e3ed,
            limb2: 0x18651f8308ac041
        },
        r1a0: u288 {
            limb0: 0xb2b2bfcf24a2e740b38d28fc,
            limb1: 0x814b8e0d53af64a331f05724,
            limb2: 0x22ed4ea6a4fda9dc
        },
        r1a1: u288 {
            limb0: 0x4ad4734945e45100418d1d57,
            limb1: 0xd6c091f01f85b8703575e484,
            limb2: 0x1a639175a3c018b9
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
            limb0: 0x7c537d8df4f8fd12a10b8820,
            limb1: 0x7ac7ac348d7821643e01b5f4,
            limb2: 0x14d93a47ab27b85e
        },
        r0a1: u288 {
            limb0: 0x77c63256b8dbb1d7398b48af,
            limb1: 0x2e24a99925da4bda5c27eece,
            limb2: 0x2e3be2b065ad29b1
        },
        r1a0: u288 {
            limb0: 0x63c4c94265767ccb52bc2e7e,
            limb1: 0x45e84f884cb3282dd5790f0,
            limb2: 0x14fa3ebad9824f64
        },
        r1a1: u288 {
            limb0: 0x5643129f3c776ef5a2820629,
            limb1: 0xc07ce3c39806d7a83c66e75d,
            limb2: 0x2b3fbbc38ab0527e
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x314fe1ee84e2d28940b8120c,
            limb1: 0x6e662113c3696878b4979b9,
            limb2: 0x1c591a8faf5a6ebf
        },
        r0a1: u288 {
            limb0: 0x4728cd6304832a595d4f11b0,
            limb1: 0xba2ee05f128ff1dba043afa5,
            limb2: 0xd29977efd823a28
        },
        r1a0: u288 {
            limb0: 0xb818ecf4d48eefbc14803194,
            limb1: 0xb1e4890be0998bef94ca96f,
            limb2: 0x20dde8d9a99d451
        },
        r1a1: u288 {
            limb0: 0x9bd93a1557eb62301de896e1,
            limb1: 0x6c91255aefb399ed3acaef18,
            limb2: 0x23620db81bfd36ee
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
            limb0: 0x17a131b21283e58932697021,
            limb1: 0xcdb5c806471d23875d81fd20,
            limb2: 0x5265982ee603ae
        },
        r0a1: u288 {
            limb0: 0x143f5ea4f900d0b50f7221f6,
            limb1: 0xd6ddaf05142b4b6f64c62b32,
            limb2: 0x1739a2faa4b89289
        },
        r1a0: u288 {
            limb0: 0x604a1ea04e8363c3f8a1c606,
            limb1: 0xa0bdc28e9fc7a87f59c84654,
            limb2: 0x1fd5beee6dfa5cd9
        },
        r1a1: u288 {
            limb0: 0xb1d919c4bd74d10bfe4e9c74,
            limb1: 0x433a372b8d8049431b85fc31,
            limb2: 0xcffd7263c2cf4fa
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
            limb0: 0xc1ecf1f257e0d44bd537479a,
            limb1: 0xd5ecfb041beb4ea66a3c6af0,
            limb2: 0x26225eaeb2b99afe
        },
        r0a1: u288 {
            limb0: 0xd2859743ab67916b1ab8d643,
            limb1: 0xed9d72dfc1d7b2e2ecee34a8,
            limb2: 0x1afce91a744fc46d
        },
        r1a0: u288 {
            limb0: 0x4ed7b915dcc44dd45e79e04f,
            limb1: 0xdce88ca3c095aa0902c5ee3e,
            limb2: 0x21d88a17e5211c46
        },
        r1a1: u288 {
            limb0: 0x777a317011f36b97a348c6b4,
            limb1: 0xc6faebf53bc7f59f0ad449a2,
            limb2: 0x7e56f2197ac04b6
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
            limb0: 0xd79d44eaab35111da2870199,
            limb1: 0xae157ca47a8945456d34657,
            limb2: 0x26e113aed2d5a6da
        },
        r0a1: u288 {
            limb0: 0x54dd5e45a6a8a68a7ad8c6ad,
            limb1: 0x2d12e2687277170bed43a68f,
            limb2: 0x6179fbb0c3d83e
        },
        r1a0: u288 {
            limb0: 0x13d7944f3dc847aab1e94e07,
            limb1: 0xaaf3f0e6b301543336653ff3,
            limb2: 0x1bee6443bd6aee62
        },
        r1a1: u288 {
            limb0: 0x35e4d44afaf77fcefb4b364b,
            limb1: 0xad7dd3cb9af693a5f5f619f3,
            limb2: 0x205f0da4bc14e3a1
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
            limb0: 0x557cba7a33d675ee9456098a,
            limb1: 0xd1f2f430d3b700ae3df5bfbf,
            limb2: 0x1da59f01033f142d
        },
        r0a1: u288 {
            limb0: 0xbce7c0104d27c46bb75d0711,
            limb1: 0xc5e4eee55443cdddde9f35f2,
            limb2: 0x2a701ba4ba23fd1d
        },
        r1a0: u288 {
            limb0: 0x1d415efa053c86fc7014649d,
            limb1: 0xd7d220ce24fd7093d085d9cf,
            limb2: 0x2eff465f3107d9f
        },
        r1a1: u288 {
            limb0: 0xc722455dfecb1f555b4085a6,
            limb1: 0xd2f3858d79a25c6d6293e5bb,
            limb2: 0x15c7c7a0002876d1
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
            limb0: 0xa8c0af8a3de875a4ce864180,
            limb1: 0x51ab3744b52f25e6a15355d7,
            limb2: 0x191209fa1ea39564
        },
        r0a1: u288 {
            limb0: 0xfbbfc5dcbbc05f0a46943175,
            limb1: 0x40b0831251a64ec28d8ac018,
            limb2: 0x63b49d819c9cee0
        },
        r1a0: u288 {
            limb0: 0xed3281580625f441cfc902e9,
            limb1: 0x99abb183284962bba267b14a,
            limb2: 0x254becf8acd82872
        },
        r1a1: u288 {
            limb0: 0x3e2300901be969a6bb5e972d,
            limb1: 0xa7d443ed93087291df710da2,
            limb2: 0x1653ffe7b97ec2b1
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xab68c4ea81d4313ab1eb3f6b,
            limb1: 0xd640306d084d63ef7c964794,
            limb2: 0x2e4411b3d9ecc656
        },
        r0a1: u288 {
            limb0: 0x506c909dbc07cba20ca777fe,
            limb1: 0xb3e10fa2745dc22c1df2cf27,
            limb2: 0x21a5e7ebdb815814
        },
        r1a0: u288 {
            limb0: 0x11bdc8632978133db7ca9ade,
            limb1: 0x4b3e0ab5dbbb945ea61b6bbc,
            limb2: 0x1a7715d9803ee9bf
        },
        r1a1: u288 {
            limb0: 0x27a6fb59f3ac1f20fec0ffd4,
            limb1: 0xe754558fdbe2bebb4f7771e2,
            limb2: 0xc79a3990bfacdc8
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
            limb0: 0xb316c748a1f676e083c76485,
            limb1: 0x3a8ed028424c316be1f59a4b,
            limb2: 0x15f2b7e6f8c54858
        },
        r0a1: u288 {
            limb0: 0x3bc955f2ad10b9adf32d677c,
            limb1: 0x8a47ec7f708686dadc631a21,
            limb2: 0x29bc0b2d6ccf4024
        },
        r1a0: u288 {
            limb0: 0xb839799b3337ed5a79ed7207,
            limb1: 0x1663a9adce954d7a3a35c4ad,
            limb2: 0x1de272af312bc884
        },
        r1a1: u288 {
            limb0: 0x117a7c049e567f96a9f8cab3,
            limb1: 0x80fe2cfca9d10775e9e1a658,
            limb2: 0xbf2e7bf99528cff
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
            limb0: 0x42bb2ecdca17668127e1d4ba,
            limb1: 0x891370dae20d40012b2f3e5f,
            limb2: 0xedf818671fd148f
        },
        r0a1: u288 {
            limb0: 0xc3631c4e5233f53adb1a8a8e,
            limb1: 0x21b2d21f012d871e98ea2755,
            limb2: 0x227ccf2bdf26018c
        },
        r1a0: u288 {
            limb0: 0x164140c439971946f962875f,
            limb1: 0xc34d9fc7b4255a550a271ede,
            limb2: 0x49e8580659864b5
        },
        r1a1: u288 {
            limb0: 0x8e34fe07d4850893c7e99ec6,
            limb1: 0xe0896d269ce2e6d6b597cddb,
            limb2: 0x2c6d57b6452a85e8
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xa0243886291f58e3c7bac4a3,
            limb1: 0x66976ceced14af4984f33943,
            limb2: 0x234d5a99e8e1d6dd
        },
        r0a1: u288 {
            limb0: 0xae5b528bf74692b2c5d7542e,
            limb1: 0x19ae40478750c2087d3951b8,
            limb2: 0x2c63bd0d81eae3b
        },
        r1a0: u288 {
            limb0: 0xabf84832e40eb19b9f722202,
            limb1: 0xa2f05da53cf74b4dba3b4951,
            limb2: 0x11f028256598cfb
        },
        r1a1: u288 {
            limb0: 0x539497a5c83032869e8a91c6,
            limb1: 0x89cc5f801d97d69787d02f03,
            limb2: 0x12fc9732cf2f02a1
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
            limb0: 0xb2036c633fee2b68baaf23e9,
            limb1: 0x792fd7c36146659d3487f0b2,
            limb2: 0x24305fe026e2ad
        },
        r0a1: u288 {
            limb0: 0xebcf4aee00c417af2cf30d0c,
            limb1: 0x4caf0a5b8b567611b417a3dc,
            limb2: 0x2db065662a312b8c
        },
        r1a0: u288 {
            limb0: 0x2d8f8dc1889e46ce946cbba1,
            limb1: 0x3ac901f2c57cd5a0bf916e3c,
            limb2: 0x22f287e59b416661
        },
        r1a1: u288 {
            limb0: 0x6a837ae22b98f4e087ffcb32,
            limb1: 0x529e23078602686552d2cb57,
            limb2: 0xf1c658d9cce601d
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
            limb0: 0x79016bbf27881a283bf0736e,
            limb1: 0xec3598776205f01072a73110,
            limb2: 0x14c0f35fde7805eb
        },
        r0a1: u288 {
            limb0: 0xae2cb71b87cc105a43c4792c,
            limb1: 0xbf6141005dcb58b07a6769f9,
            limb2: 0x501c47c39b2b2b7
        },
        r1a0: u288 {
            limb0: 0xad2538720b5b1aca6bfa88e2,
            limb1: 0x1c9d1e4032c0fc245cd6fdb0,
            limb2: 0x158cdaf8426f720c
        },
        r1a1: u288 {
            limb0: 0x76c596927263ffc8bebb46df,
            limb1: 0xeca556c7875786cd236192c9,
            limb2: 0xe5f606e8df574c9
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
            limb0: 0x7ce7980362f238867d6edda8,
            limb1: 0xaeb9ee0253965ff4b663ed04,
            limb2: 0x1401a0123e6438f
        },
        r0a1: u288 {
            limb0: 0xd4c06ee78f42b0e43988b132,
            limb1: 0xbd55f8a532506b23b6db267f,
            limb2: 0x21f605086dc7858a
        },
        r1a0: u288 {
            limb0: 0x2e7b53cf3631f74e0cdca7eb,
            limb1: 0x8cf70de3bb58bfc91e185182,
            limb2: 0x1dd17af8189c38f0
        },
        r1a1: u288 {
            limb0: 0xf39dc54965e63b25bfbbc920,
            limb1: 0x8edfe2908be645ea46844016,
            limb2: 0x631b08afca1e141
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
            limb0: 0xd5948d89663886daef18d510,
            limb1: 0x93d544c7e78e3bb857c55f41,
            limb2: 0xa946e6ba83324a9
        },
        r0a1: u288 {
            limb0: 0x3a2a3c0dd6ced24cc87fa407,
            limb1: 0x5bfbb480d87393cd68a375f7,
            limb2: 0x1c9c3d1cf2e63b14
        },
        r1a0: u288 {
            limb0: 0x3331fb01f163a67a58cd8caf,
            limb1: 0xbfce25ef4892d7274ff82eff,
            limb2: 0x2df54bbcdc9a3cdd
        },
        r1a1: u288 {
            limb0: 0xdb21b96f21cebe24f17fbc7b,
            limb1: 0x8f59392339b408f26e187166,
            limb2: 0x25f0f5f89d591e41
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x188c7c2c7851db6f8e686947,
            limb1: 0x77816cbf818148d6736d446e,
            limb2: 0x11ee1b6f7ce26bc4
        },
        r0a1: u288 {
            limb0: 0x431fdc8fb2488ef2c38851b5,
            limb1: 0xf3be98716346f2e48f5ba38a,
            limb2: 0x732de6d75576b13
        },
        r1a0: u288 {
            limb0: 0x8694838626731a6f2745b43a,
            limb1: 0xaf6466d32b5ea7a137927f3f,
            limb2: 0x1a69e0eded1aa3d
        },
        r1a1: u288 {
            limb0: 0x85f86c64fb5ba798f65dfc61,
            limb1: 0x81f0720eb3585f25b6936862,
            limb2: 0x1b78621bd5050a2f
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
            limb0: 0xa9abec3745e504826cc7637d,
            limb1: 0x9748f8696a2043a514115e92,
            limb2: 0x244e0491f6f1f1b9
        },
        r0a1: u288 {
            limb0: 0x6f254086e0299ad3452b23ec,
            limb1: 0xcec0d87ba0f625fd25154526,
            limb2: 0x224a2457115830b7
        },
        r1a0: u288 {
            limb0: 0x7bc8f0b767dbfe5ad98135c2,
            limb1: 0x120c41d773f3d96e45b91ec1,
            limb2: 0x6e3f9ba6bea09eb
        },
        r1a1: u288 {
            limb0: 0x34c1c628da8d7515e726bee,
            limb1: 0x708b3e60a67679f2b429127d,
            limb2: 0x2ca8405a6f62d031
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
            limb0: 0x5e3106fdb15c8d6ce903a136,
            limb1: 0x71b0ede5666af5b913442551,
            limb2: 0xe3acd277e2b7546
        },
        r0a1: u288 {
            limb0: 0x6eafe707e97780b02dbf3b20,
            limb1: 0x5aa62ded59262d6b13c245bc,
            limb2: 0xb12b5485cecf33f
        },
        r1a0: u288 {
            limb0: 0x1434a69abc9651bfd337fc01,
            limb1: 0xcc5c16ca7541ac8e5d28117f,
            limb2: 0x2edcb79f1931bd3e
        },
        r1a1: u288 {
            limb0: 0xae6801b8c8d2e95c22adf398,
            limb1: 0xb4a4b0bcd7d3024c96e29ae8,
            limb2: 0x1f5b23acdb1026fb
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xaeab50dc3b35cc6fe494c6a2,
            limb1: 0x41c6bfbe835e2f7078cc1052,
            limb2: 0x2df0c939e8656864
        },
        r0a1: u288 {
            limb0: 0x9ffdba4ad660635b24ef1e79,
            limb1: 0xeba897c6d95c2a0092a1f4b8,
            limb2: 0x24e5837afd4ead80
        },
        r1a0: u288 {
            limb0: 0x72f4def9d5156faa98b312b9,
            limb1: 0x6ef365a74bc1c69a96c36a01,
            limb2: 0x1d8e6ea19a645fb9
        },
        r1a1: u288 {
            limb0: 0xdcd66510e5e462cf4a72cdd0,
            limb1: 0xbe1c0f5c9645ee80b263257f,
            limb2: 0x244da11abdfed96a
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
            limb0: 0xd8e3d966492d1f6357dea647,
            limb1: 0xc49af6f7fcb00be6803b694b,
            limb2: 0x25919065bd3cd576
        },
        r0a1: u288 {
            limb0: 0x2f01ae19373bae6efff1a3e4,
            limb1: 0xc32d2e6c3374e8619d9cd4dc,
            limb2: 0xca327c8f1c12d32
        },
        r1a0: u288 {
            limb0: 0xdff7e6be021d0a1724818f21,
            limb1: 0x944972741298e1a18eeccc60,
            limb2: 0x2d78fabfb0acc55f
        },
        r1a1: u288 {
            limb0: 0x31227224c67fc004a9effe18,
            limb1: 0x9a16b75922a5bcfb78d57749,
            limb2: 0x9ee7a25efd875d9
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
            limb0: 0xdf8837b3be4e740fd76bbdba,
            limb1: 0x5615bff197886850006fe033,
            limb2: 0x22c77be5e4cd0d1d
        },
        r0a1: u288 {
            limb0: 0xf810e39904e886f0ee0edc09,
            limb1: 0x923d6e906f1952cceff22b04,
            limb2: 0x2104423bbd343fd1
        },
        r1a0: u288 {
            limb0: 0x22daf463ee4bc5d5711185ac,
            limb1: 0xeaed55ad89fad9cba78a87f3,
            limb2: 0xf62fab6d529a168
        },
        r1a1: u288 {
            limb0: 0xa7fe1f080b40009c0794e6a2,
            limb1: 0x7d0a1d66d843895f94a6795f,
            limb2: 0x2371d1990511723e
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
            limb0: 0xb1092ee32be81a55da5a0749,
            limb1: 0xa6026bb585c0e6db0d50287d,
            limb2: 0x14e8dd92da58f1b4
        },
        r0a1: u288 {
            limb0: 0xeb2995b250eb31d2cbfc49a3,
            limb1: 0x947a71db2cdf58bda75151ac,
            limb2: 0x116543399b2a0b46
        },
        r1a0: u288 {
            limb0: 0x771e7e3e7b708a8b9c44801,
            limb1: 0xff0b9f0e7ee9c1b6b42658de,
            limb2: 0x128b993aa2c603ae
        },
        r1a1: u288 {
            limb0: 0x4351724371b397b7c420fd7e,
            limb1: 0x211e44def63da6f07421088a,
            limb2: 0x2894d132ddfa86ae
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x5fe6abd293e8302297a91dc0,
            limb1: 0x4e3aeff89456f2c776a1a5d,
            limb2: 0x16a71c3bb594ae4f
        },
        r0a1: u288 {
            limb0: 0xc8240fc1426aca6bac715b70,
            limb1: 0xd51d97bd661d886d1458842a,
            limb2: 0x10907758aa8d1536
        },
        r1a0: u288 {
            limb0: 0xd8ec8fb142c99e3a569c3ee9,
            limb1: 0xe27769250144f6d4a03c45f3,
            limb2: 0x1e9787fe695ec1ff
        },
        r1a1: u288 {
            limb0: 0xf0700a064c1c8b7fd3323645,
            limb1: 0xaec29d6ccf4ac89e7e62eb27,
            limb2: 0x8a786974f0ce59f
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
            limb0: 0xe885f3d163c28d87307587e6,
            limb1: 0xc62482fa714d80c95fbe67ef,
            limb2: 0x97e5fb5636f701d
        },
        r0a1: u288 {
            limb0: 0xf256179cee80d8ca2b3e41d5,
            limb1: 0x380703fdf486f892e37f0ad1,
            limb2: 0x1420c9a64610b24f
        },
        r1a0: u288 {
            limb0: 0x5cb73ade374c6d403bb1e8a3,
            limb1: 0x895c5b9130d39bf2d965a896,
            limb2: 0x286828ac15a2673a
        },
        r1a1: u288 {
            limb0: 0xff20d0d239ba64f1e586f1dd,
            limb1: 0xa415910bdb7da22ad30476c1,
            limb2: 0x1ddf25a5e6f46520
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
            limb0: 0xcf1ea0f8ac7d525564d3fea7,
            limb1: 0x33f48cded530d2cc314686ce,
            limb2: 0x2d4f5121b788c517
        },
        r0a1: u288 {
            limb0: 0xd4bf8560e5bd1513ebd85ade,
            limb1: 0x6832ca27dba4958e1c4db33e,
            limb2: 0x17592ee85533822b
        },
        r1a0: u288 {
            limb0: 0xaf7c4c8d4ac630f0d52c1a15,
            limb1: 0x5b0f64ec354f2a31a244aa78,
            limb2: 0x1ca59f81054cf5f3
        },
        r1a1: u288 {
            limb0: 0xafcf288b2d3fed7d28dc5be7,
            limb1: 0x942e34348515519c858051d0,
            limb2: 0x2be8b8b48386d22
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
            limb0: 0xd90cc6b18235ff5987f70398,
            limb1: 0x14d5b76c78ad55ddd07ac4a9,
            limb2: 0x300320a5a5c30ea6
        },
        r0a1: u288 {
            limb0: 0x5981f96816a3eda665f86b86,
            limb1: 0x8878fe1ff3b4059504e5eeb0,
            limb2: 0x28ba86f71b36cd6b
        },
        r1a0: u288 {
            limb0: 0xb5b32fdf1263c0cfcb9f10bb,
            limb1: 0x80b9f7dd472130a4fa7424c2,
            limb2: 0x443bb62f5a2ab6
        },
        r1a1: u288 {
            limb0: 0xa81cf0bfa870a316d72e7eb5,
            limb1: 0x323ee025b2795f282f2902bd,
            limb2: 0x1307ea9752b40164
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
            limb0: 0xc3c4cd73f8fbd4e9c8381b0d,
            limb1: 0xec5e60b146b76a6a9028b818,
            limb2: 0x5772b33b6e96fcc
        },
        r0a1: u288 {
            limb0: 0xb2165bc7c18f8ea5d179589f,
            limb1: 0x7f417cc130b3164b0976bfd9,
            limb2: 0x24025dce14ce0b9b
        },
        r1a0: u288 {
            limb0: 0x162cbe2fd340a04725e98af6,
            limb1: 0x7664434d40bd5731a0d007d6,
            limb2: 0x2334bb216a48e748
        },
        r1a1: u288 {
            limb0: 0x8c55fc9070d50a0027e8afc7,
            limb1: 0x6dec5c512b05a329dd8d7fe5,
            limb2: 0x10032ce82e29972
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xe0df864f2b0b0c070a06c824,
            limb1: 0xd6e693907e799ae01cca8a65,
            limb2: 0x29b33b110f39aa89
        },
        r0a1: u288 {
            limb0: 0x9a4e312a6e2efdf825c3ce19,
            limb1: 0x90b95e56b8f61ffc628d5bc8,
            limb2: 0x17eddbb65d80bd86
        },
        r1a0: u288 {
            limb0: 0x1be7febc9337600e28daff1d,
            limb1: 0x92ecd881341ab1221ae11958,
            limb2: 0x30148b10a220fc0e
        },
        r1a1: u288 {
            limb0: 0xc523e33363c43d2f92407250,
            limb1: 0xf8d8bb041307144271c22564,
            limb2: 0x2c387a72bb23fa48
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
            limb0: 0xc5f653bcb135f5e8138eee53,
            limb1: 0xed88ead13cffc085246909b8,
            limb2: 0x2d693a7bd9561975
        },
        r0a1: u288 {
            limb0: 0x5735fadee731c1e166dee8a1,
            limb1: 0x95a4d295c86a1c633e493462,
            limb2: 0x2a9f05f670a1777a
        },
        r1a0: u288 {
            limb0: 0xab9d15a6ec2bca8919a445c9,
            limb1: 0x3a0a27264b9eaf5c9ed9ab4f,
            limb2: 0x2d7d1d3e3ea2d1bd
        },
        r1a1: u288 {
            limb0: 0x34ed2324ed4ed80f9dd1f3b7,
            limb1: 0x67bba49bfa4065dace836076,
            limb2: 0x155e33547834f7ac
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
            limb0: 0xf45f18d0e39304e905934539,
            limb1: 0x5b9b73bad880f8c37934b45d,
            limb2: 0x1ac3e4d510e1f4ff
        },
        r0a1: u288 {
            limb0: 0x67638a22583b61194db9953,
            limb1: 0x1bded9c61697fe4fa357bfc1,
            limb2: 0xffc08b36c1b41c8
        },
        r1a0: u288 {
            limb0: 0x6fc9caa66e7139bb50281a26,
            limb1: 0x119a013f9b15d522345cb741,
            limb2: 0x2f0085f1ed034a40
        },
        r1a1: u288 {
            limb0: 0x66a6a3d11d259d75e04ed3e4,
            limb1: 0xefd471f58ab3bdbf34ee9668,
            limb2: 0x15dcb9c56f7f37ea
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
            limb0: 0xf8b8ac758d32f202c32b342f,
            limb1: 0x79313b4ba6de101c2bcaaae,
            limb2: 0x1f2e428405187213
        },
        r0a1: u288 {
            limb0: 0xdec34b55dec033073993bd71,
            limb1: 0x50bd277a2df9ab3b8022166b,
            limb2: 0x29b516b63c0781ab
        },
        r1a0: u288 {
            limb0: 0xb1a705c702157c0fae46d76c,
            limb1: 0x4f860085977e5cb2a92a1e68,
            limb2: 0x12479b98c6d063ff
        },
        r1a1: u288 {
            limb0: 0xd3e98a0440987f62ecd04420,
            limb1: 0x654f9d7123bd9def43de395,
            limb2: 0x6bfae19a3a81104
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
            limb0: 0xfe3c8140317178c005b197a1,
            limb1: 0x3ea125e1927a9bf6346f85e6,
            limb2: 0x29c76783fff50579
        },
        r0a1: u288 {
            limb0: 0x39dad2afa2a24f49a884c884,
            limb1: 0x8d95836ebb0d20460efa4898,
            limb2: 0xa48178bd9c2ebb4
        },
        r1a0: u288 {
            limb0: 0x278ffa068aececa689cf913e,
            limb1: 0x3a0fd535df6e5ec05940a9cb,
            limb2: 0x2d79e4cca792c3f3
        },
        r1a1: u288 {
            limb0: 0xd068db58a5c0a0265619c810,
            limb1: 0x33035652c101090104db05ea,
            limb2: 0x27af7ca0e7440899
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xc697020eaf7664586ea77bdf,
            limb1: 0x6410ad8eb2f1f5d8fcc7b750,
            limb2: 0x232ef156817a08ba
        },
        r0a1: u288 {
            limb0: 0x1fe2959cddb2daaeb6154802,
            limb1: 0xfc72bc619692b37c81b632ff,
            limb2: 0xceebf3c502d04dc
        },
        r1a0: u288 {
            limb0: 0xba1fc9e2cd52c529b5368a5,
            limb1: 0x95ef41d8d5c91d7262ee40a8,
            limb2: 0x18c21d4ee1dfb0b4
        },
        r1a1: u288 {
            limb0: 0xa86c55140ed70e7f5f75cd59,
            limb1: 0xe986d21f58eb0ca61f3fae39,
            limb2: 0x2378a3679200655a
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
            limb0: 0x48832d674f843bc4162a0dea,
            limb1: 0x174c0d9367e80ea6c1200159,
            limb2: 0x16cce43302881c5d
        },
        r0a1: u288 {
            limb0: 0x475e04f9ca7c403c1cfd2baf,
            limb1: 0x771cc06d9ba78d03422562b1,
            limb2: 0x1fabb26f2e25f1c4
        },
        r1a0: u288 {
            limb0: 0x75cf96241189e790861bc80f,
            limb1: 0x787666be9ba6f55c7d1ce1a0,
            limb2: 0x13076eef3d675b79
        },
        r1a1: u288 {
            limb0: 0x744d46ea59a1911f3bbd8574,
            limb1: 0xf5942d963dcf74dc40a008c7,
            limb2: 0x2b2808aad4fa1b3f
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
            limb0: 0xc09c77026ab76e4ea9157a83,
            limb1: 0xcd8920f0c1e74f5f8352fad0,
            limb2: 0x3b4a37bf6815339
        },
        r0a1: u288 {
            limb0: 0xdc9380ff327c824d7cf27a66,
            limb1: 0x2a53501a5d5ad3a611857ebf,
            limb2: 0xadbccb61b59ed75
        },
        r1a0: u288 {
            limb0: 0xffaf5d4412efbcc075bd50d8,
            limb1: 0x68641d6cfe9803d117da111c,
            limb2: 0x1410e4357425963d
        },
        r1a1: u288 {
            limb0: 0x2846c7a852e3c6c2d86ed79e,
            limb1: 0x3bf30e46eb69faf3b8907448,
            limb2: 0x131b99484980b460
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xb3e37b26672b5718200b66e5,
            limb1: 0xaeda42481925c262cdb9772a,
            limb2: 0x2555dd654364c27a
        },
        r0a1: u288 {
            limb0: 0xb055481e2cb5fe6c6a05c520,
            limb1: 0x601cef1d0e180725baafbacc,
            limb2: 0x22ad2f9c9f43b1d9
        },
        r1a0: u288 {
            limb0: 0x4fe1692092081098665e3321,
            limb1: 0xb109f6d279f6412eaf25dab3,
            limb2: 0x21d7cc71da87f6
        },
        r1a1: u288 {
            limb0: 0x1a72e95326d67fe60d79fa1,
            limb1: 0x5ea95c8e4133d031d2099219,
            limb2: 0x4203dba50d239e1
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
            limb0: 0xa146faf873477d5473275a43,
            limb1: 0x6c82867f99dbcdacb17839ef,
            limb2: 0x1afeef6a50fb2a55
        },
        r0a1: u288 {
            limb0: 0x21000f35aaadbb448bce213e,
            limb1: 0x88d0aaaf9a62f3c121994256,
            limb2: 0x1d57591f3b7dc1c6
        },
        r1a0: u288 {
            limb0: 0x1b7d83a686ffa288bc2ad1f0,
            limb1: 0xd62a73be3134035a563bb4c2,
            limb2: 0x127af25b5c698915
        },
        r1a1: u288 {
            limb0: 0x11e63e91810874d509daee2a,
            limb1: 0xdfa4f168a6cf8451c6263ab0,
            limb2: 0x132c8b7f50963afb
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0xfe512db490ff407730046eb0,
            limb1: 0xab2e8dbe632410410458934f,
            limb2: 0x1497c5b5f2fc025
        },
        r0a1: u288 {
            limb0: 0x38ee387bbc0e0c7fdaeb7ddf,
            limb1: 0x97db68d124c080324169963b,
            limb2: 0xb5ea34ed7597af5
        },
        r1a0: u288 {
            limb0: 0x7ed1570cff1a1b503241f3f9,
            limb1: 0x1d54bb82ca9b101afeabd3bc,
            limb2: 0x2e7e0273dc382e56
        },
        r1a1: u288 {
            limb0: 0x63aeaab508cedc2e5d664985,
            limb1: 0xde0df2a222e9d231a6b93788,
            limb2: 0x17e05e8b2b7eb732
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
            limb0: 0x9da13c48ce82504d29b84249,
            limb1: 0xaa742908b7472e14dd1f11ac,
            limb2: 0x25efa0be6322c120
        },
        r0a1: u288 {
            limb0: 0x74feed817781bdc6570aef54,
            limb1: 0xf1dc6415080e6c9fc19c0740,
            limb2: 0x2cb57a260be2f25e
        },
        r1a0: u288 {
            limb0: 0x42ab76d434cafe4ea5a2bf8c,
            limb1: 0x8b5c411ce6c7f242038b2910,
            limb2: 0x2c42638b05972343
        },
        r1a1: u288 {
            limb0: 0xf30cae1407a39b4d9cd0e46a,
            limb1: 0x4b79222c0093dfc415955c77,
            limb2: 0xfffbf677fa8a3a9
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
            limb0: 0x399c56afc63dbd3780156645,
            limb1: 0x52555d3d72e47a96af7c5ab3,
            limb2: 0x2856f0dd43ff5146
        },
        r0a1: u288 {
            limb0: 0x8973a906f768847a74f23aaf,
            limb1: 0xc3371a5681e04c0e02b92f89,
            limb2: 0x1db70bcb4ca32a4d
        },
        r1a0: u288 {
            limb0: 0xe4313faf8f1c28f947baa709,
            limb1: 0x7780635d4757ecc13387d6f8,
            limb2: 0x16bc35c0ff2219a9
        },
        r1a1: u288 {
            limb0: 0x996ce19fda99ddd35e657f8d,
            limb1: 0xdbe023800348f1fc8b0e7c1f,
            limb2: 0x186818b9f5c2c6db
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
            limb0: 0xb85de02b3a880b2bfa966c89,
            limb1: 0xbbe8b415d4316f61018a765,
            limb2: 0x4f68083b269dbfb
        },
        r0a1: u288 {
            limb0: 0x53c785721488e9ac02b8ce56,
            limb1: 0x183c9a5f798c3f0df1078fd4,
            limb2: 0x1b5d19276491969a
        },
        r1a0: u288 {
            limb0: 0x31567a417677daed2d328f93,
            limb1: 0xbcefc5c52d867c6fab8aab5b,
            limb2: 0xd7bff9e2846747e
        },
        r1a1: u288 {
            limb0: 0x44a2f66c2aedbf9c02d25d58,
            limb1: 0xbe849c105b319af71e60b764,
            limb2: 0x28f10539c92bd7f
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
            limb0: 0xf8a8e1aa8303bcb70990014,
            limb1: 0x9a4e8b705cd16e8946e49bcc,
            limb2: 0x17c4cecdbf19cd8b
        },
        r0a1: u288 {
            limb0: 0x8a176f9201e728ea4c9c1cbd,
            limb1: 0x9cb6c6c7266118e52fb3c2da,
            limb2: 0x141fe9da18b67ba9
        },
        r1a0: u288 {
            limb0: 0x606c8dc1f25d70dac0f9ff0d,
            limb1: 0xfbc815f3f575b31df6b10b98,
            limb2: 0x180091b25f5a584f
        },
        r1a1: u288 {
            limb0: 0x63946b1126d51bda4fd77927,
            limb1: 0x99e7ba900f632b07576e1444,
            limb2: 0x22abd643830fb3cb
        }
    },
    G2Line {
        r0a0: u288 {
            limb0: 0x90fd57d90aaf8b1172dc2b5b,
            limb1: 0xcffe90542dd59bc0ce9d0904,
            limb2: 0x19274db6e7e20575
        },
        r0a1: u288 {
            limb0: 0x42924539fadb31c6fcfa30b8,
            limb1: 0xa42de18e1b20b0a1e0f3862a,
            limb2: 0x2a2a7f749a31470
        },
        r1a0: u288 {
            limb0: 0x1ce53a08e7a77bf4955f7e1e,
            limb1: 0xc6a69e9e2bf7ecd665018370,
            limb2: 0x1bf8b395db045406
        },
        r1a1: u288 {
            limb0: 0xf8747b9768a96d81d5b6480,
            limb1: 0x455471cf49d8ae4e83751904,
            limb2: 0x20ff8e62c455c13d
        }
    },
];

