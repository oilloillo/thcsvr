--
Elf={}
local ElfGlobalAttr = {}
ElfGlobalAttr[0] = 0
ElfGlobalAttr[1] = 0
function Elf.GetElfAttr(tp)
	return ElfGlobalAttr[tp]
end
function Elf.SetElfAttr(tp,attr)
	ElfGlobalAttr[tp] = attr
end
