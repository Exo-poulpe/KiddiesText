VBoxManage.exe setextradata "Windows 10" "VBoxInternal/Devices/pcbios/0/Config/DmiSystemVendor" "Dell"
VBoxManage.exe setextradata "Windows 10" "VBoxInternal/Devices/pcbios/0/Config/DmiSystemProduct" "OptiPlex 3070-1MJT3 MFF"

vboxmanage setextradata "Windows 10" VBoxInternal/CPUM/HostCPUID/80000002/eax 0x20202020
vboxmanage setextradata "Windows 10" VBoxInternal/CPUM/HostCPUID/80000002/ebx 0x65746e49
vboxmanage setextradata "Windows 10" VBoxInternal/CPUM/HostCPUID/80000002/ecx 0x2952286c
vboxmanage setextradata "Windows 10" VBoxInternal/CPUM/HostCPUID/80000002/edx 0x726f4320
vboxmanage setextradata "Windows 10" VBoxInternal/CPUM/HostCPUID/80000003/eax 0x4d542865
vboxmanage setextradata "Windows 10" VBoxInternal/CPUM/HostCPUID/80000003/ebx 0x50432029
vboxmanage setextradata "Windows 10" VBoxInternal/CPUM/HostCPUID/80000003/ecx 0x33692055
vboxmanage setextradata "Windows 10" VBoxInternal/CPUM/HostCPUID/80000003/edx 0x3037382d
vboxmanage setextradata "Windows 10" VBoxInternal/CPUM/HostCPUID/80000004/eax 0x20543130
vboxmanage setextradata "Windows 10" VBoxInternal/CPUM/HostCPUID/80000004/ebx 0x2e322040
vboxmanage setextradata "Windows 10" VBoxInternal/CPUM/HostCPUID/80000004/ecx 0x47203034
vboxmanage setextradata "Windows 10" VBoxInternal/CPUM/HostCPUID/80000004/edx 0x20207a48

# Name CPU to <Intel(R) Core(TM) CPU i3-87001T @ 2.40 GHz>

pause