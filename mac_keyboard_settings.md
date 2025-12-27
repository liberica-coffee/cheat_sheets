

\ キーが無効の問題への解決案：

in the terminal:



```
$ hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000064, "HIDKeyboardModifierMappingDst":0x700000031}]}'
Attempt to remap alphanumerics / special characters. If setting fails, ensure Terminal has input monitoring permissions.
UserKeyMapping:(
        {
        HIDKeyboardModifierMappingDst = 30064771121;
        HIDKeyboardModifierMappingSrc = 30064771172;
    }
)
```
