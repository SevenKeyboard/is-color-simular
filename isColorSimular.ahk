;==============================================================
; isColorSimular — Compares two ARGB colors within configurable alpha/RGB variation thresholds
;
; GitHub: https://github.com/SevenKeyboard/is-color-simular
; Author: SevenKeyboard Ltd. (2026)
; License: The Unlicense
;==============================================================

/*
Example Usage:
    #Requires AutoHotkey v2.0
    #SingleInstance Force
    msgBox isColorSimular(0xF7F7F7,0xF7F7F7)          ; 1
    msgBox isColorSimular(0xF7F7F7,0xF5F5F5,,0x01)    ; 0
    msgBox isColorSimular(0xF7F7F7,0xF5F5F5,,0x02)    ; 1
    msgBox isColorSimular(0xF7F7F7,0xF5F9F6,,0x02)    ; 1
    msgBox isColorSimular(0xF7F7F7,0xF2F3F4,,0x05,0x04,0x03)    ; 1
    msgBox isColorSimular(0xF7F7F7,0xF2F3F4,,0x03,0x03,0x03)    ; 0

    msgBox isColorSimular(0x88F7F7F7,0x88F7F7F7)          ;  1
    msgBox isColorSimular(0x88F7F7F7,0x83F7F7F7,0x04)     ;  0
    msgBox isColorSimular(0x88F7F7F7,0x83F7F7F7,0x05)     ;  1

    msgBox isColorSimular(0x88F7F7F7,0x87F5F4F3,0x01,0x02,0x03,0x04) ;  1
    msgBox isColorSimular(0x88F7F7F7,0x87F5F4F3,0x01,0x04) ;  1
    msgBox isColorSimular(0x88F7F7F7,0x87F5F4F3,0x01,0x03) ;  0
*/

class VersionManager_isColorSimular
{
    static _ := this._init()
    static _init()    {
        global
        ISCOLORSIMULAR_VERSION := "1.0.0"
    }
}
isColorSimular(argb1, argb2, alphaVariation:=0, rgbVariation*)    {
    c:=Map(1,"", 2,"")
    va:=Map("a",format("{:d}",alphaVariation), "r","", "g","", "b","")
    ;--------------------------------
    Loop 2    {
        i:=A_Index
        c[i]:=Map("a","", "r","", "g","", "b","")
        switch (strLen(_hex:=format("{:06X}",argb%i%)))
        {
            default:        return false
            case 6,7,8:
        }
        c[i]["b"]:=format("{:d}","0x" subStr(_hex,-2))
        c[i]["g"]:=format("{:d}","0x" subStr(_hex,-4,2))
        c[i]["r"]:=format("{:d}","0x" subStr(_hex,-6,2))
        _ahex:=(regExMatch(_hex,"D)([a-fA-F0-9]{1,2})[a-fA-F0-9]{6}$",&_)?_[1]:"")
        if (_ahex=="")
            c[i]["a"]:=format("{:d}",0xFF)
        else
            c[i]["a"]:=format("{:d}","0x" _ahex)
        for _,n in c[i]    {
            if !(0x00<=n && n<=0xFF)
                return false
        }
    }
    switch (rgbVariation.length)
    {
        default:        return false
        case 0:        va["r"]:= va["g"]:= va["b"]:= 0
        case 1:         va["r"]:= va["g"]:= va["b"]:= rgbVariation[1]
        case 3:
            for i,n in rgbVariation
                va[(i==1?"r":i==2?"g":"b")]:=n
    }
    for _,n in va    {
        if !(0x00<=n && n<=0xFF)
            return false
    }
    ;--------------------------------
    /*
    msgBox format("{:02X}",c[1]["a"]) "`t" format("{:02X}",c[1]["r"]) "`t" format("{:02X}",c[1]["g"]) "`t" format("{:02X}",c[1]["b"])
        . "`n" format("{:02X}",c[2]["a"]) "`t" format("{:02X}",c[2]["r"]) "`t" format("{:02X}",c[2]["g"]) "`t" format("{:02X}",c[2]["b"])
        . "`n"
        . "`n" format("{:02X}",va["a"]) "`t" format("{:02X}",va["r"]) "`t" format("{:02X}",va["g"]) "`t" format("{:02X}",va["b"])
    */
    bRet:=true
    for _,m in ["a","r","g","b"]    {
        _diff:=abs(c[1][m]-c[2][m])
        if (_diff<=va[m])
            continue
        bRet:=false
        break
    }
    return bRet
}